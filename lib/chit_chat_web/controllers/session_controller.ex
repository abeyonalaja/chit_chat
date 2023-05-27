defmodule ChitChatWeb.SessionController do
  use ChitChatWeb, :controller

  alias ChitChat.Accounts
  alias ChitChat.Accounts.Credential

  def new(conn, _) do
    changeset = Accounts.change_credential(%Credential{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"credential" => %{"email" => email, "password" => password}}) do
    case Accounts.auth_by_email_password(email, password) do
      {:ok, user} ->
        IO.inspect(user)

        conn
        |> put_flash(:info, "Welcome back")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: ~p"/")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Didnt work")
        |> redirect(to: ~p"/login")

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Account not found")
        |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Room updated successfully.")
    |> redirect(to: ~p"/")
  end
end
