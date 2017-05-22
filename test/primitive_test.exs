defmodule ElibufTest.Primitives do
    use ExUnit.Case

    alias Elibuf.Primitives

    defp check_repeating(%Primitives.Base{} = primitive) do
      assert primitive.repeating == false
    end

    defp check_default(%Primitives.Base{} = primitive) do
      assert primitive.default == nil
    end

    defp check_primitive(%Primitives.Base{} = primitive, type) when is_atom(type) do
      check_repeating(primitive)
      check_default(primitive)
      assert primitive.type == type
    end

    test "Floating point values" do
        Primitives.double()
        |> check_primitive(:double)
        Primitives.float()
        |> check_primitive(:float)
    end

    test "Signed values" do
        ## Basic signed values
        Primitives.int32()
        |> check_primitive(:int32)
        Primitives.int64()
        |> check_primitive(:int64)

        # Variable-length encoded signed values
        Primitives.sint32()
        |> check_primitive(:sint32)
        Primitives.sint64()
        |> check_primitive(:sint64)

        # Fixed-length encoded signed values
        Primitives.sfixed32()
        |> check_primitive(:sfixed32)
        Primitives.sfixed64()
        |> check_primitive(:sfixed64)
    end

    test "Unsigned values" do
        # Basic unsigned values
        Primitives.uint32()
        |> check_primitive(:uint32)
        Primitives.uint64()
        |> check_primitive(:uint64)

        # Fixed-length encoded unsigned values
        Primitives.fixed32()
        |> check_primitive(:fixed32)
        Primitives.fixed64()
        |> check_primitive(:fixed64)
    end

    test "Bool value" do
      Primitives.bool()
      |> check_primitive(:bool)
    end

    test "String value" do
      Primitives.string()
      |> check_primitive(:string)
    end

    test "Bytes value" do
      Primitives.bytes()
      |> check_primitive(:bytes)
    end

    test "Enum value" do
      Primitives.enum()
      |> check_primitive(:enum)
    end
end
