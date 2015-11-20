module DBF
  module Binary
    class Field < BinData::Record
      endian :little

      string :name, length: 11, trim_padding: true, pad_byte: 0
      string :_field_type, length:  1
      uint32 :record_offset
      uint8 :field_length
      uint8 :decimal
      uint8 :field_flags
      uint32 :autoincrement_next_value
      uint8 :autoincrement_step_value
      skip length: 8

      def clean_name
        name.value.strip
      end

      def field_type
        _field_type.upcase
      end

      def valid?
        clean_name.empty?
      end
    end
  end
end
