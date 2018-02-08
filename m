Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:51902 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751130AbeBHDXB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:01 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id D1E4348AE763
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:22:57 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 02/18] btrfs-progs: lowmem check: record returned errors after walk_down_tree_v2()
Date: Thu, 8 Feb 2018 11:27:21 +0800
Message-ID: <20180208032737.31561-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In lowmem mode with '--repair', check_chunks_and_extents_v2()
will fix accounting in block groups and clear the error
bit BG_ACCOUNTING_ERROR.
However, return value of check_btrfs_root() doesn't contain error bits.

If extent tree is on error, lowmem repair always prints error and
returns nonzero value even the filesystem is fine after repair.

Introduce FATAL_ERROR for lowmem mode to represents negative return
values since negative and positive can't not be mixed in bits operations.

Then let check_btrfs_root() return error bits.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 10 +++++-----
 check/mode-lowmem.h |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index d168a3ddd5e5..18ec6db098e7 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4215,7 +4215,7 @@ out:
  *                otherwise means check fs tree(s) items relationship and
  *		  @root MUST be a fs tree root.
  * Returns 0      represents OK.
- * Returns not 0  represents error.
+ * Returns >0     represents error bits.
  */
 static int check_btrfs_root(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, unsigned int ext_ref,
@@ -4238,7 +4238,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 		 */
 		ret = check_fs_first_inode(root, ext_ref);
 		if (ret < 0)
-			return ret;
+			return FATAL_ERROR;
 	}
 
 
@@ -4266,11 +4266,11 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 		ret = walk_down_tree(trans, root, &path, &level, &nrefs,
 				     ext_ref, check_all);
 
-		err |= !!ret;
-
+		if (ret > 0)
+			err |= ret;
 		/* if ret is negative, walk shall stop */
 		if (ret < 0) {
-			ret = err;
+			ret = err | FATAL_ERROR;
 			break;
 		}
 
diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
index 73d5799951b7..e7ba62e2413e 100644
--- a/check/mode-lowmem.h
+++ b/check/mode-lowmem.h
@@ -43,6 +43,7 @@
 #define DIR_INDEX_MISMATCH      (1<<19) /* INODE_INDEX found but not match */
 #define DIR_COUNT_AGAIN         (1<<20) /* DIR isize should be recalculated */
 #define BG_ACCOUNTING_ERROR     (1<<21) /* Block group accounting error */
+#define FATAL_ERROR             (1<<22) /* Fatal bit for errno */
 
 /*
  * Error bit for low memory mode check.
-- 
2.16.1



