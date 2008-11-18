From: Chris Mason <chris.mason@oracle.com>
Subject: New disk format pushed out to btrfs-unstable
Date: Tue, 18 Nov 2008 12:27:46 -0500
Message-ID: <1227029266.787.13.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The btrfs unstable git trees now have a new disk format.  The changes
include:

* Yan Zheng's seed filesystem support.  This allows you to create a
readonly image and have all writes directed to other devices

* Subvolumes and snapshots can now live anywhere in the directory tree.

The awkward 'default' subvolume is gone, and the tree of tree roots is
no longer visible when you mount -o subvol=., which is now the same as
mounting without any options.

New subvolumes can be linked anywhere in the tree, btrfsctl -S creates
subvols now, and btrfsctl -s creates snapshots.

btrfsctl -S subvol_name subvol_location

btrfsctl -s snapshot_location subvol_to_snapshot

Snapshot creation is not recursive, so for example:

mkfs.btrfs /dev/sdb
mount /dev/sdb /mnt
btrfsctl -S vol1 /mnt
btrfsctl -S vol2 /mnt/vol1
touch /mnt/vol1/vol2/some_file

Now we have two subvolumes, and some_file exists inside of vol2.

btrfsctl -s /mnt/snap /mnt/vol1

Now we have a snapshot of vol1 named /mnt/snap.  If we do a find
under /mnt/snap:

# find /mnt/snap
/mnt/snap
/mnt/snap/vol2
/mnt/snap/vol2/some_file

We see some_file under vol2.  Since vol2 is a different subvolume, and
vol1 just has a pointer to that subvolume, both snap and vol1 point to
the latest vol2.

# rm /mnt/snap/vol2/some_file

# find /mnt/vol1
/mnt/vol1
/mnt/vol1/vol2

some_file disappears.  The disk format has extra indexing so that
snapshots can be done recursively in an efficient manner, but the
current code does not implement that.

Those indexes are used by the current code to try and prevent directory
loops when snapshots are created.  For example it would refuse to create
a snapshot of /mnt under /mnt/vol1.

I'll talk with Christoph about auto bind mounting subvols and snapshots
into the directory tree instead of the current code.  But, this is a
good start and it should have enough disk format indexing to be flexible
over the long term.

-chris


