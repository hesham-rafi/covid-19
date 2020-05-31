SELECT count(distinct Country) FROM case_by_country;

SELECT Country, Confirmed, Deaths, Recovered, Latitude, Longitude  from case_by_country c INNER JOIN country_lat_lon l
ON C.CountryCode = l.CountryCode where LastUpdate = date();

SELECT DATE('now');

SELECT * FROM case_by_country;

SELECT * FROM country_lat_lon;


SELECT Confirmed FROM case_by_country where CountryCode='SG' and LastUpdate=date('now', '-1 days');
;

select LastUpdate as date, sum(Confirmed) as confirm from case_by_country group by LastUpdate;

select LastUpdate as date, sum(Confirmed) as Confirmed from case_by_country group by LastUpdate;

--delete from case_by_country;

CREATE TABLE case_by_country (
    LastUpdate Date,
    CountryCode VARCHAR (5),
    Country     VARCHAR (25),
    Confirmed   INTEGER,
    Deaths      INTEGER,
    Recovered   INTEGER,
    NewConfirmed   INTEGER,
    NewDeaths      INTEGER,
    NewRecovered   INTEGER
);

--delete from country_lat_lon;

CREATE TABLE country_lat_lon (
    CountryCode VARCHAR (5),
    Country     VARCHAR (25),
    Latitude   INTEGER,
    Longitude      INTEGER
);

SELECT * FROM country_lat_lon;

delete from singapore_ip_lat_long;

CREATE TABLE singapore_lat_long (
    Hospital     VARCHAR (25),
    Latitude   INTEGER,
    Longitude      INTEGER
);

SELECT * FROM singapore_ip_lat_long;

CREATE TABLE infected_lat_long (
    InfectedPlace     VARCHAR (25),
    Latitude   INTEGER,
    Longitude      INTEGER
);

SELECT * FROM singapore_hp_lat_long;

delete from singapore_case;

CREATE TABLE singapore_case (
    `Case` INTEGER,
    Patient VARCHAR (200),
    Age     INTEGER,
    Gender   VARCHAR (10),
    Nationality      VARCHAR (25),
    Status   VARCHAR (25),
    InfectionSource   VARCHAR (100),
    DaysToConfirmation      INTEGER,
    DaysToRecover   INTEGER,
    ConfirmDate Date
);

SELECT * FROM singapore_case where ConfirmDate=Date('now', '-1 days');

SELECT count(distinct Case) FROM singapore_case where ConfirmDate==date('now');

delete from Singapore_Master;

CREATE TABLE Singapore_Master
(
    hospital           VARCHAR (25),
    case_id            INTEGER,
    age                INTEGER,
    nationality        VARCHAR (25),
    gender             VARCHAR (10),
    imported           VARCHAR (25),
    Status             VARCHAR (25),
    origin_country     VARCHAR (50),
    symptom_to_confirm INTEGER,
    time_to_recover    INTEGER,
    confirmed_date     DATE,
    Hospital_Latitude  INTEGER,
    Hospital_Longitude INTEGER
);

select * from singapore_master;

delete from singapore_ip_lat_long;

SELECT * FROM singapore_ip_lat_long;

SELECT * FROM case_by_country;

SELECT * FROM country_lat_lon;

create table eu_country 
(
    Continent_Name VARCHAR (25),
    Country_Name VARCHAR (50),
    Country_Code VARCHAR (5)
);

SELECT * From eu_country;

delete from singapore_phpc_lat_long;

create table singapore_phpc_lat_long 
(
    clinic_name     VARCHAR (100),
    clinic_address  VARCHAR (100),
    clinic_phone    VARCHAR (10),
    pincode         INTEGER,
    lat	        INTEGER,
    lon	        INTEGER
);

SELECT * FROM singapore_phpc_lat_long;

select LastUpdate, sum(case when CountryCode = 'CN' then Confirmed else 0 end) as china_count,
sum(case when CountryCode = 'US' then Confirmed else 0 end) as us_count,
sum(case when CountryCode <> 'CN' or CountryCode <>'UN' then Confirmed else 0 end) as other_count
from case_by_country
group by LastUpdate;


select * from case_by_country;

SELECT * FROM singapore_hp_lat_long;

SELECT * FROM singapore_ip_lat_long;

create table indonesia_master
(
    last_updated	Date,
    total_cases	INTEGER,
    new_cases	INTEGER,
    total_cases_in_icu        INTEGER,
    percentage_in_icu         INTEGER,
    total_recovered	          INTEGER,
    percentage_recovered	INTEGER,
    total_deaths	          INTEGER,
    percentage_death	INTEGER,
    recovered_cases	          INTEGER,
    new_death	          INTEGER,
    new_cases_in_icu          INTEGER
);

delete from indonesia_master;

select * from indonesia_master;


create table indonesia_provinces
(
    last_updated	Date,
    provinces	VARCHAR (100),
    cases	          INTEGER,
    recovered	INTEGER,
    death	          INTEGER,
    lat	          INTEGER,
    long            INTEGER
);

select * from indonesia_provinces;

