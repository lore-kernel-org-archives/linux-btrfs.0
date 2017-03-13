Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12166 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750863AbdCMHws (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:52:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E95D548A2948
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 15:52:44 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/9] btrfs: qgroup: Re-arrange tracepoint timing to co-operate with reserved space tracepoint
Date: Mon, 13 Mar 2017 15:52:09 +0800
Message-ID: <20170313075216.5125-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Newly introduced qgroup reserved space trace points are normally nested
into several common qgroup operations.

While some other trace points are not well placed to co-operate with
them, causing confusing output.

This patch re-arrange trace_btrfs_qgroup_release_data() and
trace_btrfs_qgroup_free_delayed_ref() trace points so they are triggered
before reserved space ones.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/qgroup.c | 10 +++++-----
 fs/btrfs/qgroup.h |  6 +-----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 68a7305b0a46..1fe481d71be5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2847,14 +2847,14 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 	if (ret < 0)
 		goto out;
 
-	if (free) {
-		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
-				BTRFS_I(inode)->root->objectid,
-				changeset.bytes_changed);
+	if (free)
 		trace_op = QGROUP_FREE;
-	}
 	trace_btrfs_qgroup_release_data(inode, start, len,
 					changeset.bytes_changed, trace_op);
+	if (free)
+		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
+				BTRFS_I(inode)->root->objectid,
+				changeset.bytes_changed);
 out:
 	ulist_release(&changeset.range_changed);
 	return ret;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index e5b42f1044fc..19188e094d0e 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -230,15 +230,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_qgroup_inherit *inherit);
 void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 			       u64 ref_root, u64 num_bytes);
-/*
- * TODO: Add proper trace point for it, as btrfs_qgroup_free() is
- * called by everywhere, can't provide good trace for delayed ref case.
- */
 static inline void btrfs_qgroup_free_delayed_ref(struct btrfs_fs_info *fs_info,
 						 u64 ref_root, u64 num_bytes)
 {
-	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
 	trace_btrfs_qgroup_free_delayed_ref(fs_info, ref_root, num_bytes);
+	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
 }
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
 
-- 
2.12.0



