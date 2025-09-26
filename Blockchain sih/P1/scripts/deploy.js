const hre = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);

    const RoleManager = await ethers.getContractFactory("RoleManager");
    const roleManager = await RoleManager.deploy();
    await roleManager.deployed();
    console.log("RoleManager deployed to:", roleManager.address);

    const ProjectRegistry = await ethers.getContractFactory("ProjectRegistry");
    const projectRegistry = await ProjectRegistry.deploy("BlueCarbonProjects", "BCP");
    await projectRegistry.deployed();
    console.log("ProjectRegistry deployed to:", projectRegistry.address);

    const CarbonCreditToken = await ethers.getContractFactory("CarbonCreditToken");
    const carbonToken = await CarbonCreditToken.deploy("https://example.com/{id}.json");
    await carbonToken.deployed();
    console.log("CarbonCreditToken deployed to:", carbonToken.address);

    const VerificationOracle = await ethers.getContractFactory("VerificationOracle");
    const verificationOracle = await VerificationOracle.deploy(
        carbonToken.address,
        projectRegistry.address
    );
    await verificationOracle.deployed();
    console.log("VerificationOracle deployed to:", verificationOracle.address);

    const CommunityDAO = await ethers.getContractFactory("CommunityDAO");
    const communityDAO = await CommunityDAO.deploy(projectRegistry.address);
    await communityDAO.deployed();
    console.log("CommunityDAO deployed to:", communityDAO.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });