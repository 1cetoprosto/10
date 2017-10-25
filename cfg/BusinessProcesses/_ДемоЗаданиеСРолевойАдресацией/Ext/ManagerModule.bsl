﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
// Возвращаемое значение:
//   Структура   - структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	// Бизнес-процесс не имеет прикладных форм выполнения поручений.
	Возврат Новый Структура;
	
КонецФункции

// Вызывается при перенаправлении задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   НоваяЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	
КонецПроцедуры

// Вызывается при выполнении задачи из формы списка.
//
// Параметры:
//   ЗадачаСсылка - ЗадачаСсылка.ЗадачаИсполнителя - Задача.
//   БизнесПроцессСсылка - ЛюбаяСсылка - Ссылка на бизнес процесс.
//   ТочкаМаршрутаБизнесПроцесса - ЛюбаяСсылка - Точка маршрута.
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт

КонецПроцедуры

// Вызывается для заполнения реквизита ГлавнаяЗадача из данных заполнения.
//
// Параметры:
//  БизнесПроцессОбъект  - БизнесПроцессОбъект - бизнес-процесс.
//  ДанныеЗаполнения     - Произвольный        - данные заполнения, которые передаются в обработчик заполнения.
//  СтандартнаяОбработка - Булево              - если установить Ложь, то стандартная обработка заполнения не будет
//                                               выполнена.
//
Процедура ПриЗаполненииГлавнойЗадачиБизнесПроцесса(БизнесПроцессОбъект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Автор");
	Результат.Добавить("Исполнитель");
	Результат.Добавить("ПроверитьВыполнение");
	Результат.Добавить("Проверяющий");
	Результат.Добавить("СрокИсполнения");
	Результат.Добавить("СрокПроверки");
	
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли