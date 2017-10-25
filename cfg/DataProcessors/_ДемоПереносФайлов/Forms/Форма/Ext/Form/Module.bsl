﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МассивПереносимыхОМ = Новый Массив;
	
	Для Каждого ОМСправочник Из Метаданные.Справочники Цикл
		Если СтрЗаканчиваетсяНа(ОМСправочник.Имя, "ПрисоединенныеФайлы") Тогда
			КраткоеИмяВладельцаФайлов = Лев(ОМСправочник.Имя, СтрДлина(ОМСправочник.Имя)-19);
			Если Метаданные.Справочники.Найти(КраткоеИмяВладельцаФайлов) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ИмяТипа = "СправочникСсылка." + КраткоеИмяВладельцаФайлов;
			Если Метаданные.Справочники.Файлы.Реквизиты.ВладелецФайла.Тип.СодержитТип(Тип(ИмяТипа)) Тогда
				МассивПереносимыхОМ.Добавить("Справочник."+Лев(ОМСправочник.Имя, СтрДлина(ОМСправочник.Имя)-19));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ИмяОМ Из МассивПереносимыхОМ Цикл
		ОМ = Метаданные.НайтиПоПолномуИмени(ИмяОМ);
		Элементы.ОбъектМетаданныхСФайлами.СписокВыбора.Добавить(ОМ.ПолноеИмя(), ОМ.Представление());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектМетаданныхСФайламиПриИзменении(Элемент)
	
	ЗаполнитьТаблицуСсылок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиФайлы(Команда)
	
	Если ПустаяСтрока(ОбъектМетаданныхСФайлами) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите объект метаданных с файлами.'"), ,
			"ОбъектМетаданныхСФайлами");
		Возврат;
	КонецЕсли;
	
	ПеренестиФайлыСервер();
	ПоказатьПредупреждение(, НСтр("ru = 'Файлы успешно перенесены.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайлыДляПереноса(Команда)
	
	Если ПустаяСтрока(ОбъектМетаданныхСФайлами) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите объект метаданных с файлами.'"), ,
			"ОбъектМетаданныхСФайлами");
		Возврат;
	КонецЕсли;
	СоздатьФайлыДляПереносаНаСервере();
	
	ПоказатьПредупреждение(, НСтр("ru = 'Файлы успешно созданы.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуСсылок()
	
	ТаблицаСсылок.Очистить();
	ТаблицаСсылокЗначение = РеквизитФормыВЗначение("ТаблицаСсылок");
	МассивСсылок = РаботаСФайлами.СсылкиНаОбъектыСФайлами(ОбъектМетаданныхСФайлами);
	Для Каждого Ссылка Из МассивСсылок Цикл
		НоваяСтрока = ТаблицаСсылокЗначение.Добавить();
		НоваяСтрока.Ссылка = Ссылка;
	КонецЦикла;
	ЗначениеВРеквизитФормы(ТаблицаСсылокЗначение, "ТаблицаСсылок");
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиФайлыСервер()
	
	// Переносим файлы из справочника "Демо: Номенклатура".
	Для Каждого Строка Из ТаблицаСсылок Цикл
		РаботаСФайлами.ИзменитьСправочникХраненияФайлов(Строка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьФайлыДляПереносаНаСервере()
	
	// Переносим файлы из справочника "Демо: НоменклатураПрисоединенныеФайлы" в "Файлы".
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ПрисоединенныеФайлы.Автор КАК Автор,
		|	ПрисоединенныеФайлы.ВладелецФайла КАК ВладелецФайлов,
		|	ПрисоединенныеФайлы.Расширение КАК РасширениеБезТочки,
		|	ПрисоединенныеФайлы.Наименование КАК ИмяБезРасширения,
		|	ПрисоединенныеФайлы.ДатаМодификацииУниверсальная КАК ВремяИзмененияУниверсальное,
		|	ПрисоединенныеФайлы.Ссылка КАК Ссылка
		|ИЗ
		|	" + ОбъектМетаданныхСФайлами + "ПрисоединенныеФайлы КАК ПрисоединенныеФайлы";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ПараметрыСозданияФайла = Новый Структура;
	ПараметрыСозданияФайла.Вставить("Автор");
	ПараметрыСозданияФайла.Вставить("ИмяБезРасширения");
	ПараметрыСозданияФайла.Вставить("РасширениеБезТочки");
	ПараметрыСозданияФайла.Вставить("ВремяИзмененияУниверсальное");
	ПараметрыСозданияФайла.Вставить("ВладелецФайлов");
	
	Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ФайлИсточник = ВыборкаДетальныеЗаписи.Ссылка;
		
		МенеджерПрисоединенныхФайлов = Справочники.Файлы;
		
		НачатьТранзакцию();
		
		Попытка
			
			ФайлИсточникОбъект = ФайлИсточник.ПолучитьОбъект();
			
			СсылкаНового = МенеджерПрисоединенныхФайлов.ПолучитьСсылку();
			ПрисоединенныйФайл = МенеджерПрисоединенныхФайлов.СоздатьЭлемент();
			ПрисоединенныйФайл.УстановитьСсылкуНового(СсылкаНового);
			
			ЗаполнитьЗначенияСвойств(ПрисоединенныйФайл, ФайлИсточникОбъект, , "Владелец, Родитель, Код");
			
			ПрисоединенныйФайл.Заполнить(Неопределено);
			
			ПрисоединенныйФайл.Записать();
			
			Если ПрисоединенныйФайл.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
				ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ФайлИсточникОбъект.Ссылка);
				
				МенеджерЗаписи = РегистрыСведений.ДвоичныеДанныеФайлов.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Файл = СсылкаНового;
				МенеджерЗаписи.Прочитать();
				МенеджерЗаписи.Файл = СсылкаНового;
				МенеджерЗаписи.ДвоичныеДанныеФайла = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
				МенеджерЗаписи.Записать();
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
