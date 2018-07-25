Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbeGYOfm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 10:35:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6PDJ8Qv097026
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 13:24:01 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2kbvsnwbs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 13:24:01 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6PDO1UJ031957
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 13:24:01 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6PDO1po004755
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 13:24:01 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: btrfs_shrink_device should call commit transaction
Date: Wed, 25 Jul 2018 21:27:27 +0800
Message-Id: <20180725132727.642-1-anand.jain@oracle.com>
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

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
I am bit skeptical about the condition when btrfs_commit_transaction()
fails, can you pls be wary about it when reviewing. Thanks. 

Lu/David,
As this issues isn't reproducible at my end, can you pls test this
patch on top of the patch
  btrfs: fix missing superblock update in the device delete commit transaction
Thanks.

 fs/btrfs/volumes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 418843b8f8e8..344083cc811c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4464,7 +4464,10 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 	/* Now btrfs_update_device() will change the on-disk size. */
 	ret = btrfs_update_device(trans, device);
-	btrfs_end_transaction(trans);
+	if (ret)
+		btrfs_end_transaction(trans);
+	else
+		ret = btrfs_commit_transaction(trans);
 done:
 	btrfs_free_path(path);
 	if (ret) {
-- 
2.7.0

