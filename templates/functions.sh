
#functions.sh

#Misc

function ..() {
	local count=$1
	local path=""
	while [ $count -gt 0 ]; do
		path="../$path"
		let count=count-1
	done
	cd $path
}

function fcd() {
	selected_dir=$(fd . ~ -t d -H | fzf --reverse --preview 'tree -L 1 {}')
	echo "Selected directory: $selected_dir"
	cd "$selected_dir"
}

function v() {
	vim -o $(fd . -H -t f | fzf --preview 'bat --color=always {}')
}

function gbc(){
	currentBranch=$(git branch --show-current)
	git commit -m "[$currentBranch] - '$1'"
}

function frg(){
	result=$(rg -H --color=always --line-number --no-heading --smart-case -g '!node_modules' "${*:-}" | fzf --ansi \
		--color "hl:-1:underline,hl+:-1:underline:reverse" \
		--delimiter : \
		--preview 'bat --color=always {1} --highlight-line {2}' \
		--preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
	
	filename=$(echo $result | cut -d':' -f1)
	line=$(echo $result | cut -d':' -f2)
	nvim "$filename" +"${line}"
}

function fkill(){
	ps -ef | fzf -m | awk '{print $2}' | xargs kill -9
}

function fmv(){
    file=$(fd . ~ -H -t f | fzf -m --preview 'bat --color=always {}')
    dest=$(fd . ~ -H -t d | fzf --preview 'tree -L 1 {}')

    mv -v "$file" "$dest"
}

#end Misc

