Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:45826 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbbFWKj7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 06:39:59 -0400
From: Robbie Ko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v3 5/7] Btrfs: incremental send, fix rmdir but dir have a unprocess item
Date: Tue, 23 Jun 2015 18:39:49 +0800
Message-Id: <1435055991-10109-6-git-send-email-robbieko@synology.com>
In-Reply-To: <1435055991-10109-1-git-send-email-robbieko@synology.com>
References: <1435055991-10109-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's one case where we attempt to rmdir a directory prematurely.

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

While process inode 281, since inode 280 is waiting for inode 282,
rmdir_ino of struct waitng_dir_move for inode 280 will assigned to 281
and an orphan_dir_info will be created for node 281 in can_rmdir().

Such that, when process inode 282, we will do following steps.
First, move inode 282 from a/c to c
Second, move inode 280 from del/tmp to c/tmp
Third, try to remove inode 281

In Third step, we pass 283 (sctx->cur_ino + 1) as the send_progress to the
can_rmdir() function and that makes it return true when it shouldn't,
because the inode 283 wasn't processed yet and it's still a child of
the directory with inode number 281, which makes the receiver run into
an ENOTEMPTY error when attempting to remove the directory.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 194df76..838abf4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3211,7 +3211,7 @@ static int apply_dir_move(struct send_ctx *sctx, struct pending_dir_move *pm)
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

