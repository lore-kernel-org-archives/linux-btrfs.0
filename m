Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64501 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab3B0LEX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 06:04:23 -0500
Received: by mail-pb0-f48.google.com with SMTP id wy12so303059pbc.21
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 03:04:22 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH 2/2] Btrfs-progs: output the error reason when qgroup_show fails
Date: Wed, 27 Feb 2013 19:04:18 +0800
Message-Id: <1361963058-1966-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The original code forgot to output the reason why the commands failed,
fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 cmds-qgroup.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 79888c8..275f00f 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -298,6 +298,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
+	int e;
 	char *path = argv[1];
 
 	if (check_argc_exact(argc, 2))
@@ -310,9 +311,11 @@ static int cmd_qgroup_show(int argc, char **argv)
 	}
 
 	ret = list_qgroups(fd);
+	e = errno;
 	close(fd);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: can't list qgroups\n");
+		fprintf(stderr, "ERROR: can't list qgroups: %s\n",
+				strerror(e));
 		return 30;
 	}
 
-- 
1.7.7.6

