' ********************************************************************
' ********************************************************************
' ***** Video Data Model
' ***** Assuming API is always going to return JSON 
' ********************************************************************
' ********************************************************************



'*************************************************************
'** GetEntryData from Json
'*************************************************************
Function GetEntryData(EntryJson As Object)As Object

	data = { 
	 availableDate: EntryJson.availableDate 
     title: EntryJson.title 
     contents: GetContentsList(EntryJson.contents) 
     description: EntryJson.description 
     parentalRatings: GetParentalRatingsList(EntryJson.parentalRatings ) 
     credits: GetCreditsList(EntryJson.credits) 
     images: GetImagesList(EntryJson.images) 
     categories: GetCategoriesList(EntryJson.categories) 
     publishedDate:EntryJson.publishedDate 
     type: EntryJson.type
     metadata: GetMetaDataList(EntryJson.metadata) 
}
	return data

End Function


'*************************************************************
'** Get list of Contents
'*************************************************************
Function GetContentsList(ContentListJson As Object) As Object
	DbgPrint(3,"GetContens()")

		contentList=CreateObject("roList")
		  for each content in ContentListJson
            'result=GetContent(content)
		    contentList.AddTail(GetContent(content))
		  next
  		return contentList

End Function


'*************************************************************
'** Get Contents Object
'*************************************************************
Function GetContent(ContentJson As Object) As Object

  content = { 
	 id: ContentJson.id 
     duration: ContentJson.duration 
	 height: ContentJson.height 
     width: ContentJson.width 
	 format: ContentJson.format 
     language: ContentJson.language 
	 geoLock: ContentJson.geoLock 
     url: ContentJson.url 
}
	return content

End Function


'*************************************************************
'** Get list of Parental Rating
'*************************************************************
Function GetParentalRatingsList(pRListJson as Object) as Object
  DbgPrint(3,"GetParentalRatingsList()")

		pRList=CreateObject("roList")
		  for each pr in pRListJson
		    pRList.AddTail(GetParentalRatings(pr))
		  next
  		return pRList

End Function


'*************************************************************
'** Get Parental Rating Object
'*************************************************************
Function GetParentalRatings(pRJson as Object) as Object
	'PrintList(pRJson)

  	pR = { 
		scheme: pRJson.scheme 
   		rating: pRJson.rating 	
	}
	return pR

End Function


'*************************************************************
'** Get credit list
'*************************************************************
Function GetCreditsList(creditsListJson as Object) as Object
	DbgPrint(3,"GetCreditsList()")

		creditsList=CreateObject("roList")
		  for each credits in creditsListJson
		    creditsList.AddTail(GetCredits(credits))
		  next
  		return creditsList

End Function


'*************************************************************
'** Get Credits Object
'*************************************************************
Function GetCredits(creditsJson as Object) as Object

  credit = { 
	 name: creditsJson.name 
     role: creditsJson.role 	
}
	return credit

End Function


'*************************************************************
'** Get Image List
'*************************************************************
Function GetImagesList(imageListJson as Object) as Object

  DbgPrint(3,"GetImagesList()")

		imageList=CreateObject("roList")
		  for each image in imageListJson
		    imageList.AddTail(GetCredits(image))
		  next
  		return imageList

End Function


'*************************************************************
'** Get Image Object
'*************************************************************
Function GetImage(creditsJson as Object) as Object

  image = { 
	 type: imageJson.name 
     url: imageJson.role 	
	 width: imageJson.width,
	 height: imageJson.height,
	 id: imageJson.id
	}
	return image

End Function


'*************************************************************
'** Get Categorie List
'*************************************************************
Function GetCategoriesList(categoriesListJson as Object) as Object
	DbgPrint(3,"GetCategoriesList()")

		categoriesList=CreateObject("roList")
		  for each categorie in categoriesListJson
		    categoriesList.AddTail(GetCategorie(categorie))
		  next
  		return categoriesList

End Function


'*************************************************************
'** Get Categorie Object
'*************************************************************
Function GetCategorie(categoriJson as Object) as Object

  categori = { 
	 id: categoriJson.id 
     title: categoriJson.title 	
     description: categoriJson.description 
	}
	return categori

End Function


'*************************************************************
'** Get Meta Data List
'*************************************************************
Function GetMetaDataList(metadataListJson as Object) as Object
	DbgPrint(3,"GetMetaDataList()")

		metadataList=CreateObject("roList")
		  for each metadata in metadataListJson
		    metadataList.AddTail(GetMetaData(metadata))
		  next
  		return metadataList

End Function


'*************************************************************
'** Get Meta Data Object
'*************************************************************
Function GetMetaData(metaDataJson as Object) as Object

  metaData = { 
	 name: metaDataJson.name 
     value: metaDataJson.value 'String
	}
	return metaData

End Function



