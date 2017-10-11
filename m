Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37120 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754282AbdJKG4u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 02:56:50 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9B6umww014428
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:56:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9B6ummf003947
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:56:48 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9B6umcx004232
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:56:48 GMT
Subject: Re: [PATCH] Btrfs: free btrfs_device in place
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux_lkml_grp@oracle.com
References: <20171010215103.20828-2-bo.li.liu@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <a0b1173b-40ca-f051-ce66-3856c5985cee@oracle.com>
Date: Wed, 11 Oct 2017 14:56:34 +0800
MIME-Version: 1.0
In-Reply-To: <20171010215103.20828-2-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/11/2017 05:51 AM, Liu Bo wrote:
> It's pointless to defer it to a kthread helper as we're not under any
> special context.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   fs/btrfs/volumes.c | 14 ++------------
>   1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d983cea..4a72c45 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -836,26 +836,16 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step)
>   	mutex_unlock(&uuid_mutex);
>   }
>   
> -static void __free_device(struct work_struct *work)
> +static void free_device(struct rcu_head *head)
>   {
>   	struct btrfs_device *device;
>   
> -	device = container_of(work, struct btrfs_device, rcu_work);
> +	device = container_of(head, struct btrfs_device, rcu);
>   	rcu_string_free(device->name);
>   	bio_put(device->flush_bio);
>   	kfree(device);
>   }
>   
> -static void free_device(struct rcu_head *head)
> -{
> -	struct btrfs_device *device;
> -
> -	device = container_of(head, struct btrfs_device, rcu);
> -
> -	INIT_WORK(&device->rcu_work, __free_device);
> -	schedule_work(&device->rcu_work);
> -}
> -
>   static void btrfs_close_bdev(struct btrfs_device *device)
>   {
>   	if (device->bdev && device->writeable) {
> 
