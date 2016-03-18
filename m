Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.sr71.net ([198.145.64.142]:47067 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbcCRQds (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 12:33:48 -0400
Subject: Re: qgroup code slowing down rebalance
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
References: <56E9C7BB.7060509@sr71.net> <56EA0A0F.8070008@cn.fujitsu.com>
 <56EADD1E.3040202@sr71.net> <56EB5399.3060403@cn.fujitsu.com>
From: Dave Hansen <dave@sr71.net>
Message-ID: <56EC2DE6.2070006@sr71.net>
Date: Fri, 18 Mar 2016 09:33:42 -0700
MIME-Version: 1.0
In-Reply-To: <56EB5399.3060403@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/17/2016 06:02 PM, Qu Wenruo wrote:
> Dave Hansen wrote on 2016/03/17 09:36 -0700:
>> On 03/16/2016 06:36 PM, Qu Wenruo wrote:
>>> Dave Hansen wrote on 2016/03/16 13:53 -0700:
>>>> I have a medium-sized multi-device btrfs filesystem (4 disks, 16TB
>>>> total) running under 4.5.0-rc5.  I recently added a disk and needed to
>>>> rebalance.  I started a rebalance operation three days ago.  It was on
>>>> the order of 20% done after those three days. :)
>> ...
>> Data, RAID1: total=4.53TiB, used=4.53TiB
>> System, RAID1: total=32.00MiB, used=720.00KiB
>> Metadata, RAID1: total=17.00GiB, used=15.77GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Considering the size and the amount of metadata, even doing a quota
> rescan will be quite slowing.
> 
> Would you please try to do a quota rescan and see the CPU/IO usage?

I did a quota rescan.  It uses about 80% of one CPU core, but also has
some I/O wait time and pulls 1-20MB/s of data off the disk (the balance
with quotas on was completely CPU-bound, and had very low I/O rates).

It would seem that the "quota rescan" *does* have the same issue as the
balance with quotas on, but to a much smaller extent than what I saw
with the "balance" operation.

I have a full profile recorded from the "quota rescan", but the most
relevant parts are pasted below.  Basically btrfs_search_slot() and
radix tree lookups are eating all the CPU time, but they're still doing
enough I/O to see _some_ idle time on the processor.

>     74.55%     3.10%  kworker/u8:0     [btrfs]                      [k] find_parent_nodes                       
>                |
>                ---find_parent_nodes
>                   |          
>                   |--99.95%-- __btrfs_find_all_roots
>                   |          btrfs_find_all_roots
>                   |          btrfs_qgroup_rescan_worker
>                   |          normal_work_helper
>                   |          btrfs_qgroup_rescan_helper
>                   |          process_one_work
>                   |          worker_thread
>                   |          kthread
>                   |          ret_from_fork
>                    --0.05%-- [...]
> 
>     32.14%     4.16%  kworker/u8:0     [btrfs]                      [k] btrfs_search_slot                       
>                |
>                ---btrfs_search_slot
>                   |          
>                   |--87.90%-- find_parent_nodes
>                   |          __btrfs_find_all_roots
>                   |          btrfs_find_all_roots
>                   |          btrfs_qgroup_rescan_worker
>                   |          normal_work_helper
>                   |          btrfs_qgroup_rescan_helper
>                   |          process_one_work
>                   |          worker_thread
>                   |          kthread
>                   |          ret_from_fork
>                   |          
>                   |--11.70%-- btrfs_search_old_slot
>                   |          __resolve_indirect_refs
>                   |          find_parent_nodes
>                   |          __btrfs_find_all_roots
>                   |          btrfs_find_all_roots
>                   |          btrfs_qgroup_rescan_worker
>                   |          normal_work_helper
>                   |          btrfs_qgroup_rescan_helper
>                   |          process_one_work
>                   |          worker_thread
>                   |          kthread
>                   |          ret_from_fork
>                    --0.39%-- [...]
> 



