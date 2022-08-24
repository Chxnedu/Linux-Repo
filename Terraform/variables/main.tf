resource "local_file" "my_game" {
    filename = var.filename
    content = var.content[0]
}
