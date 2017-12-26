Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33146 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdLZFhp (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 26 Dec 2017 00:37:45 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2.2 04/10] btrfs: qgroup: Use separate meta reservation type for delalloc
Date: Tue, 26 Dec 2017 13:37:27 +0800
Message-Id: <20171226053727.25505-1-wqu@suse.com>
In-Reply-To: <20171222061847.13158-5-wqu@suse.com>
References: <20171222061847.13158-5-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, btrfs qgroup is mixing per-transcation meta rsv with
preallocated meta rsv, making it quite easy to underflow qgroup meta
reservation.

Since we have the new qgroup meta rsv types, apply it to delalloc
reservation.

Now for delalloc, most of its reserved space will use META_PREALLOC qgroup
rsv type.

And for callers reducing outstanding extent like btrfs_finish_ordered_io(),
they will convert corresponding META_PREALLOC reservation to
META_PERTRANS.

This is mainly due to the fact that current qgroup numbers will only be
updated in btrfs_commit_transaction(), that's to say if we don't keep
such placeholder reservation, we can exceed qgroup limitation.

And for callers freeing outstanding extent in error handler, we will
just free META_PREALLOC bytes.

This behavior makes callers of btrfs_qgroup_release_meta() or
btrfs_qgroup_convert_meta() to be aware of which type they are.
So in this patch, btrfs_delalloc_release_metadata() and its callers get
an extra parameter to info qgroup to do correct meta convert/release.

The good news is, even we use the wrong type (convert or free), it won't
cause obvious bug, as prealloc type is always in good shape, and the
type only affects how per-trans meta is increased or not.

So the worst case will be at most metadata limitation can be sometimes
exceeded (no convert at all) or metadata limitation is reached too soon
(no free at all).

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2.2
  Fix the wrong parameter in __btrfs_buffered_write(), where qgroup
  should be freed but not converted.
  Wrongly convert the reserved meta will easily flood the pertrans rsv,
  as each successful buffered write will increase pertrans usage, which
  results too early EDQUOT.
---
 fs/btrfs/ctree.h            |  9 ++++++---
 fs/btrfs/extent-tree.c      | 45 +++++++++++++++++++++++++--------------------
 fs/btrfs/file.c             | 15 ++++++++-------
 fs/btrfs/free-space-cache.c |  2 +-
 fs/btrfs/inode-map.c        |  4 ++--
 fs/btrfs/inode.c            | 27 ++++++++++++++-------------
 fs/btrfs/ioctl.c            | 10 ++++++----
 fs/btrfs/ordered-data.c     |  2 +-
 fs/btrfs/relocation.c       |  9 +++++----
 9 files changed, 68 insertions(+), 55 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bd2bf589e6c8..091c0e06b32e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2728,7 +2728,8 @@ int btrfs_check_data_free_space(struct inode *inode,
 void btrfs_free_reserved_data_space(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct inode *inode,
-			struct extent_changeset *reserved, u64 start, u64 len);
+				  struct extent_changeset *reserved,
+				  u64 start, u64 len, bool qgroup_free);
 void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 					    u64 len);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
@@ -2743,10 +2744,12 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     u64 *qgroup_reserved, bool use_global_rsv);
 void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
-void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
+void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
+				    bool qgroup_free);
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
-void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes);
+void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
+				     bool qgroup_free);
 int btrfs_delalloc_reserve_space(struct inode *inode,
 			struct extent_changeset **reserved, u64 start, u64 len);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 20923fce06c4..986660f301de 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5754,6 +5754,9 @@ int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 	if (num_bytes == 0)
 		return 0;
 
+	ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
+	if (ret)
+		return ret;
 	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
 	if (!ret) {
 		block_rsv_add_bytes(block_rsv, num_bytes, 0);
@@ -5766,11 +5769,16 @@ int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 /**
  * btrfs_inode_rsv_release - release any excessive reservation.
  * @inode - the inode we need to release from.
+ * @qgroup_free - free or convert qgroup meta.
+ *   Unlike normal operation, qgroup meta reservation needs to know if
+ *   we are freeing qgroup reservation or just convert them into per-trans.
+ *   Normally @qgroup_free is true for error handler, and false for normal
+ *   release.
  *
  * This is the same as btrfs_block_rsv_release, except that it handles the
  * tracepoint for the reservation.
  */
-void btrfs_inode_rsv_release(struct btrfs_inode *inode)
+void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
@@ -5786,6 +5794,10 @@ void btrfs_inode_rsv_release(struct btrfs_inode *inode)
 	if (released > 0)
 		trace_btrfs_space_reservation(fs_info, "delalloc",
 					      btrfs_ino(inode), released, 0);
+	if (qgroup_free)
+		btrfs_qgroup_free_meta_prealloc(inode->root, released);
+	else
+		btrfs_qgroup_convert_reserved_meta(inode->root, released);
 }
 
 void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
