/**
 * Minimal Markdown toolbar — inserts syntax around selection.
 * No eval, no CDN, no HTML injection.
 */
(function () {
  function wrap(ta, before, after, placeholder) {
    const start = ta.selectionStart;
    const end = ta.selectionEnd;
    const value = ta.value;
    const selected = value.slice(start, end) || placeholder || "";
    const next = value.slice(0, start) + before + selected + after + value.slice(end);
    ta.value = next;
    const cursor = start + before.length + selected.length;
    ta.focus();
    ta.setSelectionRange(start + before.length, cursor);
  }

  function onClick(btn, ta) {
    const kind = btn.getAttribute("data-md");
    if (kind === "bold") wrap(ta, "**", "**", "bold");
    else if (kind === "italic") wrap(ta, "*", "*", "italic");
    else if (kind === "code") wrap(ta, "`", "`", "code");
    else if (kind === "h2") wrap(ta, "## ", "", "Heading");
    else if (kind === "list") wrap(ta, "- ", "", "item");
    else if (kind === "link") wrap(ta, "[", "](https://)", "label");
    else if (kind === "fence") wrap(ta, "```\n", "\n```", "code");
  }

  document.querySelectorAll("[data-md-toolbar]").forEach(function (bar) {
    const id = bar.getAttribute("data-target");
    const ta = id ? document.getElementById(id) : null;
    if (!ta) return;
    bar.querySelectorAll("button[data-md]").forEach(function (btn) {
      btn.addEventListener("click", function (e) {
        e.preventDefault();
        onClick(btn, ta);
      });
    });
  });
})();
