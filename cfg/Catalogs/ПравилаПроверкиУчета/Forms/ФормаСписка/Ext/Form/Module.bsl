﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МодульПользователи = ОбщегоНазначения.ОбщийМодуль("Пользователи");
	Если Не ( (Не ОбщегоНазначения.РазделениеВключено() И МодульПользователи.ЭтоПолноправныйПользователь())
		Или (ОбщегоНазначения.РазделениеВключено() И МодульПользователи.ЭтоПолноправныйПользователь(, Истина)) ) Тогда
		
		Элементы.ПредставлениеОбщегоРасписания.Видимость    = Ложь;
		Элементы.РегламентноеЗаданиеПредставление.Видимость = Ложь;
		
	Иначе
		
		ОбщееРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
		Если ОбщееРегламентноеЗадание <> Неопределено Тогда
			Если Не ОбщегоНазначения.РазделениеВключено() Тогда
				ОбщееРасписаниеПредставление = Строка(ОбщееРегламентноеЗадание.Расписание)
			Иначе
				Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
					ОбщееРасписаниеПредставление = Строка(ОбщееРегламентноеЗадание.Шаблон.Расписание.Получить());
					Элементы.РегламентноеЗаданиеПредставление.Видимость = Истина;
				Иначе
					Элементы.РегламентноеЗаданиеПредставление.Видимость = Ложь;
					Элементы.ПредставлениеОбщегоРасписания.Видимость    = Ложь;
					ОбщееРасписаниеПредставление                        = "";
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если (ОбщегоНазначения.РазделениеВключено() И Пользователи.ЭтоПолноправныйПользователь(, Истина)) Или Не ОбщегоНазначения.РазделениеВключено() Тогда
				ОбщееРасписаниеПредставление = НСтр("ru = 'Не найдено общее регламентное задание'");
			Иначе
				ОбщееРасписаниеПредставление                     = "";
				Элементы.ПредставлениеОбщегоРасписания.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ПредставлениеОбщегоРасписания", ОбщееРасписаниеПредставление);
		
		Элементы.ПредставлениеОбщегоРасписания.Заголовок = СформироватьСтрокуСРасписанием();
		
	КонецЕсли;
	
	Элементы.ПредставлениеОбщегоРасписания.Доступность = РасписаниеДоступно();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ДополнительныеСвойстваКомпоновщика = Настройки.ДополнительныеСвойства;
	Если Не ДополнительныеСвойстваКомпоновщика.Свойство("ПредставлениеОбщегоРасписания") Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеОбщегоРасписания = ДополнительныеСвойстваКомпоновщика.ПредставлениеОбщегоРасписания;
	
	КлючиСтрок = Строки.ПолучитьКлючи();
	Для Каждого КлючСтроки Из КлючиСтрок Цикл
		ДанныеСтроки = Строки[КлючСтроки].Данные;
		Если ДанныеСтроки.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
		Если ДанныеСтроки.СпособВыполнения = Перечисления.СпособВыполненияПроверки.Вручную Тогда
			ДанныеСтроки.РегламентноеЗаданиеПредставление = НСтр("ru = 'Вручную'");
		ИначеЕсли ДанныеСтроки.СпособВыполнения = Перечисления.СпособВыполненияПроверки.ПоОбщемуРасписанию Тогда
			ДанныеСтроки.РегламентноеЗаданиеПредставление = НСтр("ru = 'По общему расписанию'")
		ИначеЕсли ДанныеСтроки.СпособВыполнения = Перечисления.СпособВыполненияПроверки.ПоОтдельномуРасписанию Тогда
			ИдентификаторЗадания = ДанныеСтроки.ИдентификаторРегламентногоЗадания;
			Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
				ДанныеСтроки.РегламентноеЗаданиеПредставление = НСтр("ru = 'Пустой идентификатор индивидуального задания'");
			Иначе
				НайденноеРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Новый УникальныйИдентификатор(ИдентификаторЗадания));
				Если НайденноеРегламентноеЗадание <> Неопределено Тогда
					РасписаниеСтрокой = Строка(НайденноеРегламентноеЗадание.Расписание);
				Иначе
					
					ОбъектПравила = КлючСтроки.ПолучитьОбъект();
					
					Параметры = Новый Структура;
					Параметры.Вставить("Использование", Истина);
					Параметры.Вставить("Метаданные",    Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
					Параметры.Вставить("Расписание",    ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(ОбъектПравила.РасписаниеВыполненияПроверки.Получить()));
					
					ВосстановленноеЗадание = РегламентныеЗаданияСервер.ДобавитьЗадание(Параметры);
					
					ПараметрыЗадания = Новый Структура;
					МассивПараметров = Новый Массив;
					МассивПараметров.Добавить(Строка(ВосстановленноеЗадание.УникальныйИдентификатор));
					ПараметрыЗадания.Вставить("Параметры", МассивПараметров);
					
					РегламентныеЗаданияСервер.ИзменитьЗадание(ВосстановленноеЗадание.УникальныйИдентификатор, ПараметрыЗадания);
					
					ОбъектПравила.ИдентификаторРегламентногоЗадания = Строка(ВосстановленноеЗадание.УникальныйИдентификатор);
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОбъектПравила);
					
					РасписаниеСтрокой = Строка(ВосстановленноеЗадание.Расписание);
					
				КонецЕсли;
				ДанныеСтроки.РегламентноеЗаданиеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'По расписанию: ""%1""'"), РасписаниеСтрокой);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не выделено ни одной проверки в списке. Выполнение невозможно.'");
	КонецЕсли;
	
	МассивПроверок = ПодготовкаМассиваПроверок(ВыделенныеСтроки);
	
	Если МассивПроверок.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'В списке выделены одни группы. Выполнение невозможно.'");
	КонецЕсли;
	
	ДлительнаяОперация = ВыполнитьПроверкиНаСервере(МассивПроверок);
	Если ДлительнаяОперация <> Неопределено Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
		ПараметрыОжидания.ТекстСообщения       = НСтр("ru = 'Идет выполнение выбранных проверок. Это может занять некоторое время'");
		ПараметрыОжидания.Интервал             = 2;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, , ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодготовкаМассиваПроверок(МассивПроверок)
	
	ОтфильтрованныйМассив = Новый Массив;
	Для Каждого Проверка Из МассивПроверок Цикл
		Если Не Проверка.ЭтоГруппа Тогда
			ОтфильтрованныйМассив.Добавить(Проверка);
		КонецЕсли;
	КонецЦикла;
	Возврат ОтфильтрованныйМассив;
	
