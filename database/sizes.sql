SELECT pg_size_pretty(pg_table_size('immolist'))
union
SELECT pg_size_pretty(pg_table_size('immolog'))