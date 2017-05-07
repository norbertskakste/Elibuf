defmodule ElibufTest do
  use ExUnit.Case
  doctest Elibuf

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "primitive generation" do
    my_double = Elibuf.Primitives.double()
    |> Elibuf.Primitives.Base.set_name("MyDoubleValue")

    my_string = Elibuf.Primitives.string()
    |> Elibuf.Primitives.Base.set_name("MyIntegerValue")
    |> Elibuf.Primitives.Base.set_default("MY_DEFAULT_VALUE")

    Elibuf.Primitives.Base.generate_list([my_double, my_string], :auto_order)
    assert my_double == my_double
  end

  test "valid types" do
    my_double = Elibuf.Primitives.double()
    |> Elibuf.Primitives.Base.set_name("MyDoubleValue")

    my_string = Elibuf.Primitives.string()
    |> Elibuf.Primitives.Base.set_order(2)
    |> Elibuf.Primitives.Base.set_name("MyIntegerValue")
    |> Elibuf.Primitives.Base.set_default("MY_DEFAULT_VALUE")
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
    my_enum_value = Elibuf.Primitives.Enum.generate(my_enum)

    my_enum_value_generated = Elibuf.Primitives.enum()
    |> Elibuf.Primitives.Base.set_order(1)
    |> Elibuf.Primitives.Base.set_name("MyEnumValue")
    |> Elibuf.Primitives.Base.set_enum_link(my_enum)
    |> Elibuf.Primitives.Base.generate


    Elibuf.Primitives.Enum.validate(my_enum)

    my_double = Elibuf.Primitives.double()
    |> Elibuf.Primitives.Base.set_order(2)
    |> Elibuf.Primitives.Base.set_name("MyDoubleValue")

    my_string = Elibuf.Primitives.string()
    |> Elibuf.Primitives.Base.set_order(3)
    |> Elibuf.Primitives.Base.set_name("MyStringValue")
    |> Elibuf.Primitives.Base.set_default("MY_DEFAULT_VALUE")

    primitive_list = Elibuf.Primitives.Base.generate_list([my_double, my_string])



    {:ok, file} = File.open "hello.proto", [:write]
    IO.binwrite file, my_enum_value
    IO.binwrite file, primitive_list
    File.close file

    message = Elibuf.Message.new_value("customMessage")
    |> Elibuf.Message.add_value(my_double)
    |> Elibuf.Message.add_value(my_string)

    another_message = Elibuf.Message.new_value("AnotherMessage")
    |> Elibuf.Message.add_value(my_double)

    custom_rpc = Elibuf.Services.Rpc.new_rpc("CustomRpc", message, message)

    another_custom_rpc = Elibuf.Services.Rpc.new_rpc("AnotherCustomRpc", message, another_message)

    custom_service = Elibuf.Services.new_service("CustomService")
    |> Elibuf.Services.add_rpc(custom_rpc)
    |> Elibuf.Services.add_rpc(another_custom_rpc)
    |> Elibuf.Services.add_rpc(custom_rpc)
    |> Elibuf.Services.generate(:indent)
    |> IO.puts

  end

  test "enum validation" do
    custom_value = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE")
    custom_value_two = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE_TWO")
    custom_value_three = Elibuf.Primitives.Enum.Value.new_value("CUSTOM_VALUE_THREE")

    Elibuf.Primitives.Enum.Value.generate_list([custom_value, custom_value_two, custom_value_three], :auto_order)
  end
end
