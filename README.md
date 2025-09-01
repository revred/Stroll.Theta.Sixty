# Stroll.Theta.Sixty — 1-Minute Bar Resolution Storage

**Purpose:** High-resolution 1-minute OHLCV bars for options backtesting (2018-01-01 → 2025-08-29)

**Architecture:** Hourly Parquet files for efficient storage and selective loading

> Primary source: `github.com/revred/Stroll.Alpha` (generation engine)
> 
> Options data: `github.com/revred/Stroll.Theta.DB` (main dataset)
>
> This repo: **`github.com/revred/Stroll.Theta.Sixty`** (1-minute bars only)

## Structure

```
Stroll.Theta.Sixty/
├─ README.md
├─ schema.md                    # Parquet schema definition
├─ manifest.json                # Index of available data
└─ bars/
   └─ YYYY/MM/DD/
      ├─ SPX_HH.parquet        # 1-minute bars for hour HH
      ├─ XSP_HH.parquet
      ├─ VIX_HH.parquet
      ├─ QQQ_HH.parquet
      ├─ GLD_HH.parquet
      └─ USO_HH.parquet
```

## Features

- **1-minute resolution** during market hours (9:30 AM - 4:00 PM ET)
- **Parquet compression** (~70% smaller than raw data)
- **Hourly partitioning** for selective loading and GitHub file size compliance
- **6 major symbols**: SPX, XSP, VIX, QQQ, GLD, USO
- **7+ years coverage**: January 2018 through August 2025

## Usage

```bash
# Load specific hour
import pandas as pd
bars = pd.read_parquet('bars/2024/03/15/SPX_14.parquet')  # 2-3 PM

# Load full trading day
from pathlib import Path
day_files = Path('bars/2024/03/15').glob('SPX_*.parquet')
full_day = pd.concat([pd.read_parquet(f) for f in day_files])
```

## File Specifications

- **~60 bars per file** (1 hour of 1-minute data)
- **~2MB per Parquet file** (compressed)
- **~96MB per trading day** (8 hours × 6 symbols × 2MB)
- **<100MB GitHub file limit** compliance

## Data Quality

- Synchronized with options data from `Stroll.Theta.DB`
- Market hours filtering (excludes pre/post-market)
- Holiday calendar integration
- Missing data handling with forward-fill

— Updated: 2025-09-01