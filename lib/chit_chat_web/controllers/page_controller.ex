defmodule ChitChatWeb.PageController do
  use ChitChatWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    user_id = get_session(conn, :user_id)
    render(conn, :home, layout: false, user_id: user_id)
  end
end
