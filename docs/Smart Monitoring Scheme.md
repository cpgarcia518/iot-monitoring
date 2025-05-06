# LoRaWAN Environmental Monitoring with InfluxDB & Grafana

This project outlines an optimal architecture for routing environmental and network telemetry data from a LoRaWAN-based IoT deployment into InfluxDB using Telegraf, and visualizing it in Grafana. The system is designed to scale across multiple dairy cattle farms and greenhouses.

## 1. Measurement Layout

| Measurement name  | Contents                                                                               | Purpose                                  |
|-------------------|----------------------------------------------------------------------------------------|------------------------------------------|
| **sensor_data**   | Temperature, humidity, pressure, luminosity, CO₂, NH₃, wind_speed, …                   | Raw environmental readings from each node. |
| **lora_uplink**   | RSSI, SNR, spreading_factor, data_rate, frequency, f_cnt                               | Per-uplink radio/LoRa network metadata.  |
| **gateway_stats** | rx_packets, tx_packets, join_requests, errors, uptime                                   | Periodic (e.g., every minute) gateway health. |

## 2. Tags vs. Fields

### Tags  
Use tags for anything you’re likely to filter/group on, and that has low cardinality:

- `site`: farm1, farm2, greenhouse1, greenhouse2  
- `site_type`: dairy_farm or greenhouse  
- `node_id`: device EUI or logical node name (e.g., node-A12)  
- `gateway_id`: gateway EUI or name (e.g., gw-southbarn)  
- `sensor_type` (optional): e.g., temp, hum  
- `sensor_location` (optional): barn, field section, bench number, etc.  

### Fields  
Numeric, string, or boolean values. Examples:

- **sensor_data**  
  - `temperature` (float, °C)  
  - `humidity` (float, %RH)  
  - `pressure` (float, hPa)  
  - `luminosity` (float, lux)  
  - `co2` (float, ppm)  
  - `ammonia` (float, ppm)  
  - `wind_speed` (float, m/s)  

- **lora_uplink**  
  - `rssi` (float, dBm)  
  - `snr` (float, dB)  
  - `spreading_factor` (integer)  
  - `data_rate` (string, e.g. "SF10BW125")  
  - `frequency` (float, MHz)  
  - `f_cnt` (integer)  

- **gateway_stats**  
  - `rx_packets` (int)  
  - `tx_packets` (int)  
  - `join_requests` (int)  
  - `errors` (int)  
  - `uptime` (int, seconds)  

## 3. Example InfluxDB Line Protocol

```plaintext
sensor_data,site=farm1,site_type=dairy_farm,node_id=A12 temperature=22.5,humidity=57.2,pressure=1013.1,luminosity=350.0,co2=820.3,ammonia=0.12 1683302400000000000

lora_uplink,site=farm1,node_id=A12,gateway_id=gw-southbarn rssi=-92.5,snr=7.2,spreading_factor=10,data_rate="SF10BW125",frequency=868.3,f_cnt=1024 1683302400000000000

gateway_stats,site=greenhouse2,gateway_id=gw-eastbench rx_packets=342,tx_packets=338,join_requests=5,errors=0,uptime=86400 1683302400000000000
```

## 4. Telegraf MQTT → InfluxDB Configuration

```toml
[[inputs.mqtt_consumer]]
  servers = ["tcp://mqtt.example.com:1883"]
  topics = [
    "application/+/device/+/event/up",
    "gateway/+/stats"
  ]
  data_format = "json"
  json_name_key = "measurement"
  tag_keys = [
    "site",
    "site_type",
    "node_id",
    "gateway_id",
    "sensor_type",
    "sensor_location"
  ]
  field_keys = [
    "temperature",
    "humidity",
    "pressure",
    "luminosity",
    "co2",
    "ammonia",
    "wind_speed",
    "rssi",
    "snr",
    "spreading_factor",
    "data_rate",
    "frequency",
    "f_cnt",
    "rx_packets",
    "tx_packets",
    "join_requests",
    "errors",
    "uptime"
  ]
```

## 5. Scaling & Retention

- **Retention Policies**  
  - `rp_raw`: retain raw data for 30 days.  
  - `rp_monthly`: retain hourly-aggregated data for 1 year.  

- **Continuous Query Example**  
```sql
CREATE CONTINUOUS QUERY cq_1h ON yourdb
BEGIN
  SELECT mean(temperature) AS avg_temp,
         max(rssi)         AS max_rssi
  INTO yourdb.rp_monthly.sensor_data
  FROM yourdb.rp_raw.sensor_data
  GROUP BY time(1h), site, node_id;
END
```

## Why This Works

1. **Low cardinality**: Filters on `site`, `site_type`, and `node_id` keep tag sets small.  
2. **Flexible querying**: A single `sensor_data` measurement covers all physical variables.  
3. **Separation of concerns**: Sensor data, network metadata, and gateway health are in separate measurements for targeted retention and downsampling.  
4. **Future-proof**: Adding new farms, greenhouses, sensors, or gateways only requires new tag values or field keys.

---

