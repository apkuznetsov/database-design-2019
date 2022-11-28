CREATE TABLE Аудитория
( 
	Номер_аудитории      integer  NOT NULL ,
	Номер_корпуса        integer  NOT NULL 
)
go

ALTER TABLE Аудитория
	ADD CONSTRAINT XPKАудитория PRIMARY KEY  CLUSTERED (Номер_аудитории ASC,Номер_корпуса ASC)
go


CREATE TABLE Группа_студентов
( 
	Номер_группы         integer  NOT NULL 
)
go

ALTER TABLE Группа_студентов
	ADD CONSTRAINT XPKГруппа_студентов PRIMARY KEY  CLUSTERED (Номер_группы ASC)
go


CREATE TABLE Дисциплина
( 
	Код_дисциплины       integer  NOT NULL ,
	Название_дисциплины  varchar(20)  NULL 
)
go

ALTER TABLE Дисциплина
	ADD CONSTRAINT XPKДисциплина PRIMARY KEY  CLUSTERED (Код_дисциплины ASC)
go


CREATE TABLE Занятие
( 
	День_недели          datetime  NOT NULL ,
	Время                datetime  NOT NULL ,
	Номер_табеля         integer  NOT NULL ,
	Номер_аудитории      integer  NOT NULL ,
	Код_дисциплины       integer  NOT NULL ,
	Номер_группы         integer  NOT NULL ,
	Номер_корпуса        integer  NOT NULL 
)
go

ALTER TABLE Занятие
	ADD CONSTRAINT XPKЗанятие PRIMARY KEY  CLUSTERED (День_недели ASC,Номер_группы ASC,Время ASC)
go


CREATE TABLE Преподаватель
( 
	Номер_табеля         integer  NOT NULL ,
	ФИО_преподавателя    varchar(20)  NULL 
)
go

ALTER TABLE Преподаватель
	ADD CONSTRAINT XPKПреподаватель PRIMARY KEY  CLUSTERED (Номер_табеля ASC)
go


