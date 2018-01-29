Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34877 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751836AbeA2NxE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 08:53:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E4F5AAEF
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 13:53:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3] btrfs: Ignore errors from btrfs_qgroup_trace_extent_post
Date: Mon, 29 Jan 2018 15:53:01 +0200
Message-Id: <1517233981-31889-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1517211848-13324-1-git-send-email-nborisov@suse.com>
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running generic/019 with qgroups on the scratch device enabled is
almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
supposed to trigger only on -ENOMEM, in reality, however, it's possible
to get -EIO from btrfs_qgroup_trace_extent_post. This function just
finds the roots of the extent being tracked and sets the qrecord->old_roots
list. If this operation fails nothing critical happens except the
quota accounting can be considered wrong. In such case just set the
INCONSISTENT flag for the quota and print a warning, rather than
killing off the system. Additionally, it's possible to trigger a BUG_ON
in btrfs_truncate_inode_items as well.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
V3: 
 * Incorporate feedback from Qu and make btrfs_qgroup_trace_extent_post always
 return 0 since higher layers don't really handle errors properly.

V2: 
 * Always print a warning if btrfs_qgroup_trace_extent_post fails 
  * Set quota inconsistent flag if btrfs_qgroup_trace_extent_post fails
 fs/btrfs/delayed-ref.c | 3 ++-
 fs/btrfs/qgroup.c      | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index a1a40cf382e3..7ab5e0128f0c 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -821,7 +821,8 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	spin_unlock(&delayed_refs->lock);
 
 	if (qrecord_inserted)
-		return btrfs_qgroup_trace_extent_post(fs_info, record);
+		btrfs_qgroup_trace_extent_post(fs_info, record);
+
 	return 0;
 
 free_head_ref:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9e61dd624f7b..ebde770ba498 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1442,8 +1442,11 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, false);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		btrfs_warn(fs_info, "Error accounting new delayed refs extent (err code: %d). Quota inconsistent", ret);
+		return 0;
+	}
 
 	/*
 	 * Here we don't need to get the lock of
-- 
2.7.4

