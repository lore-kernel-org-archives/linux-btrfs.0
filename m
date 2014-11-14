Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbaKNOFJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 09:05:09 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] btrfs: fix wrong accounting of raid1 data profile in statfs
Date: Fri, 14 Nov 2014 15:05:06 +0100
Message-Id: <1415973906-19990-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The sizes that are obtained from space infos are in raw units and have
to be adjusted according to the raid factor. This was missing for
f_bavail and df reported doubled size for raid1.

Reported-by: Martin Steigerwald <Martin@lichtvoll.de>
Fixes: ba7b6e62f420 ("btrfs: adjust statfs calculations according to raid profiles")
CC: stable@vger.kernel.org
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 54bd91ece35b..cde9c03e3913 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1824,7 +1824,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bfree -= block_rsv->size >> bits;
 	spin_unlock(&block_rsv->lock);
 
-	buf->f_bavail = total_free_data;
+	buf->f_bavail = div_u64(total_free_data, factor);
 	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
 	if (ret) {
 		mutex_unlock(&fs_info->chunk_mutex);
-- 
1.8.4.5

