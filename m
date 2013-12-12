Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14742 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3LLKnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 05:43:51 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBCAhmie023296
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Dec 2013 18:43:48 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: remove NULL-ptr judge before free for btrfs-progs
Date: Thu, 12 Dec 2013 18:41:07 +0800
Message-Id: <1386844867-16264-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

free(3) already checks the pointer for NULL, no need to do it
on your own. This patch make the change globally.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-convert.c    |  9 +++------
 btrfs-list.c       | 15 ++++-----------
 cmds-filesystem.c  |  3 +--
 cmds-subvolume.c   | 18 ++++++------------
 free-space-cache.c |  3 +--
 mkfs.c             |  3 +--
 volumes.c          |  6 ++----
 7 files changed, 18 insertions(+), 39 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index cb6ddd0..bf3defb 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -547,8 +547,7 @@ static int create_file_extents(struct btrfs_trans_handle *trans,
 					 data.first_block, data.checksum);
 	}
 fail:
-	if (buffer)
-		free(buffer);
+	free(buffer);
 	return ret;
 error:
 	fprintf(stderr, "ext2fs_block_iterate2: %s\n", error_message(err));
@@ -785,8 +784,7 @@ static int copy_single_xattr(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_xattr_item(trans, root, namebuf, name_len,
 				      data, datalen, objectid);
 out:
-	if (databuf)
-		free(databuf);
+	free(databuf);
 	return ret;
 }
 
@@ -892,8 +890,7 @@ static int copy_extended_attrs(struct btrfs_trans_handle *trans,
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
 out:
-	if (buffer != NULL)
-		free(buffer);
+	free(buffer);
 	if ((void *)ext2_inode != inode_buf)
 		free(ext2_inode);
 	return ret;
diff --git a/btrfs-list.c b/btrfs-list.c
index 6a38dd5..fa69910 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -399,8 +399,7 @@ static int update_root(struct root_lookup *root_lookup,
 	if (!ri || ri->root_id != root_id)
 		return -ENOENT;
 	if (name && name_len > 0) {
-		if (ri->name)
-			free(ri->name);
+		free(ri->name);
 
 		ri->name = malloc(name_len + 1);
 		if (!ri->name) {
@@ -515,15 +514,9 @@ static void __free_root_info(struct rb_node *node)
 	struct root_info *ri;
 
 	ri = rb_entry(node, struct root_info, rb_node);
-	if (ri->name)
-		free(ri->name);
-
-	if (ri->path)
-		free(ri->path);
-
-	if (ri->full_path)
-		free(ri->full_path);
-
+	free(ri->name);
+	free(ri->path);
+	free(ri->full_path);
 	free(ri);
 }
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 0cb35c6..6e3d6ea 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -496,8 +496,7 @@ static int btrfs_scan_kernel(void *search)
 			break;
 		}
 	}
-	if (fslist_saved)
-		kfree(fslist_saved);
+	kfree(fslist_saved);
 	if (search && !found)
 		return 1;
 	return ret;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c6a5284..255f028 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -949,22 +949,16 @@ static int cmd_subvol_show(int argc, char **argv)
 			1, raw_prefix);
 
 	/* clean up */
-	if (get_ri.path)
-		free(get_ri.path);
-	if (get_ri.name)
-		free(get_ri.name);
-	if (get_ri.full_path)
-		free(get_ri.full_path);
-	if (filter_set)
-		btrfs_list_free_filter_set(filter_set);
+	free(get_ri.path);
+	free(get_ri.name);
+	free(get_ri.full_path);
+	btrfs_list_free_filter_set(filter_set);
 
 out:
 	close_file_or_dir(fd, dirstream1);
 	close_file_or_dir(mntfd, dirstream2);
-	if (mnt)
-		free(mnt);
-	if (fullpath)
-		free(fullpath);
+	free(mnt);
+	free(fullpath);
 	return !!ret;
 }
 
diff --git a/free-space-cache.c b/free-space-cache.c
index ddeeeb6..1ca7980 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -781,8 +781,7 @@ void __btrfs_remove_free_space_cache(struct btrfs_free_space_ctl *ctl)
 	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, offset_index);
 		unlink_free_space(ctl, info);
-		if (info->bitmap)
-			free(info->bitmap);
+		free(info->bitmap);
 		free(info);
 	}
 }
diff --git a/mkfs.c b/mkfs.c
index 74bd345..89495e7 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -721,8 +721,7 @@ again:
 		goto again;
 
 end:
-	if (eb)
-		free(eb);
+	free(eb);
 	close(fd);
 	return ret;
 }
diff --git a/volumes.c b/volumes.c
index bd01270..e25b4c0 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1267,13 +1267,11 @@ int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 again:
 	ce = search_cache_extent(&map_tree->cache_tree, logical);
 	if (!ce) {
-		if (multi)
-			kfree(multi);
+		kfree(multi);
 		return -ENOENT;
 	}
 	if (ce->start > logical || ce->start + ce->size < logical) {
-		if (multi)
-			kfree(multi);
+		kfree(multi);
 		return -ENOENT;
 	}
 
-- 
1.8.0.1

