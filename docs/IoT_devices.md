# RX3000 LoRaWAN Configuration

This document outlines the mandatory configuration parameters for setting up the lora sensors system on ChirpStack.

---

## 📘 Device Profile

- **Name**: `rx3000-profile`
- **Region**: `EU868`
- **MAC Version**: `1.0.3`
- **RegParams Revision**: `B`
- **Max EIRP**: `16 dBm`
- **Supports OTAA**: `Yes`
- **Supports Class B**: `No`
- **Supports Class C**: `No`

---

## 📡 Gateway

- **Gateway ID**: `b827ebfffec9b5d2`
- **Name**: `rx3000-gateway`
- **Network Server**: `Default network-server`
- **Gateway Profile**: `Default`
- **Frequency Plan**: `EU868`
- **Public**: `No`
- **Gateway Discovery Enabled**: `No`

---

## 🌡️ Sensor (End Device)

- **Device EUI**: `a8404100004c1c57`
- **Device Profile**: `rx3000-profile`
- **Name**: `rx3000-temp-rh`
- **Application**: `rx3000`

### 🔐 OTAA Keys

- **AppKey**: `000102030405060708090a0b0c0d0e0f`
- **JoinEUI**: `800000000000000C`
