Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59775 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2KHJvx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Nov 2012 04:51:53 -0500
Message-ID: <509B80C9.2070107@cn.fujitsu.com>
Date: Thu, 08 Nov 2012 17:52:09 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Arne Jansen <sensille@gmx.net>, wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] Btrfs-progs: fix arg parsing for btrfs qgroup limit commands
References: <509B785A.9010000@cn.fujitsu.com>
In-Reply-To: <509B785A.9010000@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
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
---
 cmds-qgroup.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

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
-- 1.7.7.6 









