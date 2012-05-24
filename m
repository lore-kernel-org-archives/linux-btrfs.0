Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab2EXK75 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 06:59:57 -0400
Message-ID: <4FBE1453.20709@cn.fujitsu.com>
Date: Thu, 24 May 2012 18:58:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dave@jikos.cz>
Subject: [PATCH V2] Btrfs: fix the same inode id problem when doing auto defragment
References: <4FBDA00B.3010804@cn.fujitsu.com> <20120524102630.GP24394@twin.jikos.cz>
In-Reply-To: <20120524102630.GP24394@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two files in the different subvolumes may have the same inode id, so
The rb-tree which is used to manage the defragment object must take it
into account. This patch fix this problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2
- cleanup unnecessary comparison.
---
 fs/btrfs/file.c |   49 +++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 53bf2d7..0c04a62 100644
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
@@ -81,15 +96,17 @@ static void __btrfs_add_inode_defrag(struct inode *inode,
 	struct inode_defrag *entry;
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
+	int ret;
 
 	p = &root->fs_info->defrag_inodes.rb_node;
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct inode_defrag, rb_node);
 
-		if (defrag->ino < entry->ino)
+		ret = __compare_inode_defrag(defrag, entry);
+		if (ret < 0)
 			p = &parent->rb_left;
-		else if (defrag->ino > entry->ino)
+		else if (ret > 0)
 			p = &parent->rb_right;
 		else {
 			/* if we're reinserting an entry for
@@ -159,28 +176,35 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
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
+	int ret;
+
+	tmp.ino = ino;
+	tmp.root = root;
 
 	p = info->defrag_inodes.rb_node;
 	while (p) {
 		parent = p;
 		entry = rb_entry(parent, struct inode_defrag, rb_node);
 
-		if (ino < entry->ino)
+		ret = __compare_inode_defrag(&tmp, entry);
+		if (ret < 0)
 			p = parent->rb_left;
-		else if (ino > entry->ino)
+		else if (ret > 0)
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
@@ -202,6 +226,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 	struct btrfs_key key;
 	struct btrfs_ioctl_defrag_range_args range;
 	u64 first_ino = 0;
+	u64 root_objectid = 0;
 	int num_defrag;
 	int defrag_batch = 1024;
 
@@ -214,11 +239,14 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
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
@@ -228,6 +256,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 
 		/* remove it from the rbtree */
 		first_ino = defrag->ino + 1;
+		root_objectid = defrag->root;
 		rb_erase(&defrag->rb_node, &fs_info->defrag_inodes);
 
 		if (btrfs_fs_closing(fs_info))
-- 
1.7.6.5
