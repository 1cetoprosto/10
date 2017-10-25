﻿#Область ОписаниеПеременных

&НаКлиенте
Перем РазрешенияПолучены;

&НаКлиенте
Перем ПроверкаЗаполненияПараметрыЗаписи;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.БлокироватьВладельца Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ДоступноПолучениеПисем = РаботаСПочтовымиСообщениямиСлужебный.НастройкиПодсистемы().ДоступноПолучениеПисем;
	Элементы.ИспользоватьУчетнуюЗапись.ОтображатьЗаголовок = ДоступноПолучениеПисем;
	Элементы.ДляПолучения.Видимость = ДоступноПолучениеПисем;
	Элементы.ОставлятьПисьмаНаСервере.Видимость = ДоступноПолучениеПисем;
	Если Не ДоступноПолучениеПисем Тогда
		Элементы.ДляОтправки.Заголовок = НСтр("ru = 'Использовать для отправки писем'");
	КонецЕсли;
	Элементы.ПолучениеПисем.Доступность = ДоступноПолучениеПисем Или Объект.ТребуетсяВходНаСерверПередОтправкой;
	Элементы.Протокол.Доступность = ДоступноПолучениеПисем;
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ИспользоватьДляОтправки = Истина;
		Объект.ИспользоватьДляПолучения = ДоступноПолучениеПисем;
	КонецЕсли;
	
	УдалятьПисьмаССервера = Объект.ПериодХраненияСообщенийНаСервере > 0;
	Если Не УдалятьПисьмаССервера Тогда
		Объект.ПериодХраненияСообщенийНаСервере = 10;
	КонецЕсли;
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		УстановитьПривилегированныйРежим(Истина);
		Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Объект.Ссылка, "Пароль, ПарольSMTP");
		УстановитьПривилегированныйРежим(Ложь);
		Пароль = ?(ЗначениеЗаполнено(Пароли.Пароль), ЭтотОбъект.УникальныйИдентификатор, "");
		ПарольSMTP = ?(ЗначениеЗаполнено(Пароли.ПарольSMTP), ЭтотОбъект.УникальныйИдентификатор, "");
	КонецЕсли;
	
	Элементы.ФормаЗаписатьИЗакрыть.Доступность = Не ТолькоПросмотр;
	
	ЭтоПерсональнаяУчетнаяЗапись = ЗначениеЗаполнено(Объект.ВладелецУчетнойЗаписи);
	Элементы.ПользовательУчетнойЗаписи.Доступность = ЭтоПерсональнаяУчетнаяЗапись;
	ВидУчетнойЗаписи = ?(ЭтоПерсональнаяУчетнаяЗапись, "Персональная", "Общая");
	Элементы.ГруппаДляКогоУчетнаяЗапись.Доступность = Пользователи.ЭтоПолноправныйПользователь();
	ВладелецУчетнойЗаписи = Объект.ВладелецУчетнойЗаписи;
	
	ТребуетсяАвторизацияПриОтправкеПисем = ЗначениеЗаполнено(Объект.ПользовательSMTP);
	Элементы.АвторизацияПриОтправкеПисем.Доступность = ТребуетсяАвторизацияПриОтправкеПисем;
	
	ШифрованиеПриОтправкеПочты = ?(Объект.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты, "SSL", "Авто");
	ШифрованиеПриПолученииПочты = ?(Объект.ИспользоватьЗащищенноеСоединениеДляВходящейПочты, "SSL", "Авто");
	
	СпособАвторизацииПриОтправкеПочты = ?(Объект.ТребуетсяВходНаСерверПередОтправкой, "POP", "SMTP");
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ПарольИзменен Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, Пароль);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Если ПарольSMTPИзменен Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, ПарольSMTP, "ПарольSMTP");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если ВидУчетнойЗаписи = "Персональная" И Не ЗначениеЗаполнено(Объект.ВладелецУчетнойЗаписи) Тогда 
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Не выбран владелец учетной записи.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ВладелецУчетнойЗаписи");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ДополнительныеСвойства.Вставить("Пароль", ПроверкаПароля);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемПодтверждениеПолучено", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ, ЗавершениеРаботы);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не УдалятьПисьмаССервера Тогда
		Объект.ПериодХраненияСообщенийНаСервере = 0;
	КонецЕсли;
	
	Если Объект.ПротоколВходящейПочты = "IMAP" Тогда
		Объект.ОставлятьКопииСообщенийНаСервере = Истина;
		Объект.ПериодХраненияСообщенийНаСервере = 0;
	КонецЕсли;
	
	Если Не ПроверкаЗаполненияВыполнена(ПараметрыЗаписи) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если РазрешенияПолучены <> Истина Тогда
		
		ДанныеОбъекта = Новый Структура("Ссылка,ИспользоватьДляОтправки,СерверИсходящейПочты,ПортСервераИсходящейПочты,ИспользоватьДляПолучения,
			|ПротоколВходящейПочты,СерверВходящейПочты,ПортСервераВходящейПочты");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
		Запрос = СоздатьЗапросНаИспользованиеВнешнихРесурсов(ДанныеОбъекта);
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПолучениеРазрешенийЗавершение", ЭтотОбъект, ПараметрыЗаписи);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
			МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запрос), ЭтотОбъект, ОповещениеОЗакрытии);
		Иначе
			ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ВидУчетнойЗаписи = "Общая" И ЗначениеЗаполнено(Объект.ВладелецУчетнойЗаписи) Тогда
		Объект.ВладелецУчетнойЗаписи = Неопределено;
	КонецЕсли;
	
	ТребуетсяПроверкаПароля = Объект.ВладелецУчетнойЗаписи <> ВладелецУчетнойЗаписи
		Или ЗначениеЗаполнено(Объект.ВладелецУчетнойЗаписи);
	Если Не ПараметрыЗаписи.Свойство("ПарольВведен") И ТребуетсяПроверкаПароля Тогда
		Отказ = Истина;
		ЗапроситьПароль(ПараметрыЗаписи);
		Возврат;
	КонецЕсли;
	
	РазрешенияПолучены = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УчетнаяЗаписьЭлектроннойПочты",,Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ЗаписатьИЗакрыть") Тогда
		Закрыть();
	КонецЕсли;
	
	ВладелецУчетнойЗаписи = Объект.ВладелецУчетнойЗаписи;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПротоколПриИзменении(Элемент)
	
	Если Объект.ПротоколВходящейПочты = "IMAP" Тогда
		Если СтрНачинаетсяС(Объект.СерверВходящейПочты, "pop.") Тогда
			Объект.СерверВходящейПочты = "imap." + Сред(Объект.СерверВходящейПочты, 5);
		КонецЕсли
	Иначе
		Если ПустаяСтрока(Объект.ПротоколВходящейПочты) Тогда
			Объект.ПротоколВходящейПочты = "POP";
		КонецЕсли;
		Если СтрНачинаетсяС(Объект.СерверВходящейПочты, "imap.") Тогда
			Объект.СерверВходящейПочты = "pop." + Сред(Объект.СерверВходящейПочты, 6);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПортВходящейПочты();
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура СерверВходящейПочтыПриИзменении(Элемент)
	Объект.СерверВходящейПочты = СокрЛП(НРег(Объект.СерверВходящейПочты));
