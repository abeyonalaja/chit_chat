defmodule ChitChatWeb.SessionController do
  use ChitChatWeb, :controller

  alias ChitChat.Accounts

  def new(conn, _) do
    render(conn, :new)
  end

  def delete(conn, _)do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Room updated successfully.")
    |> redirect(to: ~p"/")
  end
end
