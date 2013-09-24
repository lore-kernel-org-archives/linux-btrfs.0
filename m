Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54673 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3IXJHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 05:07:55 -0400
Received: by mail-ea0-f174.google.com with SMTP id z15so2305731ead.5
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 02:07:54 -0700 (PDT)
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Ross Kirk <ross.kirk@gmail.com>
Subject: [PATCH v2] btrfs: remove unused parameter from btrfs_header_fsid
Date: Tue, 24 Sep 2013 10:07:43 +0100
Message-Id: <1380013663-21031-1-git-send-email-ross.kirk@gmail.com>
In-Reply-To: <1379683626-29724-1-git-send-email-ross.kirk@gmail.com>
References: <1379683626-29724-1-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused parameter, 'eb'. Unused since introduction in
5f39d397dfbe140a14edecd4e73c34ce23c4f9ee

Updated to be rebased against current upstream.

Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
---
 fs/btrfs/ctree.c   |   10 +++++-----
 fs/btrfs/ctree.h   |    2 +-
 fs/btrfs/disk-io.c |    6 +++---
 fs/btrfs/ioctl.c   |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c274a75..394e011 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -274,7 +274,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, new_root_objectid);
 
-	write_extent_buffer(cow, root->fs_info->fsid, btrfs_(cow),
+	write_extent_buffer(cow, root->fs_info->fsid, btrfs_(),
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -996,7 +996,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
-	write_extent_buffer(cow, root->fs_info->fsid, btrfs_(cow),
+	write_extent_buffer(cow, root->fs_info->fsid, btrfs_(),
 			    BTRFS_FSID_SIZE);
 
 	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
@@ -3148,7 +3148,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
-	write_extent_buffer(c, root->fs_info->fsid, btrfs_(c),
+	write_extent_buffer(c, root->fs_info->fsid, btrfs_(),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -3287,7 +3287,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(split, root->root_key.objectid);
 	write_extent_buffer(split, root->fs_info->fsid,
-			    btrfs_(split), BTRFS_FSID_SIZE);
+			    btrfs_(), BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
@@ -4042,7 +4042,7 @@ again:
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
 	write_extent_buffer(right, root->fs_info->fsid,
-			    btrfs_(right), BTRFS_FSID_SIZE);
+			    btrfs_(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(right),
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fa117f7d..d5839c2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2665,7 +2665,7 @@ static inline void btrfs_set_header_backref_rev(struct extent_buffer *eb,
 	btrfs_set_header_flags(eb, flags);
 }
 
-static inline unsigned long btrfs_(struct extent_buffer *eb)
+static inline unsigned long btrfs_(void)
 {
 	return offsetof(struct btrfs_header, fsid);
 }
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4ae17ed..3258aed 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -496,7 +496,7 @@ static int check_tree_block_fsid(struct btrfs_root *root,
 	u8 fsid[BTRFS_UUID_SIZE];
 	int ret = 1;
 
-	read_extent_buffer(eb, fsid, btrfs_(eb), BTRFS_FSID_SIZE);
+	read_extent_buffer(eb, fsid, btrfs_(), BTRFS_FSID_SIZE);
 	while (fs_devices) {
 		if (!memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE)) {
 			ret = 0;
@@ -1292,7 +1292,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_header_owner(leaf, objectid);
 	root->node = leaf;
 
-	write_extent_buffer(leaf, fs_info->fsid, btrfs_(leaf),
+	write_extent_buffer(leaf, fs_info->fsid, btrfs_(),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(leaf),
@@ -1379,7 +1379,7 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	root->node = leaf;
 
 	write_extent_buffer(root->node, root->fs_info->fsid,
-			    btrfs_(root->node), BTRFS_FSID_SIZE);
+			    btrfs_(), BTRFS_FSID_SIZE);
 	btrfs_mark_buffer_dirty(root->node);
 	btrfs_tree_unlock(root->node);
 	return root;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d46f60..1c0d5eb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -436,7 +436,7 @@ static noinline int create_subvol(struct inode *dir,
 	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(leaf, objectid);
 
-	write_extent_buffer(leaf, root->fs_info->fsid, btrfs_(leaf),
+	write_extent_buffer(leaf, root->fs_info->fsid, btrfs_(),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(leaf),
-- 
1.7.7.6

