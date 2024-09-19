

# Project Description

CreemDemo is a demo project that demonstrates how to use the CreemEx library to create a payment checkout session. It provides a simple web interface for users to input product details and initiate payments.

## Installation

1. Add the CreemEx library to your project dependencies:

```elixir
def deps do
  [
    {:creem_ex, "~> 0.1.0"}
  ]
end
```

2. Configure your API key:

```elixir
config :creem_ex, api_key: "your_api_key_here"
```

3. Start the Phoenix server:

```elixir
mix phx.server
```

## Usage

1. Open your browser and navigate to `http://localhost:4000`.


