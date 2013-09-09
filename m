Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:33232 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3IIJFV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2013 05:05:21 -0400
Message-ID: <522D8F7D.3020803@giantdisaster.de>
Date: Mon, 09 Sep 2013 11:06:05 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allocate the free space by the existed max extent
 size when ENOSPC
References: <1377858934-17187-1-git-send-email-miaox@cn.fujitsu.com> <5229DCDC.9080901@giantdisaster.de> <522D6906.5040404@cn.fujitsu.com>
In-Reply-To: <522D6906.5040404@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2013 08:21, Miao Xie wrote:
> On fri, 06 Sep 2013 15:47:08 +0200, Stefan Behrens wrote:
>> On Fri, 30 Aug 2013 18:35:34 +0800, Miao Xie wrote:
>>> By the current code, if the requested size is very large, and all the extents
>>> in the free space cache are small, we will waste lots of the cpu time to cut
>>> the requested size in half and search the cache again and again until it gets
>>> down to the size the allocator can return. In fact, we can know the max extent
>>> size in the cache after the first search, so we needn't cut the size in half
>>> repeatedly, and just use the max extent size directly. This way can save
>>> lots of cpu time and make the performance grow up when there are only fragments
>>> in the free space cache.
>>>
>>> According to my test, if there are only 4KB free space extents in the fs,
>>> and the total size of those extents are 256MB, we can reduce the execute
>>> time of the following test from 5.4s to 1.4s.
>>>    dd if=/dev/zero of=<testfile> bs=1MB count=1 oflag=sync
>>>
>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>> ---
>>> Changelog v1 -> v2:
>>> - address the problem that we return a wrong start position when searching
>>>    the free space in a bitmap.
>>> ---
>>>   fs/btrfs/extent-tree.c      | 29 ++++++++++++++-------
>>>   fs/btrfs/free-space-cache.c | 62 +++++++++++++++++++++++++++++++--------------
>>>   fs/btrfs/free-space-cache.h |  5 ++--
>>>   3 files changed, 66 insertions(+), 30 deletions(-)
>>
>> This patch makes the xfstest generic/256 lock up. It's quite reliably reproducible on one of my test boxes, and not at all visible on a second test box.
>>
>> And yes, I'm using the V2 patch although you haven't tagged it as V2 in the subject line of the mail :)
>
> According to my debug, the machine was not locked up, it seems the patch makes the test run very slow(90s ->850s on my machine).

With v2, the xfstest generic/256 was still running after 2 1/2 days with 
the 'echo w > /proc/sysrq-trigger' output as reported.


> Could you try the v3 patch?

With v3, generic/256 always finishes after 26 seconds. The issue is 
fixed with v3.


