-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 15, 2018 at 04:50 PM
-- Server version: 10.1.26-MariaDB
-- PHP Version: 7.1.9

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mbd_fp`
--

DELIMITER $$
--
-- Procedures
--
CREATE PROCEDURE `sp_changepassword` (`p_uname` VARCHAR(50), `p_oldpass` VARCHAR(50), `p_newpass` VARCHAR(50))  proc:BEGIN
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
	END$$

CREATE PROCEDURE `sp_levelupdate` (`p_usrid` INT, `p_dx` INT)  BEGIN
	select `USER_EXP`, `LEVEL_ID` from `user` where `USER_ID` = p_usrid into @x0, @l0;
	set @xt = @x0 + p_dx;
	select `LEVEL_MAX_EXP` from `level_user` where `LEVEL_ID` = @l0 into @max;
	if(@xt < @max) then
		UPDATE `user` SET `USER_EXP` = @xt WHERE `USER_ID` = p_usrid;
	else
		UPDATE `user` SET `USER_EXP` = @xt - @max, `LEVEL_ID` = @l0 + 1; 
	end if;
	END$$

CREATE PROCEDURE `sp_login` (`p_uname` VARCHAR(50), `p_password` VARCHAR(50))  BEGIN
	IF EXISTS(SELECT 1 FROM `user` 
		WHERE `USER_UNAME`=p_uname AND `USER_PASSWORD`= MD5(p_password)) THEN
		SELECT 0, "login sukses";
	ELSE
		SELECT -1, "maaf username / password tidak dikenal";	
	END IF;
	END$$

CREATE PROCEDURE `sp_register` (`p_uname` VARCHAR(15), `p_password` VARCHAR(32), `p_name` VARCHAR(20))  BEGIN
	IF NOT EXISTS (SELECT 1 FROM `user` WHERE `USER_UNAME`=p_uname) THEN
		INSERT INTO `user` (`LEVEL_ID`, `USER_NAME`, `USER_UNAME`, `USER_PASSWORD`, `USER_EXP`, `USER_MONEY`, `USER_STAMINA`, `USER_LASTACTION`)  
		VALUES (0, p_name, p_uname, MD5(p_password), 0, 100, 10, NOW());
		SELECT 0, 'pendaftaran sukses';
	ELSE 
		SELECT -1, 'Gagal, username sudah terdaftar!';
	END IF;
	END$$

CREATE PROCEDURE `sp_takecourse` (`p_usrid` INT, `p_courseid` INT)  BEGIN
	CALL sp_updatetamina(p_usrid);
	select `USER_MONEY`, `USER_STAMINA` from `user` where `USER_ID`=p_usrid
	into @usrbal, @st;
	
	select `COURSE_STAMINA`, `COURSE_COST` from `course` where `COURSE_ID` = p_courseid
	into @coursest, @coursecost;
	
	IF(@usrbal < @coursecost) then 
		select -1, "Uang tidak cukup";
	else if(EXISTS(Select * from `user_course` where `USER_ID` = p_usrid and `COURSE_ID` = p_courseid)) then
		select -1, "Tidak dapat mengambil Course yang sama sekaligus";
	else if (@st < @coursecost) then 
		select -1, "stamina tidak cukup";
	else 
		update `user` set `USER_MONEY` = @usrbal - @coursecost, `USER_STAMINA` = @st - @coursest, `USER_LASTACTION`=now() 
		where `USER_ID` = p_usrid;
		insert into `user_course`(`USER_ID`, `COURSE_ID`, `USER_COURSE_START`) values (p_usrid, p_courseid, now());
		Select 0, "Sukses mengambil course";
	end if;
	end if;
	end if;
	END$$

CREATE PROCEDURE `sp_takecoursereward` (`p_usrid` INT, `p_cid` INT)  BEGIN
	if not exists(select `USER_COURSE_START` from `user_course` where `USER_ID` = p_usrid and `COURSE_ID` = p_cid) then
		select -1, "Course not found";
	else
		select `USER_JOB_START` from `user_course` WHERE `USER_ID` = p_usrid AND `COURSE_ID` = p_cid into @t0;
		select `COURSE_DURATION`, `COURSE_EXPERIENCE` from `course` where `COURSE_ID` = p_cid into @dt, @dx;
		select `USER_EXP` from `user` where `USER_ID` = p_usrid into @x0;
		
		if(dt < timestampdiff(minute, @t0, now())) then 
			select -1, "Course has yet ended";
		else
			set @xt = @x0 + @dx;
			call sp_levelupdate(p_usrid, @xt);
			insert into `user_skill`(`USER_ID`, `SKILL_ID`) values (p_usrid, p_cid);
			delete from `user_course` where `USER_ID` = p_usrid and `COURSE_ID` = p_cid;
			select 0, "Course's reward successfully taken";
		end if;
	end if;
	END$$

CREATE PROCEDURE `sp_takejob` (`p_usrid` INT, `p_jid` INT)  BEGIN
	call sp_updatestamina(p_usrid);
	if(fn_isjobavailable(p_usrid, p_jid)) then
		select `JOB_PAYMENT`, `JOB_STAMINA` from `job` into @dm, @ds;
		select `USER_MONEY`, `USER_STAMINA` from `user` into @m0, @s0;
		update `user` set `USER_MONEY` = @m0 - @dm, `USER_STAMINA` = @s0 - @ds, `USER_LASTACTION` = now();
		select 0, "Take job success";
	else 
		select -1, "Job unavailable";
	end if;
	END$$

CREATE PROCEDURE `sp_takejobreward` (`p_usrid` INT, `p_jid` INT)  BEGIN
	if not exists(select `USER_JOB_START` from `user_job` where `USER_ID` = p_usrid and `JOB_ID` = p_jid) then 
		select -1, "Job Not Found";
	else
		SELECT `USER_JOB_START` FROM `user_job` WHERE `USER_ID` = p_usrid AND `JOB_ID` = p_jid into @t0;
		set @time = timestampdiff(minute, @t0, now());
		select `JOB_DURATION` from `job` where `JOB_ID` = p_jid into @t;
		
		if(t > @t0) then 
			select -1, "Job has yet ended";
		else
			select `JOB_PAYMENT`, `JOB_EXPERIENCE` from `job` where `JOB_ID` = p_jid into @dm, @dx;
			select `USER_MONEY`, `USER_EXP` from `user` where `USER_ID` = p_usrid into @m0, @x0;
			set @x = @x0 + @dx;
			call sp_levelupdate(p_usrid, @x);
			update `user` set `USER_MONEY` = @m0 + @dm;
			delete from `user_job` where `USER_ID` = p_usrid and `JOB_ID` = p_jid;
			select 0, "Job XP taken";
		end if;
	end if;
	
	END$$

CREATE PROCEDURE `sp_updatestamina` (`p_usrid` INT)  BEGIN
	set @st = fn_stamina(p_usrid);
	update `user` set `USER_STAMINA` = @st, `USER_LASTACTION`=now() where `USER_ID` = p_usrid;
	END$$

CREATE PROCEDURE `sp_upgrade` (`p_usrid` INT, `p_upgrid` INT)  BEGIN
	select `USER_MONEY` from `user` where `USER_ID` = p_usrid into @usrbal;
	select `UPGRADE_COST` from `equipment` where `UPGRADE_ID` = p_upgrid into @cost;
	if(@cost > @usrbal) then 
		select -1, "Uang tidak cukup";
	else
		update `user` set `USER_MONEY` = @usrbal - @cost where `USER_ID` = p_usrid;
		if(exists(select p_upgrid from `user_equipment` where `USER_ID` = p_usrid)) then 
			select `USER_EQUIPMENT_LEVEL` from `user_equipment` 
			where `USER_ID` = p_usrid and `UPGRADE_ID` = p_upgrid into @lv;
			
			update `user_equipment` set `USER_EQUIPMENT_LEVEL` = @lv + 1 
			where `USER_ID` = p_usrid AND `UPGRADE_ID` = p_upgrid;
		else 
			insert into `user_equipment` (`USER_ID`, `UPGRADE_ID`, `USER_EQUIPMENT_LEVEL`) 
			values (p_usrid, p_upgrid, 1);
		end if;
		select 0, "upgrade success";
	end if;
	END$$

--
-- Functions
--
CREATE FUNCTION `fn_isjobavailable` (`f_usrid` INT, `f_jid` INT) RETURNS TINYINT(1) BEGIN
	call sp_updatestamina(f_usrid);
	select `USER_STAMINA` from `user` where `USER_ID` = f_usrid into @s0;
	select `JOB_STAMINA` from `job` where `JOB_ID` = f_jid into @s1;
	select count(*) from `user_skill` a, `job_skill` b where b.`JOB_ID` = f_jid and a.`USER_ID` = f_usrid and b.`SKILL_ID` = a.`SKILL_ID` into @n0;
	select count(*) from `job_skill` where `JOB_ID` = f_jid into @n1;
	select count(*) from `job_equipment` a, `user_equipment` b where a.`JOB_ID` = f_jid and b.`USER_ID` = f_usrid and a.`UPGRADE_ID` = b.`UPGRADE_ID` and a.`JOB_EQUIPMENT_LEVEL` = b.`USER_EQUIPMENT_LEVEL` into @n2;
	select count(*) from `job_equipment` where `JOB_ID` = f_jid into @n3;
	if(@s0 < @s1) then
		return 0;
	else if(@n1 > @n0) then
		return 0;
	else if(@n3 > @n2) then
		return 0;
	else 
		return 1;
	end if;
	end if;
	end if;
    END$$

CREATE FUNCTION `fn_isuserfree` (`f_id` INT) RETURNS TINYINT(1) BEGIN
	SET @tjob = exists(select 1 from `user_job`  where `USER_ID` = f_id);
	SET @tcourse = EXISTS(SELECT 1 FROM `user_course` where `USER_ID` = f_id);
	return NOT(@tjob or @tcourse);
END$$

CREATE FUNCTION `fn_stamina` (`f_id` INT) RETURNS INT(11) BEGIN
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `COURSE_ID` int(11) NOT NULL,
  `SKILL_ID` int(11) DEFAULT NULL,
  `COURSE_NAME` varchar(20) DEFAULT NULL,
  `COURSE_DESCRIPTION` varchar(30) DEFAULT NULL,
  `COURSE_STAMINA` int(11) DEFAULT NULL,
  `COURSE_DURATION` int(11) DEFAULT NULL,
  `COURSE_COST` float(8,2) DEFAULT NULL,
  `COURSE_EXPERIENCE` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `equipment`
--

CREATE TABLE `equipment` (
  `UPGRADE_ID` int(11) NOT NULL,
  `UPGRADE_NAME` varchar(20) DEFAULT NULL,
  `UPGRADE_COST` float(8,2) DEFAULT NULL,
  `UPGRADE_DESCRIPTION` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `job`
--

CREATE TABLE `job` (
  `JOB_ID` int(11) NOT NULL,
  `JOB_NAME` varchar(30) DEFAULT NULL,
  `JOB_DESCRIPTION` varchar(50) DEFAULT NULL,
  `JOB_EXPERIENCE` int(11) DEFAULT NULL,
  `JOB_PAYMENT` float(8,2) DEFAULT NULL,
  `JOB_STAMINA` int(11) DEFAULT NULL,
  `JOB_DURATION` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `job_equipment`
--

CREATE TABLE `job_equipment` (
  `JOB_ID` int(11) DEFAULT NULL,
  `UPGRADE_ID` int(11) DEFAULT NULL,
  `JOB_EQUIPMENT_LEVEL` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `job_skill`
--

CREATE TABLE `job_skill` (
  `SKILL_ID` int(11) DEFAULT NULL,
  `JOB_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `level_user`
