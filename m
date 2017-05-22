Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758369AbdEVKQS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 06:16:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 724FFAC02
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 10:16:17 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: remove __BTRFS_LEAF_DATA_SIZE
Date: Mon, 22 May 2017 13:16:11 +0300
Message-Id: <1495448171-20606-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1495448171-20606-1-git-send-email-nborisov@suse.com>
References: <1495448171-20606-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__BTRFS_LAF_DATA_SIZE is used only by BTRFS_LEAF_DATA_SIZE. Make the latter
subsume the former.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 292c94c45df0..75128bd23140 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1277,19 +1277,16 @@ struct btrfs_root {
 	/* For qgroup metadata space reserve */
 	atomic64_t qgroup_meta_rsv;
 };
+
 static inline u32 btrfs_inode_sectorsize(const struct inode *inode)
 {
 	return btrfs_sb(inode->i_sb)->sectorsize;
 }
 
-static inline u32 __BTRFS_LEAF_DATA_SIZE(u32 blocksize)
-{
-	return blocksize - sizeof(struct btrfs_header);
-}
-
 static inline u32 BTRFS_LEAF_DATA_SIZE(const struct btrfs_fs_info *info)
 {
-	return __BTRFS_LEAF_DATA_SIZE(info->nodesize);
+
+	return info->nodesize - sizeof(struct btrfs_header);
 }
 
 static inline unsigned long BTRFS_LEAF_DATA_OFFSET(void)
-- 
2.7.4

