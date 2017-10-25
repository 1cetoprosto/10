﻿
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПутьКФайлуНачалоВыбораПродолжение", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("КаталогВыгрузкиНачалоВыбораПродолжение", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Объект.ПутьКФайлу);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подготовить(Команда)
	Если Не ЗначениеЗаполнено(Объект.ПутьКФайлу) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо указать путь к файлу, в который будет сохранен результат.'"));
		Возврат;
	КонецЕсли;
	ПодготовитьНаСервере();
	
	Текст = НСтр("ru= 'Описание программного интерфейса подготовлено.'");
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокПредупреждений(Команда)
	Если Объект.ЛогСозданияОписания = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сначала необходимо подготовить описание программного интерфейса.'"));
		Возврат;
	КонецЕсли;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЛогСозданияОписания", Объект.ЛогСозданияОписания);
	ОткрытьФорму(ПолноеИмяФормы("ПредупрежденияПриСозданииОписания"), ПараметрыОткрытия);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьНаСервере()
	МодульОбъекта = РеквизитФормыВЗначение("Объект");
	МодульОбъекта.СформироватьПрограммныйИнтерфейс();
	ЗначениеВРеквизитФормы(МодульОбъекта, "Объект");
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбораПродолжение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Режим = РежимДиалогаВыбораФайла.Сохранение;
		ДиалогСохранения = Новый ДиалогВыбораФайла(Режим);
		ДиалогСохранения.МножественныйВыбор = Ложь;
		ДиалогСохранения.Фильтр = НСтр("ru = 'Описание программного интерфейса'") + "(*.html)|*.html";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПутьКФайлуНачалоВыбораЗавершение", ЭтотОбъект);
		ДиалогСохранения.Показать(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПутьКФайлу = Результат[0];
	// Для совместимости с Linux.
	Объект.ПутьКФайлу = СтрЗаменить(Объект.ПутьКФайлу, "\", "/");
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбораПродолжение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(Режим);
		ДиалогВыбораКаталога.МножественныйВыбор = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения("КаталогВыгрузкиНачалоВыбораЗавершение", ЭтотОбъект);
		ДиалогВыбораКаталога.Показать(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.КаталогВыгрузки = Результат[0];
	// Для совместимости с Linux.
	Объект.КаталогВыгрузки = СтрЗаменить(Объект.КаталогВыгрузки, "\", "/");
	
КонецПроцедуры

&НаКлиенте
Функция ПолноеИмяФормы(Имя)
	ЧастиИмени = СтрРазделить(ИмяФормы, ".");
	ЧастиИмени[3] = Имя;
	Возврат СтрСоединить(ЧастиИмени, ".");
КонецФункции

#КонецОбласти