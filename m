Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:43557 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbeEBFPw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 01:15:52 -0400
Received: by mail-lf0-f68.google.com with SMTP id g12-v6so18975891lfb.10
        for <linux-btrfs@vger.kernel.org>; Tue, 01 May 2018 22:15:52 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH V3 2/3] Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
Date: Wed,  2 May 2018 08:15:37 +0300
Message-Id: <20180502051538.26432-3-nefelim4ag@gmail.com>
In-Reply-To: <20180502051538.26432-1-nefelim4ag@gmail.com>
References: <20180502051538.26432-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At now btrfs_dedupe_file_range() restricted to 16MiB range for
limit locking time and memory requirement for dedup ioctl()

For too big input range code silently set range to 16MiB

Let's remove that restriction by do iterating over dedup range.
That's backward compatible and will not change anything for request
less then 16MiB.

Changes:
  v3:
    - Splited from one to 3 patches

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/ioctl.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fb8beedb0359..38ce990e9b4c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2983,11 +2983,14 @@ static int __btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	return ret;
 }
 
+#define BTRFS_MAX_DEDUPE_LEN	SZ_16M
+
 static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 			     struct inode *dst, u64 dst_loff)
 {
 	int ret;
 	bool same_inode = (src == dst);
+	u64 i, tail_len, chunk_count;
 
 	if (olen == 0)
 		return 0;
@@ -2998,13 +3001,28 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		return -EINVAL;
 	}
 
+	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
+	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
+
 	if (same_inode)
 		inode_lock(src);
 	else
 		btrfs_double_inode_lock(src, dst);
 
-	ret = __btrfs_extent_same(src, loff, olen, dst, dst_loff);
+	for (i = 0; i < chunk_count; i++) {
+		ret = __btrfs_extent_same(src, loff, BTRFS_MAX_DEDUPE_LEN,
+					  dst, dst_loff);
+		if (ret)
+			goto out;
+
+		loff += BTRFS_MAX_DEDUPE_LEN;
+		dst_loff += BTRFS_MAX_DEDUPE_LEN;
+	}
+
+	if (tail_len > 0)
+		ret = __btrfs_extent_same(src, loff, tail_len, dst, dst_loff);
 
+out:
 	if (same_inode)
 		inode_unlock(src);
 	else
@@ -3013,8 +3031,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	return ret;
 }
 
-#define BTRFS_MAX_DEDUPE_LEN	SZ_16M
-
 ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 				struct file *dst_file, u64 dst_loff)
 {
@@ -3023,9 +3039,6 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
 	ssize_t res;
 
-	if (olen > BTRFS_MAX_DEDUPE_LEN)
-		olen = BTRFS_MAX_DEDUPE_LEN;
-
 	if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
 		/*
 		 * Btrfs does not support blocksize < page_size. As a
-- 
2.17.0
