#-------------------------------------------------
# Title: Shiny app to manage a database of Duan lab resources
# Original Authors: Amanda Zacharias, Sara Stickley, Zhi Yi Fang
# Date: 2023-11-09
# Email: 16amz1@queensu.ca
#-------------------------------------------------
# Notes -------------------------------------------
# R v3.6.0
# RSQLite info: https://cran.r-project.org/web/packages/RSQLite/vignettes/RSQLite.html
# Reference for this project: https://shanghai.hosting.nyu.edu/data/r/case-4-database-management-shiny.html#Dashboard_layout
#
# Options -----------------------------------------
source("helpers.R")

# Packages -----------------------------------------
library(shiny) # 1.7.4
library(shinydashboard) # 0.7.2
library(DBI) # 1.1.3
library(RSQLite) # 2.2.20

# Pathways -----------------------------------------
dbPath <- file.path("duanResourcesDb.sqlite")

# Load data -----------------------------------------
db <- dbConnect(RSQLite::SQLite(), dbname = dbPath)

tableIntro <- list(tools = "Tools for analysis (i.e. softwares)", 
                   databases = "Databases",
                   papers = "Papers",
                   misc = "Miscellaneous")

# Define UI -----------------------------------------
ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Resources Database"), 
  dashboardSidebar(
    collapsed = TRUE, 
    sidebarMenu(
      menuItem("View Tables", tabName = "viewTables", icon = icon("search")),
      menuItem("Insert Entries", tabName = "insertValue", icon = icon("edit")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ), 
  dashboardBody(
    tabItems(
      tabItem(tabName = "viewTables", uiOutput("viewUI")),
      tabItem(tabName = "insertValue", uiOutput("insertUI")),
      tabItem(tabName = "about", uiOutput("aboutUI"))
    )
  )
)

# Define server logic -----------------------------------------
server <- function(input, output, session) {
  # View tables =============
  output$viewUI <- renderUI({
    box(width = NULL, status = "primary",
        sidebarLayout(
          sidebarPanel(
            box(width = 12,
                collapsible = TRUE,
                div(style = "height: 15px; background-color: white;"),
                title = "Database Info:",
                p("This is an SQLite database of resources for the Duan lab.")),
            selectInput(inputId = "selectedViewTab",
                        label = "Tables in Database",
                        choices = dbListTables(db),
                        selected = "tools"
                        ),
            textOutput(outputId = "tableIntro"),
            tags$head(tags$style("#tableIntro{font-size: 15px;font-style: italic;}"))
          ),
          mainPanel(
            h4(strong("Table Preview")),
            dataTableOutput(outputId = "selectedTableView")
          )
        )
    )
  })
  output$selectedTableView <- renderDataTable(
    data <- dbGetQuery(
      conn = db, 
      statement = paste("SELECT * FROM", input$selectedViewTab)
    )
  )

  output$tableIntro <- renderText(
    if (input$selectedViewTab %in% c("tools", "databases", "papers"))
    {tableIntro[[input$selectedViewTab]]}
    else {tableIntro$misc}
  )
  # New entries =======
  
}

# Run the application  -----------------------------------------
onStop(
  function(){
    dbDisconnect(db)
  }
)

shinyApp(ui = ui, server = server)

