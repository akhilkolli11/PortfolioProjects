--Cleaning data using SQL queries 

select *
from PortfolioProject..NashvilleHousing

-- Standardize date format

select SaleDateConverted, convert(date, saledate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date, saledate)

alter table nashvillehousing
add SaleDateConverted date

update NashvilleHousing
set SaleDateConverted = convert(date, saledate)


-- Populate Property Address Data

select PropertyAddress
from PortfolioProject..NashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out address into individual columns (Address, City, State)

select PropertyAddress
from PortfolioProject..NashvilleHousing
--order by ParcelID

select
substring(propertyaddress, 1, charindex(',', propertyaddress) -1 ) as Address
, substring(propertyaddress, charindex(',', propertyaddress) +1 , len(propertyaddress)) as City
from portfolioproject..nashvillehousing

alter table nashvillehousing
add PropertySplitAddress nvarchar(255)

update nashvillehousing
set PropertySplitAddress = substring(propertyaddress, 1, charindex(',', propertyaddress) -1 ) 

alter table nashvillehousing
add PropertySplitCity nvarchar(255)

update nashvillehousing
set PropertySplitCity = substring(propertyaddress, charindex(',', propertyaddress) +1 , len(propertyaddress)) 


select owneraddress
from nashvillehousing

select 
parsename(replace(owneraddress, ',', '.'), 3) as Address,
parsename(replace(owneraddress, ',', '.'), 2) as City,
parsename(replace(owneraddress, ',', '.'), 1) as State
from nashvillehousing


alter table nashvillehousing
add OwnerSplitAddress nvarchar(255)

update nashvillehousing
set OwnerSplitAddress = parsename(replace(owneraddress, ',', '.'), 3) 

alter table nashvillehousing
add OwnerSplitCity nvarchar(255)

update nashvillehousing
set OwnerSplitCity = parsename(replace(owneraddress, ',', '.'), 2) 

alter table nashvillehousing
add OwnerSplitState nvarchar(255)

update nashvillehousing
set OwnerSplitState = parsename(replace(owneraddress, ',', '.'), 1)



-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(soldasvacant), count(soldasvacant)
from nashvillehousing
group by soldasvacant
order by 2

select soldasvacant,
CASE
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end
from nashvillehousing

update nashvillehousing 
set soldasvacant = CASE
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end


-- Remove duplicates 

WITH RowNumCTE as (
select *,
	row_number() over (
	partition by parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by
				 uniqueid
				 ) row_num
from nashvillehousing
)
select *
from rowNumCTE
where row_num > 1


-- Delete Unused Columns

select * from nashvillehousing

alter table nashvillehousing
drop column propertyaddress, owneraddress, taxdistrict

alter table nashvillehousing
drop column saledate