КонецФункции

&НаСервере
Функция ВыполнитьПроверкиНаСервере(МассивПроверок)
	
	Если МонопольныйРежим() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Выполнение списка проверок'");
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	
	МассивПараметров = Новый Массив;
	Для Каждого Проверка Из МассивПроверок Цикл
		
		РеквизитыПроверки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Проверка,
			"Идентификатор, Наименование, ИдентификаторРегламентногоЗадания,
			|ДатаНачалаПроверки, ЛимитПроблем, СпособВыполнения");
		
		ПараметрыПроверки = Новый Структура;
		ПараметрыПроверки.Вставить("Идентификатор",                     РеквизитыПроверки.Идентификатор);
		ПараметрыПроверки.Вставить("Наименование",                      РеквизитыПроверки.Наименование);
		ПараметрыПроверки.Вставить("ИдентификаторРегламентногоЗадания", РеквизитыПроверки.ИдентификаторРегламентногоЗадания);
		ПараметрыПроверки.Вставить("ДатаНачалаПроверки",                РеквизитыПроверки.ДатаНачалаПроверки);
		ПараметрыПроверки.Вставить("ЛимитПроблем",                      РеквизитыПроверки.ЛимитПроблем);
		ПараметрыПроверки.Вставить("СпособВыполнения",                  РеквизитыПроверки.СпособВыполнения);
		ПараметрыПроверки.Вставить("ПроверкаБылаОстановлена",           Ложь);
		ПараметрыПроверки.Вставить("РучнойЗапуск",                      Истина);
		
		МассивПараметров.Добавить(ПараметрыПроверки);
		
	КонецЦикла;
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("КонтрольВеденияУчетаСлужебный.ВыполнитьПроверкиВФоновомЗадании", Новый Структура("МассивПараметров", МассивПараметров), ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьСтрокуСРасписанием()
	
	ОбщееРегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
	Если ОбщееРегламентноеЗадание <> Неопределено Тогда
		Если Не ОбщегоНазначения.РазделениеВключено() Тогда
			ОбщееРасписание              = ОбщееРегламентноеЗадание.Расписание;
			ОбщееРасписаниеПредставление = Строка(ОбщееРегламентноеЗадание.Расписание);
		Иначе
			Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
				ОбщееРасписание              = ОбщееРегламентноеЗадание.Шаблон.Расписание.Получить();
				ОбщееРасписаниеПредставление = Строка(ОбщееРасписание);
			Иначе
				ОбщееРасписание = Неопределено;
				ОбщееРасписаниеПредставление = НСтр("ru = 'Просмотр расписания недоступен'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОбщееРасписание              = Неопределено;
		ОбщееРасписаниеПредставление = НСтр("ru = 'Не найдено общее регламентное задание'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		ТекстоваяСсылка = ПоместитьВоВременноеХранилище(ОбщееРасписание, УникальныйИдентификатор);
	
		Возврат Новый ФорматированнаяСтрока(НСтр("ru='Общее расписание выполнения проверок:'") + " ",
			Новый ФорматированнаяСтрока(ОбщееРасписаниеПредставление, , , , ТекстоваяСсылка));
			
	Иначе
			
		Возврат Новый ФорматированнаяСтрока(НСтр("ru='Общее расписание выполнения проверок:'") + " ",
			Новый ФорматированнаяСтрока(ОбщееРасписаниеПредставление, , ЦветаСтиля.ГиперссылкаЦвет));
			
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПредставлениеОбщегоРасписанияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог     = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьИзВременногоХранилища(НавигационнаяСсылкаФорматированнойСтроки));
	Оповещение = Новый ОписаниеОповещения("ПредставлениеОбщегоРасписанияНажатиеЗавершение", ЭтотОбъект);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

&НаСервере
Процедура ПредставлениеОбщегоРасписанияНажатиеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторОбщегоЗадания = РегламентныеЗаданияСервер.УникальныйИдентификатор(Метаданные.РегламентныеЗадания.ПроверкаВеденияУчета);
	РегламентныеЗаданияСервер.ИзменитьЗадание(ИдентификаторОбщегоЗадания, Новый Структура("Расписание", Расписание));
	
	Элементы.ПредставлениеОбщегоРасписания.Заголовок = СформироватьСтрокуСРасписанием();
	
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ПредставлениеОбщегоРасписания", Строка(Расписание));
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Функция РасписаниеДоступно()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПравилаПроверкиУчета.Ссылка КАК ПравилоПроверки
	|ИЗ
	|	Справочник.ПравилаПроверкиУчета КАК ПравилаПроверкиУчета");
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		Если Не ОбновлениеИнформационнойБазы.ОбъектОбработан(Результат.ПравилоПроверки).Обработан Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
