// Performance: Skip heavy canvas animations on mobile
var isMobile = window.innerWidth < 768 || /Mobi|Android/i.test(navigator.userAgent);

// Theme-aware particle color function
function getParticleColor(opacity) {
  const isDark = document.documentElement.classList.contains('dark');
  console.log('Particle color check - Dark mode:', isDark, 'Opacity:', opacity);
  if (isDark) {
    return `rgba(255, 255, 255, ${opacity})`;
  } else {
    return `rgba(0, 0, 0, ${opacity})`; // Black particles for light mode
  }
}

// Force particle redraw when theme changes
function onThemeChange() {
  // Force all canvases to redraw by triggering resize
  const canvases = ['particle-canvas-0', 'particles-js-1', 'particle-canvas-2', 'particleCanvas-3', 'particleCanvas-4'];
  canvases.forEach(canvasId => {
    const canvas = document.getElementById(canvasId);
    if (canvas) {
      const event = new Event('resize');
      window.dispatchEvent(event);
    }
  });
}

// Listen for theme changes
const observer = new MutationObserver((mutations) => {
  mutations.forEach((mutation) => {
    if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
      onThemeChange();
    }
  });
});
observer.observe(document.documentElement, { attributes: true });

// Performance: rAF-throttled mousemove utility
var _rafMousePending = false;
function throttledMouseMove(canvas, cb) {
  document.addEventListener('mousemove', function(e) {
    if (_rafMousePending) return;
    _rafMousePending = true;
    requestAnimationFrame(function() {
      _rafMousePending = false;
      cb(e);
    });
  }, { passive: true });
}

if (!isMobile) { (function() {
(function() {
const canvas = document.getElementById('particle-canvas-0');
    const ctx = canvas.getContext('2d');
    let particles = [];
    let mouse = { x: null, y: null, radius: 150 };

    window.addEventListener('mousemove', function(event) {
      mouse.x = event.x;
      mouse.y = event.y;
    });

    function resize() {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }
    window.addEventListener('resize', resize);
    resize();

    class Particle {
      constructor() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 2 + 1;
        this.baseX = this.x;
        this.baseY = this.y;
        this.density = (Math.random() * 30) + 1;
        this.velocity = {
          x: (Math.random() - 0.5) * 0.5,
          y: (Math.random() - 0.5) * 0.5
        };
      }

      draw() {
        ctx.fillStyle = getParticleColor('0.8');
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.closePath();
        ctx.fill();
        
        // Add a small glow to the node
        ctx.shadowBlur = 10;
        const isDark = document.documentElement.classList.contains('dark');
        ctx.shadowColor = isDark ? 'white' : 'black';
      }

      update() {
        // Natural movement
        this.x += this.velocity.x;
        this.y += this.velocity.y;

        // Bounce off walls
        if (this.x > canvas.width || this.x < 0) this.velocity.x *= -1;
        if (this.y > canvas.height || this.y < 0) this.velocity.y *= -1;

        // Mouse interaction
        let dx = mouse.x - this.x;
        let dy = mouse.y - this.y;
        let distance = Math.sqrt(dx * dx + dy * dy);
        let forceDirectionX = dx / distance;
        let forceDirectionY = dy / distance;
        let maxDistance = mouse.radius;
        let force = (maxDistance - distance) / maxDistance;
        let directionX = forceDirectionX * force * this.density;
        let directionY = forceDirectionY * force * this.density;

        if (distance < mouse.radius) {
          this.x -= directionX;
          this.y -= directionY;
        }
      }
    }

    function init() {
      particles = [];
      let numberOfParticles = (canvas.height * canvas.width) / 9000;
      for (let i = 0; i < numberOfParticles; i++) {
        particles.push(new Particle());
      }
    }

    function connect() {
      let opacityValue = 1;
      for (let a = 0; a < particles.length; a++) {
        for (let b = a; b < particles.length; b++) {
          let dx = particles[a].x - particles[b].x;
          let dy = particles[a].y - particles[b].y;
          let distance = Math.sqrt(dx * dx + dy * dy);

          if (distance < 150) {
            opacityValue = 1 - (distance / 150);
            ctx.strokeStyle = getParticleColor(opacityValue * 0.2);
            ctx.lineWidth = 1;
            ctx.beginPath();
            ctx.moveTo(particles[a].x, particles[a].y);
            ctx.lineTo(particles[b].x, particles[b].y);
            ctx.stroke();
          }
        }
      }
    }

    function animate() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.shadowBlur = 0; // Reset shadow for background lines
      for (let i = 0; i < particles.length; i++) {
        particles[i].update();
        particles[i].draw();
      }
      connect();
      requestAnimationFrame(animate);
    }

    init();
    animate();
})();
})(); }

