module MiddleEnglishDictionary
  class Bib
    class MSFull
      attr_accessor :code, :title

      def initialize(code = nil, title = nil)
        @code = code
        @title  = title
      end
    end

  end
end