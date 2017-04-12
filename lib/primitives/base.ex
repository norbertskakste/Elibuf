defmodule Elibuf.Primitives.Base do
        @moduledoc """
        Base primitive struct [all primitives 'build' on top of Base struct]
        *  :type = Name of the type               [atom]
        *  :repeating = is it repeating (array)   [boolean]
        *  :default = default value
        """

        @allowed_types ~w(double float int32 int64 uint32
                      uint64 sint32 sint64 fixed32
                      fixed64 sfixed32 sfixed64
                      bool string bytes enum)a

        defstruct type: nil, repeating: false, default: nil, order: nil, name: nil

        @doc """
        Returns boolean if type is repeating

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.repeating?(my_double) # returns false
        """
        def repeating?(%__MODULE__{} = base) do
            base.repeating
        end

        @doc """
        Sets the repeating value

        Example:
            my_value = Elibuf.Primitives.int32()
            Elibuf.Primitives.Base.set_repeating(my_value, true)
            # my_value.repeating is TRUE
        """
        def set_repeating(%__MODULE__{} = base, repeating_value) when is_boolean(repeating_value) do
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
        def toggle_repeating(%__MODULE__{} = base) do
            %{base | repeating: !base.repeating}
        end

        @doc """
        Sets the default value for type

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.set_default(my_double, 10.0)
            # my_double.default is 10.0
        """
        def set_default(%__MODULE__{} = base, default_value) do
            %{base | default: default_value}
        end

        def has_default?(%__MODULE__{} = base) do
            is_integer(base.default)
        end

        @doc """
        Sets the order value

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.set_order(my_double, 1)
            # my_double.order is 1
        """
        def set_order(%__MODULE__{} = base, order_value) when is_integer(order_value) do
            %{base | order: order_value}
        end

        @doc """
        Returns true if order is set (false otherwise)
        """
        def has_order?(%__MODULE__{} = base) do
            is_number(base.order)
        end

        @doc """
        Sets the name of the value

        Example:
            my_double = Elibuf.Primitives.double()
            Elibuf.Primitives.Base.set_name(my_double, "MyDouble")
            # my_double.name is "MyDouble"
        """
        def set_name(%__MODULE__{} = base, name_value) when is_bitstring(name_value) do
            %{base | name: name_value}
        end

        @doc """
        Returns true if name is set (false otherwise)
        """
        def has_name?(%__MODULE__{} = base) do
            is_bitstring(base.name)
        end

        @doc """
        Checks if type is supported, in-case user changes it.
        """
        def valid_type(%__MODULE__{} = base) do
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
        def generate(%__MODULE__{} = base) do
            opt_or_rep = 
                case repeating?(base) do
                    true -> "repeating"
                    false -> "optional"
                end
            case has_default?(base) do
                true -> opt_or_rep <> " " <> Atom.to_string(base.type) <> " " <> base.name <> " = " <> Integer.to_string(base.order) <> " [default = " <> base.default <> "]; // " <> inspect(base) <>"\n"
                false -> opt_or_rep <> " " <> Atom.to_string(base.type) <> " " <> base.name <> " = " <> Integer.to_string(base.order) <> "; // " <> inspect(base) <>"\n"
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
        def validate(%__MODULE__{} = base) do
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
        Validates type without checking for valid_type
        """
        def validate(%__MODULE__{} = base, :no_type_check) do
            validation_errors = %{}
            |> Map.put(:has_order, has_order?(base))
            |> Map.put(:has_name, has_name?(base))
            case validation_errors do
                %{has_order: false} -> {validation_errors, false}
                %{has_name: false} -> {validation_errors, false}
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
        Shorthand function for validate(%__MODULE__{})
        """
        def valid?(%__MODULE__{} = base) do
            elem(validate(base), 1)
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

        def generate_list(baselist, :auto_order) when is_list(baselist) do
            generate_list(baselist, 1)
        end

        def generate_list(baselist, starting_point) when is_list(baselist) and is_integer(starting_point) and starting_point >= 1 do
            baselist
            |> Enum.with_index(starting_point)
            |> Enum.map(fn base ->
                real_base = elem(base, 0)
                set_order(real_base, elem(base, 1))
            end)
            |> Enum.map(fn base ->
                generate(base)
            end)
        end

    end