From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs subvol find-new
Date: Fri, 26 Mar 2010 09:22:19 -0400
Message-ID: <20100326132219.GF16453@think>
References: <20100326111807.24dcc2f0@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Michael Niederle <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100326111807.24dcc2f0@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 26, 2010 at 11:18:07AM +0100, Michael Niederle wrote:
> I want to write a differential backup tool for btrfs snapshots.
> 
> The new "btrfs subvol find-new"-command sounds great on first encounter, but I'm
> missing informations about updated directories. I would need a list of updated
> directories to scan for deleted files.
> 
> I had a look at find_updated_files() in btrfs-list.c. To me it seems as if
> the ioctl would only return the extents of regular files.

Well, the ioctl is actually returning all the updated inodes, but the
command ignores them.

Every piece of metadata in the btrfs btree has a key, and every key has
a type field.  It's the type field that makes keys for inodes different
from keys for file extents or directory items.

In find_udpated_files, it does this:

        sk->min_type = 0;
        sk->max_type = BTRFS_EXTENT_DATA_KEY;

This means the search ioctl in the kernel won't return anything with a
key bigger than BTRFS_EXTENT_DATA_KEY.  If you look in ctree.h, you'll
see that BTRFS_EXTENT_DATA_KEY is actually bigger than inodes and
directory items, so we're getting most of the file and directory
metadata with this search.

In the loop in find_updates_files, it does this:
	if (sh->type == BTRFS_EXTENT_DATA_KEY &&

Which limits the output to only extent data keys.

> 
> The function find_root_gen() in btrfs-list.c seems to return the newest
> generation in a given snapshot. It would be nice to have this exported as a
> user command (e.g. "btrfs subvol newest-gen") then one could use the output of 
> 
> btrfs subvol newest-gen <old snapshot>

That was definitely the plan.  If you're interested in coding this,
please remember that you have to record the generation before you start
to backup, so that you catch everything that changed during the backup
next time around.

When we find an inode in the output, it doesn't mean that inode has
changed.  It just means the btree block holding that inode has changed.
So we'll want to add limiting based on the ctime/mtime of the inode as
well.

Inodes have type BTRFS_INODE_ITEM_KEY, the same inode format is used for
both files and directories.  Inside a directory we have the files listed
twice, once under items of type BTRFS_DIR_ITEM_KEY, and once under items
of type BTRFS_DIR_INDEX_KEY.  The duplicate index helps with NFS and
helps us do sequential directory reads.

You'll want to pick the BTRFS_DIR_INDEX_KEY because they are in a better
order for backing up.

> 
> (plus 1) as the input generation number to
> 
> btrfs subvol find-new <new snapshot> <gen+1>
> 

To be on the safe side (not miss any updates) we want to use gen, not
gen+1.  We'll get some duplicates, but it is the only way to be sure we
don't miss anything.

-chris

