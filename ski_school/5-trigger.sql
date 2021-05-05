USE ski_school;

-- функция проверки доступности инструктора в заданные часы
DELIMITER //
DROP FUNCTION IF EXISTS instructor_is_available//
CREATE FUNCTION instructor_is_available( f_instructor_id BIGINT,  f_start_time DATETIME,  f_end_time DATETIME, lesson_id BIGINT)
RETURNS BOOL
BEGIN 
	DECLARE lessons_count INT;
	SELECT count(*) INTO lessons_count FROM lessons WHERE lessons.instructor_id = f_instructor_id AND (
			f_start_time BETWEEN lessons.start_time AND lessons.end_time OR 
			f_end_time BETWEEN lessons.start_time AND lessons.end_time
		) AND IF(lesson_id > 0, lessons.id != lesson_id, 1);
	IF 	lessons_count > 0 THEN 
		RETURN FALSE;
	ELSE 
		RETURN TRUE;
	END IF;
END//


-- триггер для добавления нового занятия
DROP TRIGGER IF EXISTS check_schedule_create_lessons//
CREATE TRIGGER check_schedule_create_lessons BEFORE INSERT ON lessons
FOR EACH ROW 
BEGIN 
	IF NEW.start_time > NEW.end_time THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'start time cannot be later then end time';
	END IF;
	IF !instructor_is_available(NEW.instructor_id, NEW.start_time, NEW.end_time, 0) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'this time is not free';
	END IF;
END//


-- триггер для изменения нового занятия
DROP TRIGGER IF EXISTS check_schedule_update_lessons//
CREATE TRIGGER check_schedule_update_lessons BEFORE UPDATE ON lessons
FOR EACH ROW 
BEGIN 
	IF NEW.start_time > NEW.end_time THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'start time cannot be later then end time';
	END IF;
	IF !instructor_is_available(NEW.instructor_id, NEW.start_time, NEW.end_time, OLD.id) THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'this time is not free';
	END IF;
END//
DELIMITER ;
