Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22473 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752211AbdCIAg3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 19:36:29 -0500
Subject: Re: [PATCH v2 1/6] btrfs: Introduce a function to check if all chunks
 a OK for degraded rw mount
To: Anand Jain <anand.jain@oracle.com>
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
 <20170306085855.11403-2-quwenruo@cn.fujitsu.com>
 <b698b207-bef6-4064-302d-784dda4dacd5@oracle.com>
 <4ccef095-36b7-3b1e-1baf-eec09562d52c@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <lists@colorremedies.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f9750949-8fab-4e56-912e-4ca8fc9d0d80@cn.fujitsu.com>
Date: Thu, 9 Mar 2017 08:31:35 +0800
MIME-Version: 1.0
In-Reply-To: <4ccef095-36b7-3b1e-1baf-eec09562d52c@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/09/2017 02:26 AM, Anand Jain wrote:
>
>
>>> Introduce a new function, btrfs_check_rw_degradable(), to check if all
>>> chunks in btrfs is OK for degraded rw mount.
>>>
>>> It provides the new basis for accurate btrfs mount/remount and even
>>> runtime degraded mount check other than old one-size-fit-all method.
>
>   Sorry for late response. But this patch has a bug (calls free
>   with the lock held) and fixed in this patch [1].
>    [1]
>     [PATCH] btrfs: fix btrfs_check_degradable() to free extent map
>     https://patchwork.kernel.org/patch/8868761/

Thanks for the patch, while in v3, the memory leak is fixed.

However I still call free with read lock hold, I'll update it in v3.
>
>   the last version of this patch is here [2] and it did contain the
>   above fix [1] but it missed my sign-off and change commit log
>   update (sorry for that)
>     [2] http://www.spinics.net/lists/linux-btrfs/msg55038.html
>
>   Can you pls squash [1] to this patch.

I'll add you signed-off-by tag in next version too.

Thanks,
Qu
>
>   With that.
>
>>  Looks good.
>>  Reviewed-by: Anand Jain <anand.jain@oracle.com>
>
>  While you are here, can you also consider..
>
> -----
> @@ -6843,7 +6843,7 @@ bool btrfs_check_rw_degradable(struct
> btrfs_fs_info *fs_info,
>                 int max_tolerated;
>                 int i;
>
> -               map = (struct map_lookup *) em->bdev;
> +               map = em->map_lookup;
>                 max_tolerated =
>                         btrfs_get_num_tolerated_disk_barrier_failures(
>                                         map->type);
> ------
>
>
>   Thanks, Anand
>
>


