#-------------------------------------------------
# Title: Create SQL Database
# Author: Amanda Zacharias
# Date: 2023-11-09
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------
#
#
#
#
# Packages -----------------------------------------
library(DBI) # 1.1.3
library(RSQLite) # 2.2.20

# Pathways -----------------------------------------
csvPath <- file.path("./resources.csv")

# Create db -----------------------------------------
drDb <- dbConnect(RSQLite::SQLite(), "duanResourcesDb.sqlite")

# Load data -----------------------------------------
csv <- read.csv(csvPath, row.names = 1, stringsAsFactors = FALSE)

# Code -----------------------------------------
# Create different tables for SQL db =======
toolDf <- csv
toolDf[1, ] <- c("StringTie", "AmandaZacharias", "09Nov2023", "tool", "Tool used to quantify gene expression.")

databasesDf <- csv
databasesDf[1, ] <- c("Gencode", "AmandaZacharias", "09Nov2023", "database", "Database of genomes")

papersDf <- csv
papersDf[1, ] <- c("paperExample", 'AmandaZacharias', "09Nov2023", "paper", "Test paper")

miscDf <- csv
miscDf[1, ] <- c("miscThing", "AmandaZacharias", "09Nov2023", "misc", "test")

# Add to db -----------------------------------------
dbWriteTable(conn = drDb, name = "tools", value = toolDf)
dbWriteTable(conn = drDb, name = "databases", value = databasesDf)
dbWriteTable(conn = drDb, name = "papers", value = papersDf)
dbWriteTable(conn = drDb, name = "misc", value = miscDf)

# Disconnect  -----------------------------------------
dbDisconnect(drDb)
