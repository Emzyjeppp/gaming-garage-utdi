/**
 * STREAX STUDIOS / GAMING GARAGE - MAIN APPLICATION SCRIPTS
 */

document.addEventListener('DOMContentLoaded', () => {
    initLoader();
    initMobileMenu();
    initNavbarScroll();
    initInteractiveCards();
});

/**
 * 1. Loading Screen Controller
 */
function initLoader() {
    const loader = document.getElementById('loader');
    if (!loader) return;

    window.addEventListener('load', () => {
        setTimeout(() => {
            loader.style.opacity = '0';
            setTimeout(() => {
                loader.style.display = 'none';
            }, 700);
        }, 1200);
    });
}

/**
 * 2. Mobile Menu Drawer Navigation
 */
function initMobileMenu() {
    const menuToggle = document.getElementById('menu-toggle');
    const menuClose = document.getElementById('menu-close');
    const mobileMenu = document.getElementById('mobile-menu');
    const mobileLinks = document.querySelectorAll('.mobile-link');

    if (!menuToggle || !mobileMenu) return;

    const openMenu = () => {
        mobileMenu.classList.remove('translate-x-full');
        document.body.style.overflow = 'hidden';
    };

    const closeMenu = () => {
        mobileMenu.classList.add('translate-x-full');
        document.body.style.overflow = '';
    };

    menuToggle.addEventListener('click', openMenu);
    if (menuClose) {
        menuClose.addEventListener('click', closeMenu);
    }

    mobileLinks.forEach((link) => {
        link.addEventListener('click', closeMenu);
    });

    // Close on Escape key press
    window.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !mobileMenu.classList.contains('translate-x-full')) {
            closeMenu();
        }
    });
}

/**
 * 3. Navbar Styling on Scroll
 */
function initNavbarScroll() {
    const nav = document.querySelector('nav');
    if (!nav) return;

    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            nav.classList.add('py-2', 'bg-black/90');
            nav.classList.remove('bg-black/80');
        } else {
            nav.classList.remove('py-2', 'bg-black/90');
            nav.classList.add('bg-black/80');
        }
    });
}

/**
 * 4. Interactive Elements & Card Links
 */
function initInteractiveCards() {
    // Map dots hover/click highlight
    const mapDots = document.querySelectorAll('.map-dot');
    mapDots.forEach((dot) => {
        dot.addEventListener('mouseenter', () => {
            mapDots.forEach((d) => d.classList.remove('active'));
            dot.classList.add('active');
        });
    });
}
