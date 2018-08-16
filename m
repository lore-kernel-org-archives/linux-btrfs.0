Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:55683 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727410AbeHPTsp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 15:48:45 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <dsterba@suse.com>
CC: <jbacik@fb.com>, <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv4 2/3] btrfs: change btrfs_free_reserved_bytes to be void funtion
Date: Fri, 17 Aug 2018 00:37:14 +0800
Message-ID: <1534437435-51605-3-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1534437435-51605-1-git-send-email-zhongjiang@huawei.com>
References: <1534437435-51605-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_reserved_bytes use the variable "ret" for return return value,
but it is not modified after initialzation. Further, I find that any of
the callers do not handle the return value, so it is safe to drop the
unneeded "ret" and make it to be void function.

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
