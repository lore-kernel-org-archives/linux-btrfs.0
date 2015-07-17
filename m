Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51637 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbbGQMCD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jul 2015 08:02:03 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t6HC22Qm009880
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 12:02:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t6HC223j030570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 12:02:02 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t6HC22A1004889
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 12:02:02 GMT
Date: Fri, 17 Jul 2015 19:59:55 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: move kobj stuff out of dev_replace lock range
Message-ID: <20150717115954.GA28169@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1437122959-23376-1-git-send-email-bo.li.liu@oracle.com>
 <55A8D791.2010402@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55A8D791.2010402@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 17, 2015 at 06:23:13PM +0800, Anand Jain wrote:
> 
> On 07/17/2015 04:49 PM, Liu Bo wrote:
> >To avoid deadlock described in commit 084b6e7c7607 ("btrfs: Fix a lockdep warning when running xfstest."),
> 
> >we should move kobj stuff out of dev_replace lock range.
> 
>   Is this just a lock optimizing patch or fixing _a_ cause for the
>   deadlock. ? Am I missing something?

The reason that commit 084b6e7c7607 has described[1] matters here, but in my
own case the problem didn't get fixed with this patch, and I'm changing
it into rwlock, which doesn't allow memory allocation inside the lock
range.

Thanks,

-liubo

[1]:
"It is because the btrfs_kobj_{add/rm}_device() will call memory
allocation with GFP_KERNEL,
which may flush fs page cache to free space, waiting for it self to do
the commit, causing the deadlock.

To solve the problem, move btrfs_kobj_{add/rm}_device() out of the
dev_replace lock range, also involing split the
btrfs_rm_dev_replace_srcdev() function into remove and free parts.

Now only btrfs_rm_dev_replace_remove_srcdev() is called in dev_replace
lock range, and kobj_{add/rm} and btrfs_rm_dev_replace_free_srcdev() are
called out of the lock range."

> 
> Thanks,  Anand
> 
> 
> 
> >Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >---
> >  fs/btrfs/dev-replace.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> >diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> >index 862fbc2..9eb1401 100644
> >--- a/fs/btrfs/dev-replace.c
> >+++ b/fs/btrfs/dev-replace.c
> >@@ -376,10 +376,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
> >  	WARN_ON(!tgt_device);
> >  	dev_replace->tgtdev = tgt_device;
> >
> >-	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
> >-	if (ret)
> >-		btrfs_error(root->fs_info, ret, "kobj add dev failed");
> >-
> >  	printk_in_rcu(KERN_INFO
> >  		      "BTRFS: dev_replace from %s (devid %llu) to %s started\n",
> >  		      src_device->missing ? "<missing disk>" :
> >@@ -402,6 +398,10 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
> >  	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
> >  	btrfs_dev_replace_unlock(dev_replace);
> >
> >+	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
> >+	if (ret)
> >+		btrfs_error(root->fs_info, ret, "kobj add dev failed");
> >+
> >  	btrfs_wait_ordered_roots(root->fs_info, -1);
> >
> >  	/* force writing the updated state information to disk */
> >
