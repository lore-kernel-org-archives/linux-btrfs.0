From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 5/6] debug-btrfs: Add command to dump each of the btrfs trees
Date: Mon,  1 Feb 2010 10:06:24 +0530
Message-ID: <1264998984-3621-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1264947698-32371-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1264947698-32371-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 debugbtrfs/debug_btrfs_cmds.ct |   19 ++++-
 debugbtrfs/debug_tree.c        |  159 ++++++++++++++++++++-------------------
 2 files changed, 99 insertions(+), 79 deletions(-)

diff --git a/debugbtrfs/debug_btrfs_cmds.ct b/debugbtrfs/debug_btrfs_cmds.ct
index 98a7282..6b22bc1 100644
--- a/debugbtrfs/debug_btrfs_cmds.ct
+++ b/debugbtrfs/debug_btrfs_cmds.ct
@@ -23,17 +23,32 @@ request do_show_debugfs_params, "Show btrfs_debug parameters",
 request do_open_filesys, "Open the file system",
 	open_filesys, open;
 
+request do_print_inode, "Print inode details",
+	print_inode;
+
 request do_dump_tree, "Show full btrfs tree",
 	dump_tree;
 
+request do_dump_extent_tree, "Show Extent tree",
+	dump_extent_tree;
+
 request do_dump_root_tree, "Show root tree",
 	dump_root_tree;
 
 request do_dump_chunk_tree, "Show btrfs chunk tree",
 	dump_chunk_tree;
 
-request do_print_inode, "Print inode details",
-	print_inode;
+request do_dump_dev_tree, "Show btrfs dev tree",
+	dump_dev_tree;
+
+request do_dump_fs_tree, "Show btrfs fs tree",
+	dump_fs_tree;
+
+request do_dump_csum_tree, "Show btrfs checksum tree",
+	dump_csum_tree;
+
+request do_dump_log_tree, "Show btrfs log tree",
+	dump_log_tree;
 
 end;
 
diff --git a/debugbtrfs/debug_tree.c b/debugbtrfs/debug_tree.c
index 820549d..e92d6d0 100644
--- a/debugbtrfs/debug_tree.c
+++ b/debugbtrfs/debug_tree.c
@@ -28,9 +28,15 @@
 #include "transaction.h"
 #include "debug_btrfs.h"
 
-static void print_dump_tree_usage(void)
+void do_dump_extent_tree(int argc, char *argv[])
 {
-	fprintf(stderr, "usage: dump-tree [ -e ] \n");
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("Extent tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->extent_root,
+				 current_fs_root->fs_info->extent_root->node);
 }
 
 void do_dump_root_tree(int argc, char *argv[])
@@ -55,6 +61,54 @@ void do_dump_chunk_tree(int argc, char *argv[])
 				 current_fs_root->fs_info->chunk_root->node);
 }
 
