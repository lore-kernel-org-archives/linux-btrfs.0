From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/4] debug-btrfs: Add open file system command
Date: Sun, 31 Jan 2010 19:51:37 +0530
Message-ID: <1264947698-32371-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 debugbtrfs/cmds.c              |   23 +++++++++++++++++
 debugbtrfs/debug_btrfs.c       |   16 +++++------
 debugbtrfs/debug_btrfs.h       |    1 +
 debugbtrfs/debug_btrfs_cmds.ct |    3 ++
 debugbtrfs/debug_tree.c        |   54 ++++++++++++++++-----------------------
 5 files changed, 56 insertions(+), 41 deletions(-)

diff --git a/debugbtrfs/cmds.c b/debugbtrfs/cmds.c
index f5ed877..cd2901b 100644
--- a/debugbtrfs/cmds.c
+++ b/debugbtrfs/cmds.c
@@ -18,6 +18,11 @@
  */
 
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "ctree.h"
+#include "disk-io.h"
 #include "debug_btrfs.h"
 
 void do_show_debugfs_params(int argc, char *argv[])
@@ -25,3 +30,21 @@ void do_show_debugfs_params(int argc, char *argv[])
         FILE *out = stdout;
         fprintf(out, "Filesystem in use: %s\n", current_device);
 }
+
+void do_open_filesys(int argc, char *argv[])
+{
+	if (argc != 1) {
+		free((void *)current_device);
+		current_device = strdup(argv[1]);
+	}
+
+	if (current_fs_root)
+		close_ctree(current_fs_root);
+
+	radix_tree_init();
+	current_fs_root = open_ctree(current_device, 0, 0);
+	if (!current_fs_root) {
+		fprintf(stderr, "unable to open %s\n", current_device);
+		return;
+	}
+}
diff --git a/debugbtrfs/debug_btrfs.c b/debugbtrfs/debug_btrfs.c
index 44d6f64..d9f10e9 100644
--- a/debugbtrfs/debug_btrfs.c
+++ b/debugbtrfs/debug_btrfs.c
@@ -19,27 +19,25 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <ss/ss.h>
 #include "debug_btrfs.h"
 
 extern ss_request_table btrfs_debug_cmds;
 const char *current_device;
