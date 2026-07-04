# Guía del Estudiante: EFT Trazabilidad en Cadena de Suministro de Frutas de Exportación

**Curso:** Fundamentos de Blockchain (BCY0010)  
**Evaluación:** Evaluación Final Transversal (EFT)


Esta guía tiene como objetivo orientar a los estudiantes en la resolución del andamiaje (*scaffolding*) del contrato inteligente de trazabilidad de fruta. 
Para facilitar su desarrollo técnico, el código base ya está estructurado y contiene secciones específicas que deben completar.

---

## 🎯 Indicadores de Evaluación (IE) Asociados

El diseño de esta plantilla y su defensa individual evalúan los siguientes indicadores clave de la rúbrica institucional:

### 1. `[IE2 - Criptografía Aplicada y Firmas]`
*   **Descripción:** Comprender cómo las firmas digitales basadas en criptografía de clave pública y privada garantizan la autenticidad y el no-repudio de las transacciones.
*   **En el Contrato:** Se implementa en las funciones `registrarLote`, `actualizarTransito` y `certificarLote`. Valida que `msg.sender` corresponda a una billetera autorizada en la lista blanca de su respectivo rol.

### 2. `[IE4 - Estructura de Bloque e Inmutabilidad]`
*   **Descripción:** Analizar cómo el almacenamiento persistente en la Blockchain y el encadenamiento de bloques aseguran la inalterabilidad de los datos históricos.
*   **En el Contrato:** Representado por las estructuras `LoteFruta` y `HitoLogistico[]`. Cada estado de la cadena logística se añade de forma secuencial y definitiva al almacenamiento (`storage`), impidiendo que un lote o hito sea modificado o eliminado a posteriori.

### 3. `[IE6 / IE7 - Seguridad y Uso de Librerías Estándar]`
*   **Descripción:** Aplicación de mejores prácticas de la industria mediante contratos auditados y de código abierto para evitar vulnerabilidades comunes como la reentrada y la centralización no controlada.
*   **En el Contrato:** Se importan y heredan de forma nativa desde OpenZeppelin:
    *   `Ownable`: Define al administrador principal (ej: Autoridad Reguladora o SAG) encargado de enrolar actores de la cadena.
    *   `ReentrancyGuard`: Previene ataques de reentrada (`nonReentrant`) ante eventuales llamadas externas maliciosas.

### 4. `[IE9 - Conexión con el Mundo Real / Oráculos]`
*   **Descripción:** Entender cómo se alimenta una red blockchain con datos externos garantizando la veracidad de la información proveniente del mundo físico.
*   **En el Contrato:** Explicación teórica de cómo sensores IoT (temperatura del contenedor frigorífico) automatizarían el envío de datos mediante Redes de Oráculos Descentralizados (como Chainlink) sin intervención manual de los actores, mitigando riesgos de alteración o colusión humana.

### 5. `[IE11 - Marco Normativo y Ético]`
*   **Descripción:** Evaluar el impacto de la tecnología blockchain en la sociedad, el cumplimiento normativo nacional y las implicaciones éticas del almacenamiento permanente.
*   **En el Contrato:** Notas reflexivas obligatorias para la defensa de la EFT:
    *   **Ley N° 19.628 (Protección de la Vida Privada en Chile):** Analizar si es ético o legal almacenar nombres o RUTs en la Blockchain. (Solución: Usar identificadores pseudo-anónimos como las direcciones hexadecimales de las billeteras).
    *   **Ley de Infraestructura Crítica:** La cadena alimentaria de exportación es crítica para la economía chilena. Un hackeo o falsificación de datos daña el prestigio país.
    *   **Dilema "Garbage In, Garbage Out":** Blockchain asegura que el dato ingresado no cambiará, pero si el productor ingresa que la fruta es orgánica del Valle del Maule siendo que es convencional de otra región, la blockchain registrará una falsedad inmutable. Esto requiere auditorías físicas y éticas complementarias.

---

## 🛠️ Instrucciones de Desarrollo en Remix IDE

