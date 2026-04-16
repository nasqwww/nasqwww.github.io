<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>☽ LUNA — Петергоф</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=JetBrains+Mono:wght@300;400;500&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/suncalc/1.9.0/suncalc.min.js"></script>
<style>
  :root {
    --black: #02030a;
    --deep: #060818;
    --navy: #0c1228;
    --silver: #c8cdd8;
    --white: #eef0f5;
    --dim: #5a6070;
    --gold: #c9a455;
    --gold-dim: #7a6030;
    --cyan: #5bcedc;
    --cyan-dim: #1a4a50;
    --glow: rgba(91,206,220,0.12);
    --moon-glow: rgba(201,164,85,0.15);
  }

  * { margin:0; padding:0; box-sizing:border-box; }

  html, body {
    width:100%; height:100%;
    background: var(--black);
    color: var(--silver);
    font-family: 'JetBrains Mono', monospace;
    overflow-x: hidden;
  }

  /* ── STARFIELD CANVAS ── */
  #starfield {
    position: fixed;
    inset: 0;
    z-index: 0;
    pointer-events: none;
  }

  /* ── LAYOUT ── */
  .page {
    position: relative;
    z-index: 1;
    min-height: 100vh;
    padding: 0 0 80px;
  }

  /* ── HEADER ── */
  header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding: 36px 48px 0;
    border-bottom: 1px solid rgba(91,206,220,0.08);
    padding-bottom: 24px;
    margin-bottom: 0;
  }

  .logo {
    font-family: 'Cormorant Garamond', serif;
    font-size: 13px;
    font-weight: 300;
    letter-spacing: 0.4em;
    color: var(--dim);
    text-transform: uppercase;
  }
  .logo span { color: var(--cyan); }

  .live-clock {
    text-align: right;
  }
  .live-clock .time {
    font-family: 'JetBrains Mono', monospace;
    font-size: 22px;
    font-weight: 300;
    color: var(--white);
    letter-spacing: 0.08em;
  }
  .live-clock .date-loc {
    font-size: 11px;
    color: var(--dim);
    letter-spacing: 0.15em;
    margin-top: 4px;
  }

  /* ── HERO SECTION ── */
  .hero {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0;
    min-height: 70vh;
    align-items: center;
  }

  /* Moon Canvas */
  .moon-visual {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 60px 40px;
    position: relative;
  }

  .moon-wrap {
    position: relative;
    width: 300px;
    height: 300px;
  }

  #moonCanvas {
    width: 300px;
    height: 300px;
    filter: drop-shadow(0 0 40px rgba(201,164,85,0.4)) drop-shadow(0 0 80px rgba(201,164,85,0.15));
    border-radius: 50%;
  }

  .moon-phase-label {
    margin-top: 28px;
    text-align: center;
  }
  .moon-phase-label .phase-name {
    font-family: 'Cormorant Garamond', serif;
    font-size: 28px;
    font-weight: 300;
    color: var(--white);
    letter-spacing: 0.06em;
  }
  .moon-phase-label .phase-sub {
    font-size: 11px;
    color: var(--dim);
    letter-spacing: 0.2em;
    text-transform: uppercase;
    margin-top: 6px;
  }

  /* Moon orbit ring */
  .orbit-ring {
    position: absolute;
    inset: -30px;
    border-radius: 50%;
    border: 1px solid rgba(201,164,85,0.08);
    animation: orbit-spin 120s linear infinite;
  }
  .orbit-ring::before {
    content: '';
    position: absolute;
    width: 6px; height: 6px;
    background: var(--gold);
    border-radius: 50%;
    top: -3px; left: 50%;
    transform: translateX(-50%);
    box-shadow: 0 0 8px var(--gold);
  }
  @keyframes orbit-spin { from{transform:rotate(0deg)} to{transform:rotate(360deg)} }

  /* ── STATS PANEL ── */
  .stats-panel {
    padding: 60px 60px 60px 20px;
    display: flex;
    flex-direction: column;
    gap: 0;
  }

  .stat-block {
    padding: 24px 0;
    border-bottom: 1px solid rgba(91,206,220,0.06);
    display: grid;
    grid-template-columns: 1fr auto;
    align-items: end;
    gap: 8px;
  }
  .stat-block:first-child { border-top: 1px solid rgba(91,206,220,0.06); }

  .stat-label {
    font-size: 10px;
    letter-spacing: 0.25em;
    color: var(--dim);
    text-transform: uppercase;
    margin-bottom: 8px;
  }
  .stat-value {
    font-family: 'Cormorant Garamond', serif;
    font-size: 42px;
    font-weight: 300;
    color: var(--white);
    line-height: 1;
  }
  .stat-value.gold { color: var(--gold); }
  .stat-value.cyan { color: var(--cyan); }
  .stat-unit {
    font-size: 11px;
    color: var(--dim);
    letter-spacing: 0.1em;
    margin-bottom: 6px;
  }
  .stat-sub {
    font-size: 11px;
    color: var(--dim);
    letter-spacing: 0.1em;
    margin-top: 4px;
    grid-column: 1/-1;
  }

  /* ── PROGRESS BAR ── */
  .arc-bar {
    margin-top: 8px;
    height: 2px;
    background: rgba(255,255,255,0.05);
    border-radius: 1px;
    position: relative;
    overflow: visible;
    grid-column: 1/-1;
  }
  .arc-fill {
    height: 100%;
    border-radius: 1px;
    background: linear-gradient(90deg, var(--cyan-dim), var(--cyan));
    position: relative;
    transition: width 1s ease;
  }
  .arc-fill::after {
    content: '';
    position: absolute;
    right: -3px; top: -3px;
    width: 8px; height: 8px;
    background: var(--cyan);
    border-radius: 50%;
    box-shadow: 0 0 8px var(--cyan);
  }

  /* ── GRID SECTION ── */
  .grid-section {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 1px;
    background: rgba(91,206,220,0.05);
    margin: 0 0 1px;
    border-top: 1px solid rgba(91,206,220,0.05);
    border-bottom: 1px solid rgba(91,206,220,0.05);
  }

  .grid-card {
    background: var(--black);
    padding: 28px 32px;
    position: relative;
    overflow: hidden;
  }
  .grid-card::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--cyan-dim), transparent);
    opacity: 0;
    transition: opacity 0.3s;
  }
  .grid-card:hover::before { opacity: 1; }

  .card-icon {
    font-size: 20px;
    margin-bottom: 14px;
    display: block;
  }
  .card-title {
    font-size: 10px;
    letter-spacing: 0.25em;
    color: var(--dim);
    text-transform: uppercase;
    margin-bottom: 10px;
  }
  .card-main {
    font-family: 'Cormorant Garamond', serif;
    font-size: 32px;
    font-weight: 300;
    color: var(--white);
    line-height: 1;
  }
  .card-sub {
    font-size: 11px;
    color: var(--dim);
    margin-top: 8px;
    letter-spacing: 0.08em;
  }

  /* ── COMPASS ── */
  .compass-wrap {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-top: 8px;
  }
  #compassCanvas {
    flex-shrink: 0;
  }
  .compass-data { font-size: 11px; color: var(--dim); line-height: 1.8; }
  .compass-data strong { color: var(--silver); font-weight: 400; }

  /* ── RISE/SET TIMELINE ── */
  .timeline-section {
    padding: 48px 48px;
    border-bottom: 1px solid rgba(91,206,220,0.05);
  }
  .section-title {
    font-size: 10px;
    letter-spacing: 0.3em;
    color: var(--dim);
    text-transform: uppercase;
    margin-bottom: 32px;
  }
  .timeline-bar {
    position: relative;
    height: 60px;
    display: flex;
    align-items: center;
  }
  .tl-track {
    position: absolute;
    left: 0; right: 0;
    height: 1px;
    background: rgba(255,255,255,0.06);
  }
  .tl-night {
    position: absolute;
    height: 32px;
    top: 50%; transform: translateY(-50%);
    background: rgba(12,18,40,0.9);
    border-radius: 4px;
  }
  .tl-arc {
    position: absolute;
    height: 32px;
    top: 50%; transform: translateY(-50%);
    background: linear-gradient(90deg, rgba(201,164,85,0.1), rgba(201,164,85,0.25), rgba(201,164,85,0.1));
    border: 1px solid rgba(201,164,85,0.2);
    border-radius: 4px;
  }
  .tl-now {
    position: absolute;
    width: 2px; height: 50px;
    background: var(--cyan);
    top: 50%; transform: translateY(-50%);
    box-shadow: 0 0 8px var(--cyan);
    border-radius: 1px;
  }
  .tl-moon-dot {
    position: absolute;
    width: 10px; height: 10px;
    background: var(--gold);
    border-radius: 50%;
    top: 50%; transform: translate(-50%,-50%);
    box-shadow: 0 0 12px var(--gold);
  }
  .tl-labels {
    display: flex;
    justify-content: space-between;
    margin-top: 12px;
    font-size: 10px;
    color: var(--dim);
    letter-spacing: 0.1em;
  }
  .tl-event {
    display: flex;
    gap: 32px;
    margin-top: 20px;
  }
  .tl-item { }
  .tl-item-label { font-size: 10px; color: var(--dim); letter-spacing: 0.2em; text-transform: uppercase; }
  .tl-item-val { font-family: 'Cormorant Garamond', serif; font-size: 24px; color: var(--white); margin-top: 4px; }

  /* ── LUNAR CALENDAR ── */
  .calendar-section {
    padding: 48px 48px;
    border-bottom: 1px solid rgba(91,206,220,0.05);
  }
  .cal-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 4px;
    max-width: 560px;
  }
  .cal-day-name {
    text-align: center;
    font-size: 10px;
    color: var(--dim);
    letter-spacing: 0.15em;
    padding: 8px 0;
  }
  .cal-day {
    text-align: center;
    padding: 10px 6px;
    border-radius: 4px;
    font-size: 12px;
    color: var(--dim);
    position: relative;
    cursor: default;
    transition: background 0.2s;
  }
  .cal-day:hover { background: rgba(255,255,255,0.03); }
  .cal-day.today {
    background: rgba(91,206,220,0.08);
    color: var(--cyan);
    border: 1px solid rgba(91,206,220,0.2);
  }
  .cal-day.full-moon { color: var(--gold); }
  .cal-day.new-moon { color: var(--silver); }
  .cal-day .moon-emoji {
    display: block;
    font-size: 10px;
    margin-bottom: 2px;
    line-height: 1;
  }
  .cal-day .day-num { display: block; }

  /* ── COUNTDOWN ── */
  .countdown-section {
    padding: 48px 48px;
    border-bottom: 1px solid rgba(91,206,220,0.05);
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 48px;
  }
  .countdown-card {
    position: relative;
    padding: 32px;
    border: 1px solid rgba(91,206,220,0.08);
    border-radius: 2px;
    overflow: hidden;
  }
  .countdown-card::after {
    content: '';
    position: absolute;
    bottom: 0; left: 0; right: 0;
    height: 80px;
    background: linear-gradient(to top, var(--glow), transparent);
    pointer-events: none;
  }
  .countdown-card.gold-card::after {
    background: linear-gradient(to top, var(--moon-glow), transparent);
  }
  .cd-label { font-size: 10px; letter-spacing: 0.3em; color: var(--dim); text-transform: uppercase; }
  .cd-name {
    font-family: 'Cormorant Garamond', serif;
    font-size: 24px;
    color: var(--white);
    margin: 8px 0 20px;
  }
  .cd-timer {
    display: flex;
    gap: 20px;
    align-items: flex-end;
  }
  .cd-unit {}
  .cd-num {
    font-family: 'Cormorant Garamond', serif;
    font-size: 48px;
    font-weight: 300;
    color: var(--cyan);
    line-height: 1;
    display: block;
  }
  .gold-card .cd-num { color: var(--gold); }
  .cd-unit-label {
    font-size: 9px;
    color: var(--dim);
    letter-spacing: 0.2em;
    text-transform: uppercase;
    display: block;
    margin-top: 4px;
  }

  /* ── FUN FACTS ── */
  .facts-section {
    padding: 48px 48px;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 24px;
  }
  .fact-card {
    padding: 24px;
    border: 1px solid rgba(255,255,255,0.04);
    border-radius: 2px;
  }
  .fact-card .fact-num {
    font-family: 'Cormorant Garamond', serif;
    font-size: 36px;
    font-weight: 300;
    color: var(--white);
  }
  .fact-card .fact-label { font-size: 10px; color: var(--dim); letter-spacing: 0.15em; text-transform: uppercase; margin-top: 4px; }
  .fact-card .fact-desc { font-size: 11px; color: var(--dim); margin-top: 10px; line-height: 1.7; }

  /* ── FOOTER ── */
  footer {
    padding: 32px 48px;
    border-top: 1px solid rgba(91,206,220,0.06);
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 10px;
    color: var(--dim);
    letter-spacing: 0.15em;
  }
  footer a { color: var(--dim); text-decoration: none; }
  footer a:hover { color: var(--cyan); }

  /* ── LIVE INDICATOR ── */
  .live-dot {
    display: inline-block;
    width: 6px; height: 6px;
    background: var(--cyan);
    border-radius: 50%;
    box-shadow: 0 0 6px var(--cyan);
    animation: pulse-dot 2s ease-in-out infinite;
    vertical-align: middle;
    margin-right: 6px;
  }
  @keyframes pulse-dot {
    0%,100%{opacity:1;transform:scale(1)}
    50%{opacity:0.4;transform:scale(0.6)}
  }

  /* ── ZODIAC BAR ── */
  .zodiac-bar {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-top: 12px;
    padding: 12px 16px;
    background: rgba(201,164,85,0.05);
    border: 1px solid rgba(201,164,85,0.1);
    border-radius: 2px;
  }
  .zodiac-icon { font-size: 20px; }
  .zodiac-info { }
  .zodiac-name { font-family: 'Cormorant Garamond', serif; font-size: 16px; color: var(--gold); }
  .zodiac-sub { font-size: 10px; color: var(--dim); letter-spacing: 0.1em; }

  /* ── ALTITUDE VISUAL ── */
  .altitude-vis {
    position: relative;
    height: 80px;
    margin-top: 16px;
  }
  #altCanvas { width: 100%; height: 80px; }

  /* ── RESPONSIVE ── */
  @media (max-width: 900px) {
    header { padding: 24px; }
    .hero { grid-template-columns: 1fr; }
    .stats-panel { padding: 20px 24px; }
    .grid-section { grid-template-columns: repeat(2, 1fr); }
    .countdown-section { grid-template-columns: 1fr; }
    .facts-section { grid-template-columns: 1fr; }
    .timeline-section, .calendar-section, .countdown-section, .facts-section { padding: 32px 24px; }
    footer { flex-direction: column; gap: 8px; text-align: center; }
  }
