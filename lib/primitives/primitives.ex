defmodule Elibuf.Primitives do
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
    """

    defmodule Base do
        @moduledoc """
        Base primitive struct [all primitives 'build' on top of Base struct]
        *  :type = Name of the type               [atom]
        *  :repeating = is it repeating (array)   [boolean]
        *  :required = is it required             [boolean]
        *  :default = default value
        """

        @allowed_types ~w(double float int32 int64 uint32
                      uint64 sint32 sint64 fixed32
                      fixed64 sfixed32 sfixed64
                      bool string bytes)a

        defstruct type: :none, repeating: false, required: false, default: :none, order: :none, name: :none

        @doc """
        Returns boolean if type is repeating

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.repeating?(my_double) # returns false
        """
        def repeating?(%Base{} = base) do
            base.repeating
        end

        @doc """
        Sets the repeating value

        Example:
            my_value = Elibuf.Primitives.int32()
            Elibuf.Primitives.Base.set_repeating(my_value, true)
            # my_value.repeating is TRUE
        """
        def set_repeating(%Base{} = base, repeating_value) when is_boolean(repeating_value) do
            %{base | repeating: repeating_value}
        end

        @doc """
        Toggles (flips) the repeating value

        Example:
            my_value = Elibuf.Primitives.int32()
            Elibuf.Primitives.Base.set_repeating(my_value, true)
            # my_value.repeating is TRUE
            Elibuf.Primitives.Base.toggle_repeating(my_value)
            # my_value.repeating is FALSE
        """
        def toggle_repeating(%Base{} = base) do
            %{base | repeating: !base.repeating}
        end

        @doc """
        Returns boolean if type is required

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.required?(my_double) # returns false
        """
        def required?(%Base{} = base) do
            base.required
        end

        @doc """
        Sets the required value

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.set_required(my_double, true)
            # my_double.required is TRUE
        """
        def set_required(%Base{} = base, required_value) when is_boolean(required_value) do
            %{base | required: required_value}
        end

        @doc """
        Toggles (flips) the required value

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.set_required(my_double, false)
            Elibuf.Primitives.Base.toggle_required(my_double)
            # my_double.required is TRUE
        """
        def toggle_required(%Base{} = base) do
            %{base | required: !base.required}
        end

        @doc """
        Sets the default value for type

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.set_default(my_double, 10.0)
            # my_double.default is 10.0
        """
        def set_default(%Base{} = base, default_value) do
            %{base | default: default_value}
        end

        def has_default?(%Base{} = base) do
            base.default != :none
        end

        @doc """
        Sets the order value

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.set_order(my_double, 1)
            # my_double.order is 1
        """
        def set_order(%Base{} = base, order_value) when is_integer(order_value) do
            %{base | order: order_value}
        end

        @doc """
        Returns true if order is set (false otherwise)
        """
        def has_order?(%Base{} = base) do
            base.order != :none && is_number(base.order)
        end

        @doc """
        Sets the name of the value

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.set_name(my_double, "MyDouble")
            # my_double.name is "MyDouble"
        """
        def set_name(%Base{} = base, name_value) when is_bitstring(name_value) do
            %{base | name: name_value}
        end

        @doc """
        Returns true if name is set (false otherwise)
        """
        def has_name?(%Base{} = base) do
            base.name != :none && is_bitstring(base.name)
        end

        def valid_type(%Base{} = base) do
            @allowed_types
            |> Enum.member?(base.type)
        end

        @doc """
        Generates the definition of type

        Example:
            my_double = Elibuf.Primitives.double()
            |> Elibuf.Primitives.Base.set_order(1)
            |> Elibuf.Primitives.Base.set_name("MyDoubleValue")
            |> Elibuf.Primitives.Base.generate
            # Outputs optional double MyDoubleValue = 1;
        """
        def generate(%Base{} = base) do
            opt_or_rep = 
                case repeating?(base) do
                    true -> "repeating"
                    false -> "optional"
                end
            case has_default?(base) do
                true -> opt_or_rep <> " " <> Atom.to_string(base.type) <> " " <> base.name <> " = " <> Integer.to_string(base.order) <> " [default = " <> base.default <> "];"
                false -> opt_or_rep <> " " <> Atom.to_string(base.type) <> " " <> base.name <> " = " <> Integer.to_string(base.order) <> ";"
            end
        end

        @doc """
        Validates type
        *  checks for order (has_order?)
        *  checks for name (has_name?)
        *  checks the type (valid_type)

        Example:
            my_string = Elibuf.Primitives.string()
            |> Elibuf.Primitives.Base.set_order(2)
            |> Elibuf.Primitives.Base.set_name("MyIntegerValue")
            |> Elibuf.Primitives.Base.set_default("MY_DEFAULT_VALUE")
            |> Elibuf.Primitives.Base.validate
            |> IO.inspect
            # should return {%{has_name: true, has_order: true, valid_type: true}, true} 
        """
        def validate(%Base{} = base) do
            validation_errors = %{}
            |> Map.put(:has_order, has_order?(base))
            |> Map.put(:has_name, has_name?(base))
            |> Map.put(:valid_type, valid_type(base))
            case validation_errors do
                %{has_order: false} -> {validation_errors, false}
                %{has_name: false} -> {validation_errors, false}
                %{valid_type: false} -> {validation_errors, false}
                _ -> {validation_errors, true}
            end
        end

        @doc """
        Validates multiple types
        """
        def validate_list(baselist) when is_list(baselist) do
            baselist
            |> Enum.map(fn base ->
                validate(base)
            end)
        end

        @doc """
        Shorthand function for validate(%Base{})
        """
        def valid?(%Base{} = base) do
            validate(base)
        end

        @doc """
        Generates definition from list of bases
        """
        def generate_list(baselist) when is_list(baselist) do
            baselist
            |> Enum.map(fn base ->
                generate(base)
            end)
        end

    end

    @doc """
    Double type
    """
    def double() do
        %Base{type: :double, repeating: false, required: false, default: :none}
    end

    @doc """
    Float type
    """
    def float() do
        %Base{type: :float, repeating: false, required: false, default: :none}
    end

    @doc """
    Int32 type
    *  Notes: Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead.
    """
    def int32() do
        %Base{type: :int32, repeating: false, required: false, default: :none}
    end

    @doc """
    Int64 type
    *  Notes: Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead.
    """
    def int64() do
        %Base{type: :int64, repeating: false, required: false, default: :none}
    end

    @doc """
    Uint32 type
    *  Notes: Uses variable-length encoding.
    """
    def uint32() do
        %Base{type: :uint32, repeating: false, required: false, default: :none}
    end

    @doc """
    Uint64 type
    *  Notes: Uses variable-length encoding.
    """
    def uint64() do
        %Base{type: :uint64, repeating: false, required: false, default: :none}
    end

    @doc """
    Sint32 type
    *  Notes: Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s.
    """
    def sint32() do
        %Base{type: :sint32, repeating: false, required: false, default: :none}
    end

    @doc """
    Sin64 type
    *  Notes: Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s.
    """
    def sint64() do
        %Base{type: :sint64, repeating: false, required: false, default: :none}
    end

    @doc """
    Fixed32 type
    *  Notes: Always four bytes. More efficient than uint32 if values are often greater than 2^28.
    """
    def fixed32() do
        %Base{type: :fixed32, repeating: false, required: false, default: :none}
    end

    @doc """
    Fixed64 type
    *  Notes: Always eight bytes. More efficient than uint64 if values are often greater than 2^56.
    """
    def fixed64() do
        %Base{type: :fixed64, repeating: false, required: false, default: :none}
    end

    @doc """
    Sfixed32 type
    *  Notes: Always four bytes.
    """
    def sfixed32() do
        %Base{type: :sfixed32, repeating: false, required: false, default: :none}
    end

    @doc """
    Sfixed64 type
    *  Notes: Always eight bytes.
    """
    def sfixed64() do
        %Base{type: :sfixed64, repeating: false, required: false, default: :none}
    end

    @doc """
    Bool type
    """
    def bool() do
        %Base{type: :bool, repeating: false, required: false, default: :none}
    end

    @doc """
    String type
    *  Notes: A string must always contain UTF-8 encoded or 7-bit ASCII text.
    """
    def string() do
        %Base{type: :string, repeating: false, required: false, default: :none}
    end
    
    @doc """
    Bytes type
    *  Notes: 	May contain any arbitrary sequence of bytes.
    """
    def bytes() do
        %Base{type: :bytes, repeating: false, required: false, default: :none}
    end

end