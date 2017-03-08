Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:51317 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753961AbdCHSZB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 13:25:01 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v28INNMu017254
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 8 Mar 2017 18:23:23 GMT
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH v2 1/6] btrfs: Introduce a function to check if all chunks
 a OK for degraded rw mount
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
 <20170306085855.11403-2-quwenruo@cn.fujitsu.com>
 <b698b207-bef6-4064-302d-784dda4dacd5@oracle.com>
Cc: linux-btrfs@vger.kernel.org, lists@colorremedies.com
Message-ID: <4ccef095-36b7-3b1e-1baf-eec09562d52c@oracle.com>
Date: Thu, 9 Mar 2017 02:26:51 +0800
MIME-Version: 1.0
In-Reply-To: <b698b207-bef6-4064-302d-784dda4dacd5@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> Introduce a new function, btrfs_check_rw_degradable(), to check if all
>> chunks in btrfs is OK for degraded rw mount.
>>
>> It provides the new basis for accurate btrfs mount/remount and even
>> runtime degraded mount check other than old one-size-fit-all method.

   Sorry for late response. But this patch has a bug (calls free
   with the lock held) and fixed in this patch [1].
    [1]
     [PATCH] btrfs: fix btrfs_check_degradable() to free extent map
     https://patchwork.kernel.org/patch/8868761/

   the last version of this patch is here [2] and it did contain the
   above fix [1] but it missed my sign-off and change commit log
   update (sorry for that)
     [2] http://www.spinics.net/lists/linux-btrfs/msg55038.html

   Can you pls squash [1] to this patch.

   With that.

>  Looks good.
>  Reviewed-by: Anand Jain <anand.jain@oracle.com>

  While you are here, can you also consider..

-----
@@ -6843,7 +6843,7 @@ bool btrfs_check_rw_degradable(struct 
btrfs_fs_info *fs_info,
                 int max_tolerated;
                 int i;

-               map = (struct map_lookup *) em->bdev;
+               map = em->map_lookup;
                 max_tolerated =
                         btrfs_get_num_tolerated_disk_barrier_failures(
                                         map->type);
------


   Thanks, Anand
