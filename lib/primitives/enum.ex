defmodule Elibuf.Primitives.Enum do
    defstruct name: :none, values: :none, default: :none, allow_alias: false

    defmodule Value do
        defstruct name: :none, order: :none
    end

    def new_enum() do
        return %__MODULE__{}
    end

    def set_name(%__MODULE__{} = enum, name_value) when is_bitstring(name_value) do
        %{enum | name: name_value}
    end

    def has_name?(%__MODULE__{} = enum) do
        enum.name != :none && is_bitstring(enum.name)
    end

    def add_value(%__MODULE__{} = enum, %Value{} = enum_value) do
        %{enum | values: [values | enum_value ]}
    end

    def remove_value(%__MODULE__{} = enum, value_name) when is_bitstring(value_name) do

    end

    def has_value?(%__MODULE__{} = enum, value_name) when is_bitstring(value_name) do
        
    end

    def has_values?(%__MODULE__{} = enum) do
        length(enum.values) > 0
    end

    def set_alias(%__MODULE__{} = enum, alias_value) when is_boolean(alias_value) do
        %{enum | allow_alias: alias_value}
    end

    def toggle_alias(%__MODULE__{} = enum) do
        %{enum | allows_alias: !allow_alias}
    end

    def validate_alias(%__MODULE__{} = enum) do

    end

    def set_default(%__MODULE__{} = enum, default_value) when is_bitstring(default_value) do
        %{enum | default: default_value}
    end

    def has_default?(%__MODULE__{} = enum) do
        enum.default != :none
    end

end