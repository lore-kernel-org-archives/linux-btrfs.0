Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833300;
	b=eAPiuXajN6iLgQgrSx+bsbpxqJ+4gQw5MiXlOI/xt2vww2dbv4gF34EhqgAYqk5vxcCa
	 NEJXI44FdIsUtuNfH122I9tSLeJBM/rlW4AgsOfYTAl2/bfcZmZ6Qa/59EN6mpARiBbMA
	 PbFBzA1A3Chfj8sHdk/aFTcv8oPMw/lqhV/DbOLFE6ItMdl2O/Hd/6vO2kemLYPDNKN24
	 T9lfTyWYetDzKhAHnOO9GdMdrcpWX2XJGwtJZiJCv0kAfgi0543deErLpnxzzxPuMohlB
	 3Oul23hXcD4931DQAfqOAL3GLz2C+eRneHs1chqWwyKLB93QEDOh87GE3ccEC0Is85w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833300;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=agYUkA7wmbp4Lg5U9FpfwG8NB5pa66bxeh/7aJrjuIE=;
	b=qGk+eMI4CWt7E92i1ka0GiKuIStcTC5IIxd0ILdueF0dX2FWFQC6Q29XN1cYfYawF4nI
	 gYkgq6Tq82fGIo5qiLbIiFoz1UL1dvlXRvKQRDwl16OPaNLvr9Wazi07rkawyoc6VGot0
	 Iqit4RLK+IvNC4ggIyxmnkp+fgrbr/YLxj9qtek6Sg/oKhqviZf4YVwIV9XceGXXVOZK3
	 LF1MaiD4VGGUklbqhx/kQiwANGkFS6/8BN49ho8afRcsKQ4iPpS6qNUJ3rvxZmR61drqj
	 exUrB4XegWQ8LdUQUtPWC/WXgdjtPd/vG7XksvF0xXiu9UOD8+uXzxFAr8vgPG4EllQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqQEfiZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7589606A329
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqQEfiZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07E31F000C4
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833300;
	bh=agYUkA7wmbp4Lg5U9FpfwG8NB5pa66bxeh/7aJrjuIE=;
	h=From:To:Subject:Date;
	b=dqQEfiZEDEnvz+3xs6G9PPZX5aOyS8l8njQTsxW/XaUrSYj7ThuXk2Vxum4AjhCZf
	 tCfq2E9AGmuWxyFhVS6gR+6QYD7FgLqDVlqTiBIQdC5jU5bWPzR2IqSccqmr2F6tll
	 kU6RHMyP675GdnHy9/xLGubcQLNbxBN8snBe2GcMnjQhzxCi4KnCgcf6A6WDk7GCmC
	 g/7cGBSXBvyzwtNoDu1DRtsiJeJZ17V3BUaRXOo9TdU+uMJeQjsaJ+1LxoYl+sls/q
	 au3NTXbUr0d4Z5oyHF/QPhNfx10G7dO0twqIZCUZFOVPnvJnJCgGe3Q82+Ms65ZpU3
	 aGNotM4d/MdJA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add missing unlikely tag to branches leading to transaction aborts
