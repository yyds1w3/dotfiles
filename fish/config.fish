# dms kill
# niri msg action spawn -- dms run
set -gx LANG en_US.UTF-8
set -g fish_greeting
fish_add_path ~/.local/bin
starship init fish | source
zoxide init fish | source

abbr reboot 'systemctl reboot'
abbr c 'clear'
function proxy
    set -gx https_proxy http://127.0.0.1:7897
    set -gx http_proxy http://127.0.0.1:7897
end
function unproxy
    set -e https_proxy 
    set -e http_proxy
end
function ls
	command eza --icons=auto $argv
end

function lt
	command eza --icons=auto --tree $argv
end

function la
	command eza -l --icons=auto $argv
end
function nv
    command nvim $argv
end

function n
    set name $argv[1]
    if not test -f "$name.cpp"
        echo "//"(date) >> "$name.cpp"
        cat ~/ACM/lib/basic/temp.cpp >> "$name.cpp"
    end
    touch in.txt sout.txt
    nvim "$name.cpp"
end

function nb
    if not test -f "brute.cpp"
        echo "//"(date) >> "brute.cpp"
        cat ~/ACM/lib/basic/brute.cpp >> "brute.cpp"
    end
    nvim "brute.cpp"
end
function ng
    if not test -f "gen.cpp"
        echo "//"(date) >> "gen.cpp"
        cat ~/ACM/lib/basic/gen.cpp >> "gen.cpp"
    end
    nvim "gen.cpp"
end

function r
    set name $argv[1]
    if g++ "$name.cpp" -g -std=c++20 -Wall -o $name
        ./$name < in.txt > sout.txt
        cat sout.txt
    else 
        echo "Compilation Error!"
    end
end

function cl
    set name $argv[1]
    rm "$name.cpp" $name
end

function dp
    set name $argv[1]
    set cnt $argv[2]
    if g++ "gen.cpp" -g -std=c++20 -Wall -o gen
    else
        echo "gen.cpp Compilation Error!"
        return 1
    end
    if g++ "$name.cpp" -g -std=c++20 -Wall -o $name
    else
        echo "$name.cpp Compilation Error!"
        return 1
    end
    if g++ "brute.cpp" -g -std=c++20 -Wall -o brute
    else
        echo "brute.cpp Compilation Error!"
        return 1
    end
    for i in (seq 1 $cnt) 
        ./gen > in.txt
        ./$name < in.txt > sout.txt
        ./brute < in.txt > bout.txt
        if not diff sout.txt bout.txt
            printf "\r❌[%d/%d]" $i $cnt
            return 1
        else
            printf "\r✅[%d/%d]" $i $cnt
        end
    end
end

function ai
    cd ~/ai/$argv[1] && claude
end
