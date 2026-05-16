---@type vim.lsp.Config
return {
    cmd = {
        "env",
        "JAVA_HOME=/usr/lib/jvm/java-21-openjdk",
        "KOTLIN_LANGUAGE_SERVER_OPTS=-Dkotlin.jvm.target=21",
        "kotlin-language-server",
    },
    filetypes = { "kotlin" },
    init_options = {
        storagePath = vim.fn.resolve(vim.fn.stdpath("cache") .. "/kotlin_language_server")
    },
    root_markers = {
        "settings.gradle",
        "settings.gradle.kts",
        "build.xml",
        "pom.xml",
        "build.gradle",
        "build.gradle.kts"
    },
    settings = {
        kotlin = {
            compiler = {
                jvmTarget = "21", -- 3. Auch hier auf 25 ändern
                args = { "-jvm-target", "21" }
            }
        }
    }
}
