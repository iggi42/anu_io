defmodule Anu.IO.Record do
  @moduledoc """
  handle records according to
  [UESP Wiki](https://en.uesp.net/wiki/Tes5Mod:Mod_File_Format#Records).
  """

  defstruct [:type, :id, :flags, :revision, :version, :data]

  @typedoc "an unsigned integer from 16 bits"
  @type uint_16 :: 0..0xFF_FF

  @typedoc "an unsigned integer from 32 bits"
  @type uint_32 :: 0..0xFF_FF_FF_FF

  @typedoc "basic record information, type specific"
  @type t :: %__MODULE__{
          type: String.t(),
          id: uint_32,
          flags: [Anu.IO.Record.Flag.t()],
          revision: uint_32,
          version: uint_16,
          data: struct()
        }

  @doc "get the type the implementation is meant to handle"
  @callback type() :: String.t()

  @doc "parse type specific flags"
  @callback parse_flags(uint_32, [Anu.IO.Record.Flag.t()]) :: {uint_32, [Anu.IO.Record.Flag.t()]}

  @doc "parse data segment"
  @callback parse_data(IO.device(), uint_32, [Anu.IO.Record.Flag.t()]) :: {IO.device(), struct()}

  @records [
    Anu.IO.Record.TES4
  ]

  require Anu.IO.Record.Flag

  Anu.IO.Record.Flag.define_flags(
    deleted: 0x00_00_00_20,
    constant: 0x00_00_00_40,
    must_update_anims: 0x00_00_01_00,
    persistent_reference: 0x00_00_04_00,
    initially_disabled:  0x00_00_08_00,
    ignored: 0x00_00_10_00,
    distant_visible: 0x00_00_80_00,
    compressed_data: 0x00_04_00_00,
    can_not_wait: 0x00_08_00_00,
    is_marker: 0x00_80_00_00,
    navmesh_gen_filter: 0x04_00_00_00,
    navmesh_gen_bounding_box: 0x08_00_00_00,
    navmesh_gen_ground: 0x40_00_00_00
  )

  @doc "TODO"
  @spec parse_record(IO.device()) :: t()
  def parse_record(device) do
    <<type>> = IO.binread(device, 4)
    <<s::size(32)>> = IO.binread(device, 4)
    <<raw_flags::size(32)>> = IO.binread(device, 4)
    <<id::size(32)>> = IO.binread(device, 4)
    <<revision::size(32)>> = IO.binread(device, 4)
    <<version::size(16)>> = IO.binread(device, 2)
    <<_unkown::size(16)>> = IO.binread(device, 2)

    [impl] = Enum.filter(@records, fn i -> i.type == type end)
    {raw_flags, flags} = if(Module.defines?(impl, {:parse_flags, 2})) do
      impl.parse_flags(raw_flags, [])
    else
      {raw_flags, []}
    end
    {_restbin, flags} = parse_flags(raw_flags, flags)
    {_device, data} = impl.parse_data(device, s, flags)

    %__MODULE__{
      id: id,
      type: type,
      flags: raw_flags,
      revision: revision,
      version: version,
      data: data
    }
  end
end
