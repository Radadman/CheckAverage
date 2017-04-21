--Select only checks that have sandwich and drink
Select exp.checknumber
    From (Select id.* From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN 3/22/2017 AND 3/22/2017 AND id.LocationID = 22) exp
    Where
    exists (Select e1.ItemGroupID From (Select id.*, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN 3/22/2017 AND 3/22/2017 AND id.LocationID = 22) e1 Where e1.checknumber = exp.checknumber and e1.ItemGroupID in (281))
    and exists (Select e1.ItemGroupID From (Select id.*, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN 3/22/2017 AND 3/22/2017 AND id.LocationID = 22) e1 Where e1.checknumber = exp.checknumber and e1.ItemGroupID in (274))
    and not exists (Select e1.ItemGroupID From (Select id.*, igm.ItemGroupID From ItemGroupMember igm INNER JOIN ItemDetail id ON igm.ItemID = id.ItemID WHERE id.DOB BETWEEN 3/22/2017 AND 3/22/2017 AND id.LocationID = 22) e1 Where e1.checknumber = exp.checknumber and e1.ItemGroupID in (280, 34))
    Group by exp.checknumber
    order by exp.checknumber
