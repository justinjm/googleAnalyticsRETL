#' Load GA Data to BQ
#' for use in Shiny Apps to preserve against data loss
#' and optimize Docker/GCR workflow by not storing data locally
#'
#'@param ga_ids,
#'@param outfile_directory
#'@param create
#'@param overwrite
load_ga_data <- function(ga_ids,
                         outfile_directory = NULL,
                         create,
                         overwrite = NULL) {

  message("[-] starting to get load GA data to BQ...")

  message("[?] loading data for", length(ga_ids), " GA views...")

  lapply(ga_ids, function(x){

    ## set out directory
    if (is.null(outfile_directory)) {
      out_dir <- ""
    } else {
      out_dir <- paste0(outfile_directory, "/")
    }

    ## set filename
    file_name <- paste0(out_dir, "viewId_", x, ".rds")

    ## set bq destination table
    dest_table_id <- paste0("viewId_", x)

    ## load file from local into memory
    df <- readRDS(file = file_name)

    ## add column for upload time
    df$upload_timestamp <- Sys.time()

    ## load dataframe from memeory to BQ
    bqr_upload_data(tableId = dest_table_id,
                    upload_data = df,
                    create = create,
                    overwrite = overwrite)
  })
}
