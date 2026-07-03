// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importaciones directas de OpenZeppelin Contracts, compatibles con Remix IDE de forma nativa
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title FruitSupplyChain
 * @author Desarrollador Principal de Solidity / Ingeniero Senior en Blockchain
 * @notice Contrato inteligente de andamiaje para la trazabilidad inmutable de la cadena de suministro de frutas.
 * @dev Diseñado con fines pedagógicos para la Evaluación Final Transversal (EFT) de la asignatura
 * Fundamentos de Blockchain (BCY0010).
 * 
 * [IE11 - Marco Normativo y Ético]
 * NOTA ÉTICO-LEGAL PARA EL ALUMNO (Análisis Obligatorio):
 * Al implementar soluciones descentralizadas en Chile, es imperativo analizar el cumplimiento de:
 * 1. Ley N° 19.628 sobre Protección de la Vida Privada (y sus modificaciones alineadas con el estándar GDPR):
 *    Los datos personales (como direcciones de billeteras asociadas a personas naturales) no deben ser expuestos
 *    de forma que vulneren la privacidad. En este contrato solo registramos datos técnicos e institucionales.
 * 2. Ley de Infraestructura Crítica en Chile: La cadena de suministro alimentaria es parte fundamental de la seguridad
 *    y el abastecimiento nacional. La resiliencia criptográfica de este contrato ayuda a proteger esta infraestructura.
 * 3. El Dilema del "Oráculo Corrupto" u "Origen Falso" (Garbage In, Garbage Out): Blockchain garantiza que los
 *    datos no se modifiquen una vez registrados (inmutabilidad), pero NO garantiza que los datos ingresados
 *    inicialmente sean verdaderos. Si el Productor ingresa información falsa sobre el origen orgánico de la fruta,
 *    el sistema registrará esa mentira inmutablemente. Esto plantea un debate ético crucial sobre la auditoría del
 *    punto físico de entrada de datos en sistemas descentralizados.
 */
