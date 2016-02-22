Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63508 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbcBVHCM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 02:02:12 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/5] btrfs-progs: volume: Fix a bug causing btrfs-find-root to skip first chunk
Date: Mon, 22 Feb 2016 14:59:53 +0800
Message-Id: <1456124397-21403-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a small bug from 2011, where btrfs_next_bg (formally
btrfs_next_metadata) function will always skip the first chunk.

That's OK for that time, as there is always 3 empty temporary chunks.
But now, we may ended up with only one metadata or system chunk, with
empty chunk auto-remove from kernel or new mkfs.btrfs.

So fix it by checking the initial value so btrfs_next_bg() will return
the first chunk if its *logical parameter is 0.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/volumes.c b/volumes.c
index a94be0e..059c4f4 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1170,14 +1170,23 @@ int btrfs_next_bg(struct btrfs_mapping_tree *map_tree, u64 *logical,
 {
 	struct cache_extent *ce;
 	struct map_lookup *map;
+	u64 cur = *logical;
 
-	ce = search_cache_extent(&map_tree->cache_tree, *logical);
+	ce = search_cache_extent(&map_tree->cache_tree, cur);
 
 	while (ce) {
-		ce = next_cache_extent(ce);
-		if (!ce)
-			return -ENOENT;
+		/*
+		 * only jump to next bg if our cur is not 0
+		 * As the initial logical for btrfs_next_bg() is 0, and
+		 * if we jump to next bg, we skipped a valid bg.
+		 */
+		if (cur) {
+			ce = next_cache_extent(ce);
+			if (!ce)
+				return -ENOENT;
+		}
 
+		cur = ce->start;
 		map = container_of(ce, struct map_lookup, ce);
 		if (map->type & type) {
 			*logical = ce->start;
-- 
2.7.1



