Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:56926 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933444AbeE2N10 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 09:27:26 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3] Btrfs: remove unused check of skip_locking
Date: Tue, 29 May 2018 21:27:06 +0800
Message-Id: <1527600426-131024-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>
References: <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The check is superfluous since all of callers who set search_for_commit
also have skip_locking set.

ASSERT() is put in place to ensure skip_locking is set by callers.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
v3: Add assertion and comments to ensure skip_locking is not forgot by callers.
v2: Rebase.

 fs/btrfs/ctree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a2bcfdf85726..9c4f6b919d51 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2623,8 +2623,11 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 		level = btrfs_header_level(b);
 		if (p->need_commit_sem)
 			up_read(&fs_info->commit_root_sem);
-		if (!p->skip_locking)
-			btrfs_tree_read_lock(b);
+		/*
+		 * Ensure that all callers have set skip_locking when
+		 * p->search_commit_root = 1.
+		 */
+		ASSERT(p->skip_locking == 1);
 
 		goto out;
 	}
-- 
1.8.3.1

