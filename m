Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:50641 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdJCPHJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 11:07:09 -0400
Received: by mail-lf0-f67.google.com with SMTP id a132so1956134lfa.7
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Oct 2017 08:07:09 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 4/4] Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
Date: Tue,  3 Oct 2017 18:06:04 +0300
Message-Id: <20171003150604.19596-5-nefelim4ag@gmail.com>
In-Reply-To: <20171003150604.19596-1-nefelim4ag@gmail.com>
References: <20171003150604.19596-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At now btrfs_dedupe_file_range() restricted to 16MiB range for
limit locking time and memory requirement for dedup ioctl()

For too big input rage code silently set range to 16MiB

Let's remove that restriction by do iterating over dedup range.
That's backward compatible and will not change anything for request
less then 16MiB.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 fs/btrfs/ioctl.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 31407c62da63..4b468e5dfa11 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3200,11 +3200,9 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 	struct inode *src = file_inode(src_file);
 	struct inode *dst = file_inode(dst_file);
 	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
+	u64 i, tail_len, chunk_count;
 	ssize_t res;

-	if (olen > BTRFS_MAX_DEDUPE_LEN)
-		olen = BTRFS_MAX_DEDUPE_LEN;
-
 	if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
 		/*
 		 * Btrfs does not support blocksize < page_size. As a
@@ -3214,7 +3212,23 @@ ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 		return -EINVAL;
 	}

-	res = btrfs_extent_same(src, loff, olen, dst, dst_loff);
+	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
+	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
+
+	for (i = 0; i < chunk_count; i++) {
+		res = btrfs_extent_same(src, loff, BTRFS_MAX_DEDUPE_LEN,
+					dst, dst_loff);
+		if (res)
+			return res;
+
+		loff += BTRFS_MAX_DEDUPE_LEN;
+		dst_loff += BTRFS_MAX_DEDUPE_LEN;
+	}
+
+	if (tail_len > 0)
+		res = btrfs_extent_same(src, loff, tail_len,
+					dst, dst_loff);
+
 	if (res)
 		return res;
 	return olen;
--
2.14.2
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
