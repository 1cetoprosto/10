﻿////////////////////////////////////////////////////////////////////////////////
// В форме допустимо использовать только метода программного интерфейса.
// Использование методов служебного программного интерфейса, а также служебных методов не допускается.
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПользовательскиеМакетыПечати) Тогда
		Элементы.ЗадатьДействиеПриВыбореМакетаПечатнойФормы.Видимость = Ложь;
	КонецЕсли;
	
	ЭтоВебКлиент = ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	
	ПредлагатьПерейтиНаСайтПриЗапуске = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщиеНастройкиПользователя", 
		"ПредлагатьПерейтиНаСайтПриЗапуске",
		Ложь);

	// СтандартныеПодсистемы.БазоваяФункциональность
	Если Не ЭтоВебКлиент Тогда
		Элементы.ГруппаУстановитьРасширениеРаботыСФайламиНаКлиенте.Видимость = Ложь;
	КонецЕсли;
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	
	// Определение текущей настройки рабочей даты.
	ЗначениеРабочейДаты = ОбщегоНазначения.РабочаяДатаПользователя();
	Если ЗначениеЗаполнено(ЗначениеРабочейДаты) Тогда
		ИспользоватьТекущуюДатуКомпьютера = 0;
	Иначе
		ИспользоватьТекущуюДатуКомпьютера = 1;
		Элементы.ЗначениеРабочейДаты.Доступность = Ложь;
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	Если ПравоДоступа("Просмотр", Метаданные.НайтиПоТипу(ТипЗнч(АвторизованныйПользователь))) Тогда
		Элементы.СведенияОПользователе.Заголовок = АвторизованныйПользователь;
	Иначе
		Элементы.ГруппаУчетнаяЗапись.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.РаботаСФайлами
	НастройкиРаботыСФайлами = РаботаСФайлами.НастройкиРаботыСФайлами();
	СпрашиватьРежимРедактированияПриОткрытииФайла = НастройкиРаботыСФайлами.СпрашиватьРежимРедактированияПриОткрытииФайла;
	
	Если НастройкиРаботыСФайлами.ДействиеПоДвойномуЩелчкуМыши = "ОткрыватьФайл" Тогда
		ДействиеПоДвойномуЩелчкуМыши = Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл;
	Иначе
		ДействиеПоДвойномуЩелчкуМыши = Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьКарточку;
	КонецЕсли;
	
	Если НастройкиРаботыСФайлами.СпособСравненияВерсийФайлов = "MicrosoftOfficeWord" Тогда
		СпособСравненияВерсийФайлов = Перечисления.СпособыСравненияВерсийФайлов.MicrosoftOfficeWord;
	Иначе
		СпособСравненияВерсийФайлов = Перечисления.СпособыСравненияВерсийФайлов.OpenOfficeOrgWriter;
	КонецЕсли;
	
	ПоказыватьПодсказкиПриРедактированииФайлов = НастройкиРаботыСФайлами.ПоказыватьПодсказкиПриРедактированииФайлов;
	
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = НастройкиРаботыСФайлами.ПоказыватьИнформациюЧтоФайлНеБылИзменен;
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = НастройкиРаботыСФайлами.ПоказыватьЗанятыеФайлыПриЗавершенииРаботы;
	
	ПоказыватьКолонкуРазмер = НастройкиРаботыСФайлами.ПоказыватьКолонкуРазмер;
	
	// Заполнение настроек открытия файлов.
	СтрокаНастройки = НастройкиОткрытияФайлов.Добавить();
	СтрокаНастройки.ТипФайла = Перечисления.ТипыФайловДляВстроенногоРедактора.ТекстовыеФайлы;
	
	СтрокаНастройки.Расширение = НастройкиРаботыСФайлами.ТекстовыеФайлыРасширение;
	
	СтрокаНастройки.СпособОткрытия = НастройкиРаботыСФайлами.ТекстовыеФайлыСпособОткрытия;
	
	Если ЭтоВебКлиент Или Не ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		Элементы.НастройкаСканирования.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Элементы.НастройкиЭлектроннойПодписиИШифрования.Видимость =
		ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись
	
	Элементы.ГруппаИнтеграцияВызовОнлайнПоддержки.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОнлайнПоддержку");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
