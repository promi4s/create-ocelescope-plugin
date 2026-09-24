# create-ocelescope-plugin

A [Copier](https://copier.readthedocs.io) template for writing an **Ocelescope** plugin. It asks for your plugin's name and generates a ready-to-build project with the package, plugin class and metadata already named.

## Create a plugin

With [uv](https://docs.astral.sh/uv/) you don't need to install anything:

```sh
uvx copier copy gh:promi4s/create-ocelescope-plugin my-plugin
```

You will be asked for the plugin name (the label shown in the Ocelescope UI) and a short description. All other names are derived from the plugin name:

| Plugin name        | Project (`pyproject.toml`) | Package (`src/…`)  | Plugin class      |
| ------------------ | -------------------------- | ------------------ | ----------------- |
| `My Plugin`        | `my-plugin`                | `my_plugin`        | `MyPlugin`        |
| `OCEL Stats`       | `ocel-stats`               | `ocel_stats`       | `OCELStats`       |
| `3D Viewer`        | `3d-viewer`                | `plugin_3d_viewer` | `Plugin3DViewer`  |

Then:

```sh
cd my-plugin
uv sync
uv run ocelescope build
```

## Update an existing plugin

Generated plugins remember their answers in `.copier-answers.yml`. To pull template changes into a plugin, commit your work and run inside the plugin:

```sh
uvx copier update
```

## Developing this template

The generated project lives in [`template/`](template/). Files ending in `.jinja` are rendered with the answers from [`copier.yml`](copier.yml); other files are copied as-is. Try your local changes with:

```sh
uvx copier copy --vcs-ref HEAD . /tmp/test-plugin
```

### Updating dependencies

`template/uv.lock.jinja` and `template/requirements.txt.jinja` are real lockfiles with the project name replaced by `{{ project_name }}`. Regenerate them with:

```sh
scripts/update-lock.sh                                # upgrade all dependencies
scripts/update-lock.sh --upgrade-package ocelescope   # only upgrade ocelescope
scripts/update-lock.sh --no-upgrade                   # re-resolve after editing pyproject.toml.jinja
```
