Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbeIGTgw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:52 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 38E0BAD5D
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:34 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/11] btrfs: reada: reorder dev-replace locks before radix tree preload
Date: Fri,  7 Sep 2018 16:55:18 +0200
Message-Id: <c185dd64c4d1e10a7a7602c32f97567225666c9a.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The read lock is going to use rw semaphore that might sleep, this is not
possible in the radix tree preload section. The lock nesting is now:

* device replace
  * radix tree preload
    * readahead spinlock

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index dec14b739b10..6c4fdd98582d 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -376,26 +376,28 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		goto error;
 	}
 
+	/* insert extent in reada_tree + all per-device trees, all or nothing */
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	ret = radix_tree_preload(GFP_KERNEL);
-	if (ret)
+	if (ret) {
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
+	}
 
-	/* insert extent in reada_tree + all per-device trees, all or nothing */
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	spin_lock(&fs_info->reada_lock);
 	ret = radix_tree_insert(&fs_info->reada_tree, index, re);
 	if (ret == -EEXIST) {
 		re_exist = radix_tree_lookup(&fs_info->reada_tree, index);
 		re_exist->refcnt++;
 		spin_unlock(&fs_info->reada_lock);
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		radix_tree_preload_end();
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
 	}
 	if (ret) {
 		spin_unlock(&fs_info->reada_lock);
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		radix_tree_preload_end();
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
 	}
 	radix_tree_preload_end();
-- 
2.18.0
