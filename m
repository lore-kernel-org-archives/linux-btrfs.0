Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27342 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933091AbbIDNZ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 09:25:58 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t84DPlIl030025
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2015 21:25:47 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/5] btrfs-progs: Support extra-dev for btrfs rescue
Date: Fri, 4 Sep 2015 21:24:16 +0800
Message-ID: <9f20c44c6272eda068105d5ac9ae98c5ee767fcf.1441357933.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
References: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make following command support --extra-dev:
 btrfs rescue chunk-recover
 btrfs rescue super-recover
 btrfs rescue zero-log

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-rescue.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/cmds-rescue.c b/cmds-rescue.c
index dd7c01e..163d0bb 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -37,9 +37,10 @@ const char * const cmd_rescue_chunk_recover_usage[] = {
 	"btrfs rescue chunk-recover [options] <device>",
 	"Recover the chunk tree by scanning the devices one by one.",
 	"",
-	"-y	Assume an answer of `yes' to all questions",
-	"-v	Verbose mode",
-	"-h	Help",
+	HELPINFO_EXTRA_DEV,
+	"-y                 Assume an answer of `yes' to all questions",
+	"-v                 Verbose mode",
+	"-h                 Help",
 	NULL
 };
 
@@ -47,8 +48,9 @@ const char * const cmd_rescue_super_recover_usage[] = {
 	"btrfs rescue super-recover [options] <device>",
 	"Recover bad superblocks from good copies",
 	"",
-	"-y	Assume an answer of `yes' to all questions",
-	"-v	Verbose mode",
+	HELPINFO_EXTRA_DEV,
+	"-y                 Assume an answer of `yes' to all questions",
+	"-v                 Verbose mode",
 	NULL
 };
 
@@ -59,6 +61,9 @@ int cmd_rescue_chunk_recover(int argc, char *argv[])
 	int yes = 0;
 	int verbose = 0;
 
+	if (set_extra_dev_from_arg(&argc, argv))
+		usage(cmd_rescue_chunk_recover_usage);
+
 	while (1) {
 		int c = getopt(argc, argv, "yvh");
 		if (c < 0)
@@ -119,6 +124,9 @@ int cmd_rescue_super_recover(int argc, char **argv)
 	int yes = 0;
 	char *dname;
 
+	if (set_extra_dev_from_arg(&argc, argv))
+		usage(cmd_rescue_super_recover_usage);
+
 	while (1) {
 		int c = getopt(argc, argv, "vy");
 		if (c < 0)
@@ -153,9 +161,10 @@ int cmd_rescue_super_recover(int argc, char **argv)
 }
 
 const char * const cmd_rescue_zero_log_usage[] = {
-	"btrfs rescue zero-log <device>",
+	"btrfs rescue zero-log [options] <device>",
 	"Clear the tree log. Usable if it's corrupted and prevents mount.",
 	"",
+	HELPINFO_EXTRA_DEV,
 	NULL
 };
 
@@ -167,6 +176,9 @@ int cmd_rescue_zero_log(int argc, char **argv)
 	char *devname;
 	int ret;
 
+	if (set_extra_dev_from_arg(&argc, argv))
+		usage(cmd_rescue_zero_log_usage);
+
 	if (check_argc_exact(argc, 2))
 		usage(cmd_rescue_zero_log_usage);
 
-- 
1.8.5.1

