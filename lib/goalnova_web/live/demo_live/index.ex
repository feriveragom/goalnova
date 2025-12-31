defmodule GoalnovaWeb.DemoLive.Index do
  use GoalnovaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    current_user = GoalnovaWeb.Helpers.UserMock.mock_user()

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:active_tab, "desktop")

    {:ok, socket}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end
end
