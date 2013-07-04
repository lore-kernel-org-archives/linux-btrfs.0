Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36901 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3GDJuH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 05:50:07 -0400
Received: by mail-wi0-f180.google.com with SMTP id c10so1031548wiw.7
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 02:50:05 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 5/5] Btrfs-progs: don't ignore errors in btrfs_add_block_group()
Date: Thu,  4 Jul 2013 10:48:40 +0100
Message-Id: <1372931320-8340-3-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1372931320-8340-1-git-send-email-fdmanana@gmail.com>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
 <1372931320-8340-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function was not checking if the calls to set_extent_bits()
and set_state_private() actually succeeded or not.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 extent-tree.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index b0cfe0a..d260c14 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3355,12 +3355,14 @@ btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
 	BUG_ON(ret);
 
 	bit = block_group_state_bits(type);
-	set_extent_bits(block_group_cache, chunk_offset,
-			chunk_offset + size - 1,
-			bit | EXTENT_LOCKED, GFP_NOFS);
+	ret = set_extent_bits(block_group_cache, chunk_offset,
+			      chunk_offset + size - 1,
+			      bit | EXTENT_LOCKED, GFP_NOFS);
+	BUG_ON(ret);
 
-	set_state_private(block_group_cache, chunk_offset,
-			  (unsigned long)cache);
+	ret = set_state_private(block_group_cache, chunk_offset,
+				(unsigned long)cache);
+	BUG_ON(ret);
 	set_avail_alloc_bits(fs_info, type);
 
 	return cache;
-- 
1.7.9.5

