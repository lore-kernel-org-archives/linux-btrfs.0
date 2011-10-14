From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't check bytes_pinned to determine if we should commit the transaction
Date: Fri, 14 Oct 2011 13:38:15 -0400
Message-ID: <1318613895-15296-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Before the only reason to commit the transaction to recover space in
reserve_metadata_bytes() was if there were enough pinned_bytes to satisfy our
reservation.  But now we have the delayed inode stuff which will hold it's
reservations until we commit the transaction.  So say we max out our reservation
by creating a bunch of files but don't have any pinned bytes we will ENOSPC out
early even though we could commit the transaction and get that space back.  So
now just unconditionally commit the transaction since currently there is no way
to know how much metadata space is being reserved by delayed inode stuff.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fc0de68..79365a4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3568,17 +3568,6 @@ again:
 		goto again;
 	}
 
-	/*
-	 * Not enough space to be reclaimed, don't bother committing the
-	 * transaction.
-	 */
-	spin_lock(&space_info->lock);
-	if (space_info->bytes_pinned < orig_bytes)
-		ret = -ENOSPC;
-	spin_unlock(&space_info->lock);
-	if (ret)
-		goto out;
-
 	ret = -EAGAIN;
 	if (trans)
 		goto out;
-- 
1.7.5.2

