-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 27, 2018 at 02:54 PM
-- Server version: 10.1.26-MariaDB
-- PHP Version: 7.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vkvxweok_mbd_05111640000011`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `sp_changepassword`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_changepassword` (`p_uname` VARCHAR(50), `p_oldpass` VARCHAR(50), `p_newpass` VARCHAR(50))  proc:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	SELECT `USER_PASSWORD`, `USER_NAME` FROM `user` WHERE `USER_UNAME`=p_uname
			INTO @password, @Name;
					
		IF (@password != MD5(p_oldpass)) THEN
			SELECT -1, "GAGAL ! username / password tidak dikenal";
			LEAVE proc;
		END IF;
				
		IF (p_oldpass = p_newpass) THEN
			SELECT -1, "GAGAL ! password baru tak boleh sama dg password lama";
			LEAVE proc;
		END IF;
		UPDATE `user` SET `USER_PASSWORD`=MD5(p_newpass) WHERE `USER_UNAME`=p_uname;
		SELECT 0,"ubah password SUKSES !";
		commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_getmaxexp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getmaxexp` (`p_level` INT(11))  BEGIN
	select LEVEL_MAX_EXP FROM level_user WHERE LEVEL_ID = p_level;

	END$$

DROP PROCEDURE IF EXISTS `sp_getmaxstamina`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getmaxstamina` (`p_level` INT(11))  BEGIN
		SELECT LEVEL_MAX_STAMINA FROM level_user WHERE LEVEL_ID = p_level;
	END$$

DROP PROCEDURE IF EXISTS `sp_getusercourse`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getusercourse` (`p_userid` INT(11))  BEGIN
		SELECT uc.`USER_COURSE_START`, c.COURSE_NAME FROM user_course uc JOIN course c ON (uc.COURSE_ID = c.COURSE_ID AND uc.USER_ID=p_userid);

	END$$

DROP PROCEDURE IF EXISTS `sp_getuserequip`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getuserequip` (`p_userid` INT(11))  BEGIN
		SELECT e.`UPGRADE_NAME`, ue.`USER_EQUIPMENT_LEVEL` FROM user_equipment ue JOIN equipment e ON (ue.UPGRADE_ID = e.UPGRADE_ID AND ue.USER_ID = p_userid);
	END$$

DROP PROCEDURE IF EXISTS `sp_getuserid`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getuserid` (IN `p_username` VARCHAR(15))  BEGIN
		SELECT USER_ID FROM `user` WHERE USER_UNAME = `p_username`;

	END$$

DROP PROCEDURE IF EXISTS `sp_getuserjob`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getuserjob` (`p_userid` INT(11))  BEGIN
		SELECT uj.`USER_JOB_START`,j.JOB_NAME FROM user_job uj JOIN job j  ON ( uj.JOB_ID = j.JOB_ID AND uj.USER_ID = p_userid) 
		order BY uj.`USER_JOB_START` DESC;
	END$$

DROP PROCEDURE IF EXISTS `sp_getuserskill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getuserskill` (`p_userid` INT(11))  BEGIN
		SELECT s.SKILL_NAME FROM user_skill uk JOIN skill s ON (uk.SKILL_ID = s.SKILL_ID AND uk.USER_ID=p_userid);
	END$$

DROP PROCEDURE IF EXISTS `sp_getuserstats`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getuserstats` (`p_userid` INT(11))  BEGIN
		SELECT `LEVEL_ID`, `USER_EXP`, `USER_MONEY`, `USER_STAMINA` FROM `user` WHERE `USER_ID` = p_userid;
	END$$

DROP PROCEDURE IF EXISTS `sp_leaderboard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_leaderboard` ()  BEGIN
		SELECT `USER_UNAME`, `LEVEL_ID` from `user` order by `LEVEL_ID` DESC;
	END$$

DROP PROCEDURE IF EXISTS `sp_levelupdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_levelupdate` (`p_usrid` INT, `p_dx` INT)  BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	select `USER_EXP`, `LEVEL_ID` from `user` where `USER_ID` = p_usrid into @x0, @l0;
	set @xt = @x0 + p_dx;
	select `maximum_parameter` from `maximum` where `maximum_category` = "usrlvl" into @maxlv;
	select `LEVEL_MAX_EXP` from `level_user` where `LEVEL_ID` = @l0 into @max;
	IF(@maxlv > @l0) then
	if(@xt < @max) then
		UPDATE `user` SET `USER_EXP` = @xt WHERE `USER_ID` = p_usrid;
	else
		UPDATE `user` SET `USER_EXP` = 0, `LEVEL_ID` = @l0 + 1 where `USER_ID` = p_usrid; 
	end if;	

	end if;
	commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_listcourse`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listcourse` ()  BEGIN
		SELECT `COURSE_ID`, `COURSE_NAME`, `SKILL_NAME`, `COURSE_DESCRIPTION`, `COURSE_STAMINA`, `COURSE_DURATION`, `COURSE_COST`, `COURSE_EXPERIENCE` FROM `course` JOIN `skill` ON `course`.`SKILL_ID` = `skill`.`SKILL_ID`;
	END$$

DROP PROCEDURE IF EXISTS `sp_listequip`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listequip` (IN `p_userid` INT(11))  BEGIN		(SELECT `equipment`.`UPGRADE_ID`, `USER_ID`,`UPGRADE_NAME`, `USER_EQUIPMENT_LEVEL`, `UPGRADE_COST`, `UPGRADE_LEVELCOST` FROM `equipment` JOIN `user_equipment` ON `equipment`.`UPGRADE_ID` = `user_equipment`.`UPGRADE_ID` AND `user_equipment`.`USER_ID`= p_userid)
		UNION
		(select `equipment`.`UPGRADE_ID`,`USER_ID`,`UPGRADE_NAME` ,`USER_EQUIPMENT_LEVEL`, `UPGRADE_COST`, `UPGRADE_LEVELCOST` from `equipment` LEFT JOIN `user_equipment` ON `equipment`.`UPGRADE_ID` = `user_equipment`.`UPGRADE_ID` AND `user_equipment`.`USER_ID`= p_userid);
	END$$

