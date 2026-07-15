<script>
  import { onMount } from "svelte";

  let csrf = $state("");
  let email = $state("");
  let message = $state("");
  let status = $state("");
  let statusKind = $state(""); // "ok" | "err" | ""
  let busy = $state(false);
  let stats = $state(null);
  let apiOk = $state(false);
  let menuOpen = $state(false);

  onMount(async () => {
    try {
      const r = await fetch("/api/csrf", { credentials: "include" });
      const j = await r.json();
      csrf = j.csrf_token || "";
      const s = await fetch("/api/stats", { credentials: "include" });
      stats = await s.json();
      apiOk = true;
    } catch {
      apiOk = false;
      statusKind = "err";
      status = "API offline — start Ori (`ori run main.orl`) or use the Vite proxy.";
    }
  });

  async function submitContact(e) {
    e.preventDefault();
    busy = true;
    status = "";
    statusKind = "";
    try {
      const body = new URLSearchParams({
        csrf_token: csrf,
        email,
        message,
      });
      const r = await fetch("/api/contact", {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "X-CSRF-Token": csrf,
        },
        body: body.toString(),
      });
      const j = await r.json();
      if (!r.ok || !j.ok) {
        statusKind = "err";
        status = j.error || "Could not send message.";
      } else {
        statusKind = "ok";
        status = "Message received by the Ori process.";
        message = "";
        const s = await fetch("/api/stats", { credentials: "include" });
        stats = await s.json();
      }
    } catch {
      statusKind = "err";
      status = "Network error talking to Ori.";
    } finally {
      busy = false;
    }
  }

  function closeMenu() {
    menuOpen = false;
  }
</script>

