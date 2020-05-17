defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_session do
    plug Guardian.Plug.Pipeline,
      module: App.Guardian,
      error_handler: AppWeb.Auth.ErrorHandler

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug AppWeb.Auth.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :admin_required do
    plug AppWeb.Auth.CheckAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppWeb do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index
    resources "/users", UserController, only: [:index]
    resources "/login", SessionController, only: [:new, :create]
    post "/logout", SessionController, :delete
    resources "/restore-password", RestorePasswordController, only: [:index, :create]
    get "/restore-password-restore", RestorePasswordController, :restore
    post "/restore-password-restore", RestorePasswordController, :do_recover
    post "/send-email", EmailController, :send

    scope "/admin", Admin, as: :admin do
      pipe_through [:login_required, :admin_required]

      get "/", PageController, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end

    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
