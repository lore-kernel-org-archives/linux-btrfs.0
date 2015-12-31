Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8912 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753657AbbLaPHs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 10:07:48 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id A0E2E41887C9
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 23:05:27 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 05/10] btrfs: reada: Remove level argument in severial functions
Date: Thu, 31 Dec 2015 23:03:39 +0800
Message-ID: <edfc6894faf1768d32e47f65fef8d184045b3429.1451574005.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
References: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

level is not used in severial functions, remove them from arguments,
and remove relative code for get its value.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index ef9457e..66409f3 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -101,7 +101,7 @@ static void reada_start_machine(struct btrfs_fs_info *fs_info);
 static void __reada_start_machine(struct btrfs_fs_info *fs_info);
 
 static int reada_add_block(struct reada_control *rc, u64 logical,
-			   struct btrfs_key *top, int level, u64 generation);
+			   struct btrfs_key *top, u64 generation);
 
 /* recurses */
 /* in case of err, eb might be NULL */
@@ -197,8 +197,7 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 			if (rec->generation == generation &&
 			    btrfs_comp_cpu_keys(&key, &rc->key_end) < 0 &&
 			    btrfs_comp_cpu_keys(&next_key, &rc->key_start) > 0)
-				reada_add_block(rc, bytenr, &next_key,
-						level - 1, n_gen);
+				reada_add_block(rc, bytenr, &next_key, n_gen);
 		}
 	}
 	/*
@@ -315,7 +314,7 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
 
 static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 					      u64 logical,
-					      struct btrfs_key *top, int level)
+					      struct btrfs_key *top)
 {
 	int ret;
 	struct reada_extent *re = NULL;
@@ -562,13 +561,13 @@ static void reada_control_release(struct kref *kref)
 }
 
 static int reada_add_block(struct reada_control *rc, u64 logical,
-			   struct btrfs_key *top, int level, u64 generation)
+			   struct btrfs_key *top, u64 generation)
 {
 	struct btrfs_root *root = rc->root;
 	struct reada_extent *re;
 	struct reada_extctl *rec;
 
-	re = reada_find_extent(root, logical, top, level); /* takes one ref */
+	re = reada_find_extent(root, logical, top); /* takes one ref */
 	if (!re)
 		return -1;
 
@@ -921,7 +920,6 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 	struct reada_control *rc;
 	u64 start;
 	u64 generation;
-	int level;
 	int ret;
 	struct extent_buffer *node;
 	static struct btrfs_key max_key = {
@@ -944,11 +942,10 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 
 	node = btrfs_root_node(root);
 	start = node->start;
-	level = btrfs_header_level(node);
 	generation = btrfs_header_generation(node);
 	free_extent_buffer(node);
 
-	ret = reada_add_block(rc, start, &max_key, level, generation);
+	ret = reada_add_block(rc, start, &max_key, generation);
 	if (ret) {
 		kfree(rc);
 		return ERR_PTR(ret);
-- 
1.8.5.1



