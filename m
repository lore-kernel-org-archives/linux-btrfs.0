Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26398 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbEHEho (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 00:37:44 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Wolfgang_Mader@brain-frog.de, dsterba@suse.cz
Subject: [PATCH 2/2] Btrfs: check error before reporting missing device and add uuid
Date: Fri,  8 May 2015 04:34:35 +0800
Message-Id: <1431030875-17754-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430109979-9397-3-git-send-email-anand.jain@oracle.com>
References: <1430109979-9397-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Report missing device when add is successful,
otherwise it would exit as ENOMEM. And add uuid
to the report.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
v1->v2: rebase to 4.1, fix compile error,
        still wonder why it wasn't in 3.19x.

 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ef1124f..228f26b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6299,10 +6299,11 @@ static int read_one_dev(struct btrfs_root *root,
 		if (!btrfs_test_opt(root, DEGRADED))
 			return -EIO;
 
-		btrfs_warn(root->fs_info, "devid %llu missing", devid);
 		device = add_missing_dev(root, fs_devices, devid, dev_uuid);
 		if (!device)
 			return -ENOMEM;
+		btrfs_warn(root->fs_info, "devid %llu uuid %pU missing",
+				devid, dev_uuid);
 	} else {
 		if (!device->bdev && !btrfs_test_opt(root, DEGRADED))
 			return -EIO;
-- 
2.0.0.153.g79dcccc

