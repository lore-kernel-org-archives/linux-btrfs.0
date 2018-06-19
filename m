Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58011 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755718AbeFSGyr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 02:54:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1CD524B41EE5
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 14:54:43 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fix invalid-free in btrfs_extent_same
Date: Tue, 19 Jun 2018 14:54:38 +0800
Message-ID: <20180619065438.20293-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If this condition ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
		   (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM))
is hit, we will go to free the uninitialized cmp.src_pages and
cmp.dst_pages.

Fixes: 67b07bd4bec5 ("Btrfs: reuse cmp workspace in EXTENT_SAME ioctl")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c2837a32d689..43ecbe620dea 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3577,7 +3577,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
 					      dst, dst_loff, &cmp);
 		if (ret)
-			goto out_unlock;
+			goto out_free;
 
 		loff += BTRFS_MAX_DEDUPE_LEN;
 		dst_loff += BTRFS_MAX_DEDUPE_LEN;
@@ -3587,16 +3587,16 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		ret = btrfs_extent_same_range(src, loff, tail_len, dst,
 					      dst_loff, &cmp);
 
+out_free:
+	kvfree(cmp.src_pages);
+	kvfree(cmp.dst_pages);
+
 out_unlock:
 	if (same_inode)
 		inode_unlock(src);
 	else
 		btrfs_double_inode_unlock(src, dst);
 
-out_free:
-	kvfree(cmp.src_pages);
-	kvfree(cmp.dst_pages);
-
 	return ret;
 }
 
-- 
2.17.1



