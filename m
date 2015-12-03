Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbbLCQgs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:36:48 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B7B4AAD53
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Dec 2015 16:36:47 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: make lock_extent static inline
Date: Thu,  3 Dec 2015 17:34:57 +0100
Message-Id: <cd716d8fea125e5531003e66aaf7ca7323277f83.1449159704.git.dsterba@suse.com>
In-Reply-To: <cover.1449159704.git.dsterba@suse.com>
References: <cover.1449159704.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One call less reduces stack usage, code slightly reduced as well.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 5 -----
 fs/btrfs/extent_io.h | 7 ++++++-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bf9849909d46..044ffa3a520a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1347,11 +1347,6 @@ int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 	return err;
 }
 
-int lock_extent(struct extent_io_tree *tree, u64 start, u64 end)
-{
-	return lock_extent_bits(tree, start, end, NULL);
-}
-
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	int err;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e5726a3f9ce5..7cb9fa5845dc 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -199,9 +199,14 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			       struct extent_io_tree *tree, struct page *page,
 			       gfp_t mask);
 int try_release_extent_buffer(struct page *page);
-int lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		     struct extent_state **cached);
+
+static inline int lock_extent(struct extent_io_tree *tree, u64 start, u64 end)
+{
+	return lock_extent_bits(tree, start, end, NULL);
+}
+
 int try_lock_extent(struct extent_io_tree *tree, u64 start, u64 end);
 int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 			  get_extent_t *get_extent, int mirror_num);
-- 
2.6.2

