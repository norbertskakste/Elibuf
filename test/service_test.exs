defmodule ElibufTest.Service do
    use ExUnit.Case

    test "Service creation" do
        my_double = Elibuf.Primitives.double()
        |> Elibuf.Primitives.Base.set_order(2)
        |> Elibuf.Primitives.Base.set_name("MyDoubleValue")

        my_string = Elibuf.Primitives.string()
        |> Elibuf.Primitives.Base.set_order(3)
        |> Elibuf.Primitives.Base.set_name("MyStringValue")

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

        assert custom_service == "service CustomService {\n\trpc CustomRpc (customMessage) response (customMessage) {}\n\trpc AnotherCustomRpc (customMessage) response (AnotherMessage) {}\n\trpc CustomRpc (customMessage) response (customMessage) {}\n}"
    end

end

