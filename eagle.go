package main

import (
	"encoding/json"
	"encoding/xml"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"os"
	"time"

	owm "github.com/briandowns/openweathermap"
	rfc "github.com/tommessick/rainforestCommon"
	"github.com/ziutek/rrd"
)

type LocalCommand struct {
	XMLName   xml.Name `xml:"LocalCommand"`
	Name      string   `xml:"Name"`
	MacId     string
	StartTime string
	EndTime   string
	Frequency string
}

type Command struct {
	XMLName xml.Name `xml:"Command"`
	Name    string
}

type Reboot struct {
	XMLName xml.Name `xml:"Command"`
	Name    string
	MacId   string
	Target  string
}

type Any struct {
	XMLName xml.Name
	Text    string
}

type logReader struct {
	r io.Reader
}
type logWriter struct {
	w io.Writer
}

// TODO: parameter or config
const IPaddr = "192.168.1.39:5002"
const City = "SANTA CLARITA"
const evseAddr = "192.168.1.144"

// How often to read the time
// Less than 5 seconds will cause timeouts
// More than 1 minute will miss rrd intervals
// when the XML reader hangs
var period = 1 * time.Minute

// When to get weather data
var nextTemperature time.Time

// The weather data
var weather *owm.CurrentWeatherData

// http get from addr/status returns this
//{
//    "mode": "STA",
//    "wifi_client_connected": 1,
//    "eth_connected": 0,
//    "net_connected": 1,
//    "ipaddress": "192.168.1.144",
//    "emoncms_connected": 0,
//    "packets_sent": 0,
//    "packets_success": 0,
//    "mqtt_connected": 0,
//    "ohm_hour": "NotConnected",
//    "free_heap": 216088,
//    "comm_sent": 220969,
//    "comm_success": 220951,
//    "rapi_connected": 1,
//    "evse_connected": 1,
//    "amp": 11880,
//    "voltage": 120,
//    "pilot": 12,
//    "wh": 0,
//    "temp": 298,
//    "temp1": false,
//    "temp2": 298,
//    "temp3": false,
//    "temp4": 415,
//    "state": 3,
//    "vehicle": 1,
//    "colour": 6,
//    "manual_override": 0,
//    "freeram": 216088,
//    "divertmode": 1,
//    "srssi": -68,
//    "elapsed": 46085,
//    "wattsec": 65576480,
//    "watthour": 0,
//    "gfcicount": 0,
//    "nogndcount": 1,
//    "stuckcount": 0,
//    "solar": 0,
//    "grid_ie": 0,
//    "charge_rate": 0,
//    "divert_update": 55386,
//    "ota_update": 0,
//    "time": "2021-08-21T17:37:51Z",
//    "offset": "-0800"
//    }

// Add any fields that you need and capitalize the first letter
type EvseData struct {
	Amp int
}

func readEvse(addr string) (int, error) {
	var e EvseData

	resp, err := http.Get("http://" + addr + "/status")
	if err != nil {
		return 0, err
	}

	defer resp.Body.Close()

	s, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return 0, err
	}

	err = json.Unmarshal([]byte(s), &e)

	return e.Amp, nil

}

func (r *logReader) Read(p []byte) (n int, err error) {
	n, err = r.r.Read(p)
	//	fmt.Printf("%s", p)
	return
}

func (w *logWriter) Write(p []byte) (n int, err error) {
	n, err = w.w.Write(p)
	//	fmt.Printf("%s", p)
	return
}

func transaction(addr string, command *LocalCommand) ([]byte, error) {
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		return nil, err
	}
	defer conn.Close()

	xmlReader := new(logReader)
	xmlReader.r = io.Reader(conn)
	xmlWriter := new(logWriter)
	xmlWriter.w = io.Writer(conn)
	enc := xml.NewEncoder(xmlWriter)
	enc.Indent("  ", "      ")

	if err := enc.Encode(command); err != nil {
		return nil, err
	}
	fmt.Fprintf(conn, "\n")

	b, err := ioutil.ReadAll(xmlReader)

	if err != nil {
		return nil, err
	}
	err = checkXML(b)
	if err != nil {
		return nil, err
	}

	return b, nil

}
func sendReboot(addr string, command *Reboot) ([]byte, error) {
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		return nil, err
	}
	defer conn.Close()

	xmlReader := new(logReader)
	xmlReader.r = io.Reader(conn)
	xmlWriter := new(logWriter)
	xmlWriter.w = io.Writer(conn)
	enc := xml.NewEncoder(xmlWriter)
	enc.Indent("  ", "      ")

	if err := enc.Encode(command); err != nil {
		return nil, err
	}
	fmt.Fprintf(conn, "\n")

	b, err := ioutil.ReadAll(xmlReader)

	if err != nil {
		return nil, err
	}
	err = checkXML(b)
	if err != nil {
		return nil, err
	}

	return b, nil

}

