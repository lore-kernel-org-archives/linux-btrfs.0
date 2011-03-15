From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs scrub: don't restart chunk on commit
Date: Tue, 15 Mar 2011 15:31:24 +0100
Message-ID: <1300199484-3256-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch is based on the scrub v3 patch. It mainly fixes a problem where
a transaction commit led to a rescrub of the current chunk. Also fixed:
 - each EIO leaked a bio
 - the BIO_UPTODATE check was wrong
 - removed some trailing whitespace

Thanks to Ilya Dryomov and Jan Schmidt for pointing those out.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 915641d..f36f5bf 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -44,6 +44,7 @@
  *  - track and record media errors, throw out bad devices
  *  - add a readonly mode
  *  - add a mode to also read unallocated space
+ *  - make the prefetch cancellable
  */
 
 #ifdef SCRUB_BTRFS_WORKER
@@ -149,7 +150,7 @@ static noinline_for_stack void scrub_free_dev(struct scrub_dev *sdev)
 		struct bio *bio = sdev->bios[i].bio;
 		if (!bio)
 			break;
-		
+
 		last_page = NULL;
 		for (j = 0; j < bio->bi_vcnt; ++j) {
 			if (bio->bi_io_vec[j].bv_page == last_page)
@@ -218,7 +219,7 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
 	atomic_set(&sdev->cancel_req, 0);
 	sdev->csum_size = btrfs_super_csum_size(&fs_info->super_copy);
 	INIT_LIST_HEAD(&sdev->csum_list);
-	
+
 	spin_lock_init(&sdev->list_lock);
 	spin_lock_init(&sdev->stat_lock);
 	init_waitqueue_head(&sdev->list_wait);
@@ -301,7 +302,7 @@ static void scrub_recheck_error(struct scrub_bio *sbio, int ix)
 	return;
 
 malloc_error:
-	if (bio) 
+	if (bio)
 		bio_put(bio);
 	if (page)
 		__free_page(page);
@@ -387,7 +388,7 @@ static void scrub_fixup(struct scrub_fixup *fixup)
 {
 	struct scrub_dev *sdev = fixup->sdev;
 	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
-	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree; 
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct btrfs_multi_bio *multi = NULL;
 	struct bio *bio = fixup->bio;
 	u64 length;
@@ -441,7 +442,7 @@ static void scrub_fixup(struct scrub_fixup *fixup)
 
 		wait_for_completion(&complete);
 
-		if (~bio->bi_flags & BIO_UPTODATE)
+		if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 			/* I/O-error, this is not a good copy */
 			continue;
 
@@ -468,7 +469,7 @@ static void scrub_fixup(struct scrub_fixup *fixup)
 
 	wait_for_completion(&complete);
 
-	if (~bio->bi_flags & BIO_UPTODATE)
+	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		/* I/O-error, writeback failed, give up */
 		goto uncorrectable;
 
@@ -553,6 +554,7 @@ static void scrub_checksum(scrub_work_t *work)
 			page = old_bio->bi_io_vec[i].bv_page;
 			bio_add_page(bio, page, PAGE_SIZE, 0);
 		}
+		bio_put(old_bio);
 		goto out;
 	}
 	for (i = 0; i < sbio->count; ++i) {
@@ -714,7 +716,7 @@ static int scrub_submit(struct scrub_dev *sdev)
 		return 0;
 
 	sbio = sdev->bios + sdev->curr;
-	
+
 	sbio->bio->bi_sector = sbio->physical >> 9;
 	sbio->bio->bi_size = sbio->count * PAGE_SIZE;
 	sbio->bio->bi_next = NULL;
@@ -771,7 +773,7 @@ again:
 	++sbio->count;
 	if (sbio->count == SCRUB_PAGES_PER_BIO || force)
 		scrub_submit(sdev);
-		
+
 	return 0;
 }
 
