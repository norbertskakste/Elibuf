defmodule Elibuf.Protobuf do
  @moduledoc """
  Protobuf generation and macros
  """
  defstruct messages: [], enums: [], imports: [], custom_imports: [], services: [], auto_order: true, ignore_validation: false

  @doc """
  Returns empty Protobuf (proto3) builder
  """
  def new_protobuf() do
    %__MODULE__{}
  end

  # Mesage control

  @doc """
  Add message
  """
  def add_message do
  end

  @doc """
  Remove message
  """
  def remove_message do
  end

  @doc """
  Check if message exists
  """
  def has_message do
  end

  @doc """
  Check if messages exist
  """
  def has_messages? do
  end

  # Enum control

  @doc """
  Add enum
  """
  def add_enum do
  end

  @doc """
  Remove enum
  """
  def remove_enum do
  end

  @doc """
  Check if enum exists
  """
  def has_enum do
  end

  @doc """
  Check if enums exist
  """
  def has_enums? do
  end

  # Import control

  @doc """
  Add custom import (primitive typer imports are automatically injected)
  """
  def add_import do
  end

  @doc """
  Remove import
  """
  def remove_import do
  end

  @doc """
  Check if import exists
  """
  def has_import do
  end

  @doc """
  Check if imports exist
  """
  def has_imports? do
  end

  # Service control

  @doc """
  Add service
  """
  def add_service do
  end

  @doc """
  Remove service
  """
  def remove_service do
  end

  @doc """
  Check if service exists
  """
  def has_service do
  end

  @doc """
  Check if services exist
  """
  def has_services? do
  end

  # Auto-order control

  @doc """
  """
  def set_auto_order do
  end

  @doc """
  """
  def auto_order?(%__MODULE__{} = protobuf) do
    protobuf.auto_order
  end

  # Injection & Validation

  defp inject_enum do
  end

  defp inject_imports do
  end

  defp validate do
  end

  # Generation

  @doc """
  Generate protobuf spec
  """
  def generate do
  end

  @doc """
  Generate protobuf spec with identation
  """
  def gemerate(:auto_order) do
  end

 end
