Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22315 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757170AbdJKHli (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 03:41:38 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9B7fb31011445
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 07:41:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9B7fbJE029514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 07:41:37 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9B7fb9e001431
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 07:41:37 GMT
Subject: Re: [PATCH] Btrfs: remove rcu_barrier in btrfs_close_devices
From: Anand Jain <anand.jain@oracle.com>
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171010215103.20828-1-bo.li.liu@oracle.com>
 <ad0d4003-ef66-1da7-a27f-03837d839c11@oracle.com>
Message-ID: <82a3be82-f2a9-d0bd-b34c-71f98df0e571@oracle.com>
Date: Wed, 11 Oct 2017 15:41:23 +0800
MIME-Version: 1.0
In-Reply-To: <ad0d4003-ef66-1da7-a27f-03837d839c11@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/11/2017 02:11 PM, Anand Jain wrote:
> 
> 
> On 10/11/2017 05:51 AM, Liu Bo wrote:
>> It was introduced because btrfs used to do blkdev_put in a deferred
>> work, now that btrfs has put blkdev in place, this rcu_barrier can be
>> removed.

  On the 2nd thought, modprobe -r btrfs would still need rcu_barrier(), 
some where else outside of umount context ?

Thanks, Anand


>   Reviewed-by: Anand Jain <anand.jain@oracle.com>
> 
> Thanks, Anand
> 
> 
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 6 ------
>>   1 file changed, 6 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 0e8f16c..d983cea 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -958,12 +958,6 @@ int btrfs_close_devices(struct btrfs_fs_devices 
>> *fs_devices)
>>           __btrfs_close_devices(fs_devices);
>>           free_fs_devices(fs_devices);
>>       }
>> -    /*
>> -     * Wait for rcu kworkers under __btrfs_close_devices
>> -     * to finish all blkdev_puts so device is really
>> -     * free when umount is done.
>> -     */
>> -    rcu_barrier();
>>       return ret;
>>   }
>>
