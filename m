Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36586 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031531AbbD2Cbd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 22:31:33 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3T2UHpe018364
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 10:30:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 18/18] btrfs: qgroup: Make snapshot accounting work with new extent-oriented qgroup.
Date: Wed, 29 Apr 2015 10:29:11 +0800
Message-ID: <1430274551-9277-19-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make snapshot accounting work with new extent-oriented mechanism by
skipping given root in new/old_roots in create_pending_snapshot().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 fs/btrfs/transaction.c | 53 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2b50ce4..0f3c1b8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1286,6 +1286,12 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	if (pending->error)
 		goto no_free_objectid;
 
+	/*
+	 * Make qgroup to skip current new snapshot's qgroupid, as it is
+	 * accounted by later btrfs_qgroup_inherit().
+	 */
+	btrfs_set_skip_qgroup(trans, objectid);
+
 	btrfs_reloc_pre_snapshot(trans, pending, &to_reserve);
 
 	if (to_reserve > 0) {
@@ -1294,7 +1300,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 						     to_reserve,
 						     BTRFS_RESERVE_NO_FLUSH);
 		if (pending->error)
-			goto no_free_objectid;
+			goto clear_skip_qgroup;
 	}
 
 	key.objectid = objectid;
@@ -1392,25 +1398,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		btrfs_abort_transaction(trans, root, ret);
 		goto fail;
 	}
-
-	/*
-	 * We need to flush delayed refs in order to make sure all of our quota
-	 * operations have been done before we call btrfs_qgroup_inherit.
-	 */
-	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	if (ret) {
-		btrfs_abort_transaction(trans, root, ret);
-		goto fail;
-	}
-
-	ret = btrfs_qgroup_inherit(trans, fs_info,
-				   root->root_key.objectid,
-				   objectid, pending->inherit);
-	if (ret) {
-		btrfs_abort_transaction(trans, root, ret);
-		goto fail;
-	}
-
 	/* see comments in should_cow_block() */
 	set_bit(BTRFS_ROOT_FORCE_COW, &root->state);
 	smp_wmb();
@@ -1493,11 +1480,37 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 			goto fail;
 		}
 	}
+
+	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
+
+	/*
+	 * account qgroup counters before qgroup_inherit()
+	 */
+	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
+	if (ret)
+		goto fail;
+	ret = btrfs_qgroup_account_extents(trans, fs_info);
+	if (ret)
+		goto fail;
+	ret = btrfs_qgroup_inherit(trans, fs_info,
+				   root->root_key.objectid,
+				   objectid, pending->inherit);
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto fail;
+	}
+
 fail:
 	pending->error = ret;
 dir_item_existed:
 	trans->block_rsv = rsv;
 	trans->bytes_reserved = 0;
+clear_skip_qgroup:
+	btrfs_clear_skip_qgroup(trans);
 no_free_objectid:
 	kfree(new_root_item);
 root_item_alloc_fail:
-- 
2.3.6

