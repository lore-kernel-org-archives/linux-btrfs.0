From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Broken DIR_ITEMs on snapshot
Date: Wed, 19 Oct 2011 08:57:28 -0400
Message-ID: <1319028945-sup-1547@shiny>
References: <4E9DA2C7.90309@jan-o-sch.net> <20111018185134.GA31908@zambezi.lan> <4E9EA3B8.2020000@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Cc: Ilya Dryomov <idryomov@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E9EA3B8.2020000@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Jan Schmidt's message of 2011-10-19 06:17:28 -0400:
> On 18.10.2011 20:51, Ilya Dryomov wrote:
> > On Tue, Oct 18, 2011 at 06:01:11PM +0200, Jan Schmidt wrote:
> >> Hi,
> >>
> >> while still busy with btrfs send, I came across some strange DIR_ITEMs.
> >> I looked into that briefly, but I'd rather return to implementing btrfs
> >> send, hoping someone is willing to make up his mind on this one :-)
> >>
> >> To reproduce, do the following:
> >>
> >> # mkfs.btrfs /dev/sdv2
> >> # mount /dev/sdv2 /mnt
> >> # btrfs subvol snap /mnt /mnt/snap1
> >>
> >> You've a freshly created snapshot. However, file tree 256 (the
> >> snap1-tree) will contain two strange items:
> >>
> >>         item 2 key (256 DIR_ITEM 3645318598) itemoff 3788 itemsize 35
> >>                 location key (256 ROOT_ITEM 18446744073709551615) type 2
> >>                 namelen 5 datalen 0 name: snap1
> >>         item 3 key (256 DIR_INDEX 2) itemoff 3753 itemsize 35
> >>                 location key (256 ROOT_ITEM 18446744073709551615) type 2
> >>                 namelen 5 datalen 0 name: snap1
> >>
> >> These items are needed in tree 5 (fs tree) to reference snap1. However,
> >> within snap1, I'd not expect the entries. A brief look into
> >> create_pending_snapshot reveals
> >>
> >>    ...
> >>    btrfs_insert_dir_item()
> >>    ...
> >>    /* some delayed stuff with scary comments */
> >>    ...
> >>    btrfs_cow_block()
> >>    ...
> >>
> >> I'm not sure whether cowing earlier would help, I'm particularly
> >> uncertain because of the run_delayed_* code in between. So I haven't
> >> tried to fix this, I'm convinced it should be fixed, though.
> > 
> > I don't think it's a bug.  Directory item snap1 (the access point) is
> > inserted into /mnt (defaut subvolume) and THEN a snapshot is taken.  So
> > snap1 fs-tree contains that directory item, which in Btrfs terms means
> > DIR_ITEM and DIR_INDEX items in the fs-tree.
> >  
> >> These items lead to some strange effects:
> >>
> >> # cd /mnt/snap1
> >> # ls -l
> >> dr-xr-xr-x 1 root root 10 Jan  1  1970 .
> >> dr-xr-xr-x 1 root root 16 Oct 18 15:56 ..
> >> # mkdir snap1
> >> mkdir: cannot create directory `snap1': File exists
> >> # stat snap1
> >>   File: `snap1'
> >>   Size: 0               Blocks: 0          IO Block: 4096   directory
> >> Device: 11h/17d Inode: 2           Links: 1
> >> # rmdir snap1
> >> # stat snap1
> >> stat: cannot stat `snap1': No such file or directory
> >>
> >> Inode number 2 seems to be BTRFS_EMPTY_SUBVOL_DIR_OBJECTID, the pseudo
> >> object is created by btrfs_lookup_dentry() in inode.c when ENOENT is
> >> encountered.
> > 
> > Because from the user's point of view that snap1 item shouldn't be
> > there, readdir() skips it and consequently ls doesn't show it.  However
> > when you stat() it you force a lookup on it and end up with a special
> > inode which is there to ensure there is only one valid access point to a
> > particular subvolume.
> 
> You are describing the obvious. The only point I want to insist on is
> that this is a bug.
> 
> Either we must give the full namespace to the user, or we must make it
> obvious that the name of the snapshot is taken within the snapshot in
> this case (e.g. by creating an INODE_ITEM).
> 
> Chris: Or do you really absolutely want to have it like this?

This is a general problem, each subvolume/snapshot can only be reached
from its one true parent.  So if you have a directory tree of subvols
and snapshots, you have to go in and snapshot them recursively if you
want a snapshot of the root to also contain snapshots of all the inner
subvols.

-chris
