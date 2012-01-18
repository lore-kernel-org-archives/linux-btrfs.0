From: David Sterba <dave@jikos.cz>
Subject: Re: fstab mount options ignored on subsequent subvolume mounts
Date: Wed, 18 Jan 2012 13:15:38 +0100
Message-ID: <20120118121538.GH7322@twin.jikos.cz>
References: <COL113-W4695DE73CE3FDD13C0E8BBB0800@phx.gbl>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Kyle Gates <kylegates@hotmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <COL113-W4695DE73CE3FDD13C0E8BBB0800@phx.gbl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2012 at 01:09:36PM -0600, Kyle Gates wrote:
> I have multiple subvolumes on the same filesystem that are mounted with different options in fstab.
> The problem is the mount options for subsequent subvolume mounts seem to be ignored as reflected in /proc/mounts.

The output of 'mount' and /proc/mounts is different. mount takes it from
/etc/mtab while /proc/mounts gets the information from kernel (calls
into super.c:btrfs_show_options() )

'mtab':
- contains the options in order in which they were given to mount or in
  /etc/fstab
- 

/proc/mounts:
- order of options is fixed (as defined in the function)
- if the option has a default value which was not given to mount, it is
  listed here (and is not in mtab)
- an implied options appear here as well (like nodatacow implies
  nodatasum)


Now, you're giving different set of options to each subvolume, but they
belong to one filesystem and thus will result in set of options given to
the first mounted subvolume for every other mounted subvolume.

The first subvol calls 'btrfs_fill_super' and 'btrfs_parse_options', the
other do not and do not. Remount will call 'btrfs_parse_options' again
and will change the options set.

> $ cat /etc/fstab | grep mnt
> UUID=<REMOVED> /mnt/a btrfs subvol=a,defaults,nodatacow,autodefrag,noatime,space_cache,inode_cache 0 0
> UUID=<REMOVED> /mnt/b btrfs subvol=b,defaults,autodefrag,noatime,space_cache,inode_cache 0 0
> UUID=<REMOVED> /mnt/c btrfs subvol=c,defaults,compress=zlib,autodefrag,noatime,space_cache,inode_cache 0 0
>
> $ mount | grep mnt
> /dev/sdb2 on /mnt/a type btrfs (rw,noatime,subvol=a,nodatacow,autodefrag,space_cache,inode_cache)
> /dev/sdb2 on /mnt/b type btrfs (rw,noatime,subvol=b,autodefrag,space_cache,inode_cache)
> /dev/sdb2 on /mnt/c type btrfs (rw,noatime,subvol=c,compress=zlib,autodefrag,space_cache,inode_cache)
> $ cat /proc/mounts | grep mnt
> /dev/sdb2 /mnt/a btrfs rw,noatime,nodatasum,nodatacow,space_cache,autodefrag,inode_cache 0 0
> /dev/sdb2 /mnt/b btrfs rw,noatime,nodatasum,nodatacow,space_cache,autodefrag,inode_cache 0 0
> /dev/sdb2 /mnt/c btrfs rw,noatime,nodatasum,nodatacow,space_cache,autodefrag,inode_cache 0 0
> 
> continuing the example which should only change the mount options for one of the subvolumes:
> $ sudo mount -o remount,compress=zlib /mnt/oldhome
> $ cat /proc/mounts | grep mnt
> /dev/sdb2 /mnt/a btrfs rw,noatime,nodatasum,nodatacow,compress=zlib,space_cache,autodefrag,inode_cache 0 0
> /dev/sdb2 /mnt/b btrfs rw,noatime,nodatasum,nodatacow,compress=zlib,space_cache,autodefrag,inode_cache 0 0
> /dev/sdb2 /mnt/c btrfs rw,noatime,nodatasum,nodatacow,compress=zlib,space_cache,autodefrag,inode_cache 0 0

I think the above explains things in general in your listings, the last
one missing is subvol= in /proc/mounts. This is not implemented, but is
possible (save non-default subvol name with the subvol root and print in
show_options).


david
