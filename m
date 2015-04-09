Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33282 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbDIVfW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 17:35:22 -0400
Received: by paboj16 with SMTP id oj16so403168pab.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 14:35:21 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 0/6] Btrfs: show subvolume name and ID in /proc/mounts
Date: Thu,  9 Apr 2015 14:34:50 -0700
Message-Id: <cover.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's version 2 of providing the subvolume name and ID in /proc/mounts.

It turns out that getting the name of a subvolume reliably is a bit
trickier than it would seem because of how mounting subvolumes by ID is
implemented. In particular, in that case, the dentry we get for the root
of the mount is not necessarily attached to the dentry tree, which means
that the obvious solution of just dumping the dentry does not work. The
solution I put together makes the tradeoff of churning a bit more code
in order to avoid implementing this with weird hacks.

Changes from v1 (https://lkml.org/lkml/2015/4/8/16):

- Put subvol= last in show_options
- Change commit log to remove comment about userspace having no way to
  know which subvolume is mounted, as David pointed out you can use
  btrfs inspect-internal rootid <mountpoint>
- Split up patch 2
- Minor coding style fixes

This still applies to v4.0-rc7. Tested manually and with the script
below (updated from v1).

Thanks!

Omar Sandoval (6):
  Btrfs: lock superblock before remounting for rw subvol
  Btrfs: remove all subvol options before mounting top-level
  Btrfs: clean up error handling in mount_subvol()
  Btrfs: fail on mismatched subvol and subvolid mount options
  Btrfs: unify subvol= and subvolid= mounting
  Btrfs: show subvol= and subvolid= in /proc/mounts

 fs/btrfs/super.c | 376 ++++++++++++++++++++++++++++++++++++-------------------
 fs/seq_file.c    |   1 +
 2 files changed, 251 insertions(+), 126 deletions(-)

Testing script:

----
#!/bin/sh

set -e

check_subvol () {
	NAME="$1"
	ID="$2"

	# Mount by name.
	mount -osubvol="$NAME" /dev/vdb /mnt
	if ! findmnt -fno OPTIONS /mnt | grep -F ",subvolid=$ID,subvol=$NAME"; then
		echo "Failed $NAME" >&2
		umount /mnt
		exit 1
	fi
	umount /mnt

	# Mount by ID.
	mount -osubvolid="$ID" /dev/vdb /mnt
	if ! findmnt -fno OPTIONS /mnt | grep -F ",subvolid=$ID,subvol=$NAME"; then
		echo "Failed $ID" >&2
		umount /mnt
		exit 1
	fi
	umount /mnt
}

check_default_subvol () {
	NAME="$1"
	ID="$2"

	mount /dev/vdb /mnt
	if ! findmnt -fno OPTIONS /mnt | grep -F ",subvolid=$ID,subvol=$NAME"; then
		echo "Failed default" >&2
		umount /mnt
		exit 1
	fi
	umount /mnt
}

mkfs.btrfs -f /dev/vdb
mount /dev/vdb /mnt
btrfs subvolume create /mnt/vol
btrfs subvolume create /mnt/vol/nestedvol
mkdir /mnt/dir
btrfs subvolume create /mnt/dir/dirvol
btrfs subvolume create /mnt/dir/dirvol/nesteddirvol
mkdir /mnt/vol/voldir
btrfs subvolume create /mnt/vol/voldir/voldirvol
btrfs subvolume list /mnt
umount /mnt

check_subvol /vol 257
check_subvol /vol/nestedvol 258
check_subvol /dir/dirvol 259
check_subvol /dir/dirvol/nesteddirvol 260
check_subvol /vol/voldir/voldirvol 261

check_default_subvol / 5

mount /dev/vdb /mnt
btrfs subvolume set-default 257 /mnt
umount /mnt

check_default_subvol /vol 257

if mount -osubvolid=258,subvol=/vol /dev/vdb /mnt 2>/dev/null; then
	umount /mnt
	echo "Mount of mismatched subvol and subvolid should have failed" >&2
	exit 1
fi
----

-- 
2.3.5

