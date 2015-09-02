Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25821 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754164AbbIBMYQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 08:24:16 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t82CO2Pk030329
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Sep 2015 20:24:02 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 4/4] btrfs-progs: Fix some spelling typo in chunk-recover.c
Date: Wed, 2 Sep 2015 20:22:32 +0800
Message-ID: <a20f03e1e16570796ec49f750f3303f85a02ae79.1441196519.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441196519.git.zhaolei@cn.fujitsu.com>
References: <cover.1441196519.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only comment, not big issue.

And remove no-use aggument in block_group_free_all_extent().

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 chunk-recover.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 562817b..962a72b 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -259,7 +259,7 @@ again:
 		list_del_init(&exist->list);
 		free(exist);
 		/*
-		 * We must do seach again to avoid the following cache.
+		 * We must do search again to avoid the following cache.
 		 * /--old bg 1--//--old bg 2--/
 		 *        /--new bg--/
 		 */
@@ -1092,8 +1092,7 @@ err:
 	return ret;
 }
 
-static int block_group_free_all_extent(struct btrfs_trans_handle *trans,
-				       struct btrfs_root *root,
+static int block_group_free_all_extent(struct btrfs_root *root,
 				       struct block_group_record *bg)
 {
 	struct btrfs_block_group_cache *cache;
@@ -1133,7 +1132,7 @@ static int remove_chunk_extent_item(struct btrfs_trans_handle *trans,
 		if (ret)
 			return ret;
 
-		ret = block_group_free_all_extent(trans, root, chunk->bg_rec);
+		ret = block_group_free_all_extent(root, chunk->bg_rec);
 		if (ret)
 			return ret;
 	}
@@ -2310,7 +2309,7 @@ static void validate_rebuild_chunks(struct recover_control *rc)
 }
 
 /*
- * Return 0 when succesful, < 0 on error and > 0 if aborted by user
+ * Return 0 when successful, < 0 on error and > 0 if aborted by user
  */
 int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 {
-- 
1.8.5.1

