Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp11.hushmail.com ([65.39.178.133]:44424 "EHLO
	smtp11.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2E2QVG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 12:21:06 -0400
Received: from smtp11.hushmail.com (localhost.localdomain [127.0.0.1])
	by smtp11.hushmail.com (Postfix) with SMTP id 26DC31CC11D
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:21:05 +0000 (UTC)
Received: from smtp.hushmail.com (w6.hushmail.com [65.39.178.92])
	by smtp11.hushmail.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:21:02 +0000 (UTC)
MIME-Version: 1.0
Date: Tue, 29 May 2012 08:21:02 -0800
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Decrease meta fragments by using a caterpillar band Method (btrfs-progs)
From: "WeiFeng Liu" <weifeng.liu@hushmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20120529162102.56510A6E45@smtp.hushmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

signed-off-by WeiFeng Liu
523f28f9b3d9c710cacc31dbba644efb1678cf62
---

diff -uprN btrfs-progs-120328-a/ctree.c btrfs-progs-120328-b/ctree.c
--- btrfs-progs-120328-a/ctree.c	2012-04-16 08:47:08.000000000 +0000
+++ btrfs-progs-120328-b/ctree.c	2012-05-28 23:29:15.000000000 +0000
@@ -334,6 +334,7 @@ int __btrfs_cow_block(struct btrfs_trans
 		btrfs_set_header_flag(cow, BTRFS_HEADER_FLAG_RELOC);
 	else
 		btrfs_set_header_owner(cow, root->root_key.objectid);
+	btrfs_set_header_cater(cow, 0);
 
 	write_extent_buffer(cow, root->fs_info->fsid,
 			    (unsigned long)btrfs_header_fsid(cow),
diff -uprN btrfs-progs-120328-a/ctree.h btrfs-progs-120328-b/ctree.h
--- btrfs-progs-120328-a/ctree.h	2012-04-16 08:47:08.000000000 +0000
+++ btrfs-progs-120328-b/ctree.h	2012-05-28 23:25:26.000000000 +0000
@@ -292,6 +292,7 @@ struct btrfs_header {
 	__le64 owner;
 	__le32 nritems;
 	u8 level;
+	u8 cater_index_factor;
 } __attribute__ ((__packed__));
 
 #define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->nodesize - \
@@ -510,6 +511,7 @@ struct btrfs_extent_item {
 	__le64 refs;
 	__le64 generation;
 	__le64 flags;
+	u8 cater_index_factor;
 } __attribute__ ((__packed__));
 
 struct btrfs_extent_item_v0 {
@@ -1246,6 +1248,8 @@ BTRFS_SETGET_FUNCS(extent_flags, struct
 BTRFS_SETGET_FUNCS(extent_refs_v0, struct btrfs_extent_item_v0, refs, 32);
 
 BTRFS_SETGET_FUNCS(tree_block_level, struct btrfs_tree_block_info, level, 8);
+BTRFS_SETGET_FUNCS(extent_cater, struct btrfs_extent_item,
+			cater_index_factor, 8);
 
 static inline void btrfs_tree_block_key(struct extent_buffer *eb,
 					struct btrfs_tree_block_info *item,
@@ -1511,6 +1515,8 @@ BTRFS_SETGET_HEADER_FUNCS(header_owner,
 BTRFS_SETGET_HEADER_FUNCS(header_nritems, struct btrfs_header, nritems, 32);
 BTRFS_SETGET_HEADER_FUNCS(header_flags, struct btrfs_header, flags, 64);
 BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
+BTRFS_SETGET_HEADER_FUNCS(header_cater, struct btrfs_header,
+			cater_index_factor, 8);
 
 static inline int btrfs_header_flag(struct extent_buffer *eb, u64 flag)
 {
diff -uprN btrfs-progs-120328-a/extent-tree.c btrfs-progs-120328-b/extent-tree.c
--- btrfs-progs-120328-a/extent-tree.c	2012-04-16 08:47:08.000000000 +0000
+++ btrfs-progs-120328-b/extent-tree.c	2012-05-28 20:06:06.000000000 +0000
@@ -2584,6 +2584,7 @@ static int alloc_reserved_tree_block(str
 	btrfs_set_extent_generation(leaf, extent_item, generation);
 	btrfs_set_extent_flags(leaf, extent_item,
 			       flags | BTRFS_EXTENT_FLAG_TREE_BLOCK);
+	btrfs_set_extent_cater(leaf, extent_item, 0);
 	block_info = (struct btrfs_tree_block_info *)(extent_item + 1);
 
 	btrfs_set_tree_block_key(leaf, block_info, key);
diff -uprN btrfs-progs-120328-a/utils.c btrfs-progs-120328-b/utils.c
--- btrfs-progs-120328-a/utils.c	2012-04-16 08:47:08.000000000 +0000
+++ btrfs-progs-120328-b/utils.c	2012-05-28 23:22:20.000000000 +0000
@@ -135,6 +135,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_header_generation(buf, 1);
 	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(buf, BTRFS_ROOT_TREE_OBJECTID);
+	btrfs_set_header_cater(buf, 0);
 	write_extent_buffer(buf, super.fsid, (unsigned long)
 			    btrfs_header_fsid(buf), BTRFS_FSID_SIZE);
 
@@ -254,6 +255,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_header_bytenr(buf, blocks[2]);
 	btrfs_set_header_owner(buf, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
+	btrfs_set_header_cater(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[2]);
 	BUG_ON(ret != leafsize);
@@ -338,6 +340,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_header_bytenr(buf, blocks[3]);
 	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
+	btrfs_set_header_cater(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[3]);
 
@@ -373,6 +376,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_header_bytenr(buf, blocks[4]);
 	btrfs_set_header_owner(buf, BTRFS_DEV_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
+	btrfs_set_header_cater(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[4]);
 
@@ -382,6 +386,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_header_bytenr(buf, blocks[5]);
 	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
+	btrfs_set_header_cater(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[5]);
 	BUG_ON(ret != leafsize);
@@ -392,6 +397,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_header_bytenr(buf, blocks[6]);
 	btrfs_set_header_owner(buf, BTRFS_CSUM_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
+	btrfs_set_header_cater(buf, 0);
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, leafsize, blocks[6]);
 	BUG_ON(ret != leafsize);

