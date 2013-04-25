Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:40171 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3DYT76 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 15:59:58 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 95C1E7C04E9
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 13:59:57 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id vmifGSCQYhAh3Q0t (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 13:59:56 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: deal with free space cache errors while replaying log
Date: Thu, 25 Apr 2013 15:59:54 -0400
Message-ID: <1366919994-1581-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So everybody who got hit by my fsync bug will still continue to hit this
BUG_ON() in the free space cache, which is pretty heavy handed.  So I took a
file system that had this bug and fixed up all the BUG_ON()'s and leaks that
popped up when I tried to mount a broken file system like this.  With this patch
we just fail to mount instead of panicing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c      |   24 +++++++++-------
 fs/btrfs/free-space-cache.c |    4 +-
 fs/btrfs/tree-log.c         |   63 +++++++++++++++++++++++++++++-------------
 3 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index be8909d..54a3a4b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5228,9 +5228,11 @@ int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
 				    u64 bytenr, u64 num_bytes)
 {
 	struct btrfs_block_group_cache *cache;
+	int ret;
 
 	cache = btrfs_lookup_block_group(root->fs_info, bytenr);
-	BUG_ON(!cache); /* Logic error */
+	if (!cache)
+		return -EINVAL;
 
 	/*
 	 * pull in the free space cache (if any) so that our pin
@@ -5243,9 +5245,9 @@ int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
 	pin_down_extent(root, cache, bytenr, num_bytes, 0);
 
 	/* remove us from the free space cache (if we're there at all) */
-	btrfs_remove_free_space(cache, bytenr, num_bytes);
+	ret = btrfs_remove_free_space(cache, bytenr, num_bytes);
 	btrfs_put_block_group(cache);
-	return 0;
+	return ret;
 }
 
 /**
@@ -6629,40 +6631,42 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	if (!caching_ctl) {
 		BUG_ON(!block_group_cache_done(block_group));
 		ret = btrfs_remove_free_space(block_group, start, num_bytes);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret)
+			goto out;
 	} else {
 		mutex_lock(&caching_ctl->mutex);
 
 		if (start >= caching_ctl->progress) {
 			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret); /* -ENOMEM */
 		} else if (start + num_bytes <= caching_ctl->progress) {
 			ret = btrfs_remove_free_space(block_group,
 						      start, num_bytes);
-			BUG_ON(ret); /* -ENOMEM */
 		} else {
 			num_bytes = caching_ctl->progress - start;
 			ret = btrfs_remove_free_space(block_group,
 						      start, num_bytes);
-			BUG_ON(ret); /* -ENOMEM */
+			if (ret)
+				goto out_lock;
 
 			start = caching_ctl->progress;
 			num_bytes = ins->objectid + ins->offset -
 				    caching_ctl->progress;
 			ret = add_excluded_extent(root, start, num_bytes);
-			BUG_ON(ret); /* -ENOMEM */
 		}
-
+out_lock:
 		mutex_unlock(&caching_ctl->mutex);
 		put_caching_control(caching_ctl);
+		if (ret)
+			goto out;
 	}
 
 	ret = btrfs_update_reserved_bytes(block_group, ins->offset,
 					  RESERVE_ALLOC_NO_ACCOUNT);
 	BUG_ON(ret); /* logic error */
-	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
+out:
+	btrfs_put_block_group(block_group);
 	if (ret)
 		printk(KERN_ERR "this is probably where we went wrong\n");
 	return ret;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index fa1a814..37b2b89 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1567,7 +1567,8 @@ again:
 	search_bytes = ctl->unit;
 	search_bytes = min(search_bytes, end - search_start + 1);
 	ret = search_bitmap(ctl, bitmap_info, &search_start, &search_bytes);
-	BUG_ON(ret < 0 || search_start != *offset);
+	if (ret < 0 || search_start != *offset)
+		return -EINVAL;
 
 	/* We may have found more bits than what we need */
 	search_bytes = min(search_bytes, *bytes);
@@ -1973,7 +1974,6 @@ again:
 		re_search = true;
 		goto again;
 	}
