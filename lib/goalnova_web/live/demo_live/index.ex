defmodule GoalnovaWeb.DemoLive.Index do
  use GoalnovaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    current_user = GoalnovaWeb.Helpers.UserMock.mock_user()

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:active_tab, "actions")

    {:ok, socket}
  end

  @impl true
  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  @impl true
  def handle_event("demo_button_click", %{"action" => action}, socket) do
    message = "Botón #{action} clickeado"

    socket =
      socket
      |> put_flash(:info, message)

    {:noreply, socket}
  end

  @impl true
  def handle_event("dropdown_action", %{"action" => action}, socket) do
    message = case action do
      "edit" -> "Acción: Editar elemento"
      "delete" -> "Acción: Eliminar elemento"
      "download" -> "Acción: Descargar archivo"
      "archive" -> "Acción: Archivar elemento"
      "filter_date" -> "Acción: Filtrar por fecha"
      "filter_tag" -> "Acción: Filtrar por etiqueta"
      "profile" -> "Acción: Ver perfil"
      "settings" -> "Acción: Abrir configuración"
      "help" -> "Acción: Mostrar ayuda"
      "tutorials" -> "Acción: Ver tutoriales"
      _ -> "Acción del dropdown: #{action}"
    end

    socket =
      socket
      |> put_flash(:info, message)

    {:noreply, socket}
  end
end
