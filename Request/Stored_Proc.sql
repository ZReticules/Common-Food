DROP FUNCTION IF EXISTS GetTaskTemplId;
DROP FUNCTION IF EXISTS GetEmployId;
DROP FUNCTION IF EXISTS GetTaskStatusId;
DROP FUNCTION IF EXISTS GetTasksByEmploy;
DROP FUNCTION IF EXISTS SummEmployBalls;

CREATE OR REPLACE FUNCTION GetTaskTemplId(Task_Name VARCHAR(30))
RETURNS INTEGER
LANGUAGE PLPGSQL
AS $$
#variable_conflict use_variable
DECLARE OutVar INTEGER DEFAULT 0;
BEGIN
	SELECT Task_Templates.ID 
	INTO OutVar
	FROM Task_Templates
	WHERE Task_Templates.Name = Task_Name;
    RETURN OutVar;
END;
$$;

CREATE OR REPLACE FUNCTION GetEmployId(EmployName VARCHAR(30))
RETURNS INTEGER
LANGUAGE PLPGSQL
AS $$
#variable_conflict use_variable
DECLARE OutVar INTEGER DEFAULT 0;
BEGIN
	SELECT Employers.ID 
	INTO OutVar
	FROM Employers
	WHERE Employers.FIO = EmployName;
    RETURN OutVar;
END;
$$;

CREATE OR REPLACE FUNCTION GetTaskStatusId(Status_Name VARCHAR(30))
RETURNS INTEGER
LANGUAGE PLPGSQL
AS $$
#variable_conflict use_variable
DECLARE OutVar INTEGER DEFAULT 0;
BEGIN
	SELECT Task_Statuses.ID 
	INTO OutVar
	FROM Task_Statuses
	WHERE Task_Statuses.Name = Status_Name;
    RETURN OutVar;
END;
$$;

CREATE OR REPLACE FUNCTION GetTasksByEmploy(EmployID INT)
RETURNS TABLE (
	DateStart TIMESTAMPTZ,
	DateFin TIMESTAMPTZ,
	Templ_Name VARCHAR(100),
	Status_Name VARCHAR(100),
	Balls FLOAT,
	Status_Mult FLOAT,
	TaskActive BOOLEAN
)
LANGUAGE PLPGSQL
AS $$
BEGIN
	return query(
		SELECT 
            Tasks.Create_Date, 
			Tasks.Close_Date, 
			Task_Templates.Name,
			Task_Statuses.Name,
			Tasks.Balls,
			Task_Statuses.Multiplier,
			Tasks.Activity
		FROM Tasks, Task_Templates, Task_Statuses
		WHERE Tasks.ID_Employer = GetTasksByEmploy.EmployID
			AND Task_Templates.ID = Tasks.ID_Template
			AND Task_Statuses.ID = Tasks.ID_Status
	);
END;
$$;

CREATE OR REPLACE FUNCTION SummEmployBalls(My_ID_Employ INT, MyYear INT, MyMonth INT)
RETURNS FLOAT
LANGUAGE PLPGSQL
AS $$
#variable_conflict use_variable
DECLARE RealSumm FLOAT DEFAULT 0;
DECLARE MaxSumm FLOAT DEFAULT 0;
BEGIN
	SELECT SUM(Tasks.Balls*Task_Statuses.Multiplier), SUM(Tasks.Balls) 
	INTO RealSumm, MaxSumm
	FROM Tasks, Task_Statuses
	WHERE Tasks.ID_Employer = My_ID_Employ
		AND Task_Statuses.ID = Tasks.ID_Status
		AND EXTRACT(YEAR FROM Tasks.Close_Date) = MyYear
		AND EXTRACT(MONTH FROM Tasks.Close_Date) = MyMonth
		AND Tasks.Activity;
    RETURN RealSumm/MaxSumm;
END;
$$;

CREATE OR REPLACE FUNCTION Tasks_NewTry()
RETURNS trigger
LANGUAGE PLPGSQL 
AS $$
BEGIN
	IF NEW.Ready = TRUE AND OLD.Ready = FALSE THEN
		BEGIN
			UPDATE Tasks
			SET CountTry = OLD.CountTry + 1
			WHERE ID = OLD.ID;
		END;
	END IF;
	RETURN NEW;
END;
$$;
CREATE OR REPLACE TRIGGER TaskUpdTrigger
  AFTER UPDATE OF Ready
  ON TASKS
  FOR EACH ROW
  EXECUTE PROCEDURE Tasks_NewTry();