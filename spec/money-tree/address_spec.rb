require "spec_helper"

describe MoneyTree::Address do
  describe "initialize" do
    it "generates a private key by default" do
      address = MoneyTree::Address.new
      expect(address).to be
      expect(address).to be_instance_of MoneyTree::Address
      expect(address.private_key).to be_instance_of MoneyTree::PrivateKey
      expect(address.private_key.key.length).to eql(64)
    end

    it "generates a public key by default" do
      address = MoneyTree::Address.new
      expect(address).to be
      expect(address).to be_instance_of MoneyTree::Address
      expect(address.public_key).to be_instance_of MoneyTree::PublicKey
      expect(address.public_key.key.length).to eql(66)
    end

    it "imports a private key in hex form" do
      address = MoneyTree::Address.new private_key: "5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b"
      expect(address.private_key.key).to eql("5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b")
      expect(address.public_key.key).to eql("022dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b")
      expect(address.to_s).to eql("13uVqa35BMo4mYq9LiZrXVzoz9EFZ6aoXe")
      expect(address.private_key.to_s).to eql("KzPkwAXJ4wtXHnbamTaJqoMrzwCUUJaqhUxnqYhnZvZH6KhgmDPK")
      expect(address.public_key.to_s).to eql("13uVqa35BMo4mYq9LiZrXVzoz9EFZ6aoXe")
      expect(address.to_p2wpkh_p2sh).to eql("31vNN7WVDxjvc5XZVKW3qV4B3nFLxsRPnE")
      expect(address.to_bech32).to eql("bc1qrlwlgt5d0sdtq882qvk3jc0sywucn76fwcmqma")
    end

    it "imports a private key in compressed wif format" do
      address = MoneyTree::Address.new private_key: "KzPkwAXJ4wtXHnbamTaJqoMrzwCUUJaqhUxnqYhnZvZH6KhgmDPK"
      expect(address.private_key.key).to eql("5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b")
      expect(address.public_key.key).to eql("022dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b")
      expect(address.to_s).to eql("13uVqa35BMo4mYq9LiZrXVzoz9EFZ6aoXe")
      expect(address.to_p2wpkh_p2sh).to eql("31vNN7WVDxjvc5XZVKW3qV4B3nFLxsRPnE")
      expect(address.to_bech32).to eql("bc1qrlwlgt5d0sdtq882qvk3jc0sywucn76fwcmqma")
    end

    it "imports a private key in uncompressed wif format" do
      address = MoneyTree::Address.new private_key: "5JXz5ZyFk31oHVTQxqce7yitCmTAPxBqeGQ4b7H3Aj3L45wUhoa"
      expect(address.private_key.key).to eql("5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b")
      expect(address.public_key.key).to eql("022dfc2557a007c93092c2915f11e8aa70c4f399a6753e2e908330014091580e4b")
    end
  end

  describe "to_s" do
    before do
      @address = MoneyTree::Address.new private_key: "5eae5375fb5f7a0ea650566363befa2830ef441bdcb19198adf318faee86d64b"
    end

    it "returns compressed base58 public key" do
      expect(@address.to_s).to eql("13uVqa35BMo4mYq9LiZrXVzoz9EFZ6aoXe")
      expect(@address.public_key.to_s).to eql("13uVqa35BMo4mYq9LiZrXVzoz9EFZ6aoXe")
      expect(@address.to_p2wpkh_p2sh).to eql("31vNN7WVDxjvc5XZVKW3qV4B3nFLxsRPnE")
      expect(@address.to_bech32).to eql("bc1qrlwlgt5d0sdtq882qvk3jc0sywucn76fwcmqma")
    end

    it "returns compressed WIF private key" do
      expect(@address.private_key.to_s).to eql("KzPkwAXJ4wtXHnbamTaJqoMrzwCUUJaqhUxnqYhnZvZH6KhgmDPK")
    end
  end

  context "bitcoin wiki" do
    # ref https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses
    subject(:wiki_v1) { MoneyTree::Address.new private_key: "18e14a7b6a307f426a94f8114701e7c8e774e7f9a47e2c2035db29a206321725" }

    it "always regenerates the bitcoin wiki v1 example" do
      expect(wiki_v1.public_key.key).to eq "0250863ad64a87ae8a2fe83c1af1a8403cb53f53e486d8511dad8a04887e5b2352"
      expect(wiki_v1.to_s).to eq "1PMycacnJaSqwwJqjawXBErnLsZ7RkXUAs"
      expect(wiki_v1.to_p2wpkh_p2sh).to eql("3BxwGNjvG4CP14tAZodgYyZ7UTjruYDyAM")
      expect(wiki_v1.to_bech32).to eql("bc1q7499s50fxu4c0qg23esvm5h8elvqkm33r2tdza")
    end

    # ref https://en.bitcoin.it/wiki/Bech32
    subject(:wiki_bech32) { MoneyTree::Address.new private_key: "0000000000000000000000000000000000000000000000000000000000000001" }

    it "always regenerates the bitcoin wiki v1 example" do
      expect(wiki_bech32.public_key.key).to eq "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"
      expect(wiki_bech32.to_s).to eq "1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH"
      expect(wiki_bech32.to_p2wpkh_p2sh).to eql("3JvL6Ymt8MVWiCNHC7oWU6nLeHNJKLZGLN")
      expect(wiki_bech32.to_bech32).to eql("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4")
    end
  end

  context "testnet3" do
    before do
      @address = MoneyTree::Address.new network: :bitcoin_testnet
    end

    it "returns a testnet address" do
      expect(%w(m n)).to include(@address.to_s(network: :bitcoin_testnet)[0])
    end
  end
end
