Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38708 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaCUR3G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 13:29:06 -0400
Date: Fri, 21 Mar 2014 10:29:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Send/Receive howto and script for others to use (was Re: Is anyone using btrfs send/receive)
Message-ID: <20140321172904.GE28005@merlins.org>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20140107104951.GL10936@merlins.org> <20140107105329.GE15634@carfax.org.uk> <20140108080206.GV10936@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140108080206.GV10936@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 08, 2014 at 12:02:06AM -0800, Marc MERLIN wrote:
> On Tue, Jan 07, 2014 at 10:53:29AM +0000, Hugo Mills wrote:
> >    You need to move /mnt/btrfs_pool2/tmp_read_only_new to a different
> > name as well. The send stream contains the name of the subvolume it
> > wants to create, so it's trying to create a subvolume called
> > "tmp_read_only_new" in /mnt/btrfs_pool2, and there's one there already.
> 
> Aaah, got it, thanks.
> 
> I'll contribute back a shell script that makes this much easier when I'm
> done with it.

I've now spent enough time on this and have enough testing to release it.

http://marc.merlins.org/perso/btrfs/post_2014-03-22_Btrfs-Tips_-Doing-Fast-Incremental-Backups-With-Btrfs-Send-and-Receive.html
which points to
http://marc.merlins.org/linux/scripts/btrfs-subvolume-backup


Just for the archives, here is a working copy (the blog post above explains
why it keeps multiple snapshots after the fact, and creates writeable ones
on the destination, but basically this allows you to automatically boot from
the latest snapshot (a writeable snapshot copy pointed to by a symlink tha
tis kept up to date)):
----------------------------------------------------------------------------
#!/bin/bash

# By Marc MERLIN <marc_soft@merlins.org>
# License: GPL-2 or BSD at your choice.

# Source: http://marc.merlins.org/linux/scripts/
# $Id: btrfs-subvolume-backup 958 2014-03-16 00:23:28Z svnuser $

# cron jobs might not have /sbin in their path.
export PATH="$PATH:/sbin"

set -o nounset
set -o errexit
set -o pipefail

# From https://btrfs.wiki.kernel.org/index.php/Incremental_Backup


# bash shortcut for `basename $0`
PROG=${0##*/}
lock=/var/run/$PROG

usage() {
    cat <<EOF
Usage: 
cd /mnt/source_btrfs_pool
$PROG [--init] [--keep|-k num] [--dest hostname] volume_name /mnt/backup_btrfs_pool

Options:
    --init:          Print this help message and exit.
    --keep num:      Keep the last snapshots for local backups (5 by default)
    --dest hostname: If present, ssh to that machine to make the copy.

This will snapshot volume_name in a btrfs pool, and send the diff
between it and the previous snapshot (volume_name.last) to another btrfs
pool (on other drives)

If your backup destination is another machine, you'll need to add a few
ssh commands this script

The num sanpshots to keep is to give snapshots you can recover data from 
and they get deleted after num runs. Set to 0 to disable (one snapshot will
be kept since it's required for the next diff to be computed).
EOF
    exit 0
}

die () {
    msg=${1:-}
    # don't loop on ERR
    trap '' ERR

    rm $lock

    echo "$msg" >&2
    echo >&2

    # This is a fancy shell core dumper
    if echo $msg | grep -q 'Error line .* with status'; then
	line=`echo $msg | sed 's/.*Error line \(.*\) with status.*/\1/'`
	echo " DIE: Code dump:" >&2
	nl -ba $0 | grep -3 "\b$line\b" >&2
    fi
    
    exit 1
}

# Trap errors for logging before we die (so that they can be picked up
# by the log checker)
trap 'die "Error line $LINENO with status $?"' ERR


init=""
# Keep the last 5 snapshots by default
keep=5
TEMP=$(getopt --longoptions help,usage,init,keep:,dest: -o h,k:,d: -- "$@") || usage
dest=localhost
ssh=""

# getopt quotes arguments with ' We use eval to get rid of that
eval set -- $TEMP

while :
do
    case "$1" in
        -h|--help|--usage)
            usage
            shift
            ;;

	--keep|-k)
	    shift
	    keep=$1
	    shift
	    ;;

	--dest|-d)
	    shift
	    dest=$1
	    ssh="ssh $dest"
	    shift
	    ;;

	--init)
	    init=1
	    shift
	    ;;

	--)
	    shift
	    break
	    ;;

        *) 
	    echo "Internal error!"
	    exit 1
	    ;;
    esac
done
[[ $keep < 1 ]] && die "Must keep at least one snapshot for things to work ($keep given)"

DATE="$(date '+%Y%m%d_%H:%M:%S')"

[[ $# != 2 ]] && usage
vol="$1"
dest_pool="$2"

# shlock (from inn) does the right thing and grabs a lock for a dead process
# (it checks the PID in the lock file and if it's not there, it
# updates the PID with the value given to -p)
if ! shlock -p $$ -f $lock; then
    echo "$lock held for $PROG, quitting" >&2
    exit
fi

if [[ -z "$init" ]]; then
    test -e "${vol}_last" \
	|| die "Cannot sync $vol, ${vol}_last missing. Try --init?"
    src_snap="$(readlink -e ${vol}_last)"
fi
src_newsnap="${vol}_ro.$DATE"
src_newsnaprw="${vol}_rw.$DATE"

$ssh test -d "$dest_pool/" || die "ABORT: $dest_pool not a directory (on $dest)"

btrfs subvolume snapshot -r "$vol" "$src_newsnap"

# There is currently an issue that the snapshots to be used with "btrfs send"
# must be physically on the disk, or you may receive a "stale NFS file handle"
# error. This is accomplished by "sync" after the snapshot
sync

if [[ -n "$init" ]]; then
    btrfs send "$src_newsnap" | $ssh btrfs receive "$dest_pool/"
else
    btrfs send -p "$src_snap" "$src_newsnap" | $ssh btrfs receive "$dest_pool/"
fi

# We make a read-write snapshot in case you want to use it for a chroot
# and some testing with a writeable filesystem or want to boot from a
# last good known snapshot.
btrfs subvolume snapshot "$src_newsnap" "$src_newsnaprw"
$ssh btrfs subvolume snapshot "$dest_pool/$src_newsnap" "$dest_pool/$src_newsnaprw"

# Keep track of the last snapshot to send a diff against.
ln -snf $src_newsnap ${vol}_last
# The rw version can be used for mounting with subvol=vol_last_rw
ln -snf $src_newsnaprw ${vol}_last_rw
$ssh ln -snf $src_newsnaprw $dest_pool/${vol}_last_rw

# How many snapshots to keep on the source btrfs pool (both read
# only and read-write).
ls -rd ${vol}_ro* | tail -n +$(( $keep + 1 ))| while read snap
do
    btrfs subvolume delete "$snap"
done
ls -rd ${vol}_rw* | tail -n +$(( $keep + 1 ))| while read snap
do
    btrfs subvolume delete "$snap"
done

# Same thing for destination (assume the same number of snapshots to keep,
# you can change this if you really want).
$ssh ls -rd $dest_pool/${vol}_ro* | tail -n +$(( $keep + 1 ))| while read snap
do
    $ssh btrfs subvolume delete "$snap"
done
$ssh ls -rd $dest_pool/${vol}_rw* | tail -n +$(( $keep + 1 ))| while read snap
do
    $ssh btrfs subvolume delete "$snap"
done

rm $lock
----------------------------------------------------------------------------
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
