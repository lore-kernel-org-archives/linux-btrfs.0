Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46657 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754101AbeENHCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 03:02:13 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 57033AE35
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 07:02:12 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set
Date: Mon, 14 May 2018 15:02:10 +0800
Message-Id: <20180514070210.27047-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As btrfs(5) specified:

	Note
	If nodatacow or nodatasum are enabled, compression is disabled.

If NODATASUM or NODATACOW set, we should not compress the extent.

And in fact, we have bug report about corrupted compressed extent
leading to memory corruption in mail list.
Although it's mostly buggy lzo implementation causing the problem, btrfs
still needs to be fixed to meet the specification.

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

