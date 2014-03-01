Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41919 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaCAK4F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Mar 2014 05:56:05 -0500
Received: by mail-wi0-f169.google.com with SMTP id bs8so2752987wib.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Mar 2014 02:56:03 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: correctly flush data on defrag when compression is enabled
Date: Sat,  1 Mar 2014 10:55:54 +0000
Message-Id: <1393671354-7140-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the defrag flag BTRFS_DEFRAG_RANGE_START_IO is set and compression
enabled, we weren't flushing completely, as writing compressed extents
is a 2 steps process, one to compress the data and another one to write
the compressed data to disk.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d4c1795..f914b5d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1382,8 +1382,12 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 	}
 
-	if ((range->flags & BTRFS_DEFRAG_RANGE_START_IO))
+	if ((range->flags & BTRFS_DEFRAG_RANGE_START_IO)) {
 		filemap_flush(inode->i_mapping);
+		if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+			     &BTRFS_I(inode)->runtime_flags))
+			filemap_flush(inode->i_mapping);
+	}
 
 	if ((range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)) {
 		/* the filemap_flush will queue IO into the worker threads, but
-- 
1.7.9.5

