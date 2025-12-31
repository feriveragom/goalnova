defmodule GoalnovaWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import GoalnovaWeb.Gettext

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 mr-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
        <%= @title %>
      </p>
      <p class="mt-2 text-sm leading-5"><%= msg %></p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} title={gettext("Success!")} flash={@flash} />
      <.flash kind={:error} title={gettext("Error!")} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        <%= gettext("Attempting to reconnect") %>
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        <%= gettext("Hang in there while we get back on track") %>
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end


  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information. Unsupported types, such as hidden and radio,
  are best written directly in your templates.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          {@rest}
        />
        <%= @label %>
      </label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 min-h-[6rem]",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-zinc-800">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading-6 text-zinc-500">
          <tr>
            <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
            <th :if={@action != []} class="relative p-0 pb-4">
              <span class="sr-only"><%= gettext("Actions") %></span>
            </th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700"
        >
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group hover:bg-zinc-50">
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block py-4 pr-6">
                <span class="absolute -inset-y-px right-0 -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative w-14 p-0">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                >
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500"><%= item.title %></dt>
          <dd class="text-zinc-700"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(GoalnovaWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(GoalnovaWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end


  @doc """
  Renders a reusable dropdown menu component.

  ## Examples

      <.dropdown id="profile-menu">
        <:trigger :let={dropdown}>
          <button phx-click={JS.toggle(to: "#profile-menu-dropdown")}>
            Click me
          </button>
        </:trigger>
        <:header>
          <p>User info</p>
        </:header>
        <:item navigate="/profile" icon="hero-user">
          Mi Perfil
        </:item>
        <:item navigate="/admin" icon="hero-cog-6-tooth">
          Administración
        </:item>
        <%!-- Logout es ruta interna NO LiveView (controller), requiere href con redirect --%>
        <:item href="/auth/logout" data-phx-link="redirect" icon="hero-arrow-right-on-rectangle" class="text-[var(--signal-danger-main)]">
          Cerrar Sesión
        </:item>
      </.dropdown>

  The trigger slot receives a map with `dropdown_id` that should be used in the phx-click.
  The dropdown_id format is: `{id}-dropdown` where `{id}` is the id attribute passed to the component.
  """
  attr :id, :string, required: true, doc: "Unique ID for the dropdown"
  attr :position, :string, default: "right", values: ~w(left right), doc: "Dropdown position"
  attr :width, :string, default: "w-64", doc: "Width of the dropdown"
  slot :trigger, required: true, doc: "Button or element that triggers the dropdown"
  slot :header, doc: "Optional header section at the top of the dropdown"
  slot :item, doc: "Menu items" do
    attr :navigate, :string
    attr :href, :string
    attr :icon, :string
    attr :class, :string
  end

  def dropdown(assigns) do
    dropdown_id = "#{@id}-dropdown"

    ~H"""
    <div class="relative" id={@id}>
      <%= render_slot(@trigger, %{dropdown_id: dropdown_id}) %>

      <div
        id={dropdown_id}
        class={[
          "hidden absolute #{@position}-0 mt-2 #{@width} rounded-xl surface-card py-2 shadow-popover ring-1 ring-[var(--border-subtle)] z-50"
        ]}
        phx-click-away={JS.hide(to: "##{dropdown_id}")}
        phx-window-keydown={JS.hide(to: "##{dropdown_id}")}
        phx-key="escape"
      >
        <div :if={@header != []} class="px-4 py-3 border-b border-[var(--border-subtle)]">
          <%= render_slot(@header) %>
        </div>

        <div :if={@item != []}>
          <%= for item <- @item do %>
            <% item_class = Map.get(item, :class, "") %>
            <%= if item[:navigate] do %>
              <.link
                navigate={item[:navigate]}
                phx-click={JS.hide(to: "##{dropdown_id}")}
                class={[
                  "flex items-center gap-3 px-4 py-2.5 text-sm text-[var(--text-main)] hover:bg-[var(--surface-hover)] transition-colors",
                  item_class
                ]}
              >
                <.svg :if={item[:icon]} name={item[:icon]} class="w-5 h-5 text-subtle" />
                <%= render_slot(item) %>
              </.link>
            <% else %>
              <.link
                href={item[:href]}
                data-phx-link={Map.get(item, :"data-phx-link", "redirect")}
                phx-click={JS.hide(to: "##{dropdown_id}")}
                class={[
                  "flex items-center gap-3 px-4 py-2.5 text-sm text-[var(--text-main)] hover:bg-[var(--surface-hover)] transition-colors",
                  item_class
                ]}
              >
                <.svg :if={item[:icon]} name={item[:icon]} class="w-5 h-5 text-subtle" />
                <%= render_slot(item) %>
              </.link>
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @doc """
    Componente que renderiza iconos en formato SVG.
  """
  attr :name, :string,
  required: true,
  doc: """
    Nombre del icono.
    Es un atributo requerido.
    Para iconos desde `Heroicon`, se debe especificar en el nombre el prefijo `hero-`. Por defecto, se utiliza el sufijo `-outline`, pero puedes agregar `-solid` y `-mini`.
  """,
  examples: [
    "hero-x-mark-solid",
    "https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600",
    "b0ce023f-8eac-4b0b-a6e3-7d769b762b64"
  ]

  attr :type, :string,
    default: "local",
    values: ~w(local url uniqueid),
    doc: """
      Define la forma de obtener el icono.
      Por defecto se usa, `local`
      -`local` indica que se buscará el icono alojado en el servidor en la ruta `priv/static/svg`
      -`url` indica que se obtiene el icono desde una ruta
      -`uniqueid` indica que se buscará el contenido del icono en Alberto.
    """

  attr :class, :any,
    default: "",
    doc: "Agrega clases CSS, acepta valores en forma de lista o como cadena"

  attr :rest, :global

  def svg(%{name: "hero-" <> _} = assigns), do: ~H"<span class={[@name, @class]} {@rest} />"
  def svg(%{:type => "url"} = assigns), do: ~H"<img src={@name} class={@class} {@rest} />"
  def svg(assigns), do: ~H"<%= svg_path(assigns) %>"

  defp svg_path(%{type: "uniqueid", name: name, class: class}) do
    {:safe,
    cond do
      not String.valid?(name) ->
        "<img class=#{css_class(class)} src=\"#{content(name) |> extmake()}\" />"

      true ->
        name
        |> content()
        |> Floki.attr("svg", "class", fn _ -> css_class(class) end)
        |> Floki.raw_html()
    end}
  end

  defp svg_path(%{:name => name} = assigns) do
    {:safe,
    System.fetch_env!("APP_NAME")
    |> String.to_atom()
    |> Application.app_dir("priv/static/svg/#{name}.svg")
    |> File.read()
    |> loadsvg
    |> Floki.parse_fragment()
    |> insert_class(get_in(assigns, [Access.key(:class, [])]))}
  end

  defp insert_class({:error, html}, _), do: raise("No se puede parsear el html\n#{html}")

  defp insert_class({:ok, html}, class) when is_nil(class) or class == [],
    do: Floki.raw_html(html)

  defp insert_class({:ok, html}, class) do
    Floki.attr(html, "svg", "class", fn _ -> css_class(class) end)
    |> Floki.raw_html()
  end

  defp loadsvg({:ok, result}), do: String.trim(result)

  defp loadsvg(_),
    do: "<svg class='h-5 w-20'><text x='0' y='15' fill='red'>Not Found</text></svg>"

  # Capturando extension
  defp extmake(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>> = val),
    do: "data:image/png;base64,#{Base.encode64(val)}"

  defp extmake(<<0xFF, 0xD8, _::binary>> = val),
    do: "data:image/jpeg;base64,#{Base.encode64(val)}"

  defp extmake(_val), do: ""

  # Leer contenido de alberto
  def content(unique_id) when is_binary(unique_id),
    do: Firmadox.Alberto.NodeService.nodecontent_m(unique_id) |> content()

  def content({:ok, info}), do: info
  def content(_ignore), do: ""

  def css_class(class) when is_list(class), do: Enum.join(class, " ")
  def css_class(class) when is_binary(class), do: class
  def css_class(_class), do: ""


  @doc """
  Renders a button with variant support.

  If `navigate` or `href` is provided, renders as a link button (for navigation).
  Otherwise, renders as a regular button (for actions).

  ## Navigation Rules (RIGID - NO EXCEPTIONS)

  **CRITICAL:** There is a strict, non-negotiable rule for navigation attributes:

  - **`navigate`** → **INTERNAL navigation only** (within the application)
    - Routes within the LiveView application (e.g., `"/"`, `"/profile"`, `~p"/users"`)
    - Uses `patch` navigation (NO page reload, socket stays connected)
    - Example: `<.button navigate="/">Home</.button>`

  - **`href`** → **EXTERNAL navigation only** (outside the application)
    - External URLs starting with `http://` or `https://`
    - Uses `redirect` navigation (page reload, new socket connection)
    - Example: `<.button href="https://example.com">External</.button>`

  **DO NOT:**
  - Use `href` for internal routes (e.g., `href="/"` is WRONG)
  - Use `navigate` for external URLs (e.g., `navigate="https://..."` is WRONG)

  ## Variants

  - `:primary` (default) - Main action, filled with primary color
  - `:secondary` - Secondary actions, outlined style
  - `:ghost` - Tertiary actions, minimal style (cancel, dismiss)
  - `:danger` - Destructive actions (delete, remove)

  ## States

  - `loading` - Shows loading spinner and disables interaction
  - `disabled` - Disables the button (native HTML disabled attribute)

  ## Accessibility

  - `aria_label` - Accessible label for screen readers
  - `aria_disabled` - Indicates disabled state to assistive technologies

  ## Examples

      <.button>Save</.button>
      <.button variant="secondary">Cancel</.button>
      <.button variant="danger" phx-click="delete">Delete</.button>
      <.button variant="ghost">Dismiss</.button>
      <.button navigate="/profile">Mi Perfil</.button>
      <.button href="https://hexdocs.pm/elixir">External Docs</.button>
      <.button loading>Loading...</.button>
      <.button disabled>Disabled</.button>
      <.button aria_label="Save document" phx-click="save">Save</.button>
  """
  attr :type, :string, default: "button", doc: "Button type (button, submit, reset)"
  attr :class, :string, default: nil, doc: "Additional CSS classes"
  attr :variant, :string,
    default: "primary",
    values: ~w(primary secondary ghost danger),
    doc: "Button style variant"
  attr :size, :string,
    default: "default",
    values: ~w(sm default lg),
    doc: "Button size"
  attr :navigate, :string,
    doc: "INTERNAL navigation only - Routes within the application (e.g., \"/\", \"/profile\"). Uses patch navigation (no page reload)."
  attr :href, :string,
    doc: "EXTERNAL navigation only - External URLs starting with http:// or https://. Uses redirect navigation (page reload)."
  attr :loading, :boolean, default: false, doc: "Shows loading state with spinner"
  attr :disabled, :boolean, default: false, doc: "Disables the button"
  attr :aria_label, :string, default: nil, doc: "Accessible label for screen readers"
  attr :aria_disabled, :boolean, default: false, doc: "Indicates disabled state to assistive technologies"
  attr :rest, :global, include: ~w(form name value)

  slot :inner_block, required: true

  def button(assigns) do
    # Validate mutually exclusive attributes
    if assigns[:navigate] && assigns[:href] do
      raise ArgumentError,
            "Cannot use both 'navigate' and 'href' attributes. Use 'navigate' for internal routes and 'href' for external URLs."
    end

    # Validate href is external URL
    if assigns[:href] && not String.starts_with?(assigns.href, ["http://", "https://"]) do
      raise ArgumentError,
            "The 'href' attribute must be an external URL starting with http:// or https://. For internal routes, use 'navigate' instead."
    end

    # Determine if button should be disabled
    is_disabled = assigns.disabled || assigns.loading

    # Build button classes (filter out false values)
    button_classes =
      [
        "btn",
        # Size variants
        assigns.size == "sm" && "px-2.5 py-0.5 text-xs",
        assigns.size == "default" && "px-3 py-1 text-sm",
        assigns.size == "lg" && "px-4 py-1.5 text-base",
        # Style variants mapped to Master Classes
        assigns.variant == "primary" && "btn-primary",
        assigns.variant == "secondary" && "btn-secondary",
        assigns.variant == "ghost" && "btn-ghost",
        assigns.variant == "danger" && "btn-danger",
        # Loading state
        assigns.loading && "opacity-75 cursor-not-allowed",
        # Disabled state
        is_disabled && "opacity-50 cursor-not-allowed",
        assigns.class
      ]
      |> Enum.filter(& &1)

    # Build aria attributes
    aria_attrs =
      []
      |> then(fn attrs ->
        if assigns.aria_label, do: [{"aria-label", assigns.aria_label} | attrs], else: attrs
      end)
      |> then(fn attrs ->
        if assigns.aria_disabled || is_disabled, do: [{"aria-disabled", "true"} | attrs], else: attrs
      end)
      |> Map.new()

    # Build rest attributes (excluding disabled if it's a link)
    rest_attrs =
      assigns.rest
      |> Map.merge(aria_attrs)
      |> then(fn attrs ->
        if assigns[:navigate] || assigns[:href] do
          # For links, don't use disabled attribute (use aria-disabled instead)
          Map.drop(attrs, [:disabled])
        else
          # For buttons, include disabled attribute
          if is_disabled, do: Map.put(attrs, :disabled, true), else: attrs
        end
      end)

    # Assign rest_attrs to socket for use in template
    assigns = assign(assigns, :rest_attrs, rest_attrs)
    assigns = assign(assigns, :button_classes, button_classes)
    assigns = assign(assigns, :is_disabled, is_disabled)

    # If navigate or href is provided, render as link button
    cond do
      assigns[:navigate] ->
        ~H"""
        <.link
          navigate={@navigate}
          class={@button_classes}
          aria-disabled={if @is_disabled, do: "true"}
          tabindex={if @is_disabled, do: "-1"}
          {@rest_attrs}
        >
          <%= if @loading do %>
            <span class="inline-block animate-spin mr-2">
              <.svg name="hero-arrow-path" class="h-4 w-4" />
            </span>
          <% end %>
          <%= render_slot(@inner_block) %>
        </.link>
        """

      assigns[:href] ->
        ~H"""
        <.link
          href={@href}
          class={@button_classes}
          aria-disabled={if @is_disabled, do: "true"}
          tabindex={if @is_disabled, do: "-1"}
          {@rest_attrs}
        >
          <%= if @loading do %>
            <span class="inline-block animate-spin mr-2">
              <.svg name="hero-arrow-path" class="h-4 w-4" />
            </span>
          <% end %>
          <%= render_slot(@inner_block) %>
        </.link>
        """

      true ->
        ~H"""
        <button
          type={@type}
          class={@button_classes}
          disabled={@is_disabled}
          {@rest_attrs}
        >
          <%= if @loading do %>
            <span class="inline-block animate-spin mr-2">
              <.svg name="hero-arrow-path" class="h-4 w-4" />
            </span>
          <% end %>
          <%= render_slot(@inner_block) %>
        </button>
        """
    end
  end

  @doc """
  Renders a demo section with title and description.

  ## Examples

      <.demo_section id="buttons" title="Buttons" description="All button variants">
        <div>Button content here</div>
      </.demo_section>
  """
  attr :id, :string, required: true, doc: "Unique ID for the section"
  attr :title, :string, required: true, doc: "Section title"
  attr :description, :string, required: true, doc: "Section description"
  slot :inner_block, required: true

  def demo_section(assigns) do
    ~H"""
    <div id={@id} class="space-y-4">
      <div>
        <h2 class="text-xl sm:text-2xl font-semibold text-[var(--text-main)]">
          <%= @title %>
        </h2>
        <p class="mt-1 text-sm text-subtle">
          <%= @description %>
        </p>
      </div>
      <div class="pt-4">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

end
