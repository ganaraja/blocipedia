require 'rails_helper'

RSpec.describe WikisController, type: :controller do


  context "not signed in" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = User.create!(email: "test_user@example.com", password: "password", role: :standard)
      @user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in @user

      @my_wiki = Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private:false)
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns [my_wiki] to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([@my_wiki])
      end

      it "does not include private wikis in @wikis" do
        get :index
        expect(assigns(:wikis)).not_to include(@my_private_wiki)
      end
    end

     describe "GET new" do
       it "returns http success" do
         get :new
         expect(response).to have_http_status(:success)
       end

       it "renders the #new view" do
         get :new
         expect(response).to render_template :new
       end

       it "instantiates @wiki" do
         get :new
         expect(assigns(:wiki)).not_to be_nil
       end
     end

     describe "POST create" do
       it "increases the number of Wiki by 1" do
         expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: @user}}.to change(Wiki,:count).by(1)
       end

       it "assigns the new wiki to @wiki" do
         post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: @user}
         expect(assigns(:wiki)).to eq Wiki.last
       end

       it "redirects to the new wiki" do
         post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: @user}
         expect(response).to redirect_to Wiki.last
       end
     end

    describe "GET #show" do
      it "returns http success" do
        get :show, {id: @my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders a new view" do
        get :show,{id: @my_wiki.id}
        expect(response).to render_template :show
      end

      it " assigns @my_wiki to @wiki" do
        get :show,{id: @my_wiki.id}
        expect(assigns(:wiki)).to eq(@my_wiki)
      end
    end


    describe "GET edit" do
      it "returns http success" do
        get :edit, {id: @my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, {id: @my_wiki.id}
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, {id: @my_wiki.id}

        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq @my_wiki.id
        expect(wiki_instance.title).to eq @my_wiki.title
        expect(wiki_instance.body).to eq @my_wiki.body
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: @my_wiki.id, wiki: {title: new_title, body: new_body, private: false, user: @user}

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq @my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: @my_wiki.id, wiki: {title: new_title, body: new_body,private: false, user: @user}
        expect(response).to redirect_to @my_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, {id: @my_wiki.id}
        count = Wiki.where({id: @my_wiki.id}).size
        expect(count).to eq 0
      end

      it "redirects to wikis index" do
        delete :destroy, {id: @my_wiki.id}
        expect(response).to redirect_to wikis_path
      end
    end
  end

  context "signed in as a premium user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = User.create!(email: "test_user@example.com", password: "password", role: :premium)
      @user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in @user

      @my_wiki = Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private:true, user:@user)
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns [my_wiki] to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([@my_wiki])
      end
    end

     describe "GET new" do
       it "returns http success" do
         get :new
         expect(response).to have_http_status(:success)
       end

       it "renders the #new view" do
         get :new
         expect(response).to render_template :new
       end

       it "instantiates @wiki" do
         get :new
         expect(assigns(:wiki)).not_to be_nil
       end
     end

     describe "POST create" do
       it "increases the number of Wiki by 1" do
         expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}}.to change(Wiki,:count).by(1)
       end

       it "assigns the new wiki to @wiki" do
         post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}
         expect(assigns(:wiki)).to eq Wiki.last
       end

       it "redirects to the new wiki" do
         post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}
         expect(response).to redirect_to Wiki.last
       end
     end

    describe "GET #show" do
      it "returns http success" do
        get :show, {id: @my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders a new view" do
        get :show,{id: @my_wiki.id}
        expect(response).to render_template :show
      end

      it " assigns @my_wiki to @wiki" do
        get :show,{id: @my_wiki.id}
        expect(assigns(:wiki)).to eq(@my_wiki)
      end
    end


    describe "GET edit" do
      it "returns http success" do
        get :edit, {id: @my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, {id: @my_wiki.id}
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, {id: @my_wiki.id}

        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq @my_wiki.id
        expect(wiki_instance.title).to eq @my_wiki.title
        expect(wiki_instance.body).to eq @my_wiki.body
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: @my_wiki.id, wiki: {title: new_title, body: new_body, private: true, user: @user}

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq @my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: @my_wiki.id, wiki: {title: new_title, body: new_body,private: true, user: @user}
        expect(response).to redirect_to @my_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, {id: @my_wiki.id}
        count = Wiki.where({id: @my_wiki.id}).size
        expect(count).to eq 0
      end

      it "redirects to wikis index" do
        delete :destroy, {id: @my_wiki.id}
        expect(response).to redirect_to wikis_path
      end
    end
  end

  context "signed in as a admin user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = User.create!(email: "test_user@example.com", password: "password", role: :admin)
      @user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in @user

      @my_wiki = Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private:true, user:@user)
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns [my_wiki] to @wikis" do
        get :index
        expect(assigns(:wikis)).to eq([@my_wiki])
      end
    end

     describe "GET new" do
       it "returns http success" do
         get :new
         expect(response).to have_http_status(:success)
       end

       it "renders the #new view" do
         get :new
         expect(response).to render_template :new
       end

       it "instantiates @wiki" do
         get :new
         expect(assigns(:wiki)).not_to be_nil
       end
     end

     describe "POST create" do
       it "increases the number of Wiki by 1" do
         expect{post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}}.to change(Wiki,:count).by(1)
       end

       it "assigns the new wiki to @wiki" do
         post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}
         expect(assigns(:wiki)).to eq Wiki.last
       end

       it "redirects to the new wiki" do
         post :create, wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: @user}
         expect(response).to redirect_to Wiki.last
       end
     end

    describe "GET #show" do
      it "returns http success" do
        get :show, {id: @my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders a new view" do
        get :show,{id: @my_wiki.id}
        expect(response).to render_template :show
      end

      it " assigns @my_wiki to @wiki" do
        get :show,{id: @my_wiki.id}
        expect(assigns(:wiki)).to eq(@my_wiki)
      end
    end


    describe "GET edit" do
      it "returns http success" do
        get :edit, {id: @my_wiki.id}
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, {id: @my_wiki.id}
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, {id: @my_wiki.id}

        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq @my_wiki.id
        expect(wiki_instance.title).to eq @my_wiki.title
        expect(wiki_instance.body).to eq @my_wiki.body
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: @my_wiki.id, wiki: {title: new_title, body: new_body, private: true, user: @user}

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq @my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, id: @my_wiki.id, wiki: {title: new_title, body: new_body,private: true, user: @user}
        expect(response).to redirect_to @my_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, {id: @my_wiki.id}
        count = Wiki.where({id: @my_wiki.id}).size
        expect(count).to eq 0
      end

      it "redirects to wikis index" do
        delete :destroy, {id: @my_wiki.id}
        expect(response).to redirect_to wikis_path
      end
    end
  end
end