DROP PROCEDURE IF EXISTS `sp_listjob`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listjob` ()  BEGIN
		select `job`.`JOB_ID`, `job`.`JOB_NAME`, `job`.`JOB_DURATION`, `job`.`JOB_EXPERIENCE`, `job`.`JOB_PAYMENT`, `job`.`JOB_STAMINA` , group_concat(distinct `SKILL_NAME` separator ', ') as 'REQ_SKILL', group_concat( `equipment`.`UPGRADE_NAME` separator ',') as 'REQ_EQ_NAME' , group_concat(`JOB_EQUIPMENT_LEVEL` separator ',') as 'REQ_EQ_LV'
		from `job` JOIN `job_skill` ON `job`.`JOB_ID` = `job_skill`.`JOB_ID`
		JOIN `skill` ON `skill`.`SKILL_ID` = `job_skill`.`SKILL_ID`
		JOIN `job_equipment` ON `job`.`JOB_ID` = `job_equipment`.`JOB_ID`
		JOIN `equipment` ON `equipment`.`UPGRADE_ID` = `job_equipment`.`UPGRADE_ID`
		group by `job`.`JOB_ID`;
	END$$

DROP PROCEDURE IF EXISTS `sp_login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login` (`p_uname` VARCHAR(50), `p_password` VARCHAR(50))  BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	IF EXISTS(SELECT 1 FROM `user` 
		WHERE `USER_UNAME`=p_uname AND `USER_PASSWORD`= MD5(p_password)) THEN
		SELECT 0, "login sukses";
	ELSE
		SELECT -1, "maaf username / password tidak dikenal";	
	END IF;
	commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_register`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_register` (`p_uname` VARCHAR(15), `p_password` VARCHAR(32), `p_name` VARCHAR(20))  BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	IF NOT EXISTS (SELECT 1 FROM `user` WHERE `USER_UNAME`=p_uname) THEN
		INSERT INTO `user` (`LEVEL_ID`, `USER_NAME`, `USER_UNAME`, `USER_PASSWORD`, `USER_EXP`, `USER_MONEY`, `USER_STAMINA`, `USER_LASTACTION`)  
		VALUES (1, p_name, p_uname, MD5(p_password), 0, 1500, 10, NOW());
		SELECT 0, 'pendaftaran sukses';
	ELSE 
		SELECT -1, 'Gagal, username sudah terdaftar!';
	END IF;
	commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_takecourse`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_takecourse` (`p_usrid` INT, `p_courseid` INT)  BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	/*CALL sp_updatestamina(p_usrid);*/
	select `USER_MONEY`, `USER_STAMINA` from `user` where `USER_ID`=p_usrid
	into @usrbal, @st;
	
	select `COURSE_STAMINA`, `COURSE_COST` from `course` where `COURSE_ID` = p_courseid
	into @coursest, @coursecost;
	

	select `SKILL_ID` from `course` where `COURSE_ID` = p_courseid into @sid;

	IF(@usrbal < @coursecost) then 
		select -1, "Uang tidak cukup";
	/*else if(EXISTS(Select * from `user_course` where `USER_ID` = p_usrid and `COURSE_ID` = p_courseid)) then
		select -1, "Tidak dapat mengambil Course yang sama sekaligus";*/
	else if (@st < @coursest) then 
		select -1, "stamina tidak cukup";
	else if(exists(select * from `user_skill` where `USER_ID` = p_usrid and `SKILL_ID` = @sid)) then
		select -1, "sudah memiliki skill";
	else 
		update `user` set `USER_MONEY` = @usrbal - @coursecost, `USER_STAMINA` = @st - @coursest, `USER_LASTACTION`=now() where `USER_ID` = p_usrid;

		insert into `user_course`(`USER_ID`, `COURSE_ID`, `USER_COURSE_START`) values (p_usrid, p_courseid, now());
		Select 0, "Sukses mengambil course";
	end if;
	end if;
	end if;
	-- end if;
	commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_takecoursereward`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_takecoursereward` (`p_usrid` INT, `p_cid` INT)  BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	if not exists(select `USER_COURSE_START` from `user_course` where `USER_ID` = p_usrid and `COURSE_ID` = p_cid) then
		select -1, "Course not found";
	else
		select `USER_COURSE_START` from `user_course` WHERE `USER_ID` = p_usrid AND `COURSE_ID` = p_cid into @t0;
		select `COURSE_DURATION`, `COURSE_EXPERIENCE` from `course` where `COURSE_ID` = p_cid into @dt, @dx;
		select `USER_EXP` from `user` where `USER_ID` = p_usrid into @x0;
		
		if(@dt > timestampdiff(second, @t0, now())) then 
			select -1, "Course has yet ended";
		else
			select `SKILL_ID` from `course` where `COURSE_ID` = p_cid into @s1;
			set @xt = @x0 + @dx;
			call sp_levelupdate(p_usrid, @xt);
			insert into `user_skill`(`USER_ID`, `SKILL_ID`) values (p_usrid, @s1);
			delete from `user_course` where `USER_ID` = p_usrid and `COURSE_ID` = p_cid;
			select 0, "Course's reward successfully taken";
		end if;
	end if;
	commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_takejob`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_takejob` (`p_usrid` INT, `p_jid` INT)  BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	if(fn_isjobavailable(p_usrid, p_jid)) then
		select `JOB_PAYMENT`, `JOB_STAMINA` from `job` where `JOB_ID` = p_jid into @dm, @ds;
		select `USER_MONEY`, `USER_STAMINA` from `user` where `USER_ID` = p_usrid into @m0, @s0;

		insert into `user_job` (`USER_ID`,`JOB_ID`,`USER_JOB_START`) values (p_usrid, p_jid, now());
		update `user` set `USER_STAMINA` = @s0 - @ds, `USER_LASTACTION` = now() where `USER_ID` = p_usrid;
		select 0, "Take job success";
	else 
		select -1, "Job unavailable";
	end if;
	commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_takejobreward`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_takejobreward` (`p_usrid` INT, `p_jid` INT)  BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	if not exists(select `USER_JOB_START` from `user_job` where `USER_ID` = p_usrid and `JOB_ID` = p_jid) then 
		select -1, "Job Not Found";
	else
		SELECT `USER_JOB_START` FROM `user_job` WHERE `USER_ID` = p_usrid AND `JOB_ID` = p_jid into @t0;
		set @time = timestampdiff(second, @t0, now());
		select `JOB_DURATION` from `job` where `JOB_ID` = p_jid into @t;
			select `JOB_PAYMENT`, `JOB_EXPERIENCE` from `job` where `JOB_ID` = p_jid into @dm, @dx;
			select `USER_MONEY`, `USER_EXP` from `user` where `USER_ID` = p_usrid into @m0, @x0;
			set @x = @x0 + @dx;
			call sp_levelupdate(p_usrid, @dx);
			update `user` set `USER_MONEY` = @m0 + @dm where `USER_ID` = p_usrid; 
			delete from `user_job` where `USER_ID` = p_usrid and `JOB_ID` = p_jid;
			select 0, "Job Reward taken";

	end if;
	commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_updatestamina`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updatestamina` (`p_usrid` INT)  BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	set @st = fn_stamina(p_usrid);
	update `user` set `USER_STAMINA` = @st, `USER_LASTACTION`=now() where `USER_ID` = p_usrid;
	Select @st;
	commit;
	END$$

DROP PROCEDURE IF EXISTS `sp_upgrade`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_upgrade` (`p_usrid` INT, `p_upgrid` INT)  BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION, NOT FOUND
BEGIN
	ROLLBACK;
	-- LEAVE proc;
