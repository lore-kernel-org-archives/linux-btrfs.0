Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1557 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756849AbaFSBb7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:31:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1VO74019665
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:31:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/6] Btrfs-progs: btrfs-restore, don't allow users to specify -r and -f at the same time
Date: Thu, 19 Jun 2014 09:27:08 +0800
Message-ID: <1403141229-25565-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two options are used for same purpose, but they are exclusive with
each other. Make it clear to common users.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index 8267ab6..3a29ed6 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1212,6 +1212,11 @@ int cmd_restore(int argc, char **argv)
 	else if (list_roots && optind >= argc)
 		usage(cmd_restore_usage);
 
+	if (fs_location && root_objectid) {
+		fprintf(stderr, "don't use -f and -r at the same time.\n");
+		return 1;
+	}
+
 	if ((ret = check_mounted(argv[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n",
 			strerror(-ret));
-- 
1.9.0

