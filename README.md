# CDEK Transport & Passenger Analytics

## Описание проекта

Провести комплексный анализ транспортных и пассажирских данных с использованием SQL, Power Query и Power BI с целью оценки эффективности рейсов, расчёта финансовых показателей и визуализации ключевых метрик для поддержки бизнес-решений.

В рамках проекта выполнены следующие задачи:

- агрегация и анализ данных по рейсам (план/факт)  
- расчёт транспортной работы и пробега  
- расчёт выручки перевозчика с учётом комиссий и штрафов  
- анализ пассажиропотока и расчёт среднего тарифа  
- применение оконных функций для аналитики по департаментам  
- трансформация и очистка данных в Power Query  
- обработка сложной структуры бюджетных данных  
- построение наглядных дашбордов в Power BI  

## 🛠 Реализация

Код представлен в следующих файлах:

- `sql_task_1.sql` — агрегация данных по рейсам (план/факт, пробег)  
- `sql_task_2.sql` — оконные функции (максимальный оклад по департаментам)  
- `task SQL and Power query.xlsx` — исходные данные  
- `task_Power Query.pbix` — обработка и трансформация данных в Power Query  
- `powerbi_dashboard.pbix` — визуализация данных и расчёт метрик в Power BI  

## 📂 Исходные данные

**Таблица:** `transport_data`

### Атрибуты таблицы `transport_data`

- `DATERELEASE` — дата выполнения рейса  
- `ROUTEID` — идентификатор маршрута  
- `RUNPLAN` — плановый пробег  
- `RUNFACT` — фактический пробег  

---

**Таблица:** `employees`

### Атрибуты таблицы `employees`

- `emplid` — табельный номер сотрудника  
- `dep` — департамент  
- `salary` — оклад  

---

## 📊 Задача 1. Агрегация данных по рейсам

Позволяет проанализировать выполнение рейсов по маршрутам и датам: сравнить плановые и фактические показатели (количество рейсов и пробег)

```sql
SELECT
   DATE(DATERELEASE) as DATERELEASE,
   ROUTEID, 
   COUNT(CASE WHEN RUNPLAN != 0 THEN 1 END) AS plan_trips_count,
   COUNT(CASE WHEN RUNFACT != 0 THEN 1 END) AS fact_trips_count,
   SUM(RUNPLAN) AS plan_distance,
   SUM(RUNFACT) AS fact_distance
FROM transport_data
GROUP BY 1, 2
ORDER BY 1, 2;
```
![Агрегация рейсов](https://drive.google.com/uc?export=view&id=1oEfJKaXMBJSen00bAfasG4wJHo-vGkP9)

## 🧠 Задача 2. Поиск сотрудников с максимальным окладом в департаменте

Требуется определить сотрудников, имеющих максимальный оклад внутри каждого департамента с использованием оконных функций

```sql
WITH ranked AS 
(
 SELECT
  emplid,
  dep,
  salary,
  RANK() OVER (PARTITION BY dep ORDER BY salary DESC) AS rnk
 FROM employees
)
SELECT emplid
FROM ranked
WHERE rnk = 1;
```
![Зарплаты по департаментам](https://drive.google.com/uc?export=view&id=1KgLv_4w_wexLOOfH58QWGo8n3sIuGqZw)


## 🔄 ETL-процесс на Power Query 

### 📂 Исходные данные
![Исходная таблица](https://drive.google.com/uc?export=view&id=1tC77IibgmsEr8hYHhYrDBbq3Y4VruJVf)

---

### 🛠 Задача

Выполнена обработка таблицы с бюджетными данными магазинов с целью приведения её к аналитически удобному формату.

В рамках задачи:
- выделены столбцы с бюджетами (по ключевому слову "Бюджет")  
- удалены нерелевантные столбцы (доли бюджета и проценты)  
- обработаны различные форматы названий столбцов  
- извлечены названия месяцев из заголовков  
- выполнено переименование столбцов в формат дат (начало месяца)  
- использовано транспонирование для преобразования структуры данных  
- сохранена структура таблицы с магазинами и бюджетами  

Преобразование реализовано таким образом, чтобы корректно работать при изменении структуры данных.

---

### 📊 Результат
![Обработанные данные](https://drive.google.com/uc?export=view&id=1HFVkJImuvlGSwdwQvZtMWEey3N0Lfl1X)


## 📊 Анализ данных в Power BI

### 📂 Исходные данные

В работе использованы данные по пассажиропотоку и транспортной работе:

- показатели пассажиров (поездки, выручка, оплаты)  
- выполнение рейсов (план/факт)  
- информация о нарушениях и штрафах  
- характеристики транспортных средств  

---

### 🛠 Задача

В рамках задания выполнен полный цикл аналитики:

- обработка и объединение данных  
- расчёт ключевых метрик:
  - транспортная работа (ТР)  
  - вознаграждение перевозчика  
  - комиссии по типам оплаты  
  - средний тариф  
  - доход на пассажира  

- учёт бизнес-логики:
  - комиссии по типам ТК  
  - ставки за км в зависимости от типа ТС  
  - штрафы за нарушения  

- построение дашборда с наглядной визуализацией показателей  

---

### 📊 Ключевые визуализации

### 🚍 Выполнение рейсов (план vs факт)
![План vs факт](https://drive.google.com/uc?export=view&id=1wwZq7-snwn8PeCj2JbO5a9wlJJEeAXTQ)

---

### 📈 Процент выполнения рейсов
![% выполнения](https://drive.google.com/uc?export=view&id=1EUlXC7PNGRKGevf4c9l-_8n0FyQqXR33)

---

### 💳 Процент оплат
![% оплат](https://drive.google.com/uc?export=view&id=1T2Hbf4sKFQqUYnn0ZkVNxNB-Zi3AW1XG)

---

### ⚠️ Доля срывов рейсов
![% срывов](https://drive.google.com/uc?export=view&id=15GeKC5r03tj3lczFJ27HyA3mmaFOmZvb)

---

### 💰 Вознаграждение по типам оплаты
![Типы ТК](https://drive.google.com/uc?export=view&id=1Ukz6dEAT9je-kCF5wpumY_AxqI0qzxLq)

---

### 📊 Динамика вознаграждения перевозчика
![Динамика](https://drive.google.com/uc?export=view&id=1IAMHxZ2VUxddDOOuTXMmfx1Xl6f37mdt)

---

### 👤 Доход на пассажира
![Доход на пассажира](https://drive.google.com/uc?export=view&id=1GlPf7s5O6TxMRgeQ_3VYJAuei52BeS37)

---

### 💵 Средний тариф
![Средний тариф](https://drive.google.com/uc?export=view&id=1DsKg9hxosGnQ8UKqvIg5X4JhYYTb11L-)

---

### 💸 Общее вознаграждение перевозчика
![Общее вознаграждение](https://drive.google.com/uc?export=view&id=10wM22d7-56xEHOe4qS388gB7yZRRqGyx)

---

### 🏁 Финальное вознаграждение перевозчика
![Финальное вознаграждение](https://drive.google.com/uc?export=view&id=1IocbGswTRFwhULQ1vHFTNJcCCzNdY-6w)

---

### 🏆 Топ-3 перевозчика по вознаграждению
![Топ перевозчики](https://drive.google.com/uc?export=view&id=1QgqStZ6lKR7DIl5b6aRRt4heM9Pw5DD0)

---

### ⚖️ Общая сумма штрафов
![Штрафы](https://drive.google.com/uc?export=view&id=1nwGUI8olQZC3sqp03IZ8JRerd8FuVBY2)
