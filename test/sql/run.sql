-- Insert an asynchronous job that must be executed later
TRUNCATE TABLE dbms_job.all_scheduler_job_run_details;
TRUNCATE TABLE dbms_job.all_scheduled_jobs;
SET ROLE regress_dbms_job_user;
DO $$
DECLARE
jobid bigint;
BEGIN
	-- Scheduled job that will be executed in 3 seconds
	-- and each 10 seconds after that.
	SELECT dbms_job.submit(
		'CREATE TABLE IF NOT EXISTS t1 (id integer); ALTER TABLE t1 OWNER TO regress_dbms_job_user; INSERT INTO t1 VALUES (1);', -- what
		LOCALTIMESTAMP + '3 seconds'::interval, -- start the job in 3 seconds
		'LOCALTIMESTAMP + ''6 seconds''::interval' -- repeat the job every 6 seconds
	) INTO jobid;
END;
$$;
