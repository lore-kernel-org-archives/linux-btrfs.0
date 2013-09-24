Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46242 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3IXNCd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 09:02:33 -0400
Received: by mail-ea0-f180.google.com with SMTP id h10so2419093eaj.25
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Sep 2013 06:02:31 -0700 (PDT)
From: Ross Kirk <ross.kirk@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Ross Kirk <ross.kirk@gmail.com>
Subject: [PATCH] btrfs-progs: Make btrfs_header_fsid() return unsigned long
Date: Tue, 24 Sep 2013 14:02:21 +0100
Message-Id: <1380027741-23856-1-git-send-email-ross.kirk@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Internally, btrfs_header_fsid() calculates an unsigned long, but casts
it to a pointer, while all callers cast it to unsigned long again.

Committed to btrfs as fba6aa75654394fccf2530041e9451414c28084f

Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
---
 cmds-chunk.c |    6 ++----
 ctree.c      |   18 ++++++------------
 ctree.h      |    5 ++---
 disk-io.c    |    3 +--
 print-tree.c |    2 +-
 5 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/cmds-chunk.c b/cmds-chunk.c
index 03314de..a89b929 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -742,8 +742,7 @@ static int scan_one_device(struct recover_control *rc, int fd,
 		    rc->leafsize)
 			break;
 
-		if (memcmp_extent_buffer(buf, rc->fs_devices->fsid,
-					 (unsigned long)btrfs_header_fsid(buf),
+		if (memcmp_extent_buffer(buf, rc->fs_devices->fsid, btrfs_header_fsid(buf),
 					 BTRFS_FSID_SIZE)) {
 			bytenr += rc->sectorsize;
 			continue;
@@ -1043,8 +1042,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_level(cow, 0);
 	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(cow, BTRFS_CHUNK_TREE_OBJECTID);
-	write_extent_buffer(cow, root->fs_info->fsid,
-			(unsigned long)btrfs_header_fsid(cow),
+	write_extent_buffer(cow, root->fs_info->fsid, btrfs_header_fsid(cow),
 			BTRFS_FSID_SIZE);
 
 	write_extent_buffer(cow, root->fs_info->chunk_tree_uuid,
diff --git a/ctree.c b/ctree.c
index 1a4f3f0..4e9a47f 100644
--- a/ctree.c
+++ b/ctree.c
@@ -121,8 +121,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, new_root_objectid);
 
-	write_extent_buffer(cow, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(cow),
+	write_extent_buffer(cow, root->fs_info->fsid, btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -168,8 +167,7 @@ init:
 	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
-	write_extent_buffer(c, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(c),
+	write_extent_buffer(c, root->fs_info->fsid, btrfs_header_fsid(c),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -342,8 +340,7 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
-	write_extent_buffer(cow, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(cow),
+	write_extent_buffer(cow, root->fs_info->fsid, btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -1528,8 +1525,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
-	write_extent_buffer(c, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(c),
+	write_extent_buffer(c, root->fs_info->fsid, btrfs_header_fsid(c),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -1649,8 +1645,7 @@ static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_header_generation(split, trans->transid);
 	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(split, root->root_key.objectid);
-	write_extent_buffer(split, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(split),
+	write_extent_buffer(split, root->fs_info->fsid, btrfs_header_fsid(split),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
@@ -2210,8 +2205,7 @@ again:
 	btrfs_set_header_backref_rev(right, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
-	write_extent_buffer(right, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(right),
+	write_extent_buffer(right, root->fs_info->fsid, btrfs_header_fsid(right),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
diff --git a/ctree.h b/ctree.h
index 0b0d701..6a711c6 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1748,10 +1748,9 @@ static inline void btrfs_set_header_backref_rev(struct extent_buffer *eb,
 	btrfs_set_header_flags(eb, flags);
 }
 
-static inline u8 *btrfs_header_fsid(struct extent_buffer *eb)
+static inline unsigned long btrfs_header_fsid(struct extent_buffer *eb)
 {
-	unsigned long ptr = offsetof(struct btrfs_header, fsid);
-	return (u8 *)ptr;
+	return offsetof(struct btrfs_header, fsid);
 }
 
 static inline u8 *btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
diff --git a/disk-io.c b/disk-io.c
index 13dbe27..58f699e 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -49,8 +49,7 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 
 	fs_devices = root->fs_info->fs_devices;
 	while (fs_devices) {
-		if (!memcmp_extent_buffer(buf, fs_devices->fsid,
-					  (unsigned long)btrfs_header_fsid(buf),
+		if (!memcmp_extent_buffer(buf, fs_devices->fsid, btrfs_header_fsid(buf),
 					  BTRFS_FSID_SIZE)) {
 			ret = 0;
 			break;
diff --git a/print-tree.c b/print-tree.c
index aae47a9..5027b73 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -153,7 +153,7 @@ static void print_uuids(struct extent_buffer *eb)
 	char chunk_uuid[37];
 	u8 disk_uuid[BTRFS_UUID_SIZE];
 
-	read_extent_buffer(eb, disk_uuid, (unsigned long)btrfs_header_fsid(eb),
+	read_extent_buffer(eb, disk_uuid, btrfs_header_fsid(eb),
 			   BTRFS_FSID_SIZE);
 
 	fs_uuid[36] = '\0';
-- 
1.7.7.6

