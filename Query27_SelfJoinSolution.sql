CREATE TABLE [int_orders](
 [order_number] [int] NOT NULL,
 [order_date] [date] NOT NULL,
 [cust_id] [int] NOT NULL,
 [salesperson_id] [int] NOT NULL,
 [amount] [float] NOT NULL
) ON [PRIMARY];

INSERT INTO [int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (30, CAST('1995-07-14' AS Date), 9, 1, 460);

INSERT into [int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (10, CAST('1996-08-02' AS Date), 4, 2, 540);

INSERT INTO [int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (40, CAST('1998-01-29' AS Date), 7, 2, 2400);

INSERT INTO [int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (50, CAST('1998-02-03' AS Date), 6, 7, 600);

INSERT into [int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (60, CAST('1998-03-02' AS Date), 6, 7, 720);

INSERT into [int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (70, CAST('1998-05-06' AS Date), 9, 7, 150);

INSERT into [int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (20, CAST('1999-01-30' AS Date), 4, 8, 1800);

SELECT * FROM [int_orders];

/*Find the largest order by value for each salesperson and display order details*/

SELECT a.order_number, a.order_Date, a.cust_id,a.salesperson_id,a.amount
FROM [int_orders] a
LEFT JOIN [int_orders] b ON a.salesperson_id = b.salesperson_id 
GROUP BY  a.order_number, a.order_Date, a.cust_id,a.salesperson_id,a.amount
HAVING a.amount>= max(b.amount)
