Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56569 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751672AbbHYCrB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 22:47:01 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <marc@merlins.org>
Subject: [PATCH 1/2] btrfs-progs: find-root: Output matched root when searching all roots
Date: Tue, 25 Aug 2015 10:44:56 +0800
Message-ID: <1440470697-21177-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Bug]
When given '-a' option, btrfs-find-root will output all possible tree
roots but the exact matched one.

[Reason]
Result printing skipes the exact match one, as it will normally be shown
before the alternative ones.
But when '-a' is given, that's not the case.

[Fix]
Just show the exact match one for search all case.

Reported-by: Marc Merlin <marc@merlins.org>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-find-root.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 1cb3085..01b3603 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -109,6 +109,9 @@ static void print_one_result(struct cache_extent *tree_block,
 	       tree_block->start, generation, level);
 	if (unsure)
 		printf("but we are unsure about the correct generation/level\n");
+	else if (level == filter->match_level &&
+		 generation == filter->match_gen)
+		printf("and it matches superblock\n");
 	else
 		printf("but generation/level doesn't match, want gen: %llu level: %u\n",
 		       filter->match_gen, filter->match_level);
@@ -129,8 +132,10 @@ static void print_find_root_result(struct cache_tree *result,
 				struct btrfs_find_root_gen_cache, cache);
 		level = gen_cache->highest_level;
 		generation = cache->start;
+		/* For exact found one, skip it as it's output before */
 		if (level == filter->match_level &&
-		    generation == filter->match_gen)
+		    generation == filter->match_gen &&
+		    !filter->search_all)
 			continue;
 		for (tree_block = last_cache_extent(&gen_cache->eb_tree);
 		     tree_block; tree_block = prev_cache_extent(tree_block))
-- 
2.5.0

