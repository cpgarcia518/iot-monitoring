# IoT LoRaWAN Monitoring System - InfluxDB Schema

## Database Structure

### Primary Measurements

#### 1. `sensor_readings`
Stores all sensor measurements from nodes

**Tags**:
- `node_id` (string): Unique identifier for each node
- `gateway_id` (string): Identifier for the receiving gateway
- `node_type` (string, optional): Type classification of node
- `location` (string, optional): Geographic grouping tag

**Fields**:
- `vin` (float): Voltage input in volts
- `batteryChargerStatus` (float): Charger status/percentage
- `temperature` (float): Temperature in °C
- `temperature_validity` (boolean): Data validity flag
- `humidity` (float): Relative humidity in %
- `pressure` (float): Atmospheric pressure in hPa
- `tempPressure` (float): Temperature at pressure sensor in °C
- `lux` (float): Illuminance in lux

#### 2. `node_status`
Tracks device health and connectivity metrics

**Tags**:
- `node_id`
- `gateway_id`

**Fields**:
- `rssi` (float): Received signal strength indicator
- `snr` (float): Signal-to-noise ratio
- `battery_level` (float): Remaining battery percentage
- `uptime` (integer): Node uptime in seconds
- `transmission_count` (integer): Number of transmissions

#### 3. `node_errors`
Records all error conditions and failures

**Tags**:
- `node_id`
- `gateway_id`
- `error_category` (string): "sensor", "communication", "power"

**Fields**:
- `err_num` (integer): Error code
- `err_str` (string): Error description
- `err_htu` (boolean): Humidity/temperature error
- `err_pressure` (boolean): Pressure sensor error
- `err_lux` (boolean): Light sensor error
- `err_vin` (boolean): Voltage input error
- `fail` (boolean): Critical failure flag

## Example Queries

### Basic Data Retrieval
```sql
-- Get latest readings from a specific node
SELECT * FROM "sensor_readings" 
WHERE "node_id" = 'node_123' 
ORDER BY time DESC 
LIMIT 1