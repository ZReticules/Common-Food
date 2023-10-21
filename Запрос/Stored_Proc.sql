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
	DateStart Date,
	DateFin Date,
	Templ_Name VARCHAR(100),
	Balls Float,
	Status_Name Varchar(30)
)
LANGUAGE PLPGSQL
AS $$
BEGIN
	return query(
		SELECT Tasks.Create_Date, 
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

CREATE OR REPLACE FUNCTION GetTasksByEmploy(EmployID INT)
RETURNS TABLE (
	DateStart DATE,
	DateFin DATE,
	Templ_Name VARCHAR(100),
	Status_Name VARCHAR(100),
	Balls FLOAT,
	Status_Mult FLOAT,
	TaskActive BOOL
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