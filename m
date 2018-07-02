Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25975 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753849AbeGBJWG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 05:22:06 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id C47E24B43D5E
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 17:22:00 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 1/3] btrfs-progs: lowmem: delay before lowmem repair starts
Date: Mon, 2 Jul 2018 17:28:18 +0800
Message-ID: <20180702092820.16285-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
References: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since lowmem mode repair is so dangerous, delay 10 seconds before
start.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/main.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/check/main.c b/check/main.c
index 3190b5d4f293..b9997460162f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9553,12 +9553,6 @@ int cmd_check(int argc, char **argv)
 		exit(1);
 	}
 
-	/*
-	 * experimental and dangerous
-	 */
-	if (repair && check_mode == CHECK_MODE_LOWMEM)
-		warning("low-memory mode repair support is only partial");
-
 	radix_tree_init();
 	cache_tree_init(&root_cache);
 
@@ -9600,6 +9594,28 @@ int cmd_check(int argc, char **argv)
 	if (repair)
 		ctree_flags |= OPEN_CTREE_PARTIAL;
 
+	/*
+	 * experimental and dangerous
+	 */
+	if (repair && check_mode == CHECK_MODE_LOWMEM) {
+		int delay = 10;
+
+		printf("WARNING:\n\n");
+		printf("\tLow-memory mode repair support is only partial.\n");
+		printf("\tIt's experimental and very dangerous.\n");
+		printf("\tIt may run slow or crash unexpectedly.\n");
+		printf("\tPlease backup device before running low-memory mode repair.\n");
+		printf("\tThe operation will start in %d seconds.\n", delay);
+		printf("\tUse Ctrl-C to stop it.\n");
+
+		while (delay) {
+			printf("%2d", delay--);
+			fflush(stdout);
+			sleep(1);
+		}
+		printf("\nStarting to check and repair filesystem.\n");
+	}
+
 	info = open_ctree_fs_info(argv[optind], bytenr, tree_root_bytenr,
 				  chunk_root_bytenr, ctree_flags);
 	if (!info) {
-- 
2.17.1



