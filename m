Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19340 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751451AbbIBJlj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 05:41:39 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t829fQMJ023643
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Sep 2015 17:41:26 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: Fix some spelling typo in chunk-recover.c
Date: Wed, 2 Sep 2015 17:39:56 +0800
Message-ID: <f5ad7a07b09b8c8aa8e38c5ece3fd323ec036e0f.1441186744.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441186744.git.zhaolei@cn.fujitsu.com>
References: <cover.1441186744.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only comment, not big issue.

And remove no-use aggument in block_group_free_all_extent().

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 chunk-recover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 7698ee0..d9d777a 100644
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
@@ -2310,7 +2310,7 @@ static void validate_rebuild_chunks(struct recover_control *rc)
 }
 
 /*
- * Return 0 when succesful, < 0 on error and > 0 if aborted by user
+ * Return 0 when successful, < 0 on error and > 0 if aborted by user
  */
 int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 {
-- 
1.8.5.1

