From: Andi Drebes <lists-receive@programmierforen.de>
Subject: [PATCH 2/2] btrfs-progs: prevent btrfsck to run on mounted filesystems
Date: Sat, 21 Nov 2009 15:39:15 +0100
Message-ID: <200911211539.15224.lists-receive@programmierforen.de>
References: <200911211533.25878.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng" <yanzheng@21cn.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911211533.25878.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

As recently discussed on the list, btrfsck should only be run on unmounted filesystems. This patch adds a short check for the mount status at the beginning of btrfsck. If the FS is mounted, the program aborts showing an error message.

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
diff --git a/btrfsck.c b/btrfsck.c
index 73f1836..6f2a0d0 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -28,6 +28,7 @@
 #include "transaction.h"
 #include "list.h"
 #include "version.h"
+#include "utils.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -2821,6 +2822,15 @@ int main(int ac, char **av)
 
 	radix_tree_init();
 	cache_tree_init(&root_cache);
+
+	if((ret = check_mounted(av[1])) < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n", strerror(ret));
+		return ret;
+	} else if(ret) {
+		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[1]);
+		return -EBUSY;
+	}
+
 	root = open_ctree(av[1], 0, 0);
 
 	if (root == NULL)
