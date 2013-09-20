Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64162 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab3ITN1P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 09:27:15 -0400
Received: by mail-ee0-f44.google.com with SMTP id b47so268626eek.17
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 06:27:14 -0700 (PDT)
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Ross Kirk <ross.kirk@gmail.com>
Subject: [PATCH] btrfs: remove unused parameter from btrfs_header_fsid
Date: Fri, 20 Sep 2013 14:27:06 +0100
Message-Id: <1379683626-29724-1-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused parameter, 'eb'. Unused since introduction in
5f39d397dfbe140a14edecd4e73c34ce23c4f9ee

Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
---
 fs/btrfs/ctree.c   |   10 +++++-----
 fs/btrfs/ctree.h   |    2 +-
 fs/btrfs/disk-io.c |    6 +++---
 fs/btrfs/ioctl.c   |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 63cde75..febc672 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -275,7 +275,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		btrfs_set_header_owner(cow, new_root_objectid);
 
 	write_extent_buffer(cow, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(cow),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -1047,7 +1047,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
 	write_extent_buffer(cow, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(cow),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
@@ -3145,7 +3145,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
 	write_extent_buffer(c, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(c),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -3285,7 +3285,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(split, root->root_key.objectid);
 	write_extent_buffer(split, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(split),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
@@ -4041,7 +4041,7 @@ again:
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
 	write_extent_buffer(right, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(right),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e0bab4d..972a2f8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2602,7 +2602,7 @@ static inline void btrfs_set_header_backref_rev(struct extent_buffer *eb,
 	btrfs_set_header_flags(eb, flags);
 }
 
-static inline u8 *btrfs_header_fsid(struct extent_buffer *eb)
+static inline u8 *btrfs_header_fsid(void)
 {
 	unsigned long ptr = offsetof(struct btrfs_header, fsid);
 	return (u8 *)ptr;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3c2886c..e038693 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -497,7 +497,7 @@ static int check_tree_block_fsid(struct btrfs_root *root,
 	u8 fsid[BTRFS_UUID_SIZE];
 	int ret = 1;
 
-	read_extent_buffer(eb, fsid, (unsigned long)btrfs_header_fsid(eb),
+	read_extent_buffer(eb, fsid, (unsigned long)btrfs_header_fsid(),
 			   BTRFS_FSID_SIZE);
 	while (fs_devices) {
 		if (!memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE)) {
@@ -1291,7 +1291,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	root->node = leaf;
 
 	write_extent_buffer(leaf, fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(leaf),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
@@ -1378,7 +1378,7 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	root->node = leaf;
 
 	write_extent_buffer(root->node, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(root->node),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 	btrfs_mark_buffer_dirty(root->node);
 	btrfs_tree_unlock(root->node);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e17a30..464e569 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -426,7 +426,7 @@ static noinline int create_subvol(struct inode *dir,
 	btrfs_set_header_owner(leaf, objectid);
 
 	write_extent_buffer(leaf, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(leaf),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
-- 
1.7.7.6

