Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:55818 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753243AbdHTUTI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 16:19:08 -0400
Subject: [PATCH 2/4] btrfs: Adjust 32 checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net>
Message-ID: <933141a6-96cd-cef3-bbd3-e3b3d8def177@users.sourceforge.net>
Date: Sun, 20 Aug 2017 22:18:55 +0200
MIME-Version: 1.0
In-Reply-To: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Aug 2017 21:36:31 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/ctree.c       |  4 ++--
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/inode.c       |  4 ++--
 fs/btrfs/lzo.c         |  4 ++--
 fs/btrfs/qgroup.c      |  6 +++---
 fs/btrfs/reada.c       |  4 ++--
 fs/btrfs/scrub.c       | 12 ++++++------
 fs/btrfs/transaction.c |  2 +-
 fs/btrfs/tree-log.c    |  4 ++--
 fs/btrfs/volumes.c     | 14 +++++++-------
 fs/btrfs/xattr.c       |  2 +-
 fs/btrfs/zlib.c        |  4 ++--
 13 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6d49db7d86be..b89c101ef45e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2686,7 +2686,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
-	WARN_ON(p->nodes[0] != NULL);
+	WARN_ON(p->nodes[0]);
 	BUG_ON(!cow && ins_len);
 
 	if (ins_len < 0) {
@@ -2965,7 +2965,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	int prev_cmp = -1;
 
 	lowest_level = p->lowest_level;
-	WARN_ON(p->nodes[0] != NULL);
+	WARN_ON(p->nodes[0]);
 
 	if (p->search_commit_root) {
 		BUG_ON(time_seq);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 116c5615d6c2..240dccf8d41c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9774,7 +9774,7 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
 		block_group->iref = 0;
 		block_group->inode = NULL;
 		spin_unlock(&block_group->lock);
-		ASSERT(block_group->io_ctl.inode == NULL);
+		ASSERT(!block_group->io_ctl.inode);
 		iput(inode);
 		last = block_group->key.objectid + block_group->key.offset;
 		btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ea4947c97505..7fd39a1ec7d6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4793,7 +4793,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	unsigned long num_pages = num_extent_pages(src->start, src->len);
 
 	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
-	if (new == NULL)
+	if (!new)
 		return NULL;
 
 	for (i = 0; i < num_pages; i++) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4cb399854f0e..508057ec2534 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7599,7 +7599,7 @@ bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
 	 * found idx is less than or equal to the end idx then we know that
 	 * a page exists.  If no pages are found or if those pages are
 	 * outside of the range then we're fine (yay!) */
-	while (page == NULL &&
+	while (!page &&
 	       radix_tree_gang_lookup_slot(root, &pagep, NULL, start_idx, 1)) {
 		page = radix_tree_deref_slot(pagep);
 		if (unlikely(!page))
@@ -9588,7 +9588,7 @@ int btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (root == NULL)
+	if (!root)
 		return 1;
 
 	/* the snap/subvol tree is on deleting */
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index d433e75d489a..29452a0fec91 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -125,7 +125,7 @@ static int lzo_compress_pages(struct list_head *ws,
 	 * the first 4 bytes
 	 */
 	out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
-	if (out_page == NULL) {
+	if (!out_page) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -195,7 +195,7 @@ static int lzo_compress_pages(struct list_head *ws,
 				}
 
 				out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
-				if (out_page == NULL) {
+				if (!out_page) {
 					ret = -ENOMEM;
 					goto out;
 				}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ddc37c537058..1a29f333f54c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1468,7 +1468,7 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)
 	    || bytenr == 0 || num_bytes == 0)
 		return 0;
-	if (WARN_ON(trans == NULL))
+	if (WARN_ON(!trans))
 		return -EINVAL;
 	record = kmalloc(sizeof(*record), gfp_flag);
 	if (!record)
@@ -1604,7 +1604,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path = NULL;
 
 	BUG_ON(root_level < 0 || root_level >= BTRFS_MAX_LEVEL);
-	BUG_ON(root_eb == NULL);
+	BUG_ON(!root_eb);
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		return 0;
@@ -1640,7 +1640,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 walk_down:
 	level = root_level;
 	while (level >= 0) {
-		if (path->nodes[level] == NULL) {
+		if (!path->nodes[level]) {
 			int parent_slot;
 			u64 child_gen;
 			u64 child_bytenr;
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index ab852b8e3e37..71b96c2dadbf 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -445,7 +445,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		if (ret) {
 			while (--nzones >= 0) {
 				dev = re->zones[nzones]->device;
-				BUG_ON(dev == NULL);
+				BUG_ON(!dev);
 				/* ignore whether the entry was inserted */
 				radix_tree_delete(&dev->reada_extents, index);
 			}
@@ -661,7 +661,7 @@ static int reada_start_machine_dev(struct btrfs_device *dev)
 	int i;
 
 	spin_lock(&fs_info->reada_lock);
-	if (dev->reada_curr_zone == NULL) {
+	if (!dev->reada_curr_zone) {
 		ret = reada_pick_zone(dev);
 		if (!ret) {
 			spin_unlock(&fs_info->reada_lock);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f49b94ab3d2a..a36491587d13 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -710,7 +710,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	spin_lock_init(&sctx->stat_lock);
 	init_waitqueue_head(&sctx->list_wait);
 
-	WARN_ON(sctx->wr_curr_bio != NULL);
+	WARN_ON(sctx->wr_curr_bio);
 	mutex_init(&sctx->wr_lock);
 	sctx->wr_curr_bio = NULL;
 	if (is_dev_replace) {
@@ -1730,7 +1730,7 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 		struct bio *bio;
 		struct scrub_page *page = sblock->pagev[page_num];
 
-		if (page->dev->bdev == NULL) {
+		if (!page->dev->bdev) {
 			page->io_error = 1;
 			sblock->no_io_error_seen = 0;
 			continue;
@@ -1812,8 +1812,8 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 	struct scrub_page *page_good = sblock_good->pagev[page_num];
 	struct btrfs_fs_info *fs_info = sblock_bad->sctx->fs_info;
 
-	BUG_ON(page_bad->page == NULL);
-	BUG_ON(page_good->page == NULL);
+	BUG_ON(!page_bad->page);
+	BUG_ON(!page_good->page);
 	if (force_write || sblock_bad->header_error ||
 	    sblock_bad->checksum_error || page_bad->io_error) {
 		struct bio *bio;
@@ -1877,7 +1877,7 @@ static int scrub_write_page_to_dev_replace(struct scrub_block *sblock,
 {
 	struct scrub_page *spage = sblock->pagev[page_num];
 
-	BUG_ON(spage->page == NULL);
+	BUG_ON(!spage->page);
 	if (spage->io_error) {
 		void *mapped_buffer = kmap_atomic(spage->page);
 
@@ -4263,7 +4263,7 @@ int btrfs_scrub_cancel_dev(struct btrfs_fs_info *fs_info,
 	while (dev->scrub_device) {
 		mutex_unlock(&fs_info->scrub_lock);
 		wait_event(fs_info->scrub_pause_wait,
-			   dev->scrub_device == NULL);
+			   !dev->scrub_device);
 		mutex_lock(&fs_info->scrub_lock);
 	}
 	mutex_unlock(&fs_info->scrub_lock);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f615d59b0489..01d6c93caae6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1508,7 +1508,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 					 btrfs_ino(BTRFS_I(parent_inode)),
 					 dentry->d_name.name,
 					 dentry->d_name.len, 0);
-	if (dir_item != NULL && !IS_ERR(dir_item)) {
+	if (dir_item && !IS_ERR(dir_item)) {
 		pending->error = -EEXIST;
 		goto dir_item_existed;
 	} else if (IS_ERR(dir_item)) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3a11ae63676e..34692772cbcf 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1189,7 +1189,7 @@ static int extref_get_fields(struct extent_buffer *eb, int slot,
 		return -EIO;
 
 	*name = kmalloc(*namelen, GFP_NOFS);
-	if (*name == NULL)
+	if (!*name)
 		return -ENOMEM;
 
 	read_extent_buffer(eb, *name, (unsigned long)&extref->name,
@@ -1216,7 +1216,7 @@ static int ref_get_fields(struct extent_buffer *eb, int slot,
 		return -EIO;
 
 	*name = kmalloc(*namelen, GFP_NOFS);
-	if (*name == NULL)
+	if (!*name)
 		return -ENOMEM;
 
 	read_extent_buffer(eb, *name, (unsigned long)(ref + 1), *namelen);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 12bd04a4104f..dfe54b5c6884 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -409,8 +409,8 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 	 * device->running_pending is used to synchronize with the
 	 * schedule_bio code.
 	 */
-	if (device->pending_sync_bios.head == NULL &&
-	    device->pending_bios.head == NULL) {
+	if (!device->pending_sync_bios.head &&
+	    !device->pending_bios.head) {
 		again = 0;
 		device->running_pending = 0;
 	} else {
@@ -5439,7 +5439,7 @@ static int get_extra_mirror_from_replace(struct btrfs_fs_info *fs_info,
 	ret = __btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
 				logical, &length, &bbio, 0, 0);
 	if (ret) {
-		ASSERT(bbio == NULL);
+		ASSERT(!bbio);
 		return ret;
 	}
 
@@ -5688,7 +5688,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		btrfs_dev_replace_set_lock_blocking(dev_replace);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
-	    !need_full_stripe(op) && dev_replace->tgtdev != NULL) {
+	    !need_full_stripe(op) && dev_replace->tgtdev) {
 		ret = get_extra_mirror_from_replace(fs_info, logical, *length,
 						    dev_replace->srcdev->devid,
 						    &mirror_num,
@@ -5804,7 +5804,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	}
 
 	num_alloc_stripes = num_stripes;
-	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL) {
+	if (dev_replace_is_ongoing && dev_replace->tgtdev) {
 		if (op == BTRFS_MAP_WRITE)
 			num_alloc_stripes <<= 1;
 		if (op == BTRFS_MAP_GET_READ_MIRRORS)
@@ -5817,7 +5817,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		ret = -ENOMEM;
 		goto out;
 	}
-	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL)
+	if (dev_replace_is_ongoing && dev_replace->tgtdev)
 		bbio->tgtdev_map = (int *)(bbio->stripes + num_alloc_stripes);
 
 	/* build raid_map */
@@ -5863,7 +5863,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	if (bbio->raid_map)
 		sort_parity_stripes(bbio, num_stripes);
 
-	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL &&
+	if (dev_replace_is_ongoing && dev_replace->tgtdev &&
 	    need_full_stripe(op)) {
 		handle_ops_on_dev_replace(op, &bbio, dev_replace, &num_stripes,
 					  &max_errors);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 2c7e53f9ff1b..0c0972aee7e8 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -444,7 +444,7 @@ static int btrfs_initxattrs(struct inode *inode,
 	char *name;
 	int err = 0;
 
-	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+	for (xattr = xattr_array; xattr->name; xattr++) {
 		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
 			       strlen(xattr->name) + 1, GFP_KERNEL);
 		if (!name) {
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index c248f9286366..3bbe6904193a 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -109,7 +109,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	data_in = kmap(in_page);
 
 	out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
-	if (out_page == NULL) {
+	if (!out_page) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -151,7 +151,7 @@ static int zlib_compress_pages(struct list_head *ws,
 				goto out;
 			}
 			out_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
-			if (out_page == NULL) {
+			if (!out_page) {
 				ret = -ENOMEM;
 				goto out;
 			}
-- 
2.14.0

