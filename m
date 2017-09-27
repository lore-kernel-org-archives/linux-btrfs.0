Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28725 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdI0Jv2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 05:51:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com, dsterba@suse.cz
Subject: [PATCH] btrfs: take the error path out if btrfs_attach_transaction() fails
Date: Wed, 27 Sep 2017 17:50:52 +0800
Message-Id: <20170927095052.22663-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_init_new_device() calls btrfs_attach_transaction() to
commit sys chunks, however take the error path out if it fails.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fad3b10a1f81..b526d13a74da 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2494,7 +2494,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		if (IS_ERR(trans)) {
 			if (PTR_ERR(trans) == -ENOENT)
 				return 0;
-			return PTR_ERR(trans);
+			ret = PTR_ERR(trans);
+			goto error_sysfs;
 		}
 		ret = btrfs_commit_transaction(trans);
 	}
-- 
2.13.1

