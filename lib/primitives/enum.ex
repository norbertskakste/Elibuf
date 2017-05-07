defmodule Elibuf.Primitives.Enum do
    defstruct name: nil, values: [], allow_alias: false

    defmodule Value do
        defstruct name: nil, order: nil, type: :enum

        def new_value(name, order) when is_bitstring(name) and is_integer(order) and order >= 0 do
            %__MODULE__{name: name, order: order}
        end

        def new_value(name) when is_bitstring(name) do
            %__MODULE__{name: name}
        end

        def set_name(%__MODULE__{} =  value, name_value) when is_bitstring(name_value) do
            %{value | name: name_value}
        end

        def has_name?(%__MODULE__{} = value) do
            is_bitstring(value.name)
        end

        def set_order(%__MODULE__{} = value, order_value) when is_integer(order_value) do
            %{value | order: order_value}
        end

        def has_order?(%__MODULE__{} = value) do
            is_integer(value.order) && value.order >= 0
        end

        def generate(%__MODULE__{} = value) do
            "\t" <> value.name <> " = " <> Integer.to_string(value.order) <> "; // " <> inspect(value)
        end

        def generate_list(valuelist, :auto_order) when is_list(valuelist) do
            generate_list(valuelist, 0)
        end

        def generate_list(valuelist, starting_point) when is_list(valuelist) and is_integer(starting_point) do
            valuelist
            |> Enum.reverse
            |> Enum.with_index(starting_point)
            |> Enum.map(fn value ->
                real_value = elem(value, 0)
                set_order(real_value, elem(value, 1))
            end)
            |> Enum.map(fn value ->
                generate(value)
            end)
        end

        def generate_list(valuelist) when is_list(valuelist) do
            valuelist
            |> Enum.sort(&(&1.order <= &2.order))
            |> Enum.map(fn value ->
                generate(value)
            end)
        end

        def validate(%__MODULE__{} = value) do
            validation_errors = %{}
            |> Map.put(:has_name, has_name?(value))
            |> Map.put(:has_order, has_order?(value))
            case validation_errors do
                %{has_name: false} -> {validation_errors, false}
                %{has_order: false} -> {validation_errors, false}
                _ -> {validation_errors, true}
            end
        end

        def valid?(%__MODULE__{} = value) do
            elem(validate(value), 1)
        end

    end

    def new_enum() do
        %__MODULE__{}
    end

    def new_enum(name) when is_bitstring(name) do
        %__MODULE__{name: name}
    end

    def new_enum(name, :allow_alias) when is_bitstring(name) do
        %__MODULE__{name: name, allow_alias: true}
    end

    def set_name(%__MODULE__{} = enum, name_value) when is_bitstring(name_value) do
        %{enum | name: name_value}
    end

    def has_name?(%__MODULE__{} = enum) do
        enum.name != nil && is_bitstring(enum.name)
    end

    def add_value(%__MODULE__{} = enum, %Value{} = enum_value) do
        %{enum | values: [enum_value | enum.values ]}
    end

    def remove_value(%__MODULE__{} = enum, value_name) when is_bitstring(value_name) do
        index = enum.values
        |> Enum.find_index(&(&1.name == value_name))
        new_list = enum.values
        |> List.delete_at(index)
        %{enum | values: new_list}
    end

    def remove_value(%__MODULE__{} = enum, %Value{} = enum_value) do
        new_list = enum.values
        |> List.delete(enum_value)
        %{enum | values: new_list}
    end

    def has_value?(%__MODULE__{} = enum, value_name) when is_bitstring(value_name) do
        enum.values
        |> Enum.find_value(&(&1.name == value_name))
    end

    def has_values?(%__MODULE__{} = enum) do
        length(enum.values) > 0
    end

    def set_alias(%__MODULE__{} = enum, alias_value) when is_boolean(alias_value) do
        %{enum | allow_alias: alias_value}
    end

    def toggle_alias(%__MODULE__{} = enum) do
        %{enum | allow_alias: !enum.allow_alias}
    end

    def allow_alias?(%__MODULE__{} = enum) do
        enum.allow_alias
    end

    def should_alias?(%__MODULE__{} = enum) do
        uniq_values = enum.values
        |> Enum.uniq_by(fn %{} = value -> value.order end)
        length(enum.values) == length(uniq_values)
    end

    def validate(%__MODULE__{} = enum) do 
        validation_errors = %{}
        |> Map.put(:has_name, has_name?(enum))
        |> Map.put(:has_values, has_values?(enum))
        |> Map.put(:aliasing_check, should_alias?(enum))

        case validation_errors do
            %{has_name: false} -> {validation_errors, false}
            %{has_values: false} -> {validation_errors, false}
            _ -> {validation_errors, true}
        end
    end

    def valid?(%__MODULE__{} = enum) do
        elem(validate(enum), 1)
    end
    
    def generate(%__MODULE__{} = enum) do
        return_value =
            case allow_alias?(enum) do
                true -> "enum " <> enum.name <> " {\n\toption allow_alias = true;\n"
                false -> "enum " <> enum.name <> " {\n"
            end

        values = enum.values
        |> Value.generate_list
        |> Enum.join("\n")

        return_value <> values <> "\n}\n"
    end

    def generate(%__MODULE__{} = enum, :auto_order) do
        return_value =
            case allow_alias?(enum) do
                true -> "enum " <> enum.name <> " { // " <> inspect(Map.delete(enum, :values)) <> "\n\toption allow_alias = true;\n"
                false -> "enum " <> enum.name <> " {\n"
            end
        values = enum.values
        |> Value.generate_list(:auto_order)
        |> Enum.join("\n")

        return_value <> values <> "\n}\n"
    end

end
