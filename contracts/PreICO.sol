pragma solidity ^0.4.23;

/*** @title SafeMath
 * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol */
library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

interface ERC20 {
    function transfer (address _beneficiary, uint256 _tokenAmount) external returns (bool);
    function mintFromICO(address _to, uint256 _amount) external  returns(bool);
}
/**
 * @title Ownable
 * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
 */
contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

/**
 * @title CrowdSale
 * @dev https://github.com/
 */
contract SuperSafeSale is Ownable {

    ERC20 public token;

    using SafeMath for uint;

    address public backEndOperator = msg.sender;
    address team = 0x7eDE8260e573d3A3dDfc058f19309DF5a1f7397E; // 33% - основантели проекта
    address bounty = 0x0cdb839B52404d49417C8Ded6c3E2157A06CdD37; // 2% - для баунти программы
    address reserve; // 3%

    mapping(address=>bool) public whitelist;

    mapping(address => uint256) public investedEther;

    uint256 public startPreSale = 1531612801; // Sunday, 15-Jul-18 00:00:01 UTC

    uint256 public endPreSale = 1534377599; // Wednesday, 15-Aug-18 23:59:59 UTC i

    uint256 public investors; // общее количество инвесторов
    uint256 public weisRaised;

    uint256 public softCapPreSale = 2700000*1e18; // именно на преварительном
    uint256 public hardCapPreSale = 15000000*1e18; //  именно на преварительном

    uint256 public buyPrice; // 0.14 USD
    uint256 public dollarPrice;

    uint256 public soldTokens;

    event Authorized(address wlCandidate, uint timestamp);
    event Revoked(address wlCandidate, uint timestamp);
    event UpdateDollar(uint256 time, uint256 _rate);

    modifier backEnd() {
        require(msg.sender == backEndOperator || msg.sender == owner);
        _;
    }

    // конструктор контракта
    constructor(ERC20 _token, uint256 usdETH) public {
        token = _token;
        dollarPrice = usdETH;
        buyPrice = (1e17/dollarPrice)*21; // 2.10 usd
    }

    // изменение даты начала предварительной распродажи
    function setStartPreSale(uint256 newStartPreSale) public onlyOwner {
        startPreSale = newStartPreSale;
    }

    // изменение даты окончания предварительной распродажи
    function setEndPreSale(uint256 newEndPreSale) public onlyOwner {
        endPreSale = newEndPreSale;
    }

    // изменение даты начала основной распродажи
    function setStartSale(uint256 newStartSale) public onlyOwner {
        startPreSale = newStartSale;
    }

    // изменение даты окончания основной распродажи
    function setEndSale(uint256 newEndSaled) public onlyOwner {
        endPreSale = newEndSaled;
    }

    // Изменение адреса оператора бекэнда
    function setBackEndAddress(address newBackEndOperator) public onlyOwner {
        backEndOperator = newBackEndOperator;
    }

    // Изменение курса доллра к эфиру
    function setBuyPrice(uint256 _dollar) public onlyOwner {
        dollarPrice = _dollar;
        buyPrice = (1e17/dollarPrice)*21; // 2.10 usd
        emit UpdateDollar(now, dollarPrice);
    }

    /*******************************************************************************
     * Whitelist's section
     */
    // с сайта backEndOperator авторизует инвестора
    function authorize(address wlCandidate) public backEnd  {
        require(wlCandidate != address(0x0));
        require(!isWhitelisted(wlCandidate));
        whitelist[wlCandidate] = true;
        investors++;
        emit Authorized(wlCandidate, now);
    }

    // отмена авторизации инвестора в WL(только владелец контракта)
    function revoke(address wlCandidate) public  onlyOwner {
        whitelist[wlCandidate] = false;
        investors--;
        emit Revoked(wlCandidate, now);
    }

    // проверка на нахождение адреса инвестора в WL
    function isWhitelisted(address wlCandidate) internal view returns(bool) {
        return whitelist[wlCandidate];
    }

    /*******************************************************************************
     * Payable's section
     */

    function isPreSale() public constant returns(bool) {
        return now >= startPreSale && now <= endPreSale;
    }

    // callback функция контракта
    function () public payable {
        require(isWhitelisted(msg.sender));
        require(isPreSale());
        preSale(msg.sender, msg.value);
        require(soldTokens<=hardCapPreSale);
        investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);
    }

    // выпуск токенов в период предварительной распродажи
    function preSale(address _investor, uint256 _value) internal {

        // + 15 % all
        uint256 tokens = _value.mul(1e18).div(buyPrice);
        uint256 bonusSumTokens = tokens.mul(bonusSum(tokens)).div(100);
        tokens = tokens.add(bonusSumTokens); // 88,5%
        token.mintFromICO(_investor, tokens);

        uint256 tokensTeam = tokens.mul(20).div(177); // 10% - осторожно цикличное число
        token.mintFromICO(team, tokensTeam);

        uint256 tokensBoynty = tokens.div(59); // 15/885  = 1,5%  -  - осторожно цикличное число
        token.mintFromICO(bounty, tokensBoynty);

        weisRaised = weisRaised.add(msg.value);
        tokens = tokens.add(tokensTeam).add(tokensBoynty); // в расчет идут все
        soldTokens = soldTokens.add(tokens);
    }


    function bonusSum(uint256 _amount) pure private returns(uint256) {
        if (_amount > 350000*1e18) {
            return 10;
        } else if (_amount > 150000*1e18) {
            return 7;
        } else if (_amount > 50000*1e18) {
            return 5;
        } else if (_amount > 10000*1e18) {
            return 3;
        } else {
            return 0;
        }
    }



    // Отправка эфира с контракта
    function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
        //require(weisRaised >= softCap);
        _to.transfer(amount);
    }

    /*******************************************************************************
     * Refundable
     */
    function refundPreICO() public {
        require(soldTokens < softCapPreSale && now > endPreSale);
        uint rate = investedEther[msg.sender];
        require(investedEther[msg.sender] >= 0);
        investedEther[msg.sender] = 0;
        msg.sender.transfer(rate);
        weisRaised = weisRaised.sub(rate);
    }

    function refundMainICO() public {
        require(weisRaised < softCapPreSale && now > endPreSale);
        uint rate = investedEther[msg.sender];
        require(investedEther[msg.sender] > 0);
        investedEther[msg.sender] = 0;
        msg.sender.transfer(rate);
        weisRaised = weisRaised.sub(rate);
    }
}