
--Select checks with a certain item
Select distinct concat(ch.LocationID, convert(int,ch.DOB,0), ch.CheckNumber) AS CheckID, SUM(ch.GrossPrice) AS GrossPrice
FROM (Select it.* FROM ItemDetail it WHERE it.LocationID = 22 AND it.DOB BETWEEN @StartDate and @EndDate) ch 
WHERE exists (Select e1.LocationID, e1.DOB, e1.CheckNumber FROM (Select id.* FROM ItemDetail id WHERE id.ItemID = 201 and id.DOB BETWEEN @StartDate and @EndDate and LocationID = 22) e1 WHERE concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(ch.LocationID, convert(int,ch.DOB,0), ch.CheckNumber))
GROUP BY ch.LocationID, ch.DOB, ch.CheckNumber
ORDER BY CheckID

--Select checks with kids meals
Select distinct concat(ch.LocationID, convert(int,ch.DOB,0), ch.CheckNumber) AS CheckID, SUM(ch.GrossPrice) AS GrossPrice
FROM (Select it.* FROM ItemDetail it WHERE it.LocationID = 22 AND it.DOB BETWEEN @StartDate and @EndDate) ch 
WHERE exists (Select e1.LocationID, e1.DOB, e1.CheckNumber FROM (Select id.* FROM ItemDetail id WHERE id.ItemID IN (1376,1669,1767,1358,1687,1766,9258,1666,1308,2085,189,188,186,187,12507,1384,1857,1410,1853,1331,1619,1942,8334,8336,12498,8342,8346)
and id.DOB BETWEEN @StartDate and @EndDate and LocationID = 22) e1 WHERE concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(ch.LocationID, convert(int,ch.DOB,0), ch.CheckNumber))
GROUP BY ch.LocationID, ch.DOB, ch.CheckNumber
ORDER BY CheckID

--Select only checks that have sandwich (no catering)
SELECT distinct concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber) AS CheckID, SUM(exp.GrossPrice) AS GrossPrice, SUM(exp.NetPrice) AS NetPrice
FROM (Select id.* FROM ItemDetail id INNER JOIN ItemGroupMember igm ON id.ItemID = igm.ItemID Where DOB Between @StartDate and @EndDate and igm.ItemGroupID = 281) exp
WHERE 
DOB BETWEEN @StartDate and @EndDate
AND GrossPrice > 4.5
GROUP BY exp.LocationID, exp.DOB, exp.CheckNumber

--Select only checks that have a catering item
SELECT concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber) AS CheckID, exp.GrossPrice, exp.NetPrice, exp.MasterSaleDepartmentID
FROM 
(SELECT id.LocationID, id.DOB, id.CheckNumber, id.GrossPrice, id.NetPrice, msd.MasterSaleDepartmentID 
FROM ItemDetail id
INNER JOIN Item it ON id.ItemID = it.ItemID
INNER JOIN SaleDepartment sd ON it.SaleDepartmentID = sd.SaleDepartmentID
INNER JOIN MasterSaleDepartment msd ON sd.MasterSaleDepartmentID = msd.MasterSaleDepartmentID 
WHERE DOB BETWEEN @StartDate and @EndDate) exp
WHERE exists 
(SELECT cat.LocationID, cat.DOB, cat.CheckNumber, cat.ItemID, cat.GrossPrice, cat.NetPrice, cat.MasterSaleDepartmentID
FROM (SELECT id.*, sd.MasterSaleDepartmentID FROM ItemDetail id
INNER JOIN Item it ON id.ItemID = it.ItemID 
INNER JOIN SaleDepartment sd ON it.SaleDepartmentID = sd.SaleDepartmentID and sd.MasterSaleDepartmentID = 3
WHERE DOB BETWEEN @StartDate and @EndDate) cat WHERE concat(cat.LocationID,convert(int,cat.DOB,0), cat.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))

