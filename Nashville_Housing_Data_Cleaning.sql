SELECT *
FROM Nashville_Housing.dbo.NashvilleHousing

-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM Nashville_Housing.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address Data - Select both parcelID and propertyAddress to get
-- the records where property address is null. We self join to compare where only
-- a.PropertyAddress is null, but b.PropertyAddress isn't, giving us the address for
-- the same ParcelIDs. We use the ISNULL operator to replace the NULL values in alias 'a'
-- with the values in alias 'b'

SELECT *
FROM Nashville_Housing.dbo.NashvilleHousing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Nashville_Housing..NashvilleHousing a
JOIN Nashville_Housing..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
		AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--When Updating with a JOIN, you must UPDATE the alias
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	FROM Nashville_Housing..NashvilleHousing a
	JOIN Nashville_Housing..NashvilleHousing b
		ON a.ParcelID = b.ParcelID
			AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


SELECT PropertyAddress
FROM Nashville_Housing..NashvilleHousing



--Checking for Delimiters, removing the comma from end index position of 1st
--delimited substring, then adding a second substring to include 2nd position
--which is the city

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS Address
FROM Nashville_Housing..NashvilleHousing


--Updating the table to include novel split address fields

ALTER TABLE Nashville_Housing..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE Nashville_Housing..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Nashville_Housing..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE Nashville_Housing..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM Nashville_Housing..NashvilleHousing


--Stripping address components out via PARSENAME

SELECT OwnerAddress
FROM Nashville_Housing..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Nashville_Housing..NashvilleHousing



-- Updating Table with PARSENAME-stripped address fields

ALTER TABLE Nashville_Housing..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE Nashville_Housing..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashville_Housing..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE Nashville_Housing..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville_Housing..NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE Nashville_Housing..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM Nashville_Housing..NashvilleHousing


--Changing Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Nashville_Housing..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM Nashville_Housing..NashvilleHousing

UPDATE Nashville_Housing..NashvilleHousing
SET SoldAsVacant = 
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END



--Removing Duplicates Using CTEs
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelId,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM Nashville_Housing..NashvilleHousing
)
DELETE
From RowNumCTE
WHERE row_num > 1





--Deleting Unused Columns; normally done to views, not to raw data

SELECT *
FROM Nashville_Housing..NashvilleHousing

ALTER TABLE Nashville_Housing..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Nashville_Housing..NashvilleHousing
DROP COLUMN SaleDate