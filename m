Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61408 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab3EMP1T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:27:19 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH 3/5] Btrfs: optimize the error handle of use_block_rsv()
Date: Mon, 13 May 2013 21:55:10 +0800
Message-Id: <1368453312-7027-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368453312-7027-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 65 ++++++++++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 43afa77..e34e268 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6659,48 +6659,39 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 
 	block_rsv = get_block_rsv(trans, root);
 
-	if (block_rsv->size == 0) {
-		ret = reserve_metadata_bytes(root, block_rsv, blocksize,
-					     BTRFS_RESERVE_NO_FLUSH);
-		/*
-		 * If we couldn't reserve metadata bytes try and use some from
-		 * the global reserve.
-		 */
-		if (ret && block_rsv != global_rsv) {
-			ret = block_rsv_use_bytes(global_rsv, blocksize);
-			if (!ret)
-				return global_rsv;
-			return ERR_PTR(ret);
-		} else if (ret) {
-			return ERR_PTR(ret);
-		}
-		return block_rsv;
-	}
+	if (unlikely(block_rsv->size == 0))
+		goto try_reserve;
 
 	ret = block_rsv_use_bytes(block_rsv, blocksize);
 	if (!ret)
 		return block_rsv;
-	if (ret && !block_rsv->failfast) {
-		if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
-			static DEFINE_RATELIMIT_STATE(_rs,
-					DEFAULT_RATELIMIT_INTERVAL * 10,
-					/*DEFAULT_RATELIMIT_BURST*/ 1);
-			if (__ratelimit(&_rs))
-				WARN(1, KERN_DEBUG
-					"btrfs: block rsv returned %d\n", ret);
-		}
-		ret = reserve_metadata_bytes(root, block_rsv, blocksize,
-					     BTRFS_RESERVE_NO_FLUSH);
-		if (!ret) {
-			return block_rsv;
-		} else if (ret && block_rsv != global_rsv) {
-			ret = block_rsv_use_bytes(global_rsv, blocksize);
-			if (!ret)
-				return global_rsv;
-		}
-	}
 
-	return ERR_PTR(-ENOSPC);
+	if (block_rsv->failfast)
+		return ERR_PTR(ret);
+
+	if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
+		static DEFINE_RATELIMIT_STATE(_rs,
+				DEFAULT_RATELIMIT_INTERVAL * 10,
+				/*DEFAULT_RATELIMIT_BURST*/ 1);
+		if (__ratelimit(&_rs))
+			WARN(1, KERN_DEBUG
+				"btrfs: block rsv returned %d\n", ret);
+	}
+try_reserve:
+	ret = reserve_metadata_bytes(root, block_rsv, blocksize,
+				     BTRFS_RESERVE_NO_FLUSH);
+	if (!ret)
+		return block_rsv;
+	/*
+	 * If we couldn't reserve metadata bytes try and use some from
+	 * the global reserve.
+	 */
+	if (block_rsv->type != BTRFS_BLOCK_RSV_GLOBAL) {
+		ret = block_rsv_use_bytes(global_rsv, blocksize);
+		if (!ret)
+			return global_rsv;
+	}
+	return ERR_PTR(ret);
 }
 
 static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
-- 
1.8.0.1

