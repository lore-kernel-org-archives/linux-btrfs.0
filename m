From: Andi Drebes <lists-receive@programmierforen.de>
Subject: [PATCH][TRIVIAL] btrfs-progs: correct error message in btrfs_scan_one_dir
Date: Sat, 31 Oct 2009 21:55:53 +0100
Message-ID: <200910312155.54019.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When opendir() fails on the directory to be scanned, the error message should mention the correct directory name instead of "/sys/block".

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
diff --git a/utils.c b/utils.c
index 2f4c6e1..5c58071 100644
--- a/utils.c
+++ b/utils.c
@@ -694,7 +694,7 @@ again:
 	}
 	dirp = opendir(dirname);
 	if (!dirp) {
-		fprintf(stderr, "Unable to open /sys/block for scanning\n");
+		fprintf(stderr, "Unable to open %s for scanning\n", dirname);
 		return -ENOENT;
 	}
 	while(1) {
