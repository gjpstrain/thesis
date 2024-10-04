# sync all qmd files with google drive simultaneously (UPLOAD)
# NB this only works after trackdown has been configured

library(trackdown)

chapters_qmd <- list.files("chapters_quarto/", full.names = T)

lapply(chapters_qmd, function(file) trackdown::update_file(file = file,
                                                           hide_code = T,
                                                           force = T,
                                                           open = F)) #opening in browser disabled

# opposite function to sync (DOWNLOAD)

lapply(chapters_qmd, function(file) trackdown::download_file(file = file,
                                                           force = T))

# code for authenticating trackdown

#my_client <- gargle::gargle_oauth_client(
#  name = "my-client-name",
#  id = "client-id",
#  secret = "secret"
#)
#trackdown_auth_configure(client = my_client)
