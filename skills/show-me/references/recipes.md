# Show-Me Recipes - copy-paste skeletons

Three reusable pieces: the before/after grid (Mode A), the options-matrix template+loop (Mode B), and the screenshot capture snippet.

## 1. Before / After grid (Mode A) - local HTML, references local PNGs

Write to the scratchpad next to the PNGs, then `open` it. RTL Hebrew, right=before, left=after.

```html
<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="utf-8">
<title>SUBJECT - שינוי</title>
<style>
  body{margin:0;font-family:'Heebo',system-ui,sans-serif;background:#faf9f7;color:#17161c;padding:32px}
  h1{text-align:center;font-size:26px;margin:0 0 4px}
  p.sub{text-align:center;color:#55535e;margin:0 0 28px}
  .row{display:grid;grid-template-columns:1fr 1fr;gap:22px;max-width:1600px;margin:0 auto}
  @media(max-width:820px){.row{grid-template-columns:1fr}}
  .col h2{font-size:17px;margin:0 0 10px;display:flex;align-items:center;gap:9px}
  .sw{width:16px;height:16px;border-radius:5px;display:inline-block}
  img{width:100%;border-radius:14px;box-shadow:0 10px 34px rgba(20,20,40,.14);border:1px solid #e7e5e0}
  .tag{display:inline-block;padding:2px 10px;border-radius:99px;font-size:12px;font-weight:700;color:#fff}
</style></head><body>
  <h1>TITLE</h1>
  <p class="sub">ONE-LINE DELTA IN PLAIN WORDS</p>
  <div class="row">
    <div class="col before"><h2>לפני <span class="tag" style="background:#8a6a4a">BEFORE</span></h2><img src="before.png"></div>
    <div class="col after"><h2>אחרי <span class="tag" style="background:#4F46E5">AFTER</span></h2><img src="after.png"></div>
  </div>
</body></html>
```

Then: `open <scratch>/that.html`. For multi-region comparisons, add more `.row` blocks (top-of-page, mid-feed, mobile).

## 2. Options matrix (Mode B) - live in-context mocks, DRY via template + loop

The value: each option is applied to a recreation of the REAL surface, not a swatch. Define the mock once in a `<template>`, hold options in a JS array, instantiate per option by setting CSS vars on a wrapper. Pure CSS (no images) so it can ship as an Artifact.

