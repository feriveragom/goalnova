defmodule GoalnovaWeb.Components.Demo.AppUiActions do
  @moduledoc """
  Componente demo para UI Actions (Botones y Links)
  """
  use Phoenix.Component

  import GoalnovaWeb.CoreComponents
  alias Phoenix.LiveView.JS

  embed_templates "*.html"
end
