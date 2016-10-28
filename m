Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:43533 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034416AbcJ1CdZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:33:25 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2] Btrfs: fix enospc in hole punching
Date: Fri, 28 Oct 2016 10:32:54 +0800
Message-Id: <1477621974-1103-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

The hole punching can result in adding new leafs (and as a consequence
new nodes) to the tree because when we find file extent items that span
beyond the hole range we may end up not deleting them (just adjusting them)
and add new file extent items representing holes.

That after splitting a leaf (therefore creating a new one), a new node
might be added to each level of the tree (since there's a new key and
every parent node was full).

Fix this by use btrfs_calc_trans_metadata_size instead of
btrfs_calc_trunc_metadata_size.

v2:
* Improve the change log

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

