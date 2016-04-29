Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbcD2JVL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:21:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F24E6AD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:21:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 13/16] btrfs: __set_extent_bit, try preallocation out of locked section with lighter gfp flags
Date: Fri, 29 Apr 2016 11:20:57 +0200
Message-Id: <06663d10e04cd3016ec41987c2e7275ca21ce80c.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In __set_extent_bit we allocate with GFP_ATOMIC with the tree lock
held, this takes away allocator opportunities to satisfy the allocation.
In some cases we leave the locked section and we could repeat the
preallocation with less strict flags. It could lead to unnecessary
allocation, but we won't fail until we really need it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8707bcc615ff..06ad442f6c03 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1049,6 +1049,13 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	spin_unlock(&tree->lock);
 	if (gfpflags_allow_blocking(mask))
 		cond_resched();
+	/*
+	 * If we used the preallocated state, try again here out of the
+	 * locked section so we can avoid GFP_ATOMIC. No error checking
+	 * as we might not need it in the end.
+	 */
+	if (!prealloc)
+		prealloc = alloc_extent_state(mask);
 	goto again;
 
 out:
-- 
2.7.1

