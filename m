Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58899 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaGaPHp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 11:07:45 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so2874981wgh.27
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 08:07:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFChkquw9YA8DeX43zBy9_V3UwNmAZiAHziFavGst5YwL9vMuQ@mail.gmail.com>
References: <CAFChkqszfFU51qkr1CSNgv0VKNhr8U_jEDv0_BPaZZghLzKojA@mail.gmail.com>
 <CAFChkquCzoJP6fussqdKB0rU8eDOz7=D=V8Pcugewdo1TgnmxQ@mail.gmail.com> <CAFChkquw9YA8DeX43zBy9_V3UwNmAZiAHziFavGst5YwL9vMuQ@mail.gmail.com>
From: Peter Waller <peter@scraperwiki.com>
Date: Thu, 31 Jul 2014 16:07:00 +0100
Message-ID: <CAFChkquYG02RQKDDvY03OHDsEUsas54D7mz6jRna+5MyuUc7oQ@mail.gmail.com>
Subject: Re: Machine lockup due to btrfs-transaction on AWS EC2 Ubuntu 14.04
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've now reproduced this on 3.15.7-031507-generic and
3.16.0-031600rc7-generic, and have a test case where I can reliably
cause the crash after about 30 seconds of disk activity.

The test case just involves taking a directory tree of ~400GB of files
and copying every file to a new one with .new on the end in the same
directory of the original.

The soft-lockup makes a kernel thread fully occupy a CPU. On the
advice of kdave from IRC I took a stack trace every 10s whilst the
machine remained responsive, which was for 5-10 minutes before the
machine became unresponsive to the network.

The lockup seems to be reliably stuck in btrfs_find_space_cluster.

kernel log with 10s traces is linked to below (3.16.0-031600rc7-generic)

https://gist.github.com/pwaller/d40df3badb5cc8a574ef

