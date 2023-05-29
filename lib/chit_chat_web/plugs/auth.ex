defmodule ChitChatWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias ChitChatWeb.Router

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && ChitChat.Accounts.get_user!(user_id)
    put_current_user(conn, user)
  end

  def logged_in_user(conn = %{assigns: %{current_user: %{}}}, _), do: conn

  def logged_in_user(conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in")
    |> redirect(to: "/")
    |> halt()
  end

  def admin_user(conn = %{assigns: %{admin_user: true}}, _), do: conn

  def admin_user(conn, opts) do
    if opts[:pokerface] do
      conn
      |> put_status(404)
      |> render(ChitChatWeb.ErrorHTML, "404.html")
      |> halt()
    end

    conn
    |> put_flash(:error, "You do not have access to that page")
    |> redirect(to: "/")
    |> halt()
  end

  defp put_current_user(conn, user) do
    conn
    |> assign(:current_user, user)
    |> assign(:admin_user, false)
  end
end
