﻿
#Область СобытияФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Путь) Тогда
		УстановитьНастройки();
	КонецЕсли;
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти // СобытияФормы


#Область СобытияЭлементовФормы

&НаКлиенте
Асинх Процедура ПутьНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	ПолныйПуть = Ждать ПолучитьПутьКФайлу("Выберите растровое изображение");
	
	Если НЕ ПолныйПуть = "" Тогда
		Путь = ПолныйПуть;
		
		УстановитьНастройки();
	КонецЕсли;
	
КонецПроцедуры // ПутьНачалоВыбора()

&НаКлиенте
Процедура ПутьПриИзменении(Элемент)
	
	УстановитьНастройки();
	
КонецПроцедуры // ПутьПриИзменении()

&НаКлиенте
Процедура ШиринаПриИзменении(Элемент)
	
	ПересчитатьРазмеры(Истина);
	
КонецПроцедуры // ШиринаПриИзменении()

&НаКлиенте
Процедура ВысотаПриИзменении(Элемент)
	
	ПересчитатьРазмеры(Ложь);
	
КонецПроцедуры // ВысотаПриИзменении()

#КонецОбласти // СобытияЭлементовФормы


#Область Команды

&НаКлиенте
Процедура Преобразовать(Команда)
	
	Если НЕ ЗначениеЗаполнено(Путь) Тогда
		Сообщить("Не указан путь");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Алфавит) Тогда
		Сообщить("Не выбран алфавит");
		Возврат;
	КонецЕсли;
	
	ПересчитатьРазмеры(Истина);
	
	СераяМатрица = ОбработатьНаСервере(АдресКартинки);
	
	Буквы = ПолучитьАскиСимволы();
	
	Текст = ПолучитьТекстИзМатрицы(СераяМатрица, Буквы);
	
КонецПроцедуры // Преобразовать()

#КонецОбласти // Команды


#Область Движок

&НаКлиенте
Функция ПолучитьАскиСимволы()
	
	ДлинаА = СтрДлина(Алфавит);
	
	Буквы = Новый Массив;
	
	Для й = 1 По ДлинаА Цикл
		Буквы.Добавить(Сред(Алфавит, й, 1));
	КонецЦикла;
	
	Возврат Буквы;
	
КонецФункции // ПолучитьАскиСимволы()

&НаСервере
Функция ОбработатьНаСервере(Адрес)
	
	Об = РеквизитФормыВЗначение("Объект");
	
	СераяМатрица = Об.ПолучитьСеруюМатрицу(Адрес, ШиринаИзо, ВысотаИзо);
	
	Возврат СераяМатрица;
	
КонецФункции // ОбработатьНаСервере()

&НаКлиенте
Функция ПолучитьТекстИзМатрицы(Матрица, АСКИ)
	
	Рез = Новый Массив;
	
	Инт = (АСКИ.Количество() - 1) / 255;
	
	Для каждого Столб Из Матрица Цикл
		Для каждого Яркость Из Столб Цикл
			Рез.Добавить(АСКИ[Окр(Инт * Яркость)]);
		КонецЦикла;
		
		Рез.Добавить(Символы.ПС);
	КонецЦикла;
	
	Текст = СтрСоединить(Рез);
	
	Возврат Текст;
	
КонецФункции // ПолучитьТекстИзМатрицы()

&НаКлиенте
Асинх Функция ПолучитьПутьКФайлу(Заголовок)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПроверятьСуществованиеФайла = Истина;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = Заголовок;
	ДиалогОткрытияФайла.Фильтр = "*.bmp; *.png; *.jpg|*.bmp; *.png; *.jpg";
	
	ВыбранныеФайлы = Ждать ДиалогОткрытияФайла.ВыбратьАсинх();
	
	Если ВыбранныеФайлы.Количество() <> 0 Тогда             
		Возврат ВыбранныеФайлы[0];
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции // ПолучитьПутьКФайлу()

&НаКлиенте
Асинх Процедура УстановитьНастройки()
	
	Бинарник = Ждать СоздатьДвоичныеДанныеИзФайлаАсинх(Путь);
	
	АдресКартинки = ПоместитьВоВременноеХранилище(Бинарник, УникальныйИдентификатор);
	
	Текст = "";
	Картинка = Новый Картинка(Путь);
	ШиринаОриг = Картинка.Ширина();
	ВысотаОриг = Картинка.Высота();
	ШиринаИзо = ШиринаОриг;
	ВысотаИзо = ВысотаОриг;
	
КонецПроцедуры // УстановитьНастройки()

&НаКлиенте
Процедура ПересчитатьРазмеры(ЭтоШирина)
	
	Если ЭтоШирина Тогда
		ВысотаИзо = Цел(ВысотаОриг * ШиринаИзо / ШиринаОриг );
	Иначе
		ШиринаИзо = Цел(ШиринаОриг * ВысотаИзо / ВысотаОриг);
	КонецЕсли;
	
КонецПроцедуры // ПересчитатьРазмеры()

#КонецОбласти // Движок
