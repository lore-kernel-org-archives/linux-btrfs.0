Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34435 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755643AbdGXTOa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 15:14:30 -0400
Received: by mail-qk0-f194.google.com with SMTP id q66so10773100qki.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 12:14:30 -0700 (PDT)
From: josef@toxicpanda.com
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 2/2] btrfs: increase ctx->pos for delayed dir index
Date: Mon, 24 Jul 2017 15:14:26 -0400
Message-Id: <1500923666-29670-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1500923666-29670-1-git-send-email-jbacik@fb.com>
References: <1500923666-29670-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Our dir_context->pos is supposed to hold the next position we're
supposed to look.  If we successfully insert a delayed dir index we
could end up with a duplicate entry because we don't increase ctx->pos
after doing the dir_emit.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 8ae409b..19e4ad2 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1727,6 +1727,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 
 		if (over)
 			return 1;
+		ctx->pos++;
 	}
 	return 0;
 }
-- 
2.7.4

