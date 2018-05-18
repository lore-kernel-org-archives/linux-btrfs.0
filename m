Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:52283 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751971AbeERDAk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 23:00:40 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/6] Btrfs: remove superfluous free_extent_buffer
Date: Fri, 18 May 2018 11:00:19 +0800
Message-Id: <1526612424-97061-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

read_block_for_search() can be simplified as,

tmp = find_extent_buffer();
if (tmp)
   return;

free_extent_buffer();
read_tree_block();

Apparently, @tmp must be NULL at this point, free_extent_buffer() is not
needed.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b3f6f300e492..9fa3d77c98d4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2432,7 +2432,6 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
 	btrfs_unlock_up_safe(p, level + 1);
 	btrfs_set_path_blocking(p);
 
-	free_extent_buffer(tmp);
 	if (p->reada != READA_NONE)
 		reada_for_search(fs_info, p, level, slot, key->objectid);
 
-- 
1.8.3.1

