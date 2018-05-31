Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58407 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754034AbeEaIfz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 04:35:55 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3709EAC95
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 08:35:54 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: scrub: Don't use inode pages for device replace
Date: Thu, 31 May 2018 16:35:51 +0800
Message-Id: <20180531083551.25273-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
Btrfs can easily create compressed extent without checksum (even
though it shouldn't), and if we then try to replace device containing
such extent, the result device will contain all the uncompressed data
instead of the compressed one.

Leading to data corruption.

[Cause]
When handling compressed extent without checksum, device replace will
goes into copy_nocow_pages() function.

In that function, btrfs will get all inodes referring to this data
extents and then use find_or_create_page() to get pages direct from that
inode.

The problem here is, pages directly from inode are always uncompressed.
And for compressed data extent, they mismatch with on-disk data.
Thus this leads to corrupted compressed data extent written to replace
device.

[Fix]
The fix is a little tricky.
As we can't determine if an extent is compressed until we iterate
through at least one of its refereners, so we still need to go into
copy_nocow_pages() function.

And before we really begin to copy data, we check if the extent is
compressed, and if it is, we fallback to scrub_pages() to read the
on-disk data other than inode's uncompressed data.

To be able to call scrub_pages(), we need extra parameters, add all of
them (@physical, @dev, @gen, excluding @flags which is fixed to
BTRFS_EXTENT_FLAG_DATA) to copy_nocow_pages() and nocow_ctx structure.

Reported-by: James Harvey <jamespharvey20@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---

In fact, the copy_nocow_pages() and its children functions are just a
kind of "clever" optimization to skip some read IO.

However I'm never a fan of such "optimization", no to mention when it's
causing bugs.
Although the ability to use page cache to write data back looks pretty
nice, it's in fact pretty niche.

I'm pretty happy if we could remove the whole copy_nocow_pages() branch,
and use the only and unified scrub_pages() to handle everything.
At least it's way more cleaner than current solution.

---
 fs/btrfs/scrub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 52b39a0924e9..307a06450e5c 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -212,6 +212,11 @@ struct scrub_copy_nocow_ctx {
 	u64			physical_for_dev_replace;
 	struct list_head	inodes;
 	struct btrfs_work	work;
+
+	/* All these members are only for falling back to scrub_pages() */
+	u64			fb_physical;
+	struct btrfs_device	*fb_dev;
+	u64			fb_gen;
 };
 
 struct scrub_warning {
@@ -282,6 +287,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 				      struct scrub_copy_nocow_ctx *ctx);
 static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
+			    u64 physical, struct btrfs_device *dev, u64 gen,
 			    int mirror_num, u64 physical_for_dev_replace);
 static void copy_nocow_pages_worker(struct btrfs_work *work);
 static void __scrub_blocked_if_needed(struct btrfs_fs_info *fs_info);
@@ -2801,8 +2807,8 @@ static int scrub_extent(struct scrub_ctx *sctx, struct map_lookup *map,
 				++sctx->stat.no_csum;
 			if (sctx->is_dev_replace && !have_csum) {
 				ret = copy_nocow_pages(sctx, logical, l,
-						       mirror_num,
-						      physical_for_dev_replace);
+						physical, dev, gen, mirror_num,
+						physical_for_dev_replace);
 				goto behind_scrub_pages;
 			}
 		}
@@ -4359,6 +4365,7 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 }
 
 static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
+			    u64 physical, struct btrfs_device *dev, u64 gen,
 			    int mirror_num, u64 physical_for_dev_replace)
 {
 	struct scrub_copy_nocow_ctx *nocow_ctx;
@@ -4379,6 +4386,11 @@ static int copy_nocow_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 	nocow_ctx->len = len;
 	nocow_ctx->mirror_num = mirror_num;
 	nocow_ctx->physical_for_dev_replace = physical_for_dev_replace;
+
+	nocow_ctx->fb_physical = physical;
+	nocow_ctx->fb_gen = gen;
+	nocow_ctx->fb_dev = dev;
+
 	btrfs_init_work(&nocow_ctx->work, btrfs_scrubnc_helper,
 			copy_nocow_pages_worker, NULL, NULL);
 	INIT_LIST_HEAD(&nocow_ctx->inodes);
@@ -4487,7 +4499,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 }
 
 static int check_extent_to_block(struct btrfs_inode *inode, u64 start, u64 len,
-				 u64 logical)
+				 u64 logical, int *compressed)
 {
 	struct extent_state *cached_state = NULL;
 	struct btrfs_ordered_extent *ordered;
@@ -4523,6 +4535,7 @@ static int check_extent_to_block(struct btrfs_inode *inode, u64 start, u64 len,
 		ret = 1;
 		goto out_unlock;
 	}
+	*compressed = em->compress_type;
 	free_extent_map(em);
 
 out_unlock:
@@ -4543,6 +4556,7 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 	u64 nocow_ctx_logical;
 	u64 len = nocow_ctx->len;
 	unsigned long index;
+	int compressed;
 	int srcu_index;
 	int ret = 0;
 	int err = 0;
@@ -4576,12 +4590,20 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 	nocow_ctx_logical = nocow_ctx->logical;
 
 	ret = check_extent_to_block(BTRFS_I(inode), offset, len,
-			nocow_ctx_logical);
+			nocow_ctx_logical, &compressed);
 	if (ret) {
 		ret = ret > 0 ? 0 : ret;
 		goto out;
 	}
 
+	/*
+	 * We hit the damn nodatasum compressed extent, we can't use any page
+	 * from inode as they are all *UNCOMPRESSED*.
+	 * We fall back to scrub_pages() for such case.
+	 */
+	if (compressed)
+		goto fallback;
+
 	while (len >= PAGE_SIZE) {
 		index = offset >> PAGE_SHIFT;
 again:
@@ -4624,11 +4646,16 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 		}
 
 		ret = check_extent_to_block(BTRFS_I(inode), offset, len,
-					    nocow_ctx_logical);
+					    nocow_ctx_logical, &compressed);
 		if (ret) {
 			ret = ret > 0 ? 0 : ret;
 			goto next_page;
 		}
+		if (compressed) {
+			unlock_page(page);
+			put_page(page);
+			goto fallback;
+		}
 
 		err = write_page_nocow(nocow_ctx->sctx,
 				       physical_for_dev_replace, page);
@@ -4651,6 +4678,19 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 	inode_unlock(inode);
 	iput(inode);
 	return ret;
+
+fallback:
+	inode_unlock(inode);
+	iput(inode);
+
+	ret = scrub_pages(nocow_ctx->sctx, nocow_ctx->logical,
+			  nocow_ctx->len, nocow_ctx->fb_physical,
+			  nocow_ctx->fb_dev, BTRFS_EXTENT_FLAG_DATA,
+			  nocow_ctx->fb_gen, nocow_ctx->mirror_num,
+			  NULL, 0, physical_for_dev_replace);
+	if (!ret)
+		ret = COPY_COMPLETE;
+	return ret;
 }
 
 static int write_page_nocow(struct scrub_ctx *sctx,
-- 
2.17.1

