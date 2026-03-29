/**
 * scroll-story.js (Optimized)
 * Single IntersectionObserver for section reveals.
 * NO scroll event listener, NO rAF loop, NO parallax engine.
 * Zero layout reflows — uses compositor-safe CSS class toggles only.
 */
(function () {
  'use strict';

  var prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // Select all portfolio sections
  var sections = document.querySelectorAll('section[id^="section-"]');

  if (prefersReduced) {
    // Just make everything visible immediately
    sections.forEach(function (s) { s.classList.add('story-visible'); });
    return;
  }

  // Tag sections as hidden (start state)
  sections.forEach(function (s) { s.classList.add('story-hidden'); });

  // Single IntersectionObserver — no scroll listener needed
  var observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        entry.target.classList.remove('story-hidden');
        entry.target.classList.add('story-visible');
        // Unobserve after reveal — saves CPU
        observer.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.08,          // Trigger early — feels snappier
    rootMargin: '0px 0px -40px 0px'
  });

  sections.forEach(function (s) { observer.observe(s); });

})();
