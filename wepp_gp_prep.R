# Load climate index
cli_index <- read.csv("flowpath_xref_climate.txt", sep = "\t",
                      colClasses = c("numeric","numeric","character","numeric","character"))
names(cli_index)
print("Number of rows in Climate Index")
dim(cli_index)

devtools::install_github("jarad/WEPPR")
devtools::install_github("jarad/DEPR")
library(WEPPR)
library(DEPR)

# Load climate files
# Stored in raw/cli/NUMxNUM/NUM.##xNUM.##.cli
climate_files <- list()
for (i in 1:nrow(cli_index)){
  huc <- cli_index$HUC12[i]
  path <- paste("raw/", substring(cli_index$CLIMATE_FILE[i], start = 6), sep="")
  climate_files <- append(climate_files, list(read_cli(path)))
  names(climate_files)[i] <- paste("cli", huc, sep = "_")
  if (length(climate_files) == 20) break
}
names(climate_files)

# Load matching environment files
# Stored in raw/env/[8 digit number]/[4 digit number]/[8+4 digit number]_##.env
env_files <- list()
for (i in 1:nrow(cli_index)) {
  huc <- as.character(cli_index$HUC12[i])
  path1 <- paste("raw/env", substr(huc, 1, 8), substr(huc, 9, 12), sep = "/")
  xx <- dir(path = path1)
  for (j in length(xx)) {
    env_files <- append(env_files, list(read_env(paste(path1, xx[j], sep = "/"), 2009)))
    names(env_files)[length(env_files)] <- substr(xx[j], 1, 15)
  }
  if (length(env_files) == 20) break
}
names(env_files)

# Load matching slope files
# Stored in raw/slp/[8 digit number]/[4 digit number]/[8+4 digit number]_##.slp
slp_files <- list()
for (i in 1:nrow(cli_index)) {
  huc <- as.character(cli_index$HUC12[i])
  path1 <- paste("raw/slp", substr(huc, 1, 8), substr(huc, 9, 12), sep = "/")
  xx <- dir(path = path1)
  for (j in length(xx)) {
    slp_files <- append(slp_files, list(read_slp(paste(path1, xx[j], sep = "/"), 2009)))
    names(slp_files)[length(slp_files)] <- substr(xx[j], 1, 15)
  }
  if (length(slp_files) == 20) break
}
names(slp_files)
