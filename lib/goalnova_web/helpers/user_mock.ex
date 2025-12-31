defmodule GoalnovaWeb.Helpers.UserMock do
  @moduledoc """
  Helper para generar un mock de usuario.
  Este módulo será reemplazado cuando se integre la autenticación con Google.
  """

  @doc """
  Genera un mock de usuario para desarrollo.
  Retorna un mapa con la estructura esperada por el layout.
  """
  def mock_user do
    %{
      id: "mock_user_123",
      name: "Usuario Demo",
      email: "demo@goalnova.com",
      picture: "https://ui-avatars.com/api/?name=Usuario+Demo&background=d499ff&color=fff&size=128"
    }
  end
end
