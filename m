From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [RFC] Move all btrfs command to only one command
Date: Thu, 21 Jan 2010 20:29:26 +0100
Message-ID: <201001212029.26681.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WsKWLgT6ixYjt9w"
Cc: David Nicol <davidnicol@gmail.com>, taruishi.hiroak@jp.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_WsKWLgT6ixYjt9w
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all

this RFC is about unify all btrfs command (btrfsctl, btrfs-show, btrfs-tune.. 
) in only one called "btrfs" (or whatever we want).

Today "btrfsctl" needs a "bit" of care because
  * the help is basically wrong [1]
  * the return codes are incoherent [2]
  * the syntax of the command are very ugly (a lot of people complained 
    about the subvolumes/snapshot creation, because they aren't very clear)
    [3]
  * the code is a mess (in the main there is a useless for(); there a lot
    of 'if' because sometime the last argument is the target of ioctl,
    sometime no..) [4]
  * The checks of the number of argument are incorrect [5]

I think that is better to rewrite from scratch a new command instead of 
patching the old one. So we don't care about the backward compatibility.

Other filesystem (hammer, tux3, zfs) have only one command for management 
purpose. Instead we have btrfsctl (which has a lot of different
function) and btrfs-show, btrfs-tune, btrfs-volume which have few functions.

There are patches which address [6] some of the previous issues, 
but these are not integrated (because the developers are busy on other 
issues). To me rewriting from scratch seems a fast path for solving these 
issues.

I made a prototype (see attached file) in bash of what "btrfs" should be. The 
major different from btrfsctl are:
- I talk about clone and not snapshot
- If a sub-volume is required (for example for the cloning), the program check 
that the argument is a root of the subvolume and not a subdirectory
- Creating a sub-volume requires only one argument 

Below some examples:

$ btrfs                         
Usage:                                              
        btrfs clone|-c <source> [<dest>/]<name>     
                Clone the subvolume <source> with the name <name> in the 
<dest>
                directory.                                                     
        btrfs delete|-d <subvolume>                                            
                Delete the subvolume <subvolume>.                              
        btrfs create|-C [<dest>/]<name>
                Create a subvolume in <dest> (or the current directory if not
                passed.
        btrfs defrag|-d <file>|<dir> [<file>|<dir>...]
                Defragment a file or a directory.
        btrfs fssync|-s <path>
                Force a fs sync on the filesystem <path>
        btrfs resize|-r [+/-]<newsize>[gkm]|max <filesystem>
                Resize the file system. If 'max' is passed, the filesystem
                will occupe all available space on the device.
        btrfs scan|-S [<device> [<device>..]
                Scan all device for or the passed device for a btrfs 
filesystem.
        btrfs show|-l <dev>|<label> [<dev>|<label>.. ]
                Show the btrfs devices
        btrfs balance|-b <path>
                Balance teh chunk across the device
        btrfs add|-A <dev> <path>
                Add a device to a filesystem
        btrfs rem|-R <dev> <path>
                Remove a device to a filesystem

        btrfs help|--help|-h
                Show the help.



Comment are welcome




[1] In the help the -r, -c options seem that don't need any further argument; 
The -D command seems that accpet only "." as 2nd parameter....

[2] If something goes wrong btrfsctl returns 1; if the ioctl return 0 the 
command still returns 1...

[3] See the email in the mailing list

[4] If I does
   btrfsctl -c -d -A -S a .
what result do you aspect ?

[5] If I pass more argument than the ones needed no error is showed. -D checks 
if there is only one argument, when it needs two argument...

[6] 
- 10/26/09 - little fixme in btrfsctl.c [PATCH] - From: 
David Nicol <davidnicol@gmail.com>
- 12/24/09 - [PATCH] btrfs-progs: check slash in deleting subvolumes. - From: 
TARUISI 
- 12/13/09 - [PATCH] Improve the btrfsctl help - From: 
Goffredo Baroncelli <kreijack@gmail.com>


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--Boundary-00=_WsKWLgT6ixYjt9w
Content-Type: application/x-shellscript;
  name="btrfs"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="btrfs"

#!/bin/sh


# exit code
# 5	invalid number of argument
# 1	invalid command
# 10	dest dir doesn't exist
# 11	dest object exists already
# 12	source is not a subvolume
# 13	teh argument has to be a block device

error(){
	echo 1>&2 "ERROR: ""$@"
}

warn(){
	echo 1>&2 "WARN: ""$@"
}


help(){

	prgname="$( basename "$1")"
	cat <<EOF
Usage:
	$prgname clone|-c <source> [<dest>/]<name>
		Clone the subvolume <source> with the name <name> in the <dest>
		directory.
	$prgname delete|-d <subvolume>
		Delete the subvolume <subvolume>.
	$prgname create|-C [<dest>/]<name>
		Create a subvolume in <dest> (or the current directory if not
		passed.
	$prgname defrag|-d <file>|<dir> [<file>|<dir>...]
		Defragment a file or a directory.
	$prgname fssync|-s <path>
		Force a fs sync on the filesystem <path>
	$prgname resize|-r [+/-]<newsize>[gkm]|max <filesystem>
		Resize the file system. If 'max' is passed, the filesystem
		will occupe all available space on the device.
	$prgname scan|-S [<device> [<device>..]
		Scan all device for or the passed device for a btrfs filesystem.
	$prgname show|-l <dev>|<label> [<dev>|<label>.. ]
		Show the btrfs devices
	$prgname balance|-b <path>
		Balance teh chunk across the device
	$prgname add|-A <dev> <path>
		Add a device to a filesystem
	$prgname rem|-R <dev> <path>
		Remove a device to a filesystem

	$prgname help|--help|-h
		Show the help.
EOF
}

#
# check if "$0" is a subvolume. The test is perfomed checking if the INODE NO
# is 256
#
test_is_subvolume(){
	[ "256" == "$( ls 2>/dev/null -lid "$1" | cut -f 1 -d ' ')" ]
}

#
# create a subvolume
# do_create_subvol [<dir>/]<name>
#
do_create_subvol(){

	if [ -z "$1" -o -n "$2" ]; then
		error "create requires one argument"
		return 5
	fi

	d="$(dirname "$1")"
	n="$(basename "$1")"

	if [ ! -d "$d" ]; then
		error "The directory '$d' doesn't exist"
		return 10
	fi

	if [  -e "$d/$n" ]; then
		error "'$d/$n' already exists"
		return 11
	fi

	# should we check the return code ?
	btrfsctl -S "$n" "$d"
	[ -d "$d/$n" ]
}

#
# create a clone 
# do_clone <subvolume> <dstdir>[/<name>]
#
do_clone(){

	if [ -z "$2" -o -n "$3" ]; then
		error "clone requires two arguments"
		return 5
	fi

	src="$1"
	dst="$2"

	if ! test_is_subvolume "$src"; then
		error "'$src' is not a subvolume"
		return 12
	fi

	if [ -d "$dst" ]; then
		d="$dst"
		n="$(basename "$src")"
	else
		d="$(dirname "$dst")"
		n="$(basename "$dst")"
	fi

	if [ ! -d "$d" ]; then
		error "The directory '$d' doesn't exist"
		return 10
	fi

	if [  -e "$d/$n" ]; then
		error "'$d/$n' already exists"
		return 11
	fi

	# should we check the return code ?
	btrfsctl -s "$d/$n" "$src"
	[ -d "$d/$n" ]
}

# destroy a subvolume
do_delete(){
	if [ -z "$1" -o -n "$2" ]; then
		error "delete requires one argument"
		return 5
	fi

	src="$1"

	if ! test_is_subvolume "$src"; then
		error "'$src' is not a subvolume"
		return 10
	fi

	d="$(dirname "$src")"
	n="$(basename "$src")"

	# should we check the return code ?
	btrfsctl -D "$n" "$d"
	[ ! -d "$d/$n" ]
}

# defrag a file
# do_defrag <file>
do_defrag(){
	if [ -z "$1" ]; then
		error "defrag requires one or more arguments"
		return 5
	fi

	while [ -n "$1" ]; do
		if [ ! -f "$1" -a ! -d "$1" ]; then
			error "'$1' has to be a file or directory"
			return 10
		fi
		# should we check the return code ?
		btrfsctl -d "$1"
	done
}

# sync a fs
# do_fssync <file>|<dir>
do_fssync(){
	if [ -z "$1" -o -n "$2" ]; then
		error "fssync requires one argument"
		return 5
	fi
	src="$1"
	if [ ! -f "$src" -a -d "$src" ]; then
		error "'$src' has to be a file or directory"
		return 10
	fi
	# should we check the return code ?
	btrfsctl -c "$src"
}

# resize a filesystem
# do_resize <size>|'max' <filesystem>
do_resize(){
	if [ -z "$2" -o -n "$3" ]; then
		error "resize requires two argoments"
		return 5
	fi

	if [ ! -f "$2" -a ! -d "$2" ]; then
		error "'$2' has to be a file or directory"
		return 10
	fi

	# should we check the return code ?
	btrfsctl -r "$1" "$2"
}

# if an argument is passed do_scan scan the block device; otherwise it
# scall all the block device
# do_scan [<block-device> [<block-device>..]
# wishlist
# - scan the block device only
# - bypass the cdrom
# - bypass the floppy
do_scan(){
	if [ -z "$1" ]; then
		btrfsctl -a
		return
	fi

	while [ -n "$1" ]; do
		if [ ! -b "$1" ]; then
			error "'$1' has to be a block device"
			return 13
		fi
		btrfsctl -A "$1"
		shift
	done
}

# show the btrfs devices
# do_show <dev>|<label> [<dev>|<label>..]
do_show(){
	if [ -z "$1" ]; then
		btrfs-show
		return
	fi

	while [ -n "$1" ]; do
		btrfs-show "$1"
	done

}

# balance chunk across the devices
# do_balance <path>
do_balance(){
	if [ -z "$1" -o -n "$2" ]; then
		error "balance requires one argument"
		return 5
	fi
	if [ ! -f "$1" -a ! -d "$1" ]; then
		error "'$1' has to be a file or directory"
		return 10
	fi

	btrfs-vol -b "$1"
}

#add a device from a filesystem
#so_add_device <dev> <path>
do_add_device(){
	if [ -z "$2" -o -n "$3" ]; then
		error "'add' requires two arguments"
		return 5
	fi
	if [ ! -b "$1" ]; then
		error "'$1' has to be a block device"
		return 13
	fi
	if [ ! -f "$2" -a ! -d "$2" ]; then
		error "'$2' has to be a file or directory"
		return 10
	fi

	btrfs-vol -a "$1" "$2"
}

#add a device from a filesystem
#so_rem_device <dev>|'missing' <path>
do_rem_device(){
	if [ -z "$2" -o -n "$3" ]; then
		error "'rem' requires two arguments"
		return 5
	fi
	if [ ! -b "$1" -a "$1" != "missing" ]; then
		error "'$1' has to be a block device"
		return 13
	fi
	if [ ! -f "$2" -a ! -d "$2" ]; then
		error "'$2' has to be a file or directory"
		return 10
	fi
	btrfs-vol -r "$1" "$2"
}


main(){

	if [ -z "$1" ]; then
		help $0
		exit 0
	fi

	case "$1" in
		clone|-c)
			shift
			do_clone "$1" "$2" "$3"
			;;

		create|-C)
			shift
			do_create_subvol "$1" "$2"
			;;

		delete|-d)
			shift
			do_delete "$1" "$2"
			;;

		defrag|-d)
			shift
			do_defrag "$@"
			;;

		fssync|-s)
			shift
			do_fssync "$1" "$2"
			;;

		resize|-r)
			shift
			do_resize "$1" "$2" "$3"
			;;

		scan|-S)
			shift
			do_scan "$@"
			;;

		show|-l)
			shift
			do_show "$@"
			;;

		balance|-b)
			shift
			do_balance "$1" "$2"
			;;

		add|-A)
			shift
			do_add_device "$1" "$2" "$3"
			;;

		rem|-R)
			shift
			do_rem_device "$1" "$2" "$3"
			;;

		help|--help|-h)
			help "$0"
			exit 0
			;;

		*)
			error "Unknow command '"$1"'."
			help "$0"
			exit 1
			;;
	esac

}

main "$@"


--Boundary-00=_WsKWLgT6ixYjt9w--
