-- PostgreSQL Schema
-- Generated from SQLite database at /Users/rakshith/Code/F1_Project/data/sqlite/f1db.db
-- Total Tables: 30

-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA IF NOT EXISTS public;


============================================================
-- TABLE DEFINITIONS
============================================================
-- Table: chassis
CREATE TABLE IF NOT EXISTS chassis (
    "id" VARCHAR(100) PRIMARY KEY,
    "constructor_id" VARCHAR(100) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id")
);

-- Table: circuit
CREATE TABLE IF NOT EXISTS circuit (
    "id" VARCHAR(100) PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    "previous_names" VARCHAR(255),
    "type" VARCHAR(6) NOT NULL,
    "direction" VARCHAR(14) NOT NULL,
    "place_name" VARCHAR(100) NOT NULL,
    "country_id" VARCHAR(100) NOT NULL,
    "latitude" DECIMAL NOT NULL,
    "longitude" DECIMAL NOT NULL,
    "length" DECIMAL NOT NULL,
    "turns" INTEGER NOT NULL,
    "total_races_held" INTEGER NOT NULL,
    FOREIGN KEY ("country_id") REFERENCES "country"("id")
);

-- Table: constructor
CREATE TABLE IF NOT EXISTS constructor (
    "id" VARCHAR(100) PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    "country_id" VARCHAR(100) NOT NULL,
    "best_championship_position" INTEGER,
    "best_starting_grid_position" INTEGER,
    "best_race_result" INTEGER,
    "total_championship_wins" INTEGER NOT NULL,
    "total_race_entries" INTEGER NOT NULL,
    "total_race_starts" INTEGER NOT NULL,
    "total_race_wins" INTEGER NOT NULL,
    "total_1_and_2_finishes" INTEGER NOT NULL,
    "total_race_laps" INTEGER NOT NULL,
    "total_podiums" INTEGER NOT NULL,
    "total_podium_races" INTEGER NOT NULL,
    "total_points" DECIMAL NOT NULL,
    "total_championship_points" DECIMAL NOT NULL,
    "total_pole_positions" INTEGER NOT NULL,
    "total_fastest_laps" INTEGER NOT NULL,
    FOREIGN KEY ("country_id") REFERENCES "country"("id")
);

-- Table: constructor_chronology
CREATE TABLE IF NOT EXISTS constructor_chronology (
    "constructor_id" VARCHAR(100),
    "position_display_order" INTEGER,
    "other_constructor_id" VARCHAR(100) NOT NULL,
    "year_from" INTEGER NOT NULL,
    "year_to" INTEGER,
    PRIMARY KEY ("constructor_id", "position_display_order"),
    FOREIGN KEY ("other_constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id")
);

-- Table: continent
CREATE TABLE IF NOT EXISTS continent (
    "id" VARCHAR(100) PRIMARY KEY,
    "code" VARCHAR(2) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "demonym" VARCHAR(100) NOT NULL
);

-- Table: country
CREATE TABLE IF NOT EXISTS country (
    "id" VARCHAR(100) PRIMARY KEY,
    "alpha2_code" VARCHAR(2) NOT NULL,
    "alpha3_code" VARCHAR(3) NOT NULL,
    "ioc_code" VARCHAR(3),
    "name" VARCHAR(100) NOT NULL,
    "demonym" VARCHAR(100),
    "continent_id" VARCHAR(100) NOT NULL,
    FOREIGN KEY ("continent_id") REFERENCES "continent"("id")
);

-- Table: driver
CREATE TABLE IF NOT EXISTS driver (
    "id" VARCHAR(100) PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    "abbreviation" VARCHAR(3) NOT NULL,
    "permanent_number" VARCHAR(2),
    "gender" VARCHAR(6) NOT NULL,
    "date_of_birth" DATE NOT NULL,
    "date_of_death" DATE,
    "place_of_birth" VARCHAR(100) NOT NULL,
    "country_of_birth_country_id" VARCHAR(100) NOT NULL,
    "nationality_country_id" VARCHAR(100) NOT NULL,
    "second_nationality_country_id" VARCHAR(100),
    "best_championship_position" INTEGER,
    "best_starting_grid_position" INTEGER,
    "best_race_result" INTEGER,
    "total_championship_wins" INTEGER NOT NULL,
    "total_race_entries" INTEGER NOT NULL,
    "total_race_starts" INTEGER NOT NULL,
    "total_race_wins" INTEGER NOT NULL,
    "total_race_laps" INTEGER NOT NULL,
    "total_podiums" INTEGER NOT NULL,
    "total_points" DECIMAL NOT NULL,
    "total_championship_points" DECIMAL NOT NULL,
    "total_pole_positions" INTEGER NOT NULL,
    "total_fastest_laps" INTEGER NOT NULL,
    "total_driver_of_the_day" INTEGER NOT NULL,
    "total_grand_slams" INTEGER NOT NULL,
    FOREIGN KEY ("second_nationality_country_id") REFERENCES "country"("id"),
    FOREIGN KEY ("nationality_country_id") REFERENCES "country"("id"),
    FOREIGN KEY ("country_of_birth_country_id") REFERENCES "country"("id")
);

