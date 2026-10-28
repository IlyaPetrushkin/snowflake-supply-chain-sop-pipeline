-- ==============================================================================
-- SNOWFLAKE SETUP & ELT PIPELINE
-- Projekti: Supply Chain & S&OP Analytics
-- ==============================================================================

-- 1. YMPÄRISTÖN JA OPTIMOINNIN ASETUKSET
-- Varmistetaan, että oletuspalvelin sammuu automaattisesti 1 minuutin päästä kulujen minimoimiseksi
ALTER WAREHOUSE COMPUTE_WH SET AUTO_SUSPEND = 60;


-- 2. TIETOKANNAN JA SKEEMOJEN RAKENTAMINEN
-- Luodaan projektille oma tietokanta
CREATE DATABASE supply_chain_project;

-- Otetaan luotu tietokanta käyttöön
USE DATABASE supply_chain_project;

-- Luodaan skeema raakadataa (Raw/Staging) varten
CREATE SCHEMA supply_chain_project.raw_data;

-- Luodaan skeema jalostettua analytiikkakerrosta varten
CREATE SCHEMA supply_chain_project.analytics;


-- 3. DATA TRANSFORMATION & LIIKETOIMINTALOGIIKKA (S&OP)
-- Huom: Raakadata (supply_chain_raw) ladattu tähän väliin UI:n kautta CSV-tiedostosta.
-- Luodaan uudelleenkäytettävä näkymä (View) varastotilanteen seurantaan.

CREATE OR REPLACE VIEW supply_chain_project.analytics.vw_sop_inventory_health AS
SELECT 
    product_type AS TUOTERYHMA,
    sku AS TUOTE_ID,
    price AS KAPPALEHINTA,
    stock_levels AS VARASTOTILANNE,
    order_quantities AS TILAUSMAARAT,
    lead_times AS TOIMITUSAIKA_PAIVINA,
    revenue_generated AS TUOTETUT_TULOT,
    
    -- Liiketoimintalogiikka varaston kriittisyyden tunnistamiseen
    CASE 
        WHEN stock_levels < order_quantities THEN 'KRIITTINEN: Tilaa heti'
        WHEN stock_levels BETWEEN order_quantities AND (order_quantities * 1.5) THEN 'HUOMIO: Seuraa tilannetta'
        ELSE 'OK: Varasto riittävä'
    END AS VARASTON_STATUS

FROM supply_chain_project.raw_data.supply_chain_raw;


-- 4. AD-HOC ANALYYSI JA LAADUNVARMISTUS
-- Testihaku, jolla S&OP-tiimi saa haettua nopeasti kriittisessä tilassa olevat tuotteet
SELECT * 
FROM supply_chain_project.analytics.vw_sop_inventory_health 
WHERE VARASTON_STATUS = 'KRIITTINEN: Tilaa heti'
ORDER BY VARASTOTILANNE ASC;
