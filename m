Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32653 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbcG1BiK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 21:38:10 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: deal with unexpected return value in flush_space
Date: Wed, 27 Jul 2016 18:42:03 -0700
Message-Id: <1469670123-19839-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function start_transaction() can return ERR_PTR(1) when flush is
BTRFS_RESERVE_FLUSH_LIMIT, so the call graph is

start_transaction (return ERR_PTR(1))
  -> btrfs_block_rsv_add (return 1)
     -> reserve_metadata_bytes (return 1)
        -> flush_space (return 1)
           -> do_chunk_alloc  (return 1)

With BTRFS_RESERVE_FLUSH_LIMIT, if flush_space is already on the
flush_state of ALLOC_CHUNK and it successfully allocates a new
chunk, then instead of trying to reserve space again,
reserve_metadata_bytes returns 1 immediately.

Eventually the callers who call start_transaction() usually just
do the IS_ERR() check which ERR_PTR(1) can pass, then it'll get
a panic when dereferencing a pointer which is ERR_PTR(1).

This makes flush_space() translate 'ret = 1' to 'ret = 0'.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
We found this 'NULL pointer dereference' on an old 3.8 kernel but
it's not going to happen on the upstream since there is no caller
of btrfs_start_transaction_lflush().

 fs/btrfs/extent-tree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7a35c9d..a00fb67 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4457,6 +4457,15 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 	}
 }
 
+/*
+ * If force is CHUNK_ALLOC_FORCE:
+ *    - return 1 if it successfully allocates a chunk,
+ *    - return errors including -ENOSPC otherwise.
+ * If force is NOT CHUNK_ALLOC_FORCE:
+ *    - return 0 if it doesn't need to allocate a new chunk,
+ *    - return 1 if it successfully allocates a chunk,
+ *    - return errors including -ENOSPC otherwise.
+ */
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *extent_root, u64 flags, int force)
 {
@@ -4857,7 +4866,7 @@ static int flush_space(struct btrfs_root *root,
 				     btrfs_get_alloc_profile(root, 0),
 				     CHUNK_ALLOC_NO_FORCE);
 		btrfs_end_transaction(trans, root);
-		if (ret == -ENOSPC)
+		if (ret == -ENOSPC || ret == 1)
 			ret = 0;
 		break;
 	case COMMIT_TRANS:
-- 
2.5.5

