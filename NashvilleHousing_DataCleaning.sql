
select *
from project_portfolio.dbo.NashvilleHousing


--Standarize Date Format


select SaleDate,CONVERT(Date , SaleDate) as SaleDate
FROM project_portfolio.dbo.NashvilleHousing


Update project_portfolio.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date , SaleDate)

Alter table project_portfolio.dbo.NashvilleHousing
Add SaleDateConverted Date;

update project_portfolio.dbo.NashvilleHousing
set SaleDateConverted = CONVERT(Date , SaleDate)

select SaleDateConverted,CONVERT(Date , SaleDate) as SaleDateConverted
FROM project_portfolio.dbo.NashvilleHousing

select PropertyAddress
FROM project_portfolio.dbo.NashvilleHousing
where PropertyAddress is null

--Populate Property Address Data

select *
FROM project_portfolio.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelId

select a.ParcelId,a.PropertyAddress,b.ParcelId,b.PropertyAddress
FROM project_portfolio.dbo.NashvilleHousing a
join project_portfolio.dbo.NashvilleHousing b
  on a.ParcelId = b.ParcelId
  AND a.[UniqueID ] <> b.[UniqueID ]

select a.ParcelId,a.PropertyAddress,b.ParcelId,b.PropertyAddress
FROM [project_portfolio].[dbo].[NashvilleHousing] a
join [project_portfolio].[dbo].[NashvilleHousing] b
  on a.ParcelId = b.ParcelId
  AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  select a.ParcelId,a.PropertyAddress,b.ParcelId,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [project_portfolio].[dbo].[NashvilleHousing] a
join [project_portfolio].[dbo].[NashvilleHousing] b
  on a.ParcelId = b.ParcelId
  AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null


update a
  Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [project_portfolio].[dbo].[NashvilleHousing] a
join [project_portfolio].[dbo].[NashvilleHousing] b
  on a.ParcelId = b.ParcelId
  AND a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

--Breaking out Address Into Individual Column(Address,City,State)

select PropertyAddress
FROM project_portfolio.dbo.NashvilleHousing

select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)) as Address
FROM project_portfolio.dbo.NashvilleHousing




select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM project_portfolio.dbo.NashvilleHousing


Alter table project_portfolio.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update project_portfolio.dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)


Alter table project_portfolio.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

update project_portfolio.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



select *
from project_portfolio.dbo.NashvilleHousing

select OwnerAddress
from project_portfolio.dbo.NashvilleHousing

select PARSENAME(replace(OwnerAddress,',','.'),1)
from project_portfolio.dbo.NashvilleHousing

select PARSENAME(replace(OwnerAddress,',','.'),1)
,PARSENAME(replace(OwnerAddress,',','.'),2)
,PARSENAME(replace(OwnerAddress,',','.'),3)
from project_portfolio.dbo.NashvilleHousing


select PARSENAME(replace(OwnerAddress,',','.'),3)
,PARSENAME(replace(OwnerAddress,',','.'),2)
,PARSENAME(replace(OwnerAddress,',','.'),1)
from project_portfolio.dbo.NashvilleHousing


Alter table project_portfolio.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

update project_portfolio.dbo.NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)


Alter table project_portfolio.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

update project_portfolio.dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)


Alter table project_portfolio.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

update project_portfolio.dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

select *
from project_portfolio.dbo.NashvilleHousing

--Chage "Y" and "N" to Yes and No in "Sold as Vacant"field

select distinct(SoldAsVacant)
from project_portfolio.dbo.NashvilleHousing

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from project_portfolio.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  END
from  project_portfolio.dbo.NashvilleHousing


update project_portfolio.dbo.NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  END

	  --Remove Duplicates

select *,
		row_number() over (
		partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order by
							UniqueID
					 )		row_num
from project_portfolio.dbo.NashvilleHousing

with RowNumCTE AS(
select *,
		row_number() over (
		partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order by
							UniqueID
					 )		row_num
from project_portfolio.dbo.NashvilleHousing
)
select * 
from RowNumCTE
where row_num > 1
order by PropertyAddress


with RowNumCTE AS(
select *,
		row_number() over (
		partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order by
							UniqueID
					 )		row_num
from project_portfolio.dbo.NashvilleHousing
)
delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress

--Delete Unused Columns

select *
from project_portfolio.dbo.NashvilleHousing

Alter table project_portfolio.dbo.NashvilleHousing
 drop column OwnerAddress,TaxDistrict,PropertyAddress

Alter table project_portfolio.dbo.NashvilleHousing
 drop column SaleDate