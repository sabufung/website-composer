if (typeof(CKEDITOR) != 'undefined') {
    CKEDITOR.editorConfig = function (config) {
        config.removePlugins= 'htmlwriter'
    }
}