```html
<style>
  /* neutral page chrome */
  body{margin:0;font-family:'Heebo',ui-sans-serif,system-ui,sans-serif;background:#faf9f7;color:#17161c}
  .wrap{max-width:1080px;margin:0 auto;padding:56px 24px 96px}
  .palette{margin-top:34px;border:1px solid #e7e5e0;border-radius:22px;overflow:hidden;background:#fff}
  .head{display:flex;flex-wrap:wrap;align-items:center;gap:14px;padding:22px 26px;border-bottom:1px solid #e7e5e0}
  .num{width:34px;height:34px;border-radius:10px;display:grid;place-items:center;color:#fff;font-weight:800;background:var(--primary)}
  /* the mock reads ONLY from --primary/--accent/--bg/... set per section */
  .demo{padding:26px;background:var(--bg)}
  .nav-pill.on{background:color-mix(in srgb,var(--primary) 12%,#fff);color:var(--primary);
    border:1px solid color-mix(in srgb,var(--primary) 30%,transparent);border-radius:999px;padding:8px 14px;font-weight:700}
  .cbtn{color:#fff;background:var(--primary);border:0;border-radius:999px;padding:9px 16px;font-weight:700}
  .cat{color:color-mix(in srgb,var(--accent) 55%,#000);background:color-mix(in srgb,var(--accent) 20%,#fff);
    border:1px solid color-mix(in srgb,var(--accent) 40%,transparent);border-radius:999px;padding:4px 10px;font-weight:700}
  .av.grad{background:linear-gradient(135deg,var(--primary),color-mix(in srgb,var(--primary) 55%,#000))}
  code{font-family:ui-monospace,Menlo,monospace;direction:ltr;text-align:left;background:#16151b;color:#e8e6ef;
    border-radius:10px;padding:12px 14px;white-space:pre;overflow-x:auto;display:block}
</style>

<div class="wrap">
  <header><!-- eyebrow, h1, one-line why-it-looks-flat-now, current values chip --></header>
  <div id="options"></div>
  <p class="foot">how to apply + "tell me which and I apply it"</p>
</div>

<template id="mock">
  <div class="demo"><div class="mock" dir="rtl">
    <!-- RECREATE THE REAL SURFACE: nav active tab, composer + primary button,
         a post card (avatar .av.grad, name, .cat chip, title, like/comment),
         a sidebar card + stat row. Everything styled off var(--primary/accent/bg). -->
  </div></div>
</template>

<script>
  const OPTIONS = [
    { name:"Electric Indigo", he:"אינדיגו חשמלי", fit:"match", fitLabel:"מתאים",
      note:"one-line rationale",
      primary:"#4F46E5", accent:"#818CF8", gold:"#F5B93D", bg:"#F2F3FC", bgMuted:"#E5E7F6" },
    // ...4-6 distinct DIRECTIONS, not shades of one hue
  ];
  const tpl = document.getElementById("mock");
  const host = document.getElementById("options");
  OPTIONS.forEach((o,i)=>{
    const s=document.createElement("section"); s.className="palette";
    ["primary","accent","gold","bg","bgMuted"].forEach(k=>s.style.setProperty("--"+k,o[k]));
    s.innerHTML =
      `<div class="head"><span class="num">${i+1}</span>
         <span><strong>${o.he}</strong><br><small>${o.name}</small></span>
         <span class="fit ${o.fit}" style="margin-inline-start:auto">${o.fitLabel}</span></div>`
      + `<div class="swatches">/* chip+hex per role */</div>`
      + tpl.innerHTML
      + `<div class="apply"><p>${o.note}</p><code>brandColors = {
  "primary": "${o.primary}",
  "accent":  "${o.accent}",
  "gold":    "${o.gold}",
  "bg":      "${o.bg}",
  "bgMuted": "${o.bgMuted}"
}</code></div>`;
    host.appendChild(s);
  });
</script>
```

`color-mix(in srgb, var(--x) N%, ...)` is the trick that derives tints/borders/hovers from one base var, so one `--primary` restyles the whole mock. Pick 4-6 genuinely different directions (not 3 shades of the same hue) and tag which fit the subject.

## 3. Screenshot capture (Mode A) - playwright over headless Chrome CDP

Launch Chrome with CDP if playwright errors ECONNREFUSED :9222:
`"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --remote-debugging-port=9222 --user-data-dir=<scratch>/chrome --no-first-run about:blank &`

```js
async (page) => {
  await page.setViewportSize({ width: 1440, height: 900 });
  await page.goto(URL);
  await page.waitForTimeout(3000);
  // behind auth? log in (saved creds) or use a magic-link token, then dismiss blocking modals:
  if (page.url().includes('/login')) {
    await page.locator('input[type="email"]').first().fill(EMAIL);
    await page.locator('input[type="password"]').first().fill(PASS);
    await page.locator('button[type="submit"]').first().click();
    await page.waitForTimeout(4000); await page.goto(URL); await page.waitForTimeout(3000);
  }
  // fire IntersectionObserver reveals before shooting, else sections shoot empty:
  const h = await page.evaluate(() => document.body.scrollHeight);
  for (let y=0; y<=h; y+=700){ await page.evaluate(t=>scrollTo(0,t), y); await page.waitForTimeout(140); }
  await page.evaluate(() => scrollTo(0,0)); await page.waitForTimeout(800);
  await page.screenshot({ path:'./after-top.png', clip:{x:0,y:0,width:1440,height:800} });
}
```

Gotchas: capture the BEFORE before editing (unrecreatable after). Verify page `<title>` before trusting a localhost shot (another dev server can grab the port). Move PNGs out of the repo root into the scratchpad when done.
