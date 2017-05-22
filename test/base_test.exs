defmodule ElibufTest.Base do
    use ExUnit.Case

    alias Elibuf.Primitives.Base
    alias Elibuf.Primitives

    test "Primitive creation (check ? methods)" do
        test_primitive = Primitives.int32()

        assert Base.repeating?(test_primitive) == false
        assert Base.has_default?(test_primitive) == false
        assert Base.has_name?(test_primitive) == false
        assert Base.has_order?(test_primitive) == false

        assert Base.valid?(test_primitive) == false
    end

    test "Primitive creation (valid primitive)" do
        test_primitive = Primitives.int32()
        |> Base.set_name("test_primitive")
        |> Base.set_order(1)
        |> Base.set_repeating(false)
        |> Base.set_default(nil)

        assert Base.valid?(test_primitive) == true
    end

    test "Primitive creation (invalid primitive)" do
        test_primitive = Primitives.int32()
        |> Base.set_name("test_primitive")
        |> Base.set_repeating(false)
        |> Base.set_default(nil)

        assert Base.valid?(test_primitive) == false
    end

    test "Primitive type test (valid)" do
      test_int32 = %Primitives.Base{type: :int32}

      assert Base.valid_type(test_int32) == true
    end

    test "Primitive type test (invalid)" do
      test_false_primitive = %Primitives.Base{type: :abc}

      assert Base.valid_type(test_false_primitive) == false
    end

    test "Primitive generation" do
        int32 = Primitives.int32()
        |> Base.set_order(1)
        |> Base.set_name("TestPrimitive")
        |> Base.set_repeating(true)

        generated_value = Primitives.Base.generate(int32)
        assert generated_value == ~s(repeated int32 TestPrimitive = 1; // %Elibuf.Primitives.Base{default: nil, imports: [], name: "TestPrimitive", order: 1, repeating: true, type: :int32}\n)

        value_without_repeating = int32
        |> Base.set_repeating(false)

        generated_value_without_repeating = Primitives.Base.generate(value_without_repeating)
        assert generated_value_without_repeating == ~s(int32 TestPrimitive = 1; // %Elibuf.Primitives.Base{default: nil, imports: [], name: "TestPrimitive", order: 1, repeating: false, type: :int32}\n)
    end
end
