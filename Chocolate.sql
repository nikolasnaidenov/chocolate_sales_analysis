
 
CREATE VIEW clean_chocolate AS
SELECT 
    TRIM(Country) AS country,
    TRIM(Product) AS product,
    STR_TO_DATE(Date, '%d/%m/%Y') AS date,
    CAST(REPLACE(REPLACE(Amount, '$', ''), ',', '') AS DECIMAL(10,2)) AS amount,
    `Boxes Shipped` AS boxes
FROM chocolate;

Select 
country,
Sum(Amount) as amount,
Sum(boxes) as boxes
From clean_chocolate
Group by country
Order by amount desc,boxes;

-- Australia produced most revenue(8,36% than 2nd UK) and shipped most boxes(7,67%  more than UK),while biggest amount per box is held by USA with 40,50$ per box. 
-- Even though Autralia and UK produce most revenue they are at the bottom of avg_per_box with 36,60$ and 36,37$ only in front of Canada with lowest avg of 32,35$ per box.
-- Canada is our weakest market as it holds 2nd lowest revenue and lowest avg price. If we exclude Canada we can notice that lowest revenue providers have highest avg prices
-- per box leading to conclusion that these markets order higher priced products so a strategy for increasing total orders in this markets could rise our revenue more. 

Select country,
Sum(amount)/Sum(boxes) as avg_per_box
From clean_chocolate
Group by country
Order by avg_per_box desc;

Select product, 
Sum(Amount) as amount,                -- Smooth Sliky Salty (SSS) generated us most revenue (1 120 201$) which is 3% more than 2nd (50% dark bites)  and 
									  -- 6,26% more than 3rd (white choc). Most valueable per box is the Almond Choco 
Sum(boxes) as boxes,                  -- with 43,31$ per box and followed by White choco - 41,90$ per box and by SSS with 41,53$ per box.
sum(amount)/sum(boxes) as avg_per_box
From clean_chocolate
Group by product
order by amount desc , boxes,  avg_per_box; 

                                             -- Top 2 lowest on revenue are also with lowest avg prices (Caramel Stuffed Bars and 70% Dark Bites)

Select product,
Avg(amount) as avg_amount,                                     
Avg(boxes) as avg_boxes
From clean_chocolate
Group by product
Order by avg_amount desc, avg_boxes;

Select product,
Sum(amount)/Sum(boxes) as avg_price
From clean_chocolate
Group by product
order by avg_price desc;

Select 
country,
product,
Sum(amount) as amount,
Sum(boxes) as boxes,
Sum(amount)/Sum(boxes) as price,
 AVG(SUM(amount)/SUM(boxes)) OVER () AS avg_price_all_products,
 Sum(SUM(amount)) OVER () AS total_amount_all,
 Sum(Sum(boxes)) over () as total_boxes
From clean_chocolate
where country = 'Australia'
group by country,product
order by amount desc,boxes,price;

-- Australia generates most revenue through 50% dark bites as it produced 34,35% more than 2nd which is Eclairs. Interesting is that boxes for 50% DB are 140% more, 
-- meaning that our 2 top revenue generators are generating in 2 different ways. While 1st has way more orders than every other product Eclairs keep avf price of 51,69$ per box covering for their low volume.
-- The rest of top 10 are pretty balanced in terms of volume/price ratio with only exception being Baker's Choco Chips, having price of 48,30$ per box, but with less orders than the rest.
-- The market is very sensitive to prices as low priced product generate more volume.  Important note is that 33-43$ is most safe range as avg boxes ordered are
--  around 4000 + , allowing product to generate decent revenue.

Select 
country,
product,
Sum(amount) as amount,
Sum(boxes) as boxes,
Sum(amount)/Sum(boxes) as price,
 AVG(SUM(amount)/SUM(boxes)) OVER () AS avg_price_all_products,
 Sum(SUM(amount)) OVER () AS total_amount_all,
 Sum(Sum(boxes)) over () as total_boxes
From clean_chocolate
where country = 'UK'
group by country,product
order by amount desc,boxes,price;

-- UK generates most revenue through Peanut butter cubes,99% Dark & Pure and Smooth Sliky Salty, all generating close to equal revenue (22,23%).While they arent top 3 most ordered, but Milk bars,
-- Caramel Stuffed Bars and Baker's Choco Chips are the one with most boxes ordered. Compared to Australia, UK maintain similar prices with only <1% lower on average, but there is a difference. UK's avg is strongly
-- influenced by the middle ground of pretty high priced and low priced products as there are many way over/under the avg total price.
-- Unlike Australia, the UK does not have a clear optimal price range. Instead, orders volume is more balanced in the mix of products across different price levels, 
-- indicating a more diversified demand structure.

Select 
country,
product,
Sum(amount) as amount,
Sum(boxes) as boxes,
Sum(amount)/Sum(boxes) as price,
Avg(Sum(amount)/Sum(boxes)) over() as avg_price,
Sum(SUM(amount)) OVER () AS total_amount_all,
Sum(Sum(boxes)) over () as total_boxes
From clean_chocolate
Where country = 'USA'
group by country,product
order by amount desc,boxes,price;

