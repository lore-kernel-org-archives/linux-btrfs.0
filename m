Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11079 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab3GDLNJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jul 2013 07:13:09 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r64AbksR019758
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Jul 2013 18:37:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix wrong write offset when replacing a device
Date: Thu, 4 Jul 2013 18:37:21 +0800
Message-Id: <1372934241-421-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The filesystem was corrupted after we did a device replace.

Steps to reproduce:
 # mkfs.btrfs -f -m single -d raid10 <device0>..<device3>
 # mount <device0> <mnt>
 # btrfs replace start -rfB 1 <device4> <mnt>
 # umount <mnt>
 # btrfsck <device4>

The reason is that we changed the write offset by mistake. When we
replace the a device, we read the data from the source device at first,
and then write the data into the corresponding place of the new device.
But when we read the data, we will try to spread the read request among
the mirrors. It is a good idea that can speed up the read request, but
should not change the write offset because it is corresponding to the source
device, not the mirror device, if we change it by the offset of the mirror
device, we would get the wrong offset. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 929093d..092bec4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -228,7 +228,6 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work);
 static void scrub_block_complete(struct scrub_block *sblock);
 static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 			       u64 extent_logical, u64 extent_len,
-			       u64 *extent_physical,
 			       struct btrfs_device **extent_dev,
 			       int *extent_mirror_num);
 static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
@@ -2482,8 +2481,7 @@ again:
 			extent_mirror_num = mirror_num;
 			if (is_dev_replace)
 				scrub_remap_extent(fs_info, extent_logical,
-						   extent_len, &extent_physical,
-						   &extent_dev,
+						   extent_len, &extent_dev,
 						   &extent_mirror_num);
 
 			ret = btrfs_lookup_csums_range(csum_root, logical,
@@ -3057,7 +3055,6 @@ int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
 
 static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 			       u64 extent_logical, u64 extent_len,
-			       u64 *extent_physical,
 			       struct btrfs_device **extent_dev,
 			       int *extent_mirror_num)
 {
@@ -3074,7 +3071,6 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 		return;
 	}
 
-	*extent_physical = bbio->stripes[0].physical;
 	*extent_mirror_num = bbio->mirror_num;
 	*extent_dev = bbio->stripes[0].dev;
 	kfree(bbio);
-- 
1.8.1.4

