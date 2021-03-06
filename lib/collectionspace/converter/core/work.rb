module CollectionSpace
  module Converter
    module Core
      class CoreWork < Work
        ::CoreWork = CollectionSpace::Converter::Core::CoreWork
        def convert
          run do |xml|
            CoreWork.map(xml, attributes, config)
          end
        end
        def self.map(xml, attributes, config)
          pairs = {
            'worktype' => 'workType',
            'workhistorynote' => 'workHistoryNote'
          }
          pairs_transforms = {
            'worktype' => {'vocab' => 'worktype'}
          } 
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          #workDateGroupList, workDateGroup
          CSXML::Helpers.add_date_group_list(xml, 'workDate', attributes["workdategroup"])
          CSXML.add xml, 'shortIdentifier', config[:identifier] 
          #workTermGroupList, workTermGroup
          workterm_data = {
	    "termdisplayname" => "termDisplayName",
	    "termlanguage" => "termLanguage",
	    "termname" => "termName",
	    "termprefforlang" => "termPrefForLang",
	    "termqualifier" => "termQualifier",
	    "termsource" => "termSource",
	    "termsourceid" => "termSourceID",
	    "termsourcedetail" => "termSourceDetail",
	    "termsourcenote" => "termSourceNote",
 	    "termstatus" => "termStatus",
	    "termtype" => "termType",
            "termflag" => "termFlag",
	  }
          workterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'termflag' => {'vocab' => 'worktermflag'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'workTerm',
            workterm_data,
            workterm_transforms
          )
          #creatorGroupList, creatorGroup
          creator_data = {
            "creatororganization" => "creator",
            "creatorperson" => "creator",
            "creatortype" => "creatorType"
          }
          creator_transforms = {
            'creatorperson' => {'authority' => ['personauthorities', 'person']},
            'creatororganization' => {'authority' => ['orgauthorities', 'organization']},
            'creatortype' => {'vocab' => 'workcreatortype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'creator',
            creator_data,
            creator_transforms
          )
          #publisherGroupList, publisherGroup
          publisher_data = {
            "publisherorganization" => "publisher",
            "publisherperson" => "publisher",
            "publishertype" => "publisherType"
          }
          publisher_transforms = {
            'publisherperson' => {'authority' => ['personauthorities', 'person']},
            'publisherorganization' => {'authority' => ['orgauthorities', 'organization']},
            'publishertype' => {'vocab' => 'workpublishertype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'publisher',
            publisher_data,
            publisher_transforms
          )
          #addrGroupList, addrGroup
          address_data = {
            'addresstype' => 'addressType',
            'addressplace1' => 'addressPlace1',
            'addressplace2' => 'addressPlace2',
            'addressmunicipality' => 'addressMunicipality',
            'addressstateorprovince' => 'addressStateOrProvince',
            'addresspostcode' => 'addressPostCode',
            'addresscountry' => 'addressCountry'
          }
          address_transforms = {
            'addresscountry' => {'authority' => ['placeauthorities', 'place']},
            'addressmunicipality' => {'authority' => ['placeauthorities', 'place']},
            'addressstateorprovince' => {'authority' => ['placeauthorities', 'place']},
            'addresstype' => {'vocab' => 'addresstype'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'addr',
            address_data,
            address_transforms
          )
        end
      end
    end
  end
end