END;
	start transaction;
	select `maximum_parameter` from `maximum` where `maximum_category` = "equiplvl" into @maxup;

	select `USER_MONEY` from `user` where `USER_ID` = p_usrid into @usrbal;
	set @cost = fn_upgradecost(p_upgrid, p_usrid);
	if(@cost > @usrbal) then 
		select -1, "Uang tidak cukup";
	else
		update `user` set `USER_MONEY` = @usrbal - @cost where `USER_ID` = p_usrid;
		select `UPGRADE_TIME` from `equipment` where `UPGRADE_ID` = p_upgrid into @dt;
		IF(EXISTS(SELECT p_upgrid FROM `user_equipment` WHERE `USER_ID` = p_usrid AND `UPGRADE_ID` = p_upgrid)) then 
			select `USER_EQUIPMENT_LEVEL`, `USER_EQUIPMENT_REDUCTION` from `user_equipment` 
			where `USER_ID` = p_usrid and `UPGRADE_ID` = p_upgrid into @lv, @t0;
			if(@lv = @maxup) then select -1, "Reached Maximum level";
			else
			update `user_equipment` set `USER_EQUIPMENT_LEVEL` = @lv + 1, `USER_EQUIPMENT_REDUCTION` = @t0+@dt 
			where `USER_ID` = p_usrid AND `UPGRADE_ID` = p_upgrid;
			end if;

		else 
			insert into `user_equipment` (`USER_ID`, `UPGRADE_ID`, `USER_EQUIPMENT_LEVEL`, `USER_EQUIPMENT_REDUCTION`) 
			values (p_usrid, p_upgrid, 1, @dt);
		end if;
		select 0, "upgrade success";
	end if;
	commit;
	END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `fn_getcourseduration`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_getcourseduration` (`f_courseid` INT(11)) RETURNS TIMESTAMP BEGIN
	SELECT `COURSE_DURATION` FROM `course` WHERE `COURSE_ID` = f_courseid INTO @res;
	RETURN @res;
    END$$

DROP FUNCTION IF EXISTS `fn_getjobduration`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_getjobduration` (`f_jobid` INT(11)) RETURNS TIMESTAMP BEGIN
	SELECT `JOB_DURATION` from `job` where `JOB_ID` = f_jobid INTO @res;
	return @res;
    END$$

