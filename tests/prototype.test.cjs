const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const vm = require('node:vm');

const html = fs.readFileSync(path.join(__dirname, '..', 'index.html'), 'utf8');
const gameScript = html.match(/<script>([\s\S]*?)<\/script>/)?.[1];
assert.ok(gameScript, 'index.html should contain the game script');

function element(id = '') {
  let innerHTML = '';
  return {
    id,
    children: [],
    style: {},
    dataset: {},
    listeners: {},
    hidden: false,
    get innerHTML() { return innerHTML; },
    set innerHTML(value) {
      innerHTML = value;
      if (this.id === 'board') this.children = [];
    },
    appendChild(child) { this.children.push(child); },
    addEventListener(name, callback) { this.listeners[name] = callback; },
    setAttribute() {},
  };
}

function createGame() {
  const elements = Object.fromEntries(
    ['board', 'laser', 'status', 'levelTitle', 'send', 'next', 'reset']
      .map((id) => [id, element(id)]),
  );
  const context = {
    document: {
      getElementById: (id) => elements[id],
      createElement: () => element(),
    },
    addEventListener() {},
    console,
  };
  vm.runInNewContext(gameScript, context, { filename: 'index.html' });
  return { context, elements };
}

test('all three puzzles start unsolved and have a working route to the receiver', () => {
  const { context: game, elements } = createGame();
  const solutions = [
    [[3, 2]],
    [[2, 1], [4, 2]],
    [[2, 4]],
  ];

  for (let level = 0; level < solutions.length; level += 1) {
    game.send();
    assert.match(elements.status.textContent, /^PULSE LOST/, `level ${level + 1} should start unsolved`);

    for (const [x, y] of solutions[level]) {
      const button = elements.board.children[game.index(x, y)];
      assert.equal(typeof button.listeners.click, 'function', `relay at ${x},${y} should be clickable`);
      button.listeners.click();
    }

    game.send();
    assert.match(elements.status.textContent, /SIGNAL RECEIVED|ALL FIELD TESTS COMPLETE/);
    if (level < solutions.length - 1) {
      assert.equal(elements.next.hidden, false, 'next-level control should appear after a solve');
      elements.next.onclick();
    }
  }

  assert.match(elements.status.textContent, /ALL FIELD TESTS COMPLETE/);
});

test('reset restores the first puzzle to its initial unsolved state', () => {
  const { context: game, elements } = createGame();
  elements.board.children[game.index(3, 2)].listeners.click();
  game.send();
  assert.match(elements.status.textContent, /SIGNAL RECEIVED/);

  elements.reset.onclick();
  assert.equal(vm.runInContext('levelIndex', game), 0);
  assert.equal(vm.runInContext('tiles[index(3, 2)].dir', game), 0);
  game.send();
  assert.match(elements.status.textContent, /^PULSE LOST/);
});
