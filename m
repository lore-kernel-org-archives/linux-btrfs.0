From: Simon Kirby <sim@hostway.ca>
Subject: Re: Hot rb_next, setup_cluster_no_bitmap
Date: Wed, 3 Aug 2011 15:39:49 -0700
Message-ID: <20110803223949.GA20056@hostway.ca>
References: <20110803220655.GE20966@hostway.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Cc: Josef Bacik <josef@redhat.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110803220655.GE20966@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 03, 2011 at 03:06:55PM -0700, Simon Kirby wrote:

> I see Josef's 86d4a77ba3dc4ace238a0556541a41df2bd71d49 introduced the
> bitmaps list. I could try temporarily reverting this (some fixups needed)
> if anybody thinks my cache bouncing idea might be slightly possible.

I'll try the attached and see how the profile changes.

Simon-

--BXVAT5kNtrzKuDFl
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="btrfs+setup_cluster_no_bitmap_no_bitmaps_list.patch"

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6377713..99582f9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2148,7 +2148,7 @@ again:
 static noinline int
 setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			struct btrfs_free_cluster *cluster,
-			struct list_head *bitmaps, u64 offset, u64 bytes,
+			u64 offset, u64 bytes,
 			u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
@@ -2171,8 +2171,6 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	 * extent entry.
 	 */
 	while (entry->bitmap) {
-		if (list_empty(&entry->list))
-			list_add_tail(&entry->list, bitmaps);
 		node = rb_next(&entry->offset_index);
 		if (!node)
 			return -ENOSPC;
@@ -2192,11 +2190,8 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			return -ENOSPC;
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 
-		if (entry->bitmap) {
-			if (list_empty(&entry->list))
-				list_add_tail(&entry->list, bitmaps);
+		if (entry->bitmap)
 			continue;
-		}
 
 		/*
 		 * we haven't filled the empty size and the window is
@@ -2252,7 +2247,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 static noinline int
 setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		     struct btrfs_free_cluster *cluster,
-		     struct list_head *bitmaps, u64 offset, u64 bytes,
+		     u64 offset, u64 bytes,
 		     u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
@@ -2263,39 +2258,10 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 	if (ctl->total_bitmaps == 0)
 		return -ENOSPC;
 
-	/*
-	 * First check our cached list of bitmaps and see if there is an entry
-	 * here that will work.
-	 */
-	list_for_each_entry(entry, bitmaps, list) {
-		if (entry->bytes < min_bytes)
-			continue;
-		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
-		if (!ret)
-			return 0;
-	}
-
-	/*
-	 * If we do have entries on our list and we are here then we didn't find
-	 * anything, so go ahead and get the next entry after the last entry in
-	 * this list and start the search from there.
-	 */
-	if (!list_empty(bitmaps)) {
-		entry = list_entry(bitmaps->prev, struct btrfs_free_space,
-				   list);
-		node = rb_next(&entry->offset_index);
-		if (!node)
-			return -ENOSPC;
-		entry = rb_entry(node, struct btrfs_free_space, offset_index);
-		goto search;
-	}
-
 	entry = tree_search_offset(ctl, offset_to_bitmap(ctl, offset), 0, 1);
 	if (!entry)
 		return -ENOSPC;
 
-search:
 	node = &entry->offset_index;
 	do {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
@@ -2326,8 +2292,6 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 			     u64 offset, u64 bytes, u64 empty_size)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
-	struct list_head bitmaps;
-	struct btrfs_free_space *entry, *tmp;
 	u64 min_bytes;
 	int ret;
 
@@ -2366,17 +2330,12 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	INIT_LIST_HEAD(&bitmaps);
-	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
+	ret = setup_cluster_no_bitmap(block_group, cluster, offset,
 				      bytes, min_bytes);
 	if (ret)
-		ret = setup_cluster_bitmap(block_group, cluster, &bitmaps,
+		ret = setup_cluster_bitmap(block_group, cluster,
 					   offset, bytes, min_bytes);
 
-	/* Clear our temporary list */
-	list_for_each_entry_safe(entry, tmp, &bitmaps, list)
-		list_del_init(&entry->list);
-
 	if (!ret) {
 		atomic_inc(&block_group->count);
 		list_add_tail(&cluster->block_group_list,

--BXVAT5kNtrzKuDFl--