Date: Mon, 16 Nov 2026 12:48:17 +0000
Message-ID: <df971dad64e73d71fe7e9bd9188efe5f22e9bea4.1794833257.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We have a few branches that lead to transaction aborts that are missing
the unlikely tag, so add it to them as these are unexpected scenarios.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c      | 10 +++++-----
 fs/btrfs/ctree.c            |  2 +-
 fs/btrfs/delayed-inode.c    |  2 +-
 fs/btrfs/extent-tree.c      | 10 +++++-----
 fs/btrfs/file.c             |  6 +++---
 fs/btrfs/free-space-cache.c |  2 +-
 fs/btrfs/free-space-tree.c  |  6 +++---
 fs/btrfs/inode.c            | 14 +++++++-------
 fs/btrfs/qgroup.c           |  4 ++--
 fs/btrfs/raid-stripe-tree.c |  4 ++--
 fs/btrfs/relocation.c       | 14 +++++++-------
 fs/btrfs/tree-log.c         | 10 +++++-----
 fs/btrfs/xattr.c            |  4 ++--
 13 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 0b3b8843d221..a40eedc65dd2 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2929,19 +2929,19 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 		index = btrfs_bg_flags_to_raid_index(block_group->flags);
 
 		ret = insert_block_group_item(trans, block_group);
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
 		if (!test_bit(BLOCK_GROUP_FLAG_CHUNK_ITEM_INSERTED,
 			      &block_group->runtime_flags)) {
 			mutex_lock(&fs_info->chunk_mutex);
 			ret = btrfs_chunk_alloc_add_chunk_item(trans, block_group);
 			mutex_unlock(&fs_info->chunk_mutex);
-			if (ret)
+			if (unlikely(ret))
 				btrfs_abort_transaction(trans, ret);
 		}
 		ret = insert_dev_extents(trans, block_group->start,
 					 block_group->length);
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
 		btrfs_add_block_group_free_space(trans, block_group);
 
@@ -3443,7 +3443,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 				drop_reserve = false;
 			}
 			spin_unlock(&cur_trans->dirty_bgs_lock);
-		} else if (ret) {
+		} else if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 		}
 
@@ -3513,7 +3513,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 			ret = btrfs_run_delayed_refs(trans, U64_MAX);
 		if (!ret) {
 			ret = update_block_group_item(trans, path, cache);
-			if (ret)
+			if (unlikely(ret))
 				btrfs_abort_transaction(trans, ret);
 		}
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index fef0e49dd918..a70860bfd109 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4468,7 +4468,7 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 	refcount_inc(&leaf->refs);
 	ret = btrfs_free_tree_block(trans, btrfs_root_id(root), leaf, 0, 1);
 	free_extent_buffer_stale(leaf);
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		btrfs_abort_transaction(trans, ret);
 
 	return ret;
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 295329d67b21..36efeda1644a 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1076,7 +1076,7 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	 * in the same item doesn't exist.
 	 */
 	ret = btrfs_del_item(trans, root, path);
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		btrfs_abort_transaction(trans, ret);
 out:
 	btrfs_release_delayed_iref(node);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b96f3..0008cbc12412 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1568,11 +1568,11 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	/* now insert the actual backref */
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = insert_tree_block_ref(trans, path, node, bytenr);
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
 	} else {
 		ret = insert_extent_data_ref(trans, path, node, bytenr);
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
 	}
 
