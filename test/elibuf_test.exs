defmodule ElibufTest do
  use ExUnit.Case
  doctest Elibuf

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "primitive generation" do
    my_double = Elibuf.Primitives.double()
    |> Elibuf.Primitives.Base.set_order(1)
    |> Elibuf.Primitives.Base.set_name("MyDoubleValue")

    my_string = Elibuf.Primitives.string()
    |> Elibuf.Primitives.Base.set_order(2)
    |> Elibuf.Primitives.Base.set_name("MyIntegerValue")
    |> Elibuf.Primitives.Base.set_default("MY_DEFAULT_VALUE")

    Elibuf.Primitives.Base.generate_list([my_double, my_string])

    assert my_double == my_double
  end

  test "valid types" do
    my_double = Elibuf.Primitives.double()
    |> Elibuf.Primitives.Base.set_name("MyDoubleValue")

    my_string = Elibuf.Primitives.string()
    |> Elibuf.Primitives.Base.set_order(2)
    |> Elibuf.Primitives.Base.set_name("MyIntegerValue")
    |> Elibuf.Primitives.Base.set_default("MY_DEFAULT_VALUE")

    validatons = Elibuf.Primitives.Base.validate_list([my_double, my_string])
  end

  test "enums" do
    custom_value = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE", 0)
    custom_value_two = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE_TWO", 1)
    custom_value_three = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE_THREE", 2)
    my_enum = Elibuf.Primitives.Enum.new_enum
    |> Elibuf.Primitives.Enum.set_name("TestEnum")
    |> Elibuf.Primitives.Enum.toggle_alias
    |> Elibuf.Primitives.Enum.add_value(custom_value)
    |> Elibuf.Primitives.Enum.add_value(custom_value_two)
    |> Elibuf.Primitives.Enum.add_value(custom_value_three)
    |> Elibuf.Primitives.Enum.remove_value(custom_value_three)
    |> Elibuf.Primitives.Enum.generate
    
    {:ok, file} = File.open "hello", [:write]
    IO.binwrite file, my_enum
    File.close file

  end

  test "enum validation" do
    custom_value = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE", 0)
    custom_value_two = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE_TWO", 1)
    custom_value_three = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE_THREE", 2)
    my_enum = Elibuf.Primitives.Enum.new_enum
    |> Elibuf.Primitives.Enum.toggle_alias
    |> Elibuf.Primitives.Enum.validate
    |> IO.inspect
  end
end
