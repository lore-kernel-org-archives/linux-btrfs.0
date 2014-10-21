Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9118 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752836AbaJUHmR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 03:42:17 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9L7gAYv028386
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Oct 2014 15:42:10 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix number of arguments check of 'btrfs fi df'
Date: Tue, 21 Oct 2014 15:42:13 +0800
Message-ID: <1413877333-14507-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs fi df' needs exactly one arguments as mount option,
and due to the introduce of human readable options, some check is not
valid now, the new optind can point to the ending NULL string.

For example, you can run 'btrfs fi df' without any argument, and it will
error as "ERROR: can't access '%s'" which means the argument number
check is not valid.

This patch will use the old check_argc_exact() but introduce opt_num to
record how many options is provided, ensuring there will be and only be
one mount point provided.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-filesystem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index bb5881e..76845ec 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -237,11 +237,11 @@ static int cmd_df(int argc, char **argv)
 	struct btrfs_ioctl_space_args *sargs = NULL;
 	int ret;
 	int fd;
+	int opt_num = 0;
 	char *path;
 	DIR *dirstream = NULL;
 	unsigned unit_mode = UNITS_DEFAULT;
 
-	optind = 1;
 	while (1) {
 		int long_index;
 		static const struct option long_options[] = {
@@ -257,6 +257,7 @@ static int cmd_df(int argc, char **argv)
 					&long_index);
 		if (c < 0)
 			break;
+		opt_num++;
 		switch (c) {
 		case 'b':
 			unit_mode = UNITS_RAW;
@@ -290,7 +291,7 @@ static int cmd_df(int argc, char **argv)
 		}
 	}
 
-	if (check_argc_max(argc, optind + 1))
+	if (check_argc_exact(argc, 2 + opt_num))
 		usage(cmd_df_usage);
 
 	path = argv[optind];
-- 
2.1.2

