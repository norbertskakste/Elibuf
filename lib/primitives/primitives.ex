defmodule Elibuf.Primitives do

    alias Elibuf.Primitives.Base

    @moduledoc """
    Protobuf primitive types
    *  Double, Float
    *  Int32, Int64
    *  Uint32, Uint64
    *  Sint32, Sint64
    *  Fixed32, Fixed64
    *  Sfixed32, Sfixed64
    *  Bool
    *  String
    *  Bytes
    *  Enum
    """

    @doc """
    Double type
    """
    def double() do
        %Base{type: :double, repeating: false, default: nil}
    end

    @doc """
    Float type
    """
    def float() do
        %Base{type: :float, repeating: false, default: nil}
    end

    @doc """
    Int32 type
    *  Notes: Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead.
    """
    def int32() do
        %Base{type: :int32, repeating: false, default: nil}
    end

    @doc """
    Int64 type
    *  Notes: Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead.
    """
    def int64() do
        %Base{type: :int64, repeating: false, default: nil}
    end

    @doc """
    Uint32 type
    *  Notes: Uses variable-length encoding.
    """
    def uint32() do
        %Base{type: :uint32, repeating: false, default: nil}
    end

    @doc """
    Uint64 type
    *  Notes: Uses variable-length encoding.
    """
    def uint64() do
        %Base{type: :uint64, repeating: false, default: nil}
    end

    @doc """
    Sint32 type
    *  Notes: Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s.
    """
    def sint32() do
        %Base{type: :sint32, repeating: false, default: nil}
    end

    @doc """
    Sin64 type
    *  Notes: Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s.
    """
    def sint64() do
        %Base{type: :sint64, repeating: false, default: nil}
    end

    @doc """
    Fixed32 type
    *  Notes: Always four bytes. More efficient than uint32 if values are often greater than 2^28.
    """
    def fixed32() do
        %Base{type: :fixed32, repeating: false, default: nil}
    end

    @doc """
    Fixed64 type
    *  Notes: Always eight bytes. More efficient than uint64 if values are often greater than 2^56.
    """
    def fixed64() do
        %Base{type: :fixed64, repeating: false, default: nil}
    end

    @doc """
    Sfixed32 type
    *  Notes: Always four bytes.
    """
    def sfixed32() do
        %Base{type: :sfixed32, repeating: false, default: nil}
    end

    @doc """
    Sfixed64 type
    *  Notes: Always eight bytes.
    """
    def sfixed64() do
        %Base{type: :sfixed64, repeating: false, default: nil}
    end

    @doc """
    Bool type
    """
    def bool() do
        %Base{type: :bool, repeating: false, default: nil}
    end

    @doc """
    String type
    *  Notes: A string must always contain UTF-8 encoded or 7-bit ASCII text.
    """
    def string() do
        %Base{type: :string, repeating: false, default: nil}
    end
    
    @doc """
    Bytes type
    *  Notes: 	May contain any arbitrary sequence of bytes.
    """
    def bytes() do
        %Base{type: :bytes, repeating: false, default: nil}
    end

    @doc """
    Enum type
    """
    def enum() do
      %Base{type: :enum, repeating: false, default: nil}
    end

    @doc """
    Timestamp type
    """
    def timestamp()do
      %Base{type: :timestamp, repeating: false, default: nil}
    end

    @doc """
    Duration type
    """
    def duration() do
      %Base{type: :duration, repeating: false, default: nil}
    end

 end
