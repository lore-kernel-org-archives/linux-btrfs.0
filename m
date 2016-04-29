Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcD2JVI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:21:08 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id AB0EAAD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:21:06 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 12/16] btrfs: make state preallocation more speculative in __set_extent_bit
Date: Fri, 29 Apr 2016 11:20:54 +0200
Message-Id: <059f791c6bbaba72dc3c1bd6e2657aacc8552849.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Similar to __clear_extent_bit, do not fail if the state preallocation
fails as we might not need it. One less BUG_ON.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d39e2241ceb7..8707bcc615ff 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -873,8 +873,14 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	bits |= EXTENT_FIRST_DELALLOC;
 again:
 	if (!prealloc && gfpflags_allow_blocking(mask)) {
+		/*
+		 * Don't care for allocation failure here because we might end
+		 * up not needing the pre-allocated extent state at all, which
+		 * is the case if we only have in the tree extent states that
+		 * cover our input range and don't cover too any other range.
+		 * If we end up needing a new extent state we allocate it later.
+		 */
 		prealloc = alloc_extent_state(mask);
-		BUG_ON(!prealloc);
 	}
 
 	spin_lock(&tree->lock);
-- 
2.7.1

