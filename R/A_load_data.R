#'@title Load Data Files
#'
#' @description Loading files required for plotting annotated trees generated from SACCAHRIS v2, and sorts data frames to order them based on tree nodes.
#'
#' @param ... Prompted text entry of metadata .json file name (SACCHARIS output).
#' @param ... Prompted text entry of .tree file name (SACCHARIS output).
#'
#' @importFrom jsonlite fromJSON
#' @importFrom ape read.tree
#' @importFrom stringr str_remove
#' @importFrom magicfor magic_for magic_result_as_dataframe
#' @importFrom knitr kable
#' @importFrom dplyr tibble
#' @importFrom magrittr %>%
#'
#' @examples
#' A_load_data()
#' test_data.json
#' GH16_characterized.tree
#' @returns
#' CAZY_TABLE_FINAL_GHxx_characterized_DATE.xlsx. Exported data table containing information from cazy.org for each sequence.
#' @export
#'

A_load_data <- function(){
  #### load JSON metadata file

  cazy_data = readline(prompt = "Enter the name of your SACCHARIS JSON file: ")
  cazy_json <<- jsonlite::fromJSON(cazy_data) # reads in json file

  Cazy_table_edited = as.data.frame(do.call(rbind, cazy_json)) # assigns the json file to a data frame
  Cazy_table_edited$genbank <- rownames(Cazy_table_edited) # this retains the multiple-domain assignments to the genbank ID

  #### load metadata ####

  # load the tree file, and plot/annotate based on the metadata data frame
  tree_name = readline(prompt = "Enter the name of your SACCHARIS tree file: ")
  myTREE <<- ape::read.tree(file = tree_name)    # get node names
  tree_tip_names <<- myTREE$tip.label    # get tip names from the tree
  tree_tip_names=as.matrix(tree_tip_names)
  colnames(tree_tip_names)="genbank"

  # merge CAZY and tree file by GenBank numbers
  merge_t= merge(tree_tip_names, Cazy_table_edited, by.x = "genbank",  all.x=TRUE, sort=FALSE)
  Cazy_table_ord = merge_t[order(pmatch(merge_t[,1], tree_tip_names )),]
  # rownames(Cazy_table_ord) <- 1:nrow(Cazy_table_ord)

  df_tree <<- data.frame(Cazy_table_ord)
  myTREE<<-myTREE
  tree_tip_names<<-tree_tip_names
  currentDate <- Sys.Date()
  final <<- Cazy_table_ord %>% replace(.=="NULL", "0") # replace NULL with "O"
  rownames(final)=final$genbank
  final <- apply(final,2,as.character)

  # FIRST make Cazy_table_edited dataframe not list
  # then order by genbank
  # then make final dataframe
  # order final by genbank
  # then replace final module start and end with Cazy_table_edited versions.
  Cazy_table_edited<- apply(Cazy_table_edited,2,as.character)
  Cazy_table_edited<-as.data.frame(Cazy_table_edited)
  Cazy_table_edited_order <- Cazy_table_edited[order(Cazy_table_edited$genbank),]

  final<-as.data.frame(final)
  final_ord<-final[order(final$genbank),]
  identical(Cazy_table_edited_order[['genbank']],final_ord[['genbank']]) # check if identical

  final_ord$module_start=Cazy_table_edited_order$module_start
  final_ord$module_end=Cazy_table_edited_order$module_end

  # output a .csv file that includes all the metadata but also includes tree ID
  write.csv(final_ord, file=sprintf(paste("CAZY_TABLE_FINAL_%s_", currentDate, ".csv", sep=""), substr(tree_name,1,nchar(tree_name)-5)), row.names = TRUE)

  # for loop to copy from cazy final to tip names
  df_for_tree <<- df_tree # contains NAs need to remove or change to USER sequence
  df_for_tree<<-df_for_tree
  i <- sapply(df_for_tree, is.factor)
  df_for_tree[i] <- lapply(df_tree[i], as.character)


  #### clean up the labels for the tree annotation
  df_for_tree$domain[grepl("NULL", df_for_tree$domain)] <- "USER_SEQ"
  df_for_tree$org_name[grepl("NULL", df_for_tree$org_name)] <- "Unclassified"
  df_for_tree$ec_num[grepl("NULL", df_for_tree$ec_num)] <- "Unidentified"
  df_for_tree$protein_name[grepl("NULL", df_for_tree$protein_name)] <- "Unidentified"

  df_for_tree<<-df_for_tree

  identical_tips=identical(df_for_tree[['genbank']],myTREE[['tip.label']]) # check if identical
  if (identical_tips == FALSE){
    print("Your tree tip name and dataframe dont match this will cause issues when plotting heatmaps")  }

  df_for_tree<<-df_for_tree
  myTREE<<-myTREE
}