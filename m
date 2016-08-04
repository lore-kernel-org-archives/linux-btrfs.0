Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33902 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756606AbcHDO3g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Aug 2016 10:29:36 -0400
Subject: Re: [4.8] btrfs heats my room with lock contention
To: Dave Chinner <david@fromorbit.com>, <linux-btrfs@vger.kernel.org>
References: <20160804064105.GT12670@dastard>
From: Chris Mason <clm@fb.com>
Message-ID: <da05a44e-22f3-bbbb-4757-3f04ad98d758@fb.com>
Date: Thu, 4 Aug 2016 10:28:44 -0400
MIME-Version: 1.0
In-Reply-To: <20160804064105.GT12670@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/04/2016 02:41 AM, Dave Chinner wrote:
>
> Simple test. 8GB pmem device on a 16p machine:
>
> # mkfs.btrfs /dev/pmem1
> # mount /dev/pmem1 /mnt/scratch
> # dbench -t 60 -D /mnt/scratch 16
>
> And heat your room with the warm air rising from your CPUs. Top
> half of the btrfs profile looks like:
>
>   36.71%  [kernel]  [k] _raw_spin_unlock_irqrestore                                                                                                                    ¿
>   32.29%  [kernel]  [k] native_queued_spin_lock_slowpath                                                                                                               ¿
>    5.14%  [kernel]  [k] queued_write_lock_slowpath                                                                                                                     ¿
>    2.46%  [kernel]  [k] _raw_spin_unlock_irq                                                                                                                           ¿
>    2.15%  [kernel]  [k] queued_read_lock_slowpath                                                                                                                      ¿
>    1.54%  [kernel]  [k] _find_next_bit.part.0                                                                                                                          ¿
>    1.06%  [kernel]  [k] __crc32c_le                                                                                                                                    ¿
>    0.82%  [kernel]  [k] btrfs_tree_lock                                                                                                                                ¿
>    0.79%  [kernel]  [k] steal_from_bitmap.part.29                                                                                                                      ¿
>    0.70%  [kernel]  [k] __copy_user_nocache                                                                                                                            ¿
>    0.69%  [kernel]  [k] btrfs_tree_read_lock                                                                                                                           ¿
>    0.69%  [kernel]  [k] delay_tsc                                                                                                                                      ¿
>    0.64%  [kernel]  [k] btrfs_set_lock_blocking_rw                                                                                                                     ¿
>    0.63%  [kernel]  [k] copy_user_generic_string                                                                                                                       ¿
>    0.51%  [kernel]  [k] do_raw_read_unlock                                                                                                                             ¿
>    0.48%  [kernel]  [k] do_raw_spin_lock                                                                                                                               ¿
>    0.47%  [kernel]  [k] do_raw_read_lock                                                                                                                               ¿
>    0.46%  [kernel]  [k] btrfs_clear_lock_blocking_rw                                                                                                                   ¿
>    0.44%  [kernel]  [k] do_raw_write_lock                                                                                                                              ¿
>    0.41%  [kernel]  [k] __do_softirq                                                                                                                                   ¿
>    0.28%  [kernel]  [k] __memcpy                                                                                                                                       ¿
>    0.24%  [kernel]  [k] map_private_extent_buffer                                                                                                                      ¿
>    0.23%  [kernel]  [k] find_next_zero_bit                                                                                                                             ¿
>    0.22%  [kernel]  [k] btrfs_tree_read_unlock                                                                                                                         ¿
>
> Performance vs CPu usage is:
>
> nprocs		throughput		cpu usage
> 1		440MB/s			 50%
> 2		770MB/s			100%
> 4		880MB/s			250%
> 8		690MB/s			450%
> 16		280MB/s			950%
>
> In comparision, at 8-16 threads ext4 is running at ~2600MB/s and
> XFS is running at ~3800MB/s. Even if I throw 300-400 processes at
> ext4 and XFS, they only drop to ~1500-2000MB/s as they hit internal
> limits.
>
Yes, with dbench btrfs does much much better if you make a subvol per 
dbench dir.  The difference is pretty dramatic.  I'm working on it this 
month, but focusing more on database workloads right now.

-chris

