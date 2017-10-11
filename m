Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17079 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbdJKGMD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 02:12:03 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9B6C0Rc005938
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:12:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9B6C0LL008389
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:12:00 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9B6C0MG027351
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:12:00 GMT
Subject: Re: [PATCH] Btrfs: remove rcu_barrier in btrfs_close_devices
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux_lkml_grp@oracle.com
References: <20171010215103.20828-1-bo.li.liu@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ad0d4003-ef66-1da7-a27f-03837d839c11@oracle.com>
Date: Wed, 11 Oct 2017 14:11:46 +0800
MIME-Version: 1.0
In-Reply-To: <20171010215103.20828-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/11/2017 05:51 AM, Liu Bo wrote:
> It was introduced because btrfs used to do blkdev_put in a deferred
> work, now that btrfs has put blkdev in place, this rcu_barrier can be
> removed.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   fs/btrfs/volumes.c | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0e8f16c..d983cea 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -958,12 +958,6 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>   		__btrfs_close_devices(fs_devices);
>   		free_fs_devices(fs_devices);
>   	}
> -	/*
> -	 * Wait for rcu kworkers under __btrfs_close_devices
> -	 * to finish all blkdev_puts so device is really
> -	 * free when umount is done.
> -	 */
> -	rcu_barrier();
>   	return ret;
>   }
>   
> 
