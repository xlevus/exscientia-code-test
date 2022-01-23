defmodule Codegen.SDK.Builder.Render do
  @src_template EEx.compile_string("""
                import dataclass
                from baselib import Resource
                <%= for import <- imports do %>import <%= import %><% end %>

                <%= for klass <- classes do %>
                @dataclass
                class <%= klass.name %>:
                  <%= if klass.docstring do %>\"""<%= klass.docstring %>\"""<% end %>
                <%= for prop <- klass.properties do %>
                    <%= if prop.docstring do %><%= #: prop.docstring %><% end %>
                    <%= prop.name %>: <%= prop.py_type %>
                <% end %>
                <% end %>

                class AnEndpoint(Resource[<%= primary_class.name %>]):
                    uri = "url"
                    klass = <%= primary_class.name %>
                """)

  def render(ctx) do
    {result, bindings} = Code.eval_quoted(@src_template, Map.to_list(ctx))

    IO.inspect(1)
    result
  end
end
