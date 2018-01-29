Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54877 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbeA2KYM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 05:24:12 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5D7BBACAD
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 10:24:09 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Gracefully handle errors in btrfs_qgroup_trace_extent_post
Date: Mon, 29 Jan 2018 09:44:08 +0200
Message-Id: <1517211848-13324-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running generic/019 with qgroups on the scratch device enabled is
almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
supposed to trigger only on -ENOMEM, in reality, however, it's possible
to get -EIO from btrfs_qgroup_trace_extent_post. This function just
finds the roots of the extent being tracked and sets the qrecord->old_roots
list. If this operation fails nothing critical happens except the
quota accounting can be considered wrong. In such case just set the
INCONSISTENT flag for the quota and print a warning.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V2: 
 * Always print a warning if btrfs_qgroup_trace_extent_post fails 
 * Set quota inconsistent flag if btrfs_qgroup_trace_extent_post fails

 fs/btrfs/delayed-ref.c | 7 +++++--
 fs/btrfs/qgroup.c      | 6 ++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index a1a40cf382e3..5b2789a28a13 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -820,8 +820,11 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			     num_bytes, parent, ref_root, level, action);
 	spin_unlock(&delayed_refs->lock);
 
-	if (qrecord_inserted)
-		return btrfs_qgroup_trace_extent_post(fs_info, record);
+	if (qrecord_inserted) {
+		int ret = btrfs_qgroup_trace_extent_post(fs_info, record);
+		if (ret < 0)
+			btrfs_warn(fs_info, "Error accounting new delayed refs extent (err code: %d). Quota inconsistent", ret);
+	}
 	return 0;
 
 free_head_ref:
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b2ab5f795816..33f9dba44e92 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1440,8 +1440,10 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, false);
-	if (ret < 0)
+	if (ret < 0) {
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		return ret;
+	}
 
 	/*
 	 * Here we don't need to get the lock of
@@ -2933,7 +2935,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
 	if (free && reserved)
 		return qgroup_free_reserved_data(inode, reserved, start, len);
 	extent_changeset_init(&changeset);
-	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
+	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
 			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
 		goto out;
-- 
2.7.4

