/*
Cleaning data in SQL Queries
*/
select *
from PortfolioProject.dbo.NashvilleHousing

-- Standardize Date Format

select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date

update PortfolioProject.dbo.NashvilleHousing
set SaleDateConverted = Convert(Date, SaleDate)

--Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where ParcelId is Null
Order By ParcelId

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b 
  on a.ParcelID = b.ParcelID 
     And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b 
  on a.ParcelID = b.ParcelID 
     And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking Out Address inti Individual Columns (Address, City, State)



Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where ParcelId is Null
--Order By ParcelId

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address1,
SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , Len(PropertyAddress)) as Address2
From PortfolioProject.dbo.NashvilleHousing


Alter Table  PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Varchar(255)

Update  PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


Alter Table  PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Varchar(255)


Update  PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity  = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , Len(PropertyAddress))

select *
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
From PortfolioProject.dbo.NashvilleHousing


Select PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
From PortfolioProject.dbo.NashvilleHousing


Select PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From PortfolioProject.dbo.NashvilleHousing


Alter Table  PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update  PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

Alter Table  PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Update  PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


Alter Table  PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update  PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

Select *
From PortfolioProject.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field 

Select Distinct SoldAsVacant, Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant, Case
when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End
from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = Case
when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End


--Remove Duplicates
WITH RowNumCTE AS (
Select *,
ROW_NUMBER() OVER(
Partition BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order BY
			     UniqueID
				 ) Row_num
From  PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
Delete 
From RowNumCTE
Where Row_num > 1



WITH RowNumCTE AS (
Select *,
ROW_NUMBER() OVER(
Partition BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order BY
			     UniqueID
				 ) Row_num
From  PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where Row_num > 1

-- Delete Unused Columns


Select *
From  PortfolioProject.dbo.NashvilleHousing 

Alter Table  PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table  PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate









