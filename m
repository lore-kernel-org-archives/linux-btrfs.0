Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:47150 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726207AbeHERTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Aug 2018 13:19:31 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] fs/btrfs/extent-tree: remove redudant variable "err"
Date: Sun, 5 Aug 2018 23:02:50 +0800
Message-ID: <1533481371-21349-3-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com>
References: <1533481371-21349-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The err is not used after initalization, So just remove it. And make
the function to be void function.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/extent-tree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b1f2f64..ed02305 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6464,11 +6464,10 @@ static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
  * reserve set to 0 in order to clear the reservation.
  */
 
-static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
-				     u64 num_bytes, int delalloc)
+static void btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
+				      u64 num_bytes, int delalloc)
 {
 	struct btrfs_space_info *space_info = cache->space_info;
-	int ret = 0;
 
 	spin_lock(&space_info->lock);
 	spin_lock(&cache->lock);
@@ -6481,7 +6480,6 @@ static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
 		cache->delalloc_bytes -= num_bytes;
 	spin_unlock(&cache->lock);
 	spin_unlock(&space_info->lock);
-	return ret;
 }
 void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info)
 {
-- 
1.7.12.4

