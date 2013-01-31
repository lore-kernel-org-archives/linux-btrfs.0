Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46415 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab3AaIWb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 03:22:31 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0V8MSlC017906
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 16:22:28 +0800
Message-ID: <510A2984.6010601@cn.fujitsu.com>
Date: Thu, 31 Jan 2013 16:21:24 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, miaox@cn.fujitsu.com
Subject: [PATCH] Btrfs-prog/send: fix wrong dump_fd check in cmd_send_start()
References: <510A2791.1010607@cn.fujitsu.com>
In-Reply-To: <510A2791.1010607@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In cmd_send_start(), there is a check to make sure dump_fd is not a tty
before parsing command options. So if we use the option "-f file",
it doesn't work for the dump_fd has not been created. So fix it.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
 cmds-send.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 2b9a610..aafa800 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -429,11 +429,6 @@ int cmd_send_start(int argc, char **argv)
 	memset(&send, 0, sizeof(send));
 	send.dump_fd = fileno(stdout);
 
-	if (isatty(send.dump_fd)) {
-		fprintf(stderr, "ERROR: not dumping send stream into a terminal, redirect it into a file\n");
-		return 1;
-	}
-
 	while ((c = getopt(argc, argv, "vf:i:p:")) != -1) {
 		switch (c) {
 		case 'v':
@@ -497,6 +492,13 @@ int cmd_send_start(int argc, char **argv)
 		}
 	}
 
+	if (isatty(send.dump_fd)) {
+		fprintf(stderr, 
+			"ERROR: not dumping send stream into a terminal, "
+			"redirect it into a file\n");
+		return 1;
+	}
+
 	/* use first send subvol to determine mount_root */
 	subvol = argv[optind];
 
-- 
1.7.7.6



