Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab2IFKou (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A49NT017616
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:04:14 +0800
Message-ID: <5048750C.1030007@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:03:56 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 09/12] Btrfs: fix wrong size for the reservation of the,
 snapshot creation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

We should insert/update 6 items(root ref, root backref, dir item, dir index,
root item and parent inode) when creating a snapshot, not 5 items, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- new patch.
---
 fs/btrfs/extent-tree.c |    6 +++---
 fs/btrfs/ioctl.c       |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 840bfee..a010234 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4418,10 +4418,10 @@ int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *src_rsv = get_block_rsv(trans, root);
 	struct btrfs_block_rsv *dst_rsv = &pending->block_rsv;
 	/*
-	 * two for root back/forward refs, two for directory entries
-	 * and one for root of the snapshot.
+	 * two for root back/forward refs, two for directory entries,
+	 * one for root of the snapshot and one for parent inode.
 	 */
-	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 6);
 	dst_rsv->space_info = src_rsv->space_info;
 	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3a16327..9384a2a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -526,7 +526,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 		*inherit = NULL;	/* take responsibility to free it */
 	}
 
-	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
+	trans = btrfs_start_transaction(root->fs_info->extent_root, 6);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto fail;
-- 
1.7.6.5