@@ -3192,7 +3192,7 @@ static int do_free_extent_accounting(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_update_block_group(trans, bytenr, num_bytes, false);
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 
 	return ret;
@@ -4387,7 +4387,7 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 		if (ret == -ENOSPC) {
 			ret = 0;
 			ffe_ctl->loop++;
-		} else if (ret < 0) {
+		} else if (unlikely(ret < 0)) {
 			btrfs_abort_transaction(trans, ret);
 		} else {
 			ret = 0;
@@ -6123,7 +6123,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_free_tree_block(trans, btrfs_root_id(root), eb, parent,
 				    wc->refs[level] == 1);
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		btrfs_abort_transaction(trans, ret);
 out:
 	wc->refs[level] = 0;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 83804dc454b8..78af88168f18 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -450,7 +450,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		 */
 		path->slots[0] = del_slot;
 		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
 	}
 
@@ -773,7 +773,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 
 mark_dirty:
 	ret = btrfs_inode_set_file_extent_range(inode, start, end - start);
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 
 	return ret;
@@ -2121,7 +2121,7 @@ static int fill_holes(struct btrfs_trans_handle *trans,
 		btrfs_set_file_extent_generation(leaf, fi, trans->transid);
 		if (del_slot >= 0) {
 			ret = btrfs_del_items(trans, root, path, del_slot, 1);
-			if (ret) {
+			if (unlikely(ret)) {
 				btrfs_abort_transaction(trans, ret);
 				btrfs_release_path(path);
 				return ret;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bff6e5b372d6..c90ba5f6a8bb 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -241,7 +241,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_inode(trans, inode);
 
 fail:
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 
 	return ret;
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index b7a4a6ade30f..1b5e3d5e8fef 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -865,7 +865,7 @@ int btrfs_remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 	mutex_lock(&block_group->free_space_lock);
 	ret = __btrfs_remove_from_free_space_tree(trans, block_group, path, start, size);
 	mutex_unlock(&block_group->free_space_lock);
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 
 	btrfs_put_block_group(block_group);
@@ -1046,7 +1046,7 @@ int btrfs_add_to_free_space_tree(struct btrfs_trans_handle *trans,
 	mutex_lock(&block_group->free_space_lock);
 	ret = __btrfs_add_to_free_space_tree(trans, block_group, path, start, size);
 	mutex_unlock(&block_group->free_space_lock);
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 
 	btrfs_put_block_group(block_group);
@@ -1449,7 +1449,7 @@ static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 
 	ret = __btrfs_add_to_free_space_tree(trans, block_group, path,
 					     block_group->start, block_group->length);
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 
 out:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e68c9871ee1e..4b29b82eb180 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4607,7 +4607,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	inode_inc_iversion(&dir->vfs_inode);
 	inode_set_mtime_to_ts(&dir->vfs_inode, inode_set_ctime_current(&dir->vfs_inode));
 	ret = btrfs_update_inode_fallback(trans, dir);
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 out:
 	fscrypt_free_filename(&fname);
@@ -5213,7 +5213,7 @@ static int maybe_insert_hole(struct btrfs_inode *inode, u64 offset, u64 len)
 	}
 
 	ret = btrfs_insert_hole_extent(trans, root, btrfs_ino(inode), offset, len);
-	if (ret) {
+	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 	} else {
 		btrfs_update_inode_bytes(inode, 0, drop_args.bytes_found);
@@ -6826,7 +6826,7 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 			if (ret)
 				goto discard;
 			ret = btrfs_update_inode(trans, BTRFS_I(inode));
-			if (ret) {
+			if (unlikely(ret)) {
 				btrfs_abort_transaction(trans, ret);
 				goto discard;
 			}
@@ -6910,7 +6910,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	update_time_after_link_or_unlink(parent_inode);
 
 	ret = btrfs_update_inode(trans, parent_inode);
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 	return ret;
 
@@ -6921,13 +6921,13 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 		ret2 = btrfs_del_root_ref(trans, key.objectid, btrfs_root_id(root),
 					  parent_ino, &local_index, name);
-		if (ret2)
+		if (unlikely(ret2))
 			btrfs_abort_transaction(trans, ret2);
 	} else if (add_backref) {
 		int ret2;
 
 		ret2 = btrfs_del_inode_ref(trans, root, name, ino, parent_ino, NULL);
-		if (ret2)
+		if (unlikely(ret2))
 			btrfs_abort_transaction(trans, ret2);
 	}
 
@@ -9280,7 +9280,7 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 			range_end = round_up(i_size, fs_info->sectorsize);
 			ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode),
 					range_start, range_end - range_start);
-			if (ret) {
+			if (unlikely(ret)) {
 				btrfs_abort_transaction(trans, ret);
 				btrfs_end_transaction(trans);
 				break;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index baef546fa213..3127d3fcab31 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1446,7 +1446,7 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	ret = btrfs_free_tree_block(trans, btrfs_root_id(quota_root),
 				    quota_root->node, 0, 1);
 
-	if (ret < 0)
+	if (unlikely(ret < 0))
 		btrfs_abort_transaction(trans, ret);
 
 out:
@@ -1631,7 +1631,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src, u64 dst
 		int ret2;
 
 		ret2 = del_qgroup_relation_item(trans, src, dst);
-		if (ret2 < 0)
+		if (unlikely(ret2 < 0))
 			btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index d9e660447205..1d3d1fa40b20 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -362,9 +362,9 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	if (ret == -EEXIST) {
 		ret = update_raid_extent_item(trans, &stripe_key, stripe_extent,
 					      item_size);
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
-	} else if (ret) {
+	} else if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 	}
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0ccb558daf0c..cdbbf4ba968d 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1760,7 +1760,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 
 	if (ret == 0) {
 		ret = insert_dirty_subvol(trans, rc, root);
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
 	}
 
@@ -3834,7 +3834,7 @@ static void delete_orphan_inode(struct btrfs_trans_handle *trans,
 	}
 	ret = btrfs_del_item(trans, root, path);
 out:
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 }
 
@@ -4445,7 +4445,7 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
 	if (unlikely(ret)) {
 		btrfs_free_reserved_extent(fs_info, dest_addr, dest_length, 0);
 
-		if (trans) {
+		if (unlikely(trans)) {
 			btrfs_abort_transaction(trans, ret);
 			btrfs_end_transaction(trans);
 		}
@@ -5158,26 +5158,26 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 
 	if (bg_needs_free_space) {
 		ret = btrfs_add_block_group_free_space(trans, dest_bg);
-		if (ret) {
+		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
 			goto fail;
 		}
 	}
 
 	ret = copy_remapped_data(fs_info, start, new_addr, length);
-	if (ret) {
+	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
 
 	ret = btrfs_remove_from_free_space_tree(trans, new_addr, length);
-	if (ret) {
+	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
 
 	ret = add_remap_entry(trans, path, src_bg, start, new_addr, length);
-	if (ret) {
+	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 399414ae67c8..763487114f85 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -434,7 +434,7 @@ static int process_one_buffer(struct extent_buffer *eb,
 
 		if (btrfs_buffer_uptodate(eb, gen, NULL) && level == 0) {
 			ret = btrfs_exclude_logged_extents(eb);
-			if (ret)
+			if (unlikely(ret))
 				btrfs_abort_transaction(trans, ret);
 		}
 	}
@@ -2943,7 +2943,7 @@ static int clean_log_buffer(struct btrfs_trans_handle *trans,
 		int ret;
 
 		ret = btrfs_pin_reserved_extent(trans, eb);
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
 		return ret;
 	}
@@ -3019,7 +3019,7 @@ static noinline int walk_down_log_tree(struct btrfs_path *path, int *level,
 			path->slots[*level]++;
 			if (wc->free) {
 				ret = btrfs_read_extent_buffer(next, &check);
-				if (ret) {
+				if (unlikely(ret)) {
 					free_extent_buffer(next);
 					if (trans)
 						btrfs_abort_transaction(trans, ret);
@@ -3038,7 +3038,7 @@ static noinline int walk_down_log_tree(struct btrfs_path *path, int *level,
 			continue;
 		}
 		ret = btrfs_read_extent_buffer(next, &check);
-		if (ret) {
+		if (unlikely(ret)) {
 			free_extent_buffer(next);
 			if (trans)
 				btrfs_abort_transaction(trans, ret);
@@ -3617,7 +3617,7 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 
 	if (log->node) {
 		ret = walk_log_tree(&wc);
-		if (ret) {
+		if (unlikely(ret)) {
 			/*
 			 * We weren't able to traverse the entire log tree, the
 			 * typical scenario is getting an -EIO when reading an
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index cbee10b6b49a..1a71a1472c27 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -260,7 +260,7 @@ int btrfs_setxattr_trans(struct inode *inode, const char *name,
 	inode_inc_iversion(inode);
 	inode_set_ctime_current(inode);
 	ret = btrfs_update_inode(trans, BTRFS_I(inode));
-	if (ret)
+	if (unlikely(ret))
 		btrfs_abort_transaction(trans, ret);
 out:
 	if (start_trans)
@@ -446,7 +446,7 @@ static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
 		inode_inc_iversion(inode);
 		inode_set_ctime_current(inode);
 		ret = btrfs_update_inode(trans, BTRFS_I(inode));
-		if (ret)
+		if (unlikely(ret))
 			btrfs_abort_transaction(trans, ret);
 	}
 
-- 
2.53.0

