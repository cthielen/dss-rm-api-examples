class Application < ActiveResource::Base
  self.site = $API_KEY['HOST']
  self.user = $API_KEY['USER']
  self.password = $API_KEY['PASSWORD']
end
