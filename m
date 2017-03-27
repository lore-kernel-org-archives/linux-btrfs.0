Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35119 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751288AbdC0RaL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:30:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 859B3AC44
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 17:30:09 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH v5] qgroup: Retry after commit on getting EDQUOT
Date: Mon, 27 Mar 2017 12:29:57 -0500
Message-Id: <20170327172957.2518-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We are facing the same problem with EDQUOT which was experienced with
ENOSPC. Not sure if we require a full ticketing system such as ENOSPC, but
here is a quick fix, which may be too big a hammer.

Quotas are reserved during the start of an operation, incrementing
qg->reserved. However, it is written to disk in a commit_transaction
which could take as long as commit_interval. In the meantime there
could be deletions which are not accounted for because deletions are
accounted for only while committed (free_refroot). So, when we get
a EDQUOT flush the data to disk and try again.

This fixes fstests btrfs/139.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
Changes since v1:
 - Changed start_delalloc_roots() to start_delalloc_inode() to target
   the root in question only to reduce the amount of flush to be done.
 - Added wait_ordered_extents().

Changes since v2:
  - Revised patch header
  - removed comment on combining conditions
  - removed test case, to be done in fstests

Changes sinve v3:
  - testcase reinstated
  - return value checks

Changes since v4:
 - removed testcase since btrfs/139 got incorporated in fstests
 - return statements corrected

 fs/btrfs/qgroup.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a5da750..341c594 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2367,6 +2367,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 ref_root = root->root_key.objectid;
 	int ret = 0;
+	int retried = 0;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 
@@ -2375,7 +2376,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 
 	if (num_bytes == 0)
 		return 0;
-
+retry:
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
 	if (!quota_root)
@@ -2402,6 +2403,27 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 		qg = unode_aux_to_qgroup(unode);
 
 		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
+			/*
+			 * Commit the tree and retry, since we may have
+			 * deletions which would free up space.
+			 */
+			if (!retried && qg->reserved > 0) {
+				struct btrfs_trans_handle *trans;
+				spin_unlock(&fs_info->qgroup_lock);
+				ret = btrfs_start_delalloc_inodes(root, 0);
+				if (ret)
+					return ret;
+				btrfs_wait_ordered_extents(root, -1, 0,
+						(u64)-1);
+				trans = btrfs_join_transaction(root);
+				if (IS_ERR(trans))
+					return PTR_ERR(trans);
+				ret = btrfs_commit_transaction(trans);
+				if (ret)
+					return ret;
+				retried++;
+				goto retry;
+			}
 			ret = -EDQUOT;
 			goto out;
 		}
-- 
2.10.2

