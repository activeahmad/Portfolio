/**
 * cursor.js (Optimized)
 * CSS-transition cursor — NO rAF loop, NO setInterval.
 * Uses CSS custom properties + transition to move cursor elements.
 * Touch/mobile: completely skipped.
 */
(function () {
  'use strict';

  var isTouchDevice = ('ontouchstart' in window) || navigator.maxTouchPoints > 0 || window.innerWidth < 769;
  if (isTouchDevice) return;
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  // ─── Build cursor elements ───
  var dot  = document.createElement('div');
  var ring = document.createElement('div');
  dot.className  = 'cursor-dot';
  ring.className = 'cursor-ring';
  document.body.appendChild(dot);
  document.body.appendChild(ring);

  // ─── Move via CSS vars (single style write per frame) ───
  // dot uses a very short CSS transition (0.06s) — feels instant
  // ring uses a longer CSS transition (0.22s) — feels smooth
  Object.assign(dot.style, {
    transition: 'left 0.06s ease-out, top 0.06s ease-out',
    left: '-100px', top: '-100px'
  });
  Object.assign(ring.style, {
    transition: 'left 0.22s ease-out, top 0.22s ease-out',
    left: '-100px', top: '-100px'
  });

  // ─── Single passive mousemove listener ───
  document.addEventListener('mousemove', function (e) {
    var x = e.clientX + 'px';
    var y = e.clientY + 'px';
    dot.style.left  = x;
    dot.style.top   = y;
    ring.style.left = x;
    ring.style.top  = y;
  }, { passive: true });

  // ─── Hover states via event delegation (one listener, not per-element) ───
  document.addEventListener('mouseover', function (e) {
    if (e.target.closest('a, button, [role="button"], [class*="glass-card-"], .logo-container, .logo-item')) {
      document.body.classList.add('cursor-hover');
    }
  }, { passive: true });

  document.addEventListener('mouseout', function (e) {
    if (e.target.closest('a, button, [role="button"], [class*="glass-card-"], .logo-container, .logo-item')) {
      document.body.classList.remove('cursor-hover');
    }
  }, { passive: true });

})();
