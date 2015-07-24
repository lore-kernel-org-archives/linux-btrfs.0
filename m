Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33551 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbGXKVI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 06:21:08 -0400
Received: by lbbyj8 with SMTP id yj8so12258425lbb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 03:21:06 -0700 (PDT)
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>
Subject: [PATCH] btrfs-progs: defrag: remove unused variable
Date: Fri, 24 Jul 2015 12:21:02 +0200
Message-Id: <1437733262-7117-1-git-send-email-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A leftover from when recursive defrag was added.

Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>
---
 cmds-filesystem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 00a3f78..1b7b4c1 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1131,7 +1131,6 @@ static int cmd_defrag(int argc, char **argv)
 	int i;
 	int recursive = 0;
 	int ret = 0;
-	struct btrfs_ioctl_defrag_range_args range;
 	int e = 0;
 	int compress_type = BTRFS_COMPRESS_NONE;
 	DIR *dirstream;
@@ -1189,7 +1188,7 @@ static int cmd_defrag(int argc, char **argv)
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_defrag_usage);
 
-	memset(&defrag_global_range, 0, sizeof(range));
+	memset(&defrag_global_range, 0, sizeof(defrag_global_range));
 	defrag_global_range.start = start;
 	defrag_global_range.len = len;
 	defrag_global_range.extent_thresh = (u32)thresh;
-- 
2.1.4

