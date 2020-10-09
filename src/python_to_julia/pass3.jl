"""
    pass3(project)

 - Remove `pass3/`
 - Copy files from `pass2/` into `pass3`
 - Translating scope syntax
"""
function pass3(project)
    println("Performing pass 3...")
    files = prep_pass(project, 3)

    for f in files

        println("   -----------------------")
        println("   Removing comments for file $(basename(file))")
        contents = open(f->read(f, String), file)

        println("   Single-line comments...")
        contents = join([rstrip(split(line, "#")[1]) for line in split(contents, "\n")], "\n")
        # Remove lines with only whitespaces:
        println("   Cleaning white spaces...")
        contents = clean_whitespaces_and_newlines(contents)

        contents = join([line for line in split(contents, "\n")], "\n")

        flag_set = FlagSet([
        FlagPair{GreedyType}(
        StartFlag("'''", ["\n", " ", ""], ["\n", " ", ""]),
        StopFlag("'''", ["\n", " ", ""], ["\n", " ", ""])
        ),
        FlagPair{GreedyType}(
        StartFlag("\"\"\"", ["\n", " ", ""], ["\n", " ", ""]),
        StopFlag("\"\"\"", ["\n", " ", ""], ["\n", " ", ""])
        )])
        println("   Creating token stream...")
        ts = TokenStream(contents, flag_set)
        println("   Finished creating token stream...")

        fs = ("'''-'''", "\"\"\"-\"\"\"")
        i_code = [i for i in eachindex(ts.code) if cond(ts, i, fs[1],fs[2])]
        contents = join([SubString(ts.code, i, i) for i in i_code])

        println("   Cleaning white spaces...")
        contents = clean_whitespaces_and_newlines(contents)

        open(file, "w") do io
            print(io, contents)
        end

    end

end
