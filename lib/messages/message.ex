defmodule Elibuf.Message do
    defstruct name: nil, values: []

    alias Elibuf.Primitives

    def new_value(name_value) when is_bitstring(name_value) do
        %__MODULE__{name: name_value}
    end

    def set_name(%__MODULE__{} =  message, name_value) when is_bitstring(name_value) do
        %{message | name: name_value}
    end

    def has_name?(%__MODULE__{} = message) do
        is_bitstring(message.name)
    end

    def add_value(%__MODULE__{} = message, %Primitives.Base{} = base) do
        %{message | values: [base | message.values ]}
    end

    def generate(%__MODULE__{} = message) do
        return_value = "message " <> message.name <> " {\n"
        bases = Primitives.Base.generate_list(message.values, :auto_order, :indent)
        |> Enum.join("")

        return_value <> bases <> "}\n"
    end
end