+void do_dump_dev_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("Device tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->dev_root,
+				 current_fs_root->fs_info->dev_root->node);
+}
+
+void do_dump_fs_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("FS tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->fs_root,
+				 current_fs_root->fs_info->fs_root->node);
+}
+
+void do_dump_csum_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("Checksum tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->csum_root,
+				 current_fs_root->fs_info->csum_root->node);
+}
+
+void do_dump_log_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("Log tree\n");
+	if (!current_fs_root->fs_info->log_root_tree) {
+		printf("Nothing to replay \n");
+		return;
+	}
+	btrfs_print_tree(current_fs_root->fs_info->log_root_tree,
+				 current_fs_root->fs_info->log_root_tree->node);
+}
+
 void do_dump_tree(int argc, char *argv[])
 {
 	struct btrfs_path path;
@@ -66,38 +120,20 @@ void do_dump_tree(int argc, char *argv[])
 	char uuidbuf[37];
 	int ret;
 	int slot;
-	int extent_only = 0;
 	struct btrfs_root *tree_root_scan;
 
-	reset_getopt();
-	while(1) {
-		int c;
-		c = getopt(argc, argv, "e");
-		if (c < 0)
-			break;
-		switch(c) {
-			case 'e':
-				extent_only = 1;
-				break;
-			default:
-				print_dump_tree_usage();
-				return;
-		}
-	}
-
 	if (!current_fs_root) {
 		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
-	if (!extent_only) {
-		printf("root tree\n");
-		btrfs_print_tree(current_fs_root->fs_info->tree_root,
+	printf("root tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->tree_root,
 				 current_fs_root->fs_info->tree_root->node);
 
-		printf("chunk tree\n");
-		btrfs_print_tree(current_fs_root->fs_info->chunk_root,
+	printf("chunk tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->chunk_root,
 				 current_fs_root->fs_info->chunk_root->node);
-	}
+
 	tree_root_scan = current_fs_root->fs_info->tree_root;
 
 	btrfs_init_path(&path);
@@ -122,7 +158,6 @@ again:
 		if (btrfs_key_type(&found_key) == BTRFS_ROOT_ITEM_KEY) {
 			unsigned long offset;
 			struct extent_buffer *buf;
-			int skip = extent_only;
 
 			offset = btrfs_item_ptr_offset(leaf, slot);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
@@ -131,83 +166,56 @@ again:
 					      tree_root_scan->leafsize, 0);
 			switch(found_key.objectid) {
 			case BTRFS_ROOT_TREE_OBJECTID:
-				if (!skip)
-					printf("root");
+				printf("root");
 				break;
 			case BTRFS_EXTENT_TREE_OBJECTID:
-				skip = 0;
 				printf("extent");
 				break;
 			case BTRFS_CHUNK_TREE_OBJECTID:
-				if (!skip) {
-					printf("chunk");
-				}
+				printf("chunk");
 				break;
 			case BTRFS_DEV_TREE_OBJECTID:
-				if (!skip) {
-					printf("device");
-				}
+				printf("device");
 				break;
 			case BTRFS_FS_TREE_OBJECTID:
-				if (!skip) {
-					printf("fs");
-				}
+				printf("fs");
 				break;
 			case BTRFS_ROOT_TREE_DIR_OBJECTID:
-				if (!skip) {
-					printf("directory");
-				}
+				printf("directory");
 				break;
 			case BTRFS_CSUM_TREE_OBJECTID:
-				if (!skip) {
-					printf("checksum");
-				}
+				printf("checksum");
 				break;
 			case BTRFS_ORPHAN_OBJECTID:
-				if (!skip) {
-					printf("orphan");
-				}
+				printf("orphan");
 				break;
 			case BTRFS_TREE_LOG_OBJECTID:
-				if (!skip) {
-					printf("log");
-				}
+				printf("log");
 				break;
 			case BTRFS_TREE_LOG_FIXUP_OBJECTID:
-				if (!skip) {
-					printf("log fixup");
-				}
+				printf("log fixup");
 				break;
 			case BTRFS_TREE_RELOC_OBJECTID:
-				if (!skip) {
-					printf("reloc");
-				}
+				printf("reloc");
 				break;
 			case BTRFS_DATA_RELOC_TREE_OBJECTID:
-				if (!skip) {
-					printf("data reloc");
-				}
+				printf("data reloc");
 				break;
 			case BTRFS_EXTENT_CSUM_OBJECTID:
-				if (!skip) {
-					printf("extent checksum");
-				}
+				printf("extent checksum");
+				break;
 			case BTRFS_MULTIPLE_OBJECTIDS:
-				if (!skip) {
-					printf("multiple");
-				}
+				printf("multiple");
 				break;
 			default:
-				if (!skip) {
-					printf("file");
-				}
-			}
-			if (!skip) {
-				printf(" tree ");
-				btrfs_print_key(&disk_key);
-				printf(" \n");
-				btrfs_print_tree(tree_root_scan, buf);
+				printf("file");
 			}
+
+			printf(" tree ");
+			btrfs_print_key(&disk_key);
+			printf(" \n");
+			btrfs_print_tree(tree_root_scan, buf);
+
 		}
 		path.slots[0]++;
 	}
@@ -219,9 +227,6 @@ again:
 		goto again;
 	}
 
-	if (extent_only)
-		return;
-
 	printf("total bytes %llu\n",
 	       (unsigned long long)btrfs_super_total_bytes(&current_fs_root->fs_info->super_copy));
 	printf("bytes used %llu\n",
-- 
1.7.0.rc0.48.gdace5

