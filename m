Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:5520 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754014AbeAKHbB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:01 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 22BD648AEA0D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:30:57 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 02/17] btrfs-progs: lowmem check: record returned errors after walk_down_tree_v2()
Date: Thu, 11 Jan 2018 15:34:56 +0800
Message-ID: <20180111073511.25288-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
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
 cmds-check.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ba2048004054..4743a19421ec 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -134,6 +134,7 @@ struct data_backref {
 #define DIR_INDEX_MISMATCH      (1<<19) /* INODE_INDEX found but not match */
 #define DIR_COUNT_AGAIN         (1<<20) /* DIR isize should be recalculated */
 #define BG_ACCOUNTING_ERROR     (1<<21) /* Block group accounting error */
+#define FATAL_ERROR             (1<<22) /* fatal bit for errno */
 
 static inline struct data_backref* to_data_backref(struct extent_backref *back)
 {
@@ -6556,7 +6557,7 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
  *                otherwise means check fs tree(s) items relationship and
  *		  @root MUST be a fs tree root.
  * Returns 0      represents OK.
- * Returns not 0  represents error.
+ * Returns > 0    represents error bits.
  */
 static int check_btrfs_root(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, unsigned int ext_ref,
@@ -6580,7 +6581,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 		 */
 		ret = check_fs_first_inode(root, ext_ref);
 		if (ret < 0)
-			return ret;
+			return FATAL_ERROR;
 	}
 
 
@@ -6607,12 +6608,12 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 	while (1) {
 		ret = walk_down_tree_v2(trans, root, &path, &level, &nrefs,
 					ext_ref, check_all);
-
-		err |= !!ret;
+		if (ret > 0)
+			err |= ret;
 
 		/* if ret is negative, walk shall stop */
 		if (ret < 0) {
-			ret = err;
+			ret = err | FATAL_ERROR;
 			break;
 		}
 
@@ -6636,7 +6637,7 @@ out:
  * @ext_ref:	the EXTENDED_IREF feature
  *
  * Return 0 if no error found.
- * Return <0 for error.
+ * Return >0 for error.
  */
 static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
 {
-- 
2.15.1



