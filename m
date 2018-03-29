Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeC2KSA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 06:18:00 -0400
Subject: Re: [PATCH v2 5/8] btrfs: check if the fsid in the primary sb and
 copy sb are same
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180327234000.23656-1-anand.jain@oracle.com>
 <20180327234000.23656-6-anand.jain@oracle.com>
 <d7679385-3a91-c089-06c8-d7a5d4d02260@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ab1ddeed-167a-3c55-bb4b-927b5e38eee9@oracle.com>
Date: Thu, 29 Mar 2018 18:18:32 +0800
MIME-Version: 1.0
In-Reply-To: <d7679385-3a91-c089-06c8-d7a5d4d02260@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





>> -	btrfs_release_disk_super(page);
>> ->  error_bdev_put:
> 
> You need a check whether page_primary is set here and release it,
> otherwise you are leaking it. This needs to handle both the primary sb
> read failure (where page_primary might not be set) as well as any FSID
> mismatch from loop. (where it will be set)> 

  Right. I should. Will do.

Thanks. Anand

>>   	blkdev_put(bdev, flags);
>>   
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
