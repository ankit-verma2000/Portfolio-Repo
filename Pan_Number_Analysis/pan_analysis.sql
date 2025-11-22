Use Projects;
IF OBJECT_ID('pan_number_dataset', 'U') IS NOT NULL
    DROP TABLE pan_number_dataset;
GO

CREATE TABLE pan_number_dataset 
(
    pan_number varchar(22)
)
select * from pan_number_dataset;

-- Data Insertion;
Bulk insert pan_number_dataset
from 'D:\webconvoy\SQL\project_5\PAN Card Validation in SQL - Scripts\PAN_Dataset.csv'
WITH
(
    FIELDTERMINATOR = '\n',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

select * from pan_number_dataset;

-- Data Cleaning and Preprocessing:
-- Find n handle the missing data:
select count(*) counts
from pan_number_dataset where pan_number is null;

-- check for duplicates:
select pan_number, count(*) as counts
from pan_number_dataset
group by pan_number
having count(*)>1;

-- Handle the extra spaces:
select * from pan_number_dataset
where pan_number <> trim(pan_number);

-- handle the letter case:
select * from pan_number_dataset 
where pan_number <> upper(pan_number);

-- cleaned pan number:
select distinct trim(pan_number) as pan_number
from pan_number_dataset 
where pan_number is not null
and pan_number <> '';

-- ====================Pan format validation======================

-- Function to check if adjacenet character are the same -- 
CREATE FUNCTION dbo.fn_check_adjacent_characters (@p_str VARCHAR(200))
RETURNS BIT -- retune 1 or 0 (Boolean is not supported in sql server)
AS -- start the body of the function
BEGIN
    -- declare the loop variable:
    DECLARE @i INT = 1, -- @1->loop counter, starting at position 1 of the string
            @len INT = LEN(@p_str); -- @len ->total length of the string

    -- Loop from 1 to length - 1
    WHILE @i < @len  -- while loop starts
    BEGIN
        IF SUBSTRING(@p_str, @i, 1) = SUBSTRING(@p_str, @i + 1, 1)
        BEGIN
            RETURN 1;  -- characters are adjacent & same
        END

        SET @i = @i + 1;
    END

    RETURN 0;   -- none of the adjacent characters were the same
END;
GO
-- cross checking:
select dbo.fn_check_adjacent_characters('ZZOVO')


-- all five character cannot form a sequence(ABCDE) (BCDEF) ❌, (ABCDX)✔
-- Function to check if sequential character are user?
-- select ascii('A')
CREATE FUNCTION dbo.fn_check_sequential_characters (@p_str VARCHAR(200))
RETURNS BIT
AS
BEGIN
    DECLARE @i INT = 1,
            @len INT = LEN(@p_str);

    WHILE @i < @len --Loop runs from character position 1 to length-1(len-1--> because we compare current char with next char)
    BEGIN
        IF ASCII(SUBSTRING(@p_str, @i + 1, 1)) - ASCII(SUBSTRING(@p_str, @i, 1)) <> 1
        BEGIN
            RETURN 0;   -- string does NOT form a sequence
        END

        SET @i = @i + 1;
    END;

    RETURN 1;   -- string IS forming a sequence
END;
GO

select dbo.fn_check_sequential_characters('ABCDE') -- true


-- Regular expressioin to validate the pattern  or structure of the pan number?
SELECT pan_number
FROM pan_number_dataset
WHERE LEN(pan_number) = 10
AND pan_number LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]';



-- 3 .valid and invalid pan categorizatioin :
create view vw_valid_invalid_pans
as 
with cte_cleaned_pan as (
    select distinct trim(pan_number) as pan_number
    from pan_number_dataset 
    where pan_number is not null
    and pan_number <> ''
),
cte_valid_pans as (
    select pan_number
    from cte_cleaned_pan
    where dbo.fn_check_adjacent_characters(pan_number)= 0
    and dbo.fn_check_sequential_characters(substring(pan_number, 1, 5)) = 0 
    and dbo.fn_check_sequential_characters(substring(pan_number, 6, 4)) = 0 
    and pan_number LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]'
)
select 
    cld.pan_number, 
    case
        when vld.pan_number is not null 
        then 'Valid'
        else 'Invalid'
    end as pan_no_status
from cte_cleaned_pan as cld
left join cte_valid_pans as vld
on cld.pan_number = vld.pan_number;


select * from vw_valid_invalid_pans;


-- 4. Summary report:
with cte as (
    select 
        (select count(*) 
        from pan_number_dataset) as total_processed_records,
        count(case 
            when pan_no_status = 'Valid'
            then 1
        end) as total_valid_pan,
        count(case 
            when pan_no_status = 'Invalid'
            then 1
        end) as total_invalid_pan
    from vw_valid_invalid_pans)
select total_processed_records, total_valid_pan, total_invalid_pan,
(total_processed_records - (total_valid_pan + total_invalid_pan)) as total_missing_pans
from cte;


