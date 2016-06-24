Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbcFXWPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2EB76ADD6
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:27 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/31] btrfs: btrfs_relocate_chunk pass extent_root to btrfs_end_transaction
Date: Fri, 24 Jun 2016 18:15:05 -0400
Message-Id: <1466806524-27508-13-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

In btrfs_relocate_chunk, we get a transaction handle via
btrfs_start_trans_remove_block_group, which starts the transaction
using the extent root.  When we call btrfs_end_transaction, we're calling
it using the chunk root.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49c9851..e0332c9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2902,7 +2902,7 @@ static int btrfs_relocate_chunk(struct btrfs_root *root, u64 chunk_offset)
 	 * chunk tree entries
 	 */
 	ret = btrfs_remove_chunk(trans, root, chunk_offset);
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans, extent_root);
 	return ret;
 }
 
-- 
2.7.1

