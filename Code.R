# load extra libraries
# install.packages("stringr")
library("stringr")

# get locations of all cn files
files <- Sys.glob("*.cc2.tsv")

# create function to read in and format data
a <- function(x){
    # read data and set column names
    data <- read.delim(x, header=FALSE)
    colnames(data) <- c("chromosome", "start", "end", "probes", "segmean")

    # get the sample name from the file path
    sampleName <- str_extract(x, "H_OM.+cc2")
    sampleName <- gsub(".cc2", "", sampleName)
    data$sample <- sampleName

    # return the data
    return(data)
}

# run the anonymous function defined above
cnData <- lapply(files, a)

# turn the list of data frames into a single data frame
cnData <- do.call("rbind", cnData)


# construct genomic boundaries from cytoGeno
genomeBoundaries <- aggregate(chromEnd ~ chrom, data=cytoGeno[cytoGeno$genome=="hg19",], max)
genomeBoundaries$chromStart <- 0
colnames(genomeBoundaries) <- c("chromosome", "end", "start")

# create the plot
cnSpec(cnData, y=genomeBoundaries)


#The genome parameter

# add a flank to the genomic coordinates
genomeBoundaries_2 <- genomeBoundaries
genomeBoundaries_2$start <- genomeBoundaries_2$start - 1e8
genomeBoundaries_2$end <- genomeBoundaries_2$end + 1e8

# create a plot
cnSpec(cnData, y=genomeBoundaries_2)

#https://genviz.org/module-03-genvisr/0003/06/01/cnSpec_GenVisR/
