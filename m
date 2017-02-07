Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19598 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751416AbdBGGzs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 01:55:48 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id F1D4D47D8AA3
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Feb 2017 14:55:42 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Better csum error message for data csum mismatch
Date: Tue, 7 Feb 2017 14:55:38 +0800
Message-ID: <20170207065538.6397-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original csum error message only outputs inode number, offset, check
sum and expected check sum.

However no root objectid is outputted, which sometimes makes debugging
quite painful under multi-subvolume case (including relocation).

Also the checksum output is decimal, which seldom makes sense for
users/developers and is hard to read in most time.

This patch will add root objectid, which will be %lld for rootid larger
than LAST_FREE_OBJECTID, and hex csum output for better readability.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h | 18 ++++++++++++++++++
 fs/btrfs/compression.c |  6 ++----
 fs/btrfs/inode.c       |  1 +
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1a8fa46ff87e..d797f1eab5aa 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -326,6 +326,24 @@ static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
 		  &BTRFS_I(inode)->runtime_flags);
 }
 
+static inline void btrfs_print_data_csum_error(struct inode *inode,
+		u64 logical_start, u32 csum, u32 csum_expected)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	/* Output minus objectid, which is more meaningful */
+	if (root->objectid >= BTRFS_LAST_FREE_OBJECTID)
+		btrfs_warn_rl(root->fs_info,
+	"csum failed root %lld ino %lld off %llu csum 0x%08x expected csum 0x%08x",
+			root->objectid, btrfs_ino(inode), logical_start, csum,
+			csum_expected);
+	else
+		btrfs_warn_rl(root->fs_info,
+	"csum failed root %llu ino %llu off %llu csum 0x%08x expected csum 0x%08x",
+			root->objectid, btrfs_ino(inode), logical_start, csum,
+			csum_expected);
+}
+
 bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end);
 
 #endif
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 7f390849343b..06122e218326 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -124,10 +124,8 @@ static int check_compressed_csum(struct inode *inode,
 		kunmap_atomic(kaddr);
 
 		if (csum != *cb_sum) {
-			btrfs_info(BTRFS_I(inode)->root->fs_info,
-			   "csum failed ino %llu extent %llu csum %u wanted %u mirror %d",
-			   btrfs_ino(inode), disk_start, csum, *cb_sum,
-			   cb->mirror_num);
+			btrfs_print_data_csum_error(inode, disk_start, csum,
+						    *cb_sum);
 			ret = -EIO;
 			goto fail;
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e861a063721..873dd7f9184e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3123,6 +3123,7 @@ static int __readpage_endio_check(struct inode *inode,
 	kunmap_atomic(kaddr);
 	return 0;
 zeroit:
+	btrfs_print_data_csum_error(inode, start, csum, csum_expected);
 	btrfs_warn_rl(BTRFS_I(inode)->root->fs_info,
 		"csum failed ino %llu off %llu csum %u expected csum %u",
 			   btrfs_ino(inode), start, csum, csum_expected);
-- 
2.11.0



