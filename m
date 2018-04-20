Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58871 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755160AbeDTOY1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:24:27 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7FE84AEBF
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 14:24:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/6] btrfs: add discard secure to clear unused space
Date: Fri, 20 Apr 2018 16:21:55 +0200
Message-Id: <c5d6e5fcbe372d8006e8db4f13065e2cbcbf2cfd.1524233244.git.dsterba@suse.com>
In-Reply-To: <cover.1524233244.git.dsterba@suse.com>
References: <cover.1524233244.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c     | 14 ++++++++++++--
 include/uapi/linux/btrfs.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 21a24fff32dd..285bace8e2c6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2037,10 +2037,15 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 static int btrfs_issue_clear_op(struct block_device *bdev, u64 start, u64 size,
 		enum btrfs_clear_op_type clear)
 {
+	int flags = 0;
+
 	switch (clear) {
+	case BTRFS_CLEAR_OP_DISCARD_SECURE:
+		flags = BLKDEV_DISCARD_SECURE;
+		/* fall through */
 	case BTRFS_CLEAR_OP_DISCARD:
 		return blkdev_issue_discard(bdev, start >> 9, size >> 9,
-				GFP_NOFS, 0);
+				GFP_NOFS, flags);
 	case BTRFS_CLEAR_OP_ZERO:
 		return blkdev_issue_zeroout(bdev, start >> 9, size >> 9,
 				GFP_NOFS, 0);
@@ -2129,7 +2134,8 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 	struct btrfs_bio *bbio = NULL;
 	int rw;
 
-	if (clear == BTRFS_CLEAR_OP_DISCARD)
+	if (clear == BTRFS_CLEAR_OP_DISCARD ||
+	    clear == BTRFS_CLEAR_OP_DISCARD_SECURE)
 		rw = BTRFS_MAP_DISCARD;
 	else
 		rw = BTRFS_MAP_WRITE;
@@ -2160,6 +2166,10 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 			    !blk_queue_discard(req_q))
 				continue;
 
+			if (clear == BTRFS_CLEAR_OP_DISCARD_SECURE &&
+			    !blk_queue_secure_erase(req_q))
+				continue;
+
 			ret = btrfs_issue_discard(stripe->dev->bdev,
 						  stripe->physical,
 						  stripe->length,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 860f9df01614..1becbb241e53 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -743,6 +743,7 @@ enum btrfs_err_code {
 enum btrfs_clear_op_type {
 	BTRFS_CLEAR_OP_DISCARD = 0,
 	BTRFS_CLEAR_OP_ZERO,
+	BTRFS_CLEAR_OP_DISCARD_SECURE,
 	BTRFS_NR_CLEAR_OP_TYPES,
 };
 
-- 
2.16.2

