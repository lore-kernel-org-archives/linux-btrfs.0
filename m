Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40279 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753168AbeAZPXi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 10:23:38 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 02994ACC0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 15:18:02 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: wqu@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [RFC PATCH] btrfs: Gracefully handle errors in btrfs_qgroup_trace_extent_post
Date: Fri, 26 Jan 2018 16:13:41 +0200
Message-Id: <1516976021-11935-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running generic/019 with qgroups on the scratch device enabled is
almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
supposed to trigger only on -ENOMEM, in reality, however, it's possible
to get -EIO from btrfs_qgroup_trace_extent_post. This function just
finds the roots of the extent being tracked and sets the qrecord->old_roots
list. If this operation fails nothing critical happens except the
quota accounting can be considered wrong. In such case just set the
INCONSISTENT flag for the quota and be done with it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Qu, 

This fixes the crash for me, however I'm not entirely sure it's really the 
best fix since it's leaking the usage of INCONSISTENT out of qgroup.c. Ideally
I'd like to avoid this. Since you have more experience with qgroups and also you
introduced the extent tracking code in add_delayed_tree_ref how does 
look to you? 


 fs/btrfs/delayed-ref.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index a1a40cf382e3..1e9aa18cc0d8 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -820,8 +820,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			     num_bytes, parent, ref_root, level, action);
 	spin_unlock(&delayed_refs->lock);
 
-	if (qrecord_inserted)
-		return btrfs_qgroup_trace_extent_post(fs_info, record);
+	if (qrecord_inserted) {
+		int ret = btrfs_qgroup_trace_extent_post(fs_info, record);
+		if (ret != -ENOMEM)
+			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		else
+			return -ENOMEM;
+	}
 	return 0;
 
 free_head_ref:
-- 
2.7.4

