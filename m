From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: Patches for BTRFS (mail-server slow down in 3.0 and more)
Date: Sat, 29 Oct 2011 02:35:16 -0200
Message-ID: <orehxw1kl7.fsf@livre.localdomain>
References: <4EAB270C.60406@malowa.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-btrfs@vger.kernel.org
To: Marcel Lohmann <marcel@malowa.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EAB270C.60406@malowa.de> (Marcel Lohmann's message of "Sat, 29
	Oct 2011 00:05:00 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

On Oct 28, 2011, Marcel Lohmann <marcel@malowa.de> wrote:

> I would really appreciate if you could send me the patches.

Here are the patches I mentioned on IRC.  I've sent two of them to Josef
for him to push upstream, but I'm not sure he posted them here for I'm
not on the list (yet?).  The other two are newer, and the last one is
definitely not for inclusion (just for testing or as a temporary
work-around).

I've been using the first 3 with some success on a couple of mail
servers: I haven't hit the ridiculous slow downs from frequent
unsuccessful calls of setup_cluster_no_bitmap after a while, like I did
with 3.0 (and 3.1) any more.

However, the excess use of metadata that I've experienced on ceph OSDs
isn't fixed by them.  A btrfs balance with the first 3 still has 22GB of
metadata block groups even though only 4.1GB of metadata are in use, or
19GB of metadata with only 2GB of metadata in use.  With the 4th patch
and -o clear_cache, the first rebalancing of the 22GB-metadata
filesystem got it down to 8GB; the second fs is still on rebalancing
~800GB (wishlist mental note: introduce some means to rebalance only the
metadata)

Here are the patches, against 3.1-libre (should apply cleanly on 3.1).



--=-=-=
Content-Type: message/rfc822
Content-Disposition: attachment;
 filename=0001-Revamp-btrfs-cluster-creation-logic.patch

From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Fri, 14 Oct 2011 12:10:36 -0300
Subject: [PATCH 1/4] Revamp btrfs cluster creation logic.

Parameterized clusters on minimum total size and minimum chunk size,
without an upper bound.  Don't tolerate fragmentation for SSD_SPREAD;
accept some fragmentation for metadata but try to keep data dense.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |   64 +++++++++++++++++++++++-------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 41ac927..4973816 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2092,8 +2092,8 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	unsigned long next_zero;
 	unsigned long i;
-	unsigned long search_bits;
-	unsigned long total_bits;
+	unsigned long want_bits;
+	unsigned long min_bits;
 	unsigned long found_bits;
 	unsigned long start = 0;
 	unsigned long total_found = 0;
@@ -2102,8 +2102,8 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 
 	i = offset_to_bit(entry->offset, block_group->sectorsize,
 			  max_t(u64, offset, entry->offset));
-	search_bits = bytes_to_bits(bytes, block_group->sectorsize);
-	total_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
+	want_bits = bytes_to_bits(bytes, block_group->sectorsize);
+	min_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
 
 again:
 	found_bits = 0;
@@ -2112,7 +2112,7 @@ again:
 	     i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, i + 1)) {
 		next_zero = find_next_zero_bit(entry->bitmap,
 					       BITS_PER_BITMAP, i);
-		if (next_zero - i >= search_bits) {
+		if (next_zero - i >= min_bits) {
 			found_bits = next_zero - i;
 			break;
 		}
@@ -2132,9 +2132,9 @@ again:
 	if (cluster->max_size < found_bits * block_group->sectorsize)
 		cluster->max_size = found_bits * block_group->sectorsize;
 
-	if (total_found < total_bits) {
+	if (total_found < want_bits) {
 		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
-		if (i - start > total_bits * 2) {
+		if (i - start > want_bits * 2) {
 			total_found = 0;
 			cluster->max_size = 0;
 			found = false;
@@ -2180,8 +2180,8 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	 * We don't want bitmaps, so just move along until we find a normal
 	 * extent entry.
 	 */
-	while (entry->bitmap) {
-		if (list_empty(&entry->list))
+	while (entry->bitmap || entry->bytes < min_bytes) {
+		if (entry->bitmap && list_empty(&entry->list))
 			list_add_tail(&entry->list, bitmaps);
 		node = rb_next(&entry->offset_index);
 		if (!node)
@@ -2196,10 +2196,8 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	last = entry;
 	prev = entry;
 
-	while (window_free <= min_bytes) {
-		node = rb_next(&entry->offset_index);
-		if (!node)
-			return -ENOSPC;
+	for (node = rb_next(&entry->offset_index); node;
+	     node = rb_next(&entry->offset_index)) {
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 
 		if (entry->bitmap) {
@@ -2208,12 +2206,19 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			continue;
 		}
 
+		if (entry->bytes < min_bytes)
+			continue;
+
 		/*
 		 * we haven't filled the empty size and the window is
 		 * very large.  reset and try again
 		 */
 		if (entry->offset - (prev->offset + prev->bytes) > max_gap ||
-		    entry->offset - window_start > (min_bytes * 2)) {
+		    entry->offset - window_start > (window_free * 2)) {
+			/* We got a cluster of the requested size,
+			   we're done.  */
+			if (window_free >= bytes)
+				break;
 			first = entry;
 			window_start = entry->offset;
 			window_free = entry->bytes;
@@ -2228,6 +2233,9 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		prev = entry;
 	}
 
+	if (window_free < bytes)
+		return -ENOSPC;
+
 	cluster->window_start = first->offset;
 
 	node = &first->offset_index;
@@ -2241,7 +2249,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 		node = rb_next(&entry->offset_index);
-		if (entry->bitmap)
+		if (entry->bitmap || entry->bytes < min_bytes)
 			continue;
 
 		rb_erase(&entry->offset_index, &ctl->free_space_offset);
@@ -2323,7 +2331,7 @@ search:
 
 /*
  * here we try to find a cluster of blocks in a block group.  The goal
- * is to find at least bytes free and up to empty_size + bytes free.
+ * is to find at least bytes+empty_size.
  * We might not find them all in one contiguous area.
  *
  * returns zero and sets up cluster if things worked out, otherwise
@@ -2341,19 +2349,16 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	u64 min_bytes;
 	int ret;
 
-	/* for metadata, allow allocates with more holes */
+	/*
+	 * Choose the minimum extent size we'll require for this
+	 * cluster.  For SSD_SPREAD, don't allow any fragmentation.
+	 * For metadata, allow allocates with smaller extents.  For
+	 * data, keep it dense.
+	 */
 	if (btrfs_test_opt(root, SSD_SPREAD)) {
 		min_bytes = bytes + empty_size;
 	} else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
-		/*
-		 * we want to do larger allocations when we are
-		 * flushing out the delayed refs, it helps prevent
-		 * making more work as we go along.
-		 */
-		if (trans->transaction->delayed_refs.flushing)
-			min_bytes = max(bytes, (bytes + empty_size) >> 1);
-		else
-			min_bytes = max(bytes, (bytes + empty_size) >> 4);
+		min_bytes = bytes;
 	} else
 		min_bytes = max(bytes, (bytes + empty_size) >> 2);
 
@@ -2363,7 +2368,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	 * If we know we don't have enough space to make a cluster don't even
 	 * bother doing all the work to try and find one.
 	 */
-	if (ctl->free_space < min_bytes) {
+	if (ctl->free_space < bytes) {
 		spin_unlock(&ctl->tree_lock);
 		return -ENOSPC;
 	}
@@ -2378,10 +2383,11 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&bitmaps);
 	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
-				      bytes, min_bytes);
+				      bytes + empty_size, min_bytes);
 	if (ret)
 		ret = setup_cluster_bitmap(block_group, cluster, &bitmaps,
-					   offset, bytes, min_bytes);
+					   offset, bytes + empty_size,
+					   min_bytes);
 
 	/* Clear our temporary list */
 	list_for_each_entry_safe(entry, tmp, &bitmaps, list)
-- 
1.7.4.4


--=-=-=
Content-Type: message/rfc822
Content-Disposition: attachment;
 filename=0002-Drop-gap-detection-from-btrfs.patch

From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Sun, 16 Oct 2011 02:01:15 -0200
Subject: [PATCH 2/4] Drop gap detection from btrfs.

Since btrfs_find_space_cluster already sets up min_bytes so as to
avoid fragmentation, drop explicit limits on window size or density.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |   32 +++-----------------------------
 1 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4973816..81a157f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2134,11 +2134,6 @@ again:
 
 	if (total_found < want_bits) {
 		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
-		if (i - start > want_bits * 2) {
-			total_found = 0;
-			cluster->max_size = 0;
-			found = false;
-		}
 		goto again;
 	}
 
@@ -2164,13 +2159,11 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *first = NULL;
 	struct btrfs_free_space *entry = NULL;
-	struct btrfs_free_space *prev = NULL;
 	struct btrfs_free_space *last;
 	struct rb_node *node;
 	u64 window_start;
 	u64 window_free;
 	u64 max_extent;
-	u64 max_gap = 128 * 1024;
 
 	entry = tree_search_offset(ctl, offset, 0, 1);
 	if (!entry)
@@ -2194,7 +2187,6 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	max_extent = entry->bytes;
 	first = entry;
 	last = entry;
-	prev = entry;
 
 	for (node = rb_next(&entry->offset_index); node;
 	     node = rb_next(&entry->offset_index)) {
@@ -2209,28 +2201,10 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		if (entry->bytes < min_bytes)
 			continue;
 
-		/*
-		 * we haven't filled the empty size and the window is
-		 * very large.  reset and try again
-		 */
-		if (entry->offset - (prev->offset + prev->bytes) > max_gap ||
-		    entry->offset - window_start > (window_free * 2)) {
-			/* We got a cluster of the requested size,
-			   we're done.  */
-			if (window_free >= bytes)
-				break;
-			first = entry;
-			window_start = entry->offset;
-			window_free = entry->bytes;
-			last = entry;
+		last = entry;
+		window_free += entry->bytes;
+		if (entry->bytes > max_extent)
 			max_extent = entry->bytes;
-		} else {
-			last = entry;
-			window_free += entry->bytes;
-			if (entry->bytes > max_extent)
-				max_extent = entry->bytes;
-		}
-		prev = entry;
 	}
 
 	if (window_free < bytes)
-- 
1.7.4.4


--=-=-=
Content-Type: message/rfc822
Content-Disposition: attachment;
 filename=0003-Require-at-least-one-extent-of-the-requested-size-bu.patch

From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Mon, 24 Oct 2011 03:30:46 -0200
Subject: [PATCH 3/4] Require at least one extent of the requested size, but
 accept other smaller ones except when SSD_SPREAD is
 enabled.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 81a157f..e2bb018 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2087,7 +2087,8 @@ out:
 static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 				struct btrfs_free_space *entry,
 				struct btrfs_free_cluster *cluster,
-				u64 offset, u64 bytes, u64 min_bytes)
+				u64 offset, u64 bytes,
+				u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	unsigned long next_zero;
@@ -2098,7 +2099,6 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
 	unsigned long start = 0;
 	unsigned long total_found = 0;
 	int ret;
-	bool found = false;
 
 	i = offset_to_bit(entry->offset, block_group->sectorsize,
 			  max_t(u64, offset, entry->offset));
@@ -2122,17 +2122,15 @@ again:
 	if (!found_bits)
 		return -ENOSPC;
 
-	if (!found) {
+	if (!total_found)
 		start = i;
-		found = true;
-	}
 
 	total_found += found_bits;
 
 	if (cluster->max_size < found_bits * block_group->sectorsize)
 		cluster->max_size = found_bits * block_group->sectorsize;
 
-	if (total_found < want_bits) {
+	if (total_found < want_bits || cluster->max_size < cont1_bytes) {
 		i = find_next_bit(entry->bitmap, BITS_PER_BITMAP, next_zero);
 		goto again;
 	}
@@ -2149,12 +2147,14 @@ again:
 
 /*
  * This searches the block group for just extents to fill the cluster with.
+ * Try to find a cluster with at least bytes total bytes, at least one
+ * extent of cont1_bytes, and other clusters of at least min_bytes.
  */
 static noinline int
 setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			struct btrfs_free_cluster *cluster,
 			struct list_head *bitmaps, u64 offset, u64 bytes,
-			u64 min_bytes)
+			u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *first = NULL;
@@ -2207,7 +2207,7 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			max_extent = entry->bytes;
 	}
 
-	if (window_free < bytes)
+	if (window_free < bytes || max_extent < cont1_bytes)
 		return -ENOSPC;
 
 	cluster->window_start = first->offset;
@@ -2245,7 +2245,7 @@ static noinline int
 setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		     struct btrfs_free_cluster *cluster,
 		     struct list_head *bitmaps, u64 offset, u64 bytes,
-		     u64 min_bytes)
+		     u64 cont1_bytes, u64 min_bytes)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_space *entry;
@@ -2263,7 +2263,7 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 		if (entry->bytes < min_bytes)
 			continue;
 		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
+					   bytes, cont1_bytes, min_bytes);
 		if (!ret)
 			return 0;
 	}
