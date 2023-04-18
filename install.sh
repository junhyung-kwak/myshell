target_dir=$HOME/.config/myshell/

echo "cp to $target_dir"
mkdir -p $target_dir
cp -r ./* $target_dir/



echo "export MYENV=$HOME/.config/myshell" >> $HOME/.bashrc
echo "export BASH_INCLUDE=$HOME/.config/myshell/func/include.func" >> $HOME/.bashrc
echo "source $MYENV/bashrc" >> $HOME/.bashrc
