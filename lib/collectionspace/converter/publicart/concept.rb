module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtConcept < Concept
        ::PublicArtConcept = CollectionSpace::Converter::PublicArt::PublicArtConcept
        def convert
          run do |xml|
            # TODO: implement
          end
        end
      end
    end
  end
end
