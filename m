Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50112 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbcLAVgg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 16:36:36 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: use down_read_nested to make lockdep silent
Date: Thu,  1 Dec 2016 13:44:19 -0800
Message-Id: <1480628659-17731-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If @block_group is not @used_bg, it'll try to get @used_bg's lock without
droping @block_group 's lock and lockdep has throwed a scary deadlock warning
about it.
Fix it by using down_read_nested.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 210c94a..cdb082a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7394,7 +7394,8 @@ btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
 
 		spin_unlock(&cluster->refill_lock);
 
-		down_read(&used_bg->data_rwsem);
+		/* We should only have one-level nested. */
+		down_read_nested(&used_bg->data_rwsem, 1);
 
 		spin_lock(&cluster->refill_lock);
 		if (used_bg == cluster->block_group)
-- 
2.5.5

