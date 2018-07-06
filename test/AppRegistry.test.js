const AppRegistry = artifacts.require('AppRegistry');
const Token = artifacts.require('SimpleToken');

const should = require('chai')
    .use(require('chai-as-promised'))
    .should();

contract('AppRegistry', (accounts) => {
    const [owner, penaltyPool, punisher, appUser] = accounts;
    const appId = web3.fromAscii('test-app');

    beforeEach(async function() {
        this.token = await Token.new();
        this.appRegistry = await AppRegistry.new(this.token.address, penaltyPool, punisher);
    });

    describe('basic registry', () => {
        it('should register new app', async function() {
            await this.appRegistry.register(appId).should.be.fulfilled;
        });

        it('should stake token', async function() {
            await this.appRegistry.register(appId);

            await this.token.approve(this.appRegistry.address, 10);
            await this.appRegistry.deposit(10).should.be.fulfilled;
        });

        it('should add an user', async function() {
            await this.appRegistry.register(appId);
            await this.token.approve(this.appRegistry.address, 10);
            await this.appRegistry.deposit(10);

            await this.appRegistry.addUser([appUser]).should.be.fulfilled;
            
            const hasUser = await this.appRegistry.hasUser(appId, appUser);
            hasUser.should.be.equal(true);
        });
    });
});
