# MIT License
#
# Copyright (c) 2023 Sophie Katz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# NOTE: This script needs to be compatible with both ZSH and BASH

function banner() {
    echo -ne "\033[1;95m"
    echo -e "  ___           _    _       _ ____"
    echo -e " / __| ___ _ __| |_ (_)___  (_)__ /"
    echo -e " \__ \/ _ \ '_ \ ' \| / -_)  _ |_ \\"
    echo -e " |___/\___/ .__/_||_|_\___| (_)___/"
    echo -e "          |_|"
    echo -ne "\033[0;0m"
    echo
}

function log_helper() {
    readonly color="$1"
    readonly type="$2"
    readonly message="$3"

    if [ -z "$color" ] || [ -z "$type" ] || [ -z "$message" ]; then
        log_error "log_helper requires 3 arguments"
        exit 1
    fi

    echo -e "\033[0;90m[\033[1;34msetup\033[0;90m:\033[0;0m$color$type\033[0;90m]\033[1;37m $message\033[0;0m"
}

function log_info() {
    local message="$1"

    if [ -z "$message" ]; then
        log_error "log_error requires 1 argument"
        exit 1
    fi

    log_helper "\033[1;34m" "info" "$message"
}

function log_error() {
    local message="$1"

    if [ -z "$message" ]; then
        log_error "log_error requires 1 argument"
        exit 1
    fi

    log_helper "\033[1;31m" "error" "$message"
}
