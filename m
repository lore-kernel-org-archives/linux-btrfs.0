Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:51768 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaGGKfp (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 7 Jul 2014 06:35:45 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: set error return value in btrfs_get_blocks_direct
Date: Mon,  7 Jul 2014 12:35:21 +0100
Message-Id: <1404732921-15003-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were returning with 0 (success) because we weren't extracting the
error code from em (PTR_ERR(em)). Fix it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6b65fab..8a946c0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6998,8 +6998,10 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 						       block_start, len,
 						       orig_block_len,
 						       ram_bytes, type);
-				if (IS_ERR(em))
+				if (IS_ERR(em)) {
+					ret = PTR_ERR(em);
 					goto unlock_err;
+				}
 			}
 
 			ret = btrfs_add_ordered_extent_dio(inode, start,
-- 
1.9.1

