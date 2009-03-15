From: Luca Bruno <lucab@debian.org>
Subject: [PATCH] btrfs-progs: Fix printf format casting errors
Date: Sun, 15 Mar 2009 19:22:50 +0100
Message-ID: <1237141370-32328-1-git-send-email-lucab@debian.org>
Cc: Luca Bruno <lucab@debian.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are still some warnings of the form:

format '%llu' expects type 'long long unsigned int' but argument has type 'u64'

In conjunction with -Werror, this is causing some build failures.
Now they're properly casted, avoiding compiler warnings.

Signed-off-by: Luca Bruno <lucab@debian.org>
---
 btrfsck.c     |   12 ++++++++----
 extent-tree.c |    2 +-
 mkfs.c        |    2 +-
 print-tree.c  |    2 +-
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 5834ca3..dd546c8 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1134,12 +1134,14 @@ static int check_inode_recs(struct btrfs_root *root,
 		ret = check_root_dir(rec);
 		if (ret) {
 			fprintf(stderr, "root %llu root dir %llu error\n",
-				root->root_key.objectid, root_dirid);
+				(unsigned long long) root->root_key.objectid, 
+				(unsigned long long) root_dirid);
 			error++;
 		}
 	} else {
 		fprintf(stderr, "root %llu root dir %llu not found\n",
-			root->root_key.objectid, root_dirid);
+			(unsigned long long) root->root_key.objectid, 
+			(unsigned long long) root_dirid);
 	}
 
 	while (1) {
@@ -1160,7 +1162,8 @@ static int check_inode_recs(struct btrfs_root *root,
 		if (!rec->found_inode_item)
 			rec->errors |= I_ERR_NO_INODE_ITEM;
 		fprintf(stderr, "root %llu inode %llu errors %x\n",
-			root->root_key.objectid, rec->ino, rec->errors);
+			(unsigned long long) root->root_key.objectid, 
+			(unsigned long long) rec->ino, rec->errors);
 		list_for_each_entry(backref, &rec->backrefs, list) {
 			if (!backref->found_dir_item)
 				backref->errors |= REF_ERR_NO_DIR_ITEM;
@@ -1170,7 +1173,8 @@ static int check_inode_recs(struct btrfs_root *root,
 				backref->errors |= REF_ERR_NO_INODE_REF;
 			fprintf(stderr, "\tunresolved ref dir %llu index %llu"
 				" namelen %u name %s filetype %d error %x\n",
-				backref->dir, backref->index,
+				(unsigned long long) backref->dir, 
+				(unsigned long long) backref->index,
 				backref->namelen, backref->name,
 				backref->filetype, backref->errors);
 		}
diff --git a/extent-tree.c b/extent-tree.c
index cc8d1d7..94ddb0c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -823,7 +823,7 @@ int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
 		goto out;
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
-		printk("failed to find block number %Lu\n", bytenr);
+		printk("failed to find block number %Lu\n", (unsigned long long) bytenr);
 		BUG();
 	}
 	l = path->nodes[0];
diff --git a/mkfs.c b/mkfs.c
index af7d12c..1533754 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -388,7 +388,7 @@ int main(int ac, char **av)
 					fprintf(stderr, "File system size "
 						"%llu bytes is too small, "
 						"256M is required at least\n",
-						block_count);
+						(unsigned long long) block_count);
 					exit(1);
 				}
 				zero_end = 0;
diff --git a/print-tree.c b/print-tree.c
index 52ef7c7..8ff763f 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -70,7 +70,7 @@ static int print_inode_ref_item(struct extent_buffer *eb, struct btrfs_item *ite
 		len = (name_len <= sizeof(namebuf))? name_len: sizeof(namebuf);
 		read_extent_buffer(eb, namebuf, (unsigned long)(ref + 1), len);
 		printf("\t\tinode ref index %llu namelen %u name: %.*s\n",
-		       index, name_len, len, namebuf);
+		       (unsigned long long) index, name_len, len, namebuf);
 		len = sizeof(*ref) + name_len;
 		ref = (struct btrfs_inode_ref *)((char *)ref + len);
 		cur += len;
-- 
1.6.2

