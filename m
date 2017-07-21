Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34750 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754562AbdGUR3O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 13:29:14 -0400
Received: by mail-qt0-f193.google.com with SMTP id o3so3120338qto.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 10:29:14 -0700 (PDT)
From: josef@toxicpanda.com
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 3/3] btrfs: increase ctx->pos for delayed dir index
Date: Fri, 21 Jul 2017 13:29:09 -0400
Message-Id: <1500658149-20410-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1500658149-20410-1-git-send-email-jbacik@fb.com>
References: <1500658149-20410-1-git-send-email-jbacik@fb.com>
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