DROP FUNCTION IF EXISTS `fn_isdone`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_isdone` (`f_start` TIMESTAMP, `f_duration` INT(11)) RETURNS TINYINT(1) BEGIN
	RETURN NOW() > (f_start + interval f_duration SECOND);
    END$$

DROP FUNCTION IF EXISTS `fn_isjobavailable`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_isjobavailable` (`f_usrid` INT, `f_jid` INT) RETURNS TINYINT(1) BEGIN
	-- call sp_updatestamina(f_usrid);
	if(exists(select * from `user_job` where `JOB_ID` = f_jid and `USER_ID` = f_usrid)) then
		return 0;
	else
		select `maximum_parameter` from `maximum` where `maximum_category` = "jobtaken" LIMIT 1 into @jm;
		SELECT COUNT(*) FROM `user_job` WHERE `USER_ID` = f_usrid into @cj;
		
		if(@jm > @cj) then
			select `USER_STAMINA` from `user` where `USER_ID` = f_usrid  LIMIT 1 into @s0;
			select `JOB_STAMINA` from `job` where `JOB_ID` = f_jid LIMIT 1 into @s1;
			select count(*) from `user_skill` a, `job_skill` b where b.`JOB_ID` = f_jid and a.`USER_ID` = f_usrid and b.`SKILL_ID` = a.`SKILL_ID` LIMIT 1 into @n0;
			select count(*) from `job_skill` where `JOB_ID` = f_jid into @n1;
			select count(*) from `job_equipment` a, `user_equipment` b where a.`JOB_ID` = f_jid and b.`USER_ID` = f_usrid and a.`UPGRADE_ID` = b.`UPGRADE_ID` and (a.`JOB_EQUIPMENT_LEVEL` = b.`USER_EQUIPMENT_LEVEL` or a.`JOB_EQUIPMENT_LEVEL` < b.`USER_EQUIPMENT_LEVEL`) LIMIT 1 into @n2;
			select count(*) from `job_equipment` where `JOB_ID` = f_jid into @n3;

			if(@s0 < @s1) then
				return 0;
			else if(@n1 > @n0) then
				return 0;
			else if(@n3 > @n2) then
				return 0;
			else 
				return 1;
			END IF;
		END IF;
	END IF;
	else
		return 0;
	end if;
	end if;
    END$$

