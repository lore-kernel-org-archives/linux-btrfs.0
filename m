Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25975 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753911AbeGBJWJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 05:22:09 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id AEB654B43D4B
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 17:22:01 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 2/3] btrfs-progs: lowmem: force to start without delay with option '--force-repair-lowmem'
Date: Mon, 2 Jul 2018 17:28:19 +0800
Message-ID: <20180702092820.16285-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
References: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add an option '--force-repair-lowmem' to start check without any delay.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/check/main.c b/check/main.c
index b9997460162f..3c9dc242f3db 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9377,6 +9377,7 @@ const char * const cmd_check_usage[] = {
 	"-s|--super <superblock>     use this superblock copy",
 	"-b|--backup                 use the first valid backup root copy",
 	"--force                     skip mount checks, repair is not possible",
+	"--force-repair-lowmem       start to check and repair in lowmem mode without delay",
 	"--repair                    try to repair the filesystem",
 	"--readonly                  run in read-only mode (default)",
 	"--init-csum-tree            create a new CRC tree",
@@ -9419,6 +9420,7 @@ int cmd_check(int argc, char **argv)
 	int qgroup_report_ret;
 	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
 	int force = 0;
+	int force_repair_lowmem = 0;
 
 	while(1) {
 		int c;
@@ -9426,7 +9428,7 @@ int cmd_check(int argc, char **argv)
 			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
 			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE,
 			GETOPT_VAL_MODE, GETOPT_VAL_CLEAR_SPACE_CACHE,
-			GETOPT_VAL_FORCE };
+			GETOPT_VAL_FORCE, GETOPT_VAL_FORCE_REPAIR_LOWMEM };
 		static const struct option long_options[] = {
 			{ "super", required_argument, NULL, 's' },
 			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
@@ -9449,6 +9451,8 @@ int cmd_check(int argc, char **argv)
 			{ "clear-space-cache", required_argument, NULL,
 				GETOPT_VAL_CLEAR_SPACE_CACHE},
 			{ "force", no_argument, NULL, GETOPT_VAL_FORCE },
+			{"force-repair-lowmem", no_argument, NULL,
+				GETOPT_VAL_FORCE_REPAIR_LOWMEM},
 			{ NULL, 0, NULL, 0}
 		};
 
@@ -9536,6 +9540,9 @@ int cmd_check(int argc, char **argv)
 			case GETOPT_VAL_FORCE:
 				force = 1;
 				break;
+			case GETOPT_VAL_FORCE_REPAIR_LOWMEM:
+				force_repair_lowmem = 1;
+				break;
 		}
 	}
 
@@ -9552,6 +9559,11 @@ int cmd_check(int argc, char **argv)
 		error("repair options are not compatible with --readonly");
 		exit(1);
 	}
+	if (force_repair_lowmem &&
+	    (!repair || check_mode != CHECK_MODE_LOWMEM)) {
+		error("--force-repair-lowmem only works with --mode=lowmem and --repair");
+		exit(1);
+	}
 
 	radix_tree_init();
 	cache_tree_init(&root_cache);
@@ -9597,7 +9609,7 @@ int cmd_check(int argc, char **argv)
 	/*
 	 * experimental and dangerous
 	 */
-	if (repair && check_mode == CHECK_MODE_LOWMEM) {
+	if (repair && check_mode == CHECK_MODE_LOWMEM && !force_repair_lowmem) {
 		int delay = 10;
 
 		printf("WARNING:\n\n");
@@ -9605,6 +9617,7 @@ int cmd_check(int argc, char **argv)
 		printf("\tIt's experimental and very dangerous.\n");
 		printf("\tIt may run slow or crash unexpectedly.\n");
 		printf("\tPlease backup device before running low-memory mode repair.\n");
+		printf("\tUse option'--force-repair-lowmem' option to skip this warning.\n");
 		printf("\tThe operation will start in %d seconds.\n", delay);
 		printf("\tUse Ctrl-C to stop it.\n");
 
-- 
2.17.1



