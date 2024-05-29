# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# customize function
f() {
    find . | grep "$1"
}

bf200source() {
	DISTRO=minimal-console MACHINE=bf200  source sd_setup.sh -b build-bf200
}

mkdts() {
	#cd /workspace/shang.cui/work/buildsystem/android/out/target/product/$TARGET_PRODUCT/obj/KERNEL_OBJ/
	#make dtbs ARCH=arm64 CROSS_COMPILE=aarch64-linux-android-
	#cd -
    make dtb_ap1_android12
    make ap1_android12 --eval=ANDROID_CMD=vendorbootimage
}

bitkernel() {
	bitbake virtual/kernel
}

yocto_env_set() {
	MACHINE=v9f_ref source sd_setup.sh -b build-v9f
}

yocto_build_all() {
	bitbake virtual/kernel && bitbake safety && bitbake lk && bitbake baremetal && bitbake core-image-base
}

mkimage() {
	make -j128 bootimage
}

bsmkall() {
	make inittools && make sync_all && make build_all && make genpac
}

lndisp() {
	ln -s /workspace/shang.cui/work/disp_source_code/disp/lk_customize/chipdev/disp/ disp
	ln -s /workspace/shang.cui/work/disp_source_code/disp/lk_customize/chipdev/g2dlite/ g2dlite
}

d9_env() {
	DISTRO=industry    MACHINE=d9_ref  source sd_setup.sh -b build-d9_ref
}


andlunch() {
	source build/envsetup.sh
	lunch
}

mkctags() {
	ctags --languages=Asm,c,c++,java -R
}

ysource() {
	DISTRO=cluster-qt MACHINE=x9h_ms  source sd_setup.sh -b build-x9h_ms
}

dsource() {
	DISTRO=industry MACHINE=d9_ref source sd_setup.sh -b build-d9_ref
}

g2d_link_build() {
	cd ./drivers/char/sdrv_g2d/g2d_semidrive_linked
	source link_build.sh
	cd -
}

yenv() {
	export KDIR=$BUILDDIR/tmp/work/x9h_ms-sdrv-linux/linux-semidrive-dev/4.14.61-r1/linux-x9h_ms-standard-build
	export CROSS_COMPILE=$BUILDDIR/tmp/work/x9h_ms-sdrv-linux/linux-semidrive-dev/4.14.61-r1/recipe-sysroot-native/usr/bin/aarch64-sdrv-linux/aarch64-sdrv-linux-
	make -j32 yocto
}

ck_diff() {
		git diff | ./scripts/checkpatch.pl -
}

to() {
    local dest=$1
    local sub=$2

    case "$1" in
        "wk")
            dest=/workspace/shang.cui/work ;;
        "4.6")
            dest=/workspace/shang.cui/work/PTG4.6/buildsystem/ ;;
        "4.5")
            dest=/workspace/shang.cui/work/PTG4.5/buildsystem/ ;;
		"4.3")
			dest=/workspace/shang.cui/work/customer_c/PTG4.3/buildsystem/ ;;
		"4.0")
			dest=/workspace/shang.cui/work/customer_c/PTG4.0/buildsystem/ ;;
		"bs")
			dest=/workspace/shang.cui/work/buildsystem/ ;;
		"kout")
			dest=/workspace/shang.cui/work/buildsystem/android/out/target/product/$TARGET_PRODUCT/obj/KERNEL_OBJ/ ;;
		"bdtb")
			dest=/workspace/shang.cui/work/buildsystem/android/out/target/product/$TARGET_PRODUCT/obj/KERNEL_OBJ/ ;;
		"and")
			dest=/workspace/shang.cui/work/buildsystem/android/ ;;
		"hwc")
			dest=/workspace/shang.cui/work/buildsystem/android/vendor/semidrive/interfaces/q_hwcomposer/ ;;
		"kernel")
			dest=/workspace/shang.cui/work/buildsystem/android/kernel ;;
		"d9")
			dest=/workspace/shang.cui/work/d9_master/ ;;
		"sdrv")
			dest=/workspace/shang.cui/work/buildsystem/android/kernel/drivers/gpu/drm/sdrv/ ;;
		"bf200")
			dest=/workspace/shang.cui/work/X9_3.0.0_PTG3.8_BF200/source/lk_safety ;;
		"ssdk")
			dest=/workspace/shang.cui/work/E3/ssdk/


    esac

    if [ -e "$dest$sub" ]; then
        cd "$dest$sub"
    elif [ -e "$dest" ]; then
        cd "$dest"
    else
        echo "path does not exit $dest $sub"
    fi
}

cfile() {
		#!/bin/sh
# generate tag file for lookupfile plugin
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > filenametags
find -L . -not -regex '.*\.\(png\|gif\)' -type f -printf "%f\t%p\t1\n" | \
    sort -f >> filenametags
}

csmake() {
	find -L . -name "*.h" -o -name "*.c" -o -name "*.cc" > cscope.files
	cscope -bkq -i cscope.files

}

prjmk() {
	csmake
	cfile
	ctags -R *
}

rel_git() {
	cd /workspace/shang.cui/work/customer_c/sd-key-c/
	chmod 0400 ./id_rsa*
	eval `ssh-agent`
	ssh-add id_rsa
	cd -
}

export PATH=/home/shang.cui/bin:$PATH
ulimit -HS unlimited
ulimit -n 1000000
ulimit -c 0
ulimit -s unlimited
ulimit -v unlimited
