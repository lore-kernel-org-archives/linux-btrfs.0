Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:43981 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbcJGGJy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Oct 2016 02:09:54 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: fix enospc in punch hole
Date: Fri,  7 Oct 2016 14:09:36 +0800
Message-Id: <1475820576-27316-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

when extent-tree level > BTRFS_MAX_LEVEL / 2,
__btrfs_drop_extents -> btrfs_duplicate_item ->
setup_leaf_for_split -> split_leaf
maybe enospc, because min_size is too small,
need use btrfs_calc_trans_metadata_size.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fea31a4..809ca85 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2322,7 +2322,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	u64 tail_len;
 	u64 orig_start = offset;
 	u64 cur_offset;
-	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
+	u64 min_size = btrfs_calc_trans_metadata_size(root, 1);
 	u64 drop_end;
 	int ret = 0;
 	int err = 0;
@@ -2469,7 +2469,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		ret = -ENOMEM;
 		goto out_free;
 	}
-	rsv->size = btrfs_calc_trunc_metadata_size(root, 1);
+	rsv->size = btrfs_calc_trans_metadata_size(root, 1);
 	rsv->failfast = 1;
 
 	/*
-- 
1.9.1

