#' Setup GCE VM.
#' A helper function that sets up a GCE VM, waits for a period of time you set
#' then opens the shiny app in your browser
#' @param gce_vm_name STRING
#' @param gce_vm_type STRING
#' @param image_tag STRING
#' @param app_directory STRING
#' @param wait_second INTEGER of seconds to wait before opening the app's url
#' @return a dataframe "vm" wtih GCE instance info
setup_gce_vm <- function(gce_vm_name,
                         gce_vm_temp,
                         gce_vm_type,
                         image_tag,
                         app_directory,
                         wait_seconds){

  message(sprintf("[-] hello world!, it's %s EDT", Sys.time()))
  message(sprintf("[?] started building VM - %s", Sys.time()))
  vm <- gce_vm(name = gce_vm_name,
               template = gce_vm_temp,
               predefined_type = gce_vm_type,
               dynamic_image = image_tag)
  gce_vm_status <- gce_get_instance(vm)

  message(sprintf("[?] waiting %s seconds to open your browser...", wait_seconds))
  Sys.sleep(wait_seconds)

  message(sprintf("[?] ..and now opening your browser to:"))
  app_url <- sprintf("http://%s%s", gce_get_external_ip(vm), app_directory)
  message(sprintf("[?] %s", app_url))
  browseURL(app_url)

  message(sprintf("[?] Here is the gcloud command to ssh into %s:", gce_vm_name))
  cmd <- paste0("gcloud compute --project \"",
                gce_project_id,
                "\" ssh --zone \"",
                gce_zone,
                "\" \"",
                gce_vm_name,
                "\"")
  message(sprintf("[?] %s", cat(cmd)))

  return(vm)
}
