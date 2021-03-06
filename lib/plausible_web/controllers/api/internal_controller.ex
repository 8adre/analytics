defmodule PlausibleWeb.Api.InternalController do
  use PlausibleWeb, :controller
  use Plausible.Repo
  alias Plausible.Stats.Clickhouse, as: Stats

  def domain_status(conn, %{"domain" => domain}) do
    if Stats.has_pageviews?(%Plausible.Site{domain: domain}) do
      json(conn, "READY")
    else
      json(conn, "WAITING")
    end
  end

  def sites(conn, _) do
    user = Repo.preload(conn.assigns[:current_user], :sites)
    json(conn, Enum.map(user.sites, & &1.domain))
  end
end
