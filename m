Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57220 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbaE3P4g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 11:56:36 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so2169153wgh.15
        for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 08:56:35 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: ioctl, don't re-lock extent range when not necessary
Date: Fri, 30 May 2014 17:56:24 +0100
Message-Id: <1401468984-26821-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In ioctl.c:lock_extent_range(), after locking our target range, the
ordered extent that btrfs_lookup_first_ordered_extent() returns us
may not overlap our target range at all. In this case we would just
unlock our target range, wait for any new ordered extents that overlap
the range to complete, lock again the range and repeat all these steps
until we don't get any ordered extent and the delalloc flag isn't set
in the io tree for our target range.

Therefore just stop if we get an ordered extent that doesn't overlap
our target range and the dealalloc flag isn't set for the range in
the inode's io tree.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 38f2169..603c036 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2700,10 +2700,15 @@ static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
 		lock_extent(&BTRFS_I(inode)->io_tree, off, off + len - 1);
 		ordered = btrfs_lookup_first_ordered_extent(inode,
 							    off + len - 1);
-		if (!ordered &&
+		if ((!ordered ||
+		     ordered->file_offset + ordered->len <= off ||
+		     ordered->file_offset >= off + len) &&
 		    !test_range_bit(&BTRFS_I(inode)->io_tree, off,
-				    off + len - 1, EXTENT_DELALLOC, 0, NULL))
+				    off + len - 1, EXTENT_DELALLOC, 0, NULL)) {
+			if (ordered)
+				btrfs_put_ordered_extent(ordered);
 			break;
+		}
 		unlock_extent(&BTRFS_I(inode)->io_tree, off, off + len - 1);
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
-- 
1.9.1

