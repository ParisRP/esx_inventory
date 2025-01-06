window.addEventListener('message', function (event) {
    const data = event.data;

    if (data.action === 'openInventory') {
        const inventory = data.inventory;
        const itemList = document.getElementById('item-list');
        itemList.innerHTML = '';

        inventory.forEach(item => {
            const li = document.createElement('li');
            li.textContent = `${item.label} x${item.count}`;
            itemList.appendChild(li);
        });

        document.getElementById('inventory').style.display = 'block';
    }

    if (data.action === 'closeInventory') {
        document.getElementById('inventory').style.display = 'none';
    }
});