-- Table: driver_family_relationship
CREATE TABLE IF NOT EXISTS driver_family_relationship (
    "driver_id" VARCHAR(100),
    "position_display_order" INTEGER,
    "other_driver_id" VARCHAR(100) NOT NULL,
    "type" VARCHAR(50) NOT NULL,
    PRIMARY KEY ("driver_id", "position_display_order"),
    FOREIGN KEY ("other_driver_id") REFERENCES "driver"("id"),
    FOREIGN KEY ("driver_id") REFERENCES "driver"("id")
);

-- Table: engine
CREATE TABLE IF NOT EXISTS engine (
    "id" VARCHAR(100) PRIMARY KEY,
    "engine_manufacturer_id" VARCHAR(100) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    "capacity" DECIMAL,
    "configuration" VARCHAR(100),
    "aspiration" VARCHAR(100),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id")
);

-- Table: engine_manufacturer
CREATE TABLE IF NOT EXISTS engine_manufacturer (
    "id" VARCHAR(100) PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "country_id" VARCHAR(100) NOT NULL,
    "best_championship_position" INTEGER,
    "best_starting_grid_position" INTEGER,
    "best_race_result" INTEGER,
    "total_championship_wins" INTEGER NOT NULL,
    "total_race_entries" INTEGER NOT NULL,
    "total_race_starts" INTEGER NOT NULL,
    "total_race_wins" INTEGER NOT NULL,
    "total_race_laps" INTEGER NOT NULL,
    "total_podiums" INTEGER NOT NULL,
    "total_podium_races" INTEGER NOT NULL,
    "total_points" DECIMAL NOT NULL,
    "total_championship_points" DECIMAL NOT NULL,
    "total_pole_positions" INTEGER NOT NULL,
    "total_fastest_laps" INTEGER NOT NULL,
    FOREIGN KEY ("country_id") REFERENCES "country"("id")
);

-- Table: entrant
CREATE TABLE IF NOT EXISTS entrant (
    "id" VARCHAR(100) PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL
);

-- Table: grand_prix
CREATE TABLE IF NOT EXISTS grand_prix (
    "id" VARCHAR(100) PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    "short_name" VARCHAR(100) NOT NULL,
    "abbreviation" VARCHAR(3) NOT NULL,
    "country_id" VARCHAR(100),
    "total_races_held" INTEGER NOT NULL,
    FOREIGN KEY ("country_id") REFERENCES "country"("id")
);

