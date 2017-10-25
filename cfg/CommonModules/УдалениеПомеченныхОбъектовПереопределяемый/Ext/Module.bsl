﻿#Область ПрограммныйИнтерфейс

// Вызывается перед поиском объектов помеченных на удаление.
// В этом обработчике можно организовать удаление устаревших ключей аналитик и любых других объектов информационной
// базы, ставших более не нужными.
//
// Параметры:
//   Параметры - Структура - со свойствами:
//     * Интерактивное - Булево - Истина, если удаление помеченных объектов запущено пользователем.
//                                Ложь, если удаление запущено по расписанию регламентного задания.
//
Процедура ПередПоискомПомеченныхНаУдаление(Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти
