require 'rails_helper'

RSpec.describe Wiki, type: :model do

  describe "scopes" do
    context "signed in as a standard user" do
      before(:each) do
        @user = User.create!(email: "user1@blocipedia.com", password: "password", role: :standard)
        @public_wiki = Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private:false)
      end

      describe "visible_to(user)" do
        it "returns all wikis if the user is present" do
          expect(Wiki.visible_to(@user)).to eq(Wiki.where(private:false))
        end

        it "returns only public wikis if user is nil" do
          expect(Wiki.visible_to(nil)).to eq([@public_wiki])
        end
      end
    end
  end
end
