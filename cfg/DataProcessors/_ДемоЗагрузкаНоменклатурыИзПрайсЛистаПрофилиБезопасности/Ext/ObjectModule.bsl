﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// Возвращает сведения о внешней обработке.
//
// Возвращаемое значение:
//   Структура - Подробнее см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке().
//
Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	ПараметрыРегистрации.Информация = НСтр("ru = 'Обработка для загрузки номенклатуры из прайс-листа фирмы ""1C"" с использованием профилей безопасности. На сервере должен быть установлен Microsoft Office или Data Connectivity Components.'");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "2.4.1.1";
	ПараметрыРегистрации.БезопасныйРежим = Истина;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Параметры загрузки номенклатуры из прайс-листа (профили безопасности)'");
	Команда.Идентификатор = "ФормаНастройки";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	Команда.ПоказыватьОповещение = Истина;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Загрузить номенклатуру из прайс-листа фирмы ""1C"" (профили безопасности)'");
	Команда.Идентификатор = "ЗагрузитьНоменклатуруИзПрайсЛиста";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.ПоказыватьОповещение = Ложь;
	
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаСозданиеCOMКласса("Excel.Application", "00024500-0000-0000-C000-000000000046");
	ПараметрыРегистрации.Разрешения.Добавить(Разрешение);
	
	Разрешение = РаботаВБезопасномРежиме.РазрешениеНаСозданиеCOMКласса("ADODB.Connection", "00000514-0000-0010-8000-00AA006D2EA4");
	ПараметрыРегистрации.Разрешения.Добавить(Разрешение);
	
	Возврат ПараметрыРегистрации;
КонецФункции

// Обработчик серверных команд.
//
// Параметры:
//   ИдентификаторКоманды - Строка    - Имя команды, определенное в функции СведенияОВнешнейОбработке().
//   ПараметрыВыполнения  - Структура - Контекст выполнения команды.
//       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка обработки.
//           Может использоваться для чтения параметров обработки.
//           Пример см. в комментарии к функции ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы().
//
Процедура ВыполнитьКоманду(ИдентификаторКоманды, ПараметрыВыполнения) Экспорт
	АдресФайла = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыВыполнения, "АдресФайла");
	Если Не ЗначениеЗаполнено(АдресФайла) Тогда
		Ссылка = ПараметрыВыполнения.ДополнительнаяОбработкаСсылка;
		ХранилищеНастроек = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеНастроек");
		Настройки = ХранилищеНастроек.Получить();
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			АдресФайла = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Настройки, "АдресФайла");
		Иначе
			АдресФайла = "http://www.1c.ru/ftp/pub/pricelst/price_1c.zip";
		КонецЕсли;
	КонецЕсли;
	
	ЗагрузитьНоменклатуруИзПрайсЛиста(АдресФайла);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗагрузитьНоменклатуруИзПрайсЛиста(АдресФайла)
	Если Не ПравоДоступа("Добавление", Метаданные.Справочники._ДемоНоменклатура) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для добавления номенклатуры.'");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(АдресФайла) Тогда
		ВызватьИсключение НСтр("ru = 'Перед выполнением команды необходимо указать адрес файла в настройках обработки.'");
	КонецЕсли;
	
	// Загрузка файла
	КаталогВременныхФайлов = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла("Demo"));
	СоздатьКаталог(КаталогВременныхФайлов);
	
	ДлинаАдреса = СтрДлина(АдресФайла);
	ПозицияПоследнегоСлеша = ДлинаАдреса;
	Символ = Сред(АдресФайла, ПозицияПоследнегоСлеша, 1);
	Пока Символ <> "\" И Символ <> "/" Цикл
		ПозицияПоследнегоСлеша = ПозицияПоследнегоСлеша - 1;
		Символ = Сред(АдресФайла, ПозицияПоследнегоСлеша, 1);
	КонецЦикла;
	
	ИмяФайла = Сред(АдресФайла, ПозицияПоследнегоСлеша + 1);
	ПолноеИмяФайла = КаталогВременныхФайлов + ИмяФайла;
	
	КопироватьФайл(АдресФайла, ПолноеИмяФайла);
	
	// Извлечение из ZIP архива
	Если ВРег(Прав(ИмяФайла, 3)) = "ZIP" Тогда
		ЧтениеZIP = Новый ЧтениеZipФайла(ПолноеИмяФайла);
		Элемент = ЧтениеZIP.Элементы[0];
		ЧтениеZIP.Извлечь(Элемент, КаталогВременныхФайлов);
		ПолноеИмяФайла = КаталогВременныхФайлов + Элемент.Имя;
	КонецЕсли;
	
	// Загрузка прайс-листа.
	ЗагружаемаяНоменклатура = Новый ТаблицаЗначений;
	ЗагружаемаяНоменклатура.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
	ЗагружаемаяНоменклатура.Колонки.Добавить("Цена", Новый ОписаниеТипов("Число"));
	
	Попытка
		ПрочитатьНоменклатуру_Excel(ПолноеИмяФайла, ЗагружаемаяНоменклатура);
	Исключение
		ИнформацияОбОшибке_Excel = ИнформацияОбОшибке();
		Попытка
			ПрочитатьНоменклатуру_ADODB(ПолноеИмяФайла, ЗагружаемаяНоменклатура);
		Исключение
			ИнформацияОбОшибке_ADODB = ИнформацияОбОшибке();
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось прочитать номенклатуру из файла Excel.
					|Сообщение об ошибке от COM-объекта Excel.Application:
					|	%1
					|Сообщение об ошибке от COM-объекта ADODB.Connection:
					|	%2
					|Обратитесь к системному администратору.'"),
				СтрЗаменить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке_Excel), Символы.ПС, Символы.ПС + Символы.Таб),
				СтрЗаменить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке_ADODB), Символы.ПС, Символы.ПС + Символы.Таб));
		КонецПопытки;
	КонецПопытки;
	ЗагрузитьПрайс(ЗагружаемаяНоменклатура);
	
	// Удаление временных файлов.
	УдалитьФайлы(КаталогВременныхФайлов);