--Count # of catering checks
SELECT count(distinct(concat(id.LocationID, convert(int,id.DOB,0), id.CheckNumber))) AS CheckID
FROM ItemDetail id
INNER JOIN Item it ON id.ItemID = it.ItemID
INNER JOIN SaleDepartment sd ON it.SaleDepartmentID = sd.SaleDepartmentID
INNER JOIN MasterSaleDepartment msd ON sd.MasterSaleDepartmentID = msd.MasterSaleDepartmentID 
WHERE id.DOB BETWEEN '@StartDate' and '@EndDate' 
and msd.MasterSaleDepartmentID = 3

-- Count of catering checks by location by day
SELECT count(distinct concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber)) AS CheckCount, exp.LocationID, convert(varchar(10), exp.DOB, 110) AS Date
FROM 
(SELECT id.LocationID, lgm.LocationGroupID, id.DOB, id.CheckNumber, id.GrossPrice, id.NetPrice, msd.MasterSaleDepartmentID  
FROM ItemDetail id
INNER JOIN Item it ON id.ItemID = it.ItemID
INNER JOIN SaleDepartment sd ON it.SaleDepartmentID = sd.SaleDepartmentID
INNER JOIN MasterSaleDepartment msd ON sd.MasterSaleDepartmentID = msd.MasterSaleDepartmentID
INNER JOIN LocationGroupMember lgm ON id.LocationID = lgm.LocationID
WHERE DOB BETWEEN '@StartDate' and '@EndDate') exp
WHERE exists 
(SELECT cat.LocationID, cat.DOB, cat.CheckNumber, cat.ItemID, cat.GrossPrice, cat.NetPrice, cat.MasterSaleDepartmentID
FROM (SELECT id.*, sd.MasterSaleDepartmentID FROM ItemDetail id
INNER JOIN Item it ON id.ItemID = it.ItemID 
INNER JOIN SaleDepartment sd ON it.SaleDepartmentID = sd.SaleDepartmentID and sd.MasterSaleDepartmentID = 3
WHERE DOB BETWEEN '@StartDate' and '@EndDate') cat WHERE concat(cat.LocationID,convert(int,cat.DOB,0), cat.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
AND exp.LocationGroupID = 1782
GROUP BY exp.LocationID, exp.DOB

-- Count Items where check has a combo
Select sum(exp.Quantity)
From (Select id.*, igm.ItemGroupID From ItemDetail id INNER JOIN ItemGroupMember igm ON id.ItemID = igm.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate') exp
    Where
    exists (Select e1.ItemGroupID From (Select id.*, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate' AND igm.ItemGroupID in (302) AND id.GrossPrice >1) e1 Where concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
and exists (Select e1.ItemGroupID From (Select id.*, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate' AND igm.ItemGroupID in (303) AND id.GrossPrice >1) e1 Where concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
and exists (Select e1.ItemGroupID From (Select id.*, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate' AND igm.ItemGroupID in (178,179,180) AND id.GrossPrice >1) e1 Where concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
AND exp.ItemGroupID IN (178,179,180)
AND exp.GrossPrice >1

-- Count Items for Item Group and Location Group
SELECT sum(exp.Quantity)
From (Select id.quantity, id.GrossPrice, id.LocationID, id.DOB, id.CheckNumber, id.ItemID, igm.ItemGroupID From ItemDetail id INNER JOIN ItemGroupMember igm ON id.ItemID = igm.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate') exp
    Where
    exists (Select e1.ItemGroupID From (Select id.quantity, id.GrossPrice, id.LocationID, id.DOB, id.CheckNumber, id.ItemID, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate' AND igm.ItemGroupID = 302 AND id.GrossPrice >1) e1 Where concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
and exists (Select e1.ItemGroupID From (Select id.quantity, id.GrossPrice, id.LocationID, id.DOB, id.CheckNumber, id.ItemID, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate' AND igm.ItemGroupID = 303 AND id.GrossPrice >1) e1 Where concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
and exists (Select e1.ItemGroupID From (Select id.quantity, id.GrossPrice, id.LocationID, id.DOB, id.CheckNumber, id.ItemID, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate' AND igm.ItemGroupID in (178,179,180) AND id.GrossPrice >1) e1 Where concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
AND exp.ItemGroupID = 303
AND exp.GrossPrice >1