contract FruitSupplyChain is Ownable, ReentrancyGuard {

    // --- ENUMS Y ESTRUCTURAS ---

    enum EstadoLote { Creado, EnTransito, Inspeccionado, Aprobado }

    // [IE4 - Estructura de Bloque e Inmutabilidad]
    // Definimos un registro secuencial de hitos (HitoLogistico) y el estado actual del lote (LoteFruta).
    // Cada vez que se interactúa con el contrato, los datos se almacenan de forma permanente e inalterable
    // en el estado de la EVM (storage). Esto genera un historial auditable del cual ningún actor puede retractarse
    // (no repudio), garantizado por el hash del bloque y el encadenamiento criptográfico.
    
    struct HitoLogistico {
        string localizacion;
        int256 temperatura;
        EstadoLote estado;
        uint256 timestamp;
        address actor;
    }

    struct LoteFruta {
        uint256 idLote;
        string localizacionActual;
        int256 temperaturaRegistrada;
        EstadoLote estadoLote;
        uint256 timestamp;
        address registrador;
    }

    // --- ESTADO DEL CONTRATO ---

    // Mapeo para comprobar si un lote ya existe en el sistema
    mapping(uint256 => bool) public lotExists;

    // Mapeo para obtener el estado actual de cualquier lote por su ID
    mapping(uint256 => LoteFruta) public lots;

    // Mapeo para registrar el historial completo e inmutable de hitos de cada lote
    mapping(uint256 => HitoLogistico[]) public lotHistory;

    // Mapeos de listas blancas para el control de acceso de actores autorizados
    mapping(address => bool) public producers;
    mapping(address => bool) public transporters;
    mapping(address => bool) public inspectors;

    // --- EVENTOS ---

    event LoteRegistrado(uint256 indexed idLote, address indexed productor, string localizacion, int256 temperatura);
    event TransitoActualizado(uint256 indexed idLote, address indexed transportista, string localizacion, int256 temperatura);
    event LoteCertificado(uint256 indexed idLote, address indexed inspector, bool aprobado, string localizacion, int256 temperatura);
    event ActorRegistrado(address indexed actor, string rol);

    // --- CONSTRUCTOR ---

    /**
     * @dev Constructor del contrato. Define al propietario inicial (dueño/regulador).
     * Nota: En OpenZeppelin v5, Ownable requiere pasar la dirección del propietario inicial al constructor.
     * @param initialOwner Dirección de la wallet del Administrador/Autoridad Reguladora Principal.
     */
    constructor(address initialOwner) Ownable(initialOwner) {}

    // --- FUNCIONES DE ADMINISTRACIÓN (SOLO OWNER) ---

    function registrarProductor(address _productor) external onlyOwner {
        require(_productor != address(0), "Direccion invalida");
        producers[_productor] = true;
        emit ActorRegistrado(_productor, "Productor");
    }

    function registrarTransportista(address _transportista) external onlyOwner {
        require(_transportista != address(0), "Direccion invalida");
        transporters[_transportista] = true;
        emit ActorRegistrado(_transportista, "Transportista");
    }

    function registrarInspector(address _inspector) external onlyOwner {
        require(_inspector != address(0), "Direccion invalida");
        inspectors[_inspector] = true;
        emit ActorRegistrado(_inspector, "Inspector");
    }

    // --- FUNCIONES OPERATIVAS (CON ANDAMIAJE / TODOs PARA EL ALUMNO) ---

    /**
     * @notice Registra un nuevo lote de fruta en el origen (producción/packing).
     * @dev Primera fase del ciclo de vida del lote.
     * @param _idLote ID único asignado al lote de fruta.
     * @param _localizacion Ubicación geográfica inicial del lote (ej. "Valle de Curicó, Chile").
     * @param _temperatura Temperatura inicial registrada.
     */
    function registrarLote(
        uint256 _idLote,
        string calldata _localizacion,
        int256 _temperatura
    ) external nonReentrant {
        // [IE2 - Criptografía Aplicada y Firmas]
        // Se valida que la transacción provenga inequívocamente de la wallet pública del Productor
        // autorizado mediante la comprobación del msg.sender. La firma digital generada por la clave privada
        // del emisor valida su identidad y el no-repudio de la acción.
        
        // TODO: Implementar validación para asegurar que solo un Productor registrado pueda ejecutar esta función.
        // Debe arrojar el mensaje de error: "Solo productores autorizados"
        // >>> COMPLETA AQUÍ LA CLÁUSULA REQUIRE <<<


        // TODO: Implementar validación para verificar que el lote no haya sido registrado previamente.
        // Debe arrojar el mensaje de error: "El lote ya existe"
        // >>> COMPLETA AQUÍ LA CLÁUSULA REQUIRE <<<


        // Guardar estado del lote
        lots[_idLote] = LoteFruta({
            idLote: _idLote,
            localizacionActual: _localizacion,
            temperaturaRegistrada: _temperatura,
            estadoLote: EstadoLote.Creado,
            timestamp: block.timestamp,
            registrador: msg.sender
        });

        lotExists[_idLote] = true;

        // Registrar el primer hito inmutable en el historial
        lotHistory[_idLote].push(HitoLogistico({
            localizacion: _localizacion,
            temperatura: _temperatura,
            estado: EstadoLote.Creado,
            timestamp: block.timestamp,
            actor: msg.sender
        }));

        emit LoteRegistrado(_idLote, msg.sender, _localizacion, _temperatura);
    }

    /**
     * @notice Actualiza la localización y temperatura del lote durante el tránsito logístico.
     * @dev Segunda fase del ciclo de vida.
     * @param _idLote ID del lote de fruta.
     * @param _nuevaLocalizacion Nueva localización del transporte (ej. "Puerto de Valparaíso").
     * @param _temperatura Temperatura registrada en el camión frigorífico.
     */
    function actualizarTransito(
        uint256 _idLote,
        string calldata _nuevaLocalizacion,
        int256 _temperatura
    ) external nonReentrant {
        // [IE2 - Criptografía Aplicada y Firmas]
        // Control de acceso basado en el emisor de la transacción (msg.sender) para el rol de Transportista.

        // TODO: Implementar validación para asegurar que solo un Transportista registrado pueda ejecutar esta función.
        // Debe arrojar el mensaje de error: "Solo transportistas autorizados"
        // >>> COMPLETA AQUÍ LA CLÁUSULA REQUIRE <<<


        // TODO: Implementar validación para verificar que el lote exista en el sistema antes de actualizarlo.
        // Debe arrojar el mensaje de error: "El lote no existe"
        // >>> COMPLETA AQUÍ LA CLÁUSULA REQUIRE <<<


        // [IE9 - Conexión con el Mundo Real / Oráculos]
        // NOTA DE INTEGRACIÓN TECNOLÓGICA (Oráculos IoT):
        // En una implementación real de nivel empresarial, esta función no requeriría que el transportista
        // ingrese la temperatura de forma manual en la interfaz. Un sensor de telemetría IoT incorporado en el contenedor
        // frigorífico (conectado mediante redes 5G o satelitales) enviaría datos a un Oráculo descentralizado (como Chainlink).
        // El oráculo validaría la veracidad de la lectura y llamaría automáticamente a este contrato inteligente mediante
        // una transacción firmada, previniendo el fraude humano e inyectando datos automatizados en tiempo real.
        
        // TODO: Implementar validación para comprobar que la temperatura no supere el límite crítico de 8 grados Celsius (8 °C).
        // Si se supera, se arriesga la descomposición de la fruta y la pérdida de la certificación de cadena de frío.
        // Debe arrojar el mensaje de error: "Temperatura excede limite critico de 8C"
        // >>> COMPLETA AQUÍ LA CLÁUSULA REQUIRE <<<


        // Actualizar el estado actual del lote
        LoteFruta storage lote = lots[_idLote];
        lote.localizacionActual = _nuevaLocalizacion;
        lote.temperaturaRegistrada = _temperatura;
        lote.estadoLote = EstadoLote.EnTransito;
        lote.timestamp = block.timestamp;
        lote.registrador = msg.sender;

        // Registrar el hito de tránsito inmutable en el historial
        lotHistory[_idLote].push(HitoLogistico({
            localizacion: _nuevaLocalizacion,
            temperatura: _temperatura,
            estado: EstadoLote.EnTransito,
            timestamp: block.timestamp,
            actor: msg.sender
        }));

        emit TransitoActualizado(_idLote, msg.sender, _nuevaLocalizacion, _temperatura);
    }

    /**
     * @notice Certifica un lote de fruta tras la inspección de aduanas/sanitaria.
     * @dev Tercera fase. Permite aprobar o rechazar de acuerdo a la inspección.
     * @param _idLote ID del lote de fruta.
     * @param _aprobado Define si el lote aprueba (true) o queda solo en estado inspeccionado (false).
     * @param _localizacion Lugar de inspección (ej. "Aduana de San Antonio").
     * @param _temperatura Temperatura registrada al momento de la inspección.
     */
    function certificarLote(
        uint256 _idLote,
        bool _aprobado,
        string calldata _localizacion,
        int256 _temperatura
    ) external nonReentrant {
        // [IE2 - Criptografía Aplicada y Firmas]
        // Se valida que la transacción provenga de la wallet pública del Inspector de Aduanas autorizado.

        // TODO: Implementar validación para asegurar que solo un Inspector registrado pueda ejecutar esta función.
        // Debe arrojar el mensaje de error: "Solo inspectores autorizados"
        // >>> COMPLETA AQUÍ LA CLÁUSULA REQUIRE <<<


        // TODO: Implementar validación para verificar que el lote exista.
        // Debe arrojar el mensaje de error: "El lote no existe"
        // >>> COMPLETA AQUÍ LA CLÁUSULA REQUIRE <<<


        // Determinar el nuevo estado basado en la aprobación
        EstadoLote nuevoEstado = _aprobado ? EstadoLote.Aprobado : EstadoLote.Inspeccionado;

        // Actualizar el estado actual del lote
        LoteFruta storage lote = lots[_idLote];
        lote.localizacionActual = _localizacion;
        lote.temperaturaRegistrada = _temperatura;
        lote.estadoLote = nuevoEstado;
        lote.timestamp = block.timestamp;
        lote.registrador = msg.sender;

        // Registrar el hito de certificación inmutable en el historial
        lotHistory[_idLote].push(HitoLogistico({
            localizacion: _localizacion,
            temperatura: _temperatura,
            estado: nuevoEstado,
            timestamp: block.timestamp,
            actor: msg.sender
        }));

        emit LoteCertificado(_idLote, msg.sender, _aprobado, _localizacion, _temperatura);
    }

    // --- FUNCIONES DE LECTURA (GETTERS) ---

    /**
     * @notice Retorna el historial completo de hitos de un lote específico.
     * @dev Útil para aplicaciones frontend que deseen graficar la trazabilidad.
     * @param _idLote ID del lote a consultar.
     */
    function obtenerHistorial(uint256 _idLote) external view returns (HitoLogistico[] memory) {
        require(lotExists[_idLote], "El lote no existe");
        return lotHistory[_idLote];
    }
}
