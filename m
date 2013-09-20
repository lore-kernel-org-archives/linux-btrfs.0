Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:47043 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3ITN1l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 09:27:41 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so266451eak.18
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 06:27:40 -0700 (PDT)
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Ross Kirk <ross.kirk@gmail.com>
Subject: [PATCH] btrfs-progs: remove unused parameter from btrfs_header_fsid
Date: Fri, 20 Sep 2013 14:27:32 +0100
Message-Id: <1379683652-29761-1-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused parameter, 'eb'. Unused since introduction in
7777e63b425f1444d2472ea05a6b2b9cf865f35b

Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
---
 cmds-chunk.c |    4 ++--
 ctree.c      |   12 ++++++------
 ctree.h      |    2 +-
 disk-io.c    |    2 +-
 print-tree.c |    2 +-
 utils.c      |    2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/cmds-chunk.c b/cmds-chunk.c
index 03314de..c83958e 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -743,7 +743,7 @@ static int scan_one_device(struct recover_control *rc, int fd,
 			break;
 
 		if (memcmp_extent_buffer(buf, rc->fs_devices->fsid,
-					 (unsigned long)btrfs_header_fsid(buf),
+					 (unsigned long)btrfs_header_fsid(),
 					 BTRFS_FSID_SIZE)) {
 			bytenr += rc->sectorsize;
 			continue;
@@ -1044,7 +1044,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(cow, BTRFS_CHUNK_TREE_OBJECTID);
 	write_extent_buffer(cow, root->fs_info->fsid,
-			(unsigned long)btrfs_header_fsid(cow),
+			(unsigned long)btrfs_header_fsid(),
 			BTRFS_FSID_SIZE);
 
 	write_extent_buffer(cow, root->fs_info->chunk_tree_uuid,
diff --git a/ctree.c b/ctree.c
index c42c84f..e86703b 100644
--- a/ctree.c
+++ b/ctree.c
@@ -122,7 +122,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		btrfs_set_header_owner(cow, new_root_objectid);
 
 	write_extent_buffer(cow, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(cow),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -169,7 +169,7 @@ init:
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
 	write_extent_buffer(c, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(c),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -343,7 +343,7 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
 	write_extent_buffer(cow, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(cow),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -1529,7 +1529,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
 	write_extent_buffer(c, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(c),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -1650,7 +1650,7 @@ static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(split, root->root_key.objectid);
 	write_extent_buffer(split, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(split),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
@@ -2211,7 +2211,7 @@ again:
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
 	write_extent_buffer(right, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(right),
+			    (unsigned long)btrfs_header_fsid(),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
diff --git a/ctree.h b/ctree.h
index 7f40b3b..6b29d05 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1747,7 +1747,7 @@ static inline void btrfs_set_header_backref_rev(struct extent_buffer *eb,
 	btrfs_set_header_flags(eb, flags);
 }
 
-static inline u8 *btrfs_header_fsid(struct extent_buffer *eb)
+static inline u8 *btrfs_header_fsid(void)
 {
 	unsigned long ptr = offsetof(struct btrfs_header, fsid);
 	return (u8 *)ptr;
diff --git a/disk-io.c b/disk-io.c
index 13dbe27..2ab0612 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -50,7 +50,7 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 	fs_devices = root->fs_info->fs_devices;
 	while (fs_devices) {
 		if (!memcmp_extent_buffer(buf, fs_devices->fsid,
-					  (unsigned long)btrfs_header_fsid(buf),
+					  (unsigned long)btrfs_header_fsid(),
 					  BTRFS_FSID_SIZE)) {
 			ret = 0;
 			break;
diff --git a/print-tree.c b/print-tree.c
index fa37c78..4e99228 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -153,7 +153,7 @@ static void print_uuids(struct extent_buffer *eb)
 	char chunk_uuid[37];
 	u8 disk_uuid[BTRFS_UUID_SIZE];
 
-	read_extent_buffer(eb, disk_uuid, (unsigned long)btrfs_header_fsid(eb),
+	read_extent_buffer(eb, disk_uuid, (unsigned long)btrfs_header_fsid(),
 			   BTRFS_FSID_SIZE);
 
 	fs_uuid[36] = '\0';
diff --git a/utils.c b/utils.c
index 64ea769..2a08c5d 100644
--- a/utils.c
+++ b/utils.c
@@ -142,7 +142,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(buf, BTRFS_ROOT_TREE_OBJECTID);
 	write_extent_buffer(buf, super.fsid, (unsigned long)
-			    btrfs_header_fsid(buf), BTRFS_FSID_SIZE);
+			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(buf, chunk_tree_uuid, (unsigned long)
 			    btrfs_header_chunk_tree_uuid(buf),
-- 
1.7.7.6

