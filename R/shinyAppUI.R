#' Shiny app ui function

shinyAppUI <- function() {

  shinydashboard::dashboardPage(
    skin = "green",
    shinydashboard::dashboardHeader(
      title = shiny::tags$a(href = 'https://github.com/sidora-tools/sidora',
                            shiny::tags$img(shiny::includeHTML(
                              system.file(
                                'shiny/www/Athena_skull_v2_2_32x110_white_text.svg',
                                package = 'sidora'
                              )
                            ))),
      titleWidth = 270
    ),
    shinydashboard::dashboardSidebar(
      width = 270,
      shiny::h3("Pages"),
      shinydashboard::sidebarMenu(
        id = "tabs",
        shinydashboard::menuItem(
          "Overview",
          tabName = "overview",
          icon = shiny::icon("tachometer-alt"),
          selected = T,
          startExpanded = TRUE
        ),
        shinydashboard::menuItem(
          "Maps",
          tabName = "my_maps",
          icon = icon("map"),
          shinydashboard::menuSubItem(
            "Individuals Map",
            tabName = "individual_map"
          ),
          shinydashboard::menuSubItem(
            "Samples Map",
            tabName = "sample_map"
          ),
          shinydashboard::menuSubItem(
            "Sample Type Map",
            tabName = "sampletype_map"
          )
        ),
        shinydashboard::menuItem(
          "Archaeological Info",
          tabName = "arch_info",
          icon = icon("tooth")
                                 ),
        shinydashboard::menuItem(
          "Laboratory Info",
          tabName = "lab_info",
          icon = icon("flask")
        ) ,
        shinydashboard::menuItem(
          "Progress",
          shinydashboard::menuSubItem(
            "Progress Table",
            tabName = "progress_table"
          ),
          shinydashboard::menuSubItem(
            "Progress Chart",
            tabName = "progress_chart"
          ),
          shinydashboard::menuSubItem(
            "Capture Progress Table",
            tabName = "captureprogress_table"
          ),
          tabName = "progress_super",
          icon = icon("table")
        )
      ),
      shiny::h3("Filters"),
      shiny::dateRangeInput("date_range",
                     "Date Range",
                     start = lubridate::as_date("2016-01-01"),
                     end = lubridate::as_date(format(Sys.Date(), "%Y-%m-%d")),
                     min = lubridate::as_date("2016-01-01"),
                     max = lubridate::as_date(format(Sys.Date(), "%Y-%m-%d")),
                     format = "yyyy-mm-dd",
                     startview = "year",
                     weekstart = 0,
                     language = "en",
                     separator = " to ",
                     width = NULL),
      #uiOutput("date_range"),
      shiny::uiOutput("tag_include_list"),
      shiny::uiOutput("tag_exclude_list"),
      shiny::uiOutput("project_include_list"),
      shiny::uiOutput("project_exclude_list"),
      shiny::actionButton("go", "Update Filter")
    ),
    shinydashboard::dashboardBody(
      shiny::tags$head(
        shiny::tags$link(rel = "shortcut icon", href = "favicon.ico"),
        # stylesheet
        shiny::includeCSS(system.file("shiny/www/stylesheet.css", package = "sidora"))
      ),
      shiny::a(href = "https://github.com/sidora-tools/sidora",
               shiny::div(class = "corner_symbol",
                          shiny::icon("github"))),

    )
  )

}
