Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29228 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603AbaDIHKF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 03:10:05 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v9 15/16] Btrfs: use total_bytes instead of bytes_used for global_rsv
Date: Wed,  9 Apr 2014 15:08:43 +0800
Message-Id: <1397027325-27151-16-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
References: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because of dedupe, data space info cannot reflect how many data has
been written, in order to get global_rsv more proper, use total_bytes
instead.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b8fee86..6f8b012 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4692,14 +4692,14 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 
 	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
 	spin_lock(&sinfo->lock);
-	data_used = sinfo->bytes_used;
+	data_used = sinfo->total_bytes;
 	spin_unlock(&sinfo->lock);
 
 	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 	spin_lock(&sinfo->lock);
 	if (sinfo->flags & BTRFS_BLOCK_GROUP_DATA)
 		data_used = 0;
-	meta_used = sinfo->bytes_used;
+	meta_used = sinfo->total_bytes;
 	spin_unlock(&sinfo->lock);
 
 	num_bytes = (data_used >> fs_info->sb->s_blocksize_bits) *
-- 
1.8.2.1

