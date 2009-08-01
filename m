From: Luca Bruno <lucab@debian.org>
Subject: [PATCH] btrfs-progs: Fix printk format casting errors
Date: Sat,  1 Aug 2009 20:13:41 +0200
Message-ID: <1249150421-5326-1-git-send-email-lucab@debian.org>
Cc: Luca Bruno <lucab@debian.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are still some warnings of the form:

format '%llu' expects type 'long long unsigned int' but argument has type 'u64'

In conjunction with -Werror, this is causing some build failures.
Now they're properly casted, avoiding compiler warnings.
---
 convert.c     |    2 +-
 disk-io.c     |    6 ++++--
 extent-tree.c |    3 ++-
 print-tree.c  |    2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/convert.c b/convert.c
index d037c98..cf656a0 100644
--- a/convert.c
+++ b/convert.c
@@ -2572,7 +2572,7 @@ int do_rollback(const char *devname, int force)
 	ext2_root = btrfs_read_fs_root(root->fs_info, &key);
 	if (!ext2_root || IS_ERR(ext2_root)) {
 		fprintf(stderr, "unable to open subvol %llu\n",
-			key.objectid);
+			(unsigned long long) key.objectid);
 		goto fail;
 	}
 
diff --git a/disk-io.c b/disk-io.c
index addebe1..9729875 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -678,7 +678,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 		   ~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
 		printk("couldn't open because of unsupported "
-		       "option features (%Lx).\n", features);
+			"option features (%Lx).\n",
+			(unsigned long long)features);
 		BUG_ON(1);
 	}
 
@@ -692,7 +693,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (writes && features) {
 		printk("couldn't open RDWR because of unsupported "
-		       "option features (%Lx).\n", features);
+			"option features (%Lx).\n",
+			(unsigned long long) features);
 		BUG_ON(1);
 	}
 
diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..4531ba4 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1448,7 +1448,8 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 		goto out;
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
-		printk("failed to find block number %Lu\n", bytenr);
+		printk("failed to find block number %Lu\n",
+		(unsigned long long) bytenr);
 		BUG();
 	}
 
diff --git a/print-tree.c b/print-tree.c
index 59f4358..4baadb0 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -494,7 +494,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		case BTRFS_DIR_LOG_ITEM_KEY:
 			dlog = btrfs_item_ptr(l, i, struct btrfs_dir_log_item);
 			printf("\t\tdir log end %Lu\n",
-			       btrfs_dir_log_end(l, dlog));
+			       (unsigned long long) btrfs_dir_log_end(l, dlog));
 		       break;
 		case BTRFS_ORPHAN_ITEM_KEY:
 			printf("\t\torphan item\n");
-- 
1.6.3.3

