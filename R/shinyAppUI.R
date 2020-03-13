

#' Shiny app server function
#'
#'
#' @param input provided by shiny
#' @param output provided by shiny
#'
#' @export
shinyAppUI <- shinydashboard::dashboardPage(
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
      )
    )
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