@@ -6045,7 +6057,6 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
-	struct btrfs_root *root = inode->root;
 	unsigned nr_extents;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
@@ -6083,19 +6094,9 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
-	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-		ret = btrfs_qgroup_reserve_meta_prealloc(root,
-				nr_extents * fs_info->nodesize, true);
-		if (ret)
-			goto out_fail;
-	}
-
 	ret = btrfs_inode_rsv_refill(inode, flush);
-	if (unlikely(ret)) {
-		btrfs_qgroup_free_meta_prealloc(root,
-				       nr_extents * fs_info->nodesize);
+	if (unlikely(ret))
 		goto out_fail;
-	}
 
 	if (delalloc_lock)
 		mutex_unlock(&inode->delalloc_mutex);
@@ -6109,7 +6110,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
-	btrfs_inode_rsv_release(inode);
+	btrfs_inode_rsv_release(inode, true);
 	if (delalloc_lock)
 		mutex_unlock(&inode->delalloc_mutex);
 	return ret;
@@ -6119,12 +6120,14 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
  * btrfs_delalloc_release_metadata - release a metadata reservation for an inode
  * @inode: the inode to release the reservation for.
  * @num_bytes: the number of bytes we are releasing.
+ * @qgroup_free: free qgroup reservation or convert it to per-trans reservation
  *
  * This will release the metadata reservation for an inode.  This can be called
  * once we complete IO for a given set of bytes to release their metadata
  * reservations, or on error for the same reason.
  */
-void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
+void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
+				     bool qgroup_free)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 
@@ -6137,13 +6140,14 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	if (btrfs_is_testing(fs_info))
 		return;
 
-	btrfs_inode_rsv_release(inode);
+	btrfs_inode_rsv_release(inode, qgroup_free);
 }
 
 /**
  * btrfs_delalloc_release_extents - release our outstanding_extents
  * @inode: the inode to balance the reservation for.
  * @num_bytes: the number of bytes we originally reserved with
+ * @qgroup_free: do we need to free qgroup meta reservation or convert them.
  *
  * When we reserve space we increase outstanding_extents for the extents we may
  * add.  Once we've set the range as delalloc or created our ordered extents we
@@ -6151,7 +6155,8 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
  * temporarily tracked outstanding_extents.  This _must_ be used in conjunction
  * with btrfs_delalloc_reserve_metadata.
  */
-void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
+void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
+				    bool qgroup_free)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	unsigned num_extents;
@@ -6165,7 +6170,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 	if (btrfs_is_testing(fs_info))
 		return;
 
-	btrfs_inode_rsv_release(inode);
+	btrfs_inode_rsv_release(inode, qgroup_free);
 }
 
 /**
@@ -6221,9 +6226,9 @@ int btrfs_delalloc_reserve_space(struct inode *inode,
  */
 void btrfs_delalloc_release_space(struct inode *inode,
 				  struct extent_changeset *reserved,
-				  u64 start, u64 len)
+				  u64 start, u64 len, bool qgroup_free)
 {
-	btrfs_delalloc_release_metadata(BTRFS_I(inode), len);
+	btrfs_delalloc_release_metadata(BTRFS_I(inode), len, qgroup_free);
 	btrfs_free_reserved_data_space(inode, reserved, start, len);
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index eb1bac7c8553..3bf186746119 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1690,7 +1690,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				    force_page_uptodate);
 		if (ret) {
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       reserve_bytes);
+						       reserve_bytes, true);
 			break;
 		}
 
@@ -1702,7 +1702,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			if (extents_locked == -EAGAIN)
 				goto again;
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       reserve_bytes);
+						       reserve_bytes, true);
 			ret = extents_locked;
 			break;
 		}
@@ -1737,7 +1737,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 						fs_info->sb->s_blocksize_bits;
 			if (only_release_metadata) {
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-								release_bytes);
+							release_bytes, true);
 			} else {
 				u64 __pos;
 
@@ -1746,7 +1746,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 					(dirty_pages << PAGE_SHIFT);
 				btrfs_delalloc_release_space(inode,
 						data_reserved, __pos,
-						release_bytes);
+						release_bytes, true);
 			}
 		}
 
@@ -1760,7 +1760,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state,
 					     GFP_NOFS);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes,
+					       true);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
 			break;
