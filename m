Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58822 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755226AbeDTOYV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:24:21 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4AF1AEC2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 14:24:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/6] btrfs: add wrapper to switch clearing operation
Date: Fri, 20 Apr 2018 16:21:48 +0200
Message-Id: <82f2aa3817650cc83517f448adbacb44e8ef5791.1524233244.git.dsterba@suse.com>
In-Reply-To: <cover.1524233244.git.dsterba@suse.com>
References: <cover.1524233244.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ffdd3aba508c..b317f8ee42a9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2034,6 +2034,18 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int btrfs_issue_clear_op(struct block_device *bdev, u64 start, u64 size,
+		enum btrfs_clear_op_type clear)
+{
+	switch (clear) {
+	case BTRFS_CLEAR_OP_DISCARD:
+		return blkdev_issue_discard(bdev, start >> 9, size >> 9,
+				GFP_NOFS, 0);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 #define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
 static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 			       u64 *discarded_bytes,
@@ -2081,13 +2093,8 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 			bytes_left = end - start;
 			continue;
 		}
-
 		if (size) {
-			if (clear == BTRFS_CLEAR_OP_DISCARD)
-				ret = blkdev_issue_discard(bdev, start >> 9,
-						size >> 9, GFP_NOFS, 0);
-			else
-				ret = -EOPNOTSUPP;
+			ret = btrfs_issue_clear_op(bdev, start, size, clear);
 			if (!ret)
 				*discarded_bytes += size;
 			else if (ret != -EOPNOTSUPP)
@@ -2103,11 +2110,7 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 	}
 
 	if (bytes_left) {
-		if (clear == BTRFS_CLEAR_OP_DISCARD)
-			ret = blkdev_issue_discard(bdev, start >> 9,
-					bytes_left >> 9, GFP_NOFS, 0);
-		else
-			ret = -EOPNOTSUPP;
+		ret = btrfs_issue_clear_op(bdev, start, bytes_left, clear);
 		if (!ret)
 			*discarded_bytes += bytes_left;
 	}
-- 
2.16.2

