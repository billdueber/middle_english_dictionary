require 'nokogiri'
require 'delegate'
require 'middle_english_dictionary/bib/ms_full'

module MiddleEnglishDictionary
  module Collection
    class MSNames < SimpleDelegator

      def initialize
        @ms = {}
        __setobj__(@ms)
      end

      def self.new_from_nokonode(nokonode)
        msnames = self.new
        nokonode.xpath('HYPERMED/MSLIB/MSFULL').each do |ms|
          code = ms.attr('MS')
          title = ms.text.strip
          msnames[code] = MiddleEnglishDictionary::Bib::MSFull.new(code, title)
        end
        msnames
      end

      def self.new_from_xml_file(filename)
        self.new_from_nokonode(Nokogiri::XML(File.open(filename, 'r:utf-8').read))
      end

    end
  end
end
