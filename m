Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38449 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3JBM2z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Oct 2013 08:28:55 -0400
Received: by mail-wg0-f47.google.com with SMTP id f12so795570wgh.14
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Oct 2013 05:28:53 -0700 (PDT)
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Ross Kirk <ross.kirk@gmail.com>
Subject: [PATCH] btrfs-progs: Make btrfs_header_chunk_tree_uuid() return unsigned long
Date: Wed,  2 Oct 2013 13:28:27 +0100
Message-Id: <1380716907-5563-1-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Internally, btrfs_header_chunk_tree_uuid() calculates an unsigned
long, but casts it to a pointer, while all callers cast it to unsigned
long again.

>From btrfs commit b308bc2f05a86e728bd035e21a4974acd05f4d1e

Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
---
 btrfs-find-root.c |    3 +--
 cmds-chunk.c      |    6 ++----
 ctree.c           |   10 ++++------
 ctree.h           |    5 ++---
 disk-io.c         |    3 +--
 print-tree.c      |    3 +--
 utils.c           |    2 +-
 7 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 9b3d7df..97b8d32 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -112,8 +112,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 
 	eb = fs_info->chunk_root->node;
 	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
-			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
-			   BTRFS_UUID_SIZE);
+			   btrfs_header_chunk_tree_uuid(eb), BTRFS_UUID_SIZE);
 
 	return fs_info->chunk_root;
 out_chunk:
diff --git a/cmds-chunk.c b/cmds-chunk.c
index 03314de..7b8bf29 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -1048,8 +1048,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 			BTRFS_FSID_SIZE);
 
 	write_extent_buffer(cow, root->fs_info->chunk_tree_uuid,
-			(unsigned long)btrfs_header_chunk_tree_uuid(cow),
-			BTRFS_UUID_SIZE);
+			btrfs_header_chunk_tree_uuid(cow), BTRFS_UUID_SIZE);
 
 	root->node = cow;
 	btrfs_mark_buffer_dirty(cow);
@@ -1236,8 +1235,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 
 	eb = fs_info->tree_root->node;
 	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
-			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
-			   BTRFS_UUID_SIZE);
+			   btrfs_header_chunk_tree_uuid(eb), BTRFS_UUID_SIZE);
 
 	return fs_info->fs_root;
 out_failed:
diff --git a/ctree.c b/ctree.c
index 1a4f3f0..8b3549b 100644
--- a/ctree.c
+++ b/ctree.c
@@ -173,8 +173,7 @@ init:
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(c),
-			    BTRFS_UUID_SIZE);
+			    btrfs_header_chunk_tree_uuid(c), BTRFS_UUID_SIZE);
 
 	btrfs_mark_buffer_dirty(c);
 
@@ -1533,8 +1532,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(c),
-			    BTRFS_UUID_SIZE);
+			    btrfs_header_chunk_tree_uuid(c), BTRFS_UUID_SIZE);
 
 	btrfs_set_node_key(c, &lower_key, 0);
 	btrfs_set_node_blockptr(c, 0, lower->start);
@@ -1653,7 +1651,7 @@ static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 			    (unsigned long)btrfs_header_fsid(split),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
+			    btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
 
@@ -2215,7 +2213,7 @@ again:
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(right),
+			    btrfs_header_chunk_tree_uuid(right),
 			    BTRFS_UUID_SIZE);
 
 	if (split == 0) {
diff --git a/ctree.h b/ctree.h
index 0b0d701..b2a4823 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1754,10 +1754,9 @@ static inline u8 *btrfs_header_fsid(struct extent_buffer *eb)
 	return (u8 *)ptr;
 }
 
-static inline u8 *btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
+static inline unsigned long btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
 {
-	unsigned long ptr = offsetof(struct btrfs_header, chunk_tree_uuid);
-	return (u8 *)ptr;
+	return offsetof(struct btrfs_header, chunk_tree_uuid);
 }
 
 static inline u8 *btrfs_super_fsid(struct extent_buffer *eb)
diff --git a/disk-io.c b/disk-io.c
index 13dbe27..68bf205 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1034,8 +1034,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	eb = fs_info->chunk_root->node;
 	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
-			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
-			   BTRFS_UUID_SIZE);
+			   btrfs_header_chunk_tree_uuid(eb), BTRFS_UUID_SIZE);
 
 	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, partial);
 	if (ret)
diff --git a/print-tree.c b/print-tree.c
index aae47a9..510d74a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -160,8 +160,7 @@ static void print_uuids(struct extent_buffer *eb)
 	uuid_unparse(disk_uuid, fs_uuid);
 
 	read_extent_buffer(eb, disk_uuid,
-			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
-			   BTRFS_UUID_SIZE);
+			   btrfs_header_chunk_tree_uuid(eb), BTRFS_UUID_SIZE);
 
 	chunk_uuid[36] = '\0';
 	uuid_unparse(disk_uuid, chunk_uuid);
diff --git a/utils.c b/utils.c
index 7b4cd74..e0a758b 100644
--- a/utils.c
+++ b/utils.c
@@ -144,7 +144,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	write_extent_buffer(buf, super.fsid, (unsigned long)
 			    btrfs_header_fsid(buf), BTRFS_FSID_SIZE);
 
-	write_extent_buffer(buf, chunk_tree_uuid, (unsigned long)
+	write_extent_buffer(buf, chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(buf),
 			    BTRFS_UUID_SIZE);
 
-- 
1.7.7.6

