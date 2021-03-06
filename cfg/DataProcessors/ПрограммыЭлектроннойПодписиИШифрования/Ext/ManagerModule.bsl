﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ОписаниеПрограмм = Новый Массив;
	
	ОписаниеПрограмм.Добавить(ЭлектроннаяПодпись.НовоеОписаниеПрограммы(
		"Infotecs Cryptographic Service Provider", 2));
	
	ОписаниеПрограмм.Добавить(ЭлектроннаяПодпись.НовоеОписаниеПрограммы(
		"Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider", 75));
	
	ЭлектроннаяПодпись.ЗаполнитьСписокПрограмм(ОписаниеПрограмм);
	
КонецПроцедуры

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// для которых необходимо обновить записи в регистре.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПрограммыЭлектроннойПодписиИШифрования.Ссылка
		|ИЗ
		|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
		|ГДЕ
		|	ПрограммыЭлектроннойПодписиИШифрования.ЭтоПрограммаОблачногоСервиса";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

// При включении сервиса криптографии создается программа электронной подписи и шифрования.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	ВыборкаДетальныеЗаписи = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ПрограммыЭлектроннойПодписиИШифрования");
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Программа = Неопределено;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.Ссылка.ПометкаУдаления Тогда
			Программа = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Иначе
			// Есть программа уже создана и не помечена на удаление, не создаем новую.
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ВыборкаДетальныеЗаписи.Ссылка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если ОбъектовОбработано = 0 Тогда
		НачатьТранзакцию();
		Попытка
		
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ПрограммыЭлектроннойПодписиИШифрования");
				
			Блокировка.Заблокировать();
		
			Если Программа = Неопределено Тогда
				Программа = Справочники.ПрограммыЭлектроннойПодписиИШифрования.СоздатьЭлемент();
				Программа.Наименование = НСтр("ru = 'Облачный сервис'");
				Программа.ЭтоПрограммаОблачногоСервиса = Истина;
				Программа.Записать();
			Иначе
				// Если программа уже создана, снимаем пометку удаления.
				Программа.УстановитьПометкуУдаления(Ложь);
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Программа.Ссылка);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			// Если не удалось обработать какой-либо документ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось добавить программу Облачный сервис по причине:
				|%1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				, , ТекстСообщения);
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ПрограммыЭлектроннойПодписиИШифрования") Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедуре Обработки.ОбработатьДанныеДляПереходаНаНовуюВерсию.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые программы электронной подписи (пропущены): %1'"), 
		ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
		Метаданные.НайтиПоПолномуИмени("Справочник.ПрограммыЭлектроннойПодписиИШифрования"),,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедура Обработки.ОбработатьДанныеДляПереходаНаНовуюВерсию.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию программ электронной подписи: %1'"),
		ОбъектовОбработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;

КонецПроцедуры

#КонецОбласти
#КонецЕсли