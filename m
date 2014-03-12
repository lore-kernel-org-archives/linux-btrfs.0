Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:54228 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaCLWRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 18:17:16 -0400
Message-ID: <5320DD21.1040007@libero.it>
Date: Wed, 12 Mar 2014 23:18:09 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de> <531E3F10.3000908@libero.it> <20140310234547.GA31229@tango.0pointer.de> <53209868.5090506@fb.com> <5320B18C.9050400@inwind.it>
In-Reply-To: <5320B18C.9050400@inwind.it>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/12/2014 08:12 PM, Goffredo Baroncelli wrote:
[...]
> I am working to prototype something like that. A "mount.btrfs" command which
> 1) handles the rollback (i.e. the user make a snapshot which is a rollback; if something goes wrong and the machine reboot before ending the process, during the subvolume mounting phase the rollback replaces the "original" subvolume)
> 
> 2) handles the automount (i.e. if a subvolume has the right xattr it is automatically mounted in the right place)
> 
> My idea is that the subvolume are grouped so:
> 
> @<name>				simple subvolume
> @<name>.<timestamp>		snapshot of subvolume <name>
> @<name>.rollback		rollback subvolume
> 
> If @<name>.rollback exists, then it replace @<name> (something went wrong, the machine rebooted so the rollback have to take place of the original subvolume)
> 
> For each @<name> subvolume the following xattrs are considered:
> user.btrfs.automount=1|0	the subvolume has to be automounted
> user.btrfs.mountpoint=<path>	subvolume mount point
> 
> 
> So this "mount.btrfs" command should:
> 
> 1) mount the root btrfs filesystem (subvolid=5) in a temporary directory
> 2) performing the auto rollback (this behaviour can be controlled by another xattr)
> 3) mount the subvolume "@" as "root" (like the default one) in the right mount point
> 4) for each subvolume which has user.btrfs.automount=1, it should be mounted under the path stored in the "user.btrfs.mntpoint" xattr (relative to "@" or absolute)
> 5) umount the btrfs filesystem mounted at #1, or better move it to a new position in order
> to allow managing (snapshot) of the different subvolumes.
> 


Below my POC.

$ sudo mount /dev/loop0 t
$ sudo getfattr -d t/{@*,.}
# file: t/@
user.btrfs.automount="1"

# file: t/@__boot__
user.btrfs.automount="1"
user.btrfs.mountpoint="/boot"

# file: t/@.broken-0
user.btrfs.automount="1"

# file: t/@.broken-1
user.btrfs.automount="1"

# file: t/@__home__
user.btrfs.automount="1"
user.btrfs.mountpoint="/home"

# file: t/@__root__.12345
user.btrfs.automount="0"

# file: t/@space space
user.btrfs.automount="0"

# file: t/@__srv__
user.btrfs.automount="0"

# file: t/.
user.btrfs.automount="1"
user.btrfs.autorollback="1"
user.btrfs.mountpoint="/var/btrfs"

$ sudo umount t


$ sudo sh mount.btrfs /dev/loop0 t
Mount /dev/loop0/@ ->  t
Mount /dev/loop0/@__boot__ ->  t//boot
Mount /dev/loop0/@__home__ ->  t//home
Mount /dev/loop0 -> t//var/btrfs
ghigo@venice:~/btrfs/mount-btrfs$ find t
t
t/var
t/var/btrfs
t/var/btrfs/@__boot__
t/var/btrfs/@__home__
t/var/btrfs/@__srv__
t/var/btrfs/@__root__.12345
t/var/btrfs/@space space
t/var/btrfs/@.broken-0
t/var/btrfs/@.broken-0/var
t/var/btrfs/@.broken-0/var/btrfs
t/var/btrfs/@.broken-0/@__boot__
t/var/btrfs/@.broken-0/@__home__
t/var/btrfs/@.broken-0/boot
t/var/btrfs/@.broken-0/home
t/var/btrfs/@.broken-0/non-rollback-subvol
t/var/btrfs/@.broken-1
t/var/btrfs/@.broken-1/var
t/var/btrfs/@.broken-1/var/btrfs
t/var/btrfs/@.broken-1/@__boot__
t/var/btrfs/@.broken-1/@__home__
t/var/btrfs/@.broken-1/boot
t/var/btrfs/@.broken-1/home
t/var/btrfs/@.broken-1/rollback-subvol
find: File system loop detected; ‘t/var/btrfs/@’ is part of the same file system loop as ‘t’.
t/@__boot__
t/@__home__
t/boot
t/home
t/non-rollback-subvol





$cat mount.btrfs
#!/bin/sh

XAAMOUNT="user.btrfs.automount"
XAAMNTPNT="user.btrfs.mountpoint"
XAAROLLBACK="user.btrfs.autorollback"

