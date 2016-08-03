Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757672AbcHCKlX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Aug 2016 06:41:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 97FDB201F2
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Aug 2016 10:31:11 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 7D365201EF
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Aug 2016 10:31:10 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unused function btrfs_add_delayed_qgroup_reserve()
Date: Wed,  3 Aug 2016 11:31:06 +0100
Message-Id: <1470220266-27980-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

No longer used as of commit 5846a3c26873 ("btrfs: qgroup: Fix a race in
delayed_ref which leads to abort trans").

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/delayed-ref.c | 27 ---------------------------
 fs/btrfs/delayed-ref.h |  3 ---
 2 files changed, 30 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 430b368..02dd2ec 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -861,33 +861,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
-				     struct btrfs_trans_handle *trans,
-				     u64 ref_root, u64 bytenr, u64 num_bytes)
-{
-	struct btrfs_delayed_ref_root *delayed_refs;
-	struct btrfs_delayed_ref_head *ref_head;
-	int ret = 0;
-
-	if (!fs_info->quota_enabled || !is_fstree(ref_root))
-		return 0;
-
-	delayed_refs = &trans->transaction->delayed_refs;
-
-	spin_lock(&delayed_refs->lock);
-	ref_head = find_ref_head(&delayed_refs->href_root, bytenr, 0);
-	if (!ref_head) {
-		ret = -ENOENT;
-		goto out;
-	}
-	WARN_ON(ref_head->qgroup_reserved || ref_head->qgroup_ref_root);
-	ref_head->qgroup_ref_root = ref_root;
-	ref_head->qgroup_reserved = num_bytes;
-out:
-	spin_unlock(&delayed_refs->lock);
-	return ret;
-}
-
 int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 5fca953..43f3629 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -250,9 +250,6 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
 			       struct btrfs_delayed_extent_op *extent_op);
-int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
-				     struct btrfs_trans_handle *trans,
-				     u64 ref_root, u64 bytenr, u64 num_bytes);
 int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
-- 
2.7.0.rc3

