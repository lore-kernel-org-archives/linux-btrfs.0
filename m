Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbaBMDUM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 22:20:12 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1D3K49c002790
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 11:20:05 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] btrfs-progs: use usage() to replace the warning msg on no-arg usage
Date: Thu, 13 Feb 2014 11:16:35 +0800
Message-Id: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To be consistent with the other cmds, replace the warning msg
with usage() when send/receive are used without any args.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-receive.c | 6 ++----
 cmds-send.c    | 7 ++-----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index cce37a7..72d9cc8 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -951,10 +951,8 @@ int cmd_receive(int argc, char **argv)
 		}
 	}
 
-	if (optind + 1 != argc) {
-		fprintf(stderr, "ERROR: receive needs path to subvolume\n");
-		return 1;
-	}
+	if (optind + 1 != argc)
+		usage(cmd_receive_usage);
 
 	tomnt = argv[optind];
 
diff --git a/cmds-send.c b/cmds-send.c
index fc9a01e..e44770f 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -571,11 +571,8 @@ int cmd_send(int argc, char **argv)
 		}
 	}
 
-	if (optind == argc) {
-		fprintf(stderr, "ERROR: send needs path to snapshot\n");
-		ret = 1;
-		goto out;
-	}
+	if (optind == argc)
+		usage(cmd_send_usage);
 
 	if (outname != NULL) {
 		send.dump_fd = creat(outname, 0600);
-- 
1.8.1.4