-- The USA generates the highest revenue through  Raspberry choco ( ~22,40% over the 2nd and 3rd). Top 3 products produce 21,07% of the revenue. Avg price in USA is significantly higher with ~17% more than UK and Aus. Avg price is highly manipulated 
-- by products with very high price - best example being Choco Coated Almonds with 131,23$ per box. Only 5 product are in the range of the avg price ( from 36-56 $ per box). Higher prices have serious impact on order volume,
-- as USA receive around 10 000 less box orders or ~11% less, suggesting that price lowering could be of benefit for the revenue.

Select
country,
product,
Sum(amount) as amount,
Sum(boxes) as boxes,
Sum(amount)/Sum(boxes) as price,
Avg(sum(amount)/sum(boxes)) over() as avg_price,
Sum(sum(amount)) over () as total_amount,
Sum(Sum(boxes)) over () as total_boxes
From clean_chocolate
Where country = 'India'
Group by country,product
order by amount desc,boxes,price;

--  India top generators are Eclairs, Peanut Butter Cubes, Smooth Sliky Salty, Spicy Special Slims. Top 3 makes ~22% of total. There are 3 product that the Indian market slightly prefers-Eclairs,Spicy Special Slims,After Nines, all with ~6000 boxes ordered.
-- This shows that revenue performers and most consumed products are mostly not the same. Also the avg price is close to UK and Australia.  Insight I made is that India's market doesnt  react much on price. Demand is the same both for over the 
-- avg price product and under avg price making lowest on price products in the bottom of revenue providers. In other words price have an effect only in extreme conditions as the market have established solid demand for determined products.
-- Saying extreme conditions can have an effect leads to other insight I made. Smooth Sliky Salty price is ~200% higher than all other markets. This price took it to top 3 revenue, while being least ordered by boxes. High price could be a sign 
-- that the market completely rely on importing or production costs are way higher compared to the rest. Yet calculated Smooth Sliky Salty is still more prefered than many of the product so a way of justifying or lowering price could boost revenue.

Select 
country,
product,
Sum(amount) as amount,
Sum(boxes) as boxes,
Sum(amount)/Sum(boxes) as price,
AVg(Sum(amount)/Sum(boxes)) over () as avg_price,
Sum(Sum(amount)) over () as total_amount,
Sum(Sum(boxes)) over () as total_boxes
From clean_chocolate
Where country = 'Canada'
Group by country,product
order by amount desc,boxes,price;

-- Canada has lowest prices of all ( 7,75% less than avg for UK,Aus and India and 21% less than USA ) . Smooth Sliky Salty is best performer followed by Peanut Butter Cubes. Most ordered products are also not always from 
-- top revenue ones. Top 3 20% . For instance Canada ranks 2nd in demand as 2nd  most boxes ordered, but lowest on revenue, reason for that being the low prices. Products like Eclairs or Raspberry Choco are sold on prices 100% + lower than other markets.
-- Pushing prices with 5% could push Canada from last to 2nd most generative market, Canada is also sensitive on prices market as prices higher than avg experience low volume orders ( between 1500-2500 boxes), which for 2nd most demanded market is low.
-- Optional strategy could be to higher up the prices of product that are underpricing other markets and lower those who hold back order volume. This way we can safely gain from cheap-selling one without losing big amount of volume and add more volume on already high-priced products with lowering price. 
-- or with less words - pushing prices of those product little closer to the avg.

Select 
country,
product,
Sum(amount) as amount,
Sum(boxes) as boxes,
Sum(amount)/Sum(boxes) as price,
Avg(sum(amount)/sum(boxes)) over() as avg_price,
Sum(sum(amount)) over () as total_amount,
Sum(sum(boxes)) over () as total_boxes
From clean_chocolate
Where country = 'New Zealand'
Group by country,product
Order by amount desc, boxes, price; 


-- NZ is our worst performer on revenue and orders. Mint Chip Choco is clear favorite for the market producing 28,76% more revenue than top 2 and 45% more than top 3. 
-- top 3 22% but top 1 10%.  NZ contains the most balanced price market as most product keep price close to the average with only 3 exceptions making the market sensitivity almost unpredictable. 
-- Avg price is close to Aus,UK and India. Expirimenting with prices would be very unwise. Optimal strategy would be either to try increase some products popularity or Mint Chip Choco will,
-- continiue to make 10% of the revenue.


Select product,
Sum(amount) as revenue,
Sum(boxes) as boxes,
Sum(amount)/Sum(boxes) as price_avg,
Sum(sum(amount)) over() as total_revenue,
Sum(sum(boxes)) over() as total_boxes,
AVg (sum(amount)/sum(boxes)) over() as total_avg_price
 from clean_chocolate
 group by product
 order by revenue desc,boxes,price_avg; 
 
 -- Smooth Sliky Salty is our best product generating most revenue,aswell as good order volume. 50% dark bites is most popular between the markets with almost 30K boxes ordered. 
 -- However we dont have products that underperform enough to be removed or corrected, indicating we hold balanced both in price and order volume product base. 

SELECT 
    MONTH(date) AS month,
    SUM(amount) AS revenue,
    Sum(boxes) as boxes
FROM clean_chocolate
GROUP BY month
ORDER BY revenue desc,boxes;


Select 
country,
Sum(amount) as amount
From clean_chocolate
group by country
order by amount desc;

Select 
country,
Sum(boxes) as boxes,
Sum(amount)/Sum(boxes) as price
from clean_chocolate
group by country
order by boxes desc,price;

