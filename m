Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:60992 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539Ab3CUOam (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 10:30:42 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Cc: ablock84@gmail.com
Subject: [PATCH] Btrfs: fix EIO from btrfs send in is_extent_unchanged for punched holes
Date: Thu, 21 Mar 2013 15:30:23 +0100
Message-Id: <1363876223-18410-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When you take a snapshot, punch a hole where there has been data, then take
another snapshot and try to send an incremental stream, btrfs send would
give you EIO. That is because is_extent_unchanged had no support for holes
being punched. With this patch, instead of returning EIO we just return
0 (== the extent is not unchanged) and we're good.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Alexander Block <ablock84@gmail.com>
---
 fs/btrfs/send.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 68da757..ed897dc 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3945,12 +3945,10 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 		    found_key.type != key.type) {
 			key.offset += right_len;
 			break;
-		} else {
-			if (found_key.offset != key.offset + right_len) {
-				/* Should really not happen */
-				ret = -EIO;
-				goto out;
-			}
+		}
+		if (found_key.offset != key.offset + right_len) {
+			ret = 0;
+			goto out;
 		}
 		key = found_key;
 	}
-- 
1.7.1

