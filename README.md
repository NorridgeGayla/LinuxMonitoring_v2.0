# LinuxMonitoring v2.0

Мониторинг и исследование состояния системы в реальном времени.

## Содержание

- [LinuxMonitoring v2.0](#linuxmonitoring-v20)
  - [Содержание](#содержание)
  - [Общая информация](#общая-информация)
  - [1. Генератор файлов](#1-генератор-файлов)
  - [2. Засорение файловой системы](#2-засорение-файловой-системы)
  - [3. Очистка файловой системы](#3-очистка-файловой-системы)
  - [4. Генератор логов](#4-генератор-логов)
  - [5. Мониторинг](#5-мониторинг)
  - [6. **GoAccess**](#6-goaccess)
  - [7. **Prometheus** и **Grafana**](#7-prometheus-и-grafana)
  - [8. Готовый дашборд](#8-готовый-дашборд)
  - [9. Свой *node\_exporter*](#9-свой-node_exporter)
  - [Дополнительная информация](#дополнительная-информация)
    - [**GoAccess**](#goaccess)
    - [**Prometheus**](#prometheus)
    - [**Grafana**](#grafana)

## Общая информация

- Написанные Bash-скрипты находятся в папке src
- Для каждого задания создана папка с названием вида: **0x**, где x - номер задания
- Файл с основным сценарием для каждого задания называется **main.sh**
- Во всех скриптах предусмотрены проверки на некорректный ввод (указаны не все параметры, параметры неправильного формата и т.д.)

## 1. Генератор файлов

Bash-скрипт запускается с 6 параметрами. Пример запуска скрипта: \
`main.sh /opt/test 4 az 5 az.az 3kb` 

**Параметр 1** - это абсолютный путь. \
**Параметр 2** - количество вложенных папок. \
**Параметр 3** - список букв английского алфавита, используемый в названии папок (не более 7 знаков). \
**Параметр 4** - количество файлов в каждой созданной папке. \
**Параметр 5** - список букв английского алфавита, используемый в имени файла и расширении (не более 7 знаков для имени, не более 3 знаков для расширения). \
**Параметр 6** - размер файлов (в килобайтах, но не более 100).  

При запуске скрипта в указанном в параметре 1 месте, будут созданы папки и файлы в них с соответствующими именами и размером.  
Скрипт остановить работу, если в файловой системе (в разделе /) останется 1 Гб свободного места.  
Будет записан лог-файл с данными по всем созданным папкам и файлам (полный путь, дата создания, размер для файлов).

## 2. Засорение файловой системы

Bash-скрипт запускается с 3 параметрами. Пример запуска скрипта: \
`main.sh az az.az 3Mb`

**Параметр 1** - список букв английского алфавита, используемый в названии папок (не более 7 знаков). \
**Параметр 2** - список букв английского алфавита, используемый в имени файла и расширении (не более 7 знаков для имени, не более 3 знаков для расширения). \
**Параметр 3** - размер файла (в Мегабайтах, но не более 100).  

При запуске скрипта, в различных (любых, кроме путей содержащих **bin** или **sbin**) местах файловой системы, будут созданы папки с файлами.
Количество вложенных папок - до 100. Количество файлов в каждой папке - случайное число (для каждой папки своё).  
Скрипт остановить работу, когда в файловой системе (в разделе /) останется 1 Гб свободного места.  

Будет записан лог-файл с данными по всем созданным папкам и файлам (полный путь, дата создания, размер для файлов).  
В конце работы скрипта, выводится на экран время начало работы скрипта, время окончания и общее время его работы.

## 3. Очистка файловой системы

Bash-скрипт запускается с 1 параметром.
Скрипт очищает систему от созданных во [второй части](#2-засорение-файловой-системы) папок и файлов 3 способами:

1. По лог файлу
2. По дате и времени создания
3. По маске имени (т.е. символы, нижнее подчёркивание и дата).  

Способ очистки задается при запуске скрипта, как параметр со значением 1, 2 или 3.

*При удалении по дате и времени создания, пользователем вводятся времена начала и конца с точностью до минуты. Удаляются все файлы, созданные в указанном временном промежутке. Ввод реализован во время выполнения программы.*

## 4. Генератор логов

Bash-скрипт генерирует 5 файлов логов **nginx** в *combined* формате.
Каждый лог содержит информацию за 1 день.

За день будет сгенерировано случайное число записей от 100 до 1000.
Для каждой записи должны случайным образом генерируются:

1. IP (любые корректные, т.е. не должно быть ip вида 999.111.777.777)
2. Коды ответа (200, 201, 400, 401, 403, 404, 500, 501, 502, 503)
3. Методы (GET, POST, PUT, PATCH, DELETE)
4. Даты (в рамках заданного дня лога, должны идти по увеличению)
5. URL запроса агента
6. Агенты (Mozilla, Google Chrome, Opera, Safari, Internet Explorer, Microsoft Edge, Crawler and bot, Library and net tool)

## 5. Мониторинг

Bash-скрипт для разбора логов **nginx** из [Части 4](#4-генератор-логов).

Скрипт запускается с 1 параметром, который принимает значение 1, 2, 3 или 4.
В зависимости от значения параметра выводится:

1. Все записи, отсортированные по коду ответа
2. Все уникальные IP, встречающиеся в записях
3. Все запросы с ошибками (код ответа - 4хх или 5хх)
4. Все уникальные IP, которые встречаются среди ошибочных запросов

## 6. **GoAccess**

Bash-скрипт для запуска утилиты GoAccess для получения информации, что и в [Части 5](#5-мониторинг).

Будет создан файл `report.html`.


## 7. **Prometheus** и **Grafana**

Результат работы предоставлен в виде отчета `src/07/report.md`.

## 8. Готовый дашборд

Результат работы предоставлен в виде отчета `src/08/report.md`.


## 9. Свой *node_exporter*

Bash-скрипт собирает информацию по базовым метрикам системы (ЦПУ, оперативная память, жесткий диск (объем)).
Скрипт формирует html-страничку по формату **Prometheus**, которую будет отдавать **nginx**. \
Сама страничка обновляется внутри bash-скрипта каждые 3 секунды.

Результат работы предоставлен в виде отчета `src/09/report.md`.

## Дополнительная информация 

### **GoAccess**

GoAccess - это анализатор логов, который может работать с ними в реальном времени, визуализировать информацию и отдавать ее через терминал или через браузер в виде веб-странички. 

### **Prometheus**

Базы данных временных рядов, как следует из их названия, представляют собой системы баз данных,
специально разработанные для обработки данных, связанных со временем.

Большинство систем использует реляционные базы данных, основанные на таблицах. 
Базы данных временных рядов работают по-другому.
Данные по-прежнему хранятся в "коллекциях", но эти коллекции имеют общий знаменатель: они агрегируются с течением времени.
По сути, это означает, что для каждой точки, которую можно сохранить, есть связанная с ней метка времени.

Prometheus — это база данных временных рядов, к которой можно присоединить целую экосистему инструментов, чтобы расширить ее функционал. \
Prometheus создан, чтобы мониторить самые разные системы: серверы, базы данных, отдельные виртуальные машины, да почти что угодно.

### **Grafana**

Grafana — платформа для визуализации, мониторинга и анализа данных.
Grafana позволяет пользователям создавать *дашборды* с *панелями*, каждая из которых отображает определенные показатели в течение установленного периода времени.
Каждый *дашборд* универсален, поэтому его можно настроить для конкретного проекта.

*Панель* — базовый элемент визуализации выбранных показателей.

*Дашборд* — набор отдельных панелей, размещенных в сетке с набором переменных (например, имя сервера, приложения и т.д.).
