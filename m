Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49508 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbeC3FtM (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 01:49:12 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/5] btrfs-progs: extent_io: Fix NULL pointer dereference in free_extent_buffer_final()
Date: Fri, 30 Mar 2018 13:48:53 +0800
Message-Id: <20180330054857.6106-2-wqu@suse.com>
In-Reply-To: <20180330054857.6106-1-wqu@suse.com>
References: <20180330054857.6106-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In free_extent_buffer_final() we access eb->tree->cache_size in
BUG_ON().
However eb->tree can be NULL if it's a cloned extent buffer.

Currently the cloned extent buffer is only used in backref.c,
paths_from_inode() function.
Thankfully that function is not used yet (but could be pretty useful to
convert inode number to path, so I'd like to keep such function).

Anyway, check eb->tree before accessing its member.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent_io.c b/extent_io.c
index eda1fb6f5897..986ad5c0577c 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -587,7 +587,7 @@ static void free_extent_buffer_final(struct extent_buffer *eb)
 	struct extent_io_tree *tree = eb->tree;
 
 	BUG_ON(eb->refs);
-	BUG_ON(tree->cache_size < eb->len);
+	BUG_ON(tree && tree->cache_size < eb->len);
 	list_del_init(&eb->lru);
 	if (!(eb->flags & EXTENT_BUFFER_DUMMY)) {
 		remove_cache_extent(&tree->cache, &eb->cache_node);
-- 
2.16.3

