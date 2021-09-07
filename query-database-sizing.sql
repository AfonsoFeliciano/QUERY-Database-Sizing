

USE AdventureWorksDW2012

SELECT 
    t.NAME AS NOMETABLE,
    s.Name AS NOMESCHEMA,
    p.rows QUANTIDADELINHAS,
    SUM(a.total_pages) * 8 AS TOTALESPACOKB, 
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TOTALESPACOMB,
    SUM(a.used_pages) * 8 AS ESPACOUSADOKB, 
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS ESPACOUSADOMB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS ESPACONAOUTILIZADOKB,
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS ESPACONAOUTILIZADOMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
LEFT  JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE 1=1
    AND t.NAME NOT LIKE 'dt%' 
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
GROUP BY 
    t.Name, 
	s.Name, 
	p.Rows

ORDER BY 
    TOTALESPACOMB DESC, 
	t.Name