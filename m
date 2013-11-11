Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:64847 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3KKH16 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Nov 2013 02:27:58 -0500
Received: by mail-qe0-f54.google.com with SMTP id 1so4097404qec.41
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 23:27:57 -0800 (PST)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Subject: [PATCH] Btrfs: Fixup usage of btrfs: prefix in syslog
Date: Mon, 11 Nov 2013 02:27:15 -0500
Message-Id: <1384154835-7037-2-git-send-email-fholton@gmail.com>
In-Reply-To: <1384154835-7037-1-git-send-email-fholton@gmail.com>
References: <1384154835-7037-1-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change all uses of printk to use the btrfs: prefix for
easier grepping of kernel log.

Signed-off-by: Frank Holton <fholton@gmail.com>
---
 fs/btrfs/compression.c      |    4 ++--
 fs/btrfs/ctree.c            |   14 +++++++-------
 fs/btrfs/ctree.h            |    2 +-
 fs/btrfs/delayed-inode.c    |    4 ++--
 fs/btrfs/disk-io.c          |   34 +++++++++++++++++-----------------
 fs/btrfs/extent-tree.c      |    6 +++---
 fs/btrfs/extent_io.c        |   40 ++++++++++++++++++++--------------------
 fs/btrfs/file-item.c        |    2 +-
 fs/btrfs/free-space-cache.c |    6 +++---
 fs/btrfs/inode.c            |    6 +++---
 fs/btrfs/ioctl.c            |    6 +++---
 fs/btrfs/lzo.c              |    6 +++---
 fs/btrfs/ordered-data.c     |    6 +++---
 fs/btrfs/qgroup.c           |    4 ++--
 fs/btrfs/reada.c            |    4 ++--
 fs/btrfs/root-tree.c        |    2 +-
 fs/btrfs/scrub.c            |   10 +++++-----
 fs/btrfs/super.c            |   12 ++++++------
 18 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1499b27..7cbc5a3 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -128,7 +128,7 @@ static int check_compressed_csum(struct inode *inode,
 		kunmap_atomic(kaddr);
 
 		if (csum != *cb_sum) {
-			printk(KERN_INFO "btrfs csum failed ino %llu "
+			printk(KERN_INFO "btrfs: csum failed ino %llu "
 			       "extent %llu csum %u "
 			       "wanted %u mirror %d\n",
 			       btrfs_ino(inode), disk_start, csum, *cb_sum,
@@ -412,7 +412,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
 		}
 		if (bytes_left < PAGE_CACHE_SIZE) {
-			printk("bytes left %lu compress len %lu nr %lu\n",
+			printk("btrfs: bytes left %lu compress len %lu nr %lu\n",
 			       bytes_left, cb->compressed_len, cb->nr_pages);
 		}
 		bytes_left -= PAGE_CACHE_SIZE;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 316136b..f23c731 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1382,12 +1382,12 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	int ret;
 
 	if (trans->transaction != root->fs_info->running_transaction)
-		WARN(1, KERN_CRIT "trans %llu running %llu\n",
+		WARN(1, KERN_CRIT "btrfs: trans %llu running %llu\n",
 		       trans->transid,
 		       root->fs_info->running_transaction->transid);
 
 	if (trans->transid != root->fs_info->generation)
-		WARN(1, KERN_CRIT "trans %llu running %llu\n",
+		WARN(1, KERN_CRIT "btrfs: trans %llu running %llu\n",
 		       trans->transid, root->fs_info->generation);
 
 	if (!should_cow_block(trans, root, buf)) {
@@ -3362,7 +3362,7 @@ noinline int btrfs_leaf_free_space(struct btrfs_root *root,
 	int ret;
 	ret = BTRFS_LEAF_DATA_SIZE(root) - leaf_space_used(leaf, 0, nritems);
 	if (ret < 0) {
-		printk(KERN_CRIT "leaf free space ret %d, leaf data size %lu, "
+		printk(KERN_CRIT "btrfs: leaf free space ret %d, leaf data size %lu, "
 		       "used %d nritems %d\n",
 		       ret, (unsigned long) BTRFS_LEAF_DATA_SIZE(root),
 		       leaf_space_used(leaf, 0, nritems), nritems);
@@ -3676,7 +3676,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 
 	/* fixup right node */
 	if (push_items > right_nritems)
-		WARN(1, KERN_CRIT "push items %d nr %u\n", push_items,
+		WARN(1, KERN_CRIT "btrfs: push items %d nr %u\n", push_items,
 		       right_nritems);
 
 	if (push_items < right_nritems) {
@@ -4432,7 +4432,7 @@ void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	BUG_ON(slot < 0);
 	if (slot >= nritems) {
 		btrfs_print_leaf(root, leaf);
-		printk(KERN_CRIT "slot %d too large, nritems %d\n",
+		printk(KERN_CRIT "btrfs: slot %d too large, nritems %d\n",
 		       slot, nritems);
 		BUG_ON(1);
 	}
@@ -4495,7 +4495,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 
 	if (btrfs_leaf_free_space(root, leaf) < total_size) {
 		btrfs_print_leaf(root, leaf);
-		printk(KERN_CRIT "not enough freespace need %u have %d\n",
+		printk(KERN_CRIT "btrfs: not enough freespace need %u have %d\n",
 		       total_size, btrfs_leaf_free_space(root, leaf));
 		BUG();
 	}
@@ -4505,7 +4505,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 
 		if (old_data < data_end) {
 			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d old_data %d data_end %d\n",
+			printk(KERN_CRIT "btrfs: slot %d old_data %d data_end %d\n",
 			       slot, old_data, data_end);
 			BUG_ON(1);
 		}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f013a31..8d88818 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3816,7 +3816,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 
 static inline void assfail(char *expr, char *file, int line)
 {
-	printk(KERN_ERR "BTRFS assertion failed: %s, file: %s, line: %d",
+	printk(KERN_ERR "btrfs: assertion failed: %s, file: %s, line: %d",
 	       expr, file, line);
 	BUG();
 }
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 8d292fb..9de9e1c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1472,7 +1472,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&delayed_node->mutex);
 	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "err add delayed dir index item(name: %.*s) "
+		printk(KERN_ERR "btrfs: err add delayed dir index item(name: %.*s) "
 				"into the insertion tree of the delayed node"
 				"(root id: %llu, inode id: %llu, errno: %d)\n",
 				name_len, name, delayed_node->root->objectid,
@@ -1544,7 +1544,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&node->mutex);
 	ret = __btrfs_add_delayed_deletion_item(node, item);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "err add delayed dir index item(index: %llu) "
+		printk(KERN_ERR "btrfs: err add delayed dir index item(index: %llu) "
 				"into the deletion tree of the delayed node"
 				"(root id: %llu, inode id: %llu, errno: %d)\n",
 				index, node->root->objectid, node->inode_id,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4c4ed0b..9891bf3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -342,7 +342,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		ret = 0;
 		goto out;
 	}
-	printk_ratelimited("parent transid verify failed on %llu wanted %llu "
+	printk_ratelimited("btrfs: parent transid verify failed on %llu wanted %llu "
 		       "found %llu\n",
 		       eb->start, parent_transid, btrfs_header_generation(eb));
 	ret = 1;
@@ -600,14 +600,14 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		printk_ratelimited(KERN_INFO "btrfs bad tree block start "
+		printk_ratelimited(KERN_INFO "btrfs: bad tree block start "
 			       "%llu %llu\n",
 			       found_start, eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	if (check_tree_block_fsid(root, eb)) {
-		printk_ratelimited(KERN_INFO "btrfs bad fsid on block %llu\n",
+		printk_ratelimited(KERN_INFO "btrfs: bad fsid on block %llu\n",
 			       eb->start);
 		ret = -EIO;
 		goto err;
@@ -1010,7 +1010,7 @@ static void btree_invalidatepage(struct page *page, unsigned int offset,
 	extent_invalidatepage(tree, page, offset);
 	btree_releasepage(page, GFP_NOFS);
 	if (PagePrivate(page)) {
-		printk(KERN_WARNING "btrfs warning page private not zero "
+		printk(KERN_WARNING "btrfs: warning page private not zero "
 		       "on page %llu\n", (unsigned long long)page_offset(page));
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
@@ -2391,7 +2391,7 @@ int open_ctree(struct super_block *sb,
 	features = btrfs_super_incompat_flags(disk_super) &
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
-		printk(KERN_ERR "BTRFS: couldn't mount because of "
+		printk(KERN_ERR "btrfs: couldn't mount because of "
 		       "unsupported optional features (%Lx).\n",
 		       features);
 		err = -EINVAL;
@@ -2400,7 +2400,7 @@ int open_ctree(struct super_block *sb,
 
 	if (btrfs_super_leafsize(disk_super) !=
 	    btrfs_super_nodesize(disk_super)) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
+		printk(KERN_ERR "btrfs: couldn't mount because metadata "
 		       "blocksizes don't match.  node %d leaf %d\n",
 		       btrfs_super_nodesize(disk_super),
 		       btrfs_super_leafsize(disk_super));
@@ -2408,7 +2408,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 	if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
+		printk(KERN_ERR "btrfs: couldn't mount because metadata "
 		       "blocksize (%d) was too large\n",
 		       btrfs_super_leafsize(disk_super));
 		err = -EINVAL;
@@ -2429,7 +2429,7 @@ int open_ctree(struct super_block *sb,
 	 */
 	if (btrfs_super_leafsize(disk_super) > PAGE_CACHE_SIZE) {
 		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			printk(KERN_INFO "btrfs flagging fs with big metadata feature\n");
+			printk(KERN_INFO "btrfs: flagging fs with big metadata feature\n");
 		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
 	}
 
@@ -2461,7 +2461,7 @@ int open_ctree(struct super_block *sb,
 	features = btrfs_super_compat_ro_flags(disk_super) &
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
+		printk(KERN_ERR "btrfs: couldn't mount RDWR because of "
 		       "unsupported option features (%Lx).\n",
 		       features);
 		err = -EINVAL;
@@ -2745,13 +2745,13 @@ retry_root_backup:
 
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
-		printk(KERN_ERR "Failed to initial space info: %d\n", ret);
+		printk(KERN_ERR "btrfs: Failed to initial space info: %d\n", ret);
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_read_block_groups(extent_root);
 	if (ret) {
-		printk(KERN_ERR "Failed to read block groups: %d\n", ret);
+		printk(KERN_ERR "btrfs: Failed to read block groups: %d\n", ret);
 		goto fail_block_groups;
 	}
 	fs_info->num_tolerated_disk_barrier_failures =
@@ -2760,7 +2760,7 @@ retry_root_backup:
 	     fs_info->num_tolerated_disk_barrier_failures &&
 	    !(sb->s_flags & MS_RDONLY)) {
 		printk(KERN_WARNING
-		       "Btrfs: too many missing devices, writeable mount is not allowed\n");
+		       "btrfs: too many missing devices, writeable mount is not allowed\n");
 		goto fail_block_groups;
 	}
 
@@ -2778,7 +2778,7 @@ retry_root_backup:
 	if (!btrfs_test_opt(tree_root, SSD) &&
 	    !btrfs_test_opt(tree_root, NOSSD) &&
 	    !fs_info->fs_devices->rotating) {
-		printk(KERN_INFO "Btrfs detected SSD devices, enabling SSD "
+		printk(KERN_INFO "btrfs: detected SSD devices, enabling SSD "
 		       "mode\n");
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
@@ -2804,7 +2804,7 @@ retry_root_backup:
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
 		if (fs_devices->rw_devices == 0) {
-			printk(KERN_WARNING "Btrfs log replay required "
+			printk(KERN_WARNING "btrfs: log replay required "
 			       "on RO media\n");
 			err = -EIO;
 			goto fail_qgroup;
@@ -3000,7 +3000,7 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 		struct btrfs_device *device = (struct btrfs_device *)
 			bh->b_private;
 
-		printk_ratelimited_in_rcu(KERN_WARNING "lost page write due to "
+		printk_ratelimited_in_rcu(KERN_WARNING "btrfs: lost page write due to "
 					  "I/O error on %s\n",
 					  rcu_str_deref(device->name));
 		/* note, we dont' set_buffer_write_io_error because we have
@@ -3674,7 +3674,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	root = BTRFS_I(buf->pages[0]->mapping->host)->root;
 	btrfs_assert_tree_locked(buf);
 	if (transid != root->fs_info->generation)
-		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
+		WARN(1, KERN_CRIT "btrfs: transid mismatch buffer %llu, "
 		       "found %llu running %llu\n",
 			buf->start, transid, root->fs_info->generation);
 	was_dirty = set_extent_buffer_dirty(buf);
@@ -3824,7 +3824,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	spin_lock(&delayed_refs->lock);
 	if (delayed_refs->num_entries == 0) {
 		spin_unlock(&delayed_refs->lock);
-		printk(KERN_INFO "delayed_refs has NO entry\n");
+		printk(KERN_INFO "btrfs: delayed_refs has NO entry\n");
 		return ret;
 	}
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 42f1c8e..24212fd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6591,12 +6591,12 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 	int index = 0;
 
 	spin_lock(&info->lock);
-	printk(KERN_INFO "space_info %llu has %llu free, is %sfull\n",
+	printk(KERN_INFO "btrfs: space_info %llu has %llu free, is %sfull\n",
 	       info->flags,
 	       info->total_bytes - info->bytes_used - info->bytes_pinned -
 	       info->bytes_reserved - info->bytes_readonly,
 	       (info->full) ? "" : "not ");
-	printk(KERN_INFO "space_info total=%llu, used=%llu, pinned=%llu, "
+	printk(KERN_INFO "btrfs: space_info total=%llu, used=%llu, pinned=%llu, "
 	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
 	       info->total_bytes, info->bytes_used, info->bytes_pinned,
 	       info->bytes_reserved, info->bytes_may_use,
@@ -6610,7 +6610,7 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 again:
 	list_for_each_entry(cache, &info->block_groups[index], list) {
 		spin_lock(&cache->lock);
-		printk(KERN_INFO "block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %s\n",
+		printk(KERN_INFO "btrfs: block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %s\n",
 		       cache->key.objectid, cache->key.offset,
 		       btrfs_block_group_used(&cache->item), cache->pinned,
 		       cache->reserved, cache->ro ? "[readonly]" : "");
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 856bc2b..3c8696a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -59,7 +59,7 @@ void btrfs_leak_debug_check(void)
 
 	while (!list_empty(&states)) {
 		state = list_entry(states.next, struct extent_state, leak_list);
-		printk(KERN_ERR "btrfs state leak: start %llu end %llu "
+		printk(KERN_ERR "btrfs: state leak: start %llu end %llu "
 		       "state %lu in tree %p refs %d\n",
 		       state->start, state->end, state->state, state->tree,
 		       atomic_read(&state->refs));
@@ -69,7 +69,7 @@ void btrfs_leak_debug_check(void)
 
 	while (!list_empty(&buffers)) {
 		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
-		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
+		printk(KERN_ERR "btrfs: buffer leak start %llu len %lu "
 		       "refs %d\n",
 		       eb->start, eb->len, atomic_read(&eb->refs));
 		list_del(&eb->leak_list);
@@ -390,7 +390,7 @@ static int insert_state(struct extent_io_tree *tree,
 	struct rb_node *node;
 
 	if (end < start)
-		WARN(1, KERN_ERR "btrfs end < start %llu %llu\n",
+		WARN(1, KERN_ERR "btrfs: end < start %llu %llu\n",
 		       end, start);
 	state->start = start;
 	state->end = end;
@@ -401,7 +401,7 @@ static int insert_state(struct extent_io_tree *tree,
 	if (node) {
 		struct extent_state *found;
 		found = rb_entry(node, struct extent_state, rb_node);
-		printk(KERN_ERR "btrfs found node %llu %llu on insert of "
+		printk(KERN_ERR "btrfs: found node %llu %llu on insert of "
 		       "%llu %llu\n",
 		       found->start, found->end, start, end);
 		return -EEXIST;
@@ -2021,7 +2021,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 		return -EIO;
 	}
 
-	printk_ratelimited_in_rcu(KERN_INFO "btrfs read error corrected: ino %lu off %llu "
+	printk_ratelimited_in_rcu(KERN_INFO "btrfs: read error corrected: ino %lu off %llu "
 		      "(dev %s sector %llu)\n", page->mapping->host->i_ino,
 		      start, rcu_str_deref(dev->name), sector);
 
@@ -2080,7 +2080,7 @@ static int clean_io_failure(u64 start, struct page *page)
 
 	if (failrec->in_validation) {
 		/* there was no real error, just free the record */
-		pr_debug("clean_io_failure: freeing dummy error at %llu\n",
+		pr_debug("btrfs: clean_io_failure: freeing dummy error at %llu\n",
 			 failrec->start);
 		did_repair = 1;
 		goto out;
@@ -2179,7 +2179,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 			extent_set_compress_type(&failrec->bio_flags,
 						 em->compress_type);
 		}
-		pr_debug("bio_readpage_error: (new) logical=%llu, start=%llu, "
+		pr_debug("btrfs: bio_readpage_error: (new) logical=%llu, start=%llu, "
 			 "len=%llu\n", logical, start, failrec->len);
 		failrec->logical = logical;
 		free_extent_map(em);
@@ -2200,7 +2200,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		}
 	} else {
 		failrec = (struct io_failure_record *)(unsigned long)private;
-		pr_debug("bio_readpage_error: (found) logical=%llu, "
+		pr_debug("btrfs: bio_readpage_error: (found) logical=%llu, "
 			 "start=%llu, len=%llu, validation=%d\n",
 			 failrec->logical, failrec->start, failrec->len,
 			 failrec->in_validation);
@@ -2218,7 +2218,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		 * all the retry and error correction code that follows. no
 		 * matter what the error is, it is very likely to persist.
 		 */
-		pr_debug("bio_readpage_error: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
+		pr_debug("btrfs: bio_readpage_error: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
 			 num_copies, failrec->this_mirror, failed_mirror);
 		free_io_failure(inode, failrec, 0);
 		return -EIO;
@@ -2261,7 +2261,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	}
 
 	if (failrec->this_mirror > num_copies) {
-		pr_debug("bio_readpage_error: (fail) num_copies=%d, next_mirror %d, failed_mirror %d\n",
+		pr_debug("btrfs: bio_readpage_error: (fail) num_copies=%d, next_mirror %d, failed_mirror %d\n",
 			 num_copies, failrec->this_mirror, failed_mirror);
 		free_io_failure(inode, failrec, 0);
 		return -EIO;
@@ -2292,7 +2292,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 
 	bio_add_page(bio, page, failrec->len, start - page_offset(page));
 
-	pr_debug("bio_readpage_error: submitting new read[%#x] to "
+	pr_debug("btrfs: bio_readpage_error: submitting new read[%#x] to "
 		 "this_mirror=%d, num_copies=%d, in_validation=%d\n", read_mode,
 		 failrec->this_mirror, num_copies, failrec->in_validation);
 
@@ -2352,7 +2352,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
 		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE)
-			printk("%s page write in btrfs with offset %u and length %u\n",
+			printk("btrfs: %s page write in btrfs with offset %u and length %u\n",
 			       bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE
 			       ? KERN_ERR "partial" : KERN_INFO "incomplete",
 			       bvec->bv_offset, bvec->bv_len);
@@ -2418,7 +2418,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
 
-		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
+		pr_debug("btrfs: end_bio_extent_readpage: bi_sector=%llu, err=%d, "
 			 "mirror=%lu\n", (u64)bio->bi_sector, err,
 			 io_bio->mirror_num);
 		tree = &BTRFS_I(inode)->io_tree;
@@ -2429,7 +2429,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
 		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE)
-			printk("%s page read in btrfs with offset %u and length %u\n",
+			printk("btrfs: %s page read in btrfs with offset %u and length %u\n",
 			       bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE
 			       ? KERN_ERR "partial" : KERN_INFO "incomplete",
 			       bvec->bv_offset, bvec->bv_len);
@@ -3292,7 +3292,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 			set_range_writeback(tree, cur, cur + iosize - 1);
 			if (!PageWriteback(page)) {
-				printk(KERN_ERR "btrfs warning page %lu not "
+				printk(KERN_ERR "btrfs: warning page %lu not "
 				       "writeback, cur %llu end %llu\n",
 				       page->index, cur, end);
 			}
@@ -4936,7 +4936,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	}
 
 	if (start + min_len > eb->len) {
-		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
+		WARN(1, KERN_ERR "btrfs: bad mapping eb start %llu len %lu, "
 		       "wanted %lu %lu\n",
 		       eb->start, eb->len, start, min_len);
 		return -EINVAL;
@@ -5117,12 +5117,12 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	unsigned long src_i;
 
 	if (src_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
+		printk(KERN_ERR "btrfs: memmove bogus src_offset %lu move "
 		       "len %lu dst len %lu\n", src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus dst_offset %lu move "
+		printk(KERN_ERR "btrfs: memmove bogus dst_offset %lu move "
 		       "len %lu dst len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
@@ -5164,12 +5164,12 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	unsigned long src_i;
 
 	if (src_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
+		printk(KERN_ERR "btrfs: memmove bogus src_offset %lu move "
 		       "len %lu len %lu\n", src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus dst_offset %lu move "
+		printk(KERN_ERR "btrfs: memmove bogus dst_offset %lu move "
 		       "len %lu len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 6f38488..cfa4029 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -246,7 +246,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 						offset + bvec->bv_len - 1,
 						EXTENT_NODATASUM, GFP_NOFS);
 				} else {
-					printk(KERN_INFO "btrfs no csum found "
+					printk(KERN_INFO "btrfs: no csum found "
 					       "for inode %llu start %llu\n",
 					       btrfs_ino(inode), offset);
 				}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7008868..0dc9b2c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2013,13 +2013,13 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (info->bytes >= bytes && !block_group->ro)
 			count++;
-		printk(KERN_CRIT "entry offset %llu, bytes %llu, bitmap %s\n",
+		printk(KERN_CRIT "btrfs: entry offset %llu, bytes %llu, bitmap %s\n",
 		       info->offset, info->bytes,
 		       (info->bitmap) ? "yes" : "no");
 	}
-	printk(KERN_INFO "block group has cluster?: %s\n",
+	printk(KERN_INFO "btrfs: block group has cluster?: %s\n",
 	       list_empty(&block_group->cluster_list) ? "no" : "yes");
-	printk(KERN_INFO "%d blocks of free space at or bigger than bytes is"
+	printk(KERN_INFO "btrfs: %d blocks of free space at or bigger than bytes is"
 	       "\n", count);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f167ced..a2218e7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2026,7 +2026,7 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 		if (PTR_ERR(root) == -ENOENT)
 			return 0;
 		WARN_ON(1);
-		pr_debug("inum=%llu, offset=%llu, root_id=%llu\n",
+		pr_debug("btrfs: inum=%llu, offset=%llu, root_id=%llu\n",
 			 inum, offset, root_id);
 		return PTR_ERR(root);
 	}
@@ -6142,7 +6142,7 @@ next:
 				    extent_map_end(em) - 1, NULL, GFP_NOFS);
 		goto insert;
 	} else {
-		WARN(1, KERN_ERR "btrfs unknown found_type %d\n", found_type);
+		WARN(1, KERN_ERR "btrfs: unknown found_type %d\n", found_type);
 	}
 not_found:
 	em->start = start;
@@ -6912,7 +6912,7 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 	struct btrfs_dio_private *dip = bio->bi_private;
 
 	if (err) {
-		printk(KERN_ERR "btrfs direct IO failed ino %llu rw %lu "
+		printk(KERN_ERR "btrfs: direct IO failed ino %llu rw %lu "
 		      "sector %#Lx len %u err no %d\n",
 		      btrfs_ino(dip->inode), bio->bi_rw,
 		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1d04b55..8773deb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1905,7 +1905,7 @@ static noinline int search_ioctl(struct inode *inode,
 		key.offset = (u64)-1;
 		root = btrfs_read_fs_root_no_name(info, &key);
 		if (IS_ERR(root)) {
-			printk(KERN_ERR "could not find root %llu\n",
+			printk(KERN_ERR "btrfs: could not find root %llu\n",
 			       sk->tree_id);
 			btrfs_free_path(path);
 			return -ENOENT;
@@ -1995,7 +1995,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	key.offset = (u64)-1;
 	root = btrfs_read_fs_root_no_name(info, &key);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "could not find root %llu\n", tree_id);
+		printk(KERN_ERR "btrfs: could not find root %llu\n", tree_id);
 		ret = -ENOENT;
 		goto out;
 	}
@@ -3337,7 +3337,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
 		btrfs_end_transaction(trans, root);
-		printk(KERN_ERR "Umm, you don't have the default dir item, "
+		printk(KERN_ERR "btrfs: Umm, you don't have the default dir item, "
 		       "this isn't going to work\n");
 		ret = -ENOENT;
 		goto out;
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index b6a6f07..6596b0a 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -141,7 +141,7 @@ static int lzo_compress_pages(struct list_head *ws,
 		ret = lzo1x_1_compress(data_in, in_len, workspace->cbuf,
 				       &out_len, workspace->mem);
 		if (ret != LZO_E_OK) {
-			printk(KERN_DEBUG "btrfs deflate in loop returned %d\n",
+			printk(KERN_DEBUG "btrfs: deflate in loop returned %d\n",
 			       ret);
 			ret = -1;
 			goto out;
@@ -357,7 +357,7 @@ cont:
 		if (need_unmap)
 			kunmap(pages_in[page_in_index - 1]);
 		if (ret != LZO_E_OK) {
-			printk(KERN_WARNING "btrfs decompress failed\n");
+			printk(KERN_WARNING "btrfs: decompress failed\n");
 			ret = -1;
 			break;
 		}
@@ -401,7 +401,7 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	out_len = PAGE_CACHE_SIZE;
 	ret = lzo1x_decompress_safe(data_in, in_len, workspace->buf, &out_len);
 	if (ret != LZO_E_OK) {
-		printk(KERN_WARNING "btrfs decompress failed!\n");
+		printk(KERN_WARNING "btrfs: decompress failed!\n");
 		ret = -1;
 		goto out;
 	}
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 25a8f38..b855c23 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -336,12 +336,12 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 		      entry->len);
 	*file_offset = dec_end;
 	if (dec_start > dec_end) {
-		printk(KERN_CRIT "bad ordering dec_start %llu end %llu\n",
+		printk(KERN_CRIT "btrfs: bad ordering dec_start %llu end %llu\n",
 		       dec_start, dec_end);
 	}
 	to_dec = dec_end - dec_start;
 	if (to_dec > entry->bytes_left) {
-		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
+		printk(KERN_CRIT "btrfs: bad ordered accounting left %llu size %llu\n",
 		       entry->bytes_left, to_dec);
 	}
 	entry->bytes_left -= to_dec;
@@ -401,7 +401,7 @@ have_entry:
 	}
 
 	if (io_size > entry->bytes_left) {
-		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
+		printk(KERN_CRIT "btrfs: bad ordered accounting left %llu size %llu\n",
 		       entry->bytes_left, io_size);
 	}
 	entry->bytes_left -= io_size;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e6ef49..2fa3792 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1161,7 +1161,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 				       limit->rsv_excl);
 	if (ret) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-		printk(KERN_INFO "unable to update quota limit for %llu\n",
+		printk(KERN_INFO "btrfs: unable to update quota limit for %llu\n",
 		       qgroupid);
 	}
 
@@ -1871,7 +1871,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 					 &fs_info->qgroup_rescan_progress,
 					 path, 1, 0);
 
-	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
+	pr_debug("btrfs: current progress key (%llu %u %llu), search_slot ret %d\n",
 		 fs_info->qgroup_rescan_progress.objectid,
 		 fs_info->qgroup_rescan_progress.type,
 		 fs_info->qgroup_rescan_progress.offset, ret);
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 1031b69..06a519f 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -189,7 +189,7 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 			 */
 #ifdef DEBUG
 			if (rec->generation != generation) {
-				printk(KERN_DEBUG "generation mismatch for "
+				printk(KERN_DEBUG "btrfs: generation mismatch for "
 						"(%llu,%d,%llu) %llu != %llu\n",
 				       key.objectid, key.type, key.offset,
 				       rec->generation, generation);
@@ -365,7 +365,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		goto error;
 
 	if (bbio->num_stripes > BTRFS_MAX_MIRRORS) {
-		printk(KERN_ERR "btrfs readahead: more than %d copies not "
+		printk(KERN_ERR "btrfs: readahead: more than %d copies not "
 				"supported", BTRFS_MAX_MIRRORS);
 		goto error;
 	}
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ec71ea4..5f9b8fa 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -154,7 +154,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
-		printk(KERN_CRIT "unable to update root key %llu %u %llu\n",
+		printk(KERN_CRIT "btrfs: unable to update root key %llu %u %llu\n",
 		       key->objectid, key->type, key->offset);
 		BUG_ON(1);
 	}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2544805..4ad2d48 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2458,7 +2458,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			if (key.objectid < logical &&
 			    (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
 				printk(KERN_ERR
-				       "btrfs scrub: tree block %llu spanning "
+				       "btrfs: scrub: tree block %llu spanning "
 				       "stripes, ignored. logical=%llu\n",
 				       key.objectid, logical);
 				goto next;
@@ -2842,7 +2842,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	 */
 	if (fs_info->chunk_root->nodesize != fs_info->chunk_root->leafsize) {
 		printk(KERN_ERR
-		       "btrfs_scrub: size assumption nodesize == leafsize (%d == %d) fails\n",
+		       "btrfs: scrub: size assumption nodesize == leafsize (%d == %d) fails\n",
 		       fs_info->chunk_root->nodesize,
 		       fs_info->chunk_root->leafsize);
 		return -EINVAL;
@@ -2855,7 +2855,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		 * situation at all because it won't ever happen.
 		 */
 		printk(KERN_ERR
-		       "btrfs_scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails\n",
+		       "btrfs: scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails\n",
 		       fs_info->chunk_root->nodesize, BTRFS_STRIPE_LEN);
 		return -EINVAL;
 	}
@@ -2863,7 +2863,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (fs_info->chunk_root->sectorsize != PAGE_SIZE) {
 		/* not supported for data w/o checksums */
 		printk(KERN_ERR
-		       "btrfs_scrub: size assumption sectorsize != PAGE_SIZE (%d != %lu) fails\n",
+		       "btrfs: scrub: size assumption sectorsize != PAGE_SIZE (%d != %lu) fails\n",
 		       fs_info->chunk_root->sectorsize, PAGE_SIZE);
 		return -EINVAL;
 	}
@@ -2876,7 +2876,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		 * would exhaust the array bounds of pagev member in
 		 * struct scrub_block
 		 */
-		pr_err("btrfs_scrub: size assumption nodesize and sectorsize <= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails\n",
+		pr_err("btrfs: scrub: size assumption nodesize and sectorsize <= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails\n",
 		       fs_info->chunk_root->nodesize,
 		       SCRUB_MAX_PAGES_PER_BLOCK,
 		       fs_info->chunk_root->sectorsize,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e87baf6..f63ca69 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -152,11 +152,11 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: errno=%d %s (%pV)\n",
+		printk(KERN_CRIT "btrfs: error (device %s) in %s:%d: errno=%d %s (%pV)\n",
 			sb->s_id, function, line, errno, errstr, &vaf);
 		va_end(args);
 	} else {
-		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: errno=%d %s\n",
+		printk(KERN_CRIT "btrfs: error (device %s) in %s:%d: errno=%d %s\n",
 			sb->s_id, function, line, errno, errstr);
 	}
 
@@ -201,7 +201,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
+	printk("%sbtrfs: %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
 
 	va_end(args);
 }
@@ -291,10 +291,10 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 
 	errstr = btrfs_decode_error(errno);
 	if (fs_info && (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR))
-		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
+		panic(KERN_CRIT "btrfs: panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
 			s_id, function, line, &vaf, errno, errstr);
 
-	printk(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
+	printk(KERN_CRIT "btrfs: panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
 	       s_id, function, line, &vaf, errno, errstr);
 	va_end(args);
 	/* Caller calls BUG() */
@@ -1360,7 +1360,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		     fs_info->num_tolerated_disk_barrier_failures &&
 		    !(*flags & MS_RDONLY)) {
 			printk(KERN_WARNING
-			       "Btrfs: too many missing devices, writeable remount is not allowed\n");
+			       "btrfs: too many missing devices, writeable remount is not allowed\n");
 			ret = -EACCES;
 			goto restore;
 		}
-- 
1.7.9.5

