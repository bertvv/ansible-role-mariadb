--- initialise a database
DROP TABLE IF EXISTS `TestTable`;

CREATE TABLE IF NOT EXISTS `TestTable` (
  `Id` INT NOT NULL,
  `GivenName` VARCHAR(100) NOT NULL,
  `SurName` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Id`)
);
