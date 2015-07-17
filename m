Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35699 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbbGQKXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jul 2015 06:23:17 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t6HANG7L032245
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 10:23:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t6HANGi4011092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 10:23:16 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t6HANG6i031180
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 10:23:16 GMT
Message-ID: <55A8D791.2010402@oracle.com>
Date: Fri, 17 Jul 2015 18:23:13 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: move kobj stuff out of dev_replace lock range
References: <1437122959-23376-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1437122959-23376-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 07/17/2015 04:49 PM, Liu Bo wrote:
> To avoid deadlock described in commit 084b6e7c7607 ("btrfs: Fix a lockdep warning when running xfstest."),

> we should move kobj stuff out of dev_replace lock range.

   Is this just a lock optimizing patch or fixing _a_ cause for the
   deadlock. ? Am I missing something?

Thanks,  Anand



> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   fs/btrfs/dev-replace.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 862fbc2..9eb1401 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -376,10 +376,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
>   	WARN_ON(!tgt_device);
>   	dev_replace->tgtdev = tgt_device;
>
> -	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
> -	if (ret)
> -		btrfs_error(root->fs_info, ret, "kobj add dev failed");
> -
>   	printk_in_rcu(KERN_INFO
>   		      "BTRFS: dev_replace from %s (devid %llu) to %s started\n",
>   		      src_device->missing ? "<missing disk>" :
> @@ -402,6 +398,10 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
>   	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>   	btrfs_dev_replace_unlock(dev_replace);
>
> +	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
> +	if (ret)
> +		btrfs_error(root->fs_info, ret, "kobj add dev failed");
> +
>   	btrfs_wait_ordered_roots(root->fs_info, -1);
>
>   	/* force writing the updated state information to disk */
>