-	BUG_ON(ret); /* logic error */
 out_lock:
 	spin_unlock(&ctl->tree_lock);
 out:
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f50137a..aebfb2d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -277,17 +277,19 @@ static int process_one_buffer(struct btrfs_root *log,
 			      struct extent_buffer *eb,
 			      struct walk_control *wc, u64 gen)
 {
+	int ret = 0;
+
 	if (wc->pin)
-		btrfs_pin_extent_for_log_replay(log->fs_info->extent_root,
-						eb->start, eb->len);
+		ret = btrfs_pin_extent_for_log_replay(log->fs_info->extent_root,
+						      eb->start, eb->len);
 
-	if (btrfs_buffer_uptodate(eb, gen, 0)) {
+	if (!ret && btrfs_buffer_uptodate(eb, gen, 0)) {
 		if (wc->write)
 			btrfs_write_tree_block(eb);
 		if (wc->wait)
 			btrfs_wait_tree_block_writeback(eb);
 	}
-	return 0;
+	return ret;
 }
 
 /*
@@ -623,7 +625,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 						ins.objectid, ins.offset,
 						0, root->root_key.objectid,
 						key->objectid, offset, 0);
-				BUG_ON(ret);
+				if (ret)
+					goto out;
 			} else {
 				/*
 				 * insert the extent pointer in the extent
@@ -632,7 +635,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 				ret = btrfs_alloc_logged_file_extent(trans,
 						root, root->root_key.objectid,
 						key->objectid, offset, &ins);
-				BUG_ON(ret);
+				if (ret)
+					goto out;
 			}
 			btrfs_release_path(path);
 
@@ -1952,11 +1956,13 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 			if (S_ISDIR(mode)) {
 				ret = replay_dir_deletes(wc->trans,
 					 root, log, path, key.objectid, 0);
-				BUG_ON(ret);
+				if (ret)
+					break;
 			}
 			ret = overwrite_item(wc->trans, root, path,
 					     eb, i, &key);
-			BUG_ON(ret);
+			if (ret)
+				break;
 
 			/* for regular files, make sure corresponding
 			 * orhpan item exist. extents past the new EOF
@@ -1965,12 +1971,14 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 			if (S_ISREG(mode)) {
 				ret = insert_orphan_item(wc->trans, root,
 							 key.objectid);
-				BUG_ON(ret);
+				if (ret)
+					break;
 			}
 
 			ret = link_to_fixup_dir(wc->trans, root,
 						path, key.objectid);
-			BUG_ON(ret);
+			if (ret)
+				break;
 		}
 		if (wc->stage < LOG_WALK_REPLAY_ALL)
 			continue;
@@ -1979,28 +1987,35 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 		if (key.type == BTRFS_XATTR_ITEM_KEY) {
 			ret = overwrite_item(wc->trans, root, path,
 					     eb, i, &key);
-			BUG_ON(ret);
+			if (ret)
+				break;
 		} else if (key.type == BTRFS_INODE_REF_KEY) {
 			ret = add_inode_ref(wc->trans, root, log, path,
 					    eb, i, &key);
-			BUG_ON(ret && ret != -ENOENT);
+			if (ret && ret != -ENOENT)
+				break;
+			ret = 0;
 		} else if (key.type == BTRFS_INODE_EXTREF_KEY) {
 			ret = add_inode_ref(wc->trans, root, log, path,
 					    eb, i, &key);
-			BUG_ON(ret && ret != -ENOENT);
+			if (ret && ret != -ENOENT)
+				break;
+			ret = 0;
 		} else if (key.type == BTRFS_EXTENT_DATA_KEY) {
 			ret = replay_one_extent(wc->trans, root, path,
 						eb, i, &key);
-			BUG_ON(ret);
+			if (ret)
+				break;
 		} else if (key.type == BTRFS_DIR_ITEM_KEY ||
 			   key.type == BTRFS_DIR_INDEX_KEY) {
 			ret = replay_one_dir_item(wc->trans, root, path,
 						  eb, i, &key);
-			BUG_ON(ret);
+			if (ret)
+				break;
 		}
 	}
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
@@ -2045,8 +2060,10 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 
 		if (*level == 1) {
 			ret = wc->process_func(root, next, wc, ptr_gen);
-			if (ret)
+			if (ret) {
+				free_extent_buffer(next);
 				return ret;
+			}
 
 			path->slots[*level]++;
 			if (wc->free) {
@@ -3970,6 +3987,9 @@ again:
 		wc.replay_dest = btrfs_read_fs_root_no_name(fs_info, &tmp_key);
 		if (IS_ERR(wc.replay_dest)) {
 			ret = PTR_ERR(wc.replay_dest);
+			free_extent_buffer(log->node);
+			free_extent_buffer(log->commit_root);
+			kfree(log);
 			btrfs_error(fs_info, ret, "Couldn't read target root "
 				    "for tree log recovery.");
 			goto error;
@@ -3978,12 +3998,10 @@ again:
 		wc.replay_dest->log_root = log;
 		btrfs_record_root_in_trans(trans, wc.replay_dest);
 		ret = walk_log_tree(trans, log, &wc);
-		BUG_ON(ret);
 
-		if (wc.stage == LOG_WALK_REPLAY_ALL) {
+		if (!ret && wc.stage == LOG_WALK_REPLAY_ALL) {
 			ret = fixup_inode_link_counts(trans, wc.replay_dest,
 						      path);
-			BUG_ON(ret);
 		}
 
 		key.offset = found_key.offset - 1;
@@ -3992,6 +4010,9 @@ again:
 		free_extent_buffer(log->commit_root);
 		kfree(log);
 
+		if (ret)
+			goto error;
+
 		if (found_key.offset == 0)
 			break;
 	}
@@ -4024,6 +4045,8 @@ again:
 
 	return 0;
 error:
+	if (wc.trans)
+		btrfs_end_transaction(wc.trans, fs_info->tree_root);
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.7.6

