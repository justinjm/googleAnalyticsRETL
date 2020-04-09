#' Extract GA Data
#'
#' @description A function for looping trhough a list of
#' GA Views to extract custom dimensions implemented across views
#'
#' @param ga_ids
#' @param extract_dates
#' @param extract_metrics
#' @param extract_dimensions
#' @param dim_list_map
#' @param dim_filter_string
#' @param outfile_directory
#' @param outfile_dim_colname
#' @param outfile_tz_col
#' @param outfile_directory
#'
#' @import dplyr
#' @import assertthat
#'
#' @family extract functions
#' @export
#'
#' @return a dataframe object
extract_ga_data <- function(ga_ids,
                            extract_dates=NULL,
                            extract_metrics=NULL,
                            extract_dimensions=NULL,
                            dim_list_map=NULL,
                            dim_filter_string=NULL,
                            outfile_dim_colname=NULL,
                            outfile_tz_col=FALSE,
                            outfile_directory=NULL) {

  assert_that(is.numeric(ga_ids))

  myMessage("Starting to get data from all GA views...")

  myMessage("Gathering of data from ", length(ga_ids), " GA views...")

  data <- lapply(ga_ids, function(x){

    # Get GA metadata for printing and timezone setting
    ga_account_info <- ga_account_list() %>%
      filter(viewId == x)

    ## save GA view metadata for ease of reference
    view <- ga_view(accountId = ga_account_info$accountId,
                    webPropertyId = ga_account_info$webPropertyId,
                    profileId = ga_account_info$viewId)

    ga_id <- as.character(x)

    ## if dim list map provided, use it
    ## if not, use same dimensions for all views
    if(is.null(extract_dimensions)){
      extract_dimensions <- c(extract_dimensions, dim_list_map[[ga_id]])

    } else {
      myMessage("No dim map provided, extract same dimensions for all.")
    }

    myMessage(sprintf("Fetching GA data from view %s...", x))

    out <- google_analytics(viewId = x,
                            date_range = extract_dates,
                            metrics = extract_metrics,
                            dimensions = extract_dimensions,
                            dim_filters = dim_filter_string,
                            max=-1,
                            anti_sample = TRUE)
    ## print ga view timezone info for ease of inspection during debugging
    myMessage("GA Data from view: ", view$name , " | ", x, " is in Timezone: ", view$timezone)

    ## if date column exists, set it to the view's timezone
    if("date" %in% colnames(out)){
      out$date <- as.Date(x = out$date,
                          format = "%Y %m %d",
                          tz = view$timezone)
    } else {
      myMessage("No date column fetched from GA so not adding timezone")
    }

    ## if timezone column param set, add it
    if (outfile_tz_col){
      myMessage("Adding a timezone column...")
      out$timezone <- view$timezone
    }
    else {
      myMessage("Not adding a timezone column, param not set")
    }

    ## standardise custom dimension name
    ### if param null
    if (is.null(outfile_dim_colname)){
      # Do nothing
      # ## set colname to "customDimension"
      # out$customDimension <- out[[dim_list_map[[ga_id]]]]
      # out[[dim_list_map[[ga_id]]]] <- NULL
    } else {
      ## anything else, set to param provided
      ## https://stackoverflow.com/a/30083352/1812363
      names(out)[names(out) == dim_list_map[[ga_id]]] <- outfile_dim_colname
    }

    ## set outfile save directory
    if (is.null(outfile_directory)){
      ## if not set, set empty so it saves to working directory
      out_dir <- ""
    } else {
      out_dir <- paste0(outfile_directory, "/")
    }

    ## order columns and write out to rds object
    out %>%
      saveRDS(file = paste0(out_dir, "viewId_", x, ".rds"))

    myMessage("done getting data from GA view: ", view$name , " | ", x)
  })

  myMessage("done getting data from ", length(ga_ids), " GA views!")
}
