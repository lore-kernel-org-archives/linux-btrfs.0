From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V5 1/2] btrfs: use GFP_NOFS instead of GFP_KERNEL
Date: Thu, 24 Mar 2011 19:41:21 +0800
Message-ID: <4D8B2DE1.2040002@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Ito <t-itoh@jp.fujitsu.com>, David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In the filesystem context, we must allocate memory by GFP_NOFS,
or we may start another filesystem operation and make kswap thread hang up.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f1db57d..42061d2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -471,7 +471,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	if (load_cache_only)
 		return 0;
 
-	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_KERNEL);
+	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_NOFS);
 	BUG_ON(!caching_ctl);
 
 	INIT_LIST_HEAD(&caching_ctl->list);
@@ -1743,7 +1743,7 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
-	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
+	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_NOFS,
 			BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 }
 
-- 
1.7.3.1
