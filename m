Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47775 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753774AbeBGJTN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 04:19:13 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9C735ACF0
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 09:19:12 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Don't hardcode the csum size in btrfs_ordered_sum_size
Date: Wed,  7 Feb 2018 11:19:10 +0200
Message-Id: <1517995150-28081-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the function uses a hardcoded value for the checksum size of
a sector. This is fine, given that we currently support only a single
algorithm, whose checksum is 4 bytes == sizeof(u32). Despite not
having other algorithms, btrfs' design supports using a different
algorithm whith different space requirements. To future-proof the code
query the size of the currently used algorithm from the in-memory copy
of the super block. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ordered-data.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 56c4c0ee6381..c53e2cfb72d9 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -151,7 +151,9 @@ static inline int btrfs_ordered_sum_size(struct btrfs_fs_info *fs_info,
 					 unsigned long bytes)
 {
 	int num_sectors = (int)DIV_ROUND_UP(bytes, fs_info->sectorsize);
-	return sizeof(struct btrfs_ordered_sum) + num_sectors * sizeof(u32);
+	int csum_size = btrfs_super_csum_size(fs_info->super_copy);
+
+	return sizeof(struct btrfs_ordered_sum) + num_sectors * csum_size;
 }
 
 static inline void
-- 
2.7.4

