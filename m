Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933687AbeALOVN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 09:21:13 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 688AFAE06
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 14:21:12 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Streamline btrfs_delalloc_reserve_metadata initial operations
Date: Fri, 12 Jan 2018 16:21:05 +0200
Message-Id: <1515766865-13652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The behavior of btrfs_delalloc_reserve_metadata depends on whether
the inode we are allocating for is the freespace inode or not. As it
stands if we are the free node we set 'flush' and 'delalloc_lock'
variable to certain values. Subsequently we check the values of those
vars and act accordingly. Instead, simplify things by having 1 if
which checks whether we are the freespace inode or not and do any
specific operation in either branches of that if. This makes the code
a bit easier to understand, as an added bonus it also shrinks the
compiled size:

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-17 (-17)
Function                                     old     new   delta
btrfs_delalloc_reserve_metadata             1876    1859     -17
Total: Before=85966, After=85949, chg -0.02%

No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8d51e4bb67c1..47295804d91d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6062,19 +6062,19 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	 * If we have a transaction open (can happen if we call truncate_block
 	 * from truncate), then we need FLUSH_LIMIT so we don't deadlock.
 	 */
+
 	if (btrfs_is_free_space_inode(inode)) {
 		flush = BTRFS_RESERVE_NO_FLUSH;
 		delalloc_lock = false;
-	} else if (current->journal_info) {
-		flush = BTRFS_RESERVE_FLUSH_LIMIT;
-	}
+	} else {
+		if (current->journal_info)
+			flush = BTRFS_RESERVE_FLUSH_LIMIT;
 
-	if (flush != BTRFS_RESERVE_NO_FLUSH &&
-	    btrfs_transaction_in_commit(fs_info))
-		schedule_timeout(1);
+		if (btrfs_transaction_in_commit(fs_info))
+			schedule_timeout(1);
 
-	if (delalloc_lock)
 		mutex_lock(&inode->delalloc_mutex);
+	}
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 
-- 
2.7.4