if (!isMobile) { (function() {
(function() {
/**
     * Subtle Particle Background Logic
     */
    const canvas = document.getElementById('particles-js-1');
    const ctx = canvas.getContext('2d');
    let particles = [];

    function resize() {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }

    class Particle {
      constructor() {
        this.reset();
      }
      reset() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 1.5;
        this.speedX = (Math.random() - 0.5) * 0.3;
        this.speedY = (Math.random() - 0.5) * 0.3;
        this.opacity = Math.random() * 0.5;
      }
      update() {
        this.x += this.speedX;
        this.y += this.speedY;
        if (this.x > canvas.width || this.x < 0) this.speedX *= -1;
        if (this.y > canvas.height || this.y < 0) this.speedY *= -1;
      }
      draw() {
        ctx.fillStyle = getParticleColor(this.opacity);
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
      }
    }

    function init() {
      resize();
      particles = [];
      for (let i = 0; i < 80; i++) {
        particles.push(new Particle());
      }
    }

    function animate() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      particles.forEach(p => {
        p.update();
        p.draw();
      });
      requestAnimationFrame(animate);
    }

    window.addEventListener('resize', init);
    init();
    animate();
})();
})(); }

(function() {
(function() {
/**
     * 3D Floating / Tilt Effect for Panels
     */
    const cards = document.querySelectorAll('.glass-card-1');
    
    document.addEventListener('mousemove', (e) => {
      const { clientX, clientY } = e;
      const centerX = window.innerWidth / 2;
      const centerY = window.innerHeight / 2;

      cards.forEach(card => {
        const rect = card.getBoundingClientRect();
        const cardCenterX = rect.left + rect.width / 2;
        const cardCenterY = rect.top + rect.height / 2;

        // Calculate distance from cursor to card center
        const deltaX = (clientX - cardCenterX) / 25;
        const deltaY = (clientY - cardCenterY) / 25;

        // Apply a gentle tilt relative to the cursor position
        card.style.transform = `rotateY(${deltaX}deg) rotateX(${-deltaY}deg) translateY(${-deltaY * 0.5}px)`;
      });
    });

    // Reset transform on mouse leave container (if needed)
    document.querySelector('.perspective-container-1').addEventListener('mouseleave', () => {
      cards.forEach(card => {
        card.style.transform = `rotateY(0deg) rotateX(0deg) translateY(0px)`;
      });
    });
})();
})();

if (!isMobile) { (function() {
(function() {
const canvas = document.getElementById('particle-canvas-2');
    const ctx = canvas.getContext('2d');
    let particles = [];

    function resize() {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }

    class Particle {
      constructor() {
        this.reset();
      }
      reset() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 1.5 + 0.1;
        this.speedY = Math.random() * 0.2 + 0.05;
        this.opacity = Math.random() * 0.5 + 0.1;
      }
      update() {
        this.y -= this.speedY;
        if (this.y < 0) this.reset();
      }
      draw() {
        ctx.fillStyle = getParticleColor(this.opacity);
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
      }
    }

    function init() {
      resize();
      particles = [];
      for (let i = 0; i < 100; i++) {
        particles.push(new Particle());
      }
    }

    function animate() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      particles.forEach(p => {
        p.update();
        p.draw();
      });
      requestAnimationFrame(animate);
    }

    window.addEventListener('resize', init);
    init();
    animate();
})();
})(); }