<div class="shell">
  <header class="top">
    <div class="top-inner">
      <a class="brand" href="#top" onclick={closeMenu}>
        <span class="brand-mark" aria-hidden="true"></span>
        <span class="brand-text">
          <span class="brand-name">Ori</span>
          <span class="brand-sub">web framework</span>
        </span>
      </a>

      <nav class="nav-desk" aria-label="Primary">
        <a href="#features">Features</a>
        <a href="#stack">Stack</a>
        <a href="#contact">Contact</a>
        <a
          class="nav-ext"
          href="https://github.com/raillen/ori-web-framework"
          target="_blank"
          rel="noreferrer">Repo</a
        >
      </nav>

      <div class="top-actions">
        <span class="live-pill" class:on={apiOk} title="Ori API">
          <span class="dot" aria-hidden="true"></span>
          {apiOk ? "API live" : "API offline"}
        </span>
        <button
          type="button"
          class="menu-btn"
          aria-expanded={menuOpen}
          aria-controls="nav-mobile"
          aria-label={menuOpen ? "Close menu" : "Open menu"}
          onclick={() => (menuOpen = !menuOpen)}
        >
          <span class="burger" class:open={menuOpen} aria-hidden="true"></span>
        </button>
      </div>
    </div>

    {#if menuOpen}
      <nav class="nav-mob" id="nav-mobile" aria-label="Mobile">
        <a href="#features" onclick={closeMenu}>Features</a>
        <a href="#stack" onclick={closeMenu}>Stack</a>
        <a href="#contact" onclick={closeMenu}>Contact</a>
        <a
          href="https://github.com/raillen/ori-web-framework"
          target="_blank"
          rel="noreferrer"
          onclick={closeMenu}>GitHub</a
        >
      </nav>
    {/if}
  </header>

  <main id="top">
    <!-- Hero: asymmetric split -->
    <section class="hero">
      <div class="hero-copy">
        <p class="eyebrow">Svelte surface · Ori binary</p>
        <h1>
          Readable web apps,<br />
          <span class="hero-accent">one native process.</span>
        </h1>
        <p class="lede">
          This landing is a <strong>Svelte</strong> SPA. Static files and JSON APIs ship from
          <code>ori-web</code> — no Node runtime in production, CSRF and rate limits included.
        </p>
        <div class="cta-row">
          <a class="btn primary" href="#contact">Send a live request</a>
          <a class="btn ghost" href="#stack">See the pipeline</a>
        </div>
        <dl class="metrics">
          <div>
            <dt>Messages (this process)</dt>
            <dd>{stats ? stats.messages : "—"}</dd>
          </div>
          <div>
            <dt>Deploy target</dt>
            <dd>Fly.io · Linux AOT</dd>
          </div>
          <div>
            <dt>Session</dt>
            <dd>Cookie + CSRF</dd>
          </div>
        </dl>
      </div>

      <aside class="hero-panel" aria-label="Stack snapshot">
        <div class="panel-chrome">
          <span class="dot r"></span>
          <span class="dot y"></span>
          <span class="dot g"></span>
          <span class="panel-title">ori-landing</span>
        </div>
        <pre class="panel-code" aria-hidden="true"><code
            ><span class="c-muted"># production shape</span>
<span class="c-key">ori</span> compile main.orl <span class="c-op">-o</span> landing
<span class="c-key">fly</span> deploy

<span class="c-muted"># single binary serves</span>
<span class="c-str">GET</span>  /                 <span class="c-muted">→ Svelte SPA</span>
<span class="c-str">GET</span>  /api/csrf         <span class="c-muted">→ session token</span>
<span class="c-str">POST</span> /api/contact      <span class="c-muted">→ CSRF + form</span>
<span class="c-str">GET</span>  /healthz          <span class="c-muted">→ ok</span></code
          ></pre>
        <div class="panel-footer">
          <span class="chip">ubuntu:24.04</span>
          <span class="chip">PORT env</span>
          <span class="chip">0.0.0.0</span>
        </div>
      </aside>
    </section>

    <!-- Bento features (not 3 equal cards) -->
    <section class="section" id="features">
      <div class="section-head">
        <p class="eyebrow">Why this demo</p>
        <h2>Modern front, disciplined server</h2>
      </div>
      <div class="bento">
        <article class="tile tile-lg">
          <span class="tile-kicker">UI</span>
          <h3>Svelte for the surface</h3>
          <p>
            Interactive components and Vite DX. Build once into <code>public/</code> — Ori never
            embeds a JS runtime.
          </p>
          <ul class="ticks">
            <li>HMR via Vite proxy in dev</li>
            <li>Credentials + CSRF for forms</li>
            <li>No Marketplace lock-in</li>
          </ul>
        </article>
        <article class="tile">
          <span class="tile-kicker">Server</span>
          <h3>Ori on the edge of the host</h3>
          <p>One AOT binary: static, sessions, rate limit, health checks.</p>
        </article>
        <article class="tile">
          <span class="tile-kicker">Ops</span>
          <h3>Fly-ready by default</h3>
          <p>Bind <code>0.0.0.0</code> + <code>$PORT</code>. Scale to zero when idle.</p>
        </article>
        <article class="tile tile-wide">
          <span class="tile-kicker">Also available</span>
          <h3>HTML-first path with templates</h3>
          <p>
            Prefer server-rendered <code>.orix</code>? See
            <a href="https://ori-notes.fly.dev/" target="_blank" rel="noreferrer">ori-notes</a>
            — same brand stack, no SPA.
          </p>
        </article>
      </div>
    </section>

    <!-- Pipeline -->
    <section class="section" id="stack">
      <div class="section-head">
        <p class="eyebrow">Pipeline</p>
        <h2>How the pieces click</h2>
      </div>
      <ol class="pipeline">
        <li>
          <span class="step-num">01</span>
          <div>
            <h3>Build the UI</h3>
            <p class="mono">cd frontend && npm run build</p>
            <p>Emits hashed assets into <code>public/</code>.</p>
          </div>
        </li>
        <li>
          <span class="step-num">02</span>
          <div>
            <h3>Compile Ori</h3>
            <p class="mono">ori compile main.orl -o landing-page</p>
            <p>Native Linux binary + views/static next to it.</p>
          </div>
        </li>
        <li>
          <span class="step-num">03</span>
          <div>
            <h3>Ship</h3>
            <p class="mono">fly deploy</p>
            <p>Container serves SPA and <code>/api/*</code> from one process.</p>
          </div>
        </li>
      </ol>
    </section>

    <!-- Contact: split form -->
    <section class="section contact" id="contact">
      <div class="contact-grid">
        <div class="contact-copy">
          <p class="eyebrow">Live API</p>
          <h2>Hit the Ori backend</h2>
          <p class="lede-sm">
            This form posts to <code>POST /api/contact</code> with a token from
            <code>GET /api/csrf</code>. No fake “success” — the process must be up.
          </p>
          <ul class="ticks">
            <li>HttpOnly session cookie</li>
            <li>CSRF header + form field</li>
            <li>In-process message counter</li>
          </ul>
        </div>
        <form class="form-card" onsubmit={submitContact}>
          <label>
            <span>Email</span>
            <input
              type="email"
              bind:value={email}
              required
              autocomplete="email"
              placeholder="you@example.com"
            />
          </label>
          <label>
            <span>Message</span>
            <textarea
              bind:value={message}
              required
              rows="4"
              placeholder="Say something readable…"
            ></textarea>
          </label>
          <button type="submit" class="btn primary full" disabled={busy || !csrf}>
            {busy ? "Sending…" : "Send to Ori"}
          </button>
          {#if status}
            <p class="status" class:ok={statusKind === "ok"} class:err={statusKind === "err"} role="status">
              {status}
            </p>
          {/if}
        </form>
      </div>
    </section>
  </main>

  <footer class="foot">
    <div class="foot-inner">
      <p>
        <strong>ori-web-framework</strong> · landing demo ·
        <a href="https://ori-notes.fly.dev/">notes (templates)</a>
      </p>
      <p class="foot-meta">Brand: ink · tan · orange</p>
    </div>
  </footer>
</div>

<style>
  .shell {
    min-height: 100dvh;
    display: flex;
    flex-direction: column;
  }

  /* —— Header —— */
  .top {
    position: sticky;
    top: 0;
    z-index: 40;
    border-bottom: 1px solid color-mix(in srgb, var(--line) 80%, transparent);
    background: color-mix(in srgb, var(--paper) 82%, transparent);
    backdrop-filter: blur(14px) saturate(1.2);
  }

  .top-inner {
    width: min(100% - 2rem, var(--max));
    margin-inline: auto;
    min-height: 3.75rem;
    display: flex;
    align-items: center;
    gap: 1rem;
  }

  .brand {
    display: inline-flex;
    align-items: center;
    gap: 0.65rem;
    text-decoration: none;
    color: var(--ink);
    flex-shrink: 0;
  }

  .brand-mark {
    width: 1.85rem;
    height: 1.85rem;
    border-radius: 0.55rem;
    background:
      radial-gradient(circle at 30% 30%, color-mix(in srgb, var(--snow) 40%, var(--accent)), transparent 55%),
      linear-gradient(145deg, var(--accent), var(--accent-deep));
    box-shadow: 0 0 0 1px color-mix(in srgb, var(--accent-deep) 25%, transparent);
  }

  .brand-text {
    display: flex;
    flex-direction: column;
    line-height: 1.1;
  }

  .brand-name {
    font-weight: 700;
    letter-spacing: -0.03em;
    font-size: 1.05rem;
  }

  .brand-sub {
    font-size: 0.68rem;
    font-weight: 500;
    color: var(--muted);
    letter-spacing: 0.04em;
    text-transform: uppercase;
  }

  .nav-desk {
    display: none;
    align-items: center;
    gap: 0.15rem;
    margin-left: auto;
  }

  .nav-desk a {
    text-decoration: none;
    color: var(--muted);
    font-size: 0.9rem;
    font-weight: 500;
    padding: 0.4rem 0.7rem;
    border-radius: 999px;
  }

  .nav-desk a:hover {
    color: var(--ink);
    background: var(--tan-wash);
  }

  .nav-ext {
    color: var(--muted-2) !important;
  }

  .top-actions {
    display: flex;
    align-items: center;
    gap: 0.55rem;
    margin-left: auto;
  }

  .live-pill {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    font-size: 0.72rem;
    font-weight: 600;
    letter-spacing: 0.02em;
    color: var(--muted);
    padding: 0.3rem 0.65rem;
    border-radius: 999px;
    border: 1px solid var(--line);
    background: var(--card);
  }

  .live-pill.on {
    color: var(--ok);
    border-color: color-mix(in srgb, var(--ok) 35%, var(--line));
    background: color-mix(in srgb, var(--ok) 8%, var(--card));
  }

  .dot {
    width: 0.45rem;
    height: 0.45rem;
    border-radius: 50%;
    background: var(--muted-2);
  }

  .live-pill.on .dot {
    background: var(--ok);
    box-shadow: 0 0 0 3px color-mix(in srgb, var(--ok) 22%, transparent);
  }

  .menu-btn {
    display: grid;
    place-items: center;
    width: 2.35rem;
    height: 2.35rem;
    border: 1px solid var(--line);
    border-radius: var(--radius-sm);
    background: var(--card);
    cursor: pointer;
    padding: 0;
  }

  .burger,
  .burger::before,
  .burger::after {
    display: block;
    width: 1.05rem;
    height: 1.5px;
    background: var(--ink);
    border-radius: 1px;
    transition: transform 0.15s ease, opacity 0.15s ease;
  }

  .burger {
    position: relative;
  }

  .burger::before,
  .burger::after {
    content: "";
    position: absolute;
    left: 0;
  }

  .burger::before {
    top: -5px;
  }

  .burger::after {
    top: 5px;
  }

  .burger.open {
    background: transparent;
  }

  .burger.open::before {
    top: 0;
    transform: rotate(45deg);
  }

  .burger.open::after {
    top: 0;
    transform: rotate(-45deg);
  }

  .nav-mob {
    display: flex;
    flex-direction: column;
    gap: 0.15rem;
    width: min(100% - 2rem, var(--max));
    margin: 0 auto;
    padding: 0.35rem 0 0.85rem;
    border-top: 1px solid var(--line);
  }

  .nav-mob a {
    text-decoration: none;
    color: var(--ink-soft);
    font-weight: 500;
    padding: 0.7rem 0.5rem;
    border-radius: var(--radius-sm);
  }

  .nav-mob a:hover {
    background: var(--tan-wash);
  }

  @media (min-width: 860px) {
    .nav-desk {
      display: flex;
    }
    .menu-btn {
      display: none;
    }
    .top-actions {
      margin-left: 0.5rem;
    }
  }

  /* —— Main layout —— */
  main {
    width: min(100% - 2rem, var(--max));
    margin-inline: auto;
    flex: 1;
    padding-block: 2rem 4rem;
  }

  .eyebrow {
    margin: 0 0 0.65rem;
    font-size: 0.72rem;
    font-weight: 650;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--accent-deep);
  }

  h1 {
    margin: 0 0 1rem;
    font-size: clamp(2.1rem, 5.2vw, 3.35rem);
    font-weight: 700;
    letter-spacing: -0.04em;
    line-height: 1.08;
  }

  .hero-accent {
    color: var(--accent-deep);
    background: linear-gradient(105deg, var(--accent-deep), var(--accent));
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
  }

  /* fallback if clip unsupported */
  @supports not (background-clip: text) {
    .hero-accent {
      color: var(--accent-deep);
      background: none;
    }
  }

  h2 {
    margin: 0;
    font-size: clamp(1.45rem, 2.5vw, 1.85rem);
    letter-spacing: -0.03em;
    font-weight: 700;
  }

  h3 {
    margin: 0 0 0.45rem;
    font-size: 1.05rem;
    letter-spacing: -0.02em;
    font-weight: 650;
  }

  .lede {
    margin: 0 0 1.4rem;
    max-width: 34rem;
    color: var(--muted);
    font-size: 1.08rem;
    line-height: 1.6;
  }

  .lede-sm {
    margin: 0 0 1.1rem;
    color: var(--muted);
    font-size: 0.98rem;
    max-width: 28rem;
  }

  .cta-row {
    display: flex;
    flex-wrap: wrap;
    gap: 0.65rem;
    margin-bottom: 1.75rem;
  }

  .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.72rem 1.15rem;
    border-radius: 999px;
    font: inherit;
    font-weight: 600;
    font-size: 0.92rem;
    text-decoration: none;
    border: 1px solid transparent;
    cursor: pointer;
    transition: transform 0.12s ease, box-shadow 0.12s ease, background 0.12s ease;
  }

  .btn:active {
    transform: scale(0.98);
  }

  .btn.primary {
    background: var(--accent);
    color: var(--snow);
    border-color: color-mix(in srgb, var(--accent-deep) 40%, var(--accent));
    box-shadow: 0 1px 0 color-mix(in srgb, var(--snow) 25%, transparent) inset,
      0 8px 24px color-mix(in srgb, var(--accent) 28%, transparent);
  }

  .btn.primary:hover {
    background: var(--accent-deep);
  }

  .btn.primary:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    box-shadow: none;
  }

  .btn.ghost {
    background: var(--card);
    color: var(--ink);
    border-color: var(--line);
  }

  .btn.ghost:hover {
    border-color: var(--line-strong);
    background: var(--tan-wash);
  }

  .btn.full {
    width: 100%;
  }

  /* —— Hero —— */
  .hero {
    display: grid;
    gap: 2rem;
    margin-bottom: 4rem;
    align-items: start;
  }

  @media (min-width: 960px) {
    .hero {
      grid-template-columns: minmax(0, 1.1fr) minmax(0, 0.9fr);
      gap: 2.5rem;
      align-items: center;
      min-height: min(72dvh, 36rem);
    }
  }

  .metrics {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 0.75rem;
    margin: 0;
    padding: 0;
  }

  .metrics > div {
    padding: 0.75rem 0.85rem;
    border-radius: var(--radius-sm);
    border: 1px solid var(--line);
    background: color-mix(in srgb, var(--card) 88%, transparent);
  }

  .metrics dt {
    margin: 0 0 0.25rem;
    font-size: 0.68rem;
    font-weight: 600;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    color: var(--muted-2);
  }

  .metrics dd {
    margin: 0;
    font-size: 0.92rem;
    font-weight: 650;
    letter-spacing: -0.02em;
    font-variant-numeric: tabular-nums;
  }

  .hero-panel {
    border-radius: calc(var(--radius) + 4px);
    border: 1px solid var(--line);
    background: linear-gradient(165deg, var(--ink) 0%, #1c1917 100%);
    color: color-mix(in srgb, var(--snow) 92%, var(--tan));
    box-shadow: var(--shadow);
    overflow: hidden;
  }

  .panel-chrome {
    display: flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.75rem 1rem;
    border-bottom: 1px solid color-mix(in srgb, var(--tan) 18%, transparent);
    background: color-mix(in srgb, #000 25%, transparent);
  }

  .panel-chrome .dot {
    width: 0.55rem;
    height: 0.55rem;
    border-radius: 50%;
  }

  .panel-chrome .r {
    background: #e06c5c;
  }
  .panel-chrome .y {
    background: #e0b35c;
  }
  .panel-chrome .g {
    background: #6cb86a;
  }

  .panel-title {
    margin-left: 0.5rem;
    font-family: var(--mono);
    font-size: 0.72rem;
    color: color-mix(in srgb, var(--snow) 55%, var(--tan));
  }

  .panel-code {
    margin: 0;
    padding: 1.1rem 1.15rem 1.25rem;
    font-family: var(--mono);
    font-size: 0.78rem;
    line-height: 1.65;
    overflow-x: auto;
  }

  .panel-code code {
    font-size: inherit;
  }

  .c-muted {
    color: color-mix(in srgb, var(--snow) 38%, var(--tan));
  }
  .c-key {
    color: var(--accent);
  }
  .c-op {
    color: var(--tan);
  }
  .c-str {
    color: #7ec8a3;
  }

  .panel-footer {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
    padding: 0.75rem 1rem 1rem;
    border-top: 1px solid color-mix(in srgb, var(--tan) 14%, transparent);
  }

  .chip {
    font-size: 0.68rem;
    font-weight: 600;
    font-family: var(--mono);
    padding: 0.25rem 0.5rem;
    border-radius: 999px;
    border: 1px solid color-mix(in srgb, var(--tan) 30%, transparent);
    color: color-mix(in srgb, var(--snow) 75%, var(--tan));
  }

  /* —— Sections —— */
  .section {
    margin-bottom: 4rem;
  }

  .section-head {
    margin-bottom: 1.35rem;
    max-width: 36rem;
  }

  .section-head h2 {
    margin-top: 0.15rem;
  }

  /* Bento */
  .bento {
    display: grid;
    gap: 0.85rem;
    grid-template-columns: 1fr;
  }

  @media (min-width: 720px) {
    .bento {
      grid-template-columns: 1.35fr 1fr;
      grid-template-rows: auto auto auto;
    }
    .tile-lg {
      grid-row: span 2;
    }
    .tile-wide {
      grid-column: 1 / -1;
    }
  }

  .tile {
    padding: 1.25rem 1.3rem;
    border-radius: var(--radius);
    border: 1px solid var(--line);
    background: var(--card);
    box-shadow: 0 1px 0 color-mix(in srgb, var(--snow) 80%, transparent) inset;
  }

  .tile-lg {
    background:
      linear-gradient(145deg, color-mix(in srgb, var(--accent) 8%, var(--card)), var(--card) 45%),
      var(--card);
    border-color: color-mix(in srgb, var(--accent) 22%, var(--line));
  }

  .tile-kicker {
    display: inline-block;
    margin-bottom: 0.55rem;
    font-size: 0.68rem;
    font-weight: 700;
    letter-spacing: 0.07em;
    text-transform: uppercase;
    color: var(--accent-deep);
  }

  .tile p {
    margin: 0;
    color: var(--muted);
    font-size: 0.95rem;
  }

  .ticks {
    margin: 1rem 0 0;
    padding: 0;
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
  }

  .ticks li {
    position: relative;
    padding-left: 1.2rem;
    font-size: 0.9rem;
    color: var(--ink-soft);
  }

  .ticks li::before {
    content: "";
    position: absolute;
    left: 0;
    top: 0.45rem;
    width: 0.45rem;
    height: 0.45rem;
    border-radius: 50%;
    background: var(--accent);
    box-shadow: 0 0 0 3px var(--accent-soft);
  }

  /* Pipeline */
  .pipeline {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    gap: 0.75rem;
  }

  @media (min-width: 800px) {
    .pipeline {
      grid-template-columns: repeat(3, 1fr);
      gap: 1rem;
    }
  }

  .pipeline li {
    display: flex;
    gap: 0.9rem;
    padding: 1.15rem 1.2rem;
    border-radius: var(--radius);
    border: 1px solid var(--line);
    background: var(--card);
  }

  .step-num {
    font-family: var(--mono);
    font-size: 0.85rem;
    font-weight: 600;
    color: var(--accent);
    flex-shrink: 0;
  }

  .pipeline h3 {
    margin-bottom: 0.35rem;
  }

  .pipeline p {
    margin: 0.25rem 0 0;
    color: var(--muted);
    font-size: 0.9rem;
  }

  .pipeline .mono {
    margin: 0;
    font-size: 0.78rem;
    color: var(--ink-soft);
    padding: 0.35rem 0.5rem;
    border-radius: 0.4rem;
    background: var(--paper-deep);
    border: 1px solid var(--line);
    display: inline-block;
    max-width: 100%;
    overflow-x: auto;
  }

  /* Contact */
  .contact-grid {
    display: grid;
    gap: 1.5rem;
  }

  @media (min-width: 840px) {
    .contact-grid {
      grid-template-columns: 1fr 1.05fr;
      gap: 2.5rem;
      align-items: start;
    }
  }

  .form-card {
    display: flex;
    flex-direction: column;
    gap: 0.95rem;
    padding: 1.35rem 1.4rem 1.5rem;
    border-radius: calc(var(--radius) + 2px);
    border: 1px solid var(--line);
    background: var(--card);
    box-shadow: var(--shadow);
  }

  label {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
    font-size: 0.82rem;
    font-weight: 650;
    color: var(--ink-soft);
  }

  input,
  textarea {
    font: inherit;
    font-weight: 400;
    padding: 0.7rem 0.85rem;
    border: 1px solid var(--line);
    border-radius: var(--radius-sm);
    background: var(--snow);
    color: var(--ink);
    transition: border-color 0.12s ease, box-shadow 0.12s ease;
  }

  input::placeholder,
  textarea::placeholder {
    color: var(--muted-2);
  }

  input:focus,
  textarea:focus {
    outline: none;
    border-color: var(--accent);
    box-shadow: 0 0 0 3px var(--accent-soft);
  }

  .status {
    margin: 0;
    font-size: 0.88rem;
    font-weight: 500;
  }

  .status.ok {
    color: var(--ok);
  }

  .status.err {
    color: var(--danger);
  }

  /* Footer */
  .foot {
    border-top: 1px solid var(--line);
    background: color-mix(in srgb, var(--paper-deep) 55%, transparent);
    margin-top: auto;
  }

  .foot-inner {
    width: min(100% - 2rem, var(--max));
    margin-inline: auto;
    padding: 1.35rem 0;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    gap: 0.5rem 1.5rem;
    font-size: 0.85rem;
    color: var(--muted);
  }

  .foot-inner p {
    margin: 0;
  }

  .foot-inner a {
    color: var(--ink-soft);
    font-weight: 500;
  }

  .foot-meta {
    font-family: var(--mono);
    font-size: 0.75rem !important;
    color: var(--muted-2) !important;
  }
</style>
