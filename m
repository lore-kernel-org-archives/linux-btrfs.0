Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41516 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab2JQNwt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 09:52:49 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so5096232lbo.19
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 06:52:47 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Oct 2012 15:52:47 +0200
Message-ID: <CAOcd+r1ivnWAbG7BSpR2DZgZazsSf+jg1oGYCf9rKBb+Gt46xA@mail.gmail.com>
Subject: [PATCH] Btrfs: Send: preserve ownership (uid and gid) also for symlinks.
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, chris.mason@fusionio.com,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch also requires a change in the user-space part of "receive".
We need to use "lchown" instead of "chown". We will do this in the
following patch.

Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c7beb54..7d1eed2 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4033,22 +4033,21 @@ static int finish_inode_if_needed(struct
send_ctx *sctx, int at_end)
 	if (ret < 0)
 		goto out;

-	if (!S_ISLNK(sctx->cur_inode_mode)) {
-		if (!sctx->parent_root || sctx->cur_inode_new) {
+	if (!sctx->parent_root || sctx->cur_inode_new) {
+		need_chown = 1;
+		if (!S_ISLNK(sctx->cur_inode_mode))
 			need_chmod = 1;
-			need_chown = 1;
-		} else {
-			ret = get_inode_info(sctx->parent_root, sctx->cur_ino,
-					NULL, NULL, &right_mode, &right_uid,
-					&right_gid, NULL);
-			if (ret < 0)
-				goto out;
+	} else {
+		ret = get_inode_info(sctx->parent_root, sctx->cur_ino,
+				NULL, NULL, &right_mode, &right_uid,
+				&right_gid, NULL);
+		if (ret < 0)
+			goto out;

-			if (left_uid != right_uid || left_gid != right_gid)
-				need_chown = 1;
-			if (left_mode != right_mode)
-				need_chmod = 1;
-		}
+		if (left_uid != right_uid || left_gid != right_gid)
+			need_chown = 1;
+		if (!S_ISLNK(sctx->cur_inode_mode) && left_mode != right_mode)
+			need_chmod = 1;
 	}

 	if (S_ISREG(sctx->cur_inode_mode)) {
