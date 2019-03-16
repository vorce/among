defmodule AmongWeb.SearchController do
  use AmongWeb, :controller

  alias Among.Searches
  alias Among.Searches.Search

  def index(conn, %{"query" => query}) when is_binary(query) do
    with {:ok, results} <- Among.Searches.search(query) do
      render(conn, "index.html", results: results)
    end
  end

  # def index(conn, _params) do
  #   searches = Searches.list_searches()
  #   render(conn, "index.html", searches: searches)
  # end
  #
  # def new(conn, _params) do
  #   changeset = Searches.change_search(%Search{})
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"search" => search_params}) do
  #   case Searches.create_search(search_params) do
  #     {:ok, search} ->
  #       conn
  #       |> put_flash(:info, "Search created successfully.")
  #       |> redirect(to: Routes.search_path(conn, :show, search))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   search = Searches.get_search!(id)
  #   render(conn, "show.html", search: search)
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   search = Searches.get_search!(id)
  #   changeset = Searches.change_search(search)
  #   render(conn, "edit.html", search: search, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "search" => search_params}) do
  #   search = Searches.get_search!(id)
  #
  #   case Searches.update_search(search, search_params) do
  #     {:ok, search} ->
  #       conn
  #       |> put_flash(:info, "Search updated successfully.")
  #       |> redirect(to: Routes.search_path(conn, :show, search))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", search: search, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   search = Searches.get_search!(id)
  #   {:ok, _search} = Searches.delete_search(search)
  #
  #   conn
  #   |> put_flash(:info, "Search deleted successfully.")
  #   |> redirect(to: Routes.search_path(conn, :index))
  # end
end
