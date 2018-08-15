Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729287AbeHOSTk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 14:19:40 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31F37AD66
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 15:27:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/7] btrfs: Remove unnecessary locking code in qgroup_rescan_leaf
Date: Wed, 15 Aug 2018 18:26:56 +0300
Message-Id: <1534346817-9108-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In qgroup_rescan_leaf a copy is made of the target leaf by calling
btrfs_clone_extent_buffer. The latter allocates a new buffer and
attaches a new set of pages and copies the content of the source
buffer. The new scratch buffer is only used to iterate it's items, it's
not published anywhere and cannot be accessed by a third party. Hence,
it's not necessary to perform any locking on it whatsoever. Furthermore,
remove the extra extent_buffer_get call since the new buffer is always
allocated with a reference count of 1 which is sufficient here.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/qgroup.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4353bb69bb86..4d3efc8f391e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2689,9 +2689,6 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 		mutex_unlock(&fs_info->qgroup_rescan_lock);
 		goto out;
 	}
-	extent_buffer_get(scratch_leaf);
-	btrfs_tree_read_lock(scratch_leaf);
-	btrfs_set_lock_blocking_rw(scratch_leaf, BTRFS_READ_LOCK);
 	slot = path->slots[0];
 	btrfs_release_path(path);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
@@ -2717,10 +2714,8 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 			goto out;
 	}
 out:
-	if (scratch_leaf) {
-		btrfs_tree_read_unlock_blocking(scratch_leaf);
+	if (scratch_leaf)
 		free_extent_buffer(scratch_leaf);
-	}
 
 	if (done && !ret) {
 		ret = 1;
-- 
2.7.4