On 30 July 2014 11:02, Peter Waller <peter@scraperwiki.com> wrote:
> The crashes became more frequent. The time scale before lockup went
> ~12 days, ~7 days, ~2 days, ~6 hours, ~1 hour.
>
> Then we upgraded to 3.15.7-031507-generic on the advice of
> #ubuntu-kernel and #btrfs on IRC, and it has since been stable for
> 19.5 hours.
>
> I dug around more in our logs and realised that a previous machine
> lock was probably due to the same problem, so I have an additional
> stack trace, reproduced below.
>
> Thanks to those who chipped in on IRC.
>
> - Peter
>
>> [1093202.136107] INFO: task kworker/u30:1:31455 blocked for more than 120 seconds.
>> [1093202.141596]       Tainted: GF            3.13.0-30-generic #54-Ubuntu
>> [1093202.146201] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [1093202.152408] kworker/u30:1   D ffff8801efc34440     0 31455      2 0x00000000
>> [1093202.152416] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
>> [1093202.152419]  ffff880040d3b768 0000000000000002 ffff8800880f0000 ffff880040d3bfd8
>> [1093202.152422]  0000000000014440 0000000000014440 ffff8800880f0000 ffff8801efc34cd8
>> [1093202.152426]  ffff8801effcefe8 ffff880040d3b7f0 0000000000000002 ffffffff8114e010
>> [1093202.152429] Call Trace:
>> [1093202.152435]  [<ffffffff8114e010>] ? wait_on_page_read+0x60/0x60
>> [1093202.152439]  [<ffffffff8171ea6d>] io_schedule+0x9d/0x140
>> [1093202.152442]  [<ffffffff8114e01e>] sleep_on_page+0xe/0x20
>> [1093202.152445]  [<ffffffff8171eff8>] __wait_on_bit_lock+0x48/0xb0
>> [1093202.152449]  [<ffffffff8109df64>] ? vtime_common_task_switch+0x24/0x40
>> [1093202.152452]  [<ffffffff8114e12a>] __lock_page+0x6a/0x70
>> [1093202.152456]  [<ffffffff810aaee0>] ? autoremove_wake_function+0x40/0x40
>> [1093202.152474]  [<ffffffffa00e8a0d>] lock_delalloc_pages+0x13d/0x1d0 [btrfs]
>> [1093202.152487]  [<ffffffffa00eaf2b>] find_lock_delalloc_range.constprop.43+0x14b/0x1f0 [btrfs]
>> [1093202.152499]  [<ffffffffa00ebfa1>] __extent_writepage+0x131/0x750 [btrfs]
>> [1093202.152509]  [<ffffffffa00eb040>] ? end_extent_writepage+0x70/0x70 [btrfs]
>> [1093202.152521]  [<ffffffffa00ec832>] extent_write_cache_pages.isra.30.constprop.50+0x272/0x3d0 [btrfs]
>> [1093202.152532]  [<ffffffffa00edafd>] extent_writepages+0x4d/0x70 [btrfs]
>> [1093202.152544]  [<ffffffffa00d3b20>] ? btrfs_real_readdir+0x5b0/0x5b0 [btrfs]
>> [1093202.152555]  [<ffffffffa00d1cb8>] btrfs_writepages+0x28/0x30 [btrfs]
>> [1093202.152559]  [<ffffffff8115a46e>] do_writepages+0x1e/0x40
>> [1093202.152562]  [<ffffffff811e5c50>] __writeback_single_inode+0x40/0x210
>> [1093202.152565]  [<ffffffff811e6a07>] writeback_sb_inodes+0x247/0x3e0
>> [1093202.152568]  [<ffffffff811e6c3f>] __writeback_inodes_wb+0x9f/0xd0
>> [1093202.152571]  [<ffffffff811e6eb3>] wb_writeback+0x243/0x2c0
>> [1093202.152574]  [<ffffffff811e86d8>] bdi_writeback_workfn+0x108/0x430
>> [1093202.152577]  [<ffffffff810974a8>] ? finish_task_switch+0x128/0x170
>> [1093202.152581]  [<ffffffff810838a2>] process_one_work+0x182/0x450
>> [1093202.152585]  [<ffffffff81084641>] worker_thread+0x121/0x410
>> [1093202.152588]  [<ffffffff81084520>] ? rescuer_thread+0x3e0/0x3e0
>> [1093202.152591]  [<ffffffff8108b322>] kthread+0xd2/0xf0
>> [1093202.152594]  [<ffffffff8108b250>] ? kthread_create_on_node+0x1d0/0x1d0
>> [1093202.152598]  [<ffffffff8172ac3c>] ret_from_fork+0x7c/0xb0
>> [1093202.152601]  [<ffffffff8108b250>] ? kthread_create_on_node+0x1d0/0x1d0
>
> On 29 July 2014 10:20, Peter Waller <peter@scraperwiki.com> wrote:
>> Someone on IRC suggested that I clear the free cache:
>>
>>> sudo mount -o remount,clear_cache /path/to/dev /path/to/mount
>>> sudo mount -o remount,space_cache /path/to/dev /path/to/mount
>>
>>
>> The former command printed `btrfs: disk space caching is enabled` and
>> the latter repeated it, making me think that maybe the latter was
>> unnecessary.
>>
>> On 29 July 2014 09:04, Peter Waller <peter@scraperwiki.com> wrote:
>>> Hi All,
>>>
>>> I've reported a bug with Ubuntu here:
>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1349711
>>>
>>> The machine in question has one BTRFS volume which is 87% full and
>>> lives on an Logical Volume Manager (LVM) block device on top of one
>>> Amazon Elastic Block Store (EBS) device.
>>>
>>> We have other machines in a similar configuration which have not
>>> displayed this behaviour.
>>>
>>> The one thing which makes this machine different is that it has
>>> directories which contain many thousands of files. We don't make heavy
>>> use of subvolumes or snapshots.
>>>
>>> More details follow:
>>>
>>> # cat /proc/version_signature
>>> Ubuntu 3.13.0-32.57-generic 3.13.11.4
>>>
>>> The machine had a soft-lockup with messages like this appearing on the console:
>>>
>>> [246736.752053] INFO: rcu_sched self-detected stall on CPU { 0}
>>> (t=2220246 jiffies g=35399662 c=35399661 q=0)
>>> [246736.756059] INFO: rcu_sched detected stalls on CPUs/tasks: { 0}
>>> (detected by 1, t=2220247 jiffies, g=35399662, c=35399661, q=0)
>>> [246764.192014] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u30:2:1828]
>>> [246764.212058] BUG: soft lockup - CPU#1 stuck for 23s! [btrfs-transacti:492]
>>>
>>>
>>> After the first lockup and reboot, the following messages were in
>>> dmesg, which I ignored because after some research I saw that they
>>> were changed to warnings and considered non-harmful. A btrfs-scrub
>>> performed after this failed without error:
>>>
>>>
>>> [ 77.609490] BTRFS error (device dm-0): block group 10766778368 has
>>> wrong amount of free space
>>> [ 77.613678] BTRFS error (device dm-0): failed to load free space
>>> cache for block group 10766778368
>>> [ 77.643801] BTRFS error (device dm-0): block group 19356712960 has
>>> wrong amount of free space
>>> [ 77.648952] BTRFS error (device dm-0): failed to load free space
>>> cache for block group 19356712960
>>> [ 77.926325] BTRFS error (device dm-0): block group 20430454784 has
>>> wrong amount of free space
>>> [ 77.931078] BTRFS error (device dm-0): failed to load free space
>>> cache for block group 20430454784
>>> [ 78.111437] BTRFS error (device dm-0): block group 21504196608 has
>>> wrong amount of free space
>>> [ 78.116165] BTRFS error (device dm-0): failed to load free space
>>> cache for block group 21504196608
>>>
>>>
>>> After the second time I've observed the lockup and rebooted, these
>>> messages have appeared:
>>>
>>>
>>> [ 45.390221] BTRFS error (device dm-0): free space inode generation
>>> (0) did not match free space cache generation (70012)
>>> [ 45.413472] BTRFS error (device dm-0): free space inode generation
>>> (0) did not match free space cache generation (70012)
>>> [ 467.423961] BTRFS error (device dm-0): block group 518646661120 has
>>> wrong amount of free space
>>> [ 467.429251] BTRFS error (device dm-0): failed to load free space
>>> cache for block group 518646661120
>>>
>>>
>>> I would like to know if these second messages are harmful and if
>>> remedial action is needed in response to the latter messages.
>>> Searching for messages similar to my lockup I found this report which
>>> suggested the problem may be fixed in 3.14.
>>>
>>> Any advice appreciated,
>>>
>>> Thanks,
>>>
>>> - Peter
