# This file is a part of Julia. License is MIT: https://julialang.org/license

## dummy stub for https://github.com/JuliaBinaryWrappers/p7zip_jll.jl
module p7zip_jll

const PATH_list = String[]
const LIBPATH_list = String[]

export p7zip

# These get calculated in __init__()
PATH = Ref("")
LIBPATH = Ref("")
artifact_dir = ""
p7zip_path = ""
if Sys.iswindows()
    const p7zip_exe = "7z.exe"
else
    const p7zip_exe = "7z"
end

# These functions look a little strange, but they're mimicking the JLLWrappers signature
p7zip(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true) = f(p7zip_path)
p7zip(; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true) = Cmd([p7zip_path])

function init_p7zip_path()
    # Prefer our own bundled p7zip, but if we don't have one, pick it up off of the PATH
    # If this is an in-tree build, `7z` will live in `bin`.  Otherwise, it'll be in `libexec`
    for bundled_p7zip_path in (joinpath(Sys.BINDIR, Base.LIBEXECDIR, p7zip_exe),
                               joinpath(Sys.BINDIR, p7zip_exe))
        if isfile(bundled_p7zip_path)
            global p7zip_path = abspath(bundled_p7zip_path)
            return
        end
    end
    global p7zip_path = Sys.which(p7zip_exe)
end

function __init__()
    global artifact_dir = dirname(Sys.BINDIR)
    global LIBPATH[] = joinpath(Sys.BINDIR, Base.LIBDIR, "julia")
    init_p7zip_path()
end

is_available() = true

end  # module p7zip_jll
