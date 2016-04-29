Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbcD2JUv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:51 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F201EAD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:49 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/16] btrfs: sink gfp parameter to set_extent_new
Date: Fri, 29 Apr 2016 11:20:37 +0200
Message-Id: <3744dbeb7033825e53b919ae0887e08e924841a9.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Single caller passes GFP_NOFS.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/extent_io.h   | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 61b3dd25ba4c..0ddc996a40e1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7923,7 +7923,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 					buf->start + buf->len - 1, GFP_NOFS);
 		else
 			set_extent_new(&root->dirty_log_pages, buf->start,
-					buf->start + buf->len - 1, GFP_NOFS);
+					buf->start + buf->len - 1);
 	} else {
 		buf->log_index = -1;
 		set_extent_dirty(&trans->transaction->dirty_pages, buf->start,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a1cf4b1dd290..566cf86d7e63 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -307,9 +307,10 @@ static inline int set_extent_defrag(struct extent_io_tree *tree, u64 start,
 }
 
 static inline int set_extent_new(struct extent_io_tree *tree, u64 start,
-		u64 end, gfp_t mask)
+		u64 end)
 {
-	return set_extent_bit(tree, start, end, EXTENT_NEW, NULL, NULL, mask);
+	return set_extent_bit(tree, start, end, EXTENT_NEW, NULL, NULL,
+			GFP_NOFS);
 }
 
 static inline int set_extent_uptodate(struct extent_io_tree *tree, u64 start,
-- 
2.7.1

