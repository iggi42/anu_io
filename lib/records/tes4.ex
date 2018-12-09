defmodule Anu.IO.Records.TES4 do
  @moduledoc """
  handle record specific data and flags according to
  [UESP Wiki](https://en.uesp.net/wiki/Tes5Mod:Mod_File_Format#TES4_Record)
  """

  # defstruct []
  alias Anu.IO.Record

  use Record,
    type: "TES4",
    flags: [
      master_file: 0x00_00_00_00_01,
      localized: 0x00_00_00_00_80,
      light_master_file: 0x00_00_02_00
    ]

  @impl Record
  def parse_data(_device, _size, _flags) do
  end
end
