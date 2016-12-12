Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0110.outbound.protection.outlook.com ([104.47.2.110]:61997
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753239AbcLLUum (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 15:50:42 -0500
Subject: Re: [PATCH] btrfs: limit async_work allocation and worker func
 duration
To: <dsterba@suse.cz>
References: <148072986343.13061.16191252239168261528.stgit@maxim-thinkpad>
 <20161212145443.GT12522@twin.jikos.cz>
CC: <clm@fb.com>, <jbacik@fb.com>, <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
From: Maxim Patlasov <mpatlasov@virtuozzo.com>
Message-ID: <2d4aaf16-b9b3-6cd9-d542-c74f00811c93@virtuozzo.com>
Date: Mon, 12 Dec 2016 12:35:51 -0800
MIME-Version: 1.0
In-Reply-To: <20161212145443.GT12522@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2016 06:54 AM, David Sterba wrote:

> On Fri, Dec 02, 2016 at 05:51:36PM -0800, Maxim Patlasov wrote:
>> Problem statement: unprivileged user who has read-write access to more than
>> one btrfs subvolume may easily consume all kernel memory (eventually
>> triggering oom-killer).
>>
>> Reproducer (./mkrmdir below essentially loops over mkdir/rmdir):
>>
>> [root@kteam1 ~]# cat prep.sh
>>
>> DEV=/dev/sdb
>> mkfs.btrfs -f $DEV
>> mount $DEV /mnt
>> for i in `seq 1 16`
>> do
>> 	mkdir /mnt/$i
>> 	btrfs subvolume create /mnt/SV_$i
>> 	ID=`btrfs subvolume list /mnt |grep "SV_$i$" |cut -d ' ' -f 2`
>> 	mount -t btrfs -o subvolid=$ID $DEV /mnt/$i
>> 	chmod a+rwx /mnt/$i
>> done
>>
>> [root@kteam1 ~]# sh prep.sh
>>
>> [maxim@kteam1 ~]$ for i in `seq 1 16`; do ./mkrmdir /mnt/$i 2000 2000 & done
>>
>> [root@kteam1 ~]# for i in `seq 1 4`; do grep "kmalloc-128" /proc/slabinfo | grep -v dma; sleep 60; done
>> kmalloc-128        10144  10144    128   32    1 : tunables    0    0    0 : slabdata    317    317      0
>> kmalloc-128       9992352 9992352    128   32    1 : tunables    0    0    0 : slabdata 312261 312261      0
>> kmalloc-128       24226752 24226752    128   32    1 : tunables    0    0    0 : slabdata 757086 757086      0
>> kmalloc-128       42754240 42754240    128   32    1 : tunables    0    0    0 : slabdata 1336070 1336070      0
>>
>> The huge numbers above come from insane number of async_work-s allocated
>> and queued by btrfs_wq_run_delayed_node.
>>
>> The problem is caused by btrfs_wq_run_delayed_node() queuing more and more
>> works if the number of delayed items is above BTRFS_DELAYED_BACKGROUND. The
>> worker func (btrfs_async_run_delayed_root) processes at least
>> BTRFS_DELAYED_BATCH items (if they are present in the list). So, the machinery
>> works as expected while the list is almost empty. As soon as it is getting
>> bigger, worker func starts to process more than one item at a time, it takes
>> longer, and the chances to have async_works queued more than needed is getting
>> higher.
>>
>> The problem above is worsened by another flaw of delayed-inode implementation:
>> if async_work was queued in a throttling branch (number of items >=
>> BTRFS_DELAYED_WRITEBACK), corresponding worker func won't quit until
>> the number of items < BTRFS_DELAYED_BACKGROUND / 2. So, it is possible that
>> the func occupies CPU infinitely (up to 30sec in my experiments): while the
>> func is trying to drain the list, the user activity may add more and more
>> items to the list.
> Nice analysis!
>
>> The patch fixes both problems in straightforward way: refuse queuing too
>> many works in btrfs_wq_run_delayed_node and bail out of worker func if
>> at least BTRFS_DELAYED_WRITEBACK items are processed.
>>
>> Signed-off-by: Maxim Patlasov <mpatlasov@virtuozzo.com>
>> ---
>>   fs/btrfs/async-thread.c  |    8 ++++++++
>>   fs/btrfs/async-thread.h  |    1 +
>>   fs/btrfs/delayed-inode.c |    6 ++++--
>>   3 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
>> index e0f071f..29f6252 100644
>> --- a/fs/btrfs/async-thread.c
>> +++ b/fs/btrfs/async-thread.c
>> @@ -86,6 +86,14 @@ btrfs_work_owner(struct btrfs_work *work)
>>   	return work->wq->fs_info;
>>   }
>>   
>> +bool btrfs_workqueue_normal_congested(struct btrfs_workqueue *wq)
>> +{
>> +	int thresh = wq->normal->thresh != NO_THRESHOLD ?
>> +		wq->normal->thresh : num_possible_cpus();
> Why not num_online_cpus? I vaguely remember we should be checking online
> cpus, but don't have the mails for reference. We use it elsewhere for
> spreading the work over cpus, but it's still not bullet proof regarding
> cpu onlining/offlining.

Thank you for review, David! I borrowed num_possible_cpus from the 
definition of WQ_UNBOUND_MAX_ACTIVE in workqueue.h, but if btrfs uses 
num_online_cpus elsewhere, it must be OK as well.

Another problem that I realized only now, is that nobody 
increments/decrements wq->normal->pending if thresh == NO_THRESHOLD, so 
the code looks pretty misleading: it looks as though assigning thresh to 
num_possible_cpus (or num_online_cpus) matters, but the next line 
compares it with "pending" that is always zero.

As far as we don't have any NO_THRESHOLD users of 
btrfs_workqueue_normal_congested for now, I tend to think it's better to 
add a descriptive comment and simply return "false" from 
btrfs_workqueue_normal_congested rather than trying to address some 
future needs now. See please v2 of the patch.

Thanks,
Maxim

>
> Otherwise looks good to me, as far as I can imagine the possible
> behaviour of the various async parameters just from reading the code.

