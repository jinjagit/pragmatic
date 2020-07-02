defmodule Getaways.Vacation.Place do
  use Ecto.Schema
  import Ecto.Changeset

  schema "places" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :location, :string
    field :price_per_night, :decimal
    field :image, :string
    field :image_thumbnail, :string
    field :max_guests, :integer, default: 2
    field :pet_friendly, :boolean, default: false
    field :pool, :boolean, default: false
    field :wifi, :boolean, default: false

    has_many :bookings, Getaways.Vacation.Booking
    has_many :reviews, Getaways.Vacation.Review

    timestamps()
  end

  def changeset(place, attrs) do
    required_fields = [:name, :description, :location, 
                       :price_per_night, :image, :image_thumbnail]

    optional_fields = [:max_guests, :pet_friendly, :pool, :wifi]

    place
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
    |> slugify_name()
  end

  defp slugify_name(changeset) do
    case changeset.valid? do
      true ->
        name = get_field(changeset, :name)
        put_change(changeset, :slug, slugify(name))
  
      _ ->
        changeset
    end
  end
  
  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