КонецПроцедуры

&НаКлиенте
Процедура СерверИсходящейПочтыПриИзменении(Элемент)
	Объект.СерверИсходящейПочты = СокрЛП(НРег(Объект.СерверИсходящейПочты));
КонецПроцедуры

&НаКлиенте
Процедура АдресЭлектроннойПочтыПриИзменении(Элемент)
	Объект.АдресЭлектроннойПочты = СокрЛП(Объект.АдресЭлектроннойПочты);
КонецПроцедуры

&НаКлиенте
Процедура ОставлятьКопииПисемНаСервереПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура УдалятьПисьмаССервераПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПарольДляПолученияПисемПриИзменении(Элемент)
	ПарольИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПарольДляОтправкиПисемПриИзменении(Элемент)
	ПарольSMTPИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДляКогоУчетнаяЗаписьПриИзменении(Элемент)
	Элементы.ПользовательУчетнойЗаписи.Доступность = ВидУчетнойЗаписи = "Персональная";
	ОповеститьОбИзмененииВладельцаУчетнойЗаписи();
КонецПроцедуры

&НаКлиенте
Процедура ПользовательУчетнойЗаписиПриИзменении(Элемент)
	ОповеститьОбИзмененииВладельцаУчетнойЗаписи();
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяВходНаСерверПередОтправкойПриИзменении(Элемент)
	Элементы.ПолучениеПисем.Доступность = ДоступноПолучениеПисем Или Объект.ТребуетсяВходНаСерверПередОтправкой;
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяАвторизацияПриОтправкеПисемПриИзменении(Элемент)
	Элементы.АвторизацияПриОтправкеПисем.Доступность = ТребуетсяАвторизацияПриОтправкеПисем;
КонецПроцедуры

&НаКлиенте
Процедура ШифрованиеПриОтправкеПочтыПриИзменении(Элемент)
	Объект.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты = ШифрованиеПриОтправкеПочты = "SSL";
	УстановитьПортИсходящейПочты();
КонецПроцедуры

