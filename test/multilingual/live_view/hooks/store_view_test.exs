defmodule Multilingual.Hooks.StoreViewTest do
  use ExUnit.Case

  import Multilingual.Hooks.StoreView
  alias Multilingual.Test.Project.Router

  describe "on_mount/4" do
    setup do
      socket =
        %Phoenix.LiveView.Socket{router: Router}

      private = socket.private
      socket = %{socket | private: Map.put(private, :lifecycle, %{handle_params: []})}
      {:ok, socket: socket}
    end

    test "attaches the store_view hook", %{socket: socket} do
      {_, socket} = on_mount([default_locale: "en"], nil, nil, socket)

      assert [%{function: _fn, id: :multilingual_store_view}] =
               socket.private.lifecycle.handle_params
    end

    test "returns {:cont, socket}", %{socket: socket} do
      assert {:cont, _socket} = on_mount([default_locale: "en"], nil, nil, socket)
    end

    test "attaches a hook that stores the route and locale in the socket's private data", %{
      socket: socket
    } do
      {_, socket} = on_mount([default_locale: "en"], nil, "http://example.com/about", socket)

      hook = hd(socket.private.lifecycle.handle_params)
      {_, socket} = hook.function.([], "http://example.com/about", socket)
      assert %Multilingual.View{locale: "en", route: "/about"} = socket.private.multilingual
    end
  end
end
