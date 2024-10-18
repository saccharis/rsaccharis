#'@title Load Data Files
#'
#' @description Loading files required for plotting annotated trees generated from SACCAHRIS v2, and sorts data frames to order them based on tree nodes.
#'
#' @param json_file Argument for text filepath to metadata .json file name (SACCHARIS output). If not given, user is prompted for text entry of metadata .json file name instead.
#' @param tree_name Argument for text filepath to .tree file name (SACCHARIS output). If not given, user is prompted for text entry of .tree file name instead.
#' @param out_dir Argument for text folderpath output CAZY_TABLE_FINAL_GHxx_characterized_DATE.xlsx to.
#' @param root Argument for optional rooting of the tree. This should be a tip label present in the tree. If left unfilled, the tree will be unrooted.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom ape read.tree root
#' @importFrom stringr str_remove
#' @importFrom knitr kable
#' @importFrom dplyr tibble
#' @importFrom magrittr %>%
#' @importFrom utils write.csv
#'
#' @examples
#' \dontrun{
#' A_load_data()
#' test_data.json
#' GH16_characterized.tree
#' }
#' @examples
#' \dontrun{
#' A_load_data("PL9_CHARACTERIZED_ALL_DOMAINS.json", "PL9_CHARACTERIZED_ALL_DOMAINS_FASTTREE.tree")
#' }
#' @returns
#' CAZY_TABLE_FINAL_GHxx_characterized_DATE.xlsx. Exported data table containing information from cazy.org for each sequence.
#' @export
#'

A_load_data <- function(json_file=NULL, tree_name=NULL, out_dir=NULL, root=NULL){
  #### load JSON metadata file
  if (is.null(json_file)) {
    json_file <- readline(prompt = "Enter the name of your SACCHARIS JSON file: ")
  }
  #print(json_file)/
  #print(dir(getwd()))
  cazy_json <<- jsonlite::fromJSON(json_file) # reads in json file
  Cazy_table_edited <- as.data.frame(do.call(rbind, cazy_json)) # assigns the json file to a data frame
  Cazy_table_edited$genbank <- rownames(Cazy_table_edited) # this retains the multiple-domain assignments to the genbank ID

  #### load metadata ####

  # load the tree file, and plot/annotate based on the metadata data frame
  if (is.null(tree_name)) {
    tree_name <- readline(prompt = "Enter the name of your SACCHARIS tree file: ")
  }
  tree_stem = basename(tree_name)
  myTREE <<- ape::read.tree(file = tree_name)    # get node names
  if (!is.null(root)) {
    # need to use edgelabel=TRUE when rerooting trees with bootstrap values as node labels (e.g. newick format with bootstrap values)
    # For full explanation, see https://doi.org/10.1093/molbev/msx055
    myTREE <<- ape::root(myTREE, "OUT0000000", edgelabel=TRUE)
  }
  tree_tip_names <<- myTREE$tip.label    # get tip names from the tree
  tree_tip_names <- as.matrix(tree_tip_names)
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
  if (!is.null(out_dir)) {
    setwd(out_dir)
  }
  write.csv(final_ord, file=sprintf(paste("CAZY_TABLE_FINAL_%s_", currentDate, ".csv", sep=""), substr(tree_stem,1,nchar(tree_stem)-5)), row.names = TRUE)

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
