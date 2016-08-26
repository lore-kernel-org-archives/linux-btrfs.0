Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57317 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbcHZDmA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 23:42:00 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
Subject: [PATCH] btrfs: do not decrease bytes_may_use when replaying extents
Date: Fri, 26 Aug 2016 11:33:14 +0800
Message-Id: <1472182394-7785-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When replaying extents, there is no need to update bytes_may_use
in btrfs_alloc_logged_file_extent(), otherwise it'll trigger a
WARN_ON about bytes_may_use.

Fixes: ("btrfs: update btrfs_space_info's bytes_may_use timely")
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ae8f9aa..7a15990 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8242,6 +8242,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	struct btrfs_block_group_cache *block_group;
+	struct btrfs_space_info *space_info;
 
 	/*
 	 * Mixed block groups will exclude before processing the log so we only
@@ -8257,9 +8258,14 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	if (!block_group)
 		return -EINVAL;
 
-	ret = btrfs_add_reserved_bytes(block_group, ins->offset,
-				       ins->offset, 0);
-	BUG_ON(ret); /* logic error */
+	space_info = block_group->space_info;
+	spin_lock(&space_info->lock);
+	spin_lock(&block_group->lock);
+	space_info->bytes_reserved += ins->offset;
+	block_group->reserved += ins->offset;
+	spin_unlock(&block_group->lock);
+	spin_unlock(&space_info->lock);
+
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
 	btrfs_put_block_group(block_group);
-- 
2.9.0



