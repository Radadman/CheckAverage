
--Get Count of Checks that Have no catering items
SELECT count(distinct concat(id.LocationID, convert(int,id.DOB,0), id.CheckNumber))
FROM SaleDepartment sd
INNER JOIN Item i ON sd.SaleDepartmentID = i.SaleDepartmentID
INNER JOIN ItemDetail id ON i.ItemID = id.ItemID
WHERE DOB BETWEEN @StartDate and @EndDate
AND MasterSaleDepartmentID<>3

--Get Total Net Sales of all checks that do not include catering
