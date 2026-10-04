select *
from layoffs;
-- 1 remove duplicates
-- 2 Standardize data 

 create table layoffs_staging
 like layoffs;

select *
from layoffs_staging;

insert into layoffs_staging
select *
from layoffs;

select *,
row_number() over(
Partition by company,industry,total_laid_off,percentage_laid_off,`date`) row_num
from layoffs_staging;

with duplicate_cte as
(
select *,
row_number() over(
Partition by company,industry,location,country,stage,funds_raised_millions,total_laid_off,percentage_laid_off,`date`) row_num
from layoffs_staging
)
SELECT *
from duplicate_cte
where row_num > 1;

CREATE TABLE `layoffs_staging6` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging6
select *,
row_number() over(
Partition by company,industry,location,country,stage,funds_raised_millions,total_laid_off,percentage_laid_off,`date`) row_num
from layoffs_staging;

-- delete the duplicates: row_num > 1 means the row repeats an earlier one
delete
from layoffs_staging6
where row_num > 1;

select `date`
from layoffs_staging6;

update layoffs_staging6
set `date` = str_to_date(`date`, '%m/%d/%Y');

select company,trim(company)
from layoffs_staging6;

update layoffs_staging6
set company = trim(company);
update layoffs_staging6
set industry = 'crypto'
where industry like 'crypto%';
update layoffs_staging6
set country = "United States"
where country like 'United States%';

alter table layoffs_staging6
modify column `date` date;

select * 
from layoffs_staging6
where industry is null ;

select *
from layoffs_staging6;

select t1.company,t1.industry,t2.industry
from layoffs_staging6 t1
inner join layoffs_staging6 t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry =  '')
and t2.industry is not null ;

update layoffs_staging6 t1
join layoffs_staging6 t2
	on t1.company = t2.company
	and t1.location = t2.location
set t1.industry = t2.industry 
where t1.industry is null
and t2.industry is not null ;

update layoffs_staging6
set industry = null
where industry = '';

alter table layoffs_staging6
drop column row_num;

select *
from layoffs_staging6;