DROP FUNCTION IF EXISTS `fn_isuserfree`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_isuserfree` (`f_id` INT) RETURNS TINYINT(1) BEGIN
	SET @tjob = exists(select 1 from `user_job`  where `USER_ID` = f_id AND fn_isdone(`USER_JOB_START`, fn_getjobduration(`JOB_ID`)) = 0);
	SET @tcourse = EXISTS(SELECT 1 FROM `user_course` where `USER_ID` = f_id AND fn_isdone(`USER_COURSE_START`, fn_getcourseduration(`COURSE_ID`))= 0);
	return NOT(@tjob or @tcourse);
END$$

DROP FUNCTION IF EXISTS `fn_jobtime`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_jobtime` (`f_uid` INT, `f_jid` INT) RETURNS INT(11) BEGIN
	select `JOB_DURATION` from `job` where `JOB_ID` = f_jid into @t0;
	select sum(`USER_EQUIPMENT_REDUCTION`) from `user_equipment` a, `job_equipment` b where b.`JOB_ID` = f_jid and a.`USER_ID` = f_uid and b.`UPGRADE_ID` = a.`UPGRADE_ID` into @dt;
	if(@t0 -@dt < 0) then
	return 0;
	else	
	return @t0 - @dt;
	end if;
    END$$

DROP FUNCTION IF EXISTS `fn_stamina`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_stamina` (`f_id` INT) RETURNS INT(11) BEGIN
	select `LEVEL_ID`, `USER_STAMINA`, `USER_LASTACTION` from `user` where `USER_ID`=f_id
	into @lv, @s0, @t0;
	select `LEVEL_MAX_STAMINA`, `LEVEL_STAMINA_PER_MINUTE` from `level_user` where `LEVEL_ID` = @lv
	into @max, @ds;
	set @st = @s0 + timestampdiff(minute, @t0, now()) * @ds;
	if(@st > @max) then 
		set @st = @max;
	end if;
	return @st;
    END$$

DROP FUNCTION IF EXISTS `fn_upgradecost`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_upgradecost` (`f_upid` INT, `f_uid` INT) RETURNS INT(11) BEGIN
	select `UPGRADE_LEVELCOST`, `UPGRADE_COST` from `equipment` where `UPGRADE_ID` = f_upid into @dc, @c0;
	select `USER_EQUIPMENT_LEVEL` from `user_equipment` where `USER_ID`=f_uid and `UPGRADE_ID`=f_upid into @lv;
	set @ct = @c0 + @dc*@lv;
	return @ct;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `COURSE_ID` int(11) NOT NULL,
  `SKILL_ID` int(11) DEFAULT NULL,
  `COURSE_NAME` varchar(30) DEFAULT NULL,
  `COURSE_DESCRIPTION` varchar(30) DEFAULT NULL,
  `COURSE_STAMINA` int(11) DEFAULT NULL,
  `COURSE_DURATION` int(11) DEFAULT NULL,
  `COURSE_COST` int(11) DEFAULT NULL,
  `COURSE_EXPERIENCE` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`COURSE_ID`, `SKILL_ID`, `COURSE_NAME`, `COURSE_DESCRIPTION`, `COURSE_STAMINA`, `COURSE_DURATION`, `COURSE_COST`, `COURSE_EXPERIENCE`) VALUES
(1, 1, 'C++ Learning', 'Acquire C++ Skill', 1, 10, 0, 5),
(2, 5, 'Database - mysql Course', 'Acquire mysql Skill', 3, 60, 300, 15),
(3, 2, 'Web Learning : html', 'Acquire html Skill', 5, 180, 600, 20),
(4, 3, 'Web Learning : css', 'Acquire css Skill', 6, 300, 900, 25),
(5, 4, 'Web Learning : php', 'Acquire php Skill', 7, 480, 2400, 30),
(6, 6, 'Web Learning : bootstrap', 'Acquire bootstrap Skill', 8, 720, 900, 35),
(7, 8, 'Graphic Design Course', 'Acquire Graphic Design Skill', 6, 1200, 6000, 20),
(8, 9, 'Animation Course', 'Acquire Animation Skill', 6, 900, 9000, 20),
(9, 7, 'Java Course', 'Acquire Java Skill', 4, 240, 900, 18),
(10, 10, 'Game Engine Learning', 'Acquire Game Engine Skill', 8, 1080, 10000, 25);

-- --------------------------------------------------------

--
-- Table structure for table `equipment`
--

