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
launchApp <- function() {
  app_object <- shiny::shinyApp(ui = shinyAppUI, server = shinyAppServer)
  shiny::runApp(app_object)
}
