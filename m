From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] fix segfault in btrfsck
Date: Fri, 23 Jan 2009 22:01:06 +0800
Message-ID: <4979CDA2.80802@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

This patch fixes an accessing freed memory bug
in merge_inode_recs. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp btrfs-progs-unstable/btrfsck.c btrfs-progs/btrfsck.c
--- btrfs-progs-unstable/btrfsck.c	2009-01-23 06:01:44.064370471 +0800
+++ btrfs-progs/btrfsck.c	2009-01-23 11:56:36.000000000 +0800
@@ -84,6 +84,7 @@ struct inode_backref {
 struct inode_record {
 	struct list_head backrefs;
 	unsigned int checked:1;
+	unsigned int merging:1;
 	unsigned int found_inode_item:1;
 	unsigned int found_dir_item:1;
 	unsigned int found_file_extent:1;
@@ -120,6 +121,7 @@ struct inode_record {
 #define I_ERR_FILE_NBYTES_WRONG		(1 << 10)
 #define I_ERR_ODD_CSUM_ITEM		(1 << 11)
 #define I_ERR_SOME_CSUM_MISSING		(1 << 12)
+#define I_ERR_LINK_COUNT_WRONG		(1 << 13)
 
 struct ptr_node {
 	struct cache_extent cache;
@@ -258,7 +260,7 @@ static void maybe_free_inode_rec(struct 
 		}
 	}
 
-	if (!rec->checked)
+	if (!rec->checked || rec->merging)
 		return;
 
 	if (S_ISDIR(rec->imode)) {
@@ -425,6 +427,7 @@ static int merge_inode_recs(struct inode
 	struct inode_backref *backref;
 	struct cache_tree *dst_cache = &dst_node->inode_cache;
 
+	dst->merging = 1;
 	list_for_each_entry(backref, &src->backrefs, list) {
 		if (backref->found_dir_index) {
 			add_inode_backref(dst_cache, dst->ino, backref->dir,
@@ -492,6 +495,7 @@ static int merge_inode_recs(struct inode
 		if (dst_node->current == dst)
 			dst_node->current = NULL;
 	}
+	dst->merging = 0;
 	maybe_free_inode_rec(dst_cache, dst);
 	return 0;
 }
@@ -1159,6 +1163,8 @@ static int check_inode_recs(struct btrfs
 		error++;
 		if (!rec->found_inode_item)
 			rec->errors |= I_ERR_NO_INODE_ITEM;
+		if (rec->found_link != rec->nlink)
+			rec->errors |= I_ERR_LINK_COUNT_WRONG;
 		fprintf(stderr, "root %llu inode %llu errors %x\n",
 			root->root_key.objectid, rec->ino, rec->errors);
 		list_for_each_entry(backref, &rec->backrefs, list) {
