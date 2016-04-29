Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JUy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:54 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 423A3AD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/16] btrfs: sink gfp parameter to set_record_extent_bits
Date: Fri, 29 Apr 2016 11:20:40 +0200
Message-Id: <2c53b912ae317e560bce1fc446e76915a5b30587.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Single caller passes GFP_NOFS.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/qgroup.c    | 3 +--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 164bda63c5ac..0c9b11924f74 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1284,8 +1284,7 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 /* wrappers around set/clear extent bit */
 int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-			   unsigned bits, gfp_t mask,
-			   struct extent_changeset *changeset)
+			   unsigned bits, struct extent_changeset *changeset)
 {
 	/*
 	 * We don't support EXTENT_LOCKED yet, as current changeset will
@@ -1295,7 +1294,7 @@ int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 	 */
 	BUG_ON(bits & EXTENT_LOCKED);
 
-	return __set_extent_bit(tree, start, end, bits, 0, NULL, NULL, mask,
+	return __set_extent_bit(tree, start, end, bits, 0, NULL, NULL, GFP_NOFS,
 				changeset);
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 566cf86d7e63..94b376446042 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -252,8 +252,7 @@ static inline int clear_extent_bits(struct extent_io_tree *tree, u64 start,
 }
 
 int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-			   unsigned bits, gfp_t mask,
-			   struct extent_changeset *changeset);
+			   unsigned bits, struct extent_changeset *changeset);
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   unsigned bits, u64 *failed_start,
 		   struct extent_state **cached_state, gfp_t mask);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 129392a78986..34af959b4e0f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2542,8 +2542,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode, u64 start, u64 len)
 	changeset.bytes_changed = 0;
 	changeset.range_changed = ulist_alloc(GFP_NOFS);
 	ret = set_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
-			start + len -1, EXTENT_QGROUP_RESERVED, GFP_NOFS,
-			&changeset);
+			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
 	trace_btrfs_qgroup_reserve_data(inode, start, len,
 					changeset.bytes_changed,
 					QGROUP_RESERVE);
-- 
2.7.1

