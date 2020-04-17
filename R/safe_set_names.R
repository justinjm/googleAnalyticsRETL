#' Safe set names
#'
#' Will error if there is a problem setting names, which is better than silently returning NA
#' Original Author: Mark Edmondson https://github.com/MarkEdmondson1234
#'
#' @param data_frame Data.frame to change the names of
#' @param lookup_names A named vector of the names of old_name = new_name
#'
#' @return A character vector of new names, or error if any NA's
#' @export
safe_set_names <- function(data_frame, lookup_names){
  old_names <- names(data_frame)
  new_names <- lookup_names[old_names]
  failed_names <- new_names[is.na(new_names)]

  if(any(is.na(failed_names))){
    str(new_names)
    str(old_names)
    stop("Failed to rename all columns, check lookup_names")
  }

  new_names

}
