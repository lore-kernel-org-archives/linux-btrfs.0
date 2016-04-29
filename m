Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbcD2JVO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:21:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 56354AD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:21:13 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 14/16] btrfs: __clear_extent_bit, try preallocation out of locked section with lighter gfp flags
Date: Fri, 29 Apr 2016 11:21:00 +0200
Message-Id: <7b3e5689440c6b43095a5fb1d909b8ad5fa7d4a1.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In __clear_extent_bit we allocate with GFP_ATOMIC with the tree lock
held, this takes away allocator opportunities to satisfy the allocation.
In some cases we leave the locked section and we could repeat the
preallocation with less strict flags. It could lead to unnecessary
allocation, but we won't fail until we really need it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 06ad442f6c03..994b4a757ed1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -733,6 +733,13 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
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

