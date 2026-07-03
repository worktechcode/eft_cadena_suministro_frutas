import { expect } from "chai";
import hre from "hardhat";

describe("FruitSupplyChain Contract Tests", function () {
  let contract;
  let owner;
  let producer;
  let transporter;
  let inspector;
  let guest;

  beforeEach(async function () {
    // Obtener las cuentas firmantes
    [owner, producer, transporter, inspector, guest] = await hre.ethers.getSigners();

    // Obtener la factoría del contrato y desplegar
    const FruitSupplyChain = await hre.ethers.getContractFactory("FruitSupplyChain");
    contract = await FruitSupplyChain.deploy(owner.address);
    await contract.waitForDeployment();

    // Enrolar actores
    await contract.registrarProductor(producer.address);
    await contract.registrarTransportista(transporter.address);
    await contract.registrarInspector(inspector.address);
  });

  it("Debería inicializar con el propietario correcto", async function () {
    expect(await contract.owner()).to.equal(owner.address);
  });

  it("Debería registrar correctamente a los actores en la lista blanca", async function () {
    expect(await contract.producers(producer.address)).to.be.true;
    expect(await contract.transporters(transporter.address)).to.be.true;
    expect(await contract.inspectors(inspector.address)).to.be.true;
    expect(await contract.producers(guest.address)).to.be.false;
  });

  it("Debería fallar si un actor no autorizado intenta registrar un lote", async function () {
    // Intentar registrar lote con cuenta no productora (guest)
    // Nota: Dado que las validaciones son TODOs en la plantilla base, este test fallará
    // si el alumno aún no ha implementado los TODOs en el require.
    // Este test sirve para demostrar la utilidad de los requires.
    try {
      await contract.connect(guest).registrarLote(101, "Curico", 4);
      // Si llega aquí, significa que no falló. Pero como es un boilerplate sin los requires,
      // fallará la aserción de que debió revertir, lo cual es correcto para guiar al alumno.
      expect.fail("La transaccion debio haber fallado (revertido)");
    } catch (error) {
      if (error.message.includes("La transaccion debio haber fallado")) {
        throw error;
      }
      expect(error.message).to.include("Solo productores autorizados");
    }
  });
});
