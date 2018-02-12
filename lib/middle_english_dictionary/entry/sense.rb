require 'middle_english_dictionary/entry/constructors'
require_relative 'eg'
require 'representable/json'

module MiddleEnglishDictionary
  class Entry
    class Sense
      extend Entry::Constructors

      attr_accessor :xml, :definition_xml, :definition_text,
                    :discipline_usages, :grammatical_usages,
                    :egs, :sense_number, :entry_id


      def self.new_from_nokonode(nokonode, entry_id: nil)

        sense                 = self.new
        sense.xml             = nokonode.to_xml
        sense.definition_xml  = nokonode.at('DEF').to_xml
        sense.definition_text = nokonode.at('DEF').text
        sense.sense_number    = (nokonode.attr('N') || 0).to_i

        sense.entry_id = entry_id

        sense.grammatical_usages = sense.get_grammatical_usages(nokonode)
        sense.discipline_usages  = sense.get_discipline_usages(nokonode)

        sense.egs = nokonode.css('EG').map {|eg| EG.new_from_nokonode(eg, entry_id: entry_id)}

        sense
      end

      def get_discipline_usages(nokonode)
        nokonode.xpath('//DEF/USG[@TYPE="FIELD"]').map {|n| n.attr('EXPAN')}.map(&:capitalize).uniq
      end

      def get_grammatical_usages(nokonode)
        nokonode.xpath('//DEF/USG[@TYPE="GRAM"]').map(&:text).map(&:strip).uniq
      end

    end

    class SenseRepresenter < Representable::Decorator
      include Representable::JSON

      property :entry_id
      property :definition_xml
      property :definition_text
      property :sense_number
      property :grammatical_usages
      property :discipline_usages
      collection :egs, decorator: EGRepresenter, class: EG
    end

  end
end