defmodule Elibuf.Primitives do
    @moduledoc """
    Protobuf primitive types
    #------
      Double, Float
    #------
      Int32, Int64
    #------
      Uint32, Uint64
    #------
      Sint32, Sint64
    #------
      Fixed32, Fixed64
    #------
      Sfixed32, Sfixed64
    #------
      Bool
    #------
      String
    #------
      Bytes
    """

    defmodule Base do
        @moduledoc """
        Base primitive struct [all primitives 'build' on top of Base struct]

        :type = Name of the type               [atom]
        :repeating = is it repeating (array)   [bool]
        :required = is it required             [bool]
        :default = default value
        """

        defstruct type: :none, repeating: false, required: false, default: :none

        @doc """
        Returns boolean if type is repeating

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.repeating?(my_double) // returns false
        """
        def repeating?(%Base{} = base) do
            base.repeating
        end

        @doc """
        Returns boolean if type is required

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.required?(my_double) // returns false
        """
        def required?(%Base{} = base) do
            base.required
        end

        @doc """
        Sets the default value for type
        """
        def set_default(%Base{} = base, default_value) do
            base.default = default_value
        end

    end

    @doc """
    Double type
    """
    def double() do
        %Base{type_name: :double, repeating: false, required: false, default: :none}
    end

    @doc """
    Float type
    """
    def float() do
        %Base{type_name: :float, repeating: false, required: false, default: :none}
    end

    @doc """
    Int32 type
    Notes: Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead.
    """
    def int32() do
        %Base{type_name: :int32, repeating: false, required: false, default: :none}
    end

    @doc """
    Int64 type
    Notes: Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead.
    """
    def int64() do
        %Base{type_name: :int64, repeating: false, required: false, default: :none}
    end

    @doc """
    Uint32 type
    Notes: Uses variable-length encoding.
    """
    def uint32() do
        %Base{type_name: :uint32, repeating: false, required: false, default: :none}
    end

    @doc """
    Uint64 type
    Notes: Uses variable-length encoding.
    """
    def uint64() do
        %Base{type_name: :uint64, repeating: false, required: false, default: :none}
    end

    @doc """
    Sint32 type
    Notes: Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s.
    """
    def sint32() do
        %Base{type_name: :sint32, repeating: false, required: false, default: :none}
    end

    @doc """
    Sin64 type
    Notes: Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s.
    """
    def sint64() do
        %Base{type_name: :sint64, repeating: false, required: false, default: :none}
    end

    @doc """
    Fixed32 type
    Notes: Always four bytes. More efficient than uint32 if values are often greater than 2^28.
    """
    def fixed32() do
        %Base{type_name: :fixed32, repeating: false, required: false, default: :none}
    end

    @doc """
    Fixed64 type
    Notes: Always eight bytes. More efficient than uint64 if values are often greater than 2^56.
    """
    def fixed64() do
        %Base{type_name: :fixed64, repeating: false, required: false, default: :none}
    end

    @doc """
    Sfixed32 type
    Notes: Always four bytes.
    """
    def sfixed32() do
        %Base{type_name: :sfixed32, repeating: false, required: false, default: :none}
    end

    @doc """
    Sfixed64 type
    Notes: Always eight bytes.
    """
    def sfixed64() do
        %Base{type_name: :sfixed64, repeating: false, required: false, default: :none}
    end

    @doc """
    Bool type
    """
    def bool() do
        %Base{type_name: :bool, repeating: false, required: false, default: :none}
    end

    @doc """
    String type
    Notes: A string must always contain UTF-8 encoded or 7-bit ASCII text.
    """
    def string() do
        %Base{type_name: :string, repeating: false, required: false, default: :none}
    end
    
    @doc """
    Bytes type
    Notes: 	May contain any arbitrary sequence of bytes.
    """
    def bytes() do
        %Base{type_name: :bytes, repeating: false, required: false, default: :none}
    end

end