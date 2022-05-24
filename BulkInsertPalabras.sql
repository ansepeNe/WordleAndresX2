
alter table palabras alter column nombre varchar(100)
BULK INSERT palabras FROM '/var/opt/mssql/backup/Palabras.csv'
WITH (
FIELDTERMINATOR = ',' , ROWTERMINATOR = '0x0a'
)

update palabras set nombre = left(nombre,5)
alter table palabras alter column nombre varchar(5)

--select nombre,'|'+nombre+'|' from palabras