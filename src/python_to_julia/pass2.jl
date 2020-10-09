"""
    pass2(project)

 - Remove `pass2/`
 - Copy files from `pass1/` into `pass2`
 - Remove comments (if indicated)
"""
function pass2(project)
    println("Performing pass 2...")
    files = prep_pass(project, 2)
    if !project.preserve_comments
        for f in files
            remove_comments(f, project.language_from)
        end
    end
end
