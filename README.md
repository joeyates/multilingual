# Multilingual

Multilingual simplifies handling localized routes
in Elixir Phoenix applications, with and without LiveView.

# Rationale

When a site is localized, it is important to know which paths
should be used for the various localizations of a specific view.

Maybe the "about page" is `/about` in English and `/it/chi-siamo` in
Italian.

One common need is a "language selector", where you can jump to the same view
in another language.

Somewhere, for *each* localized view, there needs to be a mapping like this:

* "en" -> "/about"
* "it" -> "/it/chi-siamo"

This library is based on the idea that it is better to put such localization
information directly in the router.

# Route Metadata

Fortunately, the [Phoenix.Router](https://hexdocs.pm/phoenix/Phoenix.Router.html)
allows [metadata](https://hexdocs.pm/phoenix/Phoenix.Router.html#match/5-options)
to be added to route declarations.

With Multilingual, you add metadata to indicate the locale of each localized view.

You can do this via a helper:

```ex
import Multilingual.Routes, only: [metadata: 1]

...

get "/", PageController, :index, metadata("zh")
```

`metadata/1` returns the [`options`](https://hexdocs.pm/phoenix/Phoenix.Router.html#match/5-options)
for the route, specifically, setting the locale as the metadata for this library.

It's the same if you do this:

```ex
get "/", PageController, :index, metadata: [multilingual: %{locale: "zh"}]
```

# How Paths Are Grouped

Consider these routes:

```ex
get "/", PageController, :index, metadata("en")
get "/zh", PageController, :index, metadata("zh")
```

As they have the same `plug` (`PageController`) and `plug_opts` (`:index`),
Multilingual can group them to create the mapping that we need between
localized versions of the same view.

From the above, we can deduce this:

* "en" -> "/"
* "zh" -> "/zh"

And that's all is needed to carry out all the tasks we need when
handling the views of a localized site.

# Route Organization

Multilingual places no restrictions on how you structure your router declarations.

You can group the localized versions under scopes, with path prefixes:

```ex
scope "/", MyAppWeb do
  get "/", PageController, :index, metadata("en")
end

scope "/zh", MyAppWeb do
  get "/", PageController, :index, metadata("zh")
end
```

Otherwise, you can group the localized versions of a view together:

```ex
scope "/", MyAppWeb do
  get "/", PageController, :index, metadata("en")
  get "/zh", PageController, :index, metadata("zh")
end
```

If the path itself is localized, it's easy to follow what's going on:

```ex
scope "/", MyAppWeb do
  get "/about", PageController, :index, metadata("en")
  get "/it/chi-siamo", PageController, :index, metadata("it")
end
```

# `mix multilingual.routes`

If you want to check how your localized routes are configured,
there is a Mix task:

```sh
$ mix multilingual.routes
method  module                   action  en      it
get     MyAppWeb.PageController  :index  /about  /it/chi-siamo
```

# Using Multilingual Routes

With you routes set up, you can then make use of the information they give
via the following modules and functions.

This works by first storing the current path and locale
([the 'View'](lib/multilingual/view.ex))
in the `conn` or ,for LiveView, the `socket` and then using that
information to take further actions.

## Plugs for the Router

* The [StoreView Plug](lib/multilingual/plugs/store_view.ex) to store
  [view](lib/multilingual/view.ex) information;
* The [RedirectIncoming Plug](lib/multilingual/plugs/redirect_incoming.ex)
  for incoming links, which checks the 'accept-langauge' header
  and redirects to the correct view for the user's needs;
* The [PutGettextLocale Plug](lib/multilingual/plugs/put_gettext_locale.ex)
  which calls `Gettext.put_locale/1`.

## LiveView Hooks

* The [StoreView on_mount hook](lib/multilingual/live_view/hooks/store_view.ex)
  to store [view](lib/multilingual/view.ex) information in the LiveView socket;
* The [PutGettextLocale on_mount hook](lib/multilingual/live_view/hooks/put_gettext_locale.ex)
  which calls `Gettext.put_locale/1`.

## HTML Generation

* [get_rel_links/1](lib/multilingual/html.ex) builds a set of SEO-friendly
  rel links for the document head, indicating the canonical URL and links to
  localized views,
* [localized_path/3](lib/multilingual/routes.ex) takes any path and
  a locale and returns the equivalent path for that locale,
* [build_page_mapping/2](lib/multilingual/routes.ex) returns a mapping
  of locales to paths to aid the creation of language selectors.
