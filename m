Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39937 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbbLJLQr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 06:16:47 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix transaction handle leak in balance
Date: Thu, 10 Dec 2015 11:16:27 +0000
Message-Id: <1449746187-11806-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If we fail to allocate a new data chunk, we were jumping to the error path
without release the transaction handle we got before. Fix this by always
releasing it before doing the jump.

Fixes: 2c9fe8355258 ("btrfs: Fix lost-data-profile caused by balance bg")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3e55e07..f5e5e20 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3548,12 +3548,11 @@ again:
 
 			ret = btrfs_force_chunk_alloc(trans, chunk_root,
 						      BTRFS_BLOCK_GROUP_DATA);
+			btrfs_end_transaction(trans, chunk_root);
 			if (ret < 0) {
 				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 				goto error;
 			}
-
-			btrfs_end_transaction(trans, chunk_root);
 			chunk_reserved = 1;
 		}
 
-- 
2.1.3

