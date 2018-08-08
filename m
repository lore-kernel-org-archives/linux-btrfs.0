Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:33310 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727109AbeHHQTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 12:19:33 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 2/3] fs/btrfs/extent-tree: change btrfs_free_reserved_bytes to be void funtion
Date: Wed, 8 Aug 2018 21:47:54 +0800
Message-ID: <1533736075-8691-3-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
References: <1533736075-8691-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_reserved_bytes defines the variable "ret" for return value,
but it is not modified after initialzation. Further, I find that any of
the callees do not handle the return value, so it is safe to drop the
unneeded value "ret".

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/extent-tree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f77226d..ff305f5 100644
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

