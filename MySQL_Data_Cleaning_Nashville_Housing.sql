CREATE TABLE ville.housing
SELECT *
FROM ville.`nashville housing`;

select *
from housing;

-- Remove duplicates
WITH dup AS
(SELECT *, row_number() OVER(PARTITION BY UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath) as row_num
FROM housing)
select *
from dup
where row_num>1;

-- check if variables are standardized
select distinct landUSE
from housing;

-- Standardize Date Format
ALTER TABLE Housing
ADD saleDate1 DATE;

UPDATE housing
SET saleDate1 = STR_TO_DATE(saleDate, '%e-%b-%y');

-- Populate Property Address data
select * from housing;

SELECT distinct PropertyAddress 
from housing 
order by 1 Asc;

SELECT * from housing
where PropertyAddress="";

UPDATE housing
SET PropertyAddress=null
where PropertyAddress="";

UPDATE housing t1
JOIN housing t2
ON t1.ParcelID=t2.ParcelID
SET t1.PropertyAddress=t2.PropertyAddress
where t1.PropertyAddress IS NULL and t2.PropertyAddress IS NOT NULL;

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT
SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1 , LENGTH(PropertyAddress)) as Address1
From Housing;

ALTER TABLE Housing
Add PropertysplitAddress varchar(255);

Update Housing
SET PropertysplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

ALTER TABLE Housing
Add PropertyCity varchar(255);

Update Housing
SET PropertyCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1 , LENGTH(PropertyAddress));

Select OwnerAddress
From Housing;

Select
SUBSTRING_INDEX(OwnerAddress, ',', -1)
,SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)
,SUBSTRING_INDEX(OwnerAddress, ',', 1)
From Housing;

-- Address
ALTER TABLE Housing
Add OwnerSplitAddress varchar(255);

Update Housing
SET OwnerSplitAddress = SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '.') ,'.' , 3);

-- City
ALTER TABLE Housing
Add OwnerSplitCity varchar(255);

Update Housing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);

-- State
ALTER TABLE Housing
Add OwnerSplitState varchar(255);

Update Housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Housing
Group by SoldAsVacant
order by 2;

Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
;
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) as row_num

From Housing
order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

Select *
From Housing;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

ALTER TABLE Housing
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress, 
DROP COLUMN SaleDate;

