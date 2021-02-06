.onUnload <- function (libpath) {
  library.dynam.unload("sabre", libpath)
}
