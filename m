Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35646 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbcLMXvP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 18:51:15 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: use down_read_nested to make lockdep silent
Date: Tue, 13 Dec 2016 15:58:40 -0800
Message-Id: <1481673520-30560-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1480628659-17731-1-git-send-email-bo.li.liu@oracle.com>
References: <1480628659-17731-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If @block_group is not @used_bg, it'll try to get @used_bg's lock without
droping @block_group 's lock and lockdep has throwed a scary deadlock warning
about it.
Fix it by using down_read_nested.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Use 'SINGLE_DEPTH_NESTING' to avoid magic number.

 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4607af3..68e9d25 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7397,7 +7397,8 @@ btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
 
 		spin_unlock(&cluster->refill_lock);
 
-		down_read(&used_bg->data_rwsem);
+		/* We should only have one-level nested. */
+		down_read_nested(&used_bg->data_rwsem, SINGLE_DEPTH_NESTING);
 
 		spin_lock(&cluster->refill_lock);
 		if (used_bg == cluster->block_group)
-- 
2.5.5

