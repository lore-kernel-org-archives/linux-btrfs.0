Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbaHTPe0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 11:34:26 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: remove stale define after removing ordered operations
Date: Wed, 20 Aug 2014 17:34:22 +0200
Message-Id: <1408548862-14542-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <53F4BA21.50705@fb.com>
References: <53F4BA21.50705@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Last user removed in commit "btrfs: disable strict file flushes for
renames and truncates" (8d875f95da43c6a8f18f77869f2ef26e9594fecc).

Signed-off-by: David Sterba <dsterba@suse.cz>
---

 fs/btrfs/ctree.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e29b614fe93..69cd3262193e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -62,13 +62,6 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_COMPAT_EXTENT_TREE_V0
 
-/*
- * files bigger than this get some pre-flushing when they are added
- * to the ordered operations list.  That way we limit the total
- * work done by the commit
- */
-#define BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT (8 * 1024 * 1024)
-
 /* holds pointers to all of the tree roots */
 #define BTRFS_ROOT_TREE_OBJECTID 1ULL
 
-- 
1.9.0

