Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbbFONlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 09:41:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 38669AAD1
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 13:41:23 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/7] btrfs: make btrfs_issue_discard return bytes discarded
Date: Mon, 15 Jun 2015 09:41:14 -0400
Message-Id: <1434375680-4115-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <557ED6DC.6070900@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

Initially this will just be the length argument passed to it,
but the following patches will adjust that to reflect re-alignment
and skipped blocks.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0ec3acd..da1145d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1884,10 +1884,17 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int btrfs_issue_discard(struct block_device *bdev,
-				u64 start, u64 len)
+static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
+			       u64 *discarded_bytes)
 {
-	return blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_NOFS, 0);
+	int ret = 0;
+
+	*discarded_bytes = 0;
+	ret = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_NOFS, 0);
+	if (!ret)
+		*discarded_bytes = len;
+
+	return ret;
 }
 
 int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
@@ -1908,14 +1915,16 @@ int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 
 
 		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
+			u64 bytes;
 			if (!stripe->dev->can_discard)
 				continue;
 
 			ret = btrfs_issue_discard(stripe->dev->bdev,
 						  stripe->physical,
-						  stripe->length);
+						  stripe->length,
+						  &bytes);
 			if (!ret)
-				discarded_bytes += stripe->length;
+				discarded_bytes += bytes;
 			else if (ret != -EOPNOTSUPP)
 				break; /* Logic errors or -ENOMEM, or -EIO but I don't know how that could happen JDM */
 
-- 
2.4.3

