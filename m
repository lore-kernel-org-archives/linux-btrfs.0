Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56569 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751687AbbHYCrD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 22:47:03 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <marc@merlins.org>
Subject: [PATCH 2/2] btrfs-progs: find-root: Fix a bug that will cause wrong result
Date: Tue, 25 Aug 2015 10:44:57 +0800
Message-ID: <1440470697-21177-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1440470697-21177-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1440470697-21177-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
btrfs-find-root may not output desire result, as due to
search_extent_cache() may return result which doesn't cover the desired
range, generation cache can be screwed up if higher generation tree root
is found before lower generation tree root.

For example:
=======
./btrfs-find-root  /dev/sda6  -a
Superblock thinks the generation is 8
Superblock thinks the level is 0
adding bytenr: 4194304, gen: 8	<<< Debug output
adding bytenr: 24715264, gen: 7 <<< gen is 7 at read_tree_block time
Well block 4194304(gen: 8 level: 0) seems good, and it matches
superblock
Well block 24715264(gen: 8 level: 0) seems good, and it matches
superblock  <<< But its gen is wrong at result output time
=======

[Fix]
Add a new judgment to make sure the search_extent_cache() is returning
desired result.

Reported-by: Marc Merlin <marc@merlins.org>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 find-root.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/find-root.c b/find-root.c
index 1af37b5..0eca0ab 100644
--- a/find-root.c
+++ b/find-root.c
@@ -46,9 +46,14 @@ static int add_eb_to_result(struct extent_buffer *eb,
 	    generation < filter->generation)
 		return ret;
 
-	/* Get the generation cache or create one */
+	/*
+	 * Get the generation cache or create one
+	 *
+	 * NOTE: search_cache_extent() may return cache doesn't cover
+	 * the range. So need extra judgement to make sure it's a match.
+	 */
 	cache = search_cache_extent(result, generation);
-	if (!cache) {
+	if (!cache || cache->start != generation) {
 		gen_cache = malloc(sizeof(*gen_cache));
 		BUG_ON(!gen_cache);
 		cache = &gen_cache->cache;
-- 
2.5.0

