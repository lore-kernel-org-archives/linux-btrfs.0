Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752563AbdLLVDy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 16:03:54 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A8E37ADBF
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 21:03:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: add separate helper for unlock_extent_cached with GFP_ATOMIC
Date: Tue, 12 Dec 2017 22:01:53 +0100
Message-Id: <0292929e56c245741cb1ac3ba574a8240391d3af.1513112255.git.dsterba@suse.com>
In-Reply-To: <cover.1513112255.git.dsterba@suse.com>
References: <cover.1513112255.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's only one instance where we pass different gfp mask to
unlock_extent_cached. Add a separate helper for that and then we can
drop the gfp parameter from unlock_extent_cached.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 2 +-
 fs/btrfs/extent_io.h | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6cd3da16f114..90ecccbf0211 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2492,7 +2492,7 @@ endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
 
 	if (uptodate && tree->track_uptodate)
 		set_extent_uptodate(tree, start, end, &cached, GFP_ATOMIC);
-	unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
+	unlock_extent_cached_atomic(tree, start, end, &cached);
 }
 
 /*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index db2558b0cad4..978351e8e8dc 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -318,6 +318,13 @@ static inline int unlock_extent_cached(struct extent_io_tree *tree, u64 start,
 				mask, NULL);
 }
 
+static inline int unlock_extent_cached_atomic(struct extent_io_tree *tree,
+		u64 start, u64 end, struct extent_state **cached)
+{
+	return __clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, cached,
+				GFP_ATOMIC, NULL);
+}
+
 static inline int clear_extent_bits(struct extent_io_tree *tree, u64 start,
 		u64 end, unsigned bits)
 {
-- 
2.15.1

