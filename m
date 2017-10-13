Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31948 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751657AbdJMCSQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 22:18:16 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: [PATCH] btrfs: fix call to btrfs_end_transaction without a transaction handler
Date: Fri, 13 Oct 2017 10:16:54 +0800
Message-Id: <20171013021654.14461-1-anand.jain@oracle.com>
In-Reply-To: <20171012203900.dqdsfcpbfjyl7bea@mwanda>
References: <20171012203900.dqdsfcpbfjyl7bea@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_init_new_device() when btrfs_attach_transaction() fails we
shouldn't call btrfs_end_transaction(). Fix it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Fixes:
  btrfs: error out if btrfs_attach_transaction() fails
---
Hi David,
  Can you pls squash this changes to the patch which it
  fixes. OR if its better to send the original the with
  the fix, pls let me know I will do it.
Thanks.

 fs/btrfs/volumes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 90805581ea10..efd502176915 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2477,6 +2477,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 			if (PTR_ERR(trans) == -ENOENT)
 				return 0;
 			ret = PTR_ERR(trans);
+			trans = NULL;
 			goto error_sysfs;
 		}
 		ret = btrfs_commit_transaction(trans);
@@ -2491,7 +2492,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 error_trans:
 	if (seeding_dev)
 		sb->s_flags |= MS_RDONLY;
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 	rcu_string_free(device->name);
 	kfree(device);
 error:
-- 
2.13.1

