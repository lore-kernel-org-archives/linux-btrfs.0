Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42843 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753907AbdLHO1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 09:27:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 01E94AD11
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Dec 2017 14:27:46 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Rename bin_search -> btrfs_bin_search
Date: Fri,  8 Dec 2017 16:27:43 +0200
Message-Id: <1512743263-18791-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently there are 2 function doing binary search on btrfs nodes:
bin_search and btrfs_bin_search. The latter being a simple wrapper for
the former. So eliminate the wrapper and just rename bin_search to
btrfs_bin_search. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 1e74cf826532..880f4f693263 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1807,8 +1807,8 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
  * simple bin_search frontend that does the right thing for
  * leaves vs nodes
  */
-static int bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
-		      int level, int *slot)
+int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
+		     int level, int *slot)
 {
 	if (level == 0)
 		return generic_bin_search(eb,
@@ -1824,12 +1824,6 @@ static int bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
 					  slot);
 }
 
-int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
-		     int level, int *slot)
-{
-	return bin_search(eb, key, level, slot);
-}
-
 static void root_add_used(struct btrfs_root *root, u32 size)
 {
 	spin_lock(&root->accounting_lock);
@@ -2614,7 +2608,7 @@ static int key_search(struct extent_buffer *b, const struct btrfs_key *key,
 		      int level, int *prev_cmp, int *slot)
 {
 	if (*prev_cmp != 0) {
-		*prev_cmp = bin_search(b, key, level, slot);
+		*prev_cmp = btrfs_bin_search(b, key, level, slot);
 		return *prev_cmp;
 	}
 
@@ -5175,7 +5169,7 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
 	while (1) {
 		nritems = btrfs_header_nritems(cur);
 		level = btrfs_header_level(cur);
-		sret = bin_search(cur, min_key, level, &slot);
+		sret = btrfs_bin_search(cur, min_key, level, &slot);
 
 		/* at the lowest level, we're done, setup the path and exit */
 		if (level == path->lowest_level) {
-- 
2.7.4

