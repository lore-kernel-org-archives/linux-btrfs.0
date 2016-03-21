Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32366 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384AbcCUBog (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 21:44:36 -0400
Subject: Re: qgroup code slowing down rebalance
To: Dave Hansen <dave@sr71.net>, <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
References: <56E9C7BB.7060509@sr71.net> <56EA0A0F.8070008@cn.fujitsu.com>
 <56EADD1E.3040202@sr71.net> <56EB5399.3060403@cn.fujitsu.com>
 <56EC2DE6.2070006@sr71.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56EF51F9.8030505@cn.fujitsu.com>
Date: Mon, 21 Mar 2016 09:44:25 +0800
MIME-Version: 1.0
In-Reply-To: <56EC2DE6.2070006@sr71.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dave Hansen wrote on 2016/03/18 09:33 -0700:
> On 03/17/2016 06:02 PM, Qu Wenruo wrote:
>> Dave Hansen wrote on 2016/03/17 09:36 -0700:
>>> On 03/16/2016 06:36 PM, Qu Wenruo wrote:
>>>> Dave Hansen wrote on 2016/03/16 13:53 -0700:
>>>>> I have a medium-sized multi-device btrfs filesystem (4 disks, 16TB
>>>>> total) running under 4.5.0-rc5.  I recently added a disk and needed to
>>>>> rebalance.  I started a rebalance operation three days ago.  It was on
>>>>> the order of 20% done after those three days. :)
>>> ...
>>> Data, RAID1: total=4.53TiB, used=4.53TiB
>>> System, RAID1: total=32.00MiB, used=720.00KiB
>>> Metadata, RAID1: total=17.00GiB, used=15.77GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>> Considering the size and the amount of metadata, even doing a quota
>> rescan will be quite slowing.
>>
>> Would you please try to do a quota rescan and see the CPU/IO usage?
>
> I did a quota rescan.  It uses about 80% of one CPU core, but also has
> some I/O wait time and pulls 1-20MB/s of data off the disk (the balance
> with quotas on was completely CPU-bound, and had very low I/O rates).
>
> It would seem that the "quota rescan" *does* have the same issue as the
> balance with quotas on, but to a much smaller extent than what I saw
> with the "balance" operation.

This is quite expected. Most CPU would be consumed by find_all_roots(), 
as your subvolume layout is the just the worst case for find_all_roots().

That's to say, remove unneeded snapshots and keep them under a limited 
amount would be the best case.
Btrfs snapshot is superfast to create, but the design implies a lot of 
overhead for some minor operation, especially for backref lookup.
And unfortunately, quota relies heavily on it.


The only difference that I doesn't expect is IO. As I expected rescan 
would be much the same with balance, with little IO.
Did you run rescan/balance after dropping all the caches?


Although for balance, I would add some patch to make them by-pass quota 
accounting as them seems to be OK.
But for rescan case, AFAIK that's the case.


BTW although it's quite risky, I hope you can run some old kernels and 
see the performance difference of rescan and balance.
For old kernels, I mean 4.1 which is the latest kernel that doesn't use 
the new quota framework.

I'm very interesting to see if the old but wrong code would have a 
better or worse performance on balance or rescan.

Thank you very much for all this quota related reports.
Qu


>
> I have a full profile recorded from the "quota rescan", but the most
> relevant parts are pasted below.  Basically btrfs_search_slot() and
> radix tree lookups are eating all the CPU time, but they're still doing
> enough I/O to see _some_ idle time on the processor.
>
>>      74.55%     3.10%  kworker/u8:0     [btrfs]                      [k] find_parent_nodes
>>                 |
>>                 ---find_parent_nodes
>>                    |
>>                    |--99.95%-- __btrfs_find_all_roots
>>                    |          btrfs_find_all_roots
>>                    |          btrfs_qgroup_rescan_worker
>>                    |          normal_work_helper
>>                    |          btrfs_qgroup_rescan_helper
>>                    |          process_one_work
>>                    |          worker_thread
>>                    |          kthread
>>                    |          ret_from_fork
>>                     --0.05%-- [...]
>>
>>      32.14%     4.16%  kworker/u8:0     [btrfs]                      [k] btrfs_search_slot
>>                 |
>>                 ---btrfs_search_slot
>>                    |
>>                    |--87.90%-- find_parent_nodes
>>                    |          __btrfs_find_all_roots
>>                    |          btrfs_find_all_roots
>>                    |          btrfs_qgroup_rescan_worker
>>                    |          normal_work_helper
>>                    |          btrfs_qgroup_rescan_helper
>>                    |          process_one_work
>>                    |          worker_thread
>>                    |          kthread
>>                    |          ret_from_fork
>>                    |
>>                    |--11.70%-- btrfs_search_old_slot
>>                    |          __resolve_indirect_refs
>>                    |          find_parent_nodes
>>                    |          __btrfs_find_all_roots
>>                    |          btrfs_find_all_roots
>>                    |          btrfs_qgroup_rescan_worker
>>                    |          normal_work_helper
>>                    |          btrfs_qgroup_rescan_helper
>>                    |          process_one_work
>>                    |          worker_thread
>>                    |          kthread
>>                    |          ret_from_fork
>>                     --0.39%-- [...]
>>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


