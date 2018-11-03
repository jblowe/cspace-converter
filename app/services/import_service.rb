class ImportService
  attr_reader :data, :object
  def initialize(data)
    @data   = data
    @object = nil
  end

  # "Person" => ["recby", "recfrom"]
  # "Concept" => [ ["objname", "objectname"] ]
  def add_authorities
    raise 'Data Object has not been created' unless object
    authorities = object.profile.fetch("Authorities", {})
    authorities_added = Set.new
    authorities.each do |authority, fields|
      fields.each do |field|
        authority_subtype = authority.downcase

        # if value pair first is the field and second is the specific authority (sub)type
        if field.respond_to? :each
          field, authority_subtype = field
        end

        add_authority(field, authority, authority_subtype, true, authorities_added)
      end
    end
  end

  def add_authority(identifier_field, type, subtype, from_procedure = false, added = [])
    term_display_name = object.object_data[identifier_field]
    return unless term_display_name

    service = CollectionSpace::Converter::Default.service type, subtype
    service_id = service[:id]

    # attempt to split field in case it is multi-valued
    term_display_name.split(object.delimiter).map(&:strip).each do |name|
      begin
        identifier = AuthCache::lookup_authority_term_id service_id, subtype, name
        # if we find this procedure authority in the cache skip it!
        next if identifier and from_procedure

        identifier = object.object_data.fetch("shortidentifier", identifier)
        identifier = CSIDF.short_identifier(name) unless identifier

        if CollectionSpaceObject.has_authority?(identifier)
          if from_procedure
            # don't duplicate or update
            next
          else
            converter     = Lookup.authority_class(object.converter_module, type)
            cspace_object = CollectionSpaceObject.where(category: 'Authority', identifier: identifier).first
            Task.generate_content(
              converter: converter,
              data: object.object_data,
              object: cspace_object,
            )
            cspace_object.save!
          end
        else
          # CREATE NEW CSPACE OBJECT
          object.add_authority(
            type: type,
            subtype: subtype,
            name: name,
            term_id: identifier,
            from_procedure: from_procedure
          ) unless added.include? name
          object.save!
        end
      rescue Exception => ex
        logger.error "#{ex.message}\n#{ex.backtrace}"
      end
    end
  end

  # TODO: refactor
  # "Acquisition" => { "identifier_field" => "acqid", "identifier" => "acqid", "title" => "acqid" }
  def add_procedures
    raise 'Data Object has not been created' unless object
    object.add_procedures
    object.save!
  end

  def add_relationships
    # TODO
  end

  def create_object
    @object = DataObject.new.from_json(JSON.generate(data))
    object.save!
  end

  def update_status(import_status:, import_message:)
    raise 'Data Object has not been created' unless object
    object.write_attributes(
      import_status: import_status,
      import_message: import_message
    )
    object.save!
  end

end
