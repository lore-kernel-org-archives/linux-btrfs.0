Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:43895 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbeHMI6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 04:58:47 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs:free-space-cache: remove unneeded NULL check before kfree
Date: Mon, 13 Aug 2018 14:06:08 +0800
Message-ID: <1534140369-11578-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kfree has taken the null pointer into account. So remove the check
before kfree.

The issue is detected with the help of Coccinelle.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 fs/btrfs/free-space-cache.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c3888c1..69d639f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2110,8 +2110,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 
 out:
 	if (info) {
-		if (info->bitmap)
-			kfree(info->bitmap);
+		kfree(info->bitmap);
 		kmem_cache_free(btrfs_free_space_cachep, info);
 	}
 
@@ -3605,8 +3604,7 @@ int test_add_free_space_entry(struct btrfs_block_group_cache *cache,
 
 	if (info)
 		kmem_cache_free(btrfs_free_space_cachep, info);
-	if (map)
-		kfree(map);
+	kfree(map);
 	return 0;
 }
 
-- 
1.7.12.4