DROP TABLE IF EXISTS `equipment`;
CREATE TABLE `equipment` (
  `UPGRADE_ID` int(11) NOT NULL,
  `UPGRADE_NAME` varchar(40) DEFAULT NULL,
  `UPGRADE_COST` int(11) DEFAULT NULL,
  `UPGRADE_DESCRIPTION` varchar(25) DEFAULT NULL,
  `UPGRADE_TIME` int(11) DEFAULT NULL,
  `UPGRADE_LEVELCOST` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `equipment`
--

INSERT INTO `equipment` (`UPGRADE_ID`, `UPGRADE_NAME`, `UPGRADE_COST`, `UPGRADE_DESCRIPTION`, `UPGRADE_TIME`, `UPGRADE_LEVELCOST`) VALUES
(1, 'Laptop', 500, NULL, 1, 1000),
(2, 'External Storage', 600, NULL, 1, 1200),
(3, 'RAM', 1000, NULL, 1, 2000),
(4, 'VGA', 2000, NULL, 5, 8000),
(5, 'Internet', 1000, NULL, 2, 4000),
(6, 'Game Engine', 4000, NULL, 15, 2000),
(7, 'Image Processing Software', 800, NULL, 10, 3500);

-- --------------------------------------------------------

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
CREATE TABLE `job` (
  `JOB_ID` int(11) NOT NULL,
  `JOB_NAME` varchar(40) DEFAULT NULL,
  `JOB_DESCRIPTION` varchar(200) DEFAULT NULL,
  `JOB_EXPERIENCE` int(11) DEFAULT NULL,
  `JOB_PAYMENT` int(11) DEFAULT NULL,
  `JOB_STAMINA` int(11) DEFAULT NULL,
  `JOB_DURATION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `job`
--

INSERT INTO `job` (`JOB_ID`, `JOB_NAME`, `JOB_DESCRIPTION`, `JOB_EXPERIENCE`, `JOB_PAYMENT`, `JOB_STAMINA`, `JOB_DURATION`) VALUES
(1, 'Hello World', NULL, 10, 30, 1, 10),
(2, 'Simple Database', NULL, 30, 60, 1, 60),
(3, 'Web (html)', NULL, 40, 90, 2, 45),
(4, 'Web (css)', NULL, 45, 120, 3, 60),
(5, 'Web (bootstrap)', NULL, 45, 150, 3, 120),
(6, 'Web (database)', NULL, 200, 500, 7, 600),
(7, 'Game (Java)', NULL, 100, 250, 7, 1200),
(8, 'Game (web, database)', NULL, 2000, 2000, 8, 2400),
(9, 'Game (Engine)', NULL, 4000, 4000, 10, 6000),
(10, 'Logo Design', NULL, 20, 300, 4, 6000),
(11, 'Promotional Animation Design', NULL, 20, 500, 6, 6000);

-- --------------------------------------------------------

--
-- Table structure for table `job_equipment`
--

DROP TABLE IF EXISTS `job_equipment`;
CREATE TABLE `job_equipment` (
  `JOB_ID` int(11) DEFAULT NULL,
  `UPGRADE_ID` int(11) DEFAULT NULL,
  `JOB_EQUIPMENT_LEVEL` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `job_equipment`
--

INSERT INTO `job_equipment` (`JOB_ID`, `UPGRADE_ID`, `JOB_EQUIPMENT_LEVEL`) VALUES
(1, 1, 1),
(2, 1, 2),
(2, 2, 1),
(3, 1, 3),
(3, 5, 1),
(4, 1, 3),
(4, 4, 1),
(4, 5, 1),
(5, 1, 3),
(5, 4, 1),
(5, 5, 1),
(6, 1, 5),
(6, 2, 3),
(6, 3, 2),
(6, 5, 3),
(7, 1, 5),
(7, 3, 4),
(7, 4, 3),
(7, 7, 1),
(8, 1, 6),
(8, 2, 4),
(8, 3, 4),
(8, 4, 1),
(8, 5, 3),
(8, 7, 1),
(9, 1, 9),
(9, 2, 6),
(9, 3, 6),
(9, 4, 6),
(9, 6, 1),
(10, 7, 3),
(10, 1, 7),
(10, 3, 7),
(10, 4, 6),
(11, 7, 4),
(11, 1, 8),
(11, 3, 5),
(11, 4, 5);

-- --------------------------------------------------------

--
-- Table structure for table `job_skill`
--

DROP TABLE IF EXISTS `job_skill`;
CREATE TABLE `job_skill` (
  `SKILL_ID` int(11) DEFAULT NULL,
  `JOB_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `job_skill`
--

INSERT INTO `job_skill` (`SKILL_ID`, `JOB_ID`) VALUES
(1, 1),
(5, 2),
(2, 3),
(2, 4),
(3, 4),
(2, 5),
(3, 5),
(6, 5),
(2, 6),
(3, 6),
(6, 6),
(5, 6),
(4, 6),
(7, 7),
(8, 7),
(9, 7),
(2, 8),
(3, 8),
(4, 8),
(5, 8),
(6, 8),
(8, 8),
(9, 8),
(8, 9),
(9, 9),
(10, 9),
(8, 10),
(9, 11);

-- --------------------------------------------------------

--
-- Table structure for table `level_user`
--

DROP TABLE IF EXISTS `level_user`;
CREATE TABLE `level_user` (
  `LEVEL_ID` int(11) NOT NULL,
  `LEVEL_MAX_EXP` int(11) DEFAULT NULL,
  `LEVEL_MAX_STAMINA` int(11) DEFAULT NULL,
  `LEVEL_STAMINA_PER_MINUTE` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `level_user`
--

INSERT INTO `level_user` (`LEVEL_ID`, `LEVEL_MAX_EXP`, `LEVEL_MAX_STAMINA`, `LEVEL_STAMINA_PER_MINUTE`) VALUES
(1, 50, 10, 1),
(2, 200, 10, 1),
(3, 400, 10, 1),
(4, 800, 10, 1),
(5, 1600, 11, 1),
(6, 3200, 12, 1),
(7, 9600, 16, 1),
(8, 20000, 18, 2),
(9, 40000, 20, 2),
(10, 80000, 22, 2);

-- --------------------------------------------------------

--
-- Table structure for table `maximum`
--

DROP TABLE IF EXISTS `maximum`;
CREATE TABLE `maximum` (
  `maximum_category` varchar(30) DEFAULT NULL,
  `maximum_parameter` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `maximum`
--

INSERT INTO `maximum` (`maximum_category`, `maximum_parameter`) VALUES
('usrlvl', 10),
('equiplvl', 9),
('jobtaken', 4);

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

DROP TABLE IF EXISTS `skill`;
CREATE TABLE `skill` (
  `SKILL_ID` int(11) NOT NULL,
  `SKILL_NAME` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `skill`
--

INSERT INTO `skill` (`SKILL_ID`, `SKILL_NAME`) VALUES
(1, 'C++'),
(2, 'html'),
(3, 'css'),
(4, 'php'),
(5, 'mysql'),
(6, 'bootstrap'),
(7, 'java'),
(8, 'Graphic Design'),
(9, 'Animation'),
(10, 'Game Engine');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `USER_ID` int(11) NOT NULL,
  `LEVEL_ID` int(11) DEFAULT NULL,
  `USER_NAME` varchar(20) DEFAULT NULL,
  `USER_UNAME` varchar(15) DEFAULT NULL,
  `USER_PASSWORD` char(32) DEFAULT NULL,
  `USER_EXP` int(11) DEFAULT NULL,
  `USER_MONEY` int(11) DEFAULT NULL,
  `USER_STAMINA` int(11) DEFAULT NULL,
  `USER_LASTACTION` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`USER_ID`, `LEVEL_ID`, `USER_NAME`, `USER_UNAME`, `USER_PASSWORD`, `USER_EXP`, `USER_MONEY`, `USER_STAMINA`, `USER_LASTACTION`) VALUES
(4, 2, 'a', 'a', '0cc175b9c0f1b6a831c399e269772661', 25, 5200, 10, '2018-05-27 12:45:48'),
(5, 1, 'b', 'b', '92eb5ffee6ae2fec3ad71c777531578f', 0, 100, 10, '2018-05-23 16:25:03'),
(6, 1, 'c', 'c', '4a8a08f09d37b73795649038408b5f33', 0, 100, 10, '2018-05-23 16:34:57'),
(7, 10, 'dosen', 'dosen', 'e54e7968130c3483281515d83d2811f3', 80000, 100000, 15, '2018-05-27 12:52:44');

-- --------------------------------------------------------

--
-- Table structure for table `user_course`
--

DROP TABLE IF EXISTS `user_course`;
CREATE TABLE `user_course` (
  `USER_ID` int(11) DEFAULT NULL,
  `COURSE_ID` int(11) DEFAULT NULL,
  `USER_COURSE_START` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_equipment`
--

DROP TABLE IF EXISTS `user_equipment`;
CREATE TABLE `user_equipment` (
  `USER_ID` int(11) DEFAULT NULL,
  `UPGRADE_ID` int(11) DEFAULT NULL,
  `USER_EQUIPMENT_LEVEL` int(11) DEFAULT NULL,
  `USER_EQUIPMENT_REDUCTION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_equipment`
--

INSERT INTO `user_equipment` (`USER_ID`, `UPGRADE_ID`, `USER_EQUIPMENT_LEVEL`, `USER_EQUIPMENT_REDUCTION`) VALUES
(4, 1, 8, 8),
(4, 2, 8, 8),
(4, 3, 2, 2),
(5, 2, 1, 1),
(4, 4, 1, 5),
(4, 5, 2, 4),
(4, 6, 2, 30),
(4, 7, 2, 20),
(7, 1, 9, NULL),
(7, 2, 9, NULL),
(7, 3, 9, NULL),
(7, 4, 9, NULL),
(7, 5, 9, NULL),
(7, 6, 9, NULL),
(7, 7, 9, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_job`
--

DROP TABLE IF EXISTS `user_job`;
CREATE TABLE `user_job` (
  `USER_ID` int(11) DEFAULT NULL,
  `JOB_ID` int(11) DEFAULT NULL,
  `USER_JOB_START` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_skill`
--

DROP TABLE IF EXISTS `user_skill`;
CREATE TABLE `user_skill` (
  `USER_ID` int(11) DEFAULT NULL,
  `SKILL_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_skill`
--

INSERT INTO `user_skill` (`USER_ID`, `SKILL_ID`) VALUES
(4, 2),
(4, 5),
(4, 1),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(7, 5),
(7, 6),
(7, 7),
(7, 8),
(7, 9),
(7, 10);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`COURSE_ID`),
  ADD KEY `FK_REFERENCE_20` (`SKILL_ID`);

--
-- Indexes for table `equipment`
--
ALTER TABLE `equipment`
  ADD PRIMARY KEY (`UPGRADE_ID`);

--
-- Indexes for table `job`
--
ALTER TABLE `job`
  ADD PRIMARY KEY (`JOB_ID`);

--
-- Indexes for table `job_equipment`
--
ALTER TABLE `job_equipment`
  ADD KEY `JOB_ID` (`JOB_ID`),
  ADD KEY `UPGRADE_ID` (`UPGRADE_ID`);

--
-- Indexes for table `job_skill`
--
ALTER TABLE `job_skill`
  ADD KEY `JOB_ID` (`JOB_ID`),
  ADD KEY `SKILL_ID` (`SKILL_ID`);

--
-- Indexes for table `level_user`
--
ALTER TABLE `level_user`
  ADD PRIMARY KEY (`LEVEL_ID`);

--
-- Indexes for table `skill`
--
ALTER TABLE `skill`
  ADD PRIMARY KEY (`SKILL_ID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`USER_ID`),
  ADD KEY `LEVEL_ID` (`LEVEL_ID`);

--
-- Indexes for table `user_course`
--
ALTER TABLE `user_course`
  ADD KEY `USER_ID` (`USER_ID`),
  ADD KEY `COURSE_ID` (`COURSE_ID`);

--
-- Indexes for table `user_equipment`
--
ALTER TABLE `user_equipment`
  ADD KEY `USER_ID` (`USER_ID`),
  ADD KEY `UPGRADE_ID` (`UPGRADE_ID`);

--
-- Indexes for table `user_job`
--
ALTER TABLE `user_job`
  ADD KEY `USER_ID` (`USER_ID`),
  ADD KEY `JOB_ID` (`JOB_ID`);

--
-- Indexes for table `user_skill`
--
ALTER TABLE `user_skill`
  ADD KEY `USER_ID` (`USER_ID`),
  ADD KEY `SKILL_ID` (`SKILL_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `COURSE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `job`
--
ALTER TABLE `job`
  MODIFY `JOB_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `SKILL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `USER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `job_equipment`
--
ALTER TABLE `job_equipment`
  ADD CONSTRAINT `job_equipment_ibfk_1` FOREIGN KEY (`JOB_ID`) REFERENCES `job` (`JOB_ID`),
  ADD CONSTRAINT `job_equipment_ibfk_2` FOREIGN KEY (`UPGRADE_ID`) REFERENCES `equipment` (`UPGRADE_ID`);

--
-- Constraints for table `job_skill`
--
ALTER TABLE `job_skill`
  ADD CONSTRAINT `job_skill_ibfk_1` FOREIGN KEY (`JOB_ID`) REFERENCES `job` (`JOB_ID`),
  ADD CONSTRAINT `job_skill_ibfk_2` FOREIGN KEY (`SKILL_ID`) REFERENCES `skill` (`SKILL_ID`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`LEVEL_ID`) REFERENCES `level_user` (`LEVEL_ID`);

--
-- Constraints for table `user_course`
--
ALTER TABLE `user_course`
  ADD CONSTRAINT `user_course_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `user` (`USER_ID`),
  ADD CONSTRAINT `user_course_ibfk_2` FOREIGN KEY (`COURSE_ID`) REFERENCES `course` (`COURSE_ID`);

--
-- Constraints for table `user_equipment`
--
ALTER TABLE `user_equipment`
  ADD CONSTRAINT `user_equipment_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `user` (`USER_ID`),
  ADD CONSTRAINT `user_equipment_ibfk_2` FOREIGN KEY (`UPGRADE_ID`) REFERENCES `equipment` (`UPGRADE_ID`);

--
-- Constraints for table `user_job`
--
ALTER TABLE `user_job`
  ADD CONSTRAINT `user_job_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `user` (`USER_ID`),
  ADD CONSTRAINT `user_job_ibfk_2` FOREIGN KEY (`JOB_ID`) REFERENCES `job` (`JOB_ID`);

--
-- Constraints for table `user_skill`
--
ALTER TABLE `user_skill`
  ADD CONSTRAINT `user_skill_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `user` (`USER_ID`),
  ADD CONSTRAINT `user_skill_ibfk_2` FOREIGN KEY (`SKILL_ID`) REFERENCES `skill` (`SKILL_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
