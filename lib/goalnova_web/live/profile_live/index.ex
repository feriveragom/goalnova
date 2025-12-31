defmodule GoalnovaWeb.ProfileLive.Index do
  use GoalnovaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    current_user = GoalnovaWeb.Helpers.UserMock.mock_user()

    socket = assign(socket, :current_user, current_user)

    {:ok, socket}
  end
end
