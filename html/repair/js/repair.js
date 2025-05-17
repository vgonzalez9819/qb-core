window.addEventListener('message', function(event) {
    if (event.data.action === 'open') {
        document.getElementById('container').classList.remove('hidden');
        document.getElementById('hp-fill').style.width = event.data.hp / 10 + '%';
        document.getElementById('status').innerText = event.data.vip ? 'VIP Vehicle' : '';
    } else if (event.data.action === 'close') {
        document.getElementById('container').classList.add('hidden');
    }
});

document.getElementById('repair-btn').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/repair`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ hp: 0, vip: false })
    });
});

document.getElementById('close-btn').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' }
    });
});
