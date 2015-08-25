Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15534 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbbHYRJq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:09:46 -0400
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t7PH7M4t027847
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 10:09:46 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1wgv4202a1-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 10:09:46 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: deal with error on secondary log properly
Date: Tue, 25 Aug 2015 13:09:43 -0400
Message-ID: <1440522583-32120-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have an fsync at the same time in two seperate subvolumes we could end up
with the tree log pointing at invalid blocks.  We need to notice if our writeout
failed in anyway, if it did then we need to do a full transaction commit and
return an error on the subvolume that gave us the io error.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/file.c     | 4 ++++
 fs/btrfs/tree-log.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b823fac..c8f49f5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2054,6 +2054,10 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			if (!ret) {
 				ret = btrfs_end_transaction(trans, root);
 				goto out;
+			} else if (ctx.io_err) {
+				btrfs_end_transaction(trans, root);
+				ret = ctx.io_err;
+				goto out;
 			}
 		}
 		if (!full_sync) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1bbaace..b4f15f5 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2857,6 +2857,10 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		ret = btrfs_wait_marked_extents(log, &log->dirty_log_pages,
 						mark);
 		btrfs_wait_logged_extents(trans, log, log_transid);
+		if (ret) {
+			btrfs_set_log_full_commit(root->fs_info, trans);
+			ctx->io_err = ret;
+		}
 		wait_log_commit(log_root_tree,
 				root_log_ctx.log_transid);
 		mutex_unlock(&log_root_tree->log_mutex);
-- 
2.1.0

