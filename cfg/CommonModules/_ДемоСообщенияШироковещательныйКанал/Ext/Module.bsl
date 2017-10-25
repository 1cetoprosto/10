﻿#Область ПрограммныйИнтерфейс

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений.
//
// Параметры:
//	КаналСообщений - Строка - идентификатор канала сообщений, из которого получено сообщение.
//	ТелоСообщения - Произвольный - тело сообщения, полученное из канала, которое подлежит обработке.
//	Отправитель - ПланОбменаСсылка.ОбменСообщениями - Конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(КаналСообщений, ТелоСообщения, Отправитель) Экспорт
	
	Если КаналСообщений = "ОбщиеСообщения\ТекстовыеСообщения" Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТелоСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
