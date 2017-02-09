defmodule Kata1Test do
  use ExUnit.Case
  doctest Kata1

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "creat an item" do
    %Kata1.Item{
      name: "bread",
      type: :quantity,
      price: 0.5
    }
    assert(Kata1.Item)
  end

  test "that we know how to do math" do
    beer_offer = %Kata1.Offer{
      id: 1,
      # init: &Kata1.ThreeForTwo.init/0,
      accumulate: &Kata1.ThreeForTwo.accumulate/2,
      total: &Kata1.ThreeForTwo.discount/1
    }

    items = [
      %Kata1.Item{
        name: "beer",
        type: :quantity,
        price: 3,
        offer: beer_offer
      },
      %Kata1.Item{
        name: "milk",
        type: :quantity,
        price: 2,
        offer: beer_offer
      },
      %Kata1.Item{
        name: "water",
        type: :quantity,
        price: 1,
        offer: beer_offer
      }
    ]

    assert 5 == calculate(items)
  end

  def calculate(items) when is_list(items) do
    {line_items, offer_state} = calculate_price(items, %{offers: %{}})
    sub_total = calculate_total(line_items, 0)

    offers = Map.values(offer_state.offers)
    discounts  = apply_discounts(offers, offer_state, 0)
    sub_total - discounts
  end

  def apply_discounts([], _offer_state, acc), do: acc
  def apply_discounts([h | t], offer_state, acc) do
    apply_discounts(t, offer_state, acc + h.total.(offer_state[h.id]))
  end

  def calculate_price([], offer_state), do: {[], offer_state}
  def calculate_price([item | tail], offer_state) do
    price = case item.type do
      :quantity -> item.price
      :weight   -> item.price * item.weight
    end

    # at first, the state wil be empty since offer_state is empty?
    state = offer_state[item.offer.id]
    IO.inspect state, label: " ---- state \n"

    new_state = item.offer.accumulate.(item, state)

    unique_offers = offer_state[:offers]
    IO.inspect unique_offers, label: " ---- unique_offers before map.put"

    unique_offers = Map.put(unique_offers, item.offer.id, item.offer)
    IO.inspect unique_offers, label: " ---- unique_offers"

    merged_state = offer_state
    |> Map.put(item.offer.id, new_state)
    |> Map.put(:offers, unique_offers)


    {remainder, new_offer_state} = calculate_price(tail, merged_state)

    { [price | remainder], new_offer_state }
  end

  def calculate_total([], acc), do: acc
  def calculate_total([h | t], acc) do
    calculate_total(t, acc + h)
  end

  def offer_price(items) when is_list(items) do

  end
end

defmodule Kata1.ThreeForTwo do
  def init() do
    []
  end

  def accumulate(item, nil), do: [item]
  def accumulate(item, state) do
    [item | state]
  end

  def discount(items) do
    sorted_items = Enum.sort(items, fn(item1, item2) -> item1.price <= item2.price end)
    total_items = length(items)
    free_items = div(total_items, 3)
    discount(sorted_items, free_items, 0)
  end

  def discount([], _, acc), do: acc
  def discount(_, 0, acc),  do: acc
  def discount([h|t], free_items, acc) do
    discount(t, free_items - 1, acc + h.price)
  end
end