&НаКлиенте
Процедура ШифрованиеПриПолученииПочтыПриИзменении(Элемент)
	Объект.ИспользоватьЗащищенноеСоединениеДляВходящейПочты = ШифрованиеПриПолученииПочты = "SSL";
	УстановитьПортВходящейПочты();
КонецПроцедуры

&НаКлиенте
Процедура СпособАвторизацииПриОтправкеПочтыПриИзменении(Элемент)
	Объект.ТребуетсяВходНаСерверПередОтправкой = ?(СпособАвторизацииПриОтправкеПочты = "POP", Истина, Ложь);
	Элементы.ЛогинИПарольПриОтправкеПисем.Доступность = Не Объект.ТребуетсяВходНаСерверПередОтправкой;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Записать(Новый Структура("ЗаписатьИЗакрыть"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьПортВходящейПочты()
	Если Объект.ПротоколВходящейПочты = "IMAP" Тогда
		Если Объект.ИспользоватьЗащищенноеСоединениеДляВходящейПочты Тогда
			Объект.ПортСервераВходящейПочты = 993;
		Иначе
			Объект.ПортСервераВходящейПочты = 143;
		КонецЕсли;
	Иначе
		Если Объект.ИспользоватьЗащищенноеСоединениеДляВходящейПочты Тогда
			Объект.ПортСервераВходящейПочты = 995;
		Иначе
			Объект.ПортСервераВходящейПочты = 110;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПортИсходящейПочты()
	Если Объект.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты Тогда
		Объект.ПортСервераИсходящейПочты = 465;
	Иначе
		Объект.ПортСервераИсходящейПочты = 25;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПодтверждениеПолучено(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Записать(Новый Структура("ЗаписатьИЗакрыть"));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	ИспользуетсяПротоколPOP = Объект.ПротоколВходящейПочты = "POP";
	Элементы.POPПередSMTP.Видимость = ИспользуетсяПротоколPOP;
	Элементы.ОставлятьПисьмаНаСервере.Видимость = ИспользуетсяПротоколPOP И ДоступноПолучениеПисем;
	
	Элементы.НастройкаПериодаХраненияПисем.Доступность = Объект.ОставлятьКопииСообщенийНаСервере;
	Элементы.ПериодХраненияСообщенийНаСервере.Доступность = УдалятьПисьмаССервера;
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеРазрешенийЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		РазрешенияПолучены = Истина;
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(Объект)
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	Возврат МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
		Разрешения(Объект), Объект.Ссылка);
	
КонецФункции

&НаСервереБезКонтекста
Функция Разрешения(Объект)
	
	Результат = Новый Массив;
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Если Объект.ИспользоватьДляОтправки Тогда
		Результат.Добавить(
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
				"SMTP",
				Объект.СерверИсходящейПочты,
				Объект.ПортСервераИсходящейПочты,
				НСтр("ru = 'Электронная почта.'")));
	КонецЕсли;
	
	Если Объект.ИспользоватьДляПолучения Тогда
		Результат.Добавить(
			МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
				Объект.ПротоколВходящейПочты,
				Объект.СерверВходящейПочты,
				Объект.ПортСервераВходящейПочты,
				НСтр("ru = 'Электронная почта.'")));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗапроситьПароль(ПараметрыЗаписи)
	ПроверкаПароля = "";
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВводаПароля", ЭтотОбъект, ПараметрыЗаписи);
	ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.Форма.ПроверкаДоступаКУчетнойЗаписи", ,
		ЭтотОбъект, , , , ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаПароля(Пароль, ПараметрыЗаписи) Экспорт
	Если ТипЗнч(Пароль) = Тип("Строка") Тогда
		ПараметрыЗаписи.Вставить("ПарольВведен");
		ПроверкаПароля = Пароль;
		Записать(ПараметрыЗаписи);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзмененииВладельцаУчетнойЗаписи()
	Оповестить("ПриИзмененииВидаУчетнойЗаписиЭлектроннойПочты", ВидУчетнойЗаписи = "Персональная", ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Функция ПроверкаЗаполненияВыполнена(ПараметрыЗаписи)
	Если ПараметрыЗаписи.Свойство("ПроверкаЗаполненияВыполнена") Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПроверкаЗаполненияПараметрыЗаписи = ПараметрыЗаписи;
	ПодключитьОбработчикОжидания("ПроверитьЗаполнениеИЗаписать", 0.1, Истина);
	
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ПроверитьЗаполнениеИЗаписать()
	Если ПроверитьЗаполнение() Тогда
		ПроверкаЗаполненияПараметрыЗаписи.Вставить("ПроверкаЗаполненияВыполнена");
		Записать(ПроверкаЗаполненияПараметрыЗаписи);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