</style>
</head>
<body>

<canvas id="starfield"></canvas>

<div class="page">

  <!-- HEADER -->
  <header>
    <div>
      <div class="logo">☽ LUNA / <span>Петергоф</span></div>
      <div style="margin-top:8px;font-size:10px;color:var(--dim);letter-spacing:0.1em;">
        <span class="live-dot"></span>LIVE · 59.872°N 29.897°E
      </div>
    </div>
    <div class="live-clock">
      <div class="time" id="clockTime">--:--:--</div>
      <div class="date-loc" id="clockDate">—</div>
    </div>
  </header>

  <!-- HERO -->
  <div class="hero">
    <!-- Moon Visualization -->
    <div class="moon-visual">
      <div class="moon-wrap">
        <div class="orbit-ring"></div>
        <canvas id="moonCanvas" width="600" height="600"></canvas>
      </div>
      <div class="moon-phase-label">
        <div class="phase-name" id="phaseName">—</div>
        <div class="phase-sub" id="phaseSub">вычисление...</div>
      </div>
      <div class="zodiac-bar" id="zodiacBar">
        <div class="zodiac-icon" id="zodiacIcon">✦</div>
        <div class="zodiac-info">
          <div class="zodiac-name" id="zodiacName">—</div>
          <div class="zodiac-sub" id="zodiacSub">луна в знаке зодиака</div>
        </div>
      </div>
    </div>

    <!-- Stats Panel -->
    <div class="stats-panel">
      <div class="stat-block">
        <div>
          <div class="stat-label">Освещённость</div>
          <div class="stat-value gold" id="illumVal">—</div>
        </div>
        <div class="stat-unit">%</div>
        <div class="stat-sub" id="illumBar" style="width:100%">
          <div class="arc-bar"><div class="arc-fill" id="illumFill" style="width:0%"></div></div>
        </div>
      </div>
      <div class="stat-block">
        <div>
          <div class="stat-label">Возраст Луны</div>
          <div class="stat-value" id="ageVal">—</div>
        </div>
        <div class="stat-unit">дней</div>
        <div class="stat-sub">из 29.5 суток лунного цикла</div>
        <div style="width:100%">
          <div class="arc-bar"><div class="arc-fill" id="ageFill" style="width:0%;background:linear-gradient(90deg,var(--gold-dim),var(--gold))"></div></div>
        </div>
      </div>
      <div class="stat-block">
        <div>
          <div class="stat-label">Расстояние</div>
          <div class="stat-value cyan" id="distVal">—</div>
        </div>
        <div class="stat-unit">км</div>
        <div class="stat-sub" id="distSub">—</div>
      </div>
      <div class="stat-block">
        <div>
          <div class="stat-label">Высота над горизонтом</div>
          <div class="stat-value" id="altVal">—</div>
        </div>
        <div class="stat-unit">°</div>
        <div class="stat-sub" id="altSub">—</div>
      </div>
      <div class="stat-block">
        <div>
          <div class="stat-label">Азимут</div>
          <div class="stat-value" id="azVal">—</div>
        </div>
        <div class="stat-unit">°</div>
        <div class="stat-sub" id="azDir">—</div>
      </div>
    </div>
  </div>

  <!-- GRID CARDS -->
  <div class="grid-section">
    <div class="grid-card">
      <span class="card-icon">↑</span>
      <div class="card-title">Восход Луны</div>
      <div class="card-main" id="moonrise">—</div>
      <div class="card-sub" id="moonriseSub">—</div>
    </div>
    <div class="grid-card">
      <span class="card-icon">↓</span>
      <div class="card-title">Заход Луны</div>
      <div class="card-main" id="moonset">—</div>
      <div class="card-sub" id="moonsetSub">—</div>
    </div>
    <div class="grid-card">
      <span class="card-icon">◎</span>
      <div class="card-title">Параллакс</div>
      <div class="card-main" id="paralVal">—</div>
      <div class="card-sub">угловой диаметр Луны</div>
    </div>
    <div class="grid-card">
      <span class="card-icon">∿</span>
      <div class="card-title">Компас / Направление</div>
      <div class="compass-wrap">
        <canvas id="compassCanvas" width="70" height="70"></canvas>
        <div class="compass-data">
          <div>Азимут: <strong id="azValSmall">—</strong></div>
          <div>Высота: <strong id="altValSmall">—</strong></div>
          <div>Видимость: <strong id="visVal">—</strong></div>
        </div>
      </div>
    </div>
  </div>

  <!-- TIMELINE -->
  <div class="timeline-section">
    <div class="section-title">Суточный путь Луны</div>
    <div class="timeline-bar">
      <div class="tl-track"></div>
      <div class="tl-night" id="tlNight1"></div>
      <div class="tl-night" id="tlNight2"></div>
      <div class="tl-arc" id="tlArc"></div>
      <div class="tl-moon-dot" id="tlMoonDot"></div>
      <div class="tl-now" id="tlNow"></div>
    </div>
    <div class="tl-labels">
      <span>00:00</span><span>06:00</span><span>12:00</span><span>18:00</span><span>24:00</span>
    </div>
    <div class="tl-event">
      <div class="tl-item">
        <div class="tl-item-label">↑ Восход</div>
        <div class="tl-item-val" id="tl-rise">—</div>
      </div>
      <div class="tl-item">
        <div class="tl-item-label">⊙ Кульминация</div>
        <div class="tl-item-val" id="tl-transit">—</div>
      </div>
      <div class="tl-item">
        <div class="tl-item-label">↓ Заход</div>
        <div class="tl-item-val" id="tl-set">—</div>
      </div>
      <div class="tl-item">
        <div class="tl-item-label">◌ Над горизонтом</div>
        <div class="tl-item-val" id="tl-duration">—</div>
      </div>
    </div>
  </div>

  <!-- COUNTDOWN -->
  <div class="countdown-section">
    <div class="countdown-card">
      <div class="cd-label">следующее событие</div>
      <div class="cd-name" id="nextEventName">Полнолуние</div>
      <div class="cd-timer" id="cdTimer1">
        <div class="cd-unit"><span class="cd-num" id="cd1-d">—</span><span class="cd-unit-label">дней</span></div>
        <div class="cd-unit"><span class="cd-num" id="cd1-h">—</span><span class="cd-unit-label">часов</span></div>
        <div class="cd-unit"><span class="cd-num" id="cd1-m">—</span><span class="cd-unit-label">минут</span></div>
      </div>
    </div>
    <div class="countdown-card gold-card">
      <div class="cd-label">следующее событие</div>
      <div class="cd-name" id="nextEventName2">Новолуние</div>
      <div class="cd-timer">
        <div class="cd-unit"><span class="cd-num" id="cd2-d">—</span><span class="cd-unit-label">дней</span></div>
        <div class="cd-unit"><span class="cd-num" id="cd2-h">—</span><span class="cd-unit-label">часов</span></div>
        <div class="cd-unit"><span class="cd-num" id="cd2-m">—</span><span class="cd-unit-label">минут</span></div>
      </div>
    </div>
  </div>

  <!-- LUNAR CALENDAR -->
  <div class="calendar-section">
    <div class="section-title" id="calTitle">Лунный календарь</div>
    <div class="cal-grid" id="calGrid"></div>
  </div>

  <!-- FUN FACTS / STATIC INFO -->
  <div class="facts-section">
    <div class="fact-card">
      <div class="fact-num">384 400</div>
      <div class="fact-label">км среднее расстояние</div>
      <div class="fact-desc">Луна удаляется от Земли на ~3.8 см в год. За миллиард лет она сместилась на 38 000 км.</div>
    </div>
    <div class="fact-card">
      <div class="fact-num">29.53</div>
      <div class="fact-label">суток синодический месяц</div>
      <div class="fact-desc">Время от новолуния до новолуния. Именно столько длится один полный лунный цикл.</div>
    </div>
    <div class="fact-card">
      <div class="fact-num fact-num-dyn" id="moonAgeTotal">—</div>
      <div class="fact-label">лунных циклов от рождения Луны</div>
      <div class="fact-desc">Луне ~4.5 млрд лет. За это время она совершила около 55 миллионов оборотов вокруг Земли.</div>
    </div>
  </div>

  <!-- FOOTER -->
  <footer>
    <div>☽ LUNA · Петергоф · 59.872°N 29.897°E</div>
    <div><span class="live-dot"></span>обновляется в реальном времени</div>
    <div><a href="https://nasqwww.github.io">nasqwww.github.io</a></div>
  </footer>

