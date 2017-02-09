
defmodule Kata1.Offer do
  @moduledoc """
  Documentation for Kata1.
  """
  #define a function
  @type t :: %__MODULE__{
             id:        Integer.t,
             accumulate: nil | (([Item.t], map()) -> map()),
             total: nil | ((map()) -> float())
  }
  defstruct id:    "",
            accumulate: nil,
            total:   nil
end
defmodule Kata1.Item do
  @moduledoc """
  Documentation for Kata1.
  """
  @type t :: %__MODULE__{
             name:   String.t,
             type:   :quantity | :weight,
             price:  float,
             weight: nil | float,
             offer: nil | Kata1.Offer.t
  }
  defstruct name:    "",
            type:    :quantity,
            price:   0.0,
            weight:  0,
            offer: nil

end
