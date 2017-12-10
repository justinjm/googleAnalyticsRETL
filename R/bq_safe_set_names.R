#' Set BigQuery Safe Names
#'
#' Remove bad characters so colnames are safe for loading into BigQuery
#' Original Author: Mark Edmondson https://github.com/MarkEdmondson1234
#'
#' @param names list of dataframe column names
#' @return list of BQ safe column name
bq_safe_set_names <- function(names){
  gsub("\\.", "_", make.names(names))

}
