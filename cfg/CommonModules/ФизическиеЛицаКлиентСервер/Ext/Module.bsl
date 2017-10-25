﻿#Область ПрограммныйИнтерфейс

// Раскладывает полное имя физического лица на составные части - фамилию, имя и отчество.
// Если в конце полного имени встречаются "оглы", "улы", "уулу", "кызы" или "гызы",
// то они также считаются частью отчества.
//
// Параметры:
//  ФамилияИмяОтчество - Строка - полное имя в виде "Фамилия Имя Отчество".
//
// Возвращаемое значение:
//  Структура - части полного имени:
//   * Фамилия  - Строка - фамилия;
//   * Имя      - Строка - имя;
//   * Отчество - Строка - отчество.
//
// Пример:
//   1. ФизическиеЛицаКлиентСервер.ЧастиИмени("Иванов Иван Иванович") 
//   вернет структуру со значениями свойств: "Иванов", "Иван", "Иванович".
//   2. ФизическиеЛицаКлиентСервер.ЧастиИмени("Смит Джон") 
//   вернет структуру со значениями свойств: "Смит", "Джон", "".
//   3. ФизическиеЛицаКлиентСервер.ЧастиИмени("Алиев Ахмед Октай оглы Мамедов") 
//   вернет структуру со значениями свойств: "Алиев", "Алиев", "Октай оглы Мамедов".
//
Функция ЧастиИмени(ФамилияИмяОтчество) Экспорт
	
	Результат = Новый Структура("Фамилия,Имя,Отчество");
	
	ЧастиИмени = СтрРазделить(ФамилияИмяОтчество, " ", Ложь);
	
	Если ЧастиИмени.Количество() >= 1 Тогда
		Результат.Фамилия = ЧастиИмени[0];
	КонецЕсли;
	
	Если ЧастиИмени.Количество() >= 2 Тогда
		Результат.Имя = ЧастиИмени[1];
	КонецЕсли;
	
	Если ЧастиИмени.Количество() >= 3 Тогда
		Результат.Отчество = ЧастиИмени[2];
	КонецЕсли;
	
	Если ЧастиИмени.Количество() > 3 Тогда
		ДополнительныеЧастиОтчества = Новый Массив;
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'оглы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'улы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'уулу'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'кызы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'гызы'"));
		
		Если ДополнительныеЧастиОтчества.Найти(НРег(ЧастиИмени[3])) <> Неопределено Тогда
			Результат.Отчество = Результат.Отчество + " " + ЧастиИмени[3];
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует краткое представление из полного имени физического лица.
//
// Параметры:
//  ФамилияИмяОтчество - Строка - полное имя в виде "Фамилия Имя Отчество";
//                     - Структура - части полного имени:
//                        * Фамилия  - Строка - фамилия;
//                        * Имя      - Строка - имя;
//                        * Отчество - Строка - отчество.
//
// Возвращаемое значение:
//  Строка - фамилия и инициалы. Например, "Пупкин В. И.".
//
// Пример:
//  Результат = ФизическиеЛицаКлиентСервер.ФамилияИнициалыФизЛица("Пупкин Василий Иванович"); 
//  - возвращает "Пупкин В. И.".
//
Функция ФамилияИнициалы(Знач ФамилияИмяОтчество) Экспорт
	
	Если ТипЗнч(ФамилияИмяОтчество) = Тип("Строка") Тогда
		ФамилияИмяОтчество = ЧастиИмени(ФамилияИмяОтчество);
	КонецЕсли;
	
	Фамилия = ФамилияИмяОтчество.Фамилия;
	Имя = ФамилияИмяОтчество.Имя;
	Отчество = ФамилияИмяОтчество.Отчество;
	
	Если ПустаяСтрока(Имя) Тогда
		Возврат Фамилия;
	КонецЕсли;
	
	Если ПустаяСтрока(Отчество) Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2.", Фамилия, Лев(Имя, 1));
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2.%3.", Фамилия, Лев(Имя, 1), Лев(Отчество, 1));
	
КонецФункции

