Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5639 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756377AbbJ2Jdm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 05:33:42 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9T9X7Xi015836
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 17:33:07 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 6/6] btrfs-progs: Avoid use pointer in handle_options
Date: Thu, 29 Oct 2015 17:31:48 +0800
Message-ID: <067592f9b350f23dbe4c255238bfebcc9e34964c.1446111097.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use pointer of argc and argv in handle_options() because they
are necessary in very old code which are not exist now.

This patch move to use argc and argv directly in handle_options(),
alone with following update:
1: rename handle_options() to check_options()
   to fit its function.
2: cleanup for condition in handle_options() to make line short.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 9416a29..f881c18 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -172,20 +172,22 @@ static int cmd_version(int argc, char **argv)
 	return 0;
 }
 
-static void handle_options(int *argc, char ***argv)
+static void check_options(int argc, char **argv)
 {
-	if (*argc > 0) {
-		const char *arg = (*argv)[0];
-		if (arg[0] != '-' ||
-		    !strcmp(arg, "--help") ||
-		    !strcmp(arg, "--version"))
-			return;
-		fprintf(stderr, "Unknown option: %s\n", arg);
-		fprintf(stderr, "usage: %s\n",
-			btrfs_cmd_group.usagestr[0]);
-		exit(129);
-	}
-	return;
+	if (argc == 0)
+		return;
+
+	const char *arg = argv[0];
+
+	if (arg[0] != '-' ||
+	    !strcmp(arg, "--help") ||
+	    !strcmp(arg, "--version"))
+		return;
+
+	fprintf(stderr, "Unknown option: %s\n", arg);
+	fprintf(stderr, "usage: %s\n",
+		btrfs_cmd_group.usagestr[0]);
+	exit(129);
 }
 
 static const struct cmd_group btrfs_cmd_group = {
@@ -227,7 +229,7 @@ int main(int argc, char **argv)
 	} else {
 		argc--;
 		argv++;
-		handle_options(&argc, &argv);
+		check_options(argc, argv);
 		if (argc > 0) {
 			if (!prefixcmp(argv[0], "--"))
 				argv[0] += 2;
-- 
1.8.5.1

