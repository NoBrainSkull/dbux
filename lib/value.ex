defmodule DBux.Value do
  defstruct type: nil, value: nil
  @type t :: %DBux.Value{type: :byte | :boolean | :int16 | :uint16 | :int32 | :uint32 | :int64 | :uint64 | :double | :string | :object_path | :signature | :array | :struct | :variant | :dict_entry | :unix_fd, value: any}


  @spec marshall(%DBux.Value{}, :little_endian | :big_endian) :: Bitstring
  def marshall(%DBux.Value{type: :byte, value: value}, _) when is_binary(value) do
    if String.length(value) != 1, do: throw {:badarg, :value, :outofrange}

    << hd(to_char_list(value)) >>
  end


  @spec marshall(%DBux.Value{}, :little_endian | :big_endian) :: Bitstring
  def marshall(%DBux.Value{type: :byte, value: value}, _) when is_integer(value) do
    if value < 0,    do: throw {:badarg, :value, :outofrange}
    if value > 0xFF, do: throw {:badarg, :value, :outofrange}

    << value >>
  end


  @spec marshall(%DBux.Value{}, :little_endian | :big_endian) :: Bitstring
  def marshall(%DBux.Value{type: :boolean, value: value}, endianness) when is_boolean(value) do
    if value do
      marshall(%DBux.Value{type: :uint32, value: 1}, endianness)
    else
      marshall(%DBux.Value{type: :uint32, value: 0}, endianness)
    end
  end


  @spec marshall(%DBux.Value{}, :little_endian | :big_endian) :: Bitstring
  def marshall(%DBux.Value{type: :uint16, value: value}, endianness) when is_integer(value) do
    if value < 0,      do: throw {:badarg, :value, :outofrange}
    if value > 0xFFFF, do: throw {:badarg, :value, :outofrange}

    case endianness do
      :little_endian ->
        <<value :: size(2)-unit(8)-little >>
      :big_endian ->
        <<value :: size(2)-unit(8)-big >>
    end
  end


  @spec marshall(%DBux.Value{}, :little_endian | :big_endian) :: Bitstring
  def marshall(%DBux.Value{type: :uint32, value: value}, endianness) when is_integer(value) do
    if value < 0,          do: throw {:badarg, :value, :outofrange}
    if value > 0xFFFFFFFF, do: throw {:badarg, :value, :outofrange}

    case endianness do
      :little_endian ->
        <<value :: size(4)-unit(8)-little >>
      :big_endian ->
        <<value :: size(4)-unit(8)-big >>
    end
  end


  @spec marshall(%DBux.Value{}, :little_endian | :big_endian) :: Bitstring
  def marshall(%DBux.Value{type: :uint64, value: value}, endianness) when is_integer(value) do
    if value < 0,                  do: throw {:badarg, :value, :outofrange}
    if value > 0xFFFFFFFFFFFFFFFF, do: throw {:badarg, :value, :outofrange}

    case endianness do
      :little_endian ->
        <<value :: size(8)-unit(8)-little >>
      :big_endian ->
        <<value :: size(8)-unit(8)-big >>
    end
  end
end
