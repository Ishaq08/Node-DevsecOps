const list = document.getElementById('task-list');
const form = document.getElementById('task-form');
const input = document.getElementById('task-input');
const errorBox = document.getElementById('error');
const empty = document.getElementById('empty');
const remaining = document.getElementById('remaining');

async function api(path, options = {}) {
  const res = await fetch('/api/tasks' + path, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || 'Request failed');
  return data;
}

function render(tasks) {
  list.innerHTML = '';
  tasks.forEach((task) => {
    const li = document.createElement('li');
    if (task.done) li.className = 'done';

    const check = document.createElement('input');
    check.type = 'checkbox';
    check.checked = task.done;
    check.setAttribute('aria-label', 'Mark "' + task.title + '" as done');
    check.addEventListener('change', () => update(task._id, check.checked));

    const text = document.createElement('span');
    text.textContent = task.title; // textContent prevents XSS

    const del = document.createElement('button');
    del.textContent = 'Delete';
    del.addEventListener('click', () => remove(task._id));

    li.append(check, text, del);
    list.appendChild(li);
  });
  empty.hidden = tasks.length > 0;
  remaining.textContent = tasks.filter((t) => !t.done).length;
}

async function load() {
  try {
    errorBox.textContent = '';
    render(await api(''));
  } catch (err) {
    errorBox.textContent = err.message;
  }
}

async function update(id, done) {
  try { await api('/' + id, { method: 'PUT', body: JSON.stringify({ done }) }); await load(); }
  catch (err) { errorBox.textContent = err.message; }
}

async function remove(id) {
  try { await api('/' + id, { method: 'DELETE' }); await load(); }
  catch (err) { errorBox.textContent = err.message; }
}

form.addEventListener('submit', async (e) => {
  e.preventDefault();
  try {
    await api('', { method: 'POST', body: JSON.stringify({ title: input.value }) });
    input.value = '';
    await load();
  } catch (err) {
    errorBox.textContent = err.message;
  }
});

load();
