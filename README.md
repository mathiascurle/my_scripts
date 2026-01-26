# Practical shell scripts

Add this to shell config (.zshrc):


```
for file in ~/.my_scripts/*.sh; do
	source "$file"
done
```
