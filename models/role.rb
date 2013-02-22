class Role < ActiveResource::Base
  self.site = RM_INSTANCE
  self.user = API_KEY_NAME
  self.password = API_KEY_SECRET
end
