defmodule ChitChatWeb.SessionHTML do
  use ChitChatWeb, :html

  embed_templates "session_html/*"

  @doc """
  Renders a user form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def session_form(assigns)
end