</div>

<script>
// ═══════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════
const LAT = 59.872107104446;
const LNG = 29.896758698524;
const SYNODIC = 29.530588853;

// ═══════════════════════════════════════
// STARFIELD
// ═══════════════════════════════════════
(function() {
  const canvas = document.getElementById('starfield');
  const ctx = canvas.getContext('2d');
  let W, H, stars = [], shooters = [], nebulas = [];

  function resize() {
    W = canvas.width = window.innerWidth;
    H = canvas.height = window.innerHeight;
    initStars();
    initNebulas();
  }

  function rand(a, b) { return a + Math.random() * (b - a); }

  function initStars() {
    stars = [];
    const count = Math.floor((W * H) / 1800);
    for (let i = 0; i < count; i++) {
      stars.push({
        x: rand(0, W), y: rand(0, H),
        r: rand(0.3, 1.6),
        alpha: rand(0.1, 0.9),
        speed: rand(0.0002, 0.001),
        phase: rand(0, Math.PI * 2),
        color: Math.random() < 0.1 ? '#aac8ff' : Math.random() < 0.05 ? '#ffdcaa' : '#ffffff'
      });
    }
  }

  function initNebulas() {
    nebulas = [];
    for (let i = 0; i < 4; i++) {
      nebulas.push({
        x: rand(0, W), y: rand(0, H),
        rx: rand(200, 500), ry: rand(100, 300),
        hue: [220, 200, 240, 180][i],
        alpha: rand(0.015, 0.04)
      });
    }
  }

  function spawnShooter() {
    if (Math.random() < 0.003 && shooters.length < 3) {
      const angle = rand(-0.4, -0.15);
      shooters.push({
        x: rand(W * 0.2, W),
        y: rand(0, H * 0.5),
        vx: Math.cos(angle) * rand(8, 14),
        vy: Math.sin(angle) * rand(4, 8),
        len: rand(80, 200),
        alpha: 1,
        decay: rand(0.015, 0.03)
      });
    }
  }

  function draw(t) {
    ctx.clearRect(0, 0, W, H);

    // Deep space gradient
    const grad = ctx.createRadialGradient(W*0.3, H*0.2, 0, W*0.5, H*0.5, Math.max(W,H)*0.8);
    grad.addColorStop(0, '#0a0c18');
    grad.addColorStop(0.4, '#060814');
    grad.addColorStop(1, '#020308');
    ctx.fillStyle = grad;
    ctx.fillRect(0, 0, W, H);

    // Nebulas
    nebulas.forEach(n => {
      const g = ctx.createRadialGradient(n.x, n.y, 0, n.x, n.y, n.rx);
      g.addColorStop(0, `hsla(${n.hue},70%,60%,${n.alpha})`);
      g.addColorStop(1, 'transparent');
      ctx.save();
      ctx.scale(1, n.ry / n.rx);
      ctx.fillStyle = g;
      ctx.beginPath();
      ctx.arc(n.x, n.y * n.rx / n.ry, n.rx, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    });

    // Stars
    stars.forEach(s => {
      const a = s.alpha * (0.5 + 0.5 * Math.sin(t * s.speed * 1000 + s.phase));
      ctx.beginPath();
      ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
      ctx.fillStyle = s.color.replace(')', `,${a})`).replace('rgb', 'rgba').replace('#', '');
      // simple: just use globalAlpha
      ctx.globalAlpha = a;
      ctx.fillStyle = s.color;
      ctx.fill();
      ctx.globalAlpha = 1;
    });

    // Shooting stars
    spawnShooter();
    shooters = shooters.filter(s => s.alpha > 0);
    shooters.forEach(s => {
      ctx.save();
      ctx.globalAlpha = s.alpha;
      const grd = ctx.createLinearGradient(s.x, s.y, s.x - s.vx * s.len / 10, s.y - s.vy * s.len / 10);
      grd.addColorStop(0, 'rgba(255,255,255,1)');
      grd.addColorStop(1, 'rgba(255,255,255,0)');
      ctx.strokeStyle = grd;
      ctx.lineWidth = 1.5;
      ctx.beginPath();
      ctx.moveTo(s.x, s.y);
      ctx.lineTo(s.x - s.vx * s.len / 10, s.y - s.vy * s.len / 10);
      ctx.stroke();
      ctx.restore();
      s.x += s.vx;
      s.y += s.vy;
      s.alpha -= s.decay;
    });

    requestAnimationFrame(draw);
  }

  window.addEventListener('resize', resize);
  resize();
  requestAnimationFrame(draw);
})();

// ═══════════════════════════════════════
// CLOCK
// ═══════════════════════════════════════
function updateClock() {
  const now = new Date();
  const t = now.toLocaleTimeString('ru-RU', { hour12: false });
  document.getElementById('clockTime').textContent = t;
  const d = now.toLocaleDateString('ru-RU', { weekday:'long', day:'numeric', month:'long', year:'numeric' });
  document.getElementById('clockDate').textContent = d.charAt(0).toUpperCase() + d.slice(1);
}
setInterval(updateClock, 1000);
updateClock();

// ═══════════════════════════════════════
// MOON PHASE DRAWING
// ═══════════════════════════════════════
function drawMoon(phase, illumination) {
  const canvas = document.getElementById('moonCanvas');
  const ctx = canvas.getContext('2d');
  const cx = 300, cy = 300, r = 260;
  ctx.clearRect(0, 0, 600, 600);

  // Moon base
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.fillStyle = '#1a1a1a';
  ctx.fill();

  // Lunar surface texture (craters)
  const craters = [
    {x:0.3,y:0.2,r:0.08,d:0.3},{x:-0.2,y:-0.3,r:0.06,d:0.25},
    {x:0.1,y:0.4,r:0.05,d:0.2},{x:-0.35,y:0.15,r:0.07,d:0.28},
    {x:0.25,y:-0.1,r:0.04,d:0.2},{x:-0.1,y:0.1,r:0.09,d:0.15},
    {x:0.4,y:-0.25,r:0.05,d:0.22},{x:-0.25,y:-0.05,r:0.04,d:0.18}
  ];

  // Draw maria (dark areas)
  const maria = [
    {x:-0.05,y:-0.15,rx:0.25,ry:0.18,a:0.55},
    {x:0.15,y:0.2,rx:0.12,ry:0.09,a:0.45},
    {x:-0.2,y:0.25,rx:0.1,ry:0.07,a:0.4},
    {x:0.3,y:-0.05,rx:0.08,ry:0.1,a:0.35},
  ];

  ctx.save();
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.clip();

  // Base moon color
  const moonGrad = ctx.createRadialGradient(cx - 60, cy - 80, 0, cx, cy, r);
  moonGrad.addColorStop(0, '#d4c89a');
  moonGrad.addColorStop(0.4, '#b8a878');
  moonGrad.addColorStop(0.75, '#9a8a60');
  moonGrad.addColorStop(1, '#6a5c3a');
  ctx.fillStyle = moonGrad;
  ctx.fillRect(0, 0, 600, 600);

  // Maria
  maria.forEach(m => {
    ctx.save();
    ctx.translate(cx + m.x * r, cy + m.y * r);
    ctx.scale(m.rx, m.ry);
    const mg = ctx.createRadialGradient(0, 0, 0, 0, 0, r);
    mg.addColorStop(0, `rgba(60,50,30,${m.a})`);
    mg.addColorStop(1, 'transparent');
    ctx.fillStyle = mg;
    ctx.beginPath();
    ctx.arc(0, 0, r, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();
  });

  // Craters
  craters.forEach(c => {
    const cx2 = cx + c.x * r, cy2 = cy + c.y * r, cr = c.r * r;
    const cg = ctx.createRadialGradient(cx2 - cr*0.3, cy2 - cr*0.3, 0, cx2, cy2, cr);
    cg.addColorStop(0, `rgba(80,70,45,${c.d})`);
    cg.addColorStop(0.7, `rgba(120,105,70,${c.d * 0.5})`);
    cg.addColorStop(1, 'transparent');
    ctx.fillStyle = cg;
    ctx.beginPath();
    ctx.arc(cx2, cy2, cr, 0, Math.PI * 2);
    ctx.fill();
  });

  ctx.restore();

  // ── SHADOW / PHASE ──
  // phase: 0=new, 0.5=full, 0-0.5 waxing, 0.5-1 waning
  ctx.save();
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.clip();

  if (phase < 0.01 || phase > 0.99) {
    // New moon — full dark
    ctx.fillStyle = 'rgba(2,3,10,0.95)';
    ctx.fillRect(0, 0, 600, 600);
  } else if (phase > 0.49 && phase < 0.51) {
    // Full moon — no shadow
  } else {
    // Draw terminator
    const waxing = phase < 0.5;
    const p = waxing ? phase * 2 : (phase - 0.5) * 2;
    // p goes 0→1 for each half
    // terminator x offset: cos(p * π) * r
    const termX = Math.cos(p * Math.PI) * r;

    ctx.beginPath();
    if (waxing) {
      // Right side lit, left dark
      ctx.arc(cx, cy, r, -Math.PI / 2, Math.PI / 2, false); // right semicircle
      // Terminator ellipse on left (inside)
      ctx.ellipse(cx, cy, Math.abs(termX), r, 0, Math.PI / 2, -Math.PI / 2, true);
    } else {
      // Left side lit, right dark
      ctx.arc(cx, cy, r, Math.PI / 2, -Math.PI / 2, false); // left semicircle
      ctx.ellipse(cx, cy, Math.abs(termX), r, 0, -Math.PI / 2, Math.PI / 2, true);
    }
    ctx.fillStyle = 'rgba(2,3,10,0.94)';
    ctx.fill();
  }

  // Atmosphere glow on edge
  const edgeGrad = ctx.createRadialGradient(cx, cy, r * 0.85, cx, cy, r);
  edgeGrad.addColorStop(0, 'transparent');
  edgeGrad.addColorStop(1, 'rgba(201,164,85,0.08)');
  ctx.fillStyle = edgeGrad;
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.fill();

  ctx.restore();

  // Rim light
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.strokeStyle = 'rgba(201,164,85,0.15)';
  ctx.lineWidth = 2;
  ctx.stroke();
}

// ═══════════════════════════════════════
// COMPASS DRAWING
// ═══════════════════════════════════════
function drawCompass(azimuthDeg) {
  const canvas = document.getElementById('compassCanvas');
  const ctx = canvas.getContext('2d');
  const cx = 35, cy = 35, r = 30;
  ctx.clearRect(0, 0, 70, 70);

  // Ring
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.strokeStyle = 'rgba(91,206,220,0.2)';
  ctx.lineWidth = 1;
  ctx.stroke();

  // Labels
  const dirs = ['С','В','Ю','З'];
  const angles = [0, 90, 180, 270];
  ctx.font = '8px JetBrains Mono';
  ctx.fillStyle = 'rgba(90,96,112,0.8)';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  angles.forEach((a, i) => {
    const rad = (a - 90) * Math.PI / 180;
    ctx.fillText(dirs[i], cx + Math.cos(rad) * (r - 8), cy + Math.sin(rad) * (r - 8));
  });

  // Moon direction arrow
  const rad = (azimuthDeg - 90) * Math.PI / 180;
  const arrowX = cx + Math.cos(rad) * (r - 4);
  const arrowY = cy + Math.sin(rad) * (r - 4);

  ctx.beginPath();
  ctx.moveTo(cx, cy);
  ctx.lineTo(arrowX, arrowY);
  ctx.strokeStyle = '#c9a455';
  ctx.lineWidth = 2;
  ctx.stroke();

  // Dot
  ctx.beginPath();
  ctx.arc(arrowX, arrowY, 3, 0, Math.PI * 2);
  ctx.fillStyle = '#c9a455';
  ctx.fill();
  ctx.shadowColor = '#c9a455';
  ctx.shadowBlur = 6;
  ctx.fill();
  ctx.shadowBlur = 0;

  // Center dot
  ctx.beginPath();
  ctx.arc(cx, cy, 2, 0, Math.PI * 2);
  ctx.fillStyle = 'rgba(91,206,220,0.5)';
  ctx.fill();
}

// ═══════════════════════════════════════
// UTILS
// ═══════════════════════════════════════
function fmt(d) {
  if (!d || isNaN(d.getTime())) return '—';
  return d.toLocaleTimeString('ru-RU', { hour:'2-digit', minute:'2-digit' });
}

function azDir(az) {
  const dirs = ['С','СВ','В','ЮВ','Ю','ЮЗ','З','СЗ','С'];
  return dirs[Math.round(az / 45) % 8];
}

function getPhaseRu(phase) {
  if (phase < 0.03 || phase > 0.97) return ['Новолуние', '🌑 Луна не видна'];
  if (phase < 0.22) return ['Молодой Месяц', '🌒 Растущий серп'];
  if (phase < 0.28) return ['Первая четверть', '🌓 Правая половина освещена'];
  if (phase < 0.47) return ['Растущая Луна', '🌔 Луна прибывает'];
  if (phase < 0.53) return ['Полнолуние', '🌕 Луна полностью освещена'];
  if (phase < 0.72) return ['Убывающая Луна', '🌖 Луна убывает'];
  if (phase < 0.78) return ['Последняя четверть', '🌗 Левая половина освещена'];
  if (phase < 0.97) return ['Старый Месяц', '🌘 Убывающий серп'];
  return ['Новолуние', '🌑 Луна не видна'];
}

function getMoonEmoji(phase) {
  if (phase < 0.06) return '🌑';
  if (phase < 0.19) return '🌒';
  if (phase < 0.31) return '🌓';
  if (phase < 0.44) return '🌔';
  if (phase < 0.56) return '🌕';
  if (phase < 0.69) return '🌖';
  if (phase < 0.81) return '🌗';
  if (phase < 0.94) return '🌘';
  return '🌑';
}

// Moon zodiac sign (approximate)
function getMoonZodiac(date) {
  // Approximate moon longitude
  const d = (date - new Date(2000, 0, 1, 12)) / 86400000;
  const L = (218.316 + 13.176396 * d) % 360;
  const signs = [
    ['Овен','♈','Огонь'],['Телец','♉','Земля'],['Близнецы','♊','Воздух'],
    ['Рак','♋','Вода'],['Лев','♌','Огонь'],['Дева','♍','Земля'],
    ['Весы','♎','Воздух'],['Скорпион','♏','Вода'],['Стрелец','♐','Огонь'],
    ['Козерог','♑','Земля'],['Водолей','♒','Воздух'],['Рыбы','♓','Вода']
  ];
  const idx = Math.floor(((L % 360) + 360) % 360 / 30);
  return signs[idx];
}

// Next full/new moon finder
function nextMoonEvent(phase, date) {
  const synodic = SYNODIC * 24 * 3600 * 1000; // ms
  const currentAge = phase * synodic;

  const toFull = (0.5 * synodic - currentAge + synodic) % synodic;
  const toNew = (phase < 0.5)
    ? (1 - phase) * synodic
    : ((1 - phase) * synodic);

  const fullDate = new Date(date.getTime() + toFull);
  const newDate = new Date(date.getTime() + toNew);

  return { fullDate, newDate };
}

function msToHMS(ms) {
  const total = Math.max(0, Math.floor(ms / 1000));
  const d = Math.floor(total / 86400);
  const h = Math.floor((total % 86400) / 3600);
  const m = Math.floor((total % 3600) / 60);
  return { d, h, m };
}

// ═══════════════════════════════════════
// LUNAR CALENDAR
// ═══════════════════════════════════════
function buildCalendar() {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  const today = now.getDate();

  const monthNames = ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'];
  document.getElementById('calTitle').textContent = `Лунный календарь · ${monthNames[month]} ${year}`;

  const grid = document.getElementById('calGrid');
  grid.innerHTML = '';

  const dayNames = ['ПН','ВТ','СР','ЧТ','ПТ','СБ','ВС'];
  dayNames.forEach(n => {
    const el = document.createElement('div');
    el.className = 'cal-day-name';
    el.textContent = n;
    grid.appendChild(el);
  });

  const firstDay = new Date(year, month, 1);
  let startDow = firstDay.getDay() - 1; // Mon=0
  if (startDow < 0) startDow = 6;

  for (let i = 0; i < startDow; i++) {
    grid.appendChild(document.createElement('div'));
  }

  const daysInMonth = new Date(year, month + 1, 0).getDate();
  for (let d = 1; d <= daysInMonth; d++) {
    const date = new Date(year, month, d, 12);
    const illum = SunCalc.getMoonIllumination(date);
    const phase = illum.phase;
    const emoji = getMoonEmoji(phase);

    const el = document.createElement('div');
    el.className = 'cal-day';
    if (d === today) el.classList.add('today');
    if (phase < 0.04 || phase > 0.96) el.classList.add('new-moon');
    if (phase > 0.47 && phase < 0.53) el.classList.add('full-moon');

    el.innerHTML = `<span class="moon-emoji">${emoji}</span><span class="day-num">${d}</span>`;
    el.title = `${Math.round(illum.fraction * 100)}% освещено`;
    grid.appendChild(el);
  }
}

// ═══════════════════════════════════════
// MAIN UPDATE
// ═══════════════════════════════════════
function update() {
  const now = new Date();

  // Moon illumination & phase
  const illum = SunCalc.getMoonIllumination(now);
  const phase = illum.phase; // 0-1
  const fraction = illum.fraction; // 0-1

  // Moon position
  const pos = SunCalc.getMoonPosition(now, LAT, LNG);
  const altDeg = pos.altitude * 180 / Math.PI;
  const azDeg = ((pos.azimuth * 180 / Math.PI) + 180 + 360) % 360;

  // Moon times
  const times = SunCalc.getMoonTimes(now, LAT, LNG);
  const rise = times.rise;
  const set = times.set;

  // Distance (km) from parallax
  const distKm = Math.round(1 / Math.sin(pos.parallacticAngle === 0 ? 0.0001 : Math.abs(pos.parallacticAngle)) * 0 + pos.distance);
  // SunCalc doesn't give distance directly, calculate:
  // Earth-Moon distance: avg 384400 km, varies ±21000 based on anomaly
  // Use fraction approach
  const moonDist = Math.round(pos.distance ? pos.distance : 384400);

  // Phase name
  const [phaseName, phaseSub] = getPhaseRu(phase);
  document.getElementById('phaseName').textContent = phaseName;
  document.getElementById('phaseSub').textContent = phaseSub;

  // Zodiac
  const [zodName, zodIcon, zodEl] = getMoonZodiac(now);
  document.getElementById('zodiacName').textContent = zodName;
  document.getElementById('zodiacIcon').textContent = zodIcon;
  document.getElementById('zodiacSub').textContent = `Луна в знаке ${zodName.toLowerCase()} · стихия ${zodEl.toLowerCase()}`;

  // Illumination
  const illumPct = Math.round(fraction * 100);
  document.getElementById('illumVal').textContent = illumPct;
  document.getElementById('illumFill').style.width = illumPct + '%';

  // Age
  const moonAge = phase * SYNODIC;
  document.getElementById('ageVal').textContent = moonAge.toFixed(1);
  document.getElementById('ageFill').style.width = (moonAge / SYNODIC * 100) + '%';

  // Distance
  const distDisplay = Math.round(moonDist).toLocaleString('ru-RU');
  document.getElementById('distVal').textContent = distDisplay;
  const avgDist = 384400;
  const diffKm = Math.round(moonDist - avgDist);
  const closer = diffKm < 0 ? `на ${Math.abs(diffKm).toLocaleString('ru-RU')} км ближе среднего` : `на ${diffKm.toLocaleString('ru-RU')} км дальше среднего`;
  document.getElementById('distSub').textContent = closer;

  // Angular diameter (avg 0.5°, varies)
  const angDiam = (0.5181 * avgDist / moonDist).toFixed(3);
  document.getElementById('paralVal').textContent = angDiam + '°';

  // Altitude
  document.getElementById('altVal').textContent = altDeg.toFixed(1);
  document.getElementById('altValSmall').textContent = altDeg.toFixed(1) + '°';
  const aboveHorizon = altDeg > 0;
  document.getElementById('altSub').textContent = aboveHorizon
    ? `Луна над горизонтом · ${azDir(azDeg)}`
    : `Луна за горизонтом · ${azDir(azDeg)}`;

  // Azimuth
  document.getElementById('azVal').textContent = Math.round(azDeg);
  document.getElementById('azValSmall').textContent = Math.round(azDeg) + '°';
  document.getElementById('azDir').textContent = `Направление: ${azDir(azDeg)}`;
  document.getElementById('visVal').textContent = aboveHorizon ? 'Видна' : 'Не видна';

  // Compass
  drawCompass(azDeg);

  // Moon visual
  drawMoon(phase, fraction);

  // Rise / Set display
  document.getElementById('moonrise').textContent = fmt(rise);
  document.getElementById('moonset').textContent = fmt(set);
  document.getElementById('moonriseSub').textContent = rise ? 'местное время' : 'сегодня не восходит';
  document.getElementById('moonsetSub').textContent = set ? 'местное время' : 'сегодня не заходит';

  // Timeline
  const nowSec = now.getHours() * 3600 + now.getMinutes() * 60 + now.getSeconds();
  const dayLen = 86400;
  const nowPct = nowSec / dayLen * 100;

  document.getElementById('tlNow').style.left = nowPct + '%';
  document.getElementById('tl-rise').textContent = fmt(rise);
  document.getElementById('tl-set').textContent = fmt(set);

  // Transit (highest point - midpoint between rise and set)
  if (rise && set) {
    const transitTime = new Date((rise.getTime() + set.getTime()) / 2);
    document.getElementById('tl-transit').textContent = fmt(transitTime);
    const riseSec = rise.getHours() * 3600 + rise.getMinutes() * 60;
    const setSec = set.getHours() * 3600 + set.getMinutes() * 60;
    const risePct = riseSec / dayLen * 100;
    const setPct = setSec / dayLen * 100;
    document.getElementById('tlArc').style.left = risePct + '%';
    document.getElementById('tlArc').style.width = (setPct - risePct) + '%';

    // Moon dot position on timeline
    const moonPct = Math.max(risePct, Math.min(setPct, nowPct));
    document.getElementById('tlMoonDot').style.left = moonPct + '%';

    // Duration
    const durMs = set - rise;
    const durH = Math.floor(durMs / 3600000);
    const durM = Math.floor((durMs % 3600000) / 60000);
    document.getElementById('tl-duration').textContent = `${durH}ч ${durM}м`;
  } else {
    document.getElementById('tl-transit').textContent = '—';
    document.getElementById('tl-duration').textContent = '—';
  }

  // Night shading (simplified: before sunrise, after sunset)
  const sunTimes = SunCalc.getTimes(now, LAT, LNG);
  if (sunTimes.sunrise && sunTimes.sunset) {
    const srSec = sunTimes.sunrise.getHours() * 3600 + sunTimes.sunrise.getMinutes() * 60;
    const ssSec = sunTimes.sunset.getHours() * 3600 + sunTimes.sunset.getMinutes() * 60;
    document.getElementById('tlNight1').style.left = '0%';
    document.getElementById('tlNight1').style.width = (srSec / dayLen * 100) + '%';
    document.getElementById('tlNight2').style.left = (ssSec / dayLen * 100) + '%';
    document.getElementById('tlNight2').style.width = ((dayLen - ssSec) / dayLen * 100) + '%';
  }

  // Countdown
  const { fullDate, newDate } = nextMoonEvent(phase, now);

  // Determine which is first
  const toFull = fullDate - now;
  const toNew = newDate - now;

  const first = toFull < toNew ? { name: 'Полнолуние 🌕', ms: toFull } : { name: 'Новолуние 🌑', ms: toNew };
  const second = toFull < toNew ? { name: 'Новолуние 🌑', ms: toNew } : { name: 'Полнолуние 🌕', ms: toFull };

  const t1 = msToHMS(first.ms);
  const t2 = msToHMS(second.ms);

  document.getElementById('nextEventName').textContent = first.name;
  document.getElementById('cd1-d').textContent = t1.d;
  document.getElementById('cd1-h').textContent = String(t1.h).padStart(2,'0');
  document.getElementById('cd1-m').textContent = String(t1.m).padStart(2,'0');

  document.getElementById('nextEventName2').textContent = second.name;
  document.getElementById('cd2-d').textContent = t2.d;
  document.getElementById('cd2-h').textContent = String(t2.h).padStart(2,'0');
  document.getElementById('cd2-m').textContent = String(t2.m).padStart(2,'0');

  // Moonrise / set tile
  document.getElementById('tl-rise').textContent = fmt(rise);
}

// ═══════════════════════════════════════
// INIT
// ═══════════════════════════════════════
buildCalendar();
update();
setInterval(update, 10000); // update every 10s
setInterval(function() {
  // more frequent minor updates
  const now = new Date();
  const illum = SunCalc.getMoonIllumination(now);
  const pos = SunCalc.getMoonPosition(now, LAT, LNG);
  const altDeg = pos.altitude * 180 / Math.PI;
  const azDeg = ((pos.azimuth * 180 / Math.PI) + 180 + 360) % 360;
  drawCompass(azDeg);
  document.getElementById('altVal').textContent = altDeg.toFixed(1);
  document.getElementById('altValSmall').textContent = altDeg.toFixed(1) + '°';
  document.getElementById('azVal').textContent = Math.round(azDeg);
  document.getElementById('azValSmall').textContent = Math.round(azDeg) + '°';
}, 30000);
</script>
</body>
</html>
