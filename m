Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33559 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932843AbcIFNtg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 09:49:36 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u86DnRZk008730
        for <linux-btrfs@vger.kernel.org>; Tue, 6 Sep 2016 06:49:34 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 257tb51056-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Sep 2016 06:49:34 -0700
Received: from facebook.com (2401:db00:2040:5012:face:0:1:0)    by
 mx-out.facebook.com (10.223.101.97) with ESMTP id
 a154d716743811e683c424be0595f910-146f0a50 for <linux-btrfs@vger.kernel.org>;
        Tue, 06 Sep 2016 06:48:45 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove root_log_ctx from ctx list before btrfs_sync_log returns
Date: Tue, 6 Sep 2016 06:48:45 -0700
Message-ID: <1473169725-3325998-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use a btrfs_log_ctx structure to pass information into the
tree log commit, and get error values out.  It gets added to a per
log-transaction list which we walk when things go bad.

Commit d1433debe added an optimization to skip waiting for the log
commit, but didn't take root_log_ctx out of the list.  This
patch makes sure we remove things before exiting.

Signed-off-by: Chris Mason <clm@fb.com>
Fixes: d1433debe7f4346cf9fc0dafc71c3137d2a97bc4
cc: stable@vger.kernel.org # 3.15+
---
 fs/btrfs/tree-log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e935035..ef9c55b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2867,6 +2867,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	if (log_root_tree->log_transid_committed >= root_log_ctx.log_transid) {
 		blk_finish_plug(&plug);
+		list_del_init(&root_log_ctx.list);
 		mutex_unlock(&log_root_tree->log_mutex);
 		ret = root_log_ctx.log_ret;
 		goto out;
-- 
2.8.0.rc2

