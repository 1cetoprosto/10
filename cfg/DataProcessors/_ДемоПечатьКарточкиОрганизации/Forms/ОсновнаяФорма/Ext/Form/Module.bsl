﻿#Область ПрограммныйИнтерфейс

// Формирует печатную форму карточки конфигурации и открывает ее в форме ПечатьДокументов.
//
// Параметры:
//  ПараметрыПечати - Структура - описание команды печати, подробнее см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
// Возвращаемое значение:
//  Неопределено - возвращать результат не требуется.
//
&НаКлиенте
Функция ПечатьКарточкиОрганизации(ПараметрыПечати) Экспорт
	ОбластиОбъектов = Новый СписокЗначений;
	ТабличныйДокумент = СформироватьКарточкуОрганизации(ПараметрыПечати.ОбъектыПечати, ОбластиОбъектов);
	
	ИдентификаторПечатнойФормы = "КарточкаОрганизации";
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ИдентификаторПечатнойФормы);
	ПечатнаяФорма = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, ИдентификаторПечатнойФормы);
	ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Карточка организации'");
	ПечатнаяФорма.ТабличныйДокумент = ТабличныйДокумент;
	ПечатнаяФорма.ИмяФайлаПечатнойФормы = НСтр("ru = 'Карточка организации'");
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция СформироватьКарточкуОрганизации(СписокОрганизаций, ОбластиОбъектов)
	Возврат Обработки._ДемоПечатьКарточкиОрганизации.СформироватьКарточкуОрганизации(СписокОрганизаций, ОбластиОбъектов);
КонецФункции

#КонецОбласти
