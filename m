From: Andi Drebes <lists-receive@programmierforen.de>
Subject: [PATCH] Prevent btrfsck to run on mounted filesystems
Date: Thu, 29 Oct 2009 21:52:15 +0100
Message-ID: <200910292152.15564.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As recently discussed on the list, btrfsck should only be run on unmounted filesystems. This patch adds a short check for the mount status at the beginning of btrfsck. If the FS is mounted, the program aborts showing an error message.

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
diff --git a/btrfsck.c b/btrfsck.c
index 73f1836..87ae776 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -28,6 +28,7 @@
 #include "transaction.h"
 #include "list.h"
 #include "version.h"
+#include "utils.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -2819,6 +2820,16 @@ int main(int ac, char **av)
 	if (ac < 2)
 		print_usage();
 
+	ret = check_mounted(av[1]);
+	if (ret < 0) {
+		fprintf(stderr, "error checking %s mount status\n", av[1]);
+		return 1;
+	}
+	if (ret == 1) {
+		fprintf(stderr, "%s is mounted. btrfsck can only be run on an unmounted filesystem.\n", av[1]);
+		return 1;
+	}
+
 	radix_tree_init();
 	cache_tree_init(&root_cache);
 	root = open_ctree(av[1], 0, 0);
