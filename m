Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:34410 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbFXOWW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 10:22:22 -0400
Received: by lagx9 with SMTP id x9so27062821lag.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 07:22:21 -0700 (PDT)
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>
Subject: [PATCH] btrfs-progs: Fix defrag threshold overflow
Date: Wed, 24 Jun 2015 16:21:06 +0200
Message-Id: <1435155666-11214-1-git-send-email-patrik.lundquist@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs fi defrag -t 1T overflows the u32 thresh variable and default, instead of max, threshold is used.

Signed-off-by: Patrik Lundquist <patrik.lundquist@gmail.com>
---
 cmds-filesystem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 530f815..72bb45b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1127,7 +1127,7 @@ static int cmd_defrag(int argc, char **argv)
 	int flush = 0;
 	u64 start = 0;
 	u64 len = (u64)-1;
-	u32 thresh = 0;
+	u64 thresh = 0;
 	int i;
 	int recursive = 0;
 	int ret = 0;
@@ -1186,7 +1186,7 @@ static int cmd_defrag(int argc, char **argv)
 	memset(&defrag_global_range, 0, sizeof(range));
 	defrag_global_range.start = start;
 	defrag_global_range.len = len;
-	defrag_global_range.extent_thresh = thresh;
+	defrag_global_range.extent_thresh = thresh > (u32)-1 ? (u32)-1 : (u32)thresh;
 	if (compress_type) {
 		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_COMPRESS;
 		defrag_global_range.compress_type = compress_type;
-- 
2.1.4