>>
>> # reboot
>> ... reboot done
>> # cd ~/git/xfs/cmds/xfstests
>> # export TEST_DEV=/dev/sdc1
>> # export TEST_DIR=/mnt2
>> # export SCRATCH_DEV=/dev/sdd1
>> # export SCRATCH_MNT=/mnt3
>> # umount $TEST_DIR $SCRATCH_MNT
>> # mkfs.btrfs -f $TEST_DEV
>> # mkfs.btrfs -f $SCRATCH_DEV
>> # ./check generic/256
>> ...should be finished after 20s, but it isn't, therefore after 180s:
>> # echo w > /proc/sysrq-trigger
>> root: run xfstest generic/256
>> SysRq : Show Blocked State
>>    task                        PC stack   pid father
>> btrfs-flush_del D 000000001a6d0000  6240 31190      2 0x00000000
>>   ffff880804dbfcb8 0000000000000086 ffff880804dbffd8 ffff8807ef218000
>>   ffff880804dbffd8 ffff880804dbffd8 ffff88080ad44520 ffff8807ef218000
>>   ffff880804dbfc98 ffff880784d3ca50 ffff880784d3ca18 ffff880804dbfce8
>> Call Trace:
>>   [<ffffffff81995da4>] schedule+0x24/0x60
>>   [<ffffffffa05235c5>] btrfs_start_ordered_extent+0x85/0x130 [btrfs]
>>   [<ffffffff810ac170>] ? wake_up_bit+0x40/0x40
>>   [<ffffffffa0523694>] btrfs_run_ordered_extent_work+0x24/0x40 [btrfs]
>>   [<ffffffffa0539d5f>] worker_loop+0x13f/0x5b0 [btrfs]
>>   [<ffffffff810b5ba3>] ? finish_task_switch+0x43/0x110
>>   [<ffffffff81995880>] ? __schedule+0x3f0/0x860
>>   [<ffffffffa0539c20>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
>>   [<ffffffff810abd36>] kthread+0xd6/0xe0
>>   [<ffffffff810e61ed>] ? trace_hardirqs_on+0xd/0x10
>>   [<ffffffff810abc60>] ? kthread_create_on_node+0x130/0x130
>>   [<ffffffff8199f66c>] ret_from_fork+0x7c/0xb0
>>   [<ffffffff810abc60>] ? kthread_create_on_node+0x130/0x130
>> xfs_io          D ffff880784d3cbc0  5008 31241  31240 0x00000000
>>   ffff8808036f3868 0000000000000082 ffff8808036f3fd8 ffff8807c9878000
>>   ffff8808036f3fd8 ffff8808036f3fd8 ffffffff82010440 ffff8807c9878000
>>   ffff8808036f3848 ffff880784d3cb18 ffff880784d3cb20 7fffffffffffffff
>> Call Trace:
>>   [<ffffffff81995da4>] schedule+0x24/0x60
>>   [<ffffffff81992dc4>] schedule_timeout+0x194/0x260
>>   [<ffffffff8199513a>] ? wait_for_completion+0x3a/0x110
>>   [<ffffffff8199513a>] ? wait_for_completion+0x3a/0x110
>>   [<ffffffff810e61ed>] ? trace_hardirqs_on+0xd/0x10
>>   [<ffffffff819951cf>] wait_for_completion+0xcf/0x110
>>   [<ffffffff810bb650>] ? try_to_wake_up+0x310/0x310
>>   [<ffffffffa0523b7a>] btrfs_wait_ordered_extents+0x1ea/0x260 [btrfs]
>>   [<ffffffffa0523ce5>] btrfs_wait_all_ordered_extents+0xf5/0x150 [btrfs]
>>   [<ffffffffa04f4b8d>] reserve_metadata_bytes+0x7bd/0xa30 [btrfs]
>>   [<ffffffffa04f516d>] btrfs_delalloc_reserve_metadata+0x16d/0x460 [btrfs]
>>   [<ffffffffa051dad6>] __btrfs_buffered_write+0x276/0x4f0 [btrfs]
>>   [<ffffffffa051df1a>] btrfs_file_aio_write+0x1ca/0x5a0 [btrfs]
>>   [<ffffffff8119a6db>] do_sync_write+0x7b/0xb0
>>   [<ffffffff8119b463>] vfs_write+0xc3/0x1e0
>>   [<ffffffff8119bad2>] SyS_pwrite64+0x92/0xb0
>>   [<ffffffff8199f712>] system_call_fastpath+0x16/0x1b
>>
>> (gdb) list *(btrfs_start_ordered_extent+0x85)
>> 0x4a545 is in btrfs_start_ordered_extent (fs/btrfs/ordered-data.c:747).
>> 742              * for the flusher thread to find them
>> 743              */
>> 744             if (!test_bit(BTRFS_ORDERED_DIRECT, &entry->flags))
>> 745                     filemap_fdatawrite_range(inode->i_mapping, start, end);
>> 746             if (wait) {
>> 747                     wait_event(entry->wait, test_bit(BTRFS_ORDERED_COMPLETE,
>> 748                                                      &entry->flags));
>> 749             }
>> 750     }
>> 751
>>
>> (gdb) list *(btrfs_wait_ordered_extents+0x1ea)
>> 0x4aafa is in btrfs_wait_ordered_extents (fs/btrfs/ordered-data.c:610).
>> 605             list_for_each_entry_safe(ordered, next, &works, work_list) {
>> 606                     list_del_init(&ordered->work_list);
>> 607                     wait_for_completion(&ordered->completion);
>> 608
>> 609                     inode = ordered->inode;
>> 610                     btrfs_put_ordered_extent(ordered);
>> 611                     if (delay_iput)
>> 612                             btrfs_add_delayed_iput(inode);
>> 613                     else
>> 614                             iput(inode);
>>
>> # cat /proc/mounts | grep /mnt
>> /dev/sdc1 /mnt2 btrfs rw,relatime,ssd,space_cache 0 0
>> /dev/sdd1 /mnt3 btrfs rw,relatime,ssd,space_cache 0 0
>>
>> # btrfs fi show
>> Label: none  uuid: 3dbe59c8-f4a0-4014-85f6-a6e9f5707c3a
>>          Total devices 1 FS bytes used 1.44GiB
>>          devid    1 size 1.50GiB used 1.50GiB path /dev/sdd1
>>
>> Label: none  uuid: 60130e96-5fb6-4355-b81e-8113c6f5c517
>>          Total devices 1 FS bytes used 32.00KiB
>>          devid    1 size 20.00GiB used 20.00MiB path /dev/sdc1
>>
>> All partitions have a size of 20971520 blocks according to fdisk:
>>     Device Boot      Start         End      Blocks   Id  System
>> /dev/sdc1            2048    41945087    20971520   83  Linux
>>
>>
>> With the currently pushed btrfs-next and the latest xfstests.
>>


