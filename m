Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:41450 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753556AbeEORwN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 13:52:13 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/6] Btrfs: remove unused check of skip_locking
Date: Wed, 16 May 2018 01:52:06 +0800
Message-Id: <1526406728-109055-5-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The check is superfluous since all of callers who set search_for_commit
also have skip_locking set.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 399839df7a8f..cf34eca41d4e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2623,8 +2623,6 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 		level = btrfs_header_level(b);
 		if (p->need_commit_sem)
 			up_read(&fs_info->commit_root_sem);
-		if (!p->skip_locking)
-			btrfs_tree_read_lock(b);
 
 		goto out;
 	}
-- 
1.8.3.1

