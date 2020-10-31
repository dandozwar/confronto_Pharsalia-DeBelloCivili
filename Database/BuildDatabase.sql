-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Ott 31, 2020 alle 16:07
-- Versione del server: 10.4.11-MariaDB
-- Versione PHP: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `orizzonte`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `corrispondenza`
--

CREATE TABLE `corrispondenza` (
  `id` smallint(6) NOT NULL,
  `testo` varchar(32) COLLATE latin1_general_ci NOT NULL,
  `opera` smallint(6) NOT NULL,
  `libro` tinyint(4) NOT NULL,
  `capitolo` tinyint(4) DEFAULT NULL,
  `verso` smallint(6) NOT NULL,
  `luogo` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Struttura della tabella `luogo`
--

CREATE TABLE `luogo` (
  `id` smallint(6) NOT NULL,
  `nome` varchar(32) COLLATE latin1_general_cs NOT NULL,
  `latitudine` decimal(10,7) DEFAULT NULL,
  `longitudine` decimal(10,7) DEFAULT NULL,
  `tipo` tinyint(4) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

--
-- Struttura della tabella `opera`
--

CREATE TABLE `opera` (
  `id` smallint(6) NOT NULL,
  `titolo` varchar(32) COLLATE latin1_general_cs NOT NULL,
  `autore` varchar(32) COLLATE latin1_general_cs NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

--
-- Dump dei dati per la tabella `opera`
--

INSERT INTO `opera` (`id`, `titolo`, `autore`) VALUES
(1, 'Pharsalia', 'Marco Anneo Lucano'),
(2, 'De bello civili', 'Caio Giulio Cesare');

-- --------------------------------------------------------

--
-- Struttura della tabella `tipo`
--

CREATE TABLE `tipo` (
  `id` tinyint(4) NOT NULL,
  `descrizione` varchar(32) COLLATE latin1_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dump dei dati per la tabella `tipo`
--

INSERT INTO `tipo` (`id`, `descrizione`) VALUES
(1, 'Altro'),
(2, 'Città'),
(3, 'Regione'),
(4, 'Popolo'),
(5, 'Fiume'),
(6, 'Monte o catena montuosa'),
(7, 'Isola o arcipelago'),
(8, 'Mare'),
(9, 'Lago'),
(10, 'Capo o promontorio');

-- --------------------------------------------------------

--
-- Struttura della tabella `variabile`
--

CREATE TABLE `variabile` (
  `id` varchar(32) COLLATE latin1_general_ci NOT NULL,
  `valore` decimal(40,20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `corrispondenza`
--
ALTER TABLE `corrispondenza`
  ADD PRIMARY KEY (`id`),
  ADD KEY `opera` (`opera`),
  ADD KEY `luogo` (`luogo`);

--
-- Indici per le tabelle `luogo`
--
ALTER TABLE `luogo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tipo` (`tipo`);

--
-- Indici per le tabelle `opera`
--
ALTER TABLE `opera`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `tipo`
--
ALTER TABLE `tipo`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `variabile`
--
ALTER TABLE `variabile`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `corrispondenza`
--
ALTER TABLE `corrispondenza`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3079;

--
-- AUTO_INCREMENT per la tabella `luogo`
--
ALTER TABLE `luogo`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=549;

--
-- AUTO_INCREMENT per la tabella `opera`
--
ALTER TABLE `opera`
  MODIFY `id` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT per la tabella `tipo`
--
ALTER TABLE `tipo`
  MODIFY `id` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `corrispondenza`
--
ALTER TABLE `corrispondenza`
  ADD CONSTRAINT `corrispondenza_ibfk_1` FOREIGN KEY (`opera`) REFERENCES `opera` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `corrispondenza_ibfk_2` FOREIGN KEY (`luogo`) REFERENCES `luogo` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `luogo`
--
ALTER TABLE `luogo`
  ADD CONSTRAINT `luogo_ibfk_1` FOREIGN KEY (`tipo`) REFERENCES `tipo` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
