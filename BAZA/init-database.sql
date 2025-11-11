-- Database initialization script for Render
-- Run this script to create all tables
-- Note: Database already exists on Render, so we only create tables

CREATE TABLE IF NOT EXISTS Klijent
(
    idKlijent INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    imeKlijent VARCHAR(100) NOT NULL,
    prezimeKlijent VARCHAR(100) NOT NULL DEFAULT '',
    email VARCHAR(75) NOT NULL,
    slikaUrl VARCHAR(255),
    UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS Serviser
(
    idServiser INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    imeServiser VARCHAR(100) NOT NULL,
    prezimeServiser VARCHAR(100) NOT NULL DEFAULT '',
    email VARCHAR(100) NOT NULL,
    voditeljServisa BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS Admin
(
    idAdmin INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    imeAdmin VARCHAR(100) NOT NULL,
    prezimeAdmin VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS Model
(
    idModel INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    markaNaziv VARCHAR(100) NOT NULL,
    modelNaziv VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Vozilo
(
    idVozilo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    registracija VARCHAR(50) NOT NULL,
    idModel INT NOT NULL,
    godinaProizv INT NOT NULL,
    FOREIGN KEY (idModel) REFERENCES Model(idModel),
    UNIQUE (idVozilo),
    UNIQUE (registracija)
);

CREATE TABLE IF NOT EXISTS ZamjenskoVozilo
(
    idZamjVozilo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idModel INT NOT NULL,
    datumPreuzimanja DATE,
    datumVracanja DATE,
    FOREIGN KEY (idModel) REFERENCES Model(idModel)
);

CREATE TABLE IF NOT EXISTS Usluge
(
    idUsluga INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    uslugaNaziv VARCHAR(500) NOT NULL
);

CREATE TABLE IF NOT EXISTS Nalog
(
    idNalog INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    datumVrijemeTermin TIMESTAMP NOT NULL,
    datumVrijemeZavrsenPopravak TIMESTAMP,
    status INT NOT NULL,
    datumVrijemeAzuriranja TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    idKlijent INT NOT NULL,
    idVozilo INT NOT NULL,
    idUsluga INT NOT NULL,
    idServiser INT NOT NULL,
    idZamjVozilo INT,
    FOREIGN KEY (idVozilo) REFERENCES Vozilo(idVozilo),
    FOREIGN KEY (idKlijent) REFERENCES Klijent(idKlijent),
    FOREIGN KEY (idUsluga) REFERENCES Usluge(idUsluga),
    FOREIGN KEY (idServiser) REFERENCES Serviser(idServiser),
    FOREIGN KEY (idZamjVozilo) REFERENCES ZamjenskoVozilo(idZamjVozilo)
);