// Проверяет, верно ли написано ФИО физического лица. 
// ФИО считается верным, если содержит только кириллицу, либо только латиницу.
//
// Параметры:
//  ФИО - Строка - фамилия, имя и отчество. Например, "Пупкин Василий Иванович".
//  ТолькоКириллица - Булево - при проверке допустимой будет только кириллица в ФИО.
//
// Возвращаемое значение:
//  Булево - Истина, если ФИО написано верно.
//
Функция ФИОНаписаноВерно(Знач ФИО, ТолькоКириллица = Ложь) Экспорт
	
	ДопустимыеСимволы = "-";
	
	Возврат (Не ТолькоКириллица И СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(ФИО, Ложь, ДопустимыеСимволы))
		Или СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(ФИО, Ложь, ДопустимыеСимволы);
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ЧастиИмени.
//
// Функция раскладывает строку ФИО в структуру.
//
// Параметры:
//  ФИО - Строка - наименование.
//
// Возвращаемое значение:
//  Структура - фамилия, имя и отчество:
//   * Фамилия  - Строка - фамилия;
//   * Имя      - Строка - имя;
//   * Отчество - Строка - отчество.
//
Функция ФамилияИмяОтчество(Знач ФИО) Экспорт
	
	СтруктураФИО = Новый Структура("Фамилия, Имя, Отчество");
	
	МассивПодстрок = СтрРазделить(ФИО, " ", Ложь);
	
	Если МассивПодстрок.Количество() > 0 Тогда
		СтруктураФИО.Вставить("Фамилия", МассивПодстрок[0]);
		Если МассивПодстрок.Количество() > 1 Тогда
			СтруктураФИО.Вставить("Имя", МассивПодстрок[1]);
		КонецЕсли;
		Если МассивПодстрок.Количество() > 2 Тогда
			Отчество = "";
			Для Шаг = 2 По МассивПодстрок.Количество()-1 Цикл
				Отчество = Отчество + МассивПодстрок[Шаг] + " ";
			КонецЦикла;
			СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Отчество, 1);
			СтруктураФИО.Вставить("Отчество", Отчество);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураФИО;
	
КонецФункции

// Устарела. Следует использовать функции ФамилияИнициалы и ЧастиИмени.
// Формирует фамилию и инициалы либо по переданным строкам.
//
// Параметры:
//  ФИОСтрокой	- Строка - если указан это параметр, то остальные игнорируются.
//  Фамилия		- Строка - фамилия физического лица.
//  Имя			- Строка - имя физического лица.
//  Отчество	- Строка - отчество физического лица.
//
// Возвращаемое значение:
//  Строка - фамилия и инициалы одной строкой. 
//  В параметрах Фамилия, Имя и Отчество записываются вычисленные части.
//
// Пример:
//  Результат = ФамилияИнициалыФизЛица("Иванов Иван Иванович"); // Результат = "Иванов И. И."
//
Функция ФамилияИнициалыФизЛица(ФИОСтрокой = "", Фамилия = " ", Имя = " ", Отчество = " ") Экспорт

	ТипОбъекта = ТипЗнч(ФИОСтрокой);
	Если ТипОбъекта = Тип("Строка") Тогда
		ФИО = СтрРазделить(ФИОСтрокой, " ", Ложь);
	Иначе
		// Используем возможно переданные отдельные строки.
		Возврат ?(Не ПустаяСтрока(Фамилия), 
		          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество,1) + ".", ""), ""),
		          "");
	КонецЕсли;
	
	КоличествоПодстрок = ФИО.Количество();
	Фамилия            = ?(КоличествоПодстрок > 0, ФИО[0], "");
	Имя                = ?(КоличествоПодстрок > 1, ФИО[1], "");
	Отчество           = ?(КоличествоПодстрок > 2, ФИО[2], "");
	
	Если КоличествоПодстрок > 3 Тогда
		ДополнительныеЧастиОтчества = Новый Массив;
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'оглы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'улы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'уулу'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'кызы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'гызы'"));
		
		Если ДополнительныеЧастиОтчества.Найти(НРег(ФИО[3])) <> Неопределено Тогда
			Отчество = Отчество + " " + ФИО[3];
		КонецЕсли;
	КонецЕсли;
	
	Возврат ?(Не ПустаяСтрока(Фамилия), 
	          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя, 1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), ""),
	          "");
	
КонецФункции

#КонецОбласти

#КонецОбласти
