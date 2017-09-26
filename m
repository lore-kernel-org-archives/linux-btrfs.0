Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22957 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030405AbdIZIjz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 04:39:55 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8Q8drk2019361
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 08:39:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8Q8driZ015073
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 08:39:53 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8Q8drM6025426
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 08:39:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] btrfs: undo writable when sprouting fails
Date: Tue, 26 Sep 2017 16:47:37 +0800
Message-Id: <20170926084738.3558-2-anand.jain@oracle.com>
In-Reply-To: <20170926084738.3558-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170926084738.3558-1-anand.jain@oracle.com>

When new device is being added to seed FS, seed FS is marked writable,
but when we fail to bring in the new device, we missed to undo the
writable part. This patch fixes it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3: none
v2: add commit log

 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e8f16c305df..9d64700cc9b6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2501,6 +2501,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	return ret;
 
 error_trans:
+	if (seeding_dev)
+		sb->s_flags |= MS_RDONLY;
 	btrfs_end_transaction(trans);
 	rcu_string_free(device->name);
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
-- 
2.13.1

