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

  output$individual_box <- shinydashboard::renderInfoBox({
    shiny::req(con, all_tables)

    result <- all_tables()$TAB_Individual %>% nrow

    shinydashboard::valueBox(result,
                             "Individual",
                             icon = shiny::icon("female"),
                             color = "light-blue")
  })

  output$sample_box <- shinydashboard::renderInfoBox({
    shiny::req(con, all_tables)

    result <- all_tables()$TAB_Sample %>% nrow

    shinydashboard::valueBox(result,
                             "Sample",
                             icon = shiny::icon("skull"),
                             color = "aqua")
  })

  output$extract_box <- shinydashboard::renderInfoBox({
    shiny::req(con, all_tables)

    result <- all_tables()$TAB_Extract %>% nrow

    shinydashboard::valueBox(result,
                             "Extract",
                             icon = shiny::icon("vial"),
                             color = "yellow")
  })

  output$library_box <- shinydashboard::renderInfoBox({
    shiny::req(con, all_tables)

    result <- all_tables()$TAB_Library %>% nrow

    shinydashboard::valueBox(result,
                             "Library",
                             icon = shiny::icon("book"),
                             color = "orange")
  })

  output$capture_box <- shinydashboard::renderInfoBox({
    shiny::req(con, all_tables)

    result <- all_tables()$TAB_Capture %>% nrow

    shinydashboard::valueBox(result,
                             "Capture",
                             icon = shiny::icon("magnet"),
                             color = "red")
  })

  output$rawdata_box <- shinydashboard::renderInfoBox({
    shiny::req(con, all_tables)

    result <- all_tables()$TAB_Raw_Data %>% nrow

    shinydashboard::valueBox(result,
                             "Capture",
                             icon = shiny::icon("stream"),
                             color = "red")
  })

  # output$extlib_gauge <- flexdashboard::renderGauge()
  #
  # output$libcap_gauge <- flexdashboard::renderGauge()
  #
  # output$capseq_gauge <- flexdashboard::renderGauge()
  #
  # output$monthlyreads_gauge <- flexdashboard::renderGauge()

  ##############
  ## Shutdown ##
  ##############

  shiny::onSessionEnded(function() {
    RMariaDB::dbDisconnect(con)

    shiny::stopApp()
  })

}
