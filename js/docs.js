// Enhancements for the DocBook-generated manuals in /doc/: a sticky sidebar
// table of contents with scroll tracking, heading anchors and copy buttons
// on code blocks. Without JS the built-in TOC is used.
(function () {
  var doc = document.querySelector('body.is-doc > .book, body.is-doc > .refentry, body.is-doc > .article');
  if (!doc) return;

  function titleOf(el) {
    var h = el.querySelector(':scope > .titlepage h1, :scope > .titlepage h2, :scope > .titlepage h3, :scope > h2');
    return h;
  }

  // Collect navigable sections: chapters with their sections (manual),
  // or refsect1 blocks (manual pages).
  var items = [];
  function add(el, level, label, num) {
    if (!el.id) return;
    items.push({ el: el, level: level, label: label, num: num });
  }
  var chapters = doc.querySelectorAll(':scope > .chapter');
  if (chapters.length) {
    chapters.forEach(function (ch, i) {
      var h = titleOf(ch);
      add(ch, 1, h ? h.textContent.trim() : '', String(i + 1));
      ch.querySelectorAll(':scope > .section').forEach(function (s) {
        var sh = titleOf(s);
        if (sh) add(s, 2, sh.textContent.trim());
      });
    });
  } else {
    doc.querySelectorAll(':scope > .refsynopsisdiv, :scope > .refsect1').forEach(function (s) {
      var sh = s.querySelector(':scope > h2');
      if (!s.id && sh) s.id = sh.textContent.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-');
      if (!sh) return;
      var t = sh.textContent.trim();
      if (t === t.toUpperCase()) t = t.charAt(0) + t.slice(1).toLowerCase();
      add(s, 1, t);
    });
  }

  // Heading anchors.
  items.forEach(function (it) {
    var h = titleOf(it.el);
    if (!h || h.querySelector('.anchor')) return;
    var a = document.createElement('a');
    a.className = 'anchor';
    a.href = '#' + it.el.id;
    a.setAttribute('aria-label', 'Link to this section');
    a.textContent = '#';
    h.appendChild(a);
  });

  // Copy buttons.
  doc.querySelectorAll('pre.programlisting, pre.screen').forEach(function (pre) {
    var wrap = document.createElement('div');
    wrap.className = 'code-wrap';
    pre.parentNode.insertBefore(wrap, pre);
    wrap.appendChild(pre);
    if (!navigator.clipboard) return;
    var b = document.createElement('button');
    b.type = 'button';
    b.className = 'copy';
    b.textContent = 'Copy';
    b.addEventListener('click', function () {
      navigator.clipboard.writeText(pre.innerText).then(function () {
        b.textContent = 'Copied';
        setTimeout(function () { b.textContent = 'Copy'; }, 1500);
      });
    });
    wrap.appendChild(b);
  });

  if (items.length < 3) return;

  // Sidebar.
  var layout = document.createElement('div');
  layout.className = 'doc-layout';
  var aside = document.createElement('aside');
  aside.className = 'doc-sidebar';
  var nav = document.createElement('nav');
  nav.setAttribute('aria-label', 'Contents');
  nav.innerHTML = '<p class="doc-sidebar-title">On this page</p>';
  var ul = document.createElement('ul');
  var links = {};
  items.forEach(function (it) {
    var li = document.createElement('li');
    li.className = 'lvl-' + it.level;
    var a = document.createElement('a');
    a.href = '#' + it.el.id;
    if (it.num) {
      var n = document.createElement('span');
      n.className = 'num';
      n.textContent = it.num;
      a.appendChild(n);
    }
    a.appendChild(document.createTextNode(it.label));
    li.appendChild(a);
    ul.appendChild(li);
    links[it.el.id] = a;
  });
  nav.appendChild(ul);
  aside.appendChild(nav);
  doc.parentNode.insertBefore(layout, doc);
  layout.appendChild(aside);
  layout.appendChild(doc);
  document.body.classList.add('has-sidebar');

  // Track the section in view.
  var current = null;
  function setActive(id) {
    if (current === id || !links[id]) return;
    if (current && links[current]) links[current].classList.remove('active');
    links[id].classList.add('active');
    current = id;
    var r = links[id].getBoundingClientRect(), nr = nav.getBoundingClientRect();
    if (r.top < nr.top || r.bottom > nr.bottom) links[id].scrollIntoView({ block: 'nearest' });
  }
  function onScroll() {
    var y = 100, best = items[0];
    for (var i = 0; i < items.length; i++) {
      if (items[i].el.getBoundingClientRect().top - y <= 0) best = items[i];
      else break;
    }
    setActive(best.el.id);
  }
  var ticking = false;
  window.addEventListener('scroll', function () {
    if (!ticking) {
      ticking = true;
      requestAnimationFrame(function () { ticking = false; onScroll(); });
    }
  }, { passive: true });
  onScroll();
})();
