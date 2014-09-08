FactoryGirl.define do
  factory :user do

    name(Faker::Lorem.words(2).join("").capitalize)
    pswrd = Faker::Lorem.words(4).join("")
    password(pswrd)
    password_confirmation(pswrd)

    eml = Faker::Internet.email
    email(eml)
    email_confirmation(eml)

  end
end


