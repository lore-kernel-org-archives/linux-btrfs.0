Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2863 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753264AbcK1Bl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 Nov 2016 20:41:29 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lkml.page@gmail.com
Subject: [PATCH v4 3/3] btrfs: qgroup: Re-arrange tracepoint timing to co-operate with reserved space tracepoint
Date: Mon, 28 Nov 2016 09:40:09 +0800
Message-Id: <20161128014009.12179-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161128014009.12179-1-quwenruo@cn.fujitsu.com>
References: <20161128014009.12179-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
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
v3:
  Separated from new trace points patch.
v4:
  None
---
 fs/btrfs/qgroup.c | 6 +++---
 fs/btrfs/qgroup.h | 6 +-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index aeda450..b3837cd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2660,12 +2660,12 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 	if (ret < 0)
 		goto out;
 
-	if (free) {
-		qgroup_free(BTRFS_I(inode)->root, changeset.bytes_changed);
+	if (free)
 		trace_op = QGROUP_FREE;
-	}
 	trace_btrfs_qgroup_release_data(inode, start, len,
 					changeset.bytes_changed, trace_op);
+	if (free)
+		qgroup_free(BTRFS_I(inode)->root, changeset.bytes_changed);
 out:
 	ulist_free(changeset.range_changed);
 	return ret;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 1bc64c8..93b222b 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -107,15 +107,11 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
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
2.10.2



