Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34984 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbbGXIfT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 04:35:19 -0400
Received: by lahh5 with SMTP id h5so9880024lah.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 01:35:17 -0700 (PDT)
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>
Subject: [PATCH] btrfs-progs: defrag: fix threshold overflow again
Date: Fri, 24 Jul 2015 10:35:02 +0200
Message-Id: <1437726902-6458-1-git-send-email-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit dedb1ebeee847e3c4d71e14d0c1077887630e44a broke commit
96cfbbf0ea9fce7ecaa9e03964474f407f6e76ab.

Casting thresh value greater than (u32)-1 simply truncates bits while
desired value is (u32)-1 for max defrag threshold.

I.e. "btrfs fi defrag -t 4g" is trimmed/truncated to 0
and "-t 5g" to 1073741824.

Also added a missing newline.

Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>
---
 cmds-filesystem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 800aa4d..00a3f78 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1172,8 +1172,9 @@ static int cmd_defrag(int argc, char **argv)
 			thresh = parse_size(optarg);
 			if (thresh > (u32)-1) {
 				fprintf(stderr,
-			"WARNING: target extent size %llu too big, trimmed to %u",
+			"WARNING: target extent size %llu too big, trimmed to %u\n",
 					thresh, (u32)-1);
+				thresh = (u32)-1;
 			}
 			defrag_global_fancy_ioctl = 1;
 			break;
-- 
2.1.4

