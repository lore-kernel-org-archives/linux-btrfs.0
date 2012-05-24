Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab2EXCnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 22:43:45 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4O2hguZ012901
	for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2012 10:43:42 +0800
Message-ID: <4FBDA00B.3010804@cn.fujitsu.com>
Date: Thu, 24 May 2012 10:42:19 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix the same inode id problem when doing auto defragment
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two files in the different subvolumes may have the same inode id, so
The rb-tree which is used to manage the defragment object must take it
into account. This patch fix this problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 23364c1..3d22fd0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -65,6 +65,21 @@ struct inode_defrag {
 	int cycled;
 };
 
+static int __compare_inode_defrag(struct inode_defrag *defrag1,
+				  struct inode_defrag *defrag2)
+{
+	if (defrag1->root > defrag2->root)
+		return 1;
+	else if (defrag1->root < defrag2->root)
+		return -1;
+	else if (defrag1->ino > defrag2->ino)
+		return 1;
+	else if (defrag1->ino < defrag2->ino)
+		return -1;
+	else
+		return 0;
+}
+
 /* pop a record for an inode into the defrag tree.  The lock
  * must be held already
  *
@@ -87,9 +102,9 @@ static void __btrfs_add_inode_defrag(struct inode *inode,
 		parent = *p;
 		entry = rb_entry(parent, struct inode_defrag, rb_node);
 
-		if (defrag->ino < entry->ino)
+		if (__compare_inode_defrag(defrag, entry) < 0)
 			p = &parent->rb_left;
-		else if (defrag->ino > entry->ino)
+		else if (__compare_inode_defrag(defrag, entry) > 0)
 			p = &parent->rb_right;
 		else {
 			/* if we're reinserting an entry for
@@ -159,28 +174,33 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 /*
  * must be called with the defrag_inodes lock held
  */
-struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info, u64 ino,
+struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info,
+					     u64 root, u64 ino,
 					     struct rb_node **next)
 {
 	struct inode_defrag *entry = NULL;
+	struct inode_defrag tmp;
 	struct rb_node *p;
 	struct rb_node *parent = NULL;
 
+	tmp.ino = ino;
+	tmp.root = root;
+
 	p = info->defrag_inodes.rb_node;
 	while (p) {
 		parent = p;
 		entry = rb_entry(parent, struct inode_defrag, rb_node);
 
-		if (ino < entry->ino)
+		if (__compare_inode_defrag(&tmp, entry) < 0)
 			p = parent->rb_left;
-		else if (ino > entry->ino)
+		else if (__compare_inode_defrag(&tmp, entry) > 0)
 			p = parent->rb_right;
 		else
 			return entry;
 	}
 
 	if (next) {
-		while (parent && ino > entry->ino) {
+		while (parent && __compare_inode_defrag(&tmp, entry) > 0) {
 			parent = rb_next(parent);
 			entry = rb_entry(parent, struct inode_defrag, rb_node);
 		}
@@ -202,6 +222,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 	struct btrfs_key key;
 	struct btrfs_ioctl_defrag_range_args range;
 	u64 first_ino = 0;
+	u64 root_objectid = 0;
 	int num_defrag;
 	int defrag_batch = 1024;
 
@@ -214,11 +235,14 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 		n = NULL;
 
 		/* find an inode to defrag */
-		defrag = btrfs_find_defrag_inode(fs_info, first_ino, &n);
+		defrag = btrfs_find_defrag_inode(fs_info, root_objectid,
+						 first_ino, &n);
 		if (!defrag) {
-			if (n)
-				defrag = rb_entry(n, struct inode_defrag, rb_node);
-			else if (first_ino) {
+			if (n) {
+				defrag = rb_entry(n, struct inode_defrag,
+						  rb_node);
+			} else if (root_objectid || first_ino) {
+				root_objectid = 0;
 				first_ino = 0;
 				continue;
 			} else {
@@ -228,6 +252,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 
 		/* remove it from the rbtree */
 		first_ino = defrag->ino + 1;
+		root_objectid = defrag->root;
 		rb_erase(&defrag->rb_node, &fs_info->defrag_inodes);
 
 		if (btrfs_fs_closing(fs_info) ||
-- 
1.7.6.5
