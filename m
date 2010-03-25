From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 07/18] btrfs: Fix a BUG_ON boundary typo
Date: Thu, 25 Mar 2010 20:32:12 +0800
Message-ID: <4BAB57CC.9080809@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

logical's value should be [em->start, em->start + em->len),
so we need to use
  BUG_ON(em->start > logical || em->start + em->len <= logical);
instead of
  BUG_ON(em->start > logical || em->start + em->len < logical);

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9df8e3f..844c393 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2598,7 +2598,7 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 	read_unlock(&em_tree->lock);
 	BUG_ON(!em);
 
-	BUG_ON(em->start > logical || em->start + em->len < logical);
+	BUG_ON(em->start > logical || em->start + em->len <= logical);
 	map = (struct map_lookup *)em->bdev;
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
 		ret = map->num_stripes;
@@ -2673,7 +2673,7 @@ again:
 		BUG();
 	}
 
-	BUG_ON(em->start > logical || em->start + em->len < logical);
+	BUG_ON(em->start > logical || em->start + em->len <= logical);
 	map = (struct map_lookup *)em->bdev;
 	offset = logical - em->start;
 
-- 
1.6.5.2


