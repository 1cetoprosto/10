﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сгенерировать(Команда)
	СгенерироватьЗаказыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СброситьИзменения(Команда)
	СброситьИзмененияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗапускаОтложенногоОбновления(Команда)
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОтложенногоОбновленияИБ");
КонецПроцедуры

&НаКлиенте
Процедура СброситьСведенияОбОбновлении(Команда)
	
	СброситьСведенияОбОбновленииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокироватьОбъект(Команда)
	ЗаблокироватьОбъектНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОшибкуПриОтложенномОбновлении(Команда)
	
	ДобавитьОшибкуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьОшибкуНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОтложенноеОбновлениеИБ", "ИмитироватьОшибку", Истина,, ИмяПользователя());
	
КонецПроцедуры

&НаСервере
Процедура СгенерироватьЗаказыНаСервере()
	
	// Получаем валюты
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты";
	Валюты = Запрос.Выполнить().Выгрузить();
	
	// Получаем организацию
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Организации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник._ДемоОрганизации КАК Организации";
	Организации = Запрос.Выполнить().Выгрузить();
	
	// Получаем партнера
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	_ДемоПартнеры.Ссылка
	|ИЗ
	|	Справочник._ДемоПартнеры КАК _ДемоПартнеры";
	Партнеры = Запрос.Выполнить().Выгрузить();
	
	// Получаем контрагента
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	_ДемоКонтрагенты.Ссылка
	|ИЗ
	|	Справочник._ДемоКонтрагенты КАК _ДемоКонтрагенты";
	Контрагенты = Запрос.Выполнить().Выгрузить();
	
	// Получаем договоры
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	_ДемоДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	Справочник._ДемоДоговорыКонтрагентов КАК _ДемоДоговорыКонтрагентов";
	Договоры = Запрос.Выполнить().Выгрузить();
	
	АдресДоставки = "<КонтактнаяИнформация xmlns=""http://www.v8.1c.ru/ssl/contactinfo"""
		+ " xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"""
		+ " Представление=""127434, Москва г, Дмитровское ш, дом № 9""><Комментарий/><Состав xsi:type=""Адрес"""
		+ " Страна=""РОССИЯ""><Состав xsi:type=""АдресРФ""><СубъектРФ>Москва г</СубъектРФ><Округ/><СвРайМО><Район/>"
		+ "</СвРайМО><Город/><НаселПункт/><Улица>Дмитровское ш</Улица><ОКТМО>0</ОКТМО><ДопАдрЭл><Номер Тип=""1010"""
		+ " Значение=""9""/></ДопАдрЭл><ДопАдрЭл ТипАдрЭл=""10100000"" Значение=""127434""/></Состав></Состав></КонтактнаяИнформация>";
	
	Индекс = 1;
	НачатьТранзакцию();
	Попытка
		Пока Индекс <= КоличествоЗаказов Цикл
			НовыйДок = Документы._ДемоЗаказПокупателя.СоздатьДокумент();
			Индекс = Индекс + 1;
			НовыйДок.Дата = ДатаСоздания;
			НовыйДок.УдалитьЗаказЗакрыт = ЗаказЗакрыт;
			НовыйДок.Проведен = ЗаказПроведен;
			
			ГСЧ = Новый ГенераторСлучайныхЧисел;
			НовыйДок.Валюта = Валюты.Получить(ГСЧ.СлучайноеЧисло(0, Валюты.Количество() - 1)).Ссылка;
			НовыйДок.Организация = Организации.Получить(0).Ссылка;
			НовыйДок.Партнер = Партнеры.Получить(0).Ссылка;
			НовыйДок.Контрагент = Контрагенты.Получить(0).Ссылка;
			НовыйДок.Договор = Договоры.Получить(0).Ссылка;
			НовыйДок.СуммаДокумента = ГСЧ.СлучайноеЧисло(100, 1000);
			НовыйДок.Комментарий = НСтр("ru = 'Комментарий документа'");
			
			НовыйДок.АдресДоставки = АдресДоставки;
			НовыйДок.АдресДоставкиСтрокой = "";
			
			НовыйДок.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура СброситьИзмененияНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	_ДемоЗаказПокупателя.Ссылка КАК Ссылка
	|ИЗ
	|	Документ._ДемоЗаказПокупателя КАК _ДемоЗаказПокупателя";
	Результат = Запрос.Выполнить().Выгрузить();
	
	АдресДоставки = "<КонтактнаяИнформация xmlns=""http://www.v8.1c.ru/ssl/contactinfo"""
		+ " xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"""
		+ " Представление=""127434, Москва г, Дмитровское ш, дом № 9""><Комментарий/><Состав xsi:type=""Адрес"""
		+ " Страна=""РОССИЯ""><Состав xsi:type=""АдресРФ""><СубъектРФ>Москва г</СубъектРФ><Округ/><СвРайМО><Район/>"
		+ "</СвРайМО><Город/><НаселПункт/><Улица>Дмитровское ш</Улица><ОКТМО>0</ОКТМО><ДопАдрЭл><Номер Тип=""1010"""
		+ " Значение=""9""/></ДопАдрЭл><ДопАдрЭл ТипАдрЭл=""10100000"" Значение=""127434""/></Состав></Состав></КонтактнаяИнформация>";
	
	Для Каждого ДокументСсылка Из Результат Цикл
		ДокументОбъект = ДокументСсылка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ОбменДанными.Загрузка = Истина;
		ДокументОбъект.СтатусЗаказа = Перечисления._ДемоСтатусыЗаказовПокупателей.ПустаяСсылка();
		ДокументОбъект.АдресДоставки = АдресДоставки;
		ДокументОбъект.АдресДоставкиСтрокой = "";
		ДокументОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СброситьСведенияОбОбновленииНаСервере()
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	
	Для Каждого СтрокаДереваБиблиотека Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		
		Если СтрокаДереваБиблиотека.Статус = "Завершено" Тогда
			СтрокаДереваБиблиотека.Статус = "НеВыполнено";
		КонецЕсли;
		
		Для Каждого СтрокаДереваВерсия Из СтрокаДереваБиблиотека.Строки Цикл
			
			Если СтрокаДереваВерсия.Статус = "Завершено" Тогда
				СтрокаДереваВерсия.Статус = "НеВыполнено";
			КонецЕсли;
			
			Для Каждого Обработчик Из СтрокаДереваВерсия.Строки Цикл
				
				Если Обработчик.Статус = "Выполнено" Тогда
					Обработчик.Статус = "НеВыполнено";
				Иначе
					Обработчик.ИнформацияОбОшибке = "";
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	СведенияОбОбновлении.НомерСеанса = Новый СписокЗначений;
	СведенияОбОбновлении.ВремяНачалаОтложенногоОбновления = Неопределено;
	СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления = Неопределено;
	ОбновлениеИнформационнойБазыСлужебный.ЗаписатьСведенияОбОбновленииИнформационнойБазы(СведенияОбОбновлении);
	
КонецПроцедуры

&НаСервере
Процедура ЗаблокироватьОбъектНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	_ДемоЗаказПокупателя.Ссылка КАК Ссылка
	|ИЗ
	|	Документ._ДемоЗаказПокупателя КАК _ДемоЗаказПокупателя
	|ГДЕ
	|	_ДемоЗаказПокупателя.СтатусЗаказа = ЗНАЧЕНИЕ(Перечисление._ДемоСтатусыЗаказовПокупателей.ПустаяСсылка)";
	
	Результат = Запрос.Выполнить().Выгрузить();
	Для Каждого ЗаказПокупателя Из Результат Цикл
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Документ._ДемоЗаказПокупателя");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЗаказПокупателя.Ссылка);
			Блокировка.Заблокировать();
			
			Итератор = 0;
			Итератор2 = 0;
			НоваяДата = ТекущаяДатаСеанса() + 10*60;
			Пока НоваяДата >= ТекущаяДатаСеанса() Цикл
				// Удержание блокировки документа в течение 10 минут.
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
