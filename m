Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36588 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3IISuF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2013 14:50:05 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so3294138wgh.27
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Sep 2013 11:50:04 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't leak block group on error
Date: Mon,  9 Sep 2013 19:49:43 +0100
Message-Id: <1378752583-31362-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In extent-tree.c:btrfs_write_dirty_block_groups(), if the call to
write_one_cache_group() failed, we would return without putting
the block group first.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent-tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1d7f41f..249cdb1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3318,10 +3318,9 @@ again:
 		last = cache->key.objectid + cache->key.offset;
 
 		err = write_one_cache_group(trans, root, path, cache);
+		btrfs_put_block_group(cache);
 		if (err) /* File system offline */
 			goto out;
-
-		btrfs_put_block_group(cache);
 	}
 
 	while (1) {
-- 
1.7.9.5

