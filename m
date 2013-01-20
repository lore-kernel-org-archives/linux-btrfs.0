Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:34577 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab3ATVEl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:41 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210440.TZMF21186.eastrmfepo203.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:40 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 09/13] Btrfs-progs: fix arg parsing for btrfs qgroup limit commands
Date: Sun, 20 Jan 2013 16:04:14 -0500
Message-Id: <1358715858-4469-10-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

We can use this command in two ways.
1. btrfs qgroup limit size qgroupid path
2. btrfs qgroup limit size path

Before applying this patch, we differentiate them by check the parsing result
of the second argument. It is not so good because it may make some mistakes,
For example:
  btrfs qgroup limit 1M 123456
 			^ It is a subvolume name.

In fact, we can differentiate them just by the number of arguments, so fix it
by this way.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 cmds-qgroup.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 1525c11..129a4f0 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -383,7 +383,6 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	}
 
 	memset(&args, 0, sizeof(args));
-	args.qgroupid = parse_qgroupid(argv[optind + 1]);
 	if (size) {
 		if (compressed)
 			args.lim.flags |= BTRFS_QGROUP_LIMIT_RFER_CMPR |
@@ -397,9 +396,8 @@ static int cmd_qgroup_limit(int argc, char **argv)
 		}
 	}
 
-	if (args.qgroupid == 0) {
-		if (check_argc_exact(argc - optind, 2))
-			usage(cmd_qgroup_limit_usage);
+	if (argc - optind == 2) {
+		args.qgroupid = 0;
 		path = argv[optind + 1];
 		ret = test_issubvolume(path);
 		if (ret < 0) {
@@ -415,11 +413,11 @@ static int cmd_qgroup_limit(int argc, char **argv)
 		 * keep qgroupid at 0, this indicates that the subvolume the
 		 * fd refers to is to be limited
 		 */
-	} else {
-		if (check_argc_exact(argc - optind, 3))
-			usage(cmd_qgroup_limit_usage);
+	} else if (argc - optind == 3) {
+		args.qgroupid = parse_qgroupid(argv[optind + 1]);
 		path = argv[optind + 2];
-	}
+	} else
+		usage(cmd_qgroup_limit_usage);
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
-- 
1.8.1

