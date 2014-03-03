Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:60540 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaCCM27 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 07:28:59 -0500
Received: by mail-we0-f169.google.com with SMTP id w62so1287685wes.28
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 04:28:58 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: avoid unnecessary utimes update in incremental send
Date: Mon,  3 Mar 2014 12:28:40 +0000
Message-Id: <1393849720-32076-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we're finishing processing of an inode, if we're dealing with a
directory inode that has a pending move/rename operation, we don't
need to send a utimes update instruction to the send stream, as we'll
do it later after doing the move/rename operation. Therefore we save
some time here building paths and doing btree lookups.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 298e25d..d0e3828 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4956,18 +4956,19 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 		ret = apply_children_dir_moves(sctx);
 		if (ret)
 			goto out;
+		/*
+		 * Need to send that every time, no matter if it actually
+		 * changed between the two trees as we have done changes to
+		 * the inode before. If our inode is a directory and it's
+		 * waiting to be moved/renamed, we will send its utimes when
+		 * it's moved/renamed, therefore we don't need to do it here.
+		 */
+		sctx->send_progress = sctx->cur_ino + 1;
+		ret = send_utimes(sctx, sctx->cur_ino, sctx->cur_inode_gen);
+		if (ret < 0)
+			goto out;
 	}
 
-	/*
-	 * Need to send that every time, no matter if it actually
-	 * changed between the two trees as we have done changes to
-	 * the inode before.
-	 */
-	sctx->send_progress = sctx->cur_ino + 1;
-	ret = send_utimes(sctx, sctx->cur_ino, sctx->cur_inode_gen);
-	if (ret < 0)
-		goto out;
-
 out:
 	return ret;
 }
-- 
1.7.9.5

