

                    *** -- Cleaning Data in SQL Queries -- *** 

Select * 
FROM [PortfolioProject].[dbo].[Nashville Housing]

--------------------------------------------------------------------------------------

                   -- Standarize data formate


Select SaleDate --,convert(date,saledate ) 
FROM [PortfolioProject].[dbo].[NashvilleHousing]

--UPDATE [NashvilleHousing]   ==>> نضيف كولم في الجدول
--SET saledate = convert(date , SaleDate ) 

ALTER TABLE [NashvilleHousing] 
ADD SaleDateConverted Date ;

UPDATE [NashvilleHousing]
SET SaleDateConverted = convert(date , SaleDate ) 

Select SaleDateConverted
FROM [PortfolioProject].[dbo].[NashvilleHousing]


      -- populate proberty address data

Select PropertyAddress
FROM [PortfolioProject].[dbo].[NashvilleHousing]
WHERE PropertyAddress IS NULL



Select *
FROM [PortfolioProject].[dbo].[NashvilleHousing]
WHERE PropertyAddress IS NULL



Select *
FROM [PortfolioProject].[dbo].[NashvilleHousing]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

Select A.ParcelID,
       A.PropertyAddress , 
	   B.ParcelID,
	   B.PropertyAddress ,
	   ISNULL(A.PropertyAddress ,B.PropertyAddress )
FROM [PortfolioProject].[dbo].[NashvilleHousing] A 
JOIN [PortfolioProject].[dbo].[NashvilleHousing] B 
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE a.PropertyAddress is null



UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress ,B.PropertyAddress )
FROM [PortfolioProject].[dbo].[NashvilleHousing] A 
JOIN [PortfolioProject].[dbo].[NashvilleHousing] B 
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE a.PropertyAddress is null


--> as example
UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress ,'No Address' )
FROM [PortfolioProject].[dbo].[NashvilleHousing] A 
JOIN [PortfolioProject].[dbo].[NashvilleHousing] B 
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE a.PropertyAddress is null


--------------------------------------------------------------------------------

          --  preaking out address Into indvidual coulum ( adress , sity , state) --



Select PropertyAddress
FROM [PortfolioProject].[dbo].[NashvilleHousing]

--> to select sup string from column  ',' من البدايه الي ال      

Select SUBSTRING( PropertyAddress , 1 , CHARINDEX( ',' , PropertyAddress)) As Address
FROM [PortfolioProject].[dbo].[NashvilleHousing]


Select SUBSTRING( PropertyAddress , 1 , CHARINDEX( ',' , PropertyAddress)-1) As Address
FROM [PortfolioProject].[dbo].[NashvilleHousing]


--> to select sup string from column  من ',' الي النهايه 

Select SUBSTRING( PropertyAddress , CHARINDEX( ',' , PropertyAddress)+1 ,LEN(PropertyAddress)) As Address
FROM [PortfolioProject].[dbo].[NashvilleHousing]



Select SUBSTRING( PropertyAddress , 1 , CHARINDEX( ',' , PropertyAddress)-1) As Address , 
       SUBSTRING( PropertyAddress , CHARINDEX( ',' , PropertyAddress)+1 ,LEN(PropertyAddress)) As Address
FROM [PortfolioProject].[dbo].[NashvilleHousing]

--> table نضيف ال2 كولم في ال  

ALTER TABLE [NashvilleHousing] 
ADD PropertySplitAddress NVARCHAR(255) ;

UPDATE [NashvilleHousing]
SET PropertySplitAddress = SUBSTRING( PropertyAddress , 1 , CHARINDEX( ',' , PropertyAddress)-1) 



ALTER TABLE [NashvilleHousing] 
ADD PropertySplitCity NVARCHAR(255) ;

UPDATE [NashvilleHousing]
SET PropertySplitCity =  SUBSTRING( PropertyAddress , CHARINDEX( ',' , PropertyAddress)+1 ,LEN(PropertyAddress))



SELECT * 
FROM PortfolioProject..NashvilleHousing



SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing



SELECT PARSENAME(REPLACE( OwnerAddress, ',' , '.' ) , 3) ,
       PARSENAME(REPLACE( OwnerAddress, ',' , '.' ) , 2) ,
	   PARSENAME(REPLACE( OwnerAddress, ',' , '.' ) , 1)  
FROM PortfolioProject..NashvilleHousing


ALTER TABLE [NashvilleHousing] 
ADD OwnerSplitAddress NVARCHAR(255) ;

UPDATE [NashvilleHousing]
SET OwnerSplitAddress =  PARSENAME(REPLACE( OwnerAddress, ',' , '.' ) , 3)



ALTER TABLE [NashvilleHousing] 
ADD OwnerSplitCity NVARCHAR(255) ;

UPDATE [NashvilleHousing]
SET OwnerSplitCity =   PARSENAME(REPLACE( OwnerAddress, ',' , '.' ) , 2) 



ALTER TABLE [NashvilleHousing] 
ADD OwnerSplitState NVARCHAR(255) ;

UPDATE [NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE( OwnerAddress, ',' , '.' ) , 1) 



SELECT * 
FROM PortfolioProject..NashvilleHousing




              --change Y and N TO YES and NO in "Solid as Vacant" field

-->>> to new uinqe value   علشان نعرف القيم الموجوده ال يونيك  

SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing


SELECT DISTINCT(SoldAsVacant) , 
       count(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by SoldAsVacant


SELECT SoldAsVacant ,
 CASE WHEN SoldAsVacant = 'Y' then 'Yes' 
      WHEN SoldAsVacant = 'N' then 'No' 
      ELSE SoldAsVacant
 END
FROM PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing 
SET SoldAsVacant =
	CASE WHEN SoldAsVacant = 'Y' then 'Yes' 
		  WHEN SoldAsVacant = 'N' then 'No' 
		  ELSE SoldAsVacant
	 END







			  -- Remove Duplicates



SELECT * ,
      ROW_NUMBER() OVER(
	  PARTITION BY ParcelID
	                ,PropertyAddress
					, SalePrice
					, SaleDate
					, LegalReference
       order by UniqueID       )  row_num
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID




WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM PortfolioProject..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;



WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM PortfolioProject..NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1





			  -- Delete  UnUse Columes

select * 
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress , TaxDistrict , propertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate