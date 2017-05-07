defmodule Elibuf.Services do
  defstruct name: nil, rpcs: []

  alias Elibuf.Services.Rpc

  def new_service(name) when is_bitstring(name) do
    %__MODULE__{name: name}
  end

  def set_name(%__MODULE__{} = service, name) when is_bitstring(name) do
    %{service | name: name}
  end

  def has_name?(%__MODULE__{} = service) do
    is_bitstring(service.name)
  end

  def add_rpc(%__MODULE__{} = service, %Rpc{} = rpc) do
    %{service | rpcs: [rpc | service.rpcs]}
  end

  def has_rpcs?(%__MODULE__{} = service) do
    length(service.rpcs) > 0
  end

  def generate(%__MODULE__{} = service) do
    start_of_service = "service " <> service.name <> " {\n"
    list_of_rpcs = service.rpcs
    |> Enum.map(&(Rpc.generate(&1)))
    |> Enum.join("\n")
    start_of_service <> list_of_rpcs <> "\n}"

  end

  def generate(%__MODULE__{} = service, :indent) do
    start_of_service = "service " <> service.name <> " {\n"
    list_of_rpcs = service.rpcs
    |> Enum.map(&(Rpc.generate(&1, :indent)))
    |> Enum.join("\n")
    start_of_service <> list_of_rpcs <> "\n}"
  end

end
