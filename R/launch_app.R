#' Launches the Sidora shiny app
#'
#' @return shiny application object
#'
#' @examples
#' \dontrun{
#' launchApp()
#' }
#'
#' @export
launch_app <- function() {
  app_object <- shiny::shinyApp(ui = shiny_app_ui, server = shiny_app_server)
  shiny::runApp(app_object)
}
