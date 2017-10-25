﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа в модели сервиса.Базовая функциональность БИП".
// ОбщийМодуль.ИнтернетПоддержкаПользователейВМоделиСервиса.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает тикет аутентификации пользователя на портале поддержки
// при работе в модели сервиса в неразделенном сеансе.
// Возвращенный тикет может быть проверен вызовом операции checkTicket()
// сервиса https://login.1c.ru/api/public/ticket?wsdl или
// https://login.1c.eu/api/public/ticket?wsdl.
//
// Параметры:
//	ВладелецТикета - Строка - произвольное имя сервиса, для которого
//		выполняется аутентификация пользователя. Это же имя должно
//		использоваться при вызове операции checkTicket();
//		Не допускается незаполненное значение параметра;
//	ОбластьДанных - Число - номер области данных (абонент), для которой
//		выполняется получение тикета.
//
// Возвращаемое значение:
//	Структура - результат получения тикета. Поля структуры:
//		* Тикет - Строка - полученный тикет аутентификации. Если при получении
//			тикета произошла ошибка, значение поля - пустая строка.
//		* КодОшибки - Строка - строковый код возникшей ошибки, который
//			может быть обработан вызывающим функционалом:
//				- <Пустая строка> - получение тикета выполнено успешно;
//				- "ОшибкаПодключения" - ошибка при подключении к сервису;
//				- "ОшибкаСервиса" - внутренняя ошибка сервиса;
//				- "НеизвестнаяОшибка" - при получении тикета возникла
//					неизвестная (необрабатываемая) ошибка;
//		* СообщениеОбОшибке - Строка - краткое описание ошибки, которое
//			может быть отображено пользователю;
//		* ИнформацияОбОшибке - Строка - подробное описание ошибки, которое
//			может быть записано в журнал регистрации.
//
Функция ТикетАутентификацииНаПорталеПоддержкиВНеразделенномСеансе(ВладелецТикета, ОбластьДанных) Экспорт
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ВызватьИсключение НСтр("ru = 'Получение тикета недоступно в разделенном сеансе.'");
	КонецЕсли;
	
	Возврат ТикетАутентификацииНаПорталеПоддержки(ВладелецТикета, ОбластьДанных);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ТикетАутентификацииНаПорталеПоддержки(ВладелецТикета, ОбластьДанных = Неопределено) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru = 'Недоступно при работе в локальном режиме.'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВладелецТикета) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнено значение параметра ""ВладелецТикета""'");
	КонецЕсли;
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ЗначениеРазделителя = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
	ИначеЕсли ОбластьДанных = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнено значение параметра ""ОбластьДанных""'");
	Иначе
		// В неразделенном сеансе используется переданное
		// значение параметра ОбластьДанных.
		ЗначениеРазделителя = ОбластьДанных;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("КодОшибки"         , "");
	Результат.Вставить("СообщениеОбОшибке" , "");
	Результат.Вставить("ИнформацияОбОшибке", "");
	Результат.Вставить("Тикет"             , "");
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		ИдентификаторПользователя = Неопределено;
	Иначе
		ТекущийПользователь = Пользователи.АвторизованныйПользователь();
		ИдентификаторПользователя =
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				ТекущийПользователь,
				"ИдентификаторПользователяСервиса");
	КонецЕсли;
	
	ЗаписьТела = Новый ЗаписьJSON;
	ЗаписьТела.УстановитьСтроку();
	ЗаписьТела.ЗаписатьНачалоОбъекта();

	ЗаписьТела.ЗаписатьИмяСвойства("zone");
	ЗаписьТела.ЗаписатьЗначение(ЗначениеРазделителя);
	
	КлючОбласти = КлючОбластиДанных(ЗначениеРазделителя);
	Если ЗначениеЗаполнено(КлючОбласти) Тогда
		ЗаписьТела.ЗаписатьИмяСвойства("zoneKey");
		ЗаписьТела.ЗаписатьЗначение(КлючОбласти);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторПользователя) Тогда
		ЗаписьТела.ЗаписатьИмяСвойства("userGUID");
		ЗаписьТела.ЗаписатьЗначение(Строка(ИдентификаторПользователя));
	КонецЕсли;
	
	ЗаписьТела.ЗаписатьИмяСвойства("openUrl");
	ЗаписьТела.ЗаписатьЗначение(Строка(ВладелецТикета));
	
	ЗаписьТела.ЗаписатьКонецОбъекта();
	ТелоЗапроса = ЗаписьТела.Закрыть();
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Метод"                   , "POST");
	ДополнительныеПараметры.Вставить("Заголовки"               , Заголовки);
	ДополнительныеПараметры.Вставить("ДанныеДляОбработки"      , ТелоЗапроса);
	ДополнительныеПараметры.Вставить("ФорматДанныхДляОбработки", 1);
	ДополнительныеПараметры.Вставить("ФорматОтвета"            , 1);
	ДополнительныеПараметры.Вставить("Таймаут"                 , 30);
	
	НастройкиПодключения = НастройкиПодключенияКМенеджеруСервиса();
	URLСервиса = НастройкиПодключения.URL + "/hs/tickets/";
	
	РезультатОперации =
		ИнтернетПоддержкаПользователейКлиентСервер.ЗагрузитьСодержимоеИзИнтернет(
			URLСервиса,
			НастройкиПодключения.ИмяСлужебногоПользователя,
			НастройкиПодключения.ПарольСлужебногоПользователя,
			ДополнительныеПараметры);
	Если РезультатОперации.КодСостояния = 404 Тогда
		
		// В Менеджере сервиса отсутствует сервис получения тикетов.
		// В этом случае используется тикет-константа.
		Результат.КодОшибки = "ОшибкаПодключения";
		Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В Менеджере сервиса отсутствует сервис тикетов аутентификации.
				|Получен код состояния 404 при обращении к ресурсу %1.'"),
			URLСервиса);
		
		ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(
			Результат.ИнформацияОбОшибке);
		
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
			Результат.СообщениеОбОшибке = НСтр("ru = 'Ошибка аутентификации (404).'");
		Иначе
			Результат.СообщениеОбОшибке = НСтр("ru = 'Ошибка аутентификации.'");
		КонецЕсли;
		
	ИначеЕсли РезультатОперации.КодСостояния = 201
		Или РезультатОперации.КодСостояния = 400
		Или РезультатОперации.КодСостояния = 403
		Или РезультатОперации.КодСостояния = 500 Тогда
		
		// Обрабатываемое тело ответа.
		Попытка
			
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(РезультатОперации.Содержимое);
			ОтветОбъект = ПрочитатьJSON(ЧтениеJSON);
			ЧтениеJSON.Закрыть();
			
			Если РезультатОперации.КодСостояния = 201 Тогда
				Результат.Тикет = ОтветОбъект.ticket;
			Иначе
				
				Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось получить тикет аутентификации в Менеджере сервиса (%1).
						|Код состояния: %2;
						|Сообщение: %3
						|Тело запроса: %4'"),
					URLСервиса,
					РезультатОперации.КодСостояния,
					ОтветОбъект.text,
					ТелоЗапроса);
				ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(
					Результат.ИнформацияОбОшибке);
				
				Результат.КодОшибки = ?(
					РезультатОперации.КодСостояния = 500,
					"ОшибкаСервиса",
					"ОшибкаПодключения");
				
				Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
					Результат.СообщениеОбОшибке =
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Ошибка аутентификации (%1).'"),
							РезультатОперации.КодСостояния);
				Иначе
					Результат.СообщениеОбОшибке = НСтр("ru = 'Ошибка аутентификации.'");
				КонецЕсли;
				
			КонецЕсли;
			
		Исключение
			
			ИнфОшибка = ИнформацияОбОшибке();
			
			Результат.КодОшибки = "ОшибкаСервиса";
			
			Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось получить тикет аутентификации в Менеджере сервиса (%1).
					|Некорректный ответ Менеджера сервиса.
					|Ошибка при обработке ответа Менеджера сервиса:
					|%2
					|Код состояния: %3;
					|Тело ответа: %4
					|Тело запроса: %5'"),
				URLСервиса,
				ПодробноеПредставлениеОшибки(ИнфОшибка),
				РезультатОперации.КодСостояния,
				Лев(РезультатОперации.Содержимое, 5120),
				ТелоЗапроса);
			ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(
				Результат.ИнформацияОбОшибке);
			
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
				Результат.СообщениеОбОшибке =
					НСтр("ru = 'Ошибка аутентификации. Некорректный ответ сервиса.'");
			Иначе
				Результат.СообщениеОбОшибке = НСтр("ru = 'Ошибка аутентификации.'");
			КонецЕсли;
			
		КонецПопытки;
		
	ИначеЕсли РезультатОперации.КодСостояния = 0 Тогда
		
		// Ошибка соединения.
		Результат.КодОшибки = "ОшибкаПодключения";
		Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить тикет аутентификации в Менеджере сервиса (%1).
				|Не удалось подключиться к Менеджеру сервиса.
				|%2'"),
			URLСервиса,
			РезультатОперации.ИнформацияОбОшибке);
		ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(
			Результат.ИнформацияОбОшибке);
		
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
			Результат.СообщениеОбОшибке =
				НСтр("ru = 'Не удалось подключиться к сервису.'")
					+ Символы.ПС + РезультатОперации.СообщениеОбОшибке;
		Иначе
			Результат.СообщениеОбОшибке = НСтр("ru = 'Ошибка аутентификации.'");
		КонецЕсли;
		
	Иначе
		
		// Неизвестная ошибка сервиса.
		ИнфОшибка = ИнформацияОбОшибке();
		
		Результат.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить тикет аутентификации в Менеджере сервиса (%1).
				|Некорректный ответ Менеджера сервиса.
				|Ошибка при обработке ответа Менеджера сервиса:
				|%2
				|Код состояния: %3;
				|Тело ответа: %4
				|Тело запроса: %5'"),
			URLСервиса,
			ПодробноеПредставлениеОшибки(ИнфОшибка),
			РезультатОперации.КодСостояния,
			Лев(РезультатОперации.Содержимое, 5120),
			ТелоЗапроса);
		ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(
			Результат.ИнформацияОбОшибке);
		
		Результат.КодОшибки = "НеизвестнаяОшибка";
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
			Результат.СообщениеОбОшибке =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неизвестная ошибка сервиса аутентификации (%1).'"),
					РезультатОперации.КодСостояния);
		Иначе
			Результат.СообщениеОбОшибке = НСтр("ru = 'Ошибка аутентификации.'");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НастройкиПодключенияКМенеджеруСервиса()
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Структура;
	Результат.Вставить("URL", РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса());
	Результат.Вставить("ИмяСлужебногоПользователя",
		РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса());
	Результат.Вставить("ПарольСлужебногоПользователя",
		РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса());
	
	Возврат Результат;
	
КонецФункции

Функция КлючОбластиДанных(ЗначениеРазделителя)
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		// В разделенном режиме не кэшируется, т.к.
		// нет необходимости входить в область данных.
		УстановитьПривилегированныйРежим(Истина);
		Возврат Константы.КлючОбластиДанных.Получить();
	Иначе
		// Результат кэшируется, т.к. необходимо выполнить вход в область данных.
		Возврат ИнтернетПоддержкаПользователейВМоделиСервисаПовтИсп.КлючОбластиДанных(ЗначениеРазделителя);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
