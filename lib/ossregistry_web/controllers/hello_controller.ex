defmodule OssregistryWeb.HelloController do
  use OssregistryWeb, :controller

  def index(conn, _params) do
    # render will call OssregistryWeb.HelloHTML
    render(conn, :index)
  end

  def show(conn, %{"messenger" => messenger}) do
    render(conn, :show, messenger: messenger)
  end
end
