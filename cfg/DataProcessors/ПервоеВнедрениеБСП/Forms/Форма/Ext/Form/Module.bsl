﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗначениеОбъект = РеквизитФормыВЗначение("Объект");
	Подсистемы.Загрузить(ЗначениеОбъект.ЗависимостиПодсистем());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодсистемыПометкаПриИзменении(Элемент)
	
	Если Элементы.Подсистемы.ТекущиеДанные.Пометка Тогда
		
		Отбор = Новый Структура("Имя");
		Для Каждого ЗависимаяПодсистема Из Элементы.Подсистемы.ТекущиеДанные.ЗависитОтПодсистем Цикл
			
			Отбор.Имя = ЗависимаяПодсистема;
			СтрокаПодсистемы = Подсистемы.НайтиСтроки(Отбор)[0];
			
			Если СтрокаПодсистемы.Пометка <> Истина Тогда
				СтрокаПодсистемы.Пометка = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсистемыПриАктивизацииСтроки(Элемент)
	
	Если ПустаяСтрока(Элементы.Подсистемы.ТекущиеДанные.Имя) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура("Имя");
	МассивСинонимов = Новый Массив;
	
	Для Каждого ИмяПодсистемы Из Элементы.Подсистемы.ТекущиеДанные.ЗависитОтПодсистем Цикл
		Отбор.Имя = ИмяПодсистемы;
		НайденнаяСтрока = Подсистемы.НайтиСтроки(Отбор)[0];
		МассивСинонимов.Добавить(НайденнаяСтрока.Синоним);
	КонецЦикла;
	ЗависитОтПодсистем = СтрСоединить(МассивСинонимов, Символы.ПС);
	
	МассивСинонимов.Очистить();
	Для Каждого ИмяПодсистемы Из Элементы.Подсистемы.ТекущиеДанные.УсловноЗависитОтПодсистем Цикл
		Если ИмяПодсистемы = "*" Тогда
			Синоним = НСтр("ru = 'Все подсистемы'");
		Иначе
			Отбор.Имя = ИмяПодсистемы;
			НайденнаяСтрока = Подсистемы.НайтиСтроки(Отбор)[0];
			Синоним = НайденнаяСтрока.Синоним;
		КонецЕсли;
		МассивСинонимов.Добавить(Синоним);
	КонецЦикла;
	УсловноЗависитОтПодсистем = СтрСоединить(МассивСинонимов, Символы.ПС);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьКодНеиспользуемыхПодсистем(Команда)
	
	ЭтоФайловаяБаза = (СтрНайти(ВРег(СтрокаСоединенияИнформационнойБазы()), "FILE=") = 1);
	Если Не ЭтоФайловаяБаза Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Удаление кода неиспользуемых подсистем возможно только в файловой базе.'"));
		Возврат;
	КонецЕсли;
	
	Если ОткрытКонфигуратор() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для удаления фрагментов кода неиспользуемых подсистем необходимо закрыть конфигуратор.'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодтвержденияУдаления", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Будет выполнено удаление фрагментов кода неиспользуемых подсистем. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсистемыСнятьПометки(Команда)
	
	Для Каждого СтрокаПодсистемы Из Подсистемы Цикл
		СтрокаПодсистемы.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсистемыОтметитьВсе(Команда)
	
	Для Каждого СтрокаПодсистемы Из Подсистемы Цикл
		СтрокаПодсистемы.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСписокПодсистем(Команда)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	Отбор = Новый Структура("Пометка", Истина);
	НайденныеСтроки = Подсистемы.НайтиСтроки(Отбор);
	
	Для Каждого Подсистема Из НайденныеСтроки Цикл
		ТекстовыйДокумент.ДобавитьСтроку(Подсистема.Имя);
	КонецЦикла;
	
	ТекстовыйДокумент.Показать(НСтр(" ru = 'Выбранные подсистемы'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиВФайл(Команда)
	
	ИмяФайлаНастроек = СформироватьФайлНастроек();
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок      = НСтр("ru = 'Укажите имя файла настроек сравнения/объединения'");
	Диалог.Расширение     = "xml";
	Диалог.ПредварительныйПросмотр = Ложь;
	Диалог.ПолноеИмяФайла = НСтр("ru = 'ФайлНастроекСравнения'");
	Диалог.Фильтр = НСтр("ru = 'Файл настроек сравнения/объединения (*.xml)|*.xml'");
	Если Диалог.Выбрать() Тогда
		КопироватьФайл(ИмяФайлаНастроек, Диалог.ПолноеИмяФайла);
		УдалитьФайлы(ИмяФайлаНастроек);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПодтвержденияУдаления(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ОчиститьСообщения();
		Состояние(НСтр("ru = 'Выполняется удаление фрагментов кода из модулей конфигурации'"));
		Результат = ВырезатьФрагментыПодсистем();
		УдалитьФайлы(КаталогВыгрузкиМодулей);
		Если Не ПустаяСтрока(Результат.Ошибки) Тогда
			Документ = Новый ТекстовыйДокумент();
			Документ.УстановитьТекст(Результат.Ошибки);
			Документ.Показать(НСтр("ru = 'Пропущенные модули'"));
		КонецЕсли;
		ПоказатьПредупреждение(, СтрЗаменить(НСтр("ru = 'Было проведено замен: %1'"), "%1", Результат.ЧислоЗамен));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подсистемы.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подсистемы.Обязательная");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));
	
КонецПроцедуры

&НаСервере
Функция ВырезатьФрагментыПодсистем()
	
	ИмяАдминистратораИБ = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	ФайловаяБаза = СтрНайти(СтрокаСоединения, "File=");
	ПервыйСимволПути = ФайловаяБаза + 6;
	СтрокаСоединения = Сред(СтрокаСоединения, ПервыйСимволПути);
	ПоследнийСимволПути = СтрНайти(СтрокаСоединения, ";");
	СтрокаСоединения = Лев(СтрокаСоединения, ПоследнийСимволПути - 2);
	КаталогИБ = СтрокаСоединения;
	
	ТекущаяДата = ТекущаяДатаСеанса();
	КаталогВыгрузкиМодулей = ПолучитьИмяВременногоФайла("ВыгрузкаМодулей");
	СоздатьКаталог(КаталогВыгрузкиМодулей);
	
	УдалитьФайлы(КаталогВыгрузкиМодулей, "*");
	ВыгрузитьМодулиКонфигурации();
	
	ЧислоЗамен = 0;
	Ошибки = "";
	ПодсистемыДляУдаления = СписокПодсистемДляУдаления();
	Если ПодсистемыДляУдаления.Количество() > 0 Тогда
		
		МассивФайлов = НайтиФайлы(КаталогВыгрузкиМодулей, "*.txt");
		ТекстФайла = Новый ТекстовыйДокумент;
		
		Для Каждого Файл Из МассивФайлов Цикл 		
			
			ТекстСообщения = НСтр("ru = 'Выполняется удаление фрагментов кода в модуле [ИмяФайлаМодуля]'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "[ИмяФайлаМодуля]", Файл.Имя);
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,, ТекстСообщения);
			
			ТекстФайла.Прочитать(Файл.ПолноеИмя);
			СтрокаТекста = ТекстФайла.ПолучитьТекст();
			Для Каждого ИмяПодсистемы Из ПодсистемыДляУдаления Цикл
				ВырезатьФрагментыПодсистемыВТексте(Файл.Имя, ИмяПодсистемы, СтрокаТекста, ЧислоЗамен, Ошибки);
			КонецЦикла;
			ТекстФайла.УстановитьТекст(СтрокаТекста);
			ТекстФайла.Записать(Файл.ПолноеИмя);
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЧислоЗамен > 0 Тогда
		ЗагрузитьМодулиВКонфигурацию();
	КонецЕсли;
	
	Возврат Новый Структура("ЧислоЗамен,Ошибки", ЧислоЗамен, Ошибки);
	
КонецФункции

&НаСервере
Процедура ВырезатьФрагментыПодсистемыВТексте(ИмяФайлаМодуля, ИмяПодсистемы, СтрокаТекста, ЧислоЗамен, Ошибки)
	
	НачалоФрагмента = НайтиНачалоФрагмента(СтрокаТекста, ИмяПодсистемы);
	Пока НачалоФрагмента > 0 Цикл
		
		ПозицияКонцаФрагмента = НайтиКонецФрагмента(СтрокаТекста, ИмяПодсистемы);
		Если ПозицияКонцаФрагмента = 0 Тогда
			ТекстСообщения = НСтр("ru = '[ИмяФайлаМодуля]: для открывающей скобки [НачалоФрагмента] не обнаружена закрывающая скобка.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "[НачалоФрагмента]", "// " + ИмяПодсистемы);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "[ИмяФайлаМодуля]", ИмяФайлаМодуля);
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
			Ошибки = Ошибки + Символы.ПС + ТекстСообщения;
			Возврат;
		КонецЕсли; 				
		
		Если ПозицияКонцаФрагмента < НачалоФрагмента Тогда
			ТекстСообщения = НСтр("ru = '[ИмяФайлаМодуля]: для открывающей скобки [НачалоФрагмента] закрывающая скобка расположена выше по тексту.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "[НачалоФрагмента]", "// " + ИмяПодсистемы);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "[ИмяФайлаМодуля]", ИмяФайлаМодуля);
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
			Ошибки = Ошибки + Символы.ПС + ТекстСообщения;
			Возврат;
		КонецЕсли; 	

		ДлинаНачалаФрагмента = СтрДлина("// " + ИмяПодсистемы);
		ПромежуточнаяСтрока = Сред(СтрокаТекста, НачалоФрагмента + ДлинаНачалаФрагмента + 1, ПозицияКонцаФрагмента - (НачалоФрагмента + ДлинаНачалаФрагмента) + 1);
		Если НайтиНачалоФрагмента(ПромежуточнаяСтрока, ИмяПодсистемы) > 0 Тогда 
			ТекстСообщения = НСтр("ru = '[ИмяФайлаМодуля]: внутри открывающейся скобки [НачалоФрагмента] есть еще одна открывающаяся скобка, до закрывающейся.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "[НачалоФрагмента]", "// " + ИмяПодсистемы);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "[ИмяФайлаМодуля]", ИмяФайлаМодуля);
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
			Ошибки = Ошибки + Символы.ПС + ТекстСообщения;
			Возврат;
		КонецЕсли;	
		
		ПозицияПоследнегоСимвола = ПозицияКонцаФрагмента + СтрДлина("// Конец " + ИмяПодсистемы);
		ВырезатьФрагмент(СтрокаТекста, НачалоФрагмента - 1, ПозицияПоследнегоСимвола);
		ЧислоЗамен = ЧислоЗамен + 1;
		
		НачалоФрагмента = НайтиНачалоФрагмента(СтрокаТекста, ИмяПодсистемы);
		
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Функция НайтиНачалоФрагмента(Знач СтрокаТекста, Знач ИмяПодсистемы)
	
	СтрокаТекста 	= НРег(СтрокаТекста);
	ИмяПодсистемы 	= НРег(ИмяПодсистемы);
	
	ПервыйВариант = "// " + ИмяПодсистемы;
	ВторойВариант = "//" + ИмяПодсистемы;
	
	Если СтрНайти(СтрокаТекста, ПервыйВариант) = 0 И СтрНайти(СтрокаТекста, ВторойВариант) = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	Для Итерация = 1 По СтрДлина(СтрокаТекста) Цикл
		Если Сред(СтрокаТекста, Итерация, СтрДлина(ПервыйВариант)) = (ПервыйВариант) Тогда 
			Если Не ПустаяСтрока(Сред(СтрокаТекста, Итерация + СтрДлина(ПервыйВариант), 1)) Тогда 
				Продолжить;
			КонецЕсли;
			Возврат Итерация;
		КонецЕсли;
		
		Если Сред(СтрокаТекста, Итерация, СтрДлина(ВторойВариант)) = (ВторойВариант) Тогда 
			Если Не ПустаяСтрока(Сред(СтрокаТекста, Итерация + СтрДлина(ВторойВариант), 1)) Тогда 
				Продолжить;
			КонецЕсли;	
			Возврат Итерация;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат 0;
	
КонецФункции

&НаСервере
Функция НайтиКонецФрагмента(Знач СтрокаТекста, Знач ИмяПодсистемы)
	
	СтрокаТекста 	= НРег(СтрокаТекста);
	ИмяПодсистемы 	= НРег(ИмяПодсистемы);
	
	ПервыйВариант = "// конец " + ИмяПодсистемы;
	ВторойВариант = "//конец " + ИмяПодсистемы;
	
	Если СтрНайти(СтрокаТекста, ПервыйВариант) = 0 И СтрНайти(СтрокаТекста, ВторойВариант) = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	Для Итерация = 1 По СтрДлина(СтрокаТекста) Цикл
		
		Если Сред(СтрокаТекста, Итерация, СтрДлина(ПервыйВариант)) = (ПервыйВариант) Тогда 
			Если Не ПустаяСтрока(Сред(СтрокаТекста, Итерация + СтрДлина(ПервыйВариант), 1)) Тогда 
				Продолжить;
			КонецЕсли;
			Возврат Итерация;
		КонецЕсли;
		
		Если Сред(СтрокаТекста, Итерация, СтрДлина(ВторойВариант)) = (ВторойВариант) Тогда 
			Если Не ПустаяСтрока(Сред(СтрокаТекста, Итерация + СтрДлина(ВторойВариант), 1)) Тогда 
				Продолжить;
			КонецЕсли;
			Возврат Итерация;
		КонецЕсли;
	КонецЦикла;
	
	Возврат 0;
	
КонецФункции

&НаСервере
Процедура ВырезатьФрагмент(СтрокаТекста, Начало, Конец)
	СтрокаТекста = СокрП(Лев(СтрокаТекста, Начало)) + Сред(СтрокаТекста, Конец);
КонецПроцедуры	

&НаСервере
Процедура ЗагрузитьМодулиВКонфигурацию()
		
	СтрокаЗапускаПлатформы = КаталогПрограммы() + "1cv8.exe";
	
	КаталогКонфигурации = КаталогИБ;
	Пользователь = ИмяАдминистратораИБ;
	Пароль = "";
	КоманднаяСтрока = СтрокаЗапускаПлатформы + " DESIGNER /F"""
		+ КаталогКонфигурации + """ /N"""
		+ Пользователь + """ /P""" + Пароль
		+ """ /LoadConfigFiles """ + КаталогВыгрузкиМодулей
		+ """ -Module";
				  
	ЗапуститьПриложение(КоманднаяСтрока,,Истина);
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьМодулиКонфигурации()

	СтрокаЗапускаПлатформы = КаталогПрограммы() + "1cv8.exe";
	КаталогКонфигурации = КаталогИБ;
	Пользователь = ИмяАдминистратораИБ;
	Пароль = "";
	КоманднаяСтрока = СтрокаЗапускаПлатформы + " DESIGNER /F"""
		+ КаталогКонфигурации + """ /N"""
		+ Пользователь + """ /P""" + Пароль
		+ """ /DumpConfigFiles """ + КаталогВыгрузкиМодулей
		+ """ -Module";
				  
	ЗапуститьПриложение(КоманднаяСтрока,,Истина);

КонецПроцедуры

&НаСервере
Функция СписокПодсистемДляУдаления();
	
	СписокПодсистем = Подсистемы.Выгрузить(, "Имя").ВыгрузитьКолонку("Имя");
	СписокИспользуемыхПодсистем = СписокИспользуемыхПодсистем();
	
	ПодсистемыДляУдаления = Новый Массив;
	Для Каждого ИмяПодсистемы Из СписокПодсистем Цикл
		Если СписокИспользуемыхПодсистем.Найти(ИмяПодсистемы) = Неопределено Тогда 
			ПодсистемыДляУдаления.Добавить("СтандартныеПодсистемы." + ИмяПодсистемы);
		КонецЕсли;
	КонецЦикла;
		
	Возврат ПодсистемыДляУдаления;
	
КонецФункции

&НаСервере
Функция СписокИспользуемыхПодсистем()
	
	Результат = Новый Массив;
	СтандартныеПодсистемы = Метаданные.Подсистемы.Найти("СтандартныеПодсистемы");
	Если СтандартныеПодсистемы = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка внедрения БСП. Группа подсистем ""СтандартныеПодсистемы"" не найдена в метаданных конфигурации базы данных.'");
	Иначе
		СписокПодсистем = СтандартныеПодсистемы.Подсистемы;
		ПолучитьПодсистемы(Результат, СписокПодсистем, "")
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПолучитьПодсистемы(СписокПодсистем, ВложенныеПодсистемы, ПутьКПодсистеме)
	
	Если ВложенныеПодсистемы.Количество() > 0 Тогда
		Для Каждого Подсистема Из ВложенныеПодсистемы Цикл
			РезервныйПуть = ПутьКПодсистеме;
			ПутьКПодсистеме = ПутьКПодсистеме + "." + Строка(Подсистема.Имя);
			ПолучитьПодсистемы(СписокПодсистем, Подсистема.Подсистемы, ПутьКПодсистеме);
			СписокПодсистем.Добавить(Сред(ПутьКПодсистеме, 2));
			ПутьКПодсистеме = РезервныйПуть;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Помощник внедрения БСП'", Метаданные.ОсновнойЯзык.КодЯзыка);
	
КонецФункции

&НаСервере
Функция ОткрытКонфигуратор()
	
	Для Каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если ВРег(Сеанс.ИмяПриложения) = ВРег("Designer") Тогда // Конфигуратор
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция СформироватьФайлНастроек()
	
	ФайлШаблона = ПолучитьИмяВременногоФайла("xml");
	ЗаписьТекста = Новый ЗаписьТекста(ФайлШаблона);
	ЗаписьТекста.Записать(РеквизитФормыВЗначение("Объект").ПолучитьМакет("ШаблонНастроек").ПолучитьТекст());
	ЗаписьТекста.Закрыть();
	
	ДокументDOM = ДокументDOM(ФайлШаблона);
	УдалитьФайлы(ФайлШаблона);
	
	// Раздел Objects.
	УзелОбъекты = ДокументDOM.ПолучитьЭлементыПоИмени("Objects")[0];
	
	УстановитьФлажкиПодсистем(ДокументDOM, УзелОбъекты, "");
	
	ИмяФайлаНастроек = ПолучитьИмяВременногоФайла("xml");
	ЗаписатьДокументDOMВФайл(ДокументDOM, ИмяФайлаНастроек);
	Возврат ИмяФайлаНастроек;
	
КонецФункции

&НаСервере
Функция ДокументDOM(ПутьКФайлу)
	
	ЧтениеXML = Новый ЧтениеXML;
	ПостроительDOM = Новый ПостроительDOM;
	ЧтениеXML.ОткрытьФайл(ПутьКФайлу);
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	Возврат ДокументDOM;
	
КонецФункции

&НаСервере
Процедура УстановитьФлажкиПодсистем(ДокументDOM, УзелОбъекты, ИмяФайлаЗахвата)
	
	Для Каждого Подсистема Из Подсистемы Цикл
		
		Если Не Подсистема.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ШаблонИмени = "Подсистема.СтандартныеПодсистемы.Подсистема.%1";
		ПолноеИмя = СтрЗаменить(ШаблонИмени, "%1", Подсистема.Имя);
		
		ДобавитьОписаниеПодсистемы(ПолноеИмя, ДокументDOM, УзелОбъекты);
		Если Подсистема.Имя = "НастройкиПрограммы" Тогда
			ПолноеИмя = "Подсистема.Администрирование";
			ДобавитьОписаниеПодсистемы(ПолноеИмя, ДокументDOM, УзелОбъекты, Истина);
		ИначеЕсли Подсистема.Имя = "ПодключаемыеКоманды" Тогда
			ПолноеИмя = "Подсистема.ПодключаемыеОтчетыИОбработки";
			ДобавитьОписаниеПодсистемы(ПолноеИмя, ДокументDOM, УзелОбъекты, Истина);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОписаниеПодсистемы(ИмяПодсистемы, ДокументDOM, УзелОбъекты, ИнтерфейснаяПодсистема = Ложь)
	
	УзелОбъект = ДокументDOM.СоздатьЭлемент("Object");
	УзелОбъект.УстановитьАтрибут("fullNameInSecondConfiguration", ИмяПодсистемы);
	
	УзелПравило = ДокументDOM.СоздатьЭлемент("MergeRule");
	УзелПравило.ТекстовоеСодержимое = "GetFromSecondConfiguration";
	УзелОбъект.ДобавитьДочерний(УзелПравило);
	
	Если Не ИнтерфейснаяПодсистема Тогда
		УзелПодсистема = ДокументDOM.СоздатьЭлемент("Subsystem");
		УзелПодсистема.УстановитьАтрибут("configuration", "Second");
		УзелПодсистема.УстановитьАтрибут("includeObjectsFromSubordinateSubsystems", "true");
		
		УзелПравило = ДокументDOM.СоздатьЭлемент("MergeRule");
		УзелПравило.ТекстовоеСодержимое = "GetFromSecondConfiguration";
		УзелПодсистема.ДобавитьДочерний(УзелПравило);
		УзелОбъект.ДобавитьДочерний(УзелПодсистема);
	КонецЕсли;
	
	УзелОбъекты.ДобавитьДочерний(УзелОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДокументDOMВФайл(ДокументDOM, ПутьКФайлу)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ПутьКФайлу);
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
	
КонецПроцедуры

#КонецОбласти