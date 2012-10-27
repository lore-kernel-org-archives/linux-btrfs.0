Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:30108 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2J0MIN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 08:08:13 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9RC8Cfw011083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 12:08:12 GMT
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9RC6n64026116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 12:06:49 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9RC6meN003839
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 12:06:49 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9RC6mCw000769
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2012 07:06:48 -0500
Message-ID: <508BCE4F.10107@oracle.com>
Date: Sat, 27 Oct 2012 20:06:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs:  Remove the invalid shrink size check up from btrfs_shrink_dev()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove an invalid size check up from btrfs_shrink_dev().

The new size should not larger than the device->total_bytes as it was
already verified before coming to here(i.e. new_size < old_size).

Remove invalid check up for btrfs_shrink_dev().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/btrfs/ioctl.c   |    2 +-
 fs/btrfs/volumes.c |    3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9df50fa..a747da9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1383,7 +1383,7 @@ static noinline int btrfs_ioctl_resize(struct
btrfs_root *root,
 		btrfs_commit_transaction(trans, root);
 	} else if (new_size < old_size) {
 		ret = btrfs_shrink_device(device, new_size);
-	}
+	} /* equal, nothing need to do */

 out_free:
 	kfree(vol_args);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 88b969a..8fda4fb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3038,9 +3038,6 @@ int btrfs_shrink_device(struct btrfs_device
*device, u64 new_size)
 	u64 old_size = device->total_bytes;
 	u64 diff = device->total_bytes - new_size;

-	if (new_size >= device->total_bytes)
-		return -EINVAL;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.7.9.5
