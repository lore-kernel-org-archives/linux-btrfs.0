Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37028 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3I0Ujc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 16:39:32 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C16999A06B2
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 14:39:31 -0600 (MDT)
Received: from CAS2.int.fusionio.com ([10.101.1.41]) by mx2.fusionio.com with ESMTP id crEAQOgyjcTOLGKh (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 14:39:31 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove all BUG_ON()'s from commit_cowonly_roots
Date: Fri, 27 Sep 2013 16:39:29 -0400
Message-ID: <1380314369-29126-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Noticed this when forcing errors to happen during delayed ref running.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/transaction.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 72d2b67..374a91b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -950,16 +950,19 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 		return ret;
 
 	ret = btrfs_run_dev_stats(trans, root->fs_info);
-	WARN_ON(ret);
+	if (ret)
+		return ret;
 	ret = btrfs_run_dev_replace(trans, root->fs_info);
-	WARN_ON(ret);
-
+	if (ret)
+		return ret;
 	ret = btrfs_run_qgroups(trans, root->fs_info);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	/* run_qgroups might have added some more refs */
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
-- 
1.8.3.1

