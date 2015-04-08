Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36673 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbbDHFec (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 01:34:32 -0400
Received: by pdea3 with SMTP id a3so103445106pde.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 22:34:31 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 0/3] Btrfs: show subvolume name and ID in /proc/mounts
Date: Tue,  7 Apr 2015 22:33:59 -0700
Message-Id: <cover.1428471096.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So this is something that has bothered me as a Btrfs user for some time
and that came up in discussing a separate bug here:
https://lkml.org/lkml/2015/4/2/447.

It turns out that getting the name of a subvolume reliably is a bit
trickier than it would seem because of how mounting subvolumes by ID is
implemented. In particular, in that case, the dentry we get for the root
of the mount is not necessarily attached to the dentry tree, which means
that the obvious solution of just dumping the dentry does not work. The
solution I put together makes the tradeoff of churning a bit more code
in order to avoid implementing this with weird hacks.

Patch 1 is a bug fix that I came across during testing. Because it would
conflict with merging patch 2, I'm including it here.

Patch 2 is the big one: it makes mounts by subvolid work the same way as
mounts by subvol name by looking up the name for a subvolid from the
root backrefs and inode refs. It comes with the added benefit of making
subvolume mounts share the same codepath regardless of the method.

Patch 3 is really simple thanks to patch 2: the obvious change to
btrfs_show_options() works now.

This series applies to v4.0-rc7. I've tested it manually and with the
script below. Thank you!

Omar Sandoval (3):
  Btrfs: lock superblock before remounting for rw subvol
  Btrfs: unify subvol= and subvolid= mounting
  Btrfs: show subvol= and subvolid= in /proc/mounts

 fs/btrfs/super.c | 353 ++++++++++++++++++++++++++++++++++++-------------------
 fs/seq_file.c    |   1 +
 2 files changed, 232 insertions(+), 122 deletions(-)


Testing script:

----
#!/bin/sh

set -e

check_subvol () {
	NAME="$1"
	ID="$2"

	# Mount by name.
	mount -osubvol="$NAME" /dev/vdb /mnt
	if ! grep vdb /proc/mounts | grep ",subvol=$NAME,subvolid=$ID"; then
		echo "Failed $NAME" >&2
		exit 1
	fi
	umount /mnt

	# Mount by ID.
	mount -osubvolid="$ID" /dev/vdb /mnt
	if ! grep vdb /proc/mounts | grep ",subvol=$NAME,subvolid=$ID"; then
		echo "Failed $ID" >&2
		exit 1
	fi
	umount /mnt
}

check_default_subvol () {
	NAME="$1"
	ID="$2"

	mount /dev/vdb /mnt
	if ! grep vdb /proc/mounts | grep ",subvol=$NAME,subvolid=$ID"; then
		echo "Failed default" >&2
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
----

-- 
2.3.5

