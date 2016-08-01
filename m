Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40928 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbcHAQbJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Aug 2016 12:31:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E53932045B
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Aug 2016 16:24:56 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id B368D20451
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Aug 2016 16:24:55 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: send, don't bug on inconsistent snapshots
Date: Mon,  1 Aug 2016 03:16:52 +0100
Message-Id: <1470017812-11124-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When doing an incremental send, if we find a new/modified/deleted extent,
reference or xattr without having previously processed the corresponding
inode item we end up exexuting a BUG_ON(). This is because whenever an
extent, xattr or reference is added, modified or deleted, we always expect
to have the corresponding inode item updated. However there are situations
where this will not happen due to transient -ENOMEM or -ENOSPC errors when
doing delayed inode updates.

For example, when punching holes we can succeed in deleting and modifying
(shrinking) extents but later fail to do the delayed inode update. So after
such failure we close our transaction handle and right after a snapshot of
the fs/subvol tree can be made and used later for a send operation. The
same thing can happen during truncate, link, unlink, and xattr related
operations.

So instead of executing a BUG_ON, make send return an -EIO error and print
an informative error message do dmesg/syslog.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/send.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 2db8dc8..efe129f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -273,6 +273,39 @@ struct name_cache_entry {
 	char name[];
 };
 
+static void inconsistent_snapshot_error(struct send_ctx *sctx,
+					enum btrfs_compare_tree_result result,
+					const char *what)
+{
+	const char *result_string;
+
+	switch (result) {
+	case BTRFS_COMPARE_TREE_NEW:
+		result_string = "new";
+		break;
+	case BTRFS_COMPARE_TREE_DELETED:
+		result_string = "deleted";
+		break;
+	case BTRFS_COMPARE_TREE_CHANGED:
+		result_string = "updated";
+		break;
+	case BTRFS_COMPARE_TREE_SAME:
+		ASSERT(0);
+		result_string = "unchanged";
+		break;
+	default:
+		ASSERT(0);
+		result_string = "unexpected";
+	}
+
+	btrfs_err(sctx->send_root->fs_info,
+		  "Send: inconsistent snapshot, found %s %s for inode %llu without updated inode item, send root is %llu, parent root is %llu",
+		  result_string, what, sctx->cmp_key->objectid,
+		  sctx->send_root->root_key.objectid,
+		  (sctx->parent_root ?
+		   sctx->parent_root->root_key.objectid : 0));
+}
+
 static int is_waiting_for_move(struct send_ctx *sctx, u64 ino);
 
 static struct waiting_dir_move *
@@ -5711,7 +5744,10 @@ static int changed_ref(struct send_ctx *sctx,
 {
 	int ret = 0;
 
-	BUG_ON(sctx->cur_ino != sctx->cmp_key->objectid);
+	if (sctx->cur_ino != sctx->cmp_key->objectid) {
+		inconsistent_snapshot_error(sctx, result, "reference");
+		return -EIO;
+	}
 
 	if (!sctx->cur_inode_new_gen &&
 	    sctx->cur_ino != BTRFS_FIRST_FREE_OBJECTID) {
@@ -5736,7 +5772,10 @@ static int changed_xattr(struct send_ctx *sctx,
 {
 	int ret = 0;
 
-	BUG_ON(sctx->cur_ino != sctx->cmp_key->objectid);
+	if (sctx->cur_ino != sctx->cmp_key->objectid) {
+		inconsistent_snapshot_error(sctx, result, "xattr");
+		return -EIO;
+	}
 
 	if (!sctx->cur_inode_new_gen && !sctx->cur_inode_deleted) {
 		if (result == BTRFS_COMPARE_TREE_NEW)
@@ -5760,7 +5799,10 @@ static int changed_extent(struct send_ctx *sctx,
 {
 	int ret = 0;
 
-	BUG_ON(sctx->cur_ino != sctx->cmp_key->objectid);
+	if (sctx->cur_ino != sctx->cmp_key->objectid) {
+		inconsistent_snapshot_error(sctx, result, "extent");
+		return -EIO;
+	}
 
 	if (!sctx->cur_inode_new_gen && !sctx->cur_inode_deleted) {
 		if (result != BTRFS_COMPARE_TREE_DELETED)
-- 
2.7.0.rc3

