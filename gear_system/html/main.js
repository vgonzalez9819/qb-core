window.addEventListener('message', function(event) {
    if (event.data.action === 'open') {
        document.getElementById('gearContainer').style.display = 'block';
    } else if (event.data.action === 'setGear') {
        renderGear(event.data.slots, event.data.gear);
    }
});

document.getElementById('closeBtn').addEventListener('click', function() {
    fetch('https://gear_system/close', {method: 'POST'});
});

function renderGear(slots, gear) {
    const slotDiv = document.getElementById('slots');
    slotDiv.innerHTML = '';
    for (let slot in slots) {
        const item = gear[slot];
        const el = document.createElement('div');
        el.className = 'slot';
        el.innerHTML = `<b>${slots[slot].label}</b>: ${item ? item.name : 'Empty'}`;
        if (item) {
            const btn = document.createElement('button');
            btn.innerText = 'Unequip';
            btn.onclick = () => fetch('https://gear_system/unequip', {method:'POST', body: JSON.stringify({slot: slot})});
            el.appendChild(btn);
        }
        slotDiv.appendChild(el);
    }
}
