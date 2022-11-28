﻿SELECT * FROM Занятие;

-- запрос для таблицы Занятие, задающий успешно завершающуюся транзакцию.
BEGIN TRAN;
INSERT INTO Занятие VALUES ('09:00', 2, 212211, 1002, 413, 5, 6102);
INSERT INTO Занятие VALUES ('09:00', 5, 212211, 1002, 413, 5, 6102);
UPDATE Занятие SET Код_дисциплины = 1002 WHERE Номер_табеля = 56534;
COMMIT TRAN;

SELECT * FROM Занятие;

-- запрос, который откатывает выполнявшуюся транзакцию
BEGIN TRAN;
DELETE FROM Занятие WHERE Время = '09:00' AND Номер_табеля = 212211;
INSERT INTO Занятие VALUES ('09:00', 6, 56534, 1002, 413, 5, 6102);
ROLLBACK TRAN;

SELECT * FROM Занятие;