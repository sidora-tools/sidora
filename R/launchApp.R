#' launches the shinyAppDemo app
#'
#' @export launchApp
#'
#' @return shiny application object
#'
#' @example \dontrun {launchApp()}
#'
#' @import shiny
#'


# wrapper for shiny::shinyApp()
launchApp <- function() {
  shiny::shinyApp(ui = shinyAppUI, server = shinyAppServer)
}
