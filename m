Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39738 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3LIJeo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Dec 2013 04:34:44 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rB99Yg0k025946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Dec 2013 09:34:43 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB99YfH0020194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Dec 2013 09:34:42 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB99YfWZ019788
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Dec 2013 09:34:41 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: avoid building inode cache repeatly
Date: Mon,  9 Dec 2013 17:34:31 +0800
Message-Id: <1386581671-4639-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Inode cache is similar to free space cache and in fact shares the same
code, however, we don't load inode cache unless we're about to allocate
inode id, then there is a case where we only commit the transaction during
other operations, such as snapshot creation, we now update fs roots' generation
to the new transaction id, after that when we want to load the inode cache,
we'll find that it's not valid thanks to the mismatch of generation, and we
have to push btrfs-ino-cache thread to build inode cache from disk, and
this operation is sometimes time-costing.

So to fix the above, we load inode cache into memory during reading fs root.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c   | 9 +++++----
 fs/btrfs/inode-map.c | 2 ++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9c9667d..93b4473 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1525,14 +1525,15 @@ int btrfs_init_fs_root(struct btrfs_root *root)
 		goto fail;
 	}
 
-	btrfs_init_free_ino_ctl(root);
+	ret = get_anon_bdev(&root->anon_dev);
+	if (ret)
+		goto fail;
+
 	mutex_init(&root->fs_commit_mutex);
 	spin_lock_init(&root->cache_lock);
 	init_waitqueue_head(&root->cache_wait);
+	btrfs_init_free_ino_ctl(root);
 
-	ret = get_anon_bdev(&root->anon_dev);
-	if (ret)
-		goto fail;
 	return 0;
 fail:
 	kfree(root->free_ino_ctl);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index ab485e5..6c8d7bb 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -388,6 +388,8 @@ void btrfs_init_free_ino_ctl(struct btrfs_root *root)
 	pinned->private = NULL;
 	pinned->extents_thresh = 0;
 	pinned->op = &pinned_free_ino_op;
+
+	start_caching(root);
 }
 
 int btrfs_save_ino_cache(struct btrfs_root *root,
-- 
1.8.2.1

