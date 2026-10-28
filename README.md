# ui_render

**One capability bit from GBT V8, packaged standalone.** No. 60 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 受控界面渲染（json-render #09 蒸馏）：模型只产 spec，组件必须命中白名单；未知组件/未列动作/脚本/外链一律拒 ⇒ 先 check 再 render；产物自包含零脚本零外链；指标必须带 src（没带的照渲但标红）。op=spec/check/render/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-ui-render.git
cd gbt-ui-render
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_ui_render info                  # capability card
python -m gbt_ui_render spec --json           # machine-readable contract
python -m gbt_ui_render check --payload '{}'
python -m gbt_ui_render run   --payload '{}'
```

Real `info` output from this machine:

```text
ui_render  (creation)  v1.0.0
----------------------------------------
受控界面渲染（json-render #09 蒸馏）：模型只产 spec，组件必须命中白名单；未知组件/未列动作/脚本/外链一律拒 ⇒ 先 check 再 render；产物自包含零脚本零外链；指标必须带 src（没带的照渲但标红）。op=spec/check/render/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : spec, check, render, where
```

Wire a real implementation:

```python
from gbt_ui_render import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（4 个）**：`spec`、`check`、`render`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `ui_render` |
| domain | `creation` |
| handler | `ui_render` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [creation/ui_render](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/ui_render.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
