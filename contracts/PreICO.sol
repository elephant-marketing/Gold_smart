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
    function transferFromICO(address _to, uint256 _value) external returns(bool);
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
contract CloseICO is Ownable {

    ERC20 public token;

    using SafeMath for uint;

    address public backEndOperator = msg.sender;
    address team = 0x7eDE8260e573d3A3dDfc058f19309DF5a1f7397E; // 33 % - команда и первичные инвесторы
    address bounty = 0x0cdb839B52404d49417C8Ded6c3E2157A06CdD37; // 2 % - для баунти программы
    address reserve = 0xC032D3fCA001b73e8cC3be0B75772329395caA49; // 5% consult

    mapping(address=>bool) public whitelist;

    mapping(address => uint256) public investedEther;

    uint256 public startCloseSale = now;
    uint256 public endCloseSale = startCloseSale + 1814400; // 3 weeks

    uint256 public investors; // общее количество инвесторов
    uint256 public weisRaised;

    uint256 public hardCapCloseSale = 6400000*1e18; // 6,400,000 FBW

    uint256 public buyPrice; // 0.4 USD
    uint256 public dollarPrice;

    uint256 public soldTokensCloseSale;

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
        buyPrice = (1e17/dollarPrice)*4; // 0.4 usd
    }

    // изменение даты начала предварительной распродажи
    function setStartCloseSale(uint256 newStartCloseSale) public onlyOwner {
        startCloseSale = newStartCloseSale;
    }

    // изменение даты окончания предварительной распродажи
    function setEndCloseSale(uint256 newEndCloseSale) public onlyOwner {
        endCloseSale = newEndCloseSale;
    }

    // Изменение адреса оператора бекэнда
    function setBackEndAddress(address newBackEndOperator) public onlyOwner {
        backEndOperator = newBackEndOperator;
    }

    // Изменение курса доллра к эфиру
    function setBuyPrice(uint256 _dollar) public onlyOwner {
        dollarPrice = _dollar;
        buyPrice = (1e17/dollarPrice)*4; // 0.4 usd
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



    // callback функция контракта
    function () public payable {
        require(isWhitelisted(msg.sender));
        if (isCloseSale()) {
            closeSale(msg.sender, msg.value);
            require(soldTokensCloseSale<=hardCapCloseSale);
            investedEther[msg.sender] = investedEther[msg.sender].add(msg.value);
        } else {
            revert();
        }
    }

    // проверка на то что сейл идет
    function isCloseSale() public constant returns(bool) {
        return now >= startCloseSale && now <= endCloseSale;
    }

    // выпуск токенов в период закрытой распродажи
    function closeSale(address _investor, uint256 _valueEther) internal {
        uint256 tokens = _valueEther.mul(1e18).div(buyPrice);
        uint256 tokensBonus = tokens.mul(25).div(100);
        tokens = tokens.add(tokensBonus);
        soldTokensCloseSale = soldTokensCloseSale.add(distributionTokens(_investor, tokens));
        weisRaised = weisRaised.add(_valueEther);
    }

    // Ручная отправка токенов
    function mintManual(address receiver, uint256 _tokens) public backEnd {
        token.transferFromICO(receiver, _tokens);

        uint256 tokensTeam = _tokens.mul(2).div(7); // 33 % // 33 /60 11/20
        token.transferFromICO(team, tokensTeam);

        uint256 tokensBoynty = _tokens.div(30); // 2%
        token.transferFromICO(bounty, tokensBoynty);

        uint256 tokensReserve = _tokens.div(12); //  1/12 = 5%
        token.transferFromICO(reserve, tokensReserve);
        soldTokensCloseSale = soldTokensCloseSale.add(tokensTeam).add(tokensBoynty).add(tokensReserve);
    }

    function distributionTokens(address _recipient, uint256 _value) internal returns (uint256) {
        token.transferFromICO(_recipient, _value);

        uint256 tokensTeam = _value.mul(2).div(7); // 33 % // 33 /60 11/20
        token.transferFromICO(team, tokensTeam);

        uint256 tokensBoynty = _value.div(30); // 2%
        token.transferFromICO(bounty, tokensBoynty);

        uint256 tokensReserve = _value.div(12); //  1/12 = 5%
        token.transferFromICO(reserve, tokensReserve);
        uint256 sended = _value.add(tokensTeam).add(tokensBoynty).add(tokensReserve);
        return sended;
    }

    // Отправка эфира с контракта
    function transferEthFromContract(address _to, uint256 amount) public onlyOwner {
        _to.transfer(amount);
    }
}
