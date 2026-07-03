# Guía del Estudiante: EFT Trazabilidad en Cadena de Suministro de Frutas de Exportación

**Curso:** Fundamentos de Blockchain (BCY0010)  
**Evaluación:** Evaluación Final Transversal (EFT)

Este repositorio contiene un *boilerplate* (plantilla base de código) en **Solidity (versión ^0.8.20)** diseñado para estudiantes de pregrado de la asignatura optativa **Fundamentos de Blockchain (BCY0010)**, en preparación de su **Evaluación Final Transversal (EFT)**.

El objetivo es simular el registro inmutable y secuencial del ciclo de vida de exportación de fruta certificada en una cadena de suministro, controlando roles autorizados y variables críticas como la temperatura.

---

## 📂 Estructura del Proyecto

Toda la documentación y referencias usan enlaces relativos a la raíz del proyecto para facilitar la portabilidad:

*   [`src/FruitSupplyChain.sol`](./src/FruitSupplyChain.sol): Código fuente del contrato inteligente en Solidity con andamiaje (secciones `TODO` para lógica de requiere y anotaciones de indicadores de evaluación).
*   [`docs/EFT_Guia_Estudiante.md`](./docs/EFT_Guia_Estudiante.md): Guía pedagógica del estudiante con el mapeo de la rúbrica institucional (IE2, IE4, IE9, IE11) y soluciones lógicas.
*   [`infra/DeployRemixGuide.md`](./infra/DeployRemixGuide.md): Guía detallada paso a paso de compilación, despliegue e interacción en Remix IDE usando Remix VM.
*   `logs/`: Registro temporal de logs de acciones realizadas por sesión.
*   `docs/`: Documentación de decisiones arquitectónicas y aprendizajes.

---

## 🛠️ Requerimientos del Sistema (Entorno Local)

Para clonar, compilar y ejecutar pruebas a nivel local en su estación de trabajo, instale las siguientes herramientas:

1.  **Node.js** (Versión 18.x o superior recomendada).
2.  **npm** (Incluido por defecto al instalar Node.js).
3.  Un editor de código (e.g., VS Code con la extensión de Solidity) o en su defecto use **Remix IDE** web.

---

## 🚀 Instrucciones para Pruebas y Compilación Local

Siga estos comandos para configurar el entorno y verificar la compilación utilizando Hardhat:

### 1. Instalar las Dependencias
Instale el framework Hardhat y los contratos auditados de OpenZeppelin configurados en el proyecto:
```bash
npm install
```

### 2. Compilar el Contrato Inteligente
Ejecute el proceso de compilación para generar los artefactos del contrato (ABI y Bytecode):
```bash
npm run compile
```

### 3. Ejecutar las Pruebas Unitarias
Para correr los tests unitarios automatizados que verifican el cumplimiento de la lógica:
```bash
npm run test
```

*Nota: Para el desarrollo diario en el laboratorio y una rápida interacción visual, se aconseja seguir la guía de Remix IDE descrita en [`infra/DeployRemixGuide.md`](./infra/DeployRemixGuide.md).*

---

## 🎓 Alineación con los Indicadores de Evaluación (IE)

El contrato inteligente contiene marcadores en forma de comentarios estructurados que vinculan directamente el código con los criterios de evaluación del Encargo Grupal y la Defensa Individual:

*   `// [IE2 - Criptografía Aplicada y Firmas]`: Validación de wallets mediante `msg.sender`.
*   `// [IE4 - Estructura de Bloque e Inmutabilidad]`: Persistencia inalterable en `storage` con `historialLotes`.
*   `// [IE6 / IE7 - Seguridad y Librerías]`: Uso de `Ownable` y `ReentrancyGuard` de OpenZeppelin.
*   `// [IE9 - Conexión con el Mundo Real / Oráculos]`: Explicación conceptual sobre telemetría IoT y Chainlink.
*   `// [IE11 - Marco Normativo y Ético]`: Análisis de Ley N° 19.628 de Privacidad de Datos en Chile, Ley de Infraestructura Crítica y dilema de entrada de datos fraudulentos ("Garbage In, Garbage Out").
