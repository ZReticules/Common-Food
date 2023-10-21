DROP TABLE IF EXISTS Employers;
DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Restaurants;
DROP TABLE IF EXISTS Task_Templates;
DROP TABLE IF EXISTS Task_Statuses;

CREATE TABLE Roles(
	ID SERIAL PRIMARY KEY,
	Name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Restaurants(
	ID SERIAL PRIMARY KEY,
	Address VARCHAR(100) NOT NULL,
	City VARCHAR(30) NOT NULL
);

CREATE TABLE Employers(
	ID SERIAL PRIMARY KEY,
	FIO VARCHAR(100) NOT NULL,
	Phone VARCHAR(20),
	ID_Restaurant INT NOT NULL,
	ID_Role INT NOT NULL,
	Login VARCHAR(30) UNIQUE NOT NULL,
	Password VARCHAR(30) NOT NULL,
	FOREIGN KEY (ID_Restaurant) REFERENCES Restaurants(ID),
	FOREIGN KEY (ID_Role) REFERENCES Roles(ID)
);

CREATE TABLE Task_Templates(
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Template BYTEA
);

CREATE TABLE Task_Statuses(
    ID SERIAL PRIMARY KEY,
    Name VARCHAR(30) NOT NULL,
    Multiplier FLOAT NOT NULL
);

CREATE TABLE Tasks(
    ID SERIAL PRIMARY KEY,
    ID_Employer INT NOT NULL,
    Create_Date DATE,
    Close_Date DATE,
    ID_Temlate INT NOT NULL,
    Balls FLOAT NOT NULL,
    ID_Status INT NOT NULL,
    Activity BOOLEAN NOT NULL,
	FOREIGN KEY (ID_Employer) REFERENCES Employers(ID),
	FOREIGN KEY (ID_Temlate) REFERENCES Task_Templates(ID),
	FOREIGN KEY (ID_Status) REFERENCES Task_Statuses(ID)
);

INSERT INTO Roles VALUES (DEFAULT, 'Сотрудник'),
	(DEFAULT, 'Менеджер');


INSERT INTO TASK_Statuses VALUES (DEFAULT, 'Открыта', 0.0),
	(DEFAULT, 'Закрыта в срок', 1.0),
	(DEFAULT, 'Просрочена', -0.5),
	(DEFAULT, 'Выполнена с просрочкой', 0.5),
	(DEFAULT, 'Провалена', -1.0)

CREATE OR REPLACE FUNCTION MyTest(IN MVAR VARCHAR(30))
RETURNS TABLE(
	ID INT,
	Name VARCHAR(100)
)
LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN QUERY(
		SELECT * FROM Roles WHERE NAME = MVAR
	);
END;
$$;