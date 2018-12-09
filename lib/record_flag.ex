defmodule Anu.IO.Record.Flag do
  @moduledoc """
  code to parse record flags according to the documentation at
  [UESP Wiki](https://en.uesp.net/wiki/Tes5Mod:Mod_File_Format#Records).
  """

  @type t :: atom()

  @doc """
  use to satisfy the callback parse_flag for an Anu.IO.Record behavior

  every n needs to be element of 2^k with 0 <= k < 32.
  """
  @spec define([{Anu.IO.Record.uint_32(), t()}]) :: [t]
  defmacro define(defs \\ []) do
    quote do
      import Bitwise
      def parse_flags(raw_flags), do: parse_flags(raw_flags, [])

      unquote do
        Enum.map(defs, &flag_macro/1)
      end

      unquote do
        flag_end_macro()
      end
    end
  end

  defp flag_macro({atm, sign}) do
    quote do
      def parse_flags(raw_flags, parsed)
          when is_list(parsed) and (raw_flags &&& unquote(sign)) == unquote(sign) do
        parse_flags(raw_flags ^^^ unquote(sign), [unquote(atm) | parsed])
      end
    end
  end

  defp flag_end_macro() do
    quote do
      def parse_flags(raw_flags, parsed) when is_list(parsed) do
        {raw_flags, parsed}
      end
    end
  end
end
