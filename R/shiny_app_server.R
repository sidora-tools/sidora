# Shiny app server function

shiny_app_server <- function(input, output, session) {
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
    shiny::selectInput(
      "selected_tag",
      "Select Tag(s):",
      as.list(tag_list()),
      selectize =  T,
      multiple = T,
      selected = ""
    )
  })

  output$tag_exclude_list <- shiny::renderUI({
    shiny::req(con, tag_list)
    shiny::selectInput(
      "excluded_tag",
      "Exclude Tag(s):",
      as.list(tag_list()),
      selectize =  T,
      multiple = T,
      selected = ""
    )
  })

  output$project_include_list <- shiny::renderUI({
    shiny::req(con, project_list)
    shiny::selectInput(
      "selected_project",
      "Select Project(s):",
      as.list(project_list()),
      selectize =  T,
      multiple = T,
      selected = ""
    )
  })

  output$project_exclude_list <- shiny::renderUI({
    shiny::req(con, project_list)
    shiny::selectInput(
      "excluded_project",
      "Exclude Project(s):",
      as.list(project_list()),
      selectize =  T,
      multiple = T,
      selected = ""
    )
  })

  ########################
  ## Get base dataframe ##
  ########################

  all_tables <- shiny::reactive({
    shiny::req(con)

    table_names <- c(
      "TAB_Site",
      "TAB_Individual",
      "TAB_Sample",
      "TAB_Extract",
      "TAB_Library",
      "TAB_Capture",
      "TAB_Sequencing",
      "TAB_Raw_Data",
      "TAB_Analysis",
      "TAB_Analysis_Result_String"
    )

    shiny::withProgress(sidora.core::get_df_list(con, tab = table_names),
                        message = "Downloading data...")

  })

  ###################
  ## Overview Page ##
  ###################

  output$site_box <- shinydashboard::renderInfoBox({
    shiny::req(con, all_tables)

    result <- all_tables()$TAB_Site %>% nrow

    shinydashboard::valueBox(result,
                             "Sites",
                             icon = shiny::icon("map-marked-alt"),
                             color = "blue")
  })

  ##############
  ## Shutdown ##
  ##############

  shiny::onSessionEnded(function() {
    RMariaDB::dbDisconnect(con)

    shiny::stopApp()
  })

}
