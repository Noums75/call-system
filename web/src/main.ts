type ServiceOption = {
  value: string;
  label: string;
};

const serviceOptions: ServiceOption[] = [
  { value: 'gendarmerie', label: 'Gendarmerie' },
  { value: 'police', label: 'Police nationale' },
  { value: 'sdis2a', label: 'SDIS 2A – Pompiers Corse-du-Sud' },
  { value: 'sdis2b', label: 'SDIS 2B – Pompiers Haute-Corse' },
  { value: 'samu2a', label: 'SAMU 2A – Corse-du-Sud' },
  { value: 'samu2b', label: 'SAMU 2B – Haute-Corse' },
  { value: 'snsm', label: 'SNSM – Secours en mer' }
];

const root = document.getElementById('app') as HTMLDivElement;
const serviceSelect = document.getElementById('service') as HTMLSelectElement;
const identityInput = document.getElementById('identity') as HTMLInputElement;
const descriptionInput = document.getElementById('description') as HTMLTextAreaElement;
const messageElement = document.getElementById('message') as HTMLDivElement;
const form = document.getElementById('call-form') as HTMLFormElement;
const cancelButton = document.getElementById('cancel') as HTMLButtonElement;

function populateServices() {
  serviceSelect.innerHTML = '';
  serviceOptions.forEach((option) => {
    const element = document.createElement('option');
    element.value = option.value;
    element.textContent = option.label;
    serviceSelect.appendChild(element);
  });
}

function setVisible(visible: boolean) {
  if (!root) return;
  if (visible) {
    root.classList.remove('hidden');
    identityInput.focus();
  } else {
    root.classList.add('hidden');
    form.reset();
    messageElement.textContent = '';
  }
}

async function postNui<T>(path: string, body?: unknown): Promise<T> {
  const response = await fetch(`https://call-system/${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: body ? JSON.stringify(body) : undefined
  });

  return (await response.json()) as T;
}

function showMessage(text: string) {
  messageElement.textContent = text;
}

form.addEventListener('submit', async (event) => {
  event.preventDefault();
  showMessage('');

  const payload = {
    serviceType: serviceSelect.value,
    identity: identityInput.value.trim(),
    description: descriptionInput.value.trim()
  };

  if (!payload.identity) {
    showMessage('Merci d’indiquer votre identité.');
    return;
  }

  if (payload.description.length < 5) {
    showMessage('Merci de décrire la situation (5 caractères minimum).');
    return;
  }

  try {
    const result = await postNui<{ ok: boolean; message?: string }>('submitCall', payload);
    if (!result.ok) {
      showMessage(result.message ?? 'Impossible d’envoyer l’appel.');
      return;
    }

    setVisible(false);
  } catch (error) {
    console.error(error);
    showMessage('Une erreur est survenue.');
  }
});

cancelButton.addEventListener('click', async () => {
  await postNui('close');
  setVisible(false);
});

window.addEventListener('message', (event: MessageEvent) => {
  if (event.data?.action === 'open') {
    setVisible(true);
  }

  if (event.data?.action === 'close') {
    setVisible(false);
  }
});

populateServices();
setVisible(false);
