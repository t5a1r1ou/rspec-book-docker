# frozen_string_literal: true

module RequestSpecHelper
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resourse)
    login_as(resourse, scope: warden_scope(resourse))
  end

  def sign_out(resourse)
    logout(warden_scope(resourse))
  end

  private

  def warden_scope(resourse)
    resourse.class.name.underscore.to_sym
  end
end
