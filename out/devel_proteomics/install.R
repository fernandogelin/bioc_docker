# DO NOT EDIT 'install.R'; instead, edit 'install.R.in' and
# use 'rake' to generate 'install.R'.

## Obtain list of packages in view, as defined in config.yml

wantedBiocViews <- c("Proteomics","MassSpectrometryData")


install.packages("Cairo")

## software packages
con1 <- url("http://www.bioconductor.org/packages/3.9/bioc/VIEWS")
dcf1 <- as.data.frame(read.dcf(con1), stringsAsFactors=FALSE)
## data packages
con2 <- url("http://www.bioconductor.org/packages/3.9/data/experiment/VIEWS")
dcf2 <- as.data.frame(read.dcf(con2), stringsAsFactors=FALSE)

dcf <- rbind(dcf1[, c("Package", "biocViews")],
             dcf2[, c("Package", "biocViews")])

i <- lapply(wantedBiocViews, grep, dcf$biocViews)
pkgs_matching_views <- dcf$Package[unique(unlist(i))]

ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)

##
## Selection and fine-tuning of packages to install
##
pkgs_to_install <- pkgs_matching_views[pkgs_matching_views %in% ap]

# don't reinstall anything that's installed already
pkgs_to_install <- setdiff(pkgs_to_install, rownames(installed.packages()))

## test - there are 96 packages
## installing 48 works
## works with 65, R3.4.0_Bioc3.5 only though
#pkgs_to_install <- pkgs_to_install[1:50]

# Explicitly disable broken packages:

# https://github.com/Bioconductor/bioc_docker/issues/58
pkgs_to_install <- pkgs_to_install[!grepl("prot2D", pkgs_to_install)]

## Start the actual installation:
BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE)


# just in case there were warnings, we want to see them
# without having to scroll up:
warnings()

if (!is.null(warnings())) {
    w <- capture.output(warnings())
    if (length(grep("is not available|had non-zero exit status", w)))
        quit("no", 1L)
}

suppressWarnings(BiocManager::install(update=TRUE, ask=FALSE))
