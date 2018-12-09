defmodule Anu.IO.Record.Test do
  use ExUnit.Case

  test "Anu.IO.Record.parse_flags each flag alone " do
    assert [:deleted] == Anu.IO.Record.parse_flags(0x00_00_00_20)
    assert [:constant] == Anu.IO.Record.parse_flags(0x00_00_00_40)
    assert [:must_update_anims] == Anu.IO.Record.parse_flags(0x00_00_01_00)
    assert [:persistent_reference] == Anu.IO.Record.parse_flags(0x00_00_04_00)
    assert [:ignored] == Anu.IO.Record.parse_flags(0x00_00_10_00)
    assert [:distant_visible] == Anu.IO.Record.parse_flags(0x00_00_80_00)
    assert [:compressed_data] == Anu.IO.Record.parse_flags(0x00_040_00_0)
    assert [:can_not_wait] == Anu.IO.Record.parse_flags(0x00_08_00_00)
    assert [:is_marker] == Anu.IO.Record.parse_flags(0x00_80_00_00)
    assert [:navmesh_gen_filter] == Anu.IO.Record.parse_flags(0x04_00_00_00)
    assert [:navmesh_gen_bounding_box] == Anu.IO.Record.parse_flags(0x08_00_00_00)
    assert [:navmesh_gen_ground] == Anu.IO.Record.parse_flags(0x40_00_00_00)
  end
end