### Paso 1: Cargar el Código en Remix IDE
1. Ingrese a [Remix IDE](https://remix.ethereum.org/).
2. En el panel izquierdo (*File Explorer*), cree un nuevo archivo llamado `FruitSupplyChain.sol` dentro de la carpeta `contracts`.
3. Copie el código completo del archivo [FruitSupplyChain.sol](../src/FruitSupplyChain.sol) y péguelo en Remix.

### Paso 2: Completar las Secciones "TODO" (Andamiaje)
Debe abrir el archivo y completar los bloques vacíos indicados con comentarios `TODO`. A continuación se detalla la lógica condicional que debe programar utilizando la sentencia `require`:

#### 1. En la función `registrarLote`:
*   **Lógica 1:** Asegurar que el remitente (`msg.sender`) es un productor autorizado en la lista blanca de productores.
    ```solidity
    // TODO: Implementar validación para asegurar que solo un Productor registrado pueda ejecutar esta función.
    require(producers[msg.sender], "Solo productores autorizados");
    ```
*   **Lógica 2:** Comprobar que el ID del lote no haya sido registrado antes para evitar colisiones e inmutar datos correctos.
    ```solidity
    // TODO: Implementar validación para verificar que el lote no haya sido registrado previamente.
    require(!lotExists[_idLote], "El lote ya existe");
    ```

#### 2. En la función `actualizarTransito`:
*   **Lógica 1:** Asegurar que el remitente (`msg.sender`) es un transportista autorizado.
    ```solidity
    // TODO: Implementar validación para asegurar que solo un Transportista registrado pueda ejecutar esta función.
    require(transporters[msg.sender], "Solo transportistas autorizados");
    ```
*   **Lógica 2:** Comprobar que el lote realmente existe antes de intentar actualizar su trayecto.
    ```solidity
    // TODO: Implementar validación para verificar que el lote exista en el sistema antes de actualizarlo.
    require(lotExists[_idLote], "El lote no existe");
    ```
*   **Lógica 3:** Limitar la temperatura para no romper la cadena de frío. La fruta no debe superar los 8°C.
    ```solidity
    // TODO: Implementar validación para comprobar que la temperatura no supere el límite crítico de 8 grados Celsius (8 °C).
    require(_temperatura <= 8, "Temperatura excede limite critico de 8C");
    ```

#### 3. En la función `certificarLote`:
*   **Lógica 1:** Validar que quien certifica sea un inspector de aduanas autorizado.
    ```solidity
    // TODO: Implementar validación para asegurar que solo un Inspector registrado pueda ejecutar esta función.
    require(inspectors[msg.sender], "Solo inspectores autorizados");
    ```
*   **Lógica 2:** Comprobar que el lote exista en el sistema.
    ```solidity
    // TODO: Implementar validación para verificar que el lote exista.
    require(lotExists[_idLote], "El lote no existe");
    ```

---

## 🚀 Guía de Despliegue y Simulación (Flujo de Pruebas en Laboratorio)

Una vez completado el código, siga este orden de transacciones para demostrar el funcionamiento del smart contract:

### 1. Compilación
*   Vaya a la pestaña **Solidity Compiler**.
*   Seleccione la versión del compilador **0.8.20** o superior.
*   Presione **Compile FruitSupplyChain.sol**.

### 2. Despliegue (Deploy)
*   Vaya a la pestaña **Deploy & Run Transactions**.
*   En **Environment**, elija **Remix VM (Cancun)** o similar.
*   Verá una lista de 10 cuentas de prueba, cada una con 100 ether simulados.
*   **Cuenta 1 (Administrador / Regulador):** Copie su dirección.
*   En el botón naranja **Deploy**, verá un campo de entrada para `initialOwner`. Pegue la dirección de la Cuenta 1 y presione **Deploy**.

### 3. Registro de Actores en la Lista Blanca
Desde la Cuenta 1 (Owner), ejecute:
*   `registrarProductor`: Copie la dirección de la **Cuenta 2** y regístrela.
*   `registrarTransportista`: Copie la dirección de la **Cuenta 3** y regístrela.
*   `registrarInspector`: Copie la dirección de la **Cuenta 4** y regístrela.

### 4. Ciclo de Vida de la Fruta (Simulación del Negocio)
*   **Paso 4.1 (Producción):** Cambie la cuenta activa en Remix a la **Cuenta 2 (Productor)**. Ejecute `registrarLote` con parámetros: `_idLote = 101`, `_localizacion = "Curico Packing San Clemente"`, `_temperatura = 4`.
*   **Paso 4.2 (Tránsito):** Cambie la cuenta activa a la **Cuenta 3 (Transportista)**. Ejecute `actualizarTransito` con parámetros: `_idLote = 101`, `_nuevaLocalizacion = "Ruta 5 Sur - Kilometro 180"`, `_temperatura = 5`.
    *   *Desafío Estudiante:* Intente mandar una temperatura de `10`°C. La transacción debe fallar por exceder el límite crítico establecido en el require.
*   **Paso 4.3 (Certificación de Aduanas):** Cambie la cuenta activa a la **Cuenta 4 (Inspector)**. Ejecute `certificarLote` con parámetros: `_idLote = 101`, `_aprobado = true`, `_localizacion = "Aduana Puerto Valparaiso"`, `_temperatura = 3`.

### 5. Auditoría del Historial Inmutable
*   Llame a la función de lectura `obtenerHistorial(101)` desde cualquier cuenta.
*   Verifique cómo se despliegan en orden secuencial e inalterable los 3 hitos con sus correspondientes marcas de tiempo (`timestamp`), localizaciones, temperaturas e identidades criptográficas (`actor`) que firmaron la transacción.

---

## 💬 Preguntas Clave para Preparar la Defensa Individual

Prepare las respuestas a estas preguntas utilizando los conceptos aprendidos para asegurar la nota máxima en la defensa oral:

1.  **¿Por qué usamos `msg.sender` en lugar de pasar la dirección de la billetera como parámetro en las funciones operativas?**
    *   *Respuesta Clave:* Si pasamos la billetera como parámetro, cualquiera podría suplantar la identidad de otro actor. Usar `msg.sender` extrae criptográficamente la dirección que firmó digitalmente la transacción con su clave privada, asegurando autenticidad y no-repudio.
2.  **¿Qué pasaría si la temperatura del lote sube a 15°C durante el viaje y el transportista altera manualmente el envío de datos en su app para poner 5°C?**
    *   *Respuesta Clave:* El contrato inteligente no puede validar por sí mismo la veracidad física de los datos de entrada ("Garbage In, Garbage Out"). Registraría 5°C inmutablemente. Para solucionar este problema ético y operativo, se deben implementar oráculos IoT descentralizados conectados directamente a sensores calibrados sin manipulación humana.
3.  **¿Cómo cumple este diseño con la Ley de Protección de Datos Personales (Ley 19.628) en Chile?**
    *   *Respuesta Clave:* Al almacenar únicamente IDs numéricos de lotes, temperaturas y direcciones hash hexadecimales de billeteras públicas (pseudonimización), evitamos guardar datos sensibles identificatorios directos (como nombres, RUT o teléfonos de choferes o dueños de packing) en un registro que por definición es público e inmutable.
