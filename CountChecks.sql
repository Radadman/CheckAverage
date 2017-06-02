
--Get Count of Checks that are not catering
SELECT count(distinct concat(id.LocationID, convert(int,id.DOB,0), id.CheckNumber))
FROM SaleDepartment sd
INNER JOIN Item i ON sd.SaleDepartmentID = i.SaleDepartmentID
INNER JOIN ItemDetail id ON i.ItemID = id.ItemID
WHERE DOB BETWEEN @StartDate and @EndDate
AND MasterSaleDepartmentID<>3

--Count Quantity of Items on Checks that have combo
Select count(exp.Quantity)
From (Select id.*, igm.ItemGroupID From ItemDetail id INNER JOIN ItemGroupMember igm ON id.ItemID = igm.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate') exp
    Where
    exists (Select e1.ItemGroupID From (Select id.*, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate' AND igm.ItemGroupID in (302) AND id.GrossPrice >1) e1 Where concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
and exists (Select e1.ItemGroupID From (Select id.*, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN '@StartDate' AND '@EndDate' AND igm.ItemGroupID in (303) AND id.GrossPrice >1) e1 Where concat(e1.LocationID, convert(int,e1.DOB,0), e1.CheckNumber) = concat(exp.LocationID, convert(int,exp.DOB,0), exp.CheckNumber))
AND exp.ItemGroupID = 303
AND exp.GrossPrice >1