КонецПроцедуры

Процедура ПрочитатьНоменклатуру_ADODB(ПолноеИмяФайла, ЗагружаемаяНоменклатура)
	// Выгрузка данных excel в таблицу значений.
	Попытка
		Connection = Новый COMОбъект("ADODB.Connection");
	Исключение
		ВызватьИсключение НСтр("ru = 'Не удалось подключить объект ADODB.
			|Вероятные причины:
			| - У пользователя недостаточно прав на создание COM-объектов;
			| - Включен контроль учетных записей Windows;
			| - Операционная система сервера не из семейства Windows.
			|
			|Техническая информация:'") + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=""" + СокрЛП(ПолноеИмяФайла) + """;Extended Properties=""Excel 12.0;HDR=YES;IMEX=1;""";
	Попытка
		Connection.Open(ConnectionString);
	Исключение
		ВызватьИсключение НСтр("ru = 'Не удалось прочитать прайс-лист объектом ADODB.
			|Вероятные причины:
			| - На сервере не установлен пакет ""Microsoft Access Database Engine 2010 Redistributable"";
			| - У пользователя недостаточно прав на создание COM-объектов;
			| - Включен контроль учетных записей Windows;
			|
			|Техническая информация:'") + Символы.ПС  + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	Connection.CursorLocation = 3;
	
	RecordSet = Connection.Execute("SELECT * FROM [A:CZ]");
	Пока Не RecordSet.EOF() Цикл
		Наименование = RecordSet.Fields(1).Value;
		Цена         = RecordSet.Fields(5).Value;
		Если ЗначениеЗаполнено(Наименование) И ЗначениеЗаполнено(Цена) Тогда
			НоваяСтрока = ЗагружаемаяНоменклатура.Добавить();
			НоваяСтрока.Наименование = Наименование;
			НоваяСтрока.Цена         = Цена;
		КонецЕсли;
		RecordSet.MoveNext();
	КонецЦикла;
	
	RecordSet.Close();
	RecordSet = Неопределено;
	Connection.Close();
	Connection = Неопределено;

КонецПроцедуры

Процедура ПрочитатьНоменклатуру_Excel(ПолноеИмяФайла, ЗагружаемаяНоменклатура)
	// Чтение листа Excel.
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		ИнформацияОбОшибке = Неопределено;
	Исключение
		ВызватьИсключение НСтр("ru = 'Не удалось подключить COM-объект Excel.
			|Вероятные причины:
			| - На сервере не установлен Microsoft Office;
			| - У пользователя недостаточно прав на создание COM-объектов;
			| - Включен контроль учетных записей Windows;
			| - Операционная система сервера не из семейства Windows.
			|
			|Техническая информация:'") + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	Excel.AutomationSecurity = 3; // msoAutomationSecurityForceDisable = 3
	Excel.Application.Workbooks.Open(ПолноеИмяФайла);
	Excel.DisplayAlerts = 0;
	ExcelSheet = Excel.Sheets(1);
	ВсегоСтрок = ExcelSheet.Cells.SpecialCells(11).Row;
	
	ExcelSheetRange = ExcelSheet.Range(ExcelSheet.Cells(1,2), ExcelSheet.Cells(ВсегоСтрок,4));
	Данные = ExcelSheetRange.Value.Выгрузить();
	
	ЗначенияКолонкиНаименование = Данные[0];
	ЗначенияКолонкиЦена = Данные[2];
	
	Для Индекс = 0 По ВсегоСтрок - 1 Цикл
		Наименование = ЗначенияКолонкиНаименование[Индекс];
		Цена         = ЗначенияКолонкиЦена[Индекс];
		Если НЕ ЗначениеЗаполнено(Цена) Или НЕ ЗначениеЗаполнено(Наименование) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ЗагружаемаяНоменклатура.Добавить();
		НоваяСтрока.Наименование = Наименование;
		НоваяСтрока.Цена         = Цена;
	КонецЦикла;
	
	Данные = Неопределено;
	ExcelSheetRange = Неопределено;
	ВсегоСтрок = Неопределено;
	ExcelSheet = Неопределено;
	
	Excel.Application.Workbooks(1).Close();
	Excel.Quit();
	
	Excel = Неопределено;
	
КонецПроцедуры

Процедура ЗагрузитьПрайс(ЗагружаемаяНоменклатура)
	
	ЗагружаемаяНоменклатураВГраница = ЗагружаемаяНоменклатура.Количество() - 1;
	
	// Чтение существующей номенклатуры.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Ссылка,
	|	Таблица.Наименование
	|ИЗ
	|	Справочник._ДемоНоменклатура КАК Таблица";
	
	СуществующаяНоменклатура = Запрос.Выполнить().Выгрузить();
	СуществующаяНоменклатура.Индексы.Добавить("Наименование");
	
	// Загрузка.
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел;
	СозданоЭлементов = 0;
	ОбновленоЭлементов = 0;
	Для Номер = 1 По ДеньНедели(ТекущаяДатаСеанса()) Цикл
		СлучайныйИндекс = ГенераторСлучайныхЧисел.СлучайноеЧисло(0, ЗагружаемаяНоменклатураВГраница);
		ЗагружаемаяСтрока = ЗагружаемаяНоменклатура[СлучайныйИндекс];
		СуществующаяСтрока = СуществующаяНоменклатура.Найти(ЗагружаемаяСтрока.Наименование, "Наименование");
		Если СуществующаяСтрока = Неопределено Тогда
			СправочникОбъект = Справочники._ДемоНоменклатура.СоздатьЭлемент();
			СправочникОбъект.УстановитьНовыйКод();
			СправочникОбъект.Наименование = ЗагружаемаяСтрока.Наименование;
			СозданоЭлементов = СозданоЭлементов + 1;
		Иначе
			СправочникОбъект = СуществующаяСтрока.Ссылка.ПолучитьОбъект();
			ОбновленоЭлементов = ОбновленоЭлементов + 1;
		КонецЕсли;
		СправочникОбъект.Цена = ЗагружаемаяСтрока.Цена;
		СправочникОбъект.Записать();
	КонецЦикла;
	
	// Вывод результата.
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = СтрЗаменить(НСтр("ru = 'Из прайс-листа загружено %1 новых позиций'"), "%1", СозданоЭлементов + ОбновленоЭлементов);
	Сообщение.Сообщить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли