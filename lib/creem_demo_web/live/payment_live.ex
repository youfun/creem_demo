defmodule CreemDemoWeb.PaymentLive do
  use CreemDemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, api_key: "", product_id: "", return_url: "", payment_result: nil)}
  end

  def handle_event("create_checkout", %{"api_key" => api_key, "product_id" => product_id, "return_url" => return_url}, socket) do
    # 如果输入框提供了 API key，则使用它，否则使用配置中的 key
    api_key = if api_key != "", do: api_key, else: Application.get_env(:creem_ex, :api_key)

    # 临时设置 API key
    Application.put_env(:creem_ex, :api_key, api_key)

    # 如果提供了 return_url，则使用它，否则使用配置中的默认值
    opts = if return_url != "", do: [return_url: return_url], else: []

    case CreemEx.create_checkout_session(product_id, opts) do
      {:ok, response} ->
        case response do
          %{"checkout_url" => checkout_url} ->
            # 重定向到支付 URL
            {:noreply, redirect(socket, external: checkout_url)}
          _ ->
            # 处理意外的响应格式
            {:noreply, assign(socket, payment_result: "Error: Unexpected response format")}
        end

      {:error, error_message} ->
        # 处理错误情况
        {:noreply, assign(socket, payment_result: "Error: #{error_message}")}
    end
  rescue
    e in RuntimeError ->
      {:noreply, assign(socket, payment_result: "Error: #{e.message}")}
  end

  def handle_params(params, _uri, socket) do
    case CreemEx.parse_return_params(URI.encode_query(params)) do
      {:ok, parsed_params} ->
        {:noreply, assign(socket, payment_result: parsed_params)}
      {:error, :invalid_signature} ->
        {:noreply, put_flash(socket, :error, "Invalid signature in return parameters")}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Payment</h1>
      <form phx-submit="create_checkout">
        <input type="text" name="api_key" value={@api_key} placeholder="API Key" />
        <input type="text" name="product_id" value={@product_id} placeholder="Product ID" />
        <input type="text" name="return_url" value={@return_url} placeholder="Return URL" />
        <button type="submit">Create Checkout</button>
      </form>

      <%= if @payment_result do %>
        <h2>Payment Result</h2>
        <pre><%= inspect(@payment_result) %></pre>
      <% end %>
    </div>
    """
  end
end
