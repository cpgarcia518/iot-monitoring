# IoT Monitoring System - InfluxDB Schemas

## 1. LoRaWAN Device Monitoring Schema

### Database Structure

#### Primary Measurements

**`node_data`** - Sensor measurements from LoRaWAN nodes  
**Tags**:
- `node_id` - Device identifier
- `gateway_id` - Receiving gateway
- `location` - Geographic tag (optional)

**Fields**:
- `vin` (float) - Voltage input
- `temperature` (float)
- `humidity` (float)  
- `pressure` (float)
- `lux` (float)
- (All other sensor fields)

---

**`gateway_status`** - Gateway health metrics  
**Tags**:
- `gateway_id`
- `region`

**Fields**:
- `latitude` (float)
- `longitude` (float)
- `rssi` (float)
- `uptime` (integer)

### Example Queries

```sql
-- Latest node readings
SELECT last(*) FROM "node_data" 
GROUP BY "node_id"

-- Gateway coverage
SELECT count("node_id") FROM "node_data"
WHERE time > now() - 1h
GROUP BY "gateway_id"