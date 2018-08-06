Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55470 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbeHFMR2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Aug 2018 08:17:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w76A8niI024537
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 10:09:06 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2kn4spm39s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Aug 2018 10:09:06 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w76A95Ga028746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 10:09:05 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w76A94lB006227
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Aug 2018 10:09:05 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: btrfs_shrink_device should call commit transaction
Date: Mon,  6 Aug 2018 18:12:37 +0800
Message-Id: <20180806101237.20507-1-anand.jain@oracle.com>
In-Reply-To: <20180725132727.642-1-anand.jain@oracle.com>
References: <20180725132727.642-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

test case btrfs/164 reported UAF..

[ 6712.084324] general protection fault: 0000 [#1] PREEMPT SMP
::
[ 6712.195423]  btrfs_update_commit_device_size+0x75/0xf0 [btrfs]
[ 6712.201424]  btrfs_commit_transaction+0x57d/0xa90 [btrfs]
[ 6712.206999]  btrfs_rm_device+0x627/0x850 [btrfs]
[ 6712.211800]  btrfs_ioctl+0x2b03/0x3120 [btrfs]
::

reason for this is that btrfs_shrink_device() adds the device resized to
the fs_devices::resized_devices after it has called the last commit
transaction.
So the list fs_devices::resized_devices is not empty when
btrfs_shrink_device() returns.
Now the parent function btrfs_rm_device() calls
        btrfs_close_bdev(device);
        call_rcu(&device->rcu, free_device_rcu);
and then does the commit transaction.
The commit transaction goes through the fs_devices::resized_devices
in btrfs_update_commit_device_size() and leads to UAF.

Fix this by making sure btrfs_shrink_device() calls the last needed
btrfs_commit_transaction() before the return.

Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
v1->v2: cleanup the dirty and new meta block group before ending
the transaction when btrfs_update_device fails.

 fs/btrfs/volumes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index da86706123ff..f4405e430da6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4491,7 +4491,12 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 	/* Now btrfs_update_device() will change the on-disk size. */
 	ret = btrfs_update_device(trans, device);
-	btrfs_end_transaction(trans);
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
+	} else {
+		ret = btrfs_commit_transaction(trans);
+	}
 done:
 	btrfs_free_path(path);
 	if (ret) {
-- 
2.7.0