#Если ВебКлиент Тогда	
	НапоминатьОбУстановкеРасширенияРаботыСФайлами = ОбщегоНазначенияКлиент.ПредлагатьУстановкуРасширенияРаботыСФайлами();
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
#КонецЕсли	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Страница Главное

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(, АвторизованныйПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ПолучениеФайловИзИнтернетаКлиент.ОткрытьФормуПараметровПроксиСервера(Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуУстановкиРасширенияРаботыСФайлами()
	Оповещение = Новый ОписаниеОповещения("ОбновитьГруппуУстановкиРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуУстановкиРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(Подключено, Элементы.ГруппаРасширениеРаботыСФайламиУстановлено, 
		Элементы.ГруппаРасширениеРаботыСФайламиНеУстановлено);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТекущуюДатуКомпьютераПриИзменении(Элемент)
	
	Если ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДаты = '0001-01-01';
	Иначе
		ЗначениеРабочейДаты = ТекущаяДата();
	КонецЕсли;
	Элементы.ЗначениеРабочейДаты.Доступность = ИспользоватьТекущуюДатуКомпьютера = 0;
	Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница Органайзер

////////////////////////////////////////////////////////////////////////////////
// Страница Печать

&НаКлиенте
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы(Команда)
	
	УправлениеПечатьюКлиент.ЗадатьДействиеПриВыбореМакетаПечатнойФормы();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница РаботаСФайлами

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаРабочегоКаталогаПродолжение", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСканирования(Команда)
	
	РаботаСФайламиКлиент.ОткрытьФормуНастройкиСканирования();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЭлектроннойПодписиИШифрования(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьНастройкиИЗакрытьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьНастройкиИЗакрытьФорму()
	
	Настройки = Новый Структура;
	Настройки.Вставить("НапоминатьОбУстановкеРасширенияРаботыСФайлами", НапоминатьОбУстановкеРасширенияРаботыСФайлами);
	Настройки.Вставить("ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", ЗапрашиватьПодтверждениеПриЗавершенииПрограммы);
	
	ПерсональныеНастройкиРаботыСФайлами = УстановитьНастройкиНаСервере(Настройки);
	Настройки.Вставить("ПерсональныеНастройкиРаботыСФайлами ", ПерсональныеНастройкиРаботыСФайлами);
	
	ОбщегоНазначенияКлиент.СохранитьПерсональныеНастройки(Настройки);
	
	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Контекст) Экспорт
	СохранитьНастройкиИЗакрытьФорму();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиентеЗавершение(ДополнительныеПараметры) Экспорт
	
	ОбновитьГруппуУстановкиРасширенияРаботыСФайлами();
	
КонецПроцедуры

&НаСервере
Функция УстановитьНастройкиНаСервере(Настройки)
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	
	// Рабочая дата.
	Если ИспользоватьТекущуюДатуКомпьютера = 1 Тогда
		ЗначениеРабочейДатыДляСохранения = '0001-01-01';
	Иначе
		ЗначениеРабочейДатыДляСохранения = ЗначениеРабочейДаты;
	КонецЕсли;
	ОбщегоНазначения.УстановитьРабочуюДатуПользователя(ЗначениеРабочейДатыДляСохранения);
	
	ОбщегоНазначения.СохранитьПерсональныеНастройки(Настройки);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.РаботаСФайлами
	НастройкиРаботыСФайлами = Новый Структура;
	НастройкиРаботыСФайлами.Вставить("ДействиеПоДвойномуЩелчкуМыши", ДействиеПоДвойномуЩелчкуМыши);
	НастройкиРаботыСФайлами.Вставить("СпрашиватьРежимРедактированияПриОткрытииФайла", СпрашиватьРежимРедактированияПриОткрытииФайла);
	НастройкиРаботыСФайлами.Вставить("ПоказыватьПодсказкиПриРедактированииФайлов", ПоказыватьПодсказкиПриРедактированииФайлов);
	НастройкиРаботыСФайлами.Вставить("ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", ПоказыватьЗанятыеФайлыПриЗавершенииРаботы);
	НастройкиРаботыСФайлами.Вставить("ПоказыватьКолонкуРазмер", ПоказыватьКолонкуРазмер);
	НастройкиРаботыСФайлами.Вставить("ПоказыватьИнформациюЧтоФайлНеБылИзменен", ПоказыватьИнформациюЧтоФайлНеБылИзменен);
	НастройкиРаботыСФайлами.Вставить("СпособСравненияВерсийФайлов", СпособСравненияВерсийФайлов);
	
	Если НастройкиОткрытияФайлов.Количество() >= 1 Тогда
		НастройкиРаботыСФайлами.Вставить("ТекстовыеФайлыРасширение", НастройкиОткрытияФайлов[0].Расширение);
		НастройкиРаботыСФайлами.Вставить("ТекстовыеФайлыСпособОткрытия", НастройкиОткрытияФайлов[0].СпособОткрытия);
	КонецЕсли;
	
	РаботаСФайлами.СохранитьНастройкиРаботыСФайлами(НастройкиРаботыСФайлами);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	СохранитьСвойстваКоллекции("ОбщиеНастройкиПользователя", ЭтотОбъект,
		"ПредлагатьПерейтиНаСайтПриЗапуске");
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат РаботаСФайлами.НастройкиРаботыСФайлами();
	
КонецФункции

&НаСервере
Процедура СохранитьСвойстваКоллекции(КлючОбъекта, Коллекция, ИменаРеквизитов)
	СтруктураРеквизитов = Новый Структура(ИменаРеквизитов);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, Коллекция);
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРабочегоКаталогаПродолжение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Истина Тогда
		РаботаСФайламиКлиент.ОткрытьФормуНастройкиРабочегоКаталога();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
