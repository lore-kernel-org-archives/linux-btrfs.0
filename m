Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751083AbdGOGnV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jul 2017 02:43:21 -0400
Subject: Re: [PATCH] Btrfs: fix early ENOSPC due to delalloc
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>
Cc: kernel-team@fb.com
References: <0cf8577381f6ebe99b584ca60f920c630000c343.1499407060.git.osandov@fb.com>
 <20170714213645.GC13690@vader.DHCP.thefacebook.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1b7c8283-b585-27c4-6b95-12e889b3b96f@suse.com>
Date: Sat, 15 Jul 2017 09:43:18 +0300
MIME-Version: 1.0
In-Reply-To: <20170714213645.GC13690@vader.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.07.2017 00:36, Omar Sandoval wrote:
> On Thu, Jul 06, 2017 at 10:59:27PM -0700, Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> If a lot of metadata is reserved for outstanding delayed allocations, we
>> rely on shrink_delalloc() to reclaim metadata space in order to fulfill
>> reservation tickets. However, shrink_delalloc() has a shortcut where if
>> it determines that space can be overcommitted, it will stop early. This
>> made sense before the ticketed enospc system, but now it means that
>> shrink_delalloc() will often not reclaim enough space to fulfill any
>> tickets, leading to an early ENOSPC. (Reservation tickets don't care
>> about being able to overcommit, they need every byte accounted for.)
>>
>> Fix it by getting rid of the shortcut so that shrink_delalloc() reclaims
>> all of the metadata it is supposed to. This fixes early ENOSPCs we were
>> seeing when doing a btrfs receive to populate a new filesystem.
> 
> Jeff, Nikolay, did either of you get a chance to test this yet?

I tested this patch with generic/273 and it didn't prevent ENOSPC there.

> 
>> Signed-off-by: Omar Sandoval <osandov@fb.com>
>> ---
>> I don't have a good reproducer for this except for the btrfs send stream
>> I was given by someone internally, unfortunately.
>>
>>  fs/btrfs/extent-tree.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 33d979e9ea2a..83eecd33ad96 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4776,10 +4776,6 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
>>  		else
>>  			flush = BTRFS_RESERVE_NO_FLUSH;
>>  		spin_lock(&space_info->lock);
>> -		if (can_overcommit(root, space_info, orig, flush)) {
>> -			spin_unlock(&space_info->lock);
>> -			break;
>> -		}
>>  		if (list_empty(&space_info->tickets) &&
>>  		    list_empty(&space_info->priority_tickets)) {
>>  			spin_unlock(&space_info->lock);
>> -- 
>> 2.13.2
>>
> 
