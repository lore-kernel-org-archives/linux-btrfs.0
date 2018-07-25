Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30032 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728646AbeGYSEi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 14:04:38 -0400
Date: Thu, 26 Jul 2018 00:52:03 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: btrfs_shrink_device should call commit transaction
Message-ID: <20180725165203.GH575@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180725132727.642-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180725132727.642-1-anand.jain@oracle.com>

On Wed, Jul 25, 2018 at 09:27:27PM +0800, Anand Jain wrote:
>test case btrfs/164 reported UAF..
>
>[ 6712.084324] general protection fault: 0000 [#1] PREEMPT SMP
>::
>[ 6712.195423]  btrfs_update_commit_device_size+0x75/0xf0 [btrfs]
>[ 6712.201424]  btrfs_commit_transaction+0x57d/0xa90 [btrfs]
>[ 6712.206999]  btrfs_rm_device+0x627/0x850 [btrfs]
>[ 6712.211800]  btrfs_ioctl+0x2b03/0x3120 [btrfs]
>::
>
>reason for this is that btrfs_shrink_device() adds the device resized to
>the fs_devices::resized_devices after it has called the last commit
>transaction.
>So the list fs_devices::resized_devices is not empty when
>btrfs_shrink_device() returns.
>Now the parent function btrfs_rm_device() calls
>        btrfs_close_bdev(device);
>        call_rcu(&device->rcu, free_device_rcu);
>and then does the commit transaction.
>The commit transaction goes through the fs_devices::resized_devices
>in btrfs_update_commit_device_size() and leads to UAF.
>
>Fix this by making sure btrfs_shrink_device() calls the last needed
>btrfs_commit_transaction() before the return.
>
>Signed-off-by: Anand Jain <anand.jain@oracle.com>
>---
>I am bit skeptical about the condition when btrfs_commit_transaction()
>fails, can you pls be wary about it when reviewing. Thanks. 
>
>Lu/David,
>As this issues isn't reproducible at my end, can you pls test this
>patch on top of the patch
>  btrfs: fix missing superblock update in the device delete commit transaction

Tested-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>Thanks.
>
> fs/btrfs/volumes.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>index 418843b8f8e8..344083cc811c 100644
>--- a/fs/btrfs/volumes.c
>+++ b/fs/btrfs/volumes.c
>@@ -4464,7 +4464,10 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
> 
> 	/* Now btrfs_update_device() will change the on-disk size. */
> 	ret = btrfs_update_device(trans, device);
>-	btrfs_end_transaction(trans);
>+	if (ret)
>+		btrfs_end_transaction(trans);
>+	else
>+		ret = btrfs_commit_transaction(trans);
> done:
> 	btrfs_free_path(path);
> 	if (ret) {
>-- 
>2.7.0
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


