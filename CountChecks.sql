SELECT count(distinct concat(LocationID, convert(int,DOB,0)),CheckNumber))
FROM ItemDetail
WHERE DOB between 4/3/2017 and 4/9/2017