-
-void usage(char *prg)
-{
-	fprintf(stderr, "Usage: %s device\n", prg);
-	exit(1);
-}
+struct btrfs_root *current_fs_root;
+extern void do_open_filesys(int argc, char *argv[]);
 
 int main(int argc, char *argv[])
 {
 	int sci_idx;
 	int retval;
 
-	if (argc < 2)
-		usage(argv[0]);
+	if (argc != 1) {
+		/* open the file system */
+		do_open_filesys(argc, argv);
+	}
 
-	current_device = argv[1];
 	sci_idx = ss_create_invocation("debug-btrfs", "0.0", NULL,
 				&btrfs_debug_cmds, &retval);
 	if (retval) {
diff --git a/debugbtrfs/debug_btrfs.h b/debugbtrfs/debug_btrfs.h
index 55d7b17..1ea4fb2 100644
--- a/debugbtrfs/debug_btrfs.h
+++ b/debugbtrfs/debug_btrfs.h
@@ -22,6 +22,7 @@
 #include <getopt.h>
 
 extern const char *current_device;
+extern struct btrfs_root *current_fs_root;
 static inline void reset_getopt(void)
 {
 	optind = 0;
diff --git a/debugbtrfs/debug_btrfs_cmds.ct b/debugbtrfs/debug_btrfs_cmds.ct
index bd2e479..a46dbde 100644
--- a/debugbtrfs/debug_btrfs_cmds.ct
+++ b/debugbtrfs/debug_btrfs_cmds.ct
@@ -20,6 +20,9 @@ command_table btrfs_debug_cmds;
 request do_show_debugfs_params, "Show btrfs_debug parameters",
 	show_debugfs_params, params;
 
+request do_open_filesys, "Open the file system",
+	open_filesys, open;
+
 request do_dump_tree, "Show full btrfs tree",
 	dump_tree;
 
diff --git a/debugbtrfs/debug_tree.c b/debugbtrfs/debug_tree.c
index 1a1e5e2..820549d 100644
--- a/debugbtrfs/debug_tree.c
+++ b/debugbtrfs/debug_tree.c
@@ -35,36 +35,28 @@ static void print_dump_tree_usage(void)
 
 void do_dump_root_tree(int argc, char *argv[])
 {
-	struct btrfs_root *root;
-
-	radix_tree_init();
-	root = open_ctree(current_device, 0, 0);
-	if (!root) {
-		fprintf(stderr, "unable to open %s\n", current_device);
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
 	printf("root tree\n");
-	btrfs_print_tree(root->fs_info->tree_root,
-			 root->fs_info->tree_root->node);
+	btrfs_print_tree(current_fs_root->fs_info->tree_root,
+			 current_fs_root->fs_info->tree_root->node);
 }
 
 void do_dump_chunk_tree(int argc, char *argv[])
 {
-	struct btrfs_root *root;
-	radix_tree_init();
-	root = open_ctree(current_device, 0, 0);
-	if (!root) {
-		fprintf(stderr, "unable to open %s\n", current_device);
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
 	printf("chunk tree\n");
-	btrfs_print_tree(root->fs_info->chunk_root,
-				 root->fs_info->chunk_root->node);
+	btrfs_print_tree(current_fs_root->fs_info->chunk_root,
+				 current_fs_root->fs_info->chunk_root->node);
 }
 
 void do_dump_tree(int argc, char *argv[])
 {
-	struct btrfs_root *root;
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct btrfs_root_item ri;
@@ -77,7 +69,6 @@ void do_dump_tree(int argc, char *argv[])
 	int extent_only = 0;
 	struct btrfs_root *tree_root_scan;
 
-	radix_tree_init();
 	reset_getopt();
 	while(1) {
 		int c;
@@ -94,21 +85,20 @@ void do_dump_tree(int argc, char *argv[])
 		}
 	}
 
-	root = open_ctree(current_device, 0, 0);
-	if (!root) {
-		fprintf(stderr, "unable to open %s\n", current_device);
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
 		return;
 	}
 	if (!extent_only) {
 		printf("root tree\n");
-		btrfs_print_tree(root->fs_info->tree_root,
-				 root->fs_info->tree_root->node);
+		btrfs_print_tree(current_fs_root->fs_info->tree_root,
+				 current_fs_root->fs_info->tree_root->node);
 
 		printf("chunk tree\n");
-		btrfs_print_tree(root->fs_info->chunk_root,
-				 root->fs_info->chunk_root->node);
+		btrfs_print_tree(current_fs_root->fs_info->chunk_root,
+				 current_fs_root->fs_info->chunk_root->node);
 	}
-	tree_root_scan = root->fs_info->tree_root;
+	tree_root_scan = current_fs_root->fs_info->tree_root;
 
 	btrfs_init_path(&path);
 again:
@@ -221,11 +211,11 @@ again:
 		}
 		path.slots[0]++;
 	}
-	btrfs_release_path(root, &path);
+	btrfs_release_path(current_fs_root, &path);
 
-	if (tree_root_scan == root->fs_info->tree_root &&
-	    root->fs_info->log_root_tree) {
-		tree_root_scan = root->fs_info->log_root_tree;
+	if (tree_root_scan == current_fs_root->fs_info->tree_root &&
+	    current_fs_root->fs_info->log_root_tree) {
+		tree_root_scan = current_fs_root->fs_info->log_root_tree;
 		goto again;
 	}
 
@@ -233,11 +223,11 @@ again:
 		return;
 
 	printf("total bytes %llu\n",
-	       (unsigned long long)btrfs_super_total_bytes(&root->fs_info->super_copy));
+	       (unsigned long long)btrfs_super_total_bytes(&current_fs_root->fs_info->super_copy));
 	printf("bytes used %llu\n",
-	       (unsigned long long)btrfs_super_bytes_used(&root->fs_info->super_copy));
+	       (unsigned long long)btrfs_super_bytes_used(&current_fs_root->fs_info->super_copy));
 	uuidbuf[36] = '\0';
-	uuid_unparse(root->fs_info->super_copy.fsid, uuidbuf);
+	uuid_unparse(current_fs_root->fs_info->super_copy.fsid, uuidbuf);
 	printf("uuid %s\n", uuidbuf);
 	return;
 }
-- 
1.7.0.rc0.48.gdace5