@@ -2297,7 +2297,7 @@ search:
 		if (entry->bytes < min_bytes)
 			continue;
 		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
-					   bytes, min_bytes);
+					   bytes, cont1_bytes, min_bytes);
 	} while (ret && node);
 
 	return ret;
@@ -2320,7 +2320,7 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct list_head bitmaps;
 	struct btrfs_free_space *entry, *tmp;
-	u64 min_bytes;
+	u64 min_bytes, cont1_bytes;
 	int ret;
 
 	/*
@@ -2330,11 +2330,14 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	 * data, keep it dense.
 	 */
 	if (btrfs_test_opt(root, SSD_SPREAD)) {
-		min_bytes = bytes + empty_size;
+		cont1_bytes = min_bytes = bytes + empty_size;
 	} else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
-		min_bytes = bytes;
-	} else
-		min_bytes = max(bytes, (bytes + empty_size) >> 2);
+		cont1_bytes = bytes;
+		min_bytes = block_group->sectorsize;
+	} else {
+		cont1_bytes = max(bytes, (bytes + empty_size) >> 2);
+		min_bytes = block_group->sectorsize;
+	}
 
 	spin_lock(&ctl->tree_lock);
 
@@ -2357,11 +2360,12 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 
 	INIT_LIST_HEAD(&bitmaps);
 	ret = setup_cluster_no_bitmap(block_group, cluster, &bitmaps, offset,
-				      bytes + empty_size, min_bytes);
+				      bytes + empty_size,
+				      cont1_bytes, min_bytes);
 	if (ret)
 		ret = setup_cluster_bitmap(block_group, cluster, &bitmaps,
 					   offset, bytes + empty_size,
-					   min_bytes);
+					   cont1_bytes, min_bytes);
 
 	/* Clear our temporary list */
 	list_for_each_entry_safe(entry, tmp, &bitmaps, list)
