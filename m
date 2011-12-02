From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: btrfsck: unresolved ref root
Date: Fri, 02 Dec 2011 10:28:05 +0100
Message-ID: <4ED89A25.4000207@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While hunting another bug, I got distracted by btrfsck error output,
which is reproducible as simple as creating a snapshot. Either btrfsck
is strange or subvolume snapsnot does something wrong.

# mkfs.btrfs /dev/sdo
# mount /dev/sdo /mnt/scratch/
# umount /mnt/scratch/
# btrfsck /dev/sdo

-> everything ok

# mount /dev/sdo /mnt/scratch/
# btrfs subvol snap /mnt/scratch/ /mnt/scratch/snap1
# umount /mnt/scratch
# btrfsck /dev/sdo
fs tree 257 refs 2
        unresolved ref root 257 dir 256 index 2 namelen 5 name snap1
error 600
[...]

Tested with current for-linus and most current btrfsck. I also have
older filesystems with snapshots I never used on btrfsck before, they
also show the "unresolved ref" error.

>From a quick look at the btrfsck code, this complaint means that btrfsck
is looking for two BTRFS_ROOT_REF_KEY and BTRFS_ROOT_BACKREF_KEY each in
the tree of tree roots. However there's only one of each (as I would
expect):

        item 4 key (FS_TREE ROOT_REF 257) itemoff 3238 itemsize 23
                root ref key dirid 256 sequence 2 name snap1
...
        item 12 key (257 ROOT_BACKREF 5) itemoff 2315 itemsize 23
                root backref key dirid 256 sequence 2 name snap1

-Jan