-- Table: race
CREATE TABLE IF NOT EXISTS race (
    "id" INTEGER PRIMARY KEY,
    "year" INTEGER NOT NULL,
    "round" INTEGER NOT NULL,
    "date" DATE NOT NULL,
    "time" VARCHAR(5),
    "grand_prix_id" VARCHAR(100) NOT NULL,
    "official_name" VARCHAR(100) NOT NULL,
    "qualifying_format" VARCHAR(20) NOT NULL,
    "sprint_qualifying_format" VARCHAR(20),
    "circuit_id" VARCHAR(100) NOT NULL,
    "circuit_type" VARCHAR(6) NOT NULL,
    "direction" VARCHAR(14) NOT NULL,
    "course_length" DECIMAL NOT NULL,
    "turns" INTEGER NOT NULL,
    "laps" INTEGER NOT NULL,
    "distance" DECIMAL NOT NULL,
    "scheduled_laps" INTEGER,
    "scheduled_distance" DECIMAL,
    "drivers_championship_decider" BOOLEAN,
    "constructors_championship_decider" BOOLEAN,
    "pre_qualifying_date" DATE,
    "pre_qualifying_time" VARCHAR(5),
    "free_practice_1_date" DATE,
    "free_practice_1_time" VARCHAR(5),
    "free_practice_2_date" DATE,
    "free_practice_2_time" VARCHAR(5),
    "free_practice_3_date" DATE,
    "free_practice_3_time" VARCHAR(5),
    "free_practice_4_date" DATE,
    "free_practice_4_time" VARCHAR(5),
    "qualifying_1_date" DATE,
    "qualifying_1_time" VARCHAR(5),
    "qualifying_2_date" DATE,
    "qualifying_2_time" VARCHAR(5),
    "qualifying_date" DATE,
    "qualifying_time" VARCHAR(5),
    "sprint_qualifying_date" DATE,
    "sprint_qualifying_time" VARCHAR(5),
    "sprint_race_date" DATE,
    "sprint_race_time" VARCHAR(5),
    "warming_up_date" DATE,
    "warming_up_time" VARCHAR(5),
    FOREIGN KEY ("circuit_id") REFERENCES "circuit"("id"),
    FOREIGN KEY ("grand_prix_id") REFERENCES "grand_prix"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: race_constructor_standing
CREATE TABLE IF NOT EXISTS race_constructor_standing (
    "race_id" INTEGER,
    "position_display_order" INTEGER,
    "position_number" INTEGER,
    "position_text" VARCHAR(4) NOT NULL,
    "constructor_id" VARCHAR(100) NOT NULL,
    "engine_manufacturer_id" VARCHAR(100) NOT NULL,
    "points" DECIMAL NOT NULL,
    "positions_gained" INTEGER,
    PRIMARY KEY ("race_id", "position_display_order"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("race_id") REFERENCES "race"("id")
);

-- Table: race_data
CREATE TABLE IF NOT EXISTS race_data (
    "race_id" INTEGER,
    "type" VARCHAR(50),
    "position_display_order" INTEGER,
    "position_number" INTEGER,
    "position_text" VARCHAR(4) NOT NULL,
    "driver_number" VARCHAR(3) NOT NULL,
    "driver_id" VARCHAR(100) NOT NULL,
    "constructor_id" VARCHAR(100) NOT NULL,
    "engine_manufacturer_id" VARCHAR(100) NOT NULL,
    "tyre_manufacturer_id" VARCHAR(100) NOT NULL,
    "practice_time" VARCHAR(20),
    "practice_time_millis" INTEGER,
    "practice_gap" VARCHAR(20),
    "practice_gap_millis" INTEGER,
    "practice_interval" VARCHAR(20),
    "practice_interval_millis" INTEGER,
    "practice_laps" INTEGER,
    "qualifying_time" VARCHAR(20),
    "qualifying_time_millis" INTEGER,
    "qualifying_q1" VARCHAR(20),
    "qualifying_q1_millis" INTEGER,
    "qualifying_q2" VARCHAR(20),
    "qualifying_q2_millis" INTEGER,
    "qualifying_q3" VARCHAR(20),
    "qualifying_q3_millis" INTEGER,
    "qualifying_gap" VARCHAR(20),
    "qualifying_gap_millis" INTEGER,
    "qualifying_interval" VARCHAR(20),
    "qualifying_interval_millis" INTEGER,
    "qualifying_laps" INTEGER,
    "starting_grid_position_qualification_position_number" INTEGER,
    "starting_grid_position_qualification_position_text" VARCHAR(4),
    "starting_grid_position_grid_penalty" VARCHAR(20),
    "starting_grid_position_grid_penalty_positions" INTEGER,
    "starting_grid_position_time" VARCHAR(20),
    "starting_grid_position_time_millis" INTEGER,
    "race_shared_car" BOOLEAN,
    "race_laps" INTEGER,
    "race_time" VARCHAR(20),
    "race_time_millis" INTEGER,
    "race_time_penalty" VARCHAR(20),
    "race_time_penalty_millis" INTEGER,
    "race_gap" VARCHAR(20),
    "race_gap_millis" INTEGER,
    "race_gap_laps" INTEGER,
    "race_interval" VARCHAR(20),
    "race_interval_millis" INTEGER,
    "race_reason_retired" VARCHAR(100),
    "race_points" DECIMAL,
    "race_pole_position" BOOLEAN,
    "race_qualification_position_number" INTEGER,
    "race_qualification_position_text" VARCHAR(4),
    "race_grid_position_number" INTEGER,
    "race_grid_position_text" VARCHAR(2),
    "race_positions_gained" INTEGER,
    "race_pit_stops" INTEGER,
    "race_fastest_lap" BOOLEAN,
    "race_driver_of_the_day" BOOLEAN,
    "race_grand_slam" BOOLEAN,
    "fastest_lap_lap" INTEGER,
    "fastest_lap_time" VARCHAR(20),
    "fastest_lap_time_millis" INTEGER,
    "fastest_lap_gap" VARCHAR(20),
    "fastest_lap_gap_millis" INTEGER,
    "fastest_lap_interval" VARCHAR(20),
    "fastest_lap_interval_millis" INTEGER,
    "pit_stop_stop" INTEGER,
    "pit_stop_lap" INTEGER,
    "pit_stop_time" VARCHAR(20),
    "pit_stop_time_millis" INTEGER,
    "driver_of_the_day_percentage" DECIMAL,
    PRIMARY KEY ("race_id", "type", "position_display_order"),
    FOREIGN KEY ("tyre_manufacturer_id") REFERENCES "tyre_manufacturer"("id"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("driver_id") REFERENCES "driver"("id"),
    FOREIGN KEY ("race_id") REFERENCES "race"("id")
);

-- Table: race_driver_standing
CREATE TABLE IF NOT EXISTS race_driver_standing (
    "race_id" INTEGER,
    "position_display_order" INTEGER,
    "position_number" INTEGER,
    "position_text" VARCHAR(4) NOT NULL,
    "driver_id" VARCHAR(100) NOT NULL,
    "points" DECIMAL NOT NULL,
    "positions_gained" INTEGER,
    PRIMARY KEY ("race_id", "position_display_order"),
    FOREIGN KEY ("driver_id") REFERENCES "driver"("id"),
    FOREIGN KEY ("race_id") REFERENCES "race"("id")
);

-- Table: season
CREATE TABLE IF NOT EXISTS season (
    "year" INTEGER PRIMARY KEY
);

-- Table: season_constructor
CREATE TABLE IF NOT EXISTS season_constructor (
    "year" INTEGER,
    "constructor_id" VARCHAR(100),
    "position_number" INTEGER,
    "position_text" VARCHAR(4),
    "best_starting_grid_position" INTEGER,
    "best_race_result" INTEGER,
    "total_race_entries" INTEGER NOT NULL,
    "total_race_starts" INTEGER NOT NULL,
    "total_race_wins" INTEGER NOT NULL,
    "total_1_and_2_finishes" INTEGER NOT NULL,
    "total_race_laps" INTEGER NOT NULL,
    "total_podiums" INTEGER NOT NULL,
    "total_podium_races" INTEGER NOT NULL,
    "total_points" DECIMAL NOT NULL,
    "total_pole_positions" INTEGER NOT NULL,
    "total_fastest_laps" INTEGER NOT NULL,
    PRIMARY KEY ("year", "constructor_id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_constructor_standing
CREATE TABLE IF NOT EXISTS season_constructor_standing (
    "year" INTEGER,
    "position_display_order" INTEGER,
    "position_number" INTEGER,
    "position_text" VARCHAR(4) NOT NULL,
    "constructor_id" VARCHAR(100) NOT NULL,
    "engine_manufacturer_id" VARCHAR(100) NOT NULL,
    "points" DECIMAL NOT NULL,
    PRIMARY KEY ("year", "position_display_order"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_driver
CREATE TABLE IF NOT EXISTS season_driver (
    "year" INTEGER,
    "driver_id" VARCHAR(100),
    "position_number" INTEGER,
    "position_text" VARCHAR(4),
    "best_starting_grid_position" INTEGER,
    "best_race_result" INTEGER,
    "total_race_entries" INTEGER NOT NULL,
    "total_race_starts" INTEGER NOT NULL,
    "total_race_wins" INTEGER NOT NULL,
    "total_race_laps" INTEGER NOT NULL,
    "total_podiums" INTEGER NOT NULL,
    "total_points" DECIMAL NOT NULL,
    "total_pole_positions" INTEGER NOT NULL,
    "total_fastest_laps" INTEGER NOT NULL,
    "total_driver_of_the_day" INTEGER NOT NULL,
    "total_grand_slams" INTEGER NOT NULL,
    PRIMARY KEY ("year", "driver_id"),
    FOREIGN KEY ("driver_id") REFERENCES "driver"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_driver_standing
CREATE TABLE IF NOT EXISTS season_driver_standing (
    "year" INTEGER,
    "position_display_order" INTEGER,
    "position_number" INTEGER,
    "position_text" VARCHAR(4) NOT NULL,
    "driver_id" VARCHAR(100) NOT NULL,
    "points" DECIMAL NOT NULL,
    PRIMARY KEY ("year", "position_display_order"),
    FOREIGN KEY ("driver_id") REFERENCES "driver"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_engine_manufacturer
CREATE TABLE IF NOT EXISTS season_engine_manufacturer (
    "year" INTEGER,
    "engine_manufacturer_id" VARCHAR(100),
    "position_number" INTEGER,
    "position_text" VARCHAR(4),
    "best_starting_grid_position" INTEGER,
    "best_race_result" INTEGER,
    "total_race_entries" INTEGER NOT NULL,
    "total_race_starts" INTEGER NOT NULL,
    "total_race_wins" INTEGER NOT NULL,
    "total_race_laps" INTEGER NOT NULL,
    "total_podiums" INTEGER NOT NULL,
    "total_podium_races" INTEGER NOT NULL,
    "total_points" DECIMAL NOT NULL,
    "total_pole_positions" INTEGER NOT NULL,
    "total_fastest_laps" INTEGER NOT NULL,
    PRIMARY KEY ("year", "engine_manufacturer_id"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_entrant
CREATE TABLE IF NOT EXISTS season_entrant (
    "year" INTEGER,
    "entrant_id" VARCHAR(100),
    "country_id" VARCHAR(100) NOT NULL,
    PRIMARY KEY ("year", "entrant_id"),
    FOREIGN KEY ("country_id") REFERENCES "country"("id"),
    FOREIGN KEY ("entrant_id") REFERENCES "entrant"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_entrant_chassis
CREATE TABLE IF NOT EXISTS season_entrant_chassis (
    "year" INTEGER,
    "entrant_id" VARCHAR(100),
    "constructor_id" VARCHAR(100),
    "engine_manufacturer_id" VARCHAR(100),
    "chassis_id" VARCHAR(100),
    PRIMARY KEY ("year", "entrant_id", "constructor_id", "engine_manufacturer_id", "chassis_id"),
    FOREIGN KEY ("chassis_id") REFERENCES "chassis"("id"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("entrant_id") REFERENCES "entrant"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_entrant_constructor
CREATE TABLE IF NOT EXISTS season_entrant_constructor (
    "year" INTEGER,
    "entrant_id" VARCHAR(100),
    "constructor_id" VARCHAR(100),
    "engine_manufacturer_id" VARCHAR(100),
    PRIMARY KEY ("year", "entrant_id", "constructor_id", "engine_manufacturer_id"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("entrant_id") REFERENCES "entrant"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_entrant_driver
CREATE TABLE IF NOT EXISTS season_entrant_driver (
    "year" INTEGER,
    "entrant_id" VARCHAR(100),
    "constructor_id" VARCHAR(100),
    "engine_manufacturer_id" VARCHAR(100),
    "driver_id" VARCHAR(100),
    "rounds" VARCHAR(100),
    "rounds_text" VARCHAR(100),
    "test_driver" BOOLEAN NOT NULL,
    PRIMARY KEY ("year", "entrant_id", "constructor_id", "engine_manufacturer_id", "driver_id"),
    FOREIGN KEY ("driver_id") REFERENCES "driver"("id"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("entrant_id") REFERENCES "entrant"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_entrant_engine
CREATE TABLE IF NOT EXISTS season_entrant_engine (
    "year" INTEGER,
    "entrant_id" VARCHAR(100),
    "constructor_id" VARCHAR(100),
    "engine_manufacturer_id" VARCHAR(100),
    "engine_id" VARCHAR(100),
    PRIMARY KEY ("year", "entrant_id", "constructor_id", "engine_manufacturer_id", "engine_id"),
    FOREIGN KEY ("engine_id") REFERENCES "engine"("id"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("entrant_id") REFERENCES "entrant"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_entrant_tyre_manufacturer
CREATE TABLE IF NOT EXISTS season_entrant_tyre_manufacturer (
    "year" INTEGER,
    "entrant_id" VARCHAR(100),
    "constructor_id" VARCHAR(100),
    "engine_manufacturer_id" VARCHAR(100),
    "tyre_manufacturer_id" VARCHAR(100),
    PRIMARY KEY ("year", "entrant_id", "constructor_id", "engine_manufacturer_id", "tyre_manufacturer_id"),
    FOREIGN KEY ("tyre_manufacturer_id") REFERENCES "tyre_manufacturer"("id"),
    FOREIGN KEY ("engine_manufacturer_id") REFERENCES "engine_manufacturer"("id"),
    FOREIGN KEY ("constructor_id") REFERENCES "constructor"("id"),
    FOREIGN KEY ("entrant_id") REFERENCES "entrant"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: season_tyre_manufacturer
CREATE TABLE IF NOT EXISTS season_tyre_manufacturer (
    "year" INTEGER,
    "tyre_manufacturer_id" VARCHAR(100),
    "best_starting_grid_position" INTEGER,
    "best_race_result" INTEGER,
    "total_race_entries" INTEGER NOT NULL,
    "total_race_starts" INTEGER NOT NULL,
    "total_race_wins" INTEGER NOT NULL,
    "total_race_laps" INTEGER NOT NULL,
    "total_podiums" INTEGER NOT NULL,
    "total_podium_races" INTEGER NOT NULL,
    "total_pole_positions" INTEGER NOT NULL,
    "total_fastest_laps" INTEGER NOT NULL,
    PRIMARY KEY ("year", "tyre_manufacturer_id"),
    FOREIGN KEY ("tyre_manufacturer_id") REFERENCES "tyre_manufacturer"("id"),
    FOREIGN KEY ("year") REFERENCES "season"("year")
);

-- Table: tyre_manufacturer
CREATE TABLE IF NOT EXISTS tyre_manufacturer (
    "id" VARCHAR(100) PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "country_id" VARCHAR(100) NOT NULL,
    "best_starting_grid_position" INTEGER,
    "best_race_result" INTEGER,
    "total_race_entries" INTEGER NOT NULL,
    "total_race_starts" INTEGER NOT NULL,
    "total_race_wins" INTEGER NOT NULL,
    "total_race_laps" INTEGER NOT NULL,
    "total_podiums" INTEGER NOT NULL,
    "total_podium_races" INTEGER NOT NULL,
    "total_pole_positions" INTEGER NOT NULL,
    "total_fastest_laps" INTEGER NOT NULL,
    FOREIGN KEY ("country_id") REFERENCES "country"("id")
);


============================================================
-- INDEX DEFINITIONS

============================================================
-- Indexes for table: chassis
CREATE INDEX IF NOT EXISTS "chss_full_name_idx" ON "chassis" ("full_name");
CREATE INDEX IF NOT EXISTS "chss_name_idx" ON "chassis" ("name");
CREATE INDEX IF NOT EXISTS "chss_constructor_id_idx" ON "chassis" ("constructor_id");

-- Indexes for table: circuit
CREATE INDEX IF NOT EXISTS "crct_country_id_idx" ON "circuit" ("country_id");
CREATE INDEX IF NOT EXISTS "crct_place_name_idx" ON "circuit" ("place_name");
CREATE INDEX IF NOT EXISTS "crct_direction_idx" ON "circuit" ("direction");
CREATE INDEX IF NOT EXISTS "crct_type_idx" ON "circuit" ("type");
CREATE INDEX IF NOT EXISTS "crct_full_name_idx" ON "circuit" ("full_name");
CREATE INDEX IF NOT EXISTS "crct_name_idx" ON "circuit" ("name");

-- Indexes for table: constructor
CREATE INDEX IF NOT EXISTS "cnst_country_id_idx" ON "constructor" ("country_id");
CREATE INDEX IF NOT EXISTS "cnst_full_name_idx" ON "constructor" ("full_name");
CREATE INDEX IF NOT EXISTS "cnst_name_idx" ON "constructor" ("name");

-- Indexes for table: constructor_chronology
CREATE INDEX IF NOT EXISTS "cnch_other_constructor_id_idx" ON "constructor_chronology" ("other_constructor_id");
CREATE INDEX IF NOT EXISTS "cnch_position_display_order_idx" ON "constructor_chronology" ("position_display_order");
CREATE INDEX IF NOT EXISTS "cnch_constructor_id_idx" ON "constructor_chronology" ("constructor_id");

-- Indexes for table: country
CREATE INDEX IF NOT EXISTS "cntr_continent_id_idx" ON "country" ("continent_id");

-- Indexes for table: driver
CREATE INDEX IF NOT EXISTS "drvr_second_nationality_country_id_idx" ON "driver" ("second_nationality_country_id");
CREATE INDEX IF NOT EXISTS "drvr_nationality_country_id_idx" ON "driver" ("nationality_country_id");
CREATE INDEX IF NOT EXISTS "drvr_country_of_birth_country_id_idx" ON "driver" ("country_of_birth_country_id");
CREATE INDEX IF NOT EXISTS "drvr_place_of_birth_idx" ON "driver" ("place_of_birth");
CREATE INDEX IF NOT EXISTS "drvr_date_of_death_idx" ON "driver" ("date_of_death");
CREATE INDEX IF NOT EXISTS "drvr_date_of_birth_idx" ON "driver" ("date_of_birth");
CREATE INDEX IF NOT EXISTS "drvr_gender_idx" ON "driver" ("gender");
CREATE INDEX IF NOT EXISTS "drvr_permanent_number_idx" ON "driver" ("permanent_number");
CREATE INDEX IF NOT EXISTS "drvr_abbreviation_idx" ON "driver" ("abbreviation");
CREATE INDEX IF NOT EXISTS "drvr_full_name_idx" ON "driver" ("full_name");
CREATE INDEX IF NOT EXISTS "drvr_last_name_idx" ON "driver" ("last_name");
CREATE INDEX IF NOT EXISTS "drvr_first_name_idx" ON "driver" ("first_name");
CREATE INDEX IF NOT EXISTS "drvr_name_idx" ON "driver" ("name");

-- Indexes for table: driver_family_relationship
CREATE INDEX IF NOT EXISTS "dfrl_other_driver_id_idx" ON "driver_family_relationship" ("other_driver_id");
CREATE INDEX IF NOT EXISTS "dfrl_position_display_order_idx" ON "driver_family_relationship" ("position_display_order");
CREATE INDEX IF NOT EXISTS "dfrl_driver_id_idx" ON "driver_family_relationship" ("driver_id");

-- Indexes for table: engine
CREATE INDEX IF NOT EXISTS "engn_aspiration_idx" ON "engine" ("aspiration");
CREATE INDEX IF NOT EXISTS "engn_configuration_idx" ON "engine" ("configuration");
CREATE INDEX IF NOT EXISTS "engn_capacity_idx" ON "engine" ("capacity");
CREATE INDEX IF NOT EXISTS "engn_full_name_idx" ON "engine" ("full_name");
CREATE INDEX IF NOT EXISTS "engn_name_idx" ON "engine" ("name");
CREATE INDEX IF NOT EXISTS "engn_engine_manufacturer_id_idx" ON "engine" ("engine_manufacturer_id");

-- Indexes for table: engine_manufacturer
CREATE INDEX IF NOT EXISTS "enmf_country_id_idx" ON "engine_manufacturer" ("country_id");
CREATE INDEX IF NOT EXISTS "enmf_name_idx" ON "engine_manufacturer" ("name");

-- Indexes for table: entrant
CREATE INDEX IF NOT EXISTS "entr_name_idx" ON "entrant" ("name");

-- Indexes for table: grand_prix
CREATE INDEX IF NOT EXISTS "grpx_country_id_idx" ON "grand_prix" ("country_id");
CREATE INDEX IF NOT EXISTS "grpx_abbreviation_idx" ON "grand_prix" ("abbreviation");
CREATE INDEX IF NOT EXISTS "grpx_short_name_idx" ON "grand_prix" ("short_name");
CREATE INDEX IF NOT EXISTS "grpx_full_name_idx" ON "grand_prix" ("full_name");
CREATE INDEX IF NOT EXISTS "grpx_name_idx" ON "grand_prix" ("name");

-- Indexes for table: race
CREATE INDEX IF NOT EXISTS "race_direction_idx" ON "race" ("direction");
CREATE INDEX IF NOT EXISTS "race_circuit_type_idx" ON "race" ("circuit_type");
CREATE INDEX IF NOT EXISTS "race_circuit_id_idx" ON "race" ("circuit_id");
CREATE INDEX IF NOT EXISTS "race_sprint_qualifying_format_idx" ON "race" ("sprint_qualifying_format");
CREATE INDEX IF NOT EXISTS "race_qualifying_format_idx" ON "race" ("qualifying_format");
CREATE INDEX IF NOT EXISTS "race_official_name_idx" ON "race" ("official_name");
CREATE INDEX IF NOT EXISTS "race_grand_prix_id_idx" ON "race" ("grand_prix_id");
CREATE INDEX IF NOT EXISTS "race_date_idx" ON "race" ("date");
CREATE INDEX IF NOT EXISTS "race_round_idx" ON "race" ("round");
CREATE INDEX IF NOT EXISTS "race_year_idx" ON "race" ("year");

-- Indexes for table: race_constructor_standing
CREATE INDEX IF NOT EXISTS "rccs_engine_manufacturer_id_idx" ON "race_constructor_standing" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "rccs_constructor_id_idx" ON "race_constructor_standing" ("constructor_id");
CREATE INDEX IF NOT EXISTS "rccs_position_text_idx" ON "race_constructor_standing" ("position_text");
CREATE INDEX IF NOT EXISTS "rccs_position_number_idx" ON "race_constructor_standing" ("position_number");
CREATE INDEX IF NOT EXISTS "rccs_position_display_order_idx" ON "race_constructor_standing" ("position_display_order");
CREATE INDEX IF NOT EXISTS "rccs_race_id_idx" ON "race_constructor_standing" ("race_id");

-- Indexes for table: race_data
CREATE INDEX IF NOT EXISTS "rcda_tyre_manufacturer_id_idx" ON "race_data" ("tyre_manufacturer_id");
CREATE INDEX IF NOT EXISTS "rcda_engine_manufacturer_id_idx" ON "race_data" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "rcda_constructor_id_idx" ON "race_data" ("constructor_id");
CREATE INDEX IF NOT EXISTS "rcda_driver_id_idx" ON "race_data" ("driver_id");
CREATE INDEX IF NOT EXISTS "rcda_driver_number_idx" ON "race_data" ("driver_number");
CREATE INDEX IF NOT EXISTS "rcda_position_text_idx" ON "race_data" ("position_text");
CREATE INDEX IF NOT EXISTS "rcda_position_number_idx" ON "race_data" ("position_number");
CREATE INDEX IF NOT EXISTS "rcda_position_display_order_idx" ON "race_data" ("position_display_order");
CREATE INDEX IF NOT EXISTS "rcda_type_idx" ON "race_data" ("type");
CREATE INDEX IF NOT EXISTS "rcda_race_id_idx" ON "race_data" ("race_id");

-- Indexes for table: race_driver_standing
CREATE INDEX IF NOT EXISTS "rcds_driver_id_idx" ON "race_driver_standing" ("driver_id");
CREATE INDEX IF NOT EXISTS "rcds_position_text_idx" ON "race_driver_standing" ("position_text");
CREATE INDEX IF NOT EXISTS "rcds_position_number_idx" ON "race_driver_standing" ("position_number");
CREATE INDEX IF NOT EXISTS "rcds_position_display_order_idx" ON "race_driver_standing" ("position_display_order");
CREATE INDEX IF NOT EXISTS "rcds_race_id_idx" ON "race_driver_standing" ("race_id");

-- Indexes for table: season_constructor
CREATE INDEX IF NOT EXISTS "sscn_constructor_id_idx" ON "season_constructor" ("constructor_id");
CREATE INDEX IF NOT EXISTS "sscn_year_idx" ON "season_constructor" ("year");

-- Indexes for table: season_constructor_standing
CREATE INDEX IF NOT EXISTS "sscs_engine_manufacturer_id_idx" ON "season_constructor_standing" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "sscs_constructor_id_idx" ON "season_constructor_standing" ("constructor_id");
CREATE INDEX IF NOT EXISTS "sscs_position_text_idx" ON "season_constructor_standing" ("position_text");
CREATE INDEX IF NOT EXISTS "sscs_position_number_idx" ON "season_constructor_standing" ("position_number");
CREATE INDEX IF NOT EXISTS "sscs_position_display_order_idx" ON "season_constructor_standing" ("position_display_order");
CREATE INDEX IF NOT EXISTS "sscs_year_idx" ON "season_constructor_standing" ("year");

-- Indexes for table: season_driver
CREATE INDEX IF NOT EXISTS "ssdr_driver_id_idx" ON "season_driver" ("driver_id");
CREATE INDEX IF NOT EXISTS "ssdr_year_idx" ON "season_driver" ("year");

-- Indexes for table: season_driver_standing
CREATE INDEX IF NOT EXISTS "ssds_driver_id_idx" ON "season_driver_standing" ("driver_id");
CREATE INDEX IF NOT EXISTS "ssds_position_text_idx" ON "season_driver_standing" ("position_text");
CREATE INDEX IF NOT EXISTS "ssds_position_number_idx" ON "season_driver_standing" ("position_number");
CREATE INDEX IF NOT EXISTS "ssds_position_display_order_idx" ON "season_driver_standing" ("position_display_order");
CREATE INDEX IF NOT EXISTS "ssds_year_idx" ON "season_driver_standing" ("year");

-- Indexes for table: season_engine_manufacturer
CREATE INDEX IF NOT EXISTS "ssem_engine_manufacturer_id_idx" ON "season_engine_manufacturer" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "ssem_year_idx" ON "season_engine_manufacturer" ("year");

-- Indexes for table: season_entrant
CREATE INDEX IF NOT EXISTS "sent_country_id_idx" ON "season_entrant" ("country_id");
CREATE INDEX IF NOT EXISTS "sent_entrant_id_idx" ON "season_entrant" ("entrant_id");
CREATE INDEX IF NOT EXISTS "sent_year_idx" ON "season_entrant" ("year");

-- Indexes for table: season_entrant_chassis
CREATE INDEX IF NOT EXISTS "sech_chassis_id_idx" ON "season_entrant_chassis" ("chassis_id");
CREATE INDEX IF NOT EXISTS "sech_engine_manufacturer_id_idx" ON "season_entrant_chassis" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "sech_constructor_id_idx" ON "season_entrant_chassis" ("constructor_id");
CREATE INDEX IF NOT EXISTS "sech_entrant_id_idx" ON "season_entrant_chassis" ("entrant_id");
CREATE INDEX IF NOT EXISTS "sech_year_idx" ON "season_entrant_chassis" ("year");

-- Indexes for table: season_entrant_constructor
CREATE INDEX IF NOT EXISTS "secn_engine_manufacturer_id_idx" ON "season_entrant_constructor" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "secn_constructor_id_idx" ON "season_entrant_constructor" ("constructor_id");
CREATE INDEX IF NOT EXISTS "secn_entrant_id_idx" ON "season_entrant_constructor" ("entrant_id");
CREATE INDEX IF NOT EXISTS "secn_year_idx" ON "season_entrant_constructor" ("year");

-- Indexes for table: season_entrant_driver
CREATE INDEX IF NOT EXISTS "sedr_driver_id_idx" ON "season_entrant_driver" ("driver_id");
CREATE INDEX IF NOT EXISTS "sedr_engine_manufacturer_id_idx" ON "season_entrant_driver" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "sedr_constructor_id_idx" ON "season_entrant_driver" ("constructor_id");
CREATE INDEX IF NOT EXISTS "sedr_entrant_id_idx" ON "season_entrant_driver" ("entrant_id");
CREATE INDEX IF NOT EXISTS "sedr_year_idx" ON "season_entrant_driver" ("year");

-- Indexes for table: season_entrant_engine
CREATE INDEX IF NOT EXISTS "seen_engine_id_idx" ON "season_entrant_engine" ("engine_id");
CREATE INDEX IF NOT EXISTS "seen_engine_manufacturer_id_idx" ON "season_entrant_engine" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "seen_constructor_id_idx" ON "season_entrant_engine" ("constructor_id");
CREATE INDEX IF NOT EXISTS "seen_entrant_id_idx" ON "season_entrant_engine" ("entrant_id");
CREATE INDEX IF NOT EXISTS "seen_year_idx" ON "season_entrant_engine" ("year");

-- Indexes for table: season_entrant_tyre_manufacturer
CREATE INDEX IF NOT EXISTS "setm_tyre_manufacturer_id_idx" ON "season_entrant_tyre_manufacturer" ("tyre_manufacturer_id");
CREATE INDEX IF NOT EXISTS "setm_engine_manufacturer_id_idx" ON "season_entrant_tyre_manufacturer" ("engine_manufacturer_id");
CREATE INDEX IF NOT EXISTS "setm_constructor_id_idx" ON "season_entrant_tyre_manufacturer" ("constructor_id");
CREATE INDEX IF NOT EXISTS "setm_entrant_id_idx" ON "season_entrant_tyre_manufacturer" ("entrant_id");
CREATE INDEX IF NOT EXISTS "setm_year_idx" ON "season_entrant_tyre_manufacturer" ("year");

-- Indexes for table: season_tyre_manufacturer
CREATE INDEX IF NOT EXISTS "sstm_tyre_manufacturer_id_idx" ON "season_tyre_manufacturer" ("tyre_manufacturer_id");
CREATE INDEX IF NOT EXISTS "sstm_year_idx" ON "season_tyre_manufacturer" ("year");

-- Indexes for table: tyre_manufacturer
CREATE INDEX IF NOT EXISTS "tymf_country_id_idx" ON "tyre_manufacturer" ("country_id");
CREATE INDEX IF NOT EXISTS "tymf_name_idx" ON "tyre_manufacturer" ("name");

