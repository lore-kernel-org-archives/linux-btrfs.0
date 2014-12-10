Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:35366 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933301AbaLJVFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 16:05:41 -0500
Received: from mail-in-02-z2.arcor-online.net (mail-in-19-z2.arcor-online.net [151.189.8.36])
	by mx.arcor.de (Postfix) with ESMTP id E5D19197D19
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 22:05:39 +0100 (CET)
From: mwilck@arcor.de
To: linux-btrfs@vger.kernel.org
Cc: mwilck@arcor.de
Subject: [PATCH 03/18] btrfs-progs: btrfs-debug-tree: fix usage message
Date: Wed, 10 Dec 2014 21:51:33 +0100
Message-Id: <1418244708-7087-4-git-send-email-mwilck@arcor.de>
In-Reply-To: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
References: <1418244708-7087-1-git-send-email-mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Martin Wilck <mwilck@arcor.de>

Adapt usage message to the additional options introduced.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 btrfs-debug-tree.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 7cdc368..4c1e835 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -31,22 +31,23 @@
 
 static int print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-debug-tree [-e] [-d] [-r] [-R] [-u]\n");
-	fprintf(stderr, "                        [-b block_num ] device\n");
+	fprintf(stderr, "usage: btrfs-debug-tree [-e] [-d] [-r] [-R] [-u] [-B]\n");
+	fprintf(stderr, "                        [-t tree_id] device\n");
+	fprintf(stderr, "       btrfs-debug-tree [-b block_num [-f]] device\n");
 	fprintf(stderr, "\t-e : print detailed extents info\n");
 	fprintf(stderr, "\t-d : print info of btrfs device and root tree dirs"
                     " only\n");
 	fprintf(stderr, "\t-r : print info of roots only\n");
 	fprintf(stderr, "\t-R : print info of roots and root backups\n");
 	fprintf(stderr, "\t-u : print info of uuid tree only\n");
-	fprintf(stderr, "\t-b block_num : print info of the specified block"
-                    " only\n");
-	fprintf(stderr, "\t-f : (with -b) follow subtree of the specified"
-		" block\n");
 	fprintf(stderr,
 		"\t-t tree_id : print only the tree with the given id\n");
 	fprintf(stderr,
 		"\t-B nr: use root backup <nr> instead of real root\n");
+	fprintf(stderr, "\t-b block_num : print info of the specified block"
+                    " only\n");
+	fprintf(stderr, "\t-f : (with -b) follow subtree of the specified"
+		" block\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
