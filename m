Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbbFHWF1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jun 2015 18:05:27 -0400
Date: Mon, 8 Jun 2015 15:05:25 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH] btrfs: Handle unaligned length in extent_same
Message-ID: <20150608220525.GL18148@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The extent-same code rejects requests with an unaligned length. This
poses a problem when we want to dedupe the tail extent of files as we
skip cloning the portion between i_size and the extent boundary.

If we don't clone the entire extent, it won't be deleted. So the
combination of these behaviors winds up giving us worst-case dedupe on
many files.

We can fix this by allowing a length that extents to i_size and
internally aligining those to the end of the block. This is what
btrfs_ioctl_clone() so we can just copy that check over.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c22c65..2d24ff4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2879,12 +2879,19 @@ static int btrfs_cmp_data(struct inode *src, u64 loff, struct inode *dst,
 	return ret;
 }
 
-static int extent_same_check_offsets(struct inode *inode, u64 off, u64 len)
+static int extent_same_check_offsets(struct inode *inode, u64 off, u64 *plen,
+				     u64 olen)
 {
+	u64 len = *plen;
 	u64 bs = BTRFS_I(inode)->root->fs_info->sb->s_blocksize;
 
-	if (off + len > inode->i_size || off + len < off)
+	if (off + olen > inode->i_size || off + olen < off)
 		return -EINVAL;
+
+	/* if we extend to eof, continue to block boundary */
+	if (off + len == inode->i_size)
+		*plen = len = ALIGN(inode->i_size, bs) - off;
+
 	/* Check that we are block aligned - btrfs_clone() requires this */
 	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs))
 		return -EINVAL;
@@ -2892,10 +2899,11 @@ static int extent_same_check_offsets(struct inode *inode, u64 off, u64 len)
 	return 0;
 }
 
-static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
+static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 			     struct inode *dst, u64 dst_loff)
 {
 	int ret;
+	u64 len = olen;
 
 	/*
 	 * btrfs_clone() can't handle extents in the same file
@@ -2910,11 +2918,11 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
 
 	btrfs_double_lock(src, loff, dst, dst_loff, len);
 
-	ret = extent_same_check_offsets(src, loff, len);
+	ret = extent_same_check_offsets(src, loff, &len, olen);
 	if (ret)
 		goto out_unlock;
 
-	ret = extent_same_check_offsets(dst, dst_loff, len);
+	ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
 	if (ret)
 		goto out_unlock;
 
@@ -2927,7 +2935,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
 
 	ret = btrfs_cmp_data(src, loff, dst, dst_loff, len);
 	if (ret == 0)
-		ret = btrfs_clone(src, dst, loff, len, len, dst_loff);
+		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff);
 
 out_unlock:
 	btrfs_double_unlock(src, loff, dst, dst_loff, len);
-- 
2.1.2

