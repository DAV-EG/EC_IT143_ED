/*******************************************************************************
NAME:EC_IT143_W5.2_MyFC
PURPOSE: Answer four MyFC community questions using SQL queries.
MODIFICATION LOG:
Ver  Date        Author              Description
---- ----------  --------------     -----------------------------------------------
1.0  11/27/2026  Eguabor David       Created script for IT 143 Assignment 5.2.

RUNTIME:
Varies depending on database size and server performance.

NOTES:
This script answers four questions about the MyFC soccer database.
It uses tblTeamDim, tblPlayerDim, tblPositionDim, and tblPlayerFact
to analyze team rosters, player positions, and player salaries.
********************************************************************************
*/

USE MyFC;
GO

/*
Q1: How many players are assigned to each football team?
Original Question Author: Your Name

A1: I will join tblTeamDim to tblPlayerDim using t_id.
A LEFT JOIN ensures that teams with no listed players are also included.
I will count the player IDs for each team.
*/

SELECT
    t.t_id,
    t.t_code,
    COUNT(p.pl_id) AS PlayerCount
FROM dbo.tblTeamDim AS t
LEFT JOIN dbo.tblPlayerDim AS p
    ON t.t_id = p.t_id
GROUP BY
    t.t_id,
    t.t_code
ORDER BY
    t.t_code;
GO


/*
Q2: How many players are assigned to each playing position?
Original Question Author: Your Name

A2: I will join tblPositionDim to tblPlayerDim using p_id.
I will count the player IDs assigned to each position.
This will help compare the number of players in each position.
*/

SELECT
    pos.p_id,
    pos.p_code,
    pos.p_name,
    COUNT(p.pl_id) AS PlayerCount
FROM dbo.tblPositionDim AS pos
LEFT JOIN dbo.tblPlayerDim AS p
    ON pos.p_id = p.p_id
GROUP BY
    pos.p_id,
    pos.p_code,
    pos.p_name
ORDER BY
    pos.p_name;
GO


/*
Q3: What is the total month-to-date salary for players on each team?
Original Question Author: Your Name

A3: I will join tblTeamDim, tblPlayerDim, and tblPlayerFact.
The tables will be connected using t_id and pl_id.
I will use the latest salary reporting date and calculate
the total month-to-date salary for each team.
*/

WITH LatestDate AS
(
    SELECT MAX(as_of_date) AS LatestAsOfDate
    FROM dbo.tblPlayerFact
)
SELECT
    t.t_id,
    t.t_code,
    SUM(f.mtd_salary) AS TotalMonthToDateSalary
FROM dbo.tblTeamDim AS t
INNER JOIN dbo.tblPlayerDim AS p
    ON t.t_id = p.t_id
INNER JOIN dbo.tblPlayerFact AS f
    ON p.pl_id = f.pl_id
INNER JOIN LatestDate AS ld
    ON f.as_of_date = ld.LatestAsOfDate
GROUP BY
    t.t_id,
    t.t_code
ORDER BY
    TotalMonthToDateSalary DESC;
GO


/*
Q4: What is the average month-to-date salary for each player position?
Original Question Author: Your Name

A4: I will join tblPositionDim, tblPlayerDim, and tblPlayerFact
using p_id and pl_id. I will use the latest salary reporting date
and calculate the average salary for each playing position.
*/

WITH LatestDate AS
(
    SELECT MAX(as_of_date) AS LatestAsOfDate
    FROM dbo.tblPlayerFact
)
SELECT
    pos.p_id,
    pos.p_name,
    AVG(CAST(f.mtd_salary AS DECIMAL(18,2))) AS AverageMonthToDateSalary
FROM dbo.tblPositionDim AS pos
INNER JOIN dbo.tblPlayerDim AS p
    ON pos.p_id = p.p_id
INNER JOIN dbo.tblPlayerFact AS f
    ON p.pl_id = f.pl_id
INNER JOIN LatestDate AS ld
    ON f.as_of_date = ld.LatestAsOfDate
GROUP BY
    pos.p_id,
    pos.p_name
ORDER BY
    AverageMonthToDateSalary DESC;
GO