-- 
1.7.4.4


--=-=-=
Content-Type: message/rfc822
Content-Disposition: attachment;
 filename=0004-Disable-clustered-allocation-with-o-clear_cache.patch

From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Sat, 29 Oct 2011 02:20:55 -0200
Subject: [PATCH 4/4] Disable clustered allocation with -o clear_cache

Abuse -o clear_cache to experiment with disabling clustered allocation.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f5be06a..1d007e1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4905,7 +4905,9 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	 * If the space info is for both data and metadata it means we have a
 	 * small filesystem and we can't use the clustering stuff.
 	 */
-	if (btrfs_mixed_space_info(space_info))
+	if (btrfs_mixed_space_info(space_info)
+	    /* Abuse CLEAR_CACHE to test performance without clusters.  */
+	    || btrfs_test_opt(root, CLEAR_CACHE))
 		use_cluster = false;
 
 	if (orig_root->ref_cows || empty_size)
@@ -7010,8 +7012,10 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 	if (cache_gen != 0 &&
 	    btrfs_super_generation(&root->fs_info->super_copy) != cache_gen)
 		need_clear = 1;
-	if (btrfs_test_opt(root, CLEAR_CACHE))
+	if (btrfs_test_opt(root, CLEAR_CACHE)) {
 		need_clear = 1;
+		printk(KERN_INFO "btrfs: clearing cache and disabling clusters\n");
+	}
 	if (!btrfs_test_opt(root, SPACE_CACHE) && cache_gen)
 		printk(KERN_INFO "btrfs: disk space caching is enabled\n");
 
-- 
1.7.4.4


--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
