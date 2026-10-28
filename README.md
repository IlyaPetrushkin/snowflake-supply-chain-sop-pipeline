# Snowflake Supply Chain & S&OP Analytics Project

Tämä projekti on luotu osaksi hakuprosessia Data Analyst (Part-time) -tehtävään. Projektissa rakennetaan moderni ELT-dataputki (Extract, Load, Transform) Snowflake-ympäristöön hyödyntäen Kagglen toimitusketjudataa.

## Projektin tavoite
Projektin tavoitteena on harmonisoida raakadataa ja luoda liiketoimintalogiikkaa myynnin ja toiminnan suunnittelun (S&OP) tueksi. Erityisenä painopisteenä on varastotilanteen kriittisyyden ja logistiikan seuranta.

## Teknologiat
- **Data-alusta:** Snowflake (Enterprise Edition pilvessä)
- **Kieli:** SQL
- **Tietolähde:** Kaggle Supply Chain Sales Analytics Dataset

## Dataputken rakenne (ELT)
1. **Extract / Load:** Raakadata ladattiin CSV-muodossa sisään Snowflakeen `SUPPLY_CHAIN_PROJECT.RAW_DATA`-skeemaan taulukoksi `SUPPLY_CHAIN_RAW`.
2. **Transform (Liiketoimintalogiikka):** Datan päälle rakennettiin analytiikkakerros (`ANALYTICS`-skeema). SQL:n `CASE WHEN` -logiikalla luotiin automaattinen tuotteiden varastosaldojen kriittisyyden luokittelu (`vw_sop_inventory_health` -näkymä).

## SQL-skriptit
Projektissa käytetty täydellinen SQL-koodi tietokantojen, skeemojen ja näkymien luomiseen löytyy tiedostosta: `01_raw_to_analytics_pipeline.sql`.
