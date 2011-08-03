From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: do not allow mounting non-subvolumes via subvol
 option
Date: Wed, 3 Aug 2011 20:12:59 +0200
Message-ID: <20110803181259.GC28122@twin.jikos.cz>
References: <1311934448-887-1-git-send-email-dsterba@suse.cz>
 <4E32E9C0.9000804@libero.it>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E32E9C0.9000804@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2011 at 07:11:28PM +0200, Goffredo Baroncelli wrote:
> >$ btrfs subvol list -p .
> >ID 258 parent 5 top level 5 path subvol
> >ID 259 parent 5 top level 5 path subvol1
> >ID 260 parent 5 top level 5 path default-subvol1
> >ID 262 parent 5 top level 5 path p1/p1-snapshot
> >ID 263 parent 259 top level 5 path subvol1/subvol1-snap
> >
> >The problem I see is that this makes a false impression of snapshotting the
> >given subvolume but in fact snapshots the default one: a user expects outcome
> 
> Not that matter too much, but the old behavior was to snapshot not
> the "default one" but the one which contains the directory.
> This behavior leaded to a lot of misunderstanding about the btrfs
> capability of snapshot subvolume __only__.
> 
> Only one question, what happens now if an user pass subvol=<dir> ?

$ mount /dev/sda5 /mnt/sda5
$ cd sda5
$ mkdir p
$ cd ..
$ umount sda5
$ mount -o subvol=p /dev/sda5 /mnt/sda5
mount: wrong fs type, bad option, bad superblock on /dev/sda5,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

and dmesg says:
[ 7285.905195] device fsid 46e97521-a1c7-4509-954f-b32c90bd1d1e devid 1 transid 10 /dev/sdb5
[ 7285.954435] btrfs: disk space caching is enabled
[ 7286.600155] btrfs: 'p' is not a valid subvolume

There could be a specific error code like ENSUBVOL and mount could be
taught to give better description of what has happened. Otherwise, I took
the approach of being verbose in dmesg.


HTH,
david
