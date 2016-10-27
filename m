Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35648 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752074AbcJ0SvI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 14:51:08 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9RIkXfw031944
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 11:51:07 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 26bcpmx9rs-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 11:51:07 -0700
Received: from facebook.com (2401:db00:2040:5012:face:0:1:0)    by
 mx-out.facebook.com (10.223.100.99) with ESMTP id
 510ea8989c7611e6900f24be05956610-52ffca50 for <linux-btrfs@vger.kernel.org>;
        Thu, 27 Oct 2016 11:51:06 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fix races on root_log_ctx lists
Date: Thu, 27 Oct 2016 11:51:05 -0700
Message-ID: <20161027185105.2016317-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_remove_all_log_ctxs takes a shortcut where it avoids walking the
list because it knows all of the waiters are patiently waiting for the
commit to finish.

But, there's a small race where btrfs_sync_log can remove itself from
the list if it finds a log commit is already done.  Also, it uses
list_del_init() to remove itself from the list, but there's no way to
know if btrfs_remove_all_log_ctxs has already run, so we don't know for
sure if it is safe to call list_del_init().

This gets rid of all the shortcuts for btrfs_remove_all_log_ctxs(), and
just calls it with the proper locking.

This is part two of the corruption fixed by cbd60aa7cd1.  I should have
done this in the first place, but convinced myself the optimizations were
safe.  A 12 hour run of dbench 2048 will eventually trigger a list debug
WARN_ON for the list_del_init() in btrfs_sync_log().

Fixes: d1433debe7f4346cf9fc0dafc71c3137d2a97bc4
Reported-by: Dave Jones <davej@codemonkey.org.uk>
cc: stable@vger.kernel.org # 3.15+
Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/tree-log.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 688df71..4b1c0a6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2713,14 +2713,12 @@ static inline void btrfs_remove_all_log_ctxs(struct btrfs_root *root,
 					     int index, int error)
 {
 	struct btrfs_log_ctx *ctx;
+	struct btrfs_log_ctx *safe;
 
-	if (!error) {
-		INIT_LIST_HEAD(&root->log_ctxs[index]);
-		return;
-	}
-
-	list_for_each_entry(ctx, &root->log_ctxs[index], list)
+	list_for_each_entry_safe(ctx, safe, &root->log_ctxs[index], list) {
+		list_del_init(&ctx->list);
 		ctx->log_ret = error;
+	}
 
 	INIT_LIST_HEAD(&root->log_ctxs[index]);
 }
@@ -2961,13 +2959,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_unlock(&root->log_mutex);
 
 out_wake_log_root:
-	/*
-	 * We needn't get log_mutex here because we are sure all
-	 * the other tasks are blocked.
-	 */
+	mutex_lock(&log_root_tree->log_mutex);
 	btrfs_remove_all_log_ctxs(log_root_tree, index2, ret);
 
-	mutex_lock(&log_root_tree->log_mutex);
 	log_root_tree->log_transid_committed++;
 	atomic_set(&log_root_tree->log_commit[index2], 0);
 	mutex_unlock(&log_root_tree->log_mutex);
@@ -2978,10 +2972,8 @@ out_wake_log_root:
 	if (waitqueue_active(&log_root_tree->log_commit_wait[index2]))
 		wake_up(&log_root_tree->log_commit_wait[index2]);
 out:
-	/* See above. */
-	btrfs_remove_all_log_ctxs(root, index1, ret);
-
 	mutex_lock(&root->log_mutex);
+	btrfs_remove_all_log_ctxs(root, index1, ret);
 	root->log_transid_committed++;
 	atomic_set(&root->log_commit[index1], 0);
 	mutex_unlock(&root->log_mutex);
-- 
2.9.3

