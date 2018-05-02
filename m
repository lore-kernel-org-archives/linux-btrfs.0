Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:39731 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbeEBFPv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 01:15:51 -0400
Received: by mail-lf0-f65.google.com with SMTP id j193-v6so18981123lfg.6
        for <linux-btrfs@vger.kernel.org>; Tue, 01 May 2018 22:15:51 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH V3 1/3] Btrfs: split btrfs_extent_same() for simplification
Date: Wed,  2 May 2018 08:15:36 +0300
Message-Id: <20180502051538.26432-2-nefelim4ag@gmail.com>
In-Reply-To: <20180502051538.26432-1-nefelim4ag@gmail.com>
References: <20180502051538.26432-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Split btrfs_extent_same() for simplification and preparation
for call several times over target files

Move most logic to __btrfs_extent_same()
And leave in btrfs_extent_same() things which must happens only once

Changes:
  v3:
    - Splited from one to 3 patches

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/ioctl.c | 64 ++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f0e62e4f8fe7..fb8beedb0359 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2882,8 +2882,8 @@ static int extent_same_check_offsets(struct inode *inode, u64 off, u64 *plen,
 	return 0;
 }
 
-static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
-			     struct inode *dst, u64 dst_loff)
+static int __btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
+			       struct inode *dst, u64 dst_loff)
 {
 	int ret;
 	u64 len = olen;
@@ -2892,21 +2892,13 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	u64 same_lock_start = 0;
 	u64 same_lock_len = 0;
 
-	if (len == 0)
-		return 0;
-
-	if (same_inode)
-		inode_lock(src);
-	else
-		btrfs_double_inode_lock(src, dst);
-
 	ret = extent_same_check_offsets(src, loff, &len, olen);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	if (same_inode) {
 		/*
@@ -2923,32 +2915,21 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		 * allow an unaligned length so long as it ends at
 		 * i_size.
 		 */
-		if (len != olen) {
-			ret = -EINVAL;
-			goto out_unlock;
-		}
+		if (len != olen)
+			return -EINVAL;
 
 		/* Check for overlapping ranges */
-		if (dst_loff + len > loff && dst_loff < loff + len) {
-			ret = -EINVAL;
-			goto out_unlock;
-		}
+		if (dst_loff + len > loff && dst_loff < loff + len)
+			return -EINVAL;
 
 		same_lock_start = min_t(u64, loff, dst_loff);
 		same_lock_len = max_t(u64, loff, dst_loff) + len - same_lock_start;
 	}
 
-	/* don't make the dst file partly checksummed */
-	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
 again:
 	ret = btrfs_cmp_data_prepare(src, loff, dst, dst_loff, olen, &cmp);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	if (same_inode)
 		ret = lock_extent_range(src, same_lock_start, same_lock_len,
@@ -2998,7 +2979,32 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		btrfs_double_extent_unlock(src, loff, dst, dst_loff, len);
 
 	btrfs_cmp_data_free(&cmp);
-out_unlock:
+
+	return ret;
+}
+
+static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
+			     struct inode *dst, u64 dst_loff)
+{
+	int ret;
+	bool same_inode = (src == dst);
+
+	if (olen == 0)
+		return 0;
+
+	/* don't make the dst file partly checksummed */
+	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
+	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
+		return -EINVAL;
+	}
+
+	if (same_inode)
+		inode_lock(src);
+	else
+		btrfs_double_inode_lock(src, dst);
+
+	ret = __btrfs_extent_same(src, loff, olen, dst, dst_loff);
+
 	if (same_inode)
 		inode_unlock(src);
 	else
-- 
2.17.0
