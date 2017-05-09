require "rspec"

require_relative "account"

describe Account do

  let(:account) {Account.new("1234567890") }

  describe "#initialize" do
    context "with invalid input" do
      it "takes at least one argument" do
        expect { Account.new }.to raise_error(ArgumentError)
      end

      it "throws NoMethodError if argument is not string " do
        expect { Account.new(1234567890) }.to raise_error(NoMethodError)
      end

      it "throws InvalidAccountNumberError when argument is more than 10 digits" do
        expect { Account.new("12345678901") }.to raise_error(InvalidAccountNumberError)
      end

      it "throws InvalidAccountNumberError when argument is less than 10 digits" do
        expect { Account.new("123456789") }.to raise_error(InvalidAccountNumberError)
      end

      it "throws InvalidAccountNumberError when not made up of digits" do 
        expect { Account.new("123456789a") }.to raise_error(InvalidAccountNumberError)
      end
    end

    context "with valid input" do 
      it "creates an account with balance 0 if only 1 argument is supplied" do 
        expect(account.balance).to eq 0
      end

      it "creates an account with specified balance if 2 arguments are supplied" do 
        starting_amount = 20
        expect(Account.new("1234567890",starting_amount).balance).to eq starting_amount
      end
    end

  end

  describe "#transactions" do
    it "returns an array with all past transactions" do
      account.deposit! 20
      account.withdraw! 10
      account.deposit! 30
      account.withdraw! 35
      expect(account.transactions).to eq [0,20,-10,30,-35]
    end
  end

  describe "#balance" do
    it "returns the sum of all elements in transactions, subtracting from the sum if it is a withdrawal" do
      account.deposit! 20
      account.withdraw! 10
      account.deposit! 30
      account.withdraw! 35
      expect(account.balance).to eq 5
    end
  end

  describe "#acct_number" do
    it "returns the account number with first 6 digits hidden" do
      expect(account.acct_number).to eq "******7890"
    end
  end

  describe "deposit!" do
    it "adds the deposit amount to the transactions and return the new balance if valid number was given" do
      account.deposit!(20)
      account.deposit!(5)
      expect(account.deposit!(10) == 35 && account.transactions == [0,20,5,10]).to be true
    end

    it "returns NegativeDepositError if negative arguement was given" do
      expect { account.deposit!(-2) }.to raise_error NegativeDepositError
    end
  end

  describe "#withdraw!" do
    it "withdraws specified amount from balance and returns the new balance and also add the amount (turn it into negative num) into transactions" do
      account.deposit! 20
      account.withdraw! 15
      expect(account.withdraw!(-5) == 0 && account.transactions == [0,20,-15,-5]).to be true
    end

    it "raises an OverdraftError if withdrew more amount than available balance" do
      expect { account.withdraw!(-20) }.to raise_error(OverdraftError)
    end
  end
end