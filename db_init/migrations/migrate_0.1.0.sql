BEGIN;
DO
$$
    BEGIN
        RAISE NOTICE 'Migration successfully applied!';
    END
$$;
COMMIT;
