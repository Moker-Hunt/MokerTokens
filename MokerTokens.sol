pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract MokerTokens {

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }
    
    struct Token{
        string name;
        uint weigth;
        uint8 rank;
        string color;
        uint cost;
    }

    Token[] tokens;

    mapping (string => uint) tokenNames;
    mapping (uint => uint) tokenOwner;

    modifier checkToUnique(string name) {
        require(msg.pubkey() == tvm.pubkey(), 102);
        require(!tokenNames.exists(name), 101);
        tvm.accept();
        _;
    }

    modifier checkToOwner(uint tokenId) {
        require(msg.pubkey() == tokenOwner[tokenId], 101);
        tvm.accept();
        _;
    }

    function createToken(string name, uint weight, uint8 rank, string color) public checkToUnique(name) {
        tokens.push(Token(name, weight, rank, color, 0));
        tokenOwner[tokens.length - 1] = msg.pubkey();
        tokenNames[name] = tokens.length - 1;
    }

    function putUpForSale(uint tokenId, uint cost) public checkToOwner(tokenId){
        tokens[tokenId].cost = cost;
    }

    function viewAllTokens() public view returns(Token[]){
        return tokens;
    }
}
