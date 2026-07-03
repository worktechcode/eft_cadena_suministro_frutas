# 🛠️ Guía de Despliegue en Remix IDE (Remix VM)

Esta guía detalla el flujo de trabajo para compilar, desplegar y probar el contrato inteligente `./src/FruitSupplyChain.sol` en **Remix IDE** utilizando el entorno local de pruebas **Remix VM**.

---

## 📋 Requisitos Previos

1. Disponer de un navegador web moderno (Chrome, Brave, Firefox, Edge).
2. Tener acceso a la red de internet (para resolver las dependencias de OpenZeppelin directamente desde GitHub/npm).

---

## 🚀 Paso a Paso

### 1. Cargar el Contrato
1. Abra [Remix IDE](https://remix.ethereum.org/).
2. En la barra lateral izquierda, seleccione la pestaña **File Explorer**.
3. Haga clic derecho sobre la carpeta `contracts` y seleccione **New File**. Nómbrelo `FruitSupplyChain.sol`.
4. Copie el contenido del archivo de la plantilla: [FruitSupplyChain.sol](../src/FruitSupplyChain.sol) y péguelo en el editor de Remix.

### 2. Compilar el Contrato
1. Seleccione la pestaña **Solidity Compiler** en la barra lateral izquierda (el icono de compilador de Solidity).
2. Asegúrese de seleccionar la versión del compilador **0.8.20** o superior (preferiblemente `0.8.20+commit.a1b79de6`).
3. En la sección *Compiler*, mantenga la configuración estándar.
4. Haga clic en el botón azul **Compile FruitSupplyChain.sol**.
5. Verifique que aparece un check verde en el icono del compilador, indicando que el contrato se compiló correctamente sin errores sintácticos.

### 3. Configurar el Entorno de Despliegue
1. Vaya a la pestaña **Deploy & Run Transactions** (el icono de Ethereum con una flecha).
2. En la propiedad **Environment**, seleccione **Remix VM (Cancun)**. Esto habilitará 10 cuentas de prueba locales con 100 ether ficticios cada una.
3. Asegúrese de que el contrato seleccionado en la pestaña *Contract* sea `FruitSupplyChain`.

### 4. Desplegar el Contrato
1. En la lista de cuentas de *Account*, seleccione la **primera cuenta (Cuenta 1)**. Esta cuenta actuará como el Administrador o Autoridad Reguladora (rol `owner`).
2. Copie la dirección pública de esta cuenta (haciendo clic en el icono de copiar al lado de la cuenta).
3. Busque el botón naranja **Deploy**. A la derecha, verá un campo de texto denominado `initialOwner`.
4. Pegue la dirección que acaba de copiar en el campo `initialOwner`.
5. Presione el botón **Deploy**.
6. En la parte inferior derecha del terminal de Remix, aparecerá un mensaje de éxito con un check verde que confirma la creación del contrato. El contrato desplegado aparecerá en la sección **Deployed Contracts**.

---

## 🧪 Simulación del Caso de Uso Logístico

Una vez desplegado el contrato, puede simular el ciclo de vida de un lote de frutas siguiendo estos pasos:

### Fase 1: Registrar Actores (Desde la Cuenta 1 - Owner)
*   **Paso 1.1:** Seleccione la **Cuenta 2** de la lista *Account* de Remix y copie su dirección. Cambie de nuevo a la **Cuenta 1**. Expanda las funciones del contrato desplegado. Busque la función `registrarProductor`, pegue la dirección de la Cuenta 2 y presione **transact**.
*   **Paso 1.2:** Seleccione la **Cuenta 3** de la lista y copie su dirección. Cambie a la **Cuenta 1**, busque `registrarTransportista`, pegue la dirección y presione **transact**.
*   **Paso 1.3:** Seleccione la **Cuenta 4** de la lista y copie su dirección. Cambie a la **Cuenta 1**, busque `registrarInspector`, pegue la dirección y presione **transact**.

### Fase 2: Registrar Lote (Desde la Cuenta 2 - Productor)
1. Cambie de cuenta activa en Remix a la **Cuenta 2 (Productor)**.
2. Busque la función `registrarLote` (de color naranja/rojo).
3. Ingrese los parámetros requeridos:
   *   `_idLote`: `101`
   *   `_localizacion`: `"Valle de Curico - AgroPacking Sur"`
   *   `_temperatura`: `4`
4. Presione **transact**. La transacción se procesará correctamente.
5. *Prueba de Error (Control de Acceso):* Intente ejecutar esta misma transacción usando la Cuenta 3 o 4. Debe fallar con el error `"Solo productores autorizados"`.

### Fase 3: Actualizar Tránsito (Desde la Cuenta 3 - Transportista)
1. Cambie de cuenta activa en Remix a la **Cuenta 3 (Transportista)**.
2. Busque la función `actualizarTransito`.
3. Ingrese los parámetros requeridos:
   *   `_idLote`: `101`
   *   `_nuevaLocalizacion`: `"Ruta 5 Sur - Control Sanitario Champa"`
   *   `_temperatura`: `5`
4. Presione **transact**.
5. *Prueba de Error (Límite Crítico):* Intente ejecutar la función con una temperatura de `9` o superior. La transacción fallará inmediatamente con el mensaje `"Temperatura excede limite critico de 8C"`.

### Fase 4: Certificar Lote (Desde la Cuenta 4 - Inspector de Aduanas)
1. Cambie de cuenta activa en Remix a la **Cuenta 4 (Inspector)**.
2. Busque la función `certificarLote`.
3. Ingrese los parámetros requeridos:
   *   `_idLote`: `101`
   *   `_aprobado`: `true`
   *   `_localizacion`: `"Aduana de Puerto Valparaiso"`
   *   `_temperatura`: `4`
4. Presione **transact**. El estado del lote cambiará a `Aprobado`.

### Fase 5: Consultar Historial Inmutable (Cualquier Cuenta)
1. Busque la función de lectura (azul) `obtenerHistorial`.
2. Ingrese el ID del lote: `101`.
3. Presione **call**.
4. Verá el desglose secuencial de los tres hitos registrados inmutablemente en la Blockchain, con sus marcas de tiempo reales, temperaturas y direcciones de firmas criptográficas correspondientes.
