module CollectionSpace
  module Converter
    module Core
      class CoreCollectionObject < CollectionObject
        ::CoreCollectionObject = CollectionSpace::Converter::Core::CoreCollectionObject
        def convert
          run do |xml|
            CoreCollectionObject.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          pairs = {
            'objectnumber' => 'objectNumber',
            'numberofobjects' => 'numberOfObjects',
            'collection' => 'collection',
            'recordstatus' => 'recordStatus',
            'copynumber' => 'copyNumber',
            'editionnumber' => 'editionNumber',
            'phase' => 'phase',
            'sex' => 'sex',
            'objectproductionnote' => 'objectProductionNote',
            'fieldcollectionnote' => 'fieldCollectionNote',
            'fieldcollectionfeature' => 'fieldCollectionFeature',
            'distinguishingfeatures' => 'distinguishingFeatures',
            'agequalifier' => 'ageQualifier',
            'age' => 'age',
            'ageunit' => 'ageUnit',
            'physicaldescription' => 'physicalDescription',
            'objecthistorynote' => 'objectHistoryNote',
            'ownershipaccess' => 'ownershipAccess',
            'ownershipcategory' => 'ownershipCategory',
            'ownershipplace' => 'ownershipPlace',
            'ownershipexchangemethod' => 'ownershipExchangeMethod',
            'ownershipexchangenote' => 'ownershipExchangeNote',
            'ownershipexchangepricecurrency' => 'ownershipExchangePriceCurrency',
            'ownershipexchangepricevalue' => 'ownershipExchangePriceValue',
            'contentdescription' => 'contentDescription',
            'contentdategroup' => 'contentDateGroup',
            'contentnote' => 'contentNote'
          }
          pairs_transforms = {
            'agequalifier' => {'vocab' => 'agequalifier'},
            'ownershipexchangepricecurrency' => {'vocab' => 'currency'},
            'contentdategroup' => {'special' => 'structured_date'}
          }
          CSXML::Helpers.add_title(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          repeats = {
            'briefdescription' => ['briefDescriptions', 'briefDescription'],
            'comments' => ['comments', 'comment'],
            'fieldcollectioneventname' => ['fieldColEventNames', 'fieldColEventName'],
            'form' => ['forms', 'form'],
            'responsibledepartment' => ['responsibleDepartments', 'responsibleDepartment'],
            'style' => ['styles', 'style'],
            'color' => ['colors', 'color'],
            'objectstatus' => ['objectStatusList', 'objectStatus'],
            'contentperson' => ['contentPersons', 'contentPerson'],
            'inventorystatus' => ['inventoryStatusList', 'inventoryStatus'],
            'publishto' => ['publishToList', 'publishTo'],
            'objectproductionreason' => ['objectProductionReasons', 'objectProductionReason'],
            'objectproductiondate' => ['objectProductionDateGroupList', 'objectProductionDateGroup'],
            'ownerperson' => ['owners', 'owner'],
            'ownerorganization' => ['owners', 'owner'],
            'ownershipdate' => ['ownershipDateGroupList', 'ownershipDateGroup'],
            'contentpeople' => ['contentPeoples', 'contentPeople'],
            'contentplace' => ['contentPlaces', 'contentPlace'],
            'contentscript' => ['contentScripts', 'contentScript'],
            'contentorganization' => ['contentOrganizations', 'contentOrganization'],
            'contentlanguage' => ['contentLanguages', 'contentLanguage'],
            'contentactivity' => ['contentActivities', 'contentActivity'],
            'contentposition' => ['contentPositions', 'contentPosition'], 
            'contentconcept' => ['contentConcepts', 'contentConcept']
          }
          repeatstransforms = {
            'contentperson' => {'authority' => ['personauthorities', 'person']},
            'inventorystatus' => {'vocab' => 'inventorystatus'},
            'publishto' => {'vocab' => 'publishto'},
            'objectproductiondate' => {'special' => 'structured_date'},
            'ownerperson' => {'authority' => ['personauthorities', 'person']},
            'ownerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'ownershipdate' => {'special' => 'structured_date'},
            'contentorganization' => {'authority' => ['orgauthorities', 'organization']},
            'contentlanguage' => {'vocab' => 'languages'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          #measuredPartGroupList, measuredPartGroup 
          CSXML::Helpers.add_measured_part_group_list(xml, attributes)
          #objectProductionDateGroupList, objectProductionDateGroup 
=begin
          objectproductiondate_data = {
            'objectproductiondate' => 'objectProductionDate',
          }
          objectproductiondate_transforms = {
            'objectproductiondate' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionDate',
            objectproductiondate_data,
            objectproductiondate_transforms
          )
=end
          #textualInscriptionGroupList,textualInscriptionGroup 
          textualinscriptiondata = {
            'inscriber' => 'inscriptionContentInscriber',
            'method' => 'inscriptionContentMethod'
          }
          textualinscriptiontransforms = {
            'inscriber' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'textualInscription',
            textualinscriptiondata,
            textualinscriptiontransforms
          )
          #objectProductionOrganizationGroupList, objectProductionOrganizationGroup
          objectprodorgdata = {
            'objectproductionorganization' => 'objectProductionOrganization',
            'objectproductionorganizationrole' => 'objectProductionOrganizationRole'
          }
          objectprodorgtransforms = {
            'productionorg' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionOrganization',
            objectprodorgdata,
            objectprodorgtransforms
          )
          #objectProductionPersonGroupList, objectProductionPersonGroup
          objectprodpersondata = {
            'productionperson' => 'objectProductionPerson',
            'personrole' => 'objectProductionPersonRole'
          }
          objectprodpersontransforms = {
            'productionperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPerson',
            objectprodpersondata,
            objectprodpersontransforms
          )
          # not simple because 'objectProductionPeople' singularized as 'objectProductionPerson'
          objectprodpeopledata = {
            'objectproductionpeople' => 'objectProductionPeople',
            'objectproductionpeoplerole' => 'objectProductionPeopleRole'
          } 
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPeople',
            objectprodpeopledata,
          )
          #objectNameList, objectNameGroup
          objectname_data = {
            'objectname' => 'objectName',
            'objectnamecurrency' => 'objectNameCurrency',
            'objectnamelevel' => 'objectNameLevel',
            'objectnamesystem' => 'objectNameSystem',
            'objectnametype' => 'objectNameType',
            'objectnamelanguage' => 'objectNameLanguage',
            'objectnamenote' => 'objectNameNote',
          }
          objectname_transforms = {
            'objectnamelanguage' => {'vocab' => 'languages'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectName',
            objectname_data,
            objectname_transforms,
            list_suffix: 'List'
          )
          #otherNumberList, otherNumber
          othernumber_data = {
            'numbervalue' => 'numberValue',
            'numbertype' => 'numberType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'otherNumber',
            othernumber_data,
            list_suffix: 'List',
            group_suffix: ''
          )
          #assocPeopleGroupList, assocPeopleGroup
          assocpeopledata = {
            'assocpeople' => 'assocPeople',
            'assocpeopletype' => 'assocPeopleType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPeople',
            assocpeopledata,
          )
          #objectComponentGroupList, objectComponentGroup
          objectcompdata = {
            'objectcomponentname' => 'objectComponentName',
            'objectcomponentinformation' => 'objectComponentInformation'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectComponent',
            objectcompdata,
          )
          #materialGroupList, materialGroup
          materialdata = {
            'materialname' => 'materialName',
            'material' => 'material',
            'materialcomponent' => 'materialComponent',
            'materialcomponentnote' => 'materialComponentNote',
            'materialsource' => 'materialSource'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'material',
            materialdata
          )
          #technicalAttributeGroupList, technicalAttributeGroup
          techattribute_data = {
            'technicalattribute' => 'technicalAttribute',
            'technicalattributemeasurementunit' => 'technicalAttributeMeasurementUnit',
            'technicalattributemeasurement' => 'technicalAttributeMeasurement'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'technicalAttribute',
            techattribute_data
          )
          #techniqueGroupList, techniqueGroup
          technique_data = {
            'technique' => 'technique',
            'techniquetype' => 'techniqueType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'technique',
            technique_data
          )
          #objectProductionPlaceGroupList, objectProductionPlaceGroup
          prodplace_data = {
            'objectproductionplace' => 'objectProductionPlace',
            'objectproductionplacerole' => 'objectProductionPlaceRole'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPlace',
            prodplace_data
          )
          #usageGroupList, usageGroup
          usage_data = {
            'usage' => 'usage',
            'usagenote' => 'usageNote'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'usage',
            usage_data
          )
          #contentEventNameGroupList, contentEventNameGroup
          contenteventname_data = {
            'contenteventname' => 'contentEventName',
            'contenteventnametype' => 'contentEventNameType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'contentEventName',
            contenteventname_data
          )
          #contentOtherGroupList, contentOtherGroup
          contentother_data = {
            'contentother' => 'contentOther',
            'contentothertype' => 'contentOtherType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'contentOther',
            contentother_data
          )
          #contentObjectGroupList, contentObjectGroup
          contentobject_data = {
            'contentobject' => 'contentObject',
            'contentobjecttype' => 'contentObjectType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'contentObject',
            contentobject_data
          )
        end
      end
    end
  end
end
