Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48765 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752567AbdKGJXA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 04:23:00 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, josef@toxicpanda.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Reduce scope of delayed_rsv->lock in may_commit_trans
Date: Tue,  7 Nov 2017 11:22:54 +0200
Message-Id: <1510046574-15541-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After commit ('btrfs: change how we decide to commit transactions during
flushing') there is no need to hold the delayed_rsv during the
percpu_counter_compare call since we get the byte's snapshot earlier. So hold
the lock only while reading delayed_rsv

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

This is based on David's misc-4.15 branch 

 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 673ac4e01dd0..11b7d613140b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4952,12 +4952,12 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 		bytes = 0;
 	else
 		bytes -= delayed_rsv->size;
+	spin_unlock(&delayed_rsv->lock);
+
 	if (percpu_counter_compare(&space_info->total_bytes_pinned,
 				   bytes) < 0) {
-		spin_unlock(&delayed_rsv->lock);
 		return -ENOSPC;
 	}
-	spin_unlock(&delayed_rsv->lock);
 
 commit:
 	trans = btrfs_join_transaction(fs_info->extent_root);
-- 
2.7.4

