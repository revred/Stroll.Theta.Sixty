# Parquet Schema for 1-Minute Bars

## File Structure

Each Parquet file contains 1-minute OHLCV bars for a single symbol during one trading hour.

**Filename Pattern:** `{SYMBOL}_{HH}.parquet`
- `SYMBOL`: SPX, XSP, VIX, QQQ, GLD, USO
- `HH`: Hour in 24-hour format (09, 10, 11, 12, 13, 14, 15)

## Column Schema

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `ts_utc` | `timestamp[ns]` | Timestamp (UTC) | `2024-03-15 14:32:00+00:00` |
| `ts_et` | `timestamp[ns]` | Timestamp (Eastern) | `2024-03-15 10:32:00-04:00` |
| `symbol` | `string` | Underlying symbol | `SPX` |
| `open` | `decimal(10,2)` | Opening price | `5125.50` |
| `high` | `decimal(10,2)` | High price | `5127.25` |
| `low` | `decimal(10,2)` | Low price | `5124.75` |
| `close` | `decimal(10,2)` | Closing price | `5126.00` |
| `volume` | `int64` | Volume (contracts/shares) | `15750` |
| `vwap` | `decimal(10,4)` | Volume-weighted average price | `5125.8325` |

## Data Properties

- **Frequency**: Exactly 60 rows per file (one per minute)
- **Time Range**: 9:30 AM - 4:00 PM ET (390 minutes total, split into 6.5 hourly files)
- **Timezone**: All timestamps stored in both UTC and Eastern time
- **Missing Data**: Forward-filled from previous minute if no trades
- **Compression**: Snappy compression (default Parquet)

## Example Usage

```python
import pandas as pd

# Load one hour of SPX data
df = pd.read_parquet('bars/2024/03/15/SPX_14.parquet')
print(df.head())

#                    ts_utc                ts_et symbol     open     high      low    close  volume     vwap
# 0 2024-03-15 18:00:00+00:00 2024-03-15 14:00:00-04:00    SPX  5125.50  5127.25  5124.75  5126.00   15750  5125.83
# 1 2024-03-15 18:01:00+00:00 2024-03-15 14:01:00-04:00    SPX  5126.00  5126.50  5125.25  5125.75   12340  5125.92
# ...
```

## File Size Estimates

- **Uncompressed**: ~8KB per file (60 rows × ~130 bytes/row)
- **Compressed**: ~2-3KB per file (Parquet Snappy compression)
- **Per Day**: ~96KB per symbol (8 hours × ~12KB/hour)
- **Total Per Day**: ~576KB (6 symbols × 96KB)

Extremely efficient storage while maintaining full 1-minute resolution!