# 📜 InfluxDB v2 DBRP (Database-RetentionPolicy) Cheat Sheet

## What is DBRP mapping?

- InfluxDB v2.x stores data in **buckets** (no more databases/retention policies like v1).
- Some clients (like Grafana using **InfluxQL** or **Flux with SQL**) need a **Database/RetentionPolicy** (DBRP) mapping.
- You need to **map** a bucket to a (virtual) database and retention policy (RP).

---

## 🔍 List all existing DBRP mappings

```bash
influx v1 dbrp list
```

You will see a table like:

| ID  | Database | Bucket ID | Retention Policy | Default | Organization ID |
| --- | -------- | --------- | ---------------- | ------- | --------------- |
| ... | ...      | ...       | ...              | ...     | ...             |

---

## ➕ Create a new DBRP mapping

```bash
influx v1 dbrp create \
  --db <database-name> \
  --rp <retention-policy-name> \
  --bucket-id <bucket-id> \
  --default
```

**Example:**

```bash
influx v1 dbrp create \
  --db weather_station_raw \
  --rp raw_data_rp \
  --bucket-id 91a88c8c19ea81c4 \
  --default
```

📝 Notes:

- `--db` = the virtual database name you want.
- `--rp` = retention policy name (you choose it).
- `--bucket-id` = find it with `influx bucket list`.
- `--default` = make this mapping the default one.

---

## 🗑️ Delete an existing DBRP mapping (careful!)

First list the mappings, copy the `ID`, then:

```bash
influx v1 dbrp delete --id <dbrp-id>
```

**Example:**

```bash
influx v1 dbrp delete --id 91a88c8c19ea81c4
```

---

## 📊 How to connect in Grafana (InfluxQL)

1. Data Source type = **InfluxDB**
2. Query Language = **InfluxQL**
3. URL = Your InfluxDB instance (e.g., `http://localhost:8086`)
4. Database = **(your **``** name, e.g., **``**)**
5. User/Password = (if auth enabled)
6. (Optional) Retention Policy = (your `--rp` name, or leave blank if using default)

Then you can query as in InfluxDB v1.x!

---

# ✅ Good Practices

- Use a meaningful name for `db` and `rp` (example: `weather_station_raw`, `raw_data_rp`).
- Try to keep one mapping per bucket unless really needed.
- Don't modify system buckets (`_monitoring`, `_tasks`).
- Document your mappings if managing many buckets.

