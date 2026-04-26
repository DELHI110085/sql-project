
-- Update Paid Date
Update dbo.Accounts_Payable
Set PaidDate= DateADD(Day, ABS(CHECKSUM(NEWID()))% 30, DueDate)

-- Category 1: Data Exploration
-- Purpose: Understand raw data in Accounts Payable Table
Select * from dbo.Accounts_Payable;

-- Category 2: Business KPIs
-- Purpose: Total Payables
Select SUM(Amount) AS Late_Paid_Amount
From dbo.Accounts_Payable
where paidDate> DueDate

-- Purpose: PAID Amount
Select Sum(Amount) From dbo.Accounts_Payable
Where PaidDate IS NOT NULL;


-- Category 3: Payment Delay Analysis
-- Purpose: Delay in payment
Select *, DATEDIFF(day,duedate,PaidDate) AS delaydays From dbo.Accounts_Payable

-- Category 4: Overdue Flag Status
Select *, CASE 
             WHEN PaidDate> DueDate THEN 'Overdue'
             WHEN PaidDate<= DueDate THEN 'On Time'
             Else 'OK'
             END AS PaymentStatusFlag
From dbo.Accounts_Payable;

-- Category 5: Avg Delay
Select AVG(CASE WHEN PaidDate is Not Null THEN DATEDIFF(DAY,DueDate, PaidDate) END)AS AVG_DELAY
From dbo.Accounts_Payable


-- Category 6: Vendor-wise spend
Select vendor, SUM(Amount) AS Total_Amount
From dbo.Accounts_Payable
Group by vendor
Order by Total_Amount Desc

--Category 7: Vendor Risk
Select vendor, Sum(Amount)AS total_amount,
Avg(DatedIFF(Day, DueDate, PaidDate)) AS Avg_Delay
From dbo.Accounts_Payable
Group By Vendor


-- Category 8: JOIN QUERIES (Data Relationships)
Select a.APID,a.vendor,a.amount,v.country
From dbo.accounts_payable a
Inner Join vendors v
On a.vendor=v.vendorname

-- Category 9: Advanced Logic CTE + Join
with AP_Vendor AS(Select a.Apid,a.Amount,a.Status,v.Country,v.Rating
                  From dbo.accounts_payable a
                  Join vendors v
                  on a.vendor= v.vendorname) Select * From AP_Vendor Where Rating>=4






                 