ALTER TABLE Занятие
	ADD CONSTRAINT R_1 FOREIGN KEY (Номер_табеля) REFERENCES Преподаватель(Номер_табеля)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Занятие
	ADD CONSTRAINT R_5 FOREIGN KEY (Номер_аудитории,Номер_корпуса) REFERENCES Аудитория(Номер_аудитории,Номер_корпуса)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Занятие
	ADD CONSTRAINT R_4 FOREIGN KEY (Код_дисциплины) REFERENCES Дисциплина(Код_дисциплины)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE Занятие
	ADD CONSTRAINT R_7 FOREIGN KEY (Номер_группы) REFERENCES Группа_студентов(Номер_группы)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_Аудитория ON Аудитория FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,Занятие
      WHERE
        Занятие.Номер_аудитории = deleted.Номер_аудитории AND
        Занятие.Номер_корпуса = deleted.Номер_корпуса
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Аудитория because Занятие exists.'
      GOTO ERROR
    END

    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tU_Аудитория ON Аудитория FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insНомер_аудитории integer, 
           @insНомер_корпуса integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(Номер_аудитории) OR
    UPDATE(Номер_корпуса)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Занятие
      WHERE
        Занятие.Номер_аудитории = deleted.Номер_аудитории AND
        Занятие.Номер_корпуса = deleted.Номер_корпуса
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Аудитория because Занятие exists.'
      GOTO ERROR
    END
  END

  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tD_Группа_студентов ON Группа_студентов FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,Занятие
      WHERE
        Занятие.Номер_группы = deleted.Номер_группы
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Группа_студентов because Занятие exists.'
      GOTO ERROR
    END

    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tU_Группа_студентов ON Группа_студентов FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insНомер_группы integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(Номер_группы)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Занятие
      WHERE
        Занятие.Номер_группы = deleted.Номер_группы
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Группа_студентов because Занятие exists.'
      GOTO ERROR
    END
  END

  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tD_Дисциплина ON Дисциплина FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,Занятие
      WHERE
        Занятие.Код_дисциплины = deleted.Код_дисциплины
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Дисциплина because Занятие exists.'
      GOTO ERROR
    END

    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tU_Дисциплина ON Дисциплина FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insКод_дисциплины integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(Код_дисциплины)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Занятие
      WHERE
        Занятие.Код_дисциплины = deleted.Код_дисциплины
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Дисциплина because Занятие exists.'
      GOTO ERROR
    END
  END

  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tD_Занятие ON Занятие FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (SELECT * FROM deleted,Преподаватель
      WHERE
        deleted.Номер_табеля = Преподаватель.Номер_табеля AND
        NOT EXISTS (
          SELECT * FROM Занятие
          WHERE
            Занятие.Номер_табеля = Преподаватель.Номер_табеля
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Занятие because Преподаватель exists.'
      GOTO ERROR
    END

    IF EXISTS (SELECT * FROM deleted,Дисциплина
      WHERE
        deleted.Код_дисциплины = Дисциплина.Код_дисциплины AND
        NOT EXISTS (
          SELECT * FROM Занятие
          WHERE
            Занятие.Код_дисциплины = Дисциплина.Код_дисциплины
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Занятие because Дисциплина exists.'
      GOTO ERROR
    END

    IF EXISTS (SELECT * FROM deleted,Аудитория
      WHERE
        deleted.Номер_аудитории = Аудитория.Номер_аудитории AND
        deleted.Номер_корпуса = Аудитория.Номер_корпуса AND
        NOT EXISTS (
          SELECT * FROM Занятие
          WHERE
            Занятие.Номер_аудитории = Аудитория.Номер_аудитории AND
            Занятие.Номер_корпуса = Аудитория.Номер_корпуса
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Занятие because Аудитория exists.'
      GOTO ERROR
    END

    IF EXISTS (SELECT * FROM deleted,Группа_студентов
      WHERE
        /* %JoinFKPK(deleted,Группа_студентов," = "," AND") */
        deleted.Номер_группы = Группа_студентов.Номер_группы AND
        NOT EXISTS (
          SELECT * FROM Занятие
          WHERE
            /* %JoinFKPK(Занятие,Группа_студентов," = "," AND") */
            Занятие.Номер_группы = Группа_студентов.Номер_группы
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Занятие because Группа_студентов exists.'
      GOTO ERROR
    END

    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tU_Занятие ON Занятие FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insДень_недели datetime, 
           @insНомер_группы integer, 
           @insВремя datetime,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(Номер_табеля)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Преподаватель
        WHERE
          inserted.Номер_табеля = Преподаватель.Номер_табеля
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Занятие because Преподаватель does not exist.'
      GOTO ERROR
    END
  END

  IF
    UPDATE(Код_дисциплины)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Дисциплина
        WHERE
          inserted.Код_дисциплины = Дисциплина.Код_дисциплины
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Занятие because Дисциплина does not exist.'
      GOTO ERROR
    END
  END

  IF
    UPDATE(Номер_аудитории) OR
    UPDATE(Номер_корпуса)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Аудитория
        WHERE
          inserted.Номер_аудитории = Аудитория.Номер_аудитории and
          inserted.Номер_корпуса = Аудитория.Номер_корпуса
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Занятие because Аудитория does not exist.'
      GOTO ERROR
    END
  END

  IF
    UPDATE(Номер_группы)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Группа_студентов
        WHERE
          inserted.Номер_группы = Группа_студентов.Номер_группы
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Занятие because Группа_студентов does not exist.'
      GOTO ERROR
    END
  END

  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tD_Преподаватель ON Преподаватель FOR DELETE AS
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    IF EXISTS (
      SELECT * FROM deleted,Занятие
      WHERE
        Занятие.Номер_табеля = deleted.Номер_табеля
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Преподаватель because Занятие exists.'
      GOTO ERROR
    END

    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go

CREATE TRIGGER tU_Преподаватель ON Преподаватель FOR UPDATE AS
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insНомер_табеля integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  IF
    UPDATE(Номер_табеля)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Занятие
      WHERE
        Занятие.Номер_табеля = deleted.Номер_табеля
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Преподаватель because Занятие exists.'
      GOTO ERROR
    END
  END

  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END
go
