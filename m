Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49214 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbeHPFvP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 01:51:15 -0400
Subject: Re: [PATCH v2 0/3] Misc volume patch set part2
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180810055321.19730-1-anand.jain@oracle.com>
 <20180815122051.GL24025@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <71234053-a677-be3c-f7b3-0418f39e0601@oracle.com>
Date: Thu, 16 Aug 2018 10:59:41 +0800
MIME-Version: 1.0
In-Reply-To: <20180815122051.GL24025@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/15/2018 08:20 PM, David Sterba wrote:
> On Fri, Aug 10, 2018 at 01:53:18PM +0800, Anand Jain wrote:
>> The patch set (2/3 and 3/3) adds helper function to deduce the num_device
>> (which is the number of the devices when device is mounted, this excludes
>> the seed device however includes the replacing target). We need to know
>> the num_device that actually belongs to the FSID without the replacing
>> target (if it exists) when we are balancing and or when we are trying to
>> device delete. In both of these cases, it would be wrong to consider
>> replacing target when reallocating the blockgroups.
>>
>> This patch as such does not change any of the logic which is already in
>> the original code, but instead it would bring such a logic at two
>> locations into a single place/function. But to do that as these two
>> location uses either WARN_ON or BUG_ON to perform the safety catch so
>> the first patch does the cleanup and uses ASSERT at both of these
>> places. And now since these two sections of codes are identical, the 2nd
>> patch replaces them into a helper function.
>>
>> Also though the check for num_device > 0 should actually be num_device >
>> 1 OR instead, the check of num_device > 0 should have been after the
>> num_device--,
> 
> I updated the patch following that logic now.

  Right thanks.

>> since we have had already too many comments and added
>> confusions, I shall leave that part to be fixed at sometime later. So
>> that the cleanup here is a really a cleanup instead of chaning the
>> logic in a rough scale.
>>
>> Last but not least, this patch has gone through a lot of comments on
>> either to use BUG or return -EINVAL for accidental fall of num_device
>> below 1, which I wasn't expecting so much of the concerns about
>> the use of BUG_ON/-EINVAL as its trivial because fundamentally a FS
>> can't be in the mounted state when num_device < 1.
>>
>>
>> Anand Jain (3):
>>    btrfs: drop uuid_mutex in btrfs_free_extra_devids()
>>    btrfs: assert for num_devices below 0
>>    btrfs: add helper btrfs_num_devices() to deduce num_devices
> 
> Patches 2 and 3 are applied, with some adjustments.

  Adjustments at [1] are correct.

  [1]
   gitlab.com/kdave/btrfs-devel.git misc-next

Thanks, Anand.

> The first patch
> needs another round of review as there were many changes regarding the
> device locking and uuid_mutex. I need a break from this code as the
> wounds haven't healed yet, but will add the patch to a topic branch to
> next so I don't forget about it.
