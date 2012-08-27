Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:20450 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab2H0OaH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 10:30:07 -0400
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] Btrfs: revert checksum error statistic which can cause a BUG()
Date: Mon, 27 Aug 2012 16:30:03 +0200
Message-Id: <1346077803-10391-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 442a4f6308e694e0fa6025708bd5e4e424bbf51c added btrfs device
statistic counters for detected IO and checksum errors to Linux 3.5.
The statistic part that counts checksum errors in
end_bio_extent_readpage() can cause a BUG() in a subfunction:
"kernel BUG at fs/btrfs/volumes.c:3762!"
That part is reverted with the current patch.
However, the counting of checksum errors in the scrub context remains
active, and the counting of detected IO errors (read, write or flush
errors) in all contexts remains active.

Cc: stable <stable@vger.kernel.org> # 3.5
Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/extent_io.c | 17 ++---------------
 fs/btrfs/volumes.c   | 22 ----------------------
 fs/btrfs/volumes.h   |  2 --
 3 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bb25e89..e2b3f36 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2329,23 +2329,10 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
 							      state, mirror);
-			if (ret) {
-				/* no IO indicated but software detected errors
-				 * in the block, either checksum errors or
-				 * issues with the contents */
-				struct btrfs_root *root =
-					BTRFS_I(page->mapping->host)->root;
-				struct btrfs_device *device;
-
+			if (ret)
 				uptodate = 0;
-				device = btrfs_find_device_for_logical(
-						root, start, mirror);
-				if (device)
-					btrfs_dev_stat_inc_and_print(device,
-						BTRFS_DEV_STAT_CORRUPTION_ERRS);
-			} else {
+			else
 				clean_io_failure(start, page);
-			}
 		}
 
 		if (!uptodate && tree->ops && tree->ops->readpage_io_failed_hook) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 01d6e66..bb0c732 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4607,28 +4607,6 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	return ret;
 }
 
-struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
-						   u64 logical, int mirror_num)
-{
-	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
-	int ret;
-	u64 map_length = 0;
-	struct btrfs_bio *bbio = NULL;
-	struct btrfs_device *device;
-
-	BUG_ON(mirror_num == 0);
-	ret = btrfs_map_block(map_tree, WRITE, logical, &map_length, &bbio,
-			      mirror_num);
-	if (ret) {
-		BUG_ON(bbio != NULL);
-		return NULL;
-	}
-	BUG_ON(mirror_num != bbio->mirror_num);
-	device = bbio->stripes[mirror_num - 1].dev;
-	kfree(bbio);
-	return device;
-}
-
 int btrfs_read_chunk_tree(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5479325..53c06af 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -289,8 +289,6 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
-struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
-						   u64 logical, int mirror_num);
 void btrfs_dev_stat_print_on_error(struct btrfs_device *device);
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_root *root,
-- 
1.7.12

