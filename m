Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33229 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdAXTtA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 14:49:00 -0500
Date: Tue, 24 Jan 2017 20:48:53 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Hans Deragon <hans@deragon.biz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid1:  cannot add disk to replace faulty because can only mount
 fs as read-only.
Message-ID: <20170124194853.rebmhi42szhwfci6@angband.pl>
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yspfzzzlp5wv3bp3"
In-Reply-To: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yspfzzzlp5wv3bp3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 24, 2017 at 01:57:24PM -0500, Hans Deragon wrote:
> If I remove 'ro' from the option, I cannot get the filesystem mounted
> because of the following error:
> 
> BTRFS: missing devices(1) exceeds the limit(0), writeable mount is not
> allowed
> 
> So I am stuck. I can only mount the filesystem as read-only, which prevents
> me to add a disk.

A known problem: you get only one shot at fixing the filesystem, but that's
not because of some damage but because the check whether the fs is in a
shape is good enough to mount is oversimplistic.

Here's a patch, if you apply it and recompile, you'll be able to mount
degraded rw.

Note that it removes a safety harness: here, the harness got tangled up and
keeps you from recovering when it shouldn't, but it _has_ valid uses that.


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11

--yspfzzzlp5wv3bp3
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


--yspfzzzlp5wv3bp3--
