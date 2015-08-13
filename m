Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbHMXNK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 19:13:10 -0400
Date: Thu, 13 Aug 2015 16:13:08 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Major qgroup regression in 4.2?
Message-ID: <20150813231307.GA1145@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi I was looking at qgroups in linux 4.2 and noticed that the code to handle
subvolume deletion was removed and replaced with a comment:

/*
 * TODO: Modify related function to add related node/leaf to
 * dirty_extent_root,
 * for later qgroup accounting.
 *
 * Current, this function does nothing.
 */

The commit in question is 0ed4792af0e8346cb670b4bc540df7594f4b2020,
"btrfs: qgroup: Switch to new extent-oriented qgroup mechanism."


Sure enough, I can reproduce an inconsistency by just removing a subvolume
with more than 1 level.  A script to reproduce this is attached to my e-mail
(it's from the last time I fixed subvolume delete).  This does not happen
with Kernel 4.1.

I also found the following in an e-mail from Qu a few weeks ago on the list:

"And we still don't have a good idea to fix the snapshot deletion bug.
(My patchset can only handle snapshot with up to 2 levels. With higher
level, the qgroup number will still be wrong until related node/leaves are
all COWed)"

http://www.spinics.net/lists/linux-btrfs/msg45724.html


So did we just commit another qgroup rewrite while knowingly re-introducing a
major regression without a plan to fix it, or am I crazy?

If there *is* a plan to make this all work again, can I please hear it? The
comment mentions something about adding those nodes to a dirty_extent_root.
Why wasn't that done?

Thanks,
	--Mark


#! /bin/bash 

SCRATCH_MNT="/btrfs"
SCRATCH_DEV=/dev/vdb1
BTRFS_UTIL_PROG=btrfs

echo "format, mount fs"

mkfs.btrfs -f $SCRATCH_DEV
mount -t btrfs $SCRATCH_DEV $SCRATCH_MNT

# This always reproduces level 1 trees
maxfiles=100

echo "create file set"

# Make a bunch of small files in a directory. This is designed to expand
# the filesystem tree to something more than zero levels.
mkdir $SCRATCH_MNT/files
for i in `seq -w 0 $maxfiles`;
do
    dd status=none if=/dev/zero of=$SCRATCH_MNT/files/file$i bs=4096 count=4
done

# create a snapshot of what we just did
$BTRFS_UTIL_PROG fi sy $SCRATCH_MNT
$BTRFS_UTIL_PROG su sna $SCRATCH_MNT $SCRATCH_MNT/snap1
mv $SCRATCH_MNT/snap1/files $SCRATCH_MNT/snap1/old

# same thing as before but on the snapshot. this way we can generate
# some exclusively owned tree nodes.
echo "create file set on snapshot"
mkdir $SCRATCH_MNT/snap1/files
for i in `seq -w 0 $maxfiles`;
do
    dd status=none if=/dev/zero of=$SCRATCH_MNT/snap1/files/file$i bs=4096 count=4
done

SECS=30
echo "sleep for $SECS seconds"
# Enable qgroups now that we have our filesystem prepared. This
# will kick off a scan which we will have to wait for below.
$BTRFS_UTIL_PROG qu en $SCRATCH_MNT
sleep $SECS

echo "unmount, remount fs to clear cache"
umount $SCRATCH_MNT
mount -t btrfs $SCRATCH_DEV $SCRATCH_MNT

SECS=45
echo "delete snapshot, sleep for $SECS seconds"

# Ok, delete the snapshot we made previously. Since btrfs drop
# snapshot is a delayed action with no way to force it, we have to
# impose another sleep here.
$BTRFS_UTIL_PROG su de $SCRATCH_MNT/snap1
sleep $SECS

echo "unmount"
umount $SCRATCH_MNT

# generate a qgroup report and look for inconsistent groups
$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV

exit
