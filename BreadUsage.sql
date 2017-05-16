-- For Bread Count report, calculates cases usage on 7", 10.5", 14", 
SELECT id.LocationID, ig.ItemGroupName, SUM(id.Quantity) as Sandwiches, 
CASE When igm.ItemGroupID = 127 Then Round((((SUM(id.Quantity) * 7)/22)/24),0) 
When igm.ItemGroupID = 128 Then Round((((Sum(id.Quantity)*10.5)/22)/24),0)
When igm.ItemGroupID = 129 Then Round((((Sum(id.Quantity)*14)/22)/24),0)
When igm.ItemGroupID = 261 Then Round((((Sum(id.Quantity)*3.5)/22)/24),0)
When igm.ItemGroupID = 130 Then Round((((Sum(id.Quantity)*10*7)/22)/24),0)
When igm.ItemGroupID = 282 Then Round((((Sum(id.Quantity)*15*7)/22)/24),0)
When igm.ItemGroupID = 131 Then Round((((Sum(id.Quantity)*6*7)/22)/24),0)
Else Round((((Sum(id.Quantity)*23)/22)/24),0)
END as Cases
FROM ItemDayTotal id
INNER JOIN ItemGroupMember igm ON id.ItemID = igm.ItemID
INNER JOIN ItemGroup ig ON igm.ItemGroupID = ig.ItemGroupID
INNER JOIN LocationGroupMember lgm ON id.LocationID = lgm.LocationID 
WHERE id.DOB Between '@StartDate' and '@EndDate'
AND igm.ItemGroupID IN (127, 128, 129, 261, 130, 282, 131, 246)
AND lgm.LocationGroupID = '@LocationGroupID'
GROUP BY id.LocationID, ig.ItemGroupName, igm.ItemGroupID
ORDER BY id.LocationID
