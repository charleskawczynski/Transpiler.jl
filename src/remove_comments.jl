function clean_whitespaces_and_newlines(contents)
    # Remove lines with only whitespaces:
    contents = join([line for line in split(contents, "\n") if (length(line)≠count(" ", line)) || isempty(line)], "\n")

    # Trim some \n's
    contents = replace(contents, "\n\n\n\n"=>"\n\n")
    contents = replace(contents, "\n\n\n\n"=>"\n\n")
    contents = replace(contents, "\n\n\n"=>"\n\n")
    if startswith(contents, "\n\n")
        chop(contents, head=1, tail=0)
    end
    return contents
end
comment_flags(::Union{Python,Cython}) = ("#",)
doc_string_flags(::Union{Python,Cython}) = ("\"\"\"",)
cond(ts,i,f1,f2) = ts.token_stream[f1][i]≠1 && ts.token_stream[f2][i]≠1

function remove_comments(file, ::Union{Python,Cython})
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
