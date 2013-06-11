Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab3FKUcz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 16:32:55 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <josef@redhat.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/4] btrfs: abtract out range locking in clone ioctl()
Date: Tue, 11 Jun 2013 13:31:35 -0700
Message-Id: <1370982698-757-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1370982698-757-1-git-send-email-mfasheh@suse.de>
References: <1370982698-757-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The range locking in btrfs_ioctl_clone is trivially broken out into it's own
function. This reduces the complexity of btrfs_ioctl_clone() by a small bit
and makes that locking code available to future functions in
fs/btrfs/ioctl.c

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2c02310..ef53952 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2456,6 +2456,26 @@ out:
 	return ret;
 }
 
+static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
+{
+	/* do any pending delalloc/csum calc on src, one way or
+	   another, and lock file content */
+	while (1) {
+		struct btrfs_ordered_extent *ordered;
+		lock_extent(&BTRFS_I(inode)->io_tree, off, off + len - 1);
+		ordered = btrfs_lookup_first_ordered_extent(inode,
+							    off + len - 1);
+		if (!ordered &&
+		    !test_range_bit(&BTRFS_I(inode)->io_tree, off,
+				    off + len - 1, EXTENT_DELALLOC, 0, NULL))
+			break;
+		unlock_extent(&BTRFS_I(inode)->io_tree, off, off + len - 1);
+		if (ordered)
+			btrfs_put_ordered_extent(ordered);
+		btrfs_wait_ordered_range(inode, off, len);
+	}
+}
+
 static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				       u64 off, u64 olen, u64 destoff)
 {
@@ -2573,21 +2593,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	truncate_inode_pages_range(&inode->i_data, destoff,
 				   PAGE_CACHE_ALIGN(destoff + len) - 1);
 
-	/* do any pending delalloc/csum calc on src, one way or
-	   another, and lock file content */
-	while (1) {
-		struct btrfs_ordered_extent *ordered;
-		lock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
-		ordered = btrfs_lookup_first_ordered_extent(src, off + len - 1);
-		if (!ordered &&
-		    !test_range_bit(&BTRFS_I(src)->io_tree, off, off + len - 1,
-				    EXTENT_DELALLOC, 0, NULL))
-			break;
-		unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
-		if (ordered)
-			btrfs_put_ordered_extent(ordered);
-		btrfs_wait_ordered_range(src, off, len);
-	}
+	lock_extent_range(src, off, len);
 
 	/* clone data */
 	key.objectid = btrfs_ino(src);
-- 
1.8.1.4

