﻿#Область ПрограммныйИнтерфейс

// Формирует массив реквизитов документа. 
// 
// Параметры: 
//  ИмяДокумента - Строка - имя документа.
//
// Возвращаемое значение:
//   Массив - массив наименований реквизитов документа. 
//
Функция МассивРеквизитовОбъектаДляФормированияПредставления(ИмяДокумента) Экспорт
	
	МассивДопРеквизитов = Новый Массив;
	
	// _Демо начало примера 
	
	Если ИмяДокумента = "ЭлектронноеПисьмоИсходящее" Тогда
		
		МассивДопРеквизитов.Добавить("ДатаОтправления");
		МассивДопРеквизитов.Добавить("Тема");
		МассивДопРеквизитов.Добавить("СписокПолучателейПисьма");
		
	ИначеЕсли ИмяДокумента = "ЭлектронноеПисьмоВходящее" Тогда
		
		МассивДопРеквизитов.Добавить("Дата");
		МассивДопРеквизитов.Добавить("Тема");
		МассивДопРеквизитов.Добавить("ОтправительПредставление");
		
	КонецЕсли;
	
	// _Демо конец примера
	
	Возврат МассивДопРеквизитов
	
КонецФункции

// Получает представление документа для печати.
//
// Параметры:
//  Выборка  - КоллекцияДанных - структура или выборка из результатов запроса
//                 в которой содержатся дополнительные реквизиты, на основании
//                 которых можно сформировать переопределенное представление 
//                 документа для вывода в отчет "Структура подчиненности".
//
// Возвращаемое значение:
//   Строка,Неопределено   - переопределенное представление документа, или Неопределено,
//                           если для данного типа документов такое не задано.
//
Функция ПредставлениеОбъектаДляВыводаВОтчет(Выборка) Экспорт
	
	// _Демо начало примера 
	
	Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
	
		ПереопределяемоеПредставление = НСтр("ru = '""%2"" для %3 %1'");
		ПереопределяемоеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПереопределяемоеПредставление,
			?(Выборка.ДополнительныйРеквизит1 = Дата(1,1,1),
				НСтр("ru = '(черновик)'"),
				НСтр("ru='отправленное'") + " " + Формат(Выборка.ДополнительныйРеквизит1,"ДЛФ=DDT")),
			Выборка.ДополнительныйРеквизит2,
			Выборка.ДополнительныйРеквизит3);
		
		Возврат ПереопределяемоеПредставление;
		
	ИначеЕсли ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
		
		ПереопределяемоеПредставление = НСтр("ru = '""%2"" от %3 отправленное %1'");
		ПереопределяемоеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПереопределяемоеПредставление,
			Формат(Выборка.ДополнительныйРеквизит1,"ДЛФ=DDT"),
			Выборка.ДополнительныйРеквизит2,
			Выборка.ДополнительныйРеквизит3);
		
		Возврат ПереопределяемоеПредставление;
		
	КонецЕсли;
	
	// _Демо конец примера
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает имя реквизита документа, в котором содержится информация о Сумме и Валюте документа для вывода в
// структуру подчиненности.
// По умолчанию используются реквизиты Валюта и СуммаДокумента. Если для конкретного документа или конфигурации в целом
// используются другие
// реквизиты, то переопределить значения по умолчанию можно в данной функции.
//
// Параметры:
//  ИмяДокумента  - Строка - имя документа, для которого надо получить имя реквизита.
//  Реквизит      - Строка - Строка, может принимать значения "Валюта" и "СуммаДокумента".
//
// Возвращаемое значение:
//   Строка   - Имя реквизита документа, в котором содержится информация о Валюте или Сумме.
//
Функция ИмяРеквизитаДокумента(ИмяДокумента, Реквизит) Экспорт
	
	// _Демо начало примера 
	
	Если ИмяДокумента = "_ДемоСчетНаОплатуПокупателю" Тогда
		
		Если Реквизит = "СуммаДокумента" Тогда
			Возврат "СуммаОплаты";
		ИначеЕсли Реквизит = "Валюта" Тогда
			Возврат "ВалютаДокумента";
		КонецЕсли;
		
	КонецЕсли;
	
	// _Демо конец примера
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
