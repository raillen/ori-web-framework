<script>
  import { onMount } from "svelte";

  let csrf = $state("");
  let email = $state("");
  let message = $state("");
  let status = $state("");
  let busy = $state(false);
  let stats = $state(null);

  onMount(async () => {
    try {
      const r = await fetch("/api/csrf", { credentials: "include" });
      const j = await r.json();
      csrf = j.csrf_token || "";
      const s = await fetch("/api/stats", { credentials: "include" });
      stats = await s.json();
    } catch {
      status = "API offline — start Ori (`ori run main.orl`) or use the Vite proxy.";
    }
  });

  async function submitContact(e) {
    e.preventDefault();
    busy = true;
    status = "";
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
        status = j.error || "Could not send message.";
      } else {
        status = "Thanks — message received by the Ori backend.";
        message = "";
        const s = await fetch("/api/stats", { credentials: "include" });
        stats = await s.json();
      }
    } catch {
      status = "Network error talking to Ori.";
    } finally {
      busy = false;
    }
  }
</script>

<div class="page">
  <header class="nav">
    <a class="brand" href="#top">
      <span class="mark" aria-hidden="true">◎</span>
      Ori
    </a>
    <nav>
      <a href="#features">Features</a>
      <a href="#stack">Stack</a>
      <a href="#contact">Contact</a>
    </nav>
  </header>

  <main id="top">
    <section class="hero">
      <p class="eyebrow">Svelte UI · Ori server</p>
      <h1>Readable web apps, shipped as real HTTP.</h1>
      <p class="lede">
        This landing is a <strong>Svelte</strong> SPA. Static assets and JSON APIs are
        served by <code>ori-web</code> — same process, no Node in production.
      </p>
      <div class="cta-row">
        <a class="btn primary" href="#contact">Try the contact form</a>
        <a class="btn ghost" href="https://github.com/raillen/ori-web-framework" target="_blank" rel="noreferrer">
          Framework repo
        </a>
      </div>
      {#if stats}
        <p class="stat">Messages received this process: <strong>{stats.messages}</strong></p>
      {/if}
    </section>

    <section class="features" id="features">
      <h2>Why this demo</h2>
      <div class="grid">
        <article class="card">
          <h3>Svelte for the surface</h3>
          <p>Interactive UI, components, and build via Vite — familiar frontend DX.</p>
        </article>
        <article class="card">
          <h3>Ori for the edge</h3>
          <p>Single native binary: static files, CSRF session, rate limit, health checks.</p>
        </article>
        <article class="card">
          <h3>Fly-ready</h3>
          <p>Bind <code>0.0.0.0</code> + <code>PORT</code>. Scale to zero free tier friendly.</p>
        </article>
      </div>
    </section>

    <section class="stack" id="stack">
      <h2>How it fits together</h2>
      <ol class="steps">
        <li><code>cd frontend && npm run build</code> → emits into <code>public/</code></li>
        <li><code>ori run main.orl</code> serves <code>public/</code> + <code>/api/*</code></li>
        <li>Deploy the binary + <code>public/</code> on Fly</li>
      </ol>
      <p class="hint">
        For server-rendered HTML with our template engine, see
        <code>demos/ori-notes</code> instead.
      </p>
    </section>

    <section class="contact" id="contact">
      <h2>Contact (hits Ori)</h2>
      <p class="lede-sm">
        POST <code>/api/contact</code> with CSRF from <code>/api/csrf</code>.
      </p>
      <form class="card form" onsubmit={submitContact}>
        <label>
          Email
          <input type="email" bind:value={email} required autocomplete="email" placeholder="you@example.com" />
        </label>
        <label>
          Message
          <textarea bind:value={message} required rows="4" placeholder="Say hello…"></textarea>
        </label>
        <button type="submit" class="btn primary" disabled={busy || !csrf}>
          {busy ? "Sending…" : "Send"}
        </button>
        {#if status}
          <p class="status" role="status">{status}</p>
        {/if}
      </form>
    </section>
  </main>

  <footer class="foot">
    <p>ori-web-framework · landing-page demo</p>
  </footer>
</div>

<style>
  .page {
    max-width: 52rem;
    margin: 0 auto;
    padding: 1.25rem 1.25rem 3rem;
  }

  .nav {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
    padding: 0.5rem 0 1.5rem;
    border-bottom: 1px solid var(--line);
    margin-bottom: 2rem;
  }

  .brand {
    display: inline-flex;
    align-items: center;
    gap: 0.45rem;
    text-decoration: none;
    color: var(--ink);
    font-weight: 700;
    letter-spacing: -0.02em;
  }

  .mark {
    color: var(--accent);
  }

  nav {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
  }

  nav a {
    text-decoration: none;
    color: var(--muted);
    font-size: 0.92rem;
    font-weight: 500;
  }

  nav a:hover {
    color: var(--ink);
  }

  .eyebrow {
    margin: 0 0 0.5rem;
    font-size: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: var(--accent-deep);
  }

  h1 {
    margin: 0 0 0.85rem;
    font-size: clamp(1.85rem, 4vw, 2.55rem);
    letter-spacing: -0.035em;
    line-height: 1.15;
  }

  h2 {
    margin: 0 0 1rem;
    font-size: 1.25rem;
    letter-spacing: -0.02em;
  }

  h3 {
    margin: 0 0 0.4rem;
    font-size: 1rem;
  }

  .lede {
    margin: 0 0 1.25rem;
    max-width: 36rem;
    color: var(--muted);
    font-size: 1.05rem;
  }

  .lede-sm {
    margin: 0 0 1rem;
    color: var(--muted);
    font-size: 0.92rem;
  }

  .cta-row {
    display: flex;
    flex-wrap: wrap;
    gap: 0.65rem;
    margin-bottom: 1rem;
  }

  .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.6rem 1rem;
    border-radius: 0.6rem;
    font: inherit;
    font-weight: 600;
    font-size: 0.92rem;
    text-decoration: none;
    border: 1px solid transparent;
    cursor: pointer;
  }

  .btn.primary {
    background: var(--accent);
    color: #fff;
    border-color: var(--accent);
  }

  .btn.primary:disabled {
    opacity: 0.55;
    cursor: not-allowed;
  }

  .btn.ghost {
    background: transparent;
    color: var(--ink);
    border-color: var(--line);
  }

  .stat {
    font-size: 0.88rem;
    color: var(--muted);
  }

  .hero {
    margin-bottom: 3rem;
  }

  .features,
  .stack,
  .contact {
    margin-bottom: 2.75rem;
  }

  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(14rem, 1fr));
    gap: 0.85rem;
  }

  .card {
    background: var(--card);
    border: 1px solid var(--line);
    border-radius: 0.9rem;
    padding: 1.1rem 1.15rem;
    box-shadow: 0 1px 2px color-mix(in srgb, var(--ink) 6%, transparent);
  }

  .card p {
    margin: 0;
    color: var(--muted);
    font-size: 0.92rem;
  }

  .steps {
    margin: 0 0 1rem;
    padding-left: 1.2rem;
    color: var(--muted);
  }

  .steps li {
    margin-bottom: 0.35rem;
  }

  .hint {
    margin: 0;
    font-size: 0.88rem;
    color: var(--muted);
  }

  .form {
    display: flex;
    flex-direction: column;
    gap: 0.85rem;
    max-width: 28rem;
  }

  label {
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
    font-size: 0.85rem;
    font-weight: 600;
  }

  input,
  textarea {
    font: inherit;
    font-weight: 400;
    padding: 0.55rem 0.7rem;
    border: 1px solid var(--line);
    border-radius: 0.5rem;
    background: #fff;
  }

  input:focus,
  textarea:focus {
    outline: none;
    border-color: var(--accent);
    box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 20%, transparent);
  }

  .status {
    margin: 0;
    font-size: 0.88rem;
    color: var(--ok);
  }

  .foot {
    border-top: 1px solid var(--line);
    padding-top: 1rem;
    color: var(--muted);
    font-size: 0.82rem;
  }

  .foot p {
    margin: 0;
  }
</style>
