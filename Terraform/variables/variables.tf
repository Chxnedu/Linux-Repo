variable "filename" {
  type = string
  default = "/home/kali/Documents/games.txt"
  description = "name of the file, can include the path"
}
variable "content" {
  type = list(string)
  default = [ "tlou2", "god of war", "uncharted 4" ]
  description = "the games you want in the file"
}