@@ -939,12 +941,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 			}
 			btrfs_item_key_to_cpu(l, &key, slot);
 
-			if (key.objectid + key.offset <= logical)
-				goto next1;
-
 			if (key.objectid >= logical + map->stripe_len)
 				break;
-next1:
+
 			path->slots[0]++;
 		}
 		btrfs_release_path(root, path);
@@ -959,8 +958,7 @@ next1:
 	 */
 	start_stripe = 0;
 again:
-	logical = base + offset + start_stripe * map->stripe_len;
-	physical = map->stripes[num].physical + start_stripe * map->stripe_len;
+	logical = base + offset + start_stripe * increment;
 	for (i = start_stripe; i < nstripes; ++i) {
 		ret = btrfs_lookup_csums_range(csum_root, logical,
 		                               logical + map->stripe_len - 1,
@@ -974,7 +972,7 @@ again:
 	/*
 	 * now find all extents for each stripe and scrub them
 	 */
-	logical = base + offset + start_stripe * map->stripe_len;
+	logical = base + offset + start_stripe * increment;
 	physical = map->stripes[num].physical + start_stripe * map->stripe_len;
 	ret = 0;
 	for (i = start_stripe; i < nstripes; ++i) {
@@ -1007,6 +1005,7 @@ again:
 			mutex_unlock(&fs_info->scrub_lock);
 			wake_up(&fs_info->scrub_pause_wait);
 			scrub_free_csums(sdev);
+			start_stripe = i;
 			goto again;
 		}
 
@@ -1083,6 +1082,7 @@ again:
 			                   flags, generation, mirror_num);
 			if (ret)
 				goto out;
+
 next:
 			path->slots[0]++;
 		}
@@ -1101,7 +1101,7 @@ out:
 	return ret < 0 ? ret : 0;
 }
 
-static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev, 
+static noinline_for_stack int scrub_chunk(struct scrub_dev *sdev,
 	u64 chunk_tree, u64 chunk_objectid, u64 chunk_offset, u64 length)
 {
 	struct btrfs_mapping_tree *map_tree =
@@ -1242,7 +1242,7 @@ static noinline_for_stack int scrub_supers(struct scrub_dev *sdev)
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >= device->total_bytes)
 			break;
 
-		ret = scrub_page(sdev, bytenr, PAGE_SIZE, bytenr, 
+		ret = scrub_page(sdev, bytenr, PAGE_SIZE, bytenr,
 		                 BTRFS_EXTENT_FLAG_SUPER, gen, i, NULL, 1);
 		if (ret)
 			return ret;
@@ -1280,7 +1280,7 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_root *root)
 static noinline_for_stack void scrub_workers_put(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	
+
 	mutex_lock(&fs_info->scrub_lock);
 	if (--fs_info->scrub_workers_refcnt == 0) {
 #ifdef SCRUB_BTRFS_WORKER
@@ -1316,7 +1316,7 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 		printk(KERN_ERR "btrfs_scrub: size assumptions fail\n");
 		return -EINVAL;
 	}
-	    
+
 	ret = scrub_workers_get(root);
 	if (ret)
 		return ret;
@@ -1431,7 +1431,7 @@ int btrfs_scrub_cancel(struct btrfs_root *root)
 	}
 	atomic_dec(&fs_info->scrub_cancel_req);
 	mutex_unlock(&fs_info->scrub_lock);
-	
+
 	return 0;
 }
 
@@ -1454,7 +1454,7 @@ int btrfs_scrub_cancel_dev(struct btrfs_root *root, struct btrfs_device *dev)
 		mutex_lock(&fs_info->scrub_lock);
 	}
 	mutex_unlock(&fs_info->scrub_lock);
-		
+
 	return 0;
 }
 int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid)
@@ -1478,7 +1478,7 @@ int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid)
 
 	return ret;
 }
-	
+
 int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
                          struct btrfs_scrub_progress *progress)
 {
-- 
1.7.3.4

