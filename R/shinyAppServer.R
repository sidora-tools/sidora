
#' Shiny app server function
#'
#' @param input provided by shiny
#' @param output provided by shiny
#'
#' @export
shinyAppServer <- function(input, output) {

  ##########################
  ## Get connection ##
  ##########################

  con <- sidora.core::get_pandora_connection()

  ##########################
  ## User defined Filters ##
  ##########################

  tag_list <- reactive({
    req(con)
    sidora.core::get_df("TAB_Tag", con) %>% dplyr::pull(Name)
  })

  # project_list <- reactive({
  #   req(con)
  #   print("Loading project tags")
  #   sidora.core::get_df("TAB_Project", con) %>% print %>% dplyr::pull(Name)
  # })

  project_list <-

  output$tag_include_list <- renderUI({
    req(con, tag_list)
    selectInput("selected_tag",
                "Select Tag(s):",
                as.list(tag_list()),
                selectize =  T,
                multiple = T,
                selected = "")
  })

  output$tag_exclude_list <- renderUI({
    req(con, tag_list)
    selectInput("excluded_tag",
                "Exclude Tag(s):",
                as.list(tag_list()),
                selectize =  T,
                multiple = T,
                selected = "")
  })

  output$project_include_list <- renderUI({
    req(con, project_list)
    print(project_list())
    selectInput("selected_project",
                "Select Project(s):",
                as.list(project_list()),
                selectize =  T,
                multiple = T,
                selected = "")
  })

  output$project_exclude_list <- renderUI({
    req(con, project_list)
    selectInput("excluded_project",
                "Exclude Project(s):",
                as.list(project_list()),
                selectize =  T,
                multiple = T,
                selected = "")
  })

  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- datasets::"faithful"[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })

  ##############
  ## Shutdown ##
  ##############

  onSessionEnded(function() {

    RMariaDB::dbDisconnect(con)

    stopApp()
  })

}
