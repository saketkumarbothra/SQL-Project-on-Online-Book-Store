--Creating Books Table:

CREATE TABLE books(Book_ID SERIAL PRIMARY KEY,
                   Title VARCHAR(100),
                   Author VARCHAR(100),
                   Genre VARCHAR(50),
                   Published_Year INT,
                   Price NUMERIC(10,2),
                   Stock INT);

SELECT * FROM books;

--Importing Books Data from .csv File:

COPY books (Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'K:\Books.csv'
CSV HEADER;

SELECT * FROM books; 

--Creating Customers Table:

CREATE TABLE customers(Customer_ID SERIAL PRIMARY KEY,
					   NAME VARCHAR(100),
					   Email VARCHAR (100),
					   Phone VARCHAR(15),
					   City VARCHAR(50),
					   Country VARCHAR(150));

SELECT * FROM customers;

--Importing Customers Data from .csv File:

COPY customers (Customer_ID, Name, Email, Phone, City, Country)
FROM 'K:\Customers.csv'
CSV HEADER;

SELECT * FROM customers;

--Creating Orders Table:

CREATE TABLE orders(Order_ID SERIAL PRIMARY KEY,
					Customer_ID INT REFERENCES customers(customer_id),
					Book_ID INT REFERENCES books(book_id),
					Order_Date DATE,
					Quantity INT,
					Total_Amount NUMERIC(10,2));

SELECT * FROM orders;

--Importing Orders Data from .csv File:

COPY orders (Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'K:\Orders.csv'
CSV HEADER;

SELECT * FROM orders;

--1. Retrieve all books in the “Fiction” genre.

SELECT * FROM books WHERE genre='Fiction';

--2. Find books published after the year 1950.

SELECT * FROM books WHERE published_year>1950;

--3. List all the customers from Canada.

SELECT * FROM customers WHERE country='Canada';

--4. Show orders placed in November 2023.

SELECT * FROM orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5. Retrieve the total stock of books available.

SELECT SUM(stock) AS total_stock_of_books FROM books;

--6. Find the details of the most expensive book.

SELECT * FROM books ORDER BY price DESC LIMIT 1;

--7. Show all the customers who ordered more than 1 quantity of a book.

SELECT c.*, o.quantity AS quantity_ordered
FROM customers c JOIN orders o
ON c.customer_id=o.customer_id
WHERE o.quantity>1;

--8. Retrieve all orders where the total amount exceeds $20.

SELECT * FROM orders WHERE total_amount>20 ORDER BY total_amount;

--9. List all genres available in the books table.

SELECT DISTINCT (genre) FROM books;

--10. Find the book with the lowest stock.

SELECT * FROM books ORDER BY stock LIMIT 1;

--11. Calculate the total revenue generated from all orders.

SELECT SUM(total_amount) AS total_revenue_generated FROM orders;

--12. Retrieve the total number of books sold for each genre.

SELECT b.genre, SUM(o.quantity) AS total_books_sold 
FROM books b JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.genre;

--13. Find the average price of books in the “Fantasy” genre.

SELECT AVG(price) AS average_price_of_fantasy_genre FROM books WHERE genre='Fantasy';

--14. List customers who placed at least 2 orders.

SELECT c.customer_id, c.name, COUNT(c.customer_id) AS number_of_orders_placed
FROM customers c JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id
HAVING COUNT(c.customer_id)>=2;

--15. Find the most frequently ordered book.

SELECT b.*, COUNT(o.book_id) AS frequency_of_order
FROM books b JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.book_id
ORDER BY COUNT(o.book_id) DESC LIMIT 1;

--16. Show the top 3 most expensive books of “Fantasy” genre.

SELECT * FROM books WHERE genre='Fantasy' ORDER BY price DESC LIMIT 3;

--17. Retrieve the total quantity of books sold by each author.

SELECT b.book_id, b.author, SUM(o.quantity) AS total_quantity_sold
FROM books b JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.book_id, b.author;

--18. List the cities where customers who spent over $30 are located.

SELECT c.customer_id, c.city, SUM(o.total_amount) AS total_amount_spent
FROM customers c JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_amount)>30;

-- 19. Find the customer who spent the most on orders.

SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_amount_spent
FROM customers c JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY SUM(o.total_amount) DESC
LIMIT 1;

--20. Calculate the remaining stock of books.

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS total_quantity_sold, b.stock-COALESCE(SUM(o.quantity),0) AS remaining_stock
FROM books b LEFT JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;





















