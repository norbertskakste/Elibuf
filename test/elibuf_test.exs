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

    my_integer = Elibuf.Primitives.double()
    |> Elibuf.Primitives.Base.set_order(2)
    |> Elibuf.Primitives.Base.set_name("MyIntegerValue")

    Elibuf.Primitives.Base.generate_list([my_double, my_integer], :auto_order)
    |> IO.inspect

    assert my_double == my_double
  end
end
