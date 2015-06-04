Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:37099 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbbFDL1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 07:27:54 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 4/5] Btrfs: incremental send, fix rmdir but dir have a unprocess item
Date: Thu,  4 Jun 2015 19:18:09 +0800
Message-Id: <1433416690-19177-5-git-send-email-robbieko@synology.com>
In-Reply-To: <1433416690-19177-1-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's one case where we can't rmdir issue.

Example:

Parent snapshot:
|---- a/ (ino 279)
  |---- c (ino 282)
|---- del/ (ino 281)
  |---- tmp/ (ino 280)
  |---- long/ (ino 283)

Send snapshot:
|---- a/ (ino 279)
  |---- long (ino 283)
|---- c/ (ino 282)
  |---- tmp/ (ino 280)

Here we process 281 use can_rmdir check, but 280 is waiting, so create orphan_dir_info
and when 282 is move to dest, so 280 can move to c/tmp, and now run can_rmdir check again.
Return is true, because sctx->cur_ino is 282 , and call can_rmdir(, sctx->cur_ino + 1)
so 283 is equal or lesser than (sctx->cur_ino + 1), not anything unprocess.
So fix this rmdir for this case.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ff9d052..e8eb3ab 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3213,7 +3213,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
 			/* already deleted */
 			goto finish;
 		}
-		ret = can_rmdir(sctx, rmdir_ino, odi->gen, sctx->cur_ino + 1);
+		ret = can_rmdir(sctx, rmdir_ino, odi->gen, sctx->cur_ino);
 		if (ret < 0)
 			goto out;
 		if (!ret)
-- 
1.9.1

