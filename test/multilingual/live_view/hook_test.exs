defmodule Multilingual.LiveView.HookTest do
  use ExUnit.Case

  import Multilingual.LiveView.Hook
  alias Multilingual.Test.Project.Router

  describe "on_mount/4" do
    setup do
      socket =
        %Phoenix.LiveView.Socket{router: Router}
      private = socket.private
      socket = %{socket | private: Map.put(private, :lifecycle, %{handle_params: []})}
      {:ok, socket: socket}
    end

    test "attaches the multilingual hook", %{socket: socket} do
      {_, socket} = on_mount([default_locale: "en"], nil, nil, socket)

      assert [%{function: _fn, id: :multilingual}] = socket.private.lifecycle.handle_params
    end

    test "returns {:cont, socket}", %{socket: socket} do
      assert {:cont, _socket} = on_mount([default_locale: "en"], nil, nil, socket)
    end

    test "attaches a hook that sets the path and locale", %{socket: socket} do
      {_, socket} = on_mount([default_locale: "en"], nil, "http://example.com/about", socket)

      hook = hd(socket.private.lifecycle.handle_params)
      {_, socket} = hook.function.([], "http://example.com/about", socket)
      assert %Multilingual.View{locale: "en", path: "/about"} = socket.private.multilingual
    end
  end
end

