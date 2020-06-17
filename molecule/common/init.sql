--- initialise a database
DROP TABLE IF EXISTS `TestTable`;

CREATE TABLE IF NOT EXISTS `TestTable` (
  `Id` INT NOT NULL,
  `GivenName` VARCHAR(100) NOT NULL,
  `SurName` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Id`)
);

INSERT INTO `TestTable` (`Id`, `GivenName`, `SurName`)
VALUES
  (1, 'John X.', 'Doe'),
  (2, 'Jane Y.', 'Doe');
