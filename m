Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20260 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751660AbdB0HLQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 02:11:16 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>, <clm@fb.com>
Subject: [PATCH 2/9] btrfs: qgroup: Re-arrange tracepoint timing to co-operate with reserved space tracepoint
Date: Mon, 27 Feb 2017 15:10:32 +0800
Message-ID: <20170227071039.8335-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
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
---
 fs/btrfs/qgroup.c | 10 +++++-----
 fs/btrfs/qgroup.h |  6 +-----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b303d4794026..e46499cafdbf 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2895,14 +2895,14 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
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
index 26932a8a1993..92608edf0e89 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -186,15 +186,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
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
2.11.1



