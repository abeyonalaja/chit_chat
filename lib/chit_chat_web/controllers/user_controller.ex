defmodule ChitChatWeb.UserController do
  use ChitChatWeb, :controller

  alias ChitChat.Accounts
  alias ChitChat.Accounts.User
  import ChitChatWeb.Auth, only: [logged_in_user: 2, admin_user: 2]
  plug :logged_in_user when action not in [:new, :create]
  plug :correct_user when action in [:edit, :update, :delete]
  plug :admin_user, [pokerface: true] when action in [:index, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end

  defp correct_user(
         %{assigns: %{current_user: current, admin_user: admin}, params: %{"id" => id}} = conn,
         _params
       ) do
    if(String.to_integer(id) == current.id || admin) do
      conn
    else
      conn
      |> put_flash(:error, "You dont have access to that page")
      |> redirect(to: ~p"/users/#{current}")
    end
  end
end
