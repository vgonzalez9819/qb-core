let draggedItem = null;

window.addEventListener('message', function(event) {
    if (event.data.action === 'open') {
        document.getElementById('gearContainer').style.display = 'block';
    } else if (event.data.action === 'close') {
        document.getElementById('gearContainer').style.display = 'none';
    } else if (event.data.action === 'setGear') {
        renderGear(event.data.slots, event.data.gear);
    }
});

window.startGearDrag = function(itemName) {
    draggedItem = itemName;
}

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
        el.dataset.slot = slot;
        el.innerHTML = `<b>${slots[slot].label}</b><br>${item ? item.name : 'Empty'}`;
        el.ondragover = (ev) => ev.preventDefault();
        el.ondrop = () => {
            if (draggedItem) {
                fetch('https://gear_system/equip', {method:'POST', body: JSON.stringify({item: draggedItem})});
                draggedItem = null;
            }
        };
        if (item) {
            const btn = document.createElement('button');
            btn.innerText = 'Unequip';
            btn.onclick = () => fetch('https://gear_system/unequip', {method:'POST', body: JSON.stringify({slot: slot})});
            el.appendChild(btn);
        }
        slotDiv.appendChild(el);
    }
}
