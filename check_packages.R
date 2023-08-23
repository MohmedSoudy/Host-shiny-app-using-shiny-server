required_packages <- c("magrittr", "rvest", "dplyr")
# Install CRAN packages (if not already installed)
inst <- required_packages %in% installed.packages()
if(length(required_packages[!inst]) > 0) install.packages(required_packages[!inst])
# Load packages into session 
lapply(required_packages, library, character.only = TRUE)

check_packages <- function(libraries){
  CRANpackages <- available.packages() %>% 
    as.data.frame() %>% 
    select(Package) %>% 
    mutate(source = 'CRAN')
  
  url <- 'https://www.bioconductor.org/packages/release/bioc/'
  biocPackages <- url %>% 
    read_html() %>% 
    html_table() %>%
    .[[1]] %>%
    select(Package) %>% 
    mutate(source = 'BioConductor')
  
  all_packages <- bind_rows(CRANpackages, biocPackages) 
  rownames(all_packages) <- NULL
  result <- all_packages %>% filter(Package %in% libraries)
  return(result)
}
args <- commandArgs(trailingOnly = TRUE)
#Absolute path of packages file
Input_path <- args[1]
#Absolute path of output file
Out_path <- args[2]

libraries <- read.csv(Input_path)[,1]
result <- check_packages(libraries)
#Subset the results based on the type of packages 
CRAN_packages <- result[result$source == "CRAN",]
Bioc_packages <- result[result$source == "BioConductor",]
#Write the output files 
write.csv(CRAN_packages, file = paste0(Out_path, "CRAN_Packages.csv"), row.names = F)
write.csv(Bioc_packages, file = paste0(Out_path, "BioConductor_Packages.csv"), row.names = F)