xdebug() {
    [ -z "$DEBUG" ] && return
    echo "$@"
}

autorollback() {

    ( cd "$tmpdir"; ls -d @*.rollback 2>/dev/null) | while read drb; do
    
        rbfullpath="$tmpdir/$drb"
        [ ! -d "$rbfullpath" ] && continue
        is_btrfs_subvol "$rbfullpath" || continue
        
        f="$(get_fattr $XAAROLLBACK "$rbfullpath" )"
        [ "x$f" = "x0" ] && continue

        d="$(echo $drb | sed -e "s/.rollback$//")"
        fullpath="$tmpdir/$d"
        
        if [ -d "$fullpath" ]; then
            f="$(get_fattr $XAAROLLBACK "$fullpath" )"
            [ "x$f" = "x0" ] && continue
            
            i=0
            while true; do
                newfullpath="$fullpath.broken-$i"
                if [ ! -e  "$newfullpath" ]; then
                    mv "$fullpath" "$newfullpath"
                    break
                fi
                i=$(($i+1))
            done
        fi
        
        echo "Rollback $d"
        mv "$rbfullpath" "$fullpath"

    done
    
}

is_btrfs_subvol() {
    [ "$(stat -c "%i" "$1")" -eq "256" ]
}

get_fattr() {

    name="$1"
    file="$2"

    getfattr --only-values -n "$name" "$file" 2>/dev/null || echo -n ""

}

automount() {
    tmpdir="$1"
    srcdev="$2"
    mntpnt="$3"

    fullpath="$tmpdir/@"
    [ ! -d "$fullpath" ] && return 1

    is_btrfs_subvol "$fullpath" || return 1
    b="$(get_fattr $XAAMOUNT "$fullpath" )"
    [ "x$b" = "x0" ] && return 1
    
    path="$(get_fattr $XAAMNTPNT "$fullpath" )"
    if [ -n "$path" ] ; then
        mntpnt="$path"
    fi
    xdebug mount -o "subvol=@" "$srcdev" "$mntpnt/"
    echo "Mount $srcdev/@ ->  $mntpnt"
    mount -o "subvol=@" "$srcdev" "$mntpnt/" || return 1
    

    ( cd "$tmpdir"; ls -d @*  2>/dev/null) |  grep -v "\." | while read d; do
    
        [ "x$d" = "x./@" ] && continue
        
        fullpath="$tmpdir/$d"
        [ ! -d "$fullpath" ] && continue
        
        is_btrfs_subvol "$fullpath" || continue
        
        path="$(get_fattr $XAAMNTPNT "$fullpath" )"
        [ -z "$path" ] && continue
        
        b="$(get_fattr $XAAMOUNT "$fullpath" )"
        [ "x$b" = "x0" ] && continue
        
        echo "Mount $srcdev/$d ->  $mntpnt/$path"
        xdebug mount -o "subvol=$d" "$srcdev" "$mntpnt/$path"
        mkdir -p "$mntpnt/$path"
        mount -o "subvol=$d" "$srcdev" "$mntpnt/$path"

    done
    
    return 0

}

main() {
    #create tempdir
    tmpdir=$(mktemp --directory)

    srcdev="$1"
    mntpnt="$2"

    xdebug mount -t btrfs "$srcdev" "$tmpdir" 
    mount -o subvolid=5 -t btrfs "$srcdev" "$tmpdir" || exit

    # get the global value
    GLOBALAMOUNT=$(get_fattr $XAAMOUNT "$tmpdir/.")
    GLOBALAROLLBACK=$(get_fattr $XAAROLLBACK "$tmpdir/.")
    BTRFSROOT="$(get_fattr $XAAMNTPNT "$tmpdir/." )"
    xdebug "GLOBALAMOUNT=$GLOBALAMOUNT, GLOBALAROLLBACK=$GLOBALAROLLBACK"

    if [ "x$GLOBALAROLLBACK" = "x1" ]; then
        autorollback "$tmpdir"
    fi

    if [ "x$GLOBALAMOUNT" = "x1" ]; then
        if ! automount "$tmpdir" "$srcdev" "$mntpnt"; then
            echo 1>&2 "ERROR: unable to mount the filesystem"
            exit 10
        fi

        umount "$tmpdir"
        if [ -n "$BTRFSROOT" ]; then
            mkdir -p "$mntpnt/$BTRFSROOT"
            echo "Mount $srcdev -> $mntpnt/$BTRFSROOT"
            mount -o subvolid=5 "$srcdev" "$mntpnt/$BTRFSROOT"
        fi

    else
        mount --move "$tmpdir" "$mntpnt"
    fi

}

#FIXME: allow options
if [ $# -ne 2 ]; then
    echo "usage: $0 <srcdev> <mount-point>"
    exit 1
fi
main "$@"


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