@@ -1800,11 +1801,11 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		if (only_release_metadata) {
 			btrfs_end_write_no_snapshotting(root);
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
-					release_bytes);
+					release_bytes, true);
 		} else {
 			btrfs_delalloc_release_space(inode, data_reserved,
 					round_down(pos, fs_info->sectorsize),
-					release_bytes);
+					release_bytes, true);
 		}
 	}
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4426d1c73e50..fbd831044a1d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3548,7 +3548,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	if (ret) {
 		if (release_metadata)
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
-					inode->i_size);
+					inode->i_size, true);
 #ifdef DEBUG
 		btrfs_err(fs_info,
 			  "failed to write free ino cache for root %llu",
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 022b19336fee..9409dcc7020d 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -500,12 +500,12 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, true);
 		goto out_put;
 	}
 
 	ret = btrfs_write_out_ino_cache(root, trans, path, inode);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, false);
 out_put:
 	iput(inode);
 out_release:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e1a7f3cb5be9..76a1b4819607 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1839,7 +1839,7 @@ static void btrfs_clear_bit_hook(void *private_data,
 		 */
 		if (*bits & EXTENT_CLEAR_META_RESV &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len);
+			btrfs_delalloc_release_metadata(inode, len, false);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
@@ -2102,7 +2102,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 				  0);
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, false);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			     &cached_state, GFP_NOFS);
@@ -4760,8 +4760,8 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	page = find_or_create_page(mapping, index, mask);
 	if (!page) {
 		btrfs_delalloc_release_space(inode, data_reserved,
-					     block_start, blocksize);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize);
+					     block_start, blocksize, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, true);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4829,8 +4829,8 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 out_unlock:
 	if (ret)
 		btrfs_delalloc_release_space(inode, data_reserved, block_start,
-					     blocksize);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize);
+					     blocksize, true);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, (ret != 0));
 	unlock_page(page);
 	put_page(page);
 out:
@@ -8814,7 +8814,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
 				btrfs_delalloc_release_space(inode, data_reserved,
-					offset, dio_data.reserve);
+					offset, dio_data.reserve, true);
 			/*
 			 * On error we might have left some ordered extents
 			 * without submitting corresponding bios for them, so
@@ -8830,8 +8830,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 					false);
 		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode, data_reserved,
-					offset, count - (size_t)ret);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), count);
+					offset, count - (size_t)ret, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), count, false);
 	}
 out:
 	if (wakeup)
@@ -9150,7 +9150,8 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 		if (reserved_space < PAGE_SIZE) {
 			end = page_start + reserved_space - 1;
 			btrfs_delalloc_release_space(inode, data_reserved,
-					page_start, PAGE_SIZE - reserved_space);
+					page_start, PAGE_SIZE - reserved_space,
+					true);
 		}
 	}
 
@@ -9200,16 +9201,16 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 
 out_unlock:
 	if (!ret) {
-		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
 		sb_end_pagefault(inode->i_sb);
 		extent_changeset_free(data_reserved);
 		return VM_FAULT_LOCKED;
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0));
 	btrfs_delalloc_release_space(inode, data_reserved, page_start,
-				     reserved_space);
+				     reserved_space, (ret != 0));
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	extent_changeset_free(data_reserved);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2ef8acaac688..9c46b89de591 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1198,7 +1198,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode, data_reserved,
 				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT);
+				(page_cnt - i_done) << PAGE_SHIFT, true);
 	}
 
 
@@ -1217,7 +1217,8 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		unlock_page(pages[i]);
 		put_page(pages[i]);
 	}
-	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT,
+				       false);
 	extent_changeset_free(data_reserved);
 	return i_done;
 out:
@@ -1227,8 +1228,9 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	}
 	btrfs_delalloc_release_space(inode, data_reserved,
 			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
+			page_cnt << PAGE_SHIFT, true);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT,
+				       true);
 	extent_changeset_free(data_reserved);
 	return ret;
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5b311aeddcc8..c6f5f7e274a5 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -610,7 +610,7 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	btrfs_mod_outstanding_extents(btrfs_inode, -1);
 	spin_unlock(&btrfs_inode->lock);
 	if (root != fs_info->tree_root)
-		btrfs_delalloc_release_metadata(btrfs_inode, entry->len);
+		btrfs_delalloc_release_metadata(btrfs_inode, entry->len, false);
 
 	tree = &btrfs_inode->ordered_tree;
 	spin_lock_irq(&tree->lock);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f0c3f00e97cb..632129024c5f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3226,7 +3226,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 						   mask);
 			if (!page) {
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-							PAGE_SIZE);
+							PAGE_SIZE, true);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -3245,9 +3245,9 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				unlock_page(page);
 				put_page(page);
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-							PAGE_SIZE);
+							PAGE_SIZE, true);
 				btrfs_delalloc_release_extents(BTRFS_I(inode),
-							       PAGE_SIZE);
+							       PAGE_SIZE, true);
 				ret = -EIO;
 				goto out;
 			}
@@ -3278,7 +3278,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		put_page(page);
 
 		index++;
-		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE,
+					       false);
 		balance_dirty_pages_ratelimited(inode->i_mapping);
 		btrfs_throttle(fs_info);
 	}
-- 
2.15.1

