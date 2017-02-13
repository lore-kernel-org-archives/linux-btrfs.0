Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751472AbdBMObG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 09:31:06 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2C6DAAD51
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 14:30:55 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/7] btrfs: qgroups: opencode qgroup_free helper
Date: Mon, 13 Feb 2017 15:30:26 +0100
Message-Id: <f57c767155c283a7e69ddfb64e9f117aa5589c86.1486995885.git.dsterba@suse.com>
In-Reply-To: <cover.1486995885.git.dsterba@suse.com>
References: <cover.1486995885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper name is not too helpful and is just wrapping a simple call.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2b22223c2ad9..114d6770dc23 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2465,11 +2465,6 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 	spin_unlock(&fs_info->qgroup_lock);
 }
 
-static inline void qgroup_free(struct btrfs_root *root, u64 num_bytes)
-{
-	return btrfs_qgroup_free_refroot(root->fs_info, root->objectid,
-					 num_bytes);
-}
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 {
 	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
@@ -2870,7 +2865,9 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 		goto out;
 
 	if (free) {
-		qgroup_free(BTRFS_I(inode)->root, changeset.bytes_changed);
+		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
+				BTRFS_I(inode)->root->objectid,
+				changeset.bytes_changed);
 		trace_op = QGROUP_FREE;
 	}
 	trace_btrfs_qgroup_release_data(inode, start, len,
@@ -2945,7 +2942,7 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
 	reserved = atomic_xchg(&root->qgroup_meta_rsv, 0);
 	if (reserved == 0)
 		return;
-	qgroup_free(root, reserved);
+	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved);
 }
 
 void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
@@ -2959,7 +2956,7 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
 	WARN_ON(atomic_read(&root->qgroup_meta_rsv) < num_bytes);
 	atomic_sub(num_bytes, &root->qgroup_meta_rsv);
-	qgroup_free(root, num_bytes);
+	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes);
 }
 
 /*
@@ -2986,7 +2983,10 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
 				"leaking qgroup reserved space, ino: %lu, start: %llu, end: %llu",
 				inode->i_ino, unode->val, unode->aux);
 		}
-		qgroup_free(BTRFS_I(inode)->root, changeset.bytes_changed);
+		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
+				BTRFS_I(inode)->root->objectid,
+				changeset.bytes_changed);
+
 	}
 	ulist_fini(&changeset.range_changed);
 }
-- 
2.10.1

