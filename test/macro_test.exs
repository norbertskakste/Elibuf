defmodule ElibufMacroTest do
 # use ExUnit.Case
@moduledoc"""
  test "message macro" do
    custom_enum = enum "Gender" do
      enum :male
      enum :female
    end

    custom_message = message "CustomMessage" do
      primitive :name, :string
      primitive :surname, :string
      primitive :age, :int32, default: 0.0
      primitive :photo, :bytes
      primitive :gender, enum: custom_enum, default: custom_enum.female
    end

    custom_message_two = message "CustomMessageTwo" do
      primitive :title, :string
      message_type :person, message: custom_message
      primitive :any, :description
      t_map :friends, key: string, value: custom_message
      reserved 5
    end

    custom_service = service "CustomService" do
      rpc :myRpc, request: custom_message, return: custom_message
    end

    protobuf = protobuf "CustomProtobuf" do
      enum custom_enum
      message custom_message
      service custom_service
    end

    protobuf
    |> Elibuf.auto_order
    |> Elibuf.validate
    |> Elibuf.generate
  end
"""
end

defmodule Unless do
  def fun_unless(clause, do: expression) do
    if(!clause, do: expression)
  end

  def macro_unless(clause, do: expression) do
    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end

  defmacro unless(clause, do: expression) do
    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end

  def value(type, name, params \\ []) when is_bitstring(name) do
    value = value_create(type, name, params)
  end

  defp message(name, types) do
    message = Elibuf.Message.new_value(name)
    |> Elibuf.Message.add_values(types)
  end

  defp value_create(type, name, params) when is_bitstring(name) do
    case type do
      :enum ->
        Elibuf.Primitives.Enum.Value.new_value(name)
      :primitive ->
        primitive = apply(Elibuf.Primitives, params[:type], [])
        primitive
        |> Elibuf.Primitives.Base.set_name(name)
        |> Elibuf.Primitives.Base.set_repeating(params[:repeating])
        |> Elibuf.Primitives.Base.set_order(params[:order])
      _ -> false
    end
  end

  def run do

  end

end

Unless.run
