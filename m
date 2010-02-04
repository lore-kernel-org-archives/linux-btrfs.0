From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 3/6] debug-btrfs: Add open file system command
Date: Thu,  4 Feb 2010 23:14:04 +0530
Message-ID: <1265305447-30780-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 debugbtrfs/cmds.c              |   23 +++++++++++++++++++++++
 debugbtrfs/debug_btrfs.c       |   16 +++++++---------
 debugbtrfs/debug_btrfs.h       |    1 +
 debugbtrfs/debug_btrfs_cmds.ct |    3 +++
 4 files changed, 34 insertions(+), 9 deletions(-)

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
index 29095d3..e9890ee 100644
--- a/debugbtrfs/debug_btrfs_cmds.ct
+++ b/debugbtrfs/debug_btrfs_cmds.ct
@@ -20,5 +20,8 @@ command_table btrfs_debug_cmds;
 request do_show_debugfs_params, "Show btrfs_debug parameters",
 	show_debugfs_params, params;
 
+request do_open_filesys, "Open the file system",
+	open_filesys, open;
+
 end;
 
-- 
1.7.0.rc0.48.gdace5

