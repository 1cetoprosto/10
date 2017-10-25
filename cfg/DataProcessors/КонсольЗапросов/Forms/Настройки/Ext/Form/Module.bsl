﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПередачи = ПолучитьИзВременногоХранилища(Параметры.АдресХранилища);
	Объект.ИспользоватьАвтосохранение 						= ПараметрыПередачи.ИспользоватьАвтосохранение;	
	Объект.ПериодАвтосохранения 							= ПараметрыПередачи.ПериодАвтосохранения;	
	Объект.ВыводитьВРезультатахЗапросаЗначенияСсылок		= ПараметрыПередачи.ВыводитьВРезультатахЗапросаЗначенияСсылок;
	Объект.ТипОбхода										= ПараметрыПередачи.ТипОбхода;
	Объект.ЧередованиеЦветовВРезультатеЗапроса				= ПараметрыПередачи.ЧередованиеЦветовВРезультатеЗапроса;
	
	Элементы.ТипОбхода.СписокВыбора.Добавить("Авто");
	Элементы.ТипОбхода.СписокВыбора.Добавить("Прямой");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	ПараметрыПередачи = ПоместитьНастройкиВСтруктуру();
	
	// Передача в открывающую форму.
	Закрыть(); 
	Владелец		= ЭтотОбъект.ВладелецФормы;
	
	Оповестить("ПередатьПараметрыНастроек" , ПараметрыПередачи);
	Оповестить("ПередатьПараметрыНастроекАвтоСохранения");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаСервере
Функция ПоместитьНастройкиВСтруктуру()
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("АдресХранилища", ОбъектОбработки().ПоместитьНастройкиВоВременноеХранилище(Объект));
	Возврат ПараметрыПередачи;
КонецФункции	

#КонецОбласти