func main() {
	var err error
	// The readall used to get the XML from the eagle sometimes hangs after 100 or
	// 10000 times working.  I have a watchdog that kills the program when that happens
	// Write to the log file to track restarts

	f, err := os.OpenFile("Start.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening log file: %v", err)
	}

	log.SetOutput(f)
	log.Println("Restarting")
	f.Close()

	log.SetOutput(os.Stderr)

	eagleMac, err := getOurMac()
	if err != nil {
		log.Fatal(err)
	}

	weather, err = owm.NewCurrent("F", "EN")
	weather.CurrentByName(City)
	nextTemperature = time.Now().Add(5 * time.Minute)
	_, err = getDemand(eagleMac)
	if err != nil {
		log.Fatal(err)
	}
}

func checkXML(data []byte) error {
	var a Any
	err := xml.Unmarshal(data, &a)
	if err != nil {
		return err
	}

	if a.XMLName.Local == "Error" {
		return errors.New(a.Text)
	}
	return nil
}

func getOurMac() (string, error) {
	var q rfc.DeviceInfo

	b, err := transaction(IPaddr, &LocalCommand{Name: "list_devices"})
	if err != nil {
		return "", err
	}
	err = xml.Unmarshal(b, &q)
	if err != nil {
		return "", err
	}

	return q.DeviceMacId, nil
}

func getMeterMac(mac string) (string, error) {
	var q rfc.HistoryData

	// Meter time is 30 years smaller than Unix time
	// Subtract another hour of seconds (3600) to get some history
	t := rfc.MeterTime(time.Now()).Unix() - 3600
	b, err := transaction(IPaddr, &LocalCommand{Name: "get_history_data",
		MacId:     mac,
		StartTime: fmt.Sprintf("0x%x", t),
		EndTime:   fmt.Sprintf("0x%x", t+3600),
		Frequency: "0x0001"})
	//b, err := transaction(IPaddr, &LocalCommand{Name: "get_history_data", MacId: mac, StartTime: fmt.Sprintf("0x%x", t)})
	if err != nil {
		return "", err
	}
	err = xml.Unmarshal(b, &q)
	if err != nil {
		return "", err
	}

	return q.SummationList[0].MeterMacId, nil
}

func getDemand(mac string) (demand float32, err error) {
	var q rfc.InstantaneousDemand

	u := rrd.NewUpdater("powertemp.rrd")

	timeSave := time.Unix(0, 0)
	ticker := time.NewTicker(period)
	quit := make(chan struct{})
	loop := 0
	watch := 1
	go func() {
		for {
			loop += 1
			select {
			case <-ticker.C:
				b, err := transaction(IPaddr, &LocalCommand{Name: "get_instantaneous_demand", MacId: mac})
				if err != nil {
					fmt.Println(err)
					return
				}

				err = xml.Unmarshal(b, &q)
				if err != nil {
					fmt.Println(err)
					return
				}

				if q.TimeStamp == "0x00000000" {
					fmt.Println("Meter reads zero time")
					fmt.Println("Demand = ", q.Demand)
					return
				}

				// do stuff
				newTime, err := rfc.UnixTime(q.TimeStamp)
				//fmt.Println("Time from meter", q.TimeStamp)
				if err != nil {
					fmt.Println(err)
					return
				}
				if timeSave != newTime {
					timeSave = newTime
					// Sometimes the time read from the meter gets stuck
					// Don't reset the watchdog unless time is moving forward
					// fmt.Println("Watchdog = ", watch)
					watch++
					demand, err := rfc.CalcVal(q.Demand, q.Multiplier, q.Divisor)
					if err != nil {
						fmt.Println(err)
						return
					}
					if time.Now().After(nextTemperature) {
						// It's a free online server
						// Don't need to ask for temp every time
						nextTemperature = time.Now().Add(5 * time.Minute)
						fmt.Println("get temp")
						weather.CurrentByName(City)
					}

					ma, err := readEvse(evseAddr)
					// assume 115 volts
					// converting milliwats to kilowatts
					evKw := float64(ma) * 115.0 / 1000000.0
					fmt.Println(ma, evKw)

					fmt.Println(newTime, time.Since(newTime), demand, evKw, weather.Main.Temp)
					err = u.Update(newTime, demand, weather.Main.Temp, evKw)
					if err != nil {
						fmt.Println(err)
						return
					}

				} else {
					fmt.Println("Time is not moving forward")
				}
			case <-quit:
				fmt.Println("quit")
				ticker.Stop()
				return
			}
		}
	}()

	for {
		time.Sleep(3 * period)

		if watch == 0 {
			// The readall sometimes hangs
			// Die and let the program restart
			// TODO clean this up
			b, err := sendReboot(IPaddr, &Reboot{Name: "reboot", MacId: mac, Target: "All"})
			if err != nil {
				return 0.0, err
			}
			err = xml.Unmarshal(b, &q)
			if err != nil {
				log.Println(err)
			}
			log.Fatal("watchdog expired")
		}
		watch = 0
	}
	return rfc.CalcVal(q.Demand, q.Multiplier, q.Divisor)
}
