defmodule Lens do
  def key(key) do
    fn data, fun ->
      {res, updated} = fun.(data[key])
      {[res], Map.put(data, key, updated)}
    end
  end

  def combine(lens1, lens2) do
    fn data, fun ->
      {res, changed} = get_and_map(data, lens1, fn item ->
        get_and_map(item, lens2, fun)
      end)
      {Enum.concat(res), changed}
    end
  end

  def to_list(data, lens) do
    {list, _} = get_and_map(data, lens, &{&1, &1})
    list
  end

  def each(data, lens, fun) do
    {_, _} = get_and_map(data, lens, &{nil, fun.(&1)})
  end

  def map(data, lens, fun) do
    {_, changed} = get_and_map(data, lens, &{nil, fun.(&1)})
    changed
  end

  def get_and_map(data, lens, fun) do
    lens.(data, fun)
  end
end