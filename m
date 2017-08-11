Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36252 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752869AbdHKOng (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Aug 2017 10:43:36 -0400
Subject: Re: FAILED: patch "[PATCH] Btrfs: fix early ENOSPC due to delalloc"
 failed to apply to 4.12-stable tree
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>,
        <linux-btrfs@vger.kernel.org>
CC: <osandov@fb.com>
References: <15015495878144@kroah.com>
 <1501874946.5098.3.camel@christoph.anton.mitterer.name>
From: Chris Mason <clm@fb.com>
Message-ID: <b1952548-7899-c885-e410-1b2b9df314b3@fb.com>
Date: Fri, 11 Aug 2017 10:43:16 -0400
MIME-Version: 1.0
In-Reply-To: <1501874946.5098.3.camel@christoph.anton.mitterer.name>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/04/2017 03:29 PM, Christoph Anton Mitterer wrote:
> Hey.
> 
> Could someone of the devs put some attention on this...?
> 
> Thanks,
> Chris :-)

Done, you can also grab it here: 

https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git/commit/?h=for-stable-4.12&id=354850ad1948af13248031e5180d495044d05aa5

-chris

> 
> 
> On Mon, 2017-07-31 at 18:06 -0700, gregkh@linuxfoundation.org wrote:
>> The patch below does not apply to the 4.12-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git
>> commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>>  From 17024ad0a0fdfcfe53043afb969b813d3e020c21 Mon Sep 17 00:00:00
>> 2001
>> From: Omar Sandoval <osandov@fb.com>
>> Date: Thu, 20 Jul 2017 15:10:35 -0700
>> Subject: [PATCH] Btrfs: fix early ENOSPC due to delalloc
>>
>> If a lot of metadata is reserved for outstanding delayed allocations,
>> we
>> rely on shrink_delalloc() to reclaim metadata space in order to
>> fulfill
>> reservation tickets. However, shrink_delalloc() has a shortcut where
>> if
>> it determines that space can be overcommitted, it will stop early.
>> This
>> made sense before the ticketed enospc system, but now it means that
>> shrink_delalloc() will often not reclaim enough space to fulfill any
>> tickets, leading to an early ENOSPC. (Reservation tickets don't care
>> about being able to overcommit, they need every byte accounted for.)
>>
>> Fix it by getting rid of the shortcut so that shrink_delalloc()
>> reclaims
>> all of the metadata it is supposed to. This fixes early ENOSPCs we
>> were
>> seeing when doing a btrfs receive to populate a new filesystem, as
>> well
>> as early ENOSPCs Christoph saw when doing a big cp -r onto Btrfs.
>>
>> Fixes: 957780eb2788 ("Btrfs: introduce ticketed enospc
>> infrastructure")
>> Tested-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.na
>> me>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Josef Bacik <jbacik@fb.com>
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index a6635f07b8f1..e3b0b4196d3d 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4825,10 +4825,6 @@ static void shrink_delalloc(struct
>> btrfs_fs_info *fs_info, u64 to_reclaim,
>>   		else
>>   			flush = BTRFS_RESERVE_NO_FLUSH;
>>   		spin_lock(&space_info->lock);
>> -		if (can_overcommit(fs_info, space_info, orig, flush,
>> false)) {
>> -			spin_unlock(&space_info->lock);
>> -			break;
>> -		}
>>   		if (list_empty(&space_info->tickets) &&
>>   		    list_empty(&space_info->priority_tickets)) {
>>   			spin_unlock(&space_info->lock);
