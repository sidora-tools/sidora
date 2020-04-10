# Shiny app server function

shinyAppServer <- function(input, output, session) {

  ####################
  ## Get connection ##
  ####################

  con <- sidora.core::get_pandora_connection()

  ##########################
  ## User defined Filters ##
  ##########################

  tag_list <- shiny::reactive({
    shiny::req(con)
    sidora.core::get_df("TAB_Tag", con) %>% dplyr::pull(.data$Name)
  })

  project_list <- shiny::reactive({
    shiny::req(con)
    sidora.core::get_df("TAB_Project", con) %>% dplyr::pull(.data$Name)
  })

  output$tag_include_list <- shiny::renderUI({
    shiny::req(con, tag_list)
    shiny::selectInput("selected_tag",
                "Select Tag(s):",
                as.list(tag_list()),
                selectize =  T,
                multiple = T,
                selected = "")
  })

  output$tag_exclude_list <- shiny::renderUI({
    shiny::req(con, tag_list)
    shiny::selectInput("excluded_tag",
                "Exclude Tag(s):",
                as.list(tag_list()),
                selectize =  T,
                multiple = T,
                selected = "")
  })

  output$project_include_list <- shiny::renderUI({
    shiny::req(con, project_list)
    shiny::selectInput("selected_project",
                "Select Project(s):",
                as.list(project_list()),
                selectize =  T,
                multiple = T,
                selected = "")
  })

  output$project_exclude_list <- shiny::renderUI({
    shiny::req(con, project_list)
    shiny::selectInput("excluded_project",
                "Exclude Project(s):",
                as.list(project_list()),
                selectize =  T,
                multiple = T,
                selected = "")
  })

  output$distPlot <- shiny::renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- datasets::"faithful"[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    graphics::hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })

  ##############
  ## Shutdown ##
  ##############

  shiny::onSessionEnded(function() {

    RMariaDB::dbDisconnect(con)

    shiny::stopApp()
  })

}
