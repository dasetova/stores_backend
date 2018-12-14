defmodule StoreAdminWeb.ErrorView do
  use StoreAdminWeb, :view

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Resource not found"}}
  end

  def render("400.json", %{msg: msg}) do
    %{errors: %{detail: msg}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
