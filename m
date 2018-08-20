Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49774 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbeHTLkb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 07:40:31 -0400
Date: Mon, 20 Aug 2018 11:25:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] btrfs: use after free in btrfs_quota_enable()
Message-ID: <20180820082533.rs3yh4agza6epz7j@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The issue here is that btrfs_commit_transaction() frees "trans" on both
the error and the success path.  So the problem would be if
btrfs_commit_transaction() succeeds, and then qgroup_rescan_init()
fails.  That means that "ret" is non-zero and "trans" is non-NULL and it
leads to a use after free inside the btrfs_end_transaction() macro.

Fixes: 340f1aa27f36 ("btrfs: qgroups: Move transaction management inside btrfs_quota_enable/disable")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4353bb69bb86..d4917c0cddf5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1019,10 +1019,9 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	spin_unlock(&fs_info->qgroup_lock);
 
 	ret = btrfs_commit_transaction(trans);
-	if (ret) {
-		trans = NULL;
+	trans = NULL;
+	if (ret)
 		goto out_free_path;
-	}
 
 	ret = qgroup_rescan_init(fs_info, 0, 1);
 	if (!ret) {