(function() {
(function() {
// Optional: Pause animation on hover
    const track = document.querySelector('.carousel-track');
    track.addEventListener('mouseenter', () => {
      track.style.animationPlayState = 'paused';
    });
    track.addEventListener('mouseleave', () => {
      track.style.animationPlayState = 'running';
    });
})();
})();

if (!isMobile) { (function() {
(function() {
const canvas = document.getElementById('particleCanvas-3');
    const ctx = canvas.getContext('2d');
    
    let particles = [];
    const particleCount = 100;

    function init() {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
      for (let i = 0; i < particleCount; i++) {
        particles.push({
          x: Math.random() * canvas.width,
          y: Math.random() * canvas.height,
          size: Math.random() * 1.5,
          speed: Math.random() * 0.5 + 0.2,
          opacity: Math.random() * 0.5
        });
      }
    }

    function animate() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      
      particles.forEach(p => {
        ctx.fillStyle = getParticleColor(p.opacity);
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
        ctx.fill();

        p.y -= p.speed;
        if (p.y < 0) {
          p.y = canvas.height;
          p.x = Math.random() * canvas.width;
        }
      });
      requestAnimationFrame(animate);
    }

    window.addEventListener('resize', () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    });

    init();
    animate();
})();
})(); }

(function() {
(function() {
// Simple 3D tilt effect on hover for cards
    const cards = document.querySelectorAll('.card-inner-3');
    
    cards.forEach(card => {
      card.addEventListener('mousemove', (e) => {
        if (window.innerWidth < 1024) return; // Disable tilt on mobile
        
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        const centerX = rect.width / 2;
        const centerY = rect.height / 2;
        
        const rotateX = (y - centerY) / 20;
        const rotateY = (x - centerX) / 20;

        // Note: The flip still happens on Y axis, this adds a subtle tilt to the current state
        if (card.parentElement.matches(':hover')) {
          // While flipped, tilt logic slightly different or we just use default flip
        }
      });

      card.addEventListener('mouseleave', () => {
        card.style.transform = '';
      });
    });
})();
})();

if (!isMobile) { (function() {
(function() {
/**
     * Subtle Particle Background Animation
     */
    const canvas = document.getElementById('particleCanvas-4');
    const ctx = canvas.getContext('2d');
    let particles = [];

    function resize() {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }

    class Particle {
      constructor() {
        this.reset();
      }
      reset() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 1.5 + 0.1;
        this.speedX = (Math.random() - 0.5) * 0.3;
        this.speedY = (Math.random() - 0.5) * 0.3;
        this.life = Math.random() * 0.5 + 0.2;
      }
      update() {
        this.x += this.speedX;
        this.y += this.speedY;
        if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
          this.reset();
        }
      }
      draw() {
        const isDark = document.documentElement.classList.contains('dark');
        if (isDark) {
          ctx.fillStyle = `rgba(0, 255, 255, ${this.life})`;
        } else {
          ctx.fillStyle = `rgba(0, 139, 139, ${this.life})`; // Dark cyan for light mode
        }
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
      }
    }

    function init() {
      resize();
      for (let i = 0; i < 80; i++) {
        particles.push(new Particle());
      }
    }

    function animate() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      particles.forEach(p => {
        p.update();
        p.draw();
      });
      requestAnimationFrame(animate);
    }

    window.addEventListener('resize', resize);
    init();
    animate();
})();
})(); }

(function() {
(function() {
document.addEventListener('DOMContentLoaded', () => {
      const lines = document.querySelectorAll('.log-line');
      let currentIndex = 0;

      function showNextLine() {
        if (currentIndex < lines.length) {
          lines[currentIndex].classList.add('active');
          currentIndex++;
          
          // Random delay between lines to simulate real system behavior
          const nextDelay = Math.floor(Math.random() * 1200) + 600;
          setTimeout(showNextLine, nextDelay);
        } else {
          // Reset after a longer pause to loop the animation
          setTimeout(() => {
            lines.forEach(line => line.classList.remove('active'));
            currentIndex = 0;
            showNextLine();
          }, 4000);
        }
      }

      // Initial start
      setTimeout(showNextLine, 500);
    });
})();
})();
