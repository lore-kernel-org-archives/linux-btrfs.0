Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbbFONlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 09:41:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 457FBAC7C
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 13:41:23 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/7] btrfs: btrfs_issue_discard ensure offset/length are aligned to sector boundaries
Date: Mon, 15 Jun 2015 09:41:15 -0400
Message-Id: <1434375680-4115-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <557ED6DC.6070900@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

It's possible, though unexpected, to pass unaligned offsets and lengths
to btrfs_issue_discard.  We then shift the offset/length values to sector
units.  If an unaligned offset has been passed, it will result in the
entire sector being discarded, possibly losing data.  An unaligned
length is safe but we'll end up returning an inaccurate number of
discarded bytes.

This patch aligns the offset to the 512B boundary, adjusts the length,
and warns, since we shouldn't be discarding on an offset that isn't
aligned with our sector size.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index da1145d..cf9cefd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1888,12 +1888,21 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 			       u64 *discarded_bytes)
 {
 	int ret = 0;
+	u64 aligned_start = ALIGN(start, 1 << 9);
 
-	*discarded_bytes = 0;
-	ret = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_NOFS, 0);
-	if (!ret)
-		*discarded_bytes = len;
+	if (WARN_ON(start != aligned_start)) {
+		len -= aligned_start - start;
+		len = round_down(len, 1 << 9);
+		start = aligned_start;
+	}
 
+	*discarded_bytes = 0;
+	if (len) {
+		ret = blkdev_issue_discard(bdev, start >> 9, len >> 9,
+					   GFP_NOFS, 0);
+		if (!ret)
+			*discarded_bytes = len;
+	}
 	return ret;
 }
 
-- 
2.4.3

