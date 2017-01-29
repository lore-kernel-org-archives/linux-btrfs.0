Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:57174 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbdA2URd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Jan 2017 15:17:33 -0500
Date: Sun, 29 Jan 2017 21:16:50 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Subscription Account <4subsacct+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Raid1 won't mount degraded
Message-ID: <20170129201650.wvpzaz45r5uzsvrb@angband.pl>
References: <CAHMMHbe4Py0JBxOQ7Z7Vv4r0UQ4ZJPKjKUXZqNo+Pdi6L_gAaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rej55rvgrewqtyls"
In-Reply-To: <CAHMMHbe4Py0JBxOQ7Z7Vv4r0UQ4ZJPKjKUXZqNo+Pdi6L_gAaw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rej55rvgrewqtyls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 29, 2017 at 08:12:56AM -0500, Subscription Account wrote:
> I had to remove one disk from raid 1 and I rebooted the system and was
> able to mount in degraded mode. Then I powered off the system added a
> new disk and when I am trying to mount the btrfs filesystem in
> degraded mode it will no longer mount it read-write. I can mount
> read-only though.
> 
> [ 2506.816795] BTRFS: missing devices(1) exceeds the limit(0),
> writeable mount is not allowed
> 
> In the read-only mode I am not able to add a new device or replace :(.
> Please help.

A known problem; you can mount rw degraded only once, if you don't fix the
degradation somehow (by adding a device or converting down), you can't mount
rw again.

If you know how to build a kernel, here's a crude patch.


Meow
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11

--rej55rvgrewqtyls
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-NOT-FOR-MERGING-btrfs-make-too-many-missing-devices-.patch"

>From 1367d3da6b0189797f6090b11d8716a1cc136593 Mon Sep 17 00:00:00 2001
From: Adam Borowski <kilobyte@angband.pl>
Date: Mon, 23 Jan 2017 19:03:20 +0100
Subject: [PATCH] [NOT-FOR-MERGING] btrfs: make "too many missing devices"
 check non-fatal

It breaks degraded mounts of multi-device filesystems that have any single
blocks, which are naturally created if it has been mounted degraded before.
Obviously, any further device loss will result in data loss, but the user
has already specified -odegraded so that's understood.

For a real fix, we'd want to check whether any of single blocks are missing,
as that would allow telling apart broken JBOD filesystems from bona-fide
degraded RAIDs.

(This patch is for the benefit of folks who'd have to recreate a filesystem
just because it got degraded.)
---
 fs/btrfs/disk-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 18004169552c..1b25b9e24662 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3060,10 +3060,9 @@ int open_ctree(struct super_block *sb,
 	     fs_info->num_tolerated_disk_barrier_failures &&
 	    !(sb->s_flags & MS_RDONLY)) {
 		btrfs_warn(fs_info,
-"missing devices (%llu) exceeds the limit (%d), writeable mount is not allowed",
+"missing devices (%llu) exceeds the limit (%d), add more or risk data loss",
 			fs_info->fs_devices->missing_devices,
 			fs_info->num_tolerated_disk_barrier_failures);
-		goto fail_sysfs;
 	}
 
 	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
-- 
2.11.0


--rej55rvgrewqtyls--
