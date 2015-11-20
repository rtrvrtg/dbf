# encoding ascii-8bit

module DBF
  module Binary
    class Header < BinData::Record
      endian :little

      # The size of the header up to (but not including) the field descriptors
      FILE_HEADER_SIZE = 32

      uint8 :_version                           # byte offset 0
      struct :_last_update do                   # byte offset 1-3
        uint8 :year
        uint8 :month
        uint8 :day
      end
      uint32 :record_count                      # byte offset 4-7
      uint16 :header_length                     # byte offset 8-9
      uint16 :record_length                     # byte offset 10-11
      skip length: 2                            # byte offset 12-13
      uint8 :incomplete_transaction             # byte offset 14
      uint8 :_encrypted                         # byte offset 15
      skip :length => 12                        # byte offset 16-27
      uint8 :table_flags                        # byte offset 28
      uint8 :code_page_mark                     # byte offset 29
      skip :length => 2                         # byte offset 30-31 - Reserved
      array :fields, :type => :field, initial_length: :field_count

      def version
        @version ||= _version.to_i.to_s(16).rjust(2, '0')
      end

      def encoding_key
        @encoding_key ||= code_page_mark.to_i.to_s(16).rjust(2, '0')
      end

      def last_update
        Date.new _last_update.year, _last_update.month, _last_update.day
      end

      def encrypted
        !_encrypted.zero?
      end

      def field_count
        @field_count ||= ((header_length - FILE_HEADER_SIZE) / FILE_HEADER_SIZE)
      end

      def encoding
        @encoding ||= DBF::ENCODINGS[encoding_key]
      end
    end
  end
end
