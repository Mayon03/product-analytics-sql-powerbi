WITH cte AS (
  SELECT
      a.Product, a.Category, a.Brand, a.Description,
      a.Sale_Price, a.Cost_Price, a.Image_Url,

      b.[Date],
      b.Customer_Type, b.Discount_Band, b.Units_Sold,

      a.Sale_Price * b.Units_Sold AS revenue,
      a.Cost_Price * b.Units_Sold AS total_cost,

      CAST(b.[Date] AS date)               AS DateOnly,
      CONVERT(varchar(10), b.[Date], 103)  AS Date_ddMMyyyy,
      DATENAME(month, b.[Date])            AS [Month],
      YEAR(b.[Date])                       AS [Year]
  FROM dbo.product_data  AS a
  JOIN dbo.product_sales AS b
    ON a.Product_ID = b.Product  
)
SELECT
  c.*,
  (1 - d.Discount * 1.0 / 100) * c.revenue AS discount_revenue
FROM cte c
JOIN dbo.discount_data d
  ON c.Discount_Band = d.Discount_Band
 AND c.[Month] = d.[Month];

