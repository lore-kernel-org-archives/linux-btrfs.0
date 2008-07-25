From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs-progs: add orphan support to print-tree
Date: Fri, 25 Jul 2008 09:10:14 -0400
Message-ID: <20080725131014.GG28414@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This adds orphan support to print-tree so when debug_tree hits an orphan item it
will print out "orphan item" under it so you know what it is.  Thanks,

Josef


diff -r e08f2f90e4f8 ctree.h
--- a/ctree.h	Thu Jul 24 13:52:04 2008 -0400
+++ b/ctree.h	Fri Jul 25 16:18:38 2008 -0400
@@ -54,6 +54,9 @@ struct btrfs_trans_handle;
 
 /* directory objectid inside the root tree */
 #define BTRFS_ROOT_TREE_DIR_OBJECTID 6ULL
+
+/* oprhan objectid for tracking unlinked/truncated files */
+#define BTRFS_ORPHAN_OBJECTID -5ULL
 
 /*
  * All files have objectids higher than this.
@@ -564,6 +567,7 @@ struct btrfs_root {
 #define BTRFS_INODE_ITEM_KEY		1
 #define BTRFS_INODE_REF_KEY		2
 #define BTRFS_XATTR_ITEM_KEY		8
+#define BTRFS_ORPHAN_ITEM_KEY		9
 
 /* reserve 3-15 close to the inode for later flexibility */
 
diff -r e08f2f90e4f8 print-tree.c
--- a/print-tree.c	Thu Jul 24 13:52:04 2008 -0400
+++ b/print-tree.c	Fri Jul 25 16:18:38 2008 -0400
@@ -183,6 +183,9 @@ void btrfs_print_leaf(struct btrfs_root 
 			di = btrfs_item_ptr(l, i, struct btrfs_dir_item);
 			print_dir_item(l, item, di);
 			break;
+		case BTRFS_ORPHAN_ITEM_KEY:
+			printf("\t\torphan item\n");
+			break;
 		case BTRFS_ROOT_ITEM_KEY:
 			ri = btrfs_item_ptr(l, i, struct btrfs_root_item);
 			read_extent_buffer(l, &root_item, (unsigned long)ri, sizeof(root_item));
