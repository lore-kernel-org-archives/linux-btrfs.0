Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56301 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbaCFDkl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 22:40:41 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s263eXPE002066
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 11:40:36 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: cleanup dead return after usage() for fi-disk_usage
Date: Thu, 6 Mar 2014 11:36:46 +0800
Message-Id: <1394077008-3568-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The usage() calls exit() internally, so remove the return after it.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-fi-disk_usage.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index e4eb72b..a3b06be 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -494,10 +494,8 @@ int cmd_filesystem_df(int argc, char **argv)
 		}
 	}
 
-	if (check_argc_min(argc - optind, 1)) {
+	if (check_argc_min(argc - optind, 1))
 		usage(cmd_filesystem_df_usage);
-		return 21;
-	}
 
 	for (i = optind; i < argc ; i++) {
 		int r, fd;
@@ -914,10 +912,8 @@ int cmd_filesystem_disk_usage(int argc, char **argv)
 		}
 	}
 
-	if (check_argc_min(argc - optind, 1)) {
+	if (check_argc_min(argc - optind, 1))
 		usage(cmd_filesystem_disk_usage_usage);
-		return 21;
-	}
 
 	for (i = optind; i < argc ; i++) {
 		int r, fd;
@@ -1050,10 +1046,8 @@ int cmd_device_disk_usage(int argc, char **argv)
 		}
 	}
 
-	if (check_argc_min(argc - optind, 1)) {
+	if (check_argc_min(argc - optind, 1))
 		usage(cmd_device_disk_usage_usage);
-		return 21;
-	}
 
 	for (i = optind; i < argc ; i++) {
 		int r, fd;
-- 
1.8.1.4

