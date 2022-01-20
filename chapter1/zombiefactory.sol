//ゾンビゲームをサイトに合わせて作り、コードの説明をここにまとめる。
//Chapter1が終わった時点のコード。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
//（solidityのバージョンを記載。エラーが起こらないように。）

contract ZombieFactory {
//ゾンビ軍団を生み出すためのコントラクト
//（solidityのコードは全てコントラクト内にカプセル化されている。
//コントラクトはイーサリアムアプリケーションの基本ブロックのこと。
//変数やファンクションは全てコントラクトに属している。）

    event NewZombie(uint zombieId, string name, uint dna);
    //eventはブロックチェーン上で何かが生じたときに、コントラクトがアプリのフロントエンドに伝えることができる。
    //今回はゾンビを作る毎nそれをフロントエンドに伝えてアプリに表示する。

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    //（符号なし整数uintは負の数ではないことを表す。
    //状態変数はコントラクト内に永遠に保管される。つまりブロックチェーン上に記載される。

    struct Zombie {
    //構造体の宣言

        string name;
        uint dna;
    }

    Zombie[] public zombies;
    //（構造体の配列を作成し、publicで宣言）

    function _createZombie(string memory _name, uint _dna) private {
    //新しいゾンビを作成、関数はprivate、privateにするときは関数名の前にアンダーバー
    //（関数の宣言、引数の設定）

        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        //新しいZombie構造体のオブジェクトを作ってそれを配列に格納

        NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string memory _str) private view returns (uint) {
    //戻り値をuintに設定
        uint rand = uint(keccak256(_str));
        //16桁のDNAを作る
        //ハッシュ関数（不完全）を用いてハッシュ値を生成。uintにキャスト
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
    //ゾンビの名前やユーザーの名前をインプットしてランダムなDNAでゾンビを作る
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
