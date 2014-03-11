Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59914 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaCKN4c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 09:56:32 -0400
Received: by mail-wg0-f41.google.com with SMTP id n12so10178099wgh.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 06:56:31 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/2] Btrfs: cache extent states in defrag code path
Date: Tue, 11 Mar 2014 13:56:15 +0000
Message-Id: <1394546175-7370-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1394546175-7370-1-git-send-email-fdmanana@gmail.com>
References: <1394546175-7370-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When locking file ranges in the inode's io_tree, cache the first
extent state that belongs to the target range, so that when unlocking
the range we don't need to search in the io_tree again, reducing cpu
time and making and therefore holding the io_tree's lock for a shorter
period.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5239470..6de00ad 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -994,10 +994,13 @@ static struct extent_map *defrag_lookup_extent(struct inode *inode, u64 start)
 	read_unlock(&em_tree->lock);
 
 	if (!em) {
+		struct extent_state *cached = NULL;
+		u64 end = start + len - 1;
+
 		/* get the big lock and read metadata off disk */
-		lock_extent(io_tree, start, start + len - 1);
+		lock_extent_bits(io_tree, start, end, 0, &cached);
 		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
-		unlock_extent(io_tree, start, start + len - 1);
+		unlock_extent_cached(io_tree, start, end, &cached, GFP_NOFS);
 
 		if (IS_ERR(em))
 			return NULL;
@@ -1136,10 +1139,12 @@ again:
 		page_start = page_offset(page);
 		page_end = page_start + PAGE_CACHE_SIZE - 1;
 		while (1) {
-			lock_extent(tree, page_start, page_end);
+			lock_extent_bits(tree, page_start, page_end,
+					 0, &cached_state);
 			ordered = btrfs_lookup_ordered_extent(inode,
 							      page_start);
-			unlock_extent(tree, page_start, page_end);
+			unlock_extent_cached(tree, page_start, page_end,
+					     &cached_state, GFP_NOFS);
 			if (!ordered)
 				break;
 
-- 
1.7.9.5