--

CREATE TABLE `level_user` (
  `LEVEL_ID` int(11) NOT NULL,
  `LEVEL_MAX_EXP` int(11) DEFAULT NULL,
  `LEVEL_MAX_STAMINA` int(11) DEFAULT NULL,
  `LEVEL_STAMINA_PER_MINUTE` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `skill`
--

CREATE TABLE `skill` (
  `SKILL_ID` int(11) NOT NULL,
  `SKILL_NAME` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `USER_ID` int(11) NOT NULL,
  `LEVEL_ID` int(11) DEFAULT NULL,
  `USER_NAME` varchar(20) DEFAULT NULL,
  `USER_UNAME` varchar(15) DEFAULT NULL,
  `USER_PASSWORD` char(32) DEFAULT NULL,
  `USER_EXP` int(11) DEFAULT NULL,
  `USER_MONEY` float(8,2) DEFAULT NULL,
  `USER_STAMINA` int(11) DEFAULT NULL,
  `USER_LASTACTION` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_course`
--

CREATE TABLE `user_course` (
  `USER_ID` int(11) DEFAULT NULL,
  `COURSE_ID` int(11) DEFAULT NULL,
  `USER_COURSE_START` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_equipment`
--

CREATE TABLE `user_equipment` (
  `USER_ID` int(11) DEFAULT NULL,
  `UPGRADE_ID` int(11) DEFAULT NULL,
  `USER_EQUIPMENT_LEVEL` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_job`
--

CREATE TABLE `user_job` (
  `USER_ID` int(11) DEFAULT NULL,
  `JOB_ID` int(11) DEFAULT NULL,
  `USER_JOB_START` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_skill`
--

CREATE TABLE `user_skill` (
  `USER_ID` int(11) DEFAULT NULL,
  `SKILL_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  MODIFY `COURSE_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job`
--
ALTER TABLE `job`
  MODIFY `JOB_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `skill`
--
ALTER TABLE `skill`
  MODIFY `SKILL_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `USER_ID` int(11) NOT NULL AUTO_INCREMENT;

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
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
