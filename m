Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42630 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752196AbeEOHg1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:36:27 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9C5C6ADFF
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 07:36:26 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: inode: Don't compress if NODATASUM or NODATACOW set
Date: Tue, 15 May 2018 15:36:21 +0800
Message-Id: <20180515073622.18732-2-wqu@suse.com>
In-Reply-To: <20180515073622.18732-1-wqu@suse.com>
References: <20180515073622.18732-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As btrfs(5) specified:

	Note
	If nodatacow or nodatasum are enabled, compression is disabled.

If NODATASUM or NODATACOW set, we should not compress the extent.

Normally NODATACOW is detected properly in run_delalloc_range() so
compression won't happen for NODATACOW.

However for NODATASUM we don't have any check, and it can cause
compressed extent without csum pretty easily, just by:
------
mkfs.btrfs -f $dev
mount $dev $mnt -o nodatasum
touch $mnt/foobar
mount -o remount,datasum,compress $mnt
xfs_io -f -c "pwrite 0 128K" $mnt/foobar
------

And in fact, we have bug report about corrupted compressed extent
without proper data checksum so even RAID1 can't recover the corruption.
(https://bugzilla.kernel.org/show_bug.cgi?id=199707)

Running compression without proper checksum could cause more damage when
corruption happens, so there is no need to allow compression for
NODATACSUM.

Reported-by: James Harvey <jamespharvey20@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d241285a0d2a..dbef3f404559 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -396,6 +396,14 @@ static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 
+	/*
+	 * Btrfs doesn't support compression without csum or CoW.
+	 * This should have the highest priority.
+	 */
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
+	    BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
+		return 0;
+
 	/* force compress */
 	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
 		return 1;
-- 
2.17.0

