SELECT 'list' as name,pg_size_pretty(pg_table_size('immolist'))
union
SELECT 'immolog' as name, pg_size_pretty(pg_table_size('immolog'))