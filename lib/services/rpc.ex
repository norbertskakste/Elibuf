defmodule Elibuf.Services.Rpc do
  @moduledoc"""
  Defines service RPC calls
  Example:
    my_rpc_call = Elibuf.Services.Rpc.new_rpc("MyRpcCall", request_message, response_message)
  """
  alias Elibuf.Message

  defstruct name: nil, request: nil, response: nil

  @doc"""
  Creates new RPC message structure
  Requires:
  *  name: string [bitstring]
  *  request: %Elibuf.Message{}
  *  response: %Elibuf.Message{}
  """
  def new_rpc(name, %Message{} = request, %Message{} = response) when is_bitstring(name) do
    %__MODULE__{name: name, request: request, response: response}
  end

  def set_name(%__MODULE__{} = rpc, name) when is_bitstring(name) do
    %{rpc | name: name}
  end

  def has_name?(%__MODULE__{} = rpc) do
    is_bitstring(rpc.name)
  end

  def set_request(%__MODULE__{} = rpc, %Message{} = request) do
    %{rpc | request: request}
  end

  def has_request?(%__MODULE__{} = rpc) do
    rpc.request.__struct__ == "Message"
  end

  def set_response(%__MODULE__{} = rpc, %Message{} = return) do
    rpc.response.__struct__ == "Message"
  end

  def generate(%__MODULE__{} = rpc) do
    "rpc " <> rpc.name <> " (" <> rpc.request.name <> ") responses (" <> rpc.response.name <> ") {}"
  end

  def generate(%__MODULE__{} = rpc, :indent) do
    "\trpc " <> rpc.name <> " (" <> rpc.request.name <> ") responses (" <> rpc.response.name <> ") {}"
  end

end
