﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ГруппаДоступа = Ссылка;
	Иначе
		СсылкаНового = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаНового) Тогда
			СсылкаНового = Справочники._ДемоГруппыДоступаНоменклатуры.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
		КонецЕсли;
		ГруппаДоступа = СсылкаНового;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
