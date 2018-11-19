defmodule Anu.IO.Record.Flag do
  @moduledoc """
  code to parse record flags according to the documentation at
  [UESP Wiki](https://en.uesp.net/wiki/Tes5Mod:Mod_File_Format#Records).
  """

  @type t ::
          :deleted
          | :constant
          | :hidden_from_local_map
          | :must_update_anims
          | :inaccessible
          | :starts_dead
          | :motion_blur_casts_shadows
          | :persistent_reference
          | :display_in_main_menu
          | :initially_disabled
          | :ignored
          | :distant_visible
          | :random_animation_start
          | :dangerous
          | :compressed_data
          | :can_not_wait
          | :ignore_object_interaction
          | :is_marker
          | :obstacle
          | :no_ai_acquire
          | :navmesh_gen_filter
          | :navmesh_gen_bounding_box
          | :must_exit_to_talk
          | :reflected_by_auto_water
          | :child_can_use
          | :no_havok_settle
          | :navmesh_gen_ground
          | :no_respawn
          | :multibound

  @doc """
  use to satisfy the callback parse_flag for an Anu.IO.Record behavior

  every n needs to be element of 2^k with 0 <= k < 32.
  """
  @spec define_flags([{Anu.IO.Record.uint_32(), t()}]) :: [t]
  defmacro define_flags(defs \\ []) do
    [
      quote do
      import Bitwise
      @doc "parse flags TODO"
      def parse_flags(raw_flags), do: parse_flags(raw_flags, [])
      end,
      Enum.map(defs, fn {atm, sign} ->
        quote do
          def parse_flags(raw_flags, parsed)
              when is_list(parsed) and (raw_flags &&& unquote(sign)) == unquote(sign) do
            parse_flags(raw_flags ^^^ unquote(sign), [unquote(atm) | parsed])
          end
        end
      end),
      quote do
        def parse_flags(_raw_flags, parsed) when is_list(parsed) do
          parsed
        end
      end
    ]
  end
end
