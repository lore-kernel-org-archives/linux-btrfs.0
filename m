Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19138 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754651AbcK2ImB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 03:42:01 -0500
Subject: Re: Qgroup accounting issue on kdave/for-next branch
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <19009351.7ILlWBP2dy@localhost.localdomain>
 <50a6ef84-240d-b88b-e7c1-75f7af77a78e@cn.fujitsu.com>
 <2678465.HbM4Gyh5fr@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <dd0cae85-213b-db19-2d69-176707eb7d12@cn.fujitsu.com>
Date: Tue, 29 Nov 2016 16:41:41 +0800
MIME-Version: 1.0
In-Reply-To: <2678465.HbM4Gyh5fr@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/29/2016 04:21 PM, Chandan Rajendra wrote:
> On Tuesday, November 29, 2016 03:55:53 PM Qu Wenruo wrote:
>> At 11/29/2016 02:36 PM, Chandan Rajendra wrote:
>>> When executing btrfs/126 test on kdave/for-next branch on a ppc64 guest, I
>>> noticed the following call trace.
>>>
>>> [   77.335887] ------------[ cut here ]------------
>>> [   77.336115] WARNING: CPU: 0 PID: 8325 at /root/repos/linux/fs/btrfs/qgroup.c:2443 .btrfs_qgroup_free_refroot+0x188/0x220
>>> [   77.336303] Modules linked in:
>>> [   77.336393] CPU: 0 PID: 8325 Comm: umount Not tainted 4.9.0-rc5-00062-g6b74e43 #22
>>> [   77.336526] task: c00000062b8d4880 task.stack: c00000062b9a4000
>>> [   77.336638] NIP: c0000000005cf018 LR: c0000000005ceff8 CTR: c0000000005390c0
>>> [   77.336771] REGS: c00000062b9a7450 TRAP: 0700   Not tainted  (4.9.0-rc5-00062-g6b74e43)
>>> [   77.336908] MSR: 800000000282b032
>>> [   77.336960] <
>>> [   77.337027] SF
>>> [   77.337053] ,VEC
>>> [   77.337087] ,VSX
>>> [   77.337114] ,EE
>>> [   77.337146] ,FP
>>> [   77.337173] ,ME
>>> [   77.337207] ,IR
>>> [   77.337233] ,DR
>>> [   77.337267] ,RI
>>> [   77.337294] >
>>> [   77.337330]   CR: 88000842  XER: 00000000
>>> [   77.337392] CFAR: c0000000005c9b5c
>>> [   77.337443] SOFTE: 1
>>> [   77.337477]
>>>                GPR00:
>>> [   77.337517] c0000000005cefcc
>>> [   77.337575] c00000062b9a76d0
>>> [   77.337626] c000000001103a00
>>> [   77.337714] c00000063e058d40
>>> [   77.337765]
>>>                GPR04:
>>> [   77.337817] c00000062b9a7740
>>> [   77.337868] 0000000000000008
>>> [   77.337927] 000000000005f000
>>> [   77.337978] 000000063eed0000
>>> [   77.338037]
>>>                GPR08:
>>> [   77.338080] c00000062f9629c8
>>> [   77.338138] 0000000000000001
>>> [   77.338191] fffffffffffff000
>>> [   77.338248] c00000063e058e80
>>> [   77.338300]
>>>                GPR12:
>>> [   77.338384] 0000000000000000
>>> [   77.338435] c00000000fe00000
>>> [   77.338498] 0000000020000000
>>> [   77.338548] 0000000000000000
>>> [   77.338605]
>>>                GPR16:
>>> [   77.338645] 0000000000000008
>>> [   77.338703] 000000004d5906fc
>>> [   77.338754] 000000004d5a6c08
>>> [   77.338811] 000000004d54b3d0
>>> [   77.338866]
>>>                GPR20:
>>> [   77.338921] 000001000bcf8440
>>> [   77.338972] 0000000000000000
>>> [   77.339030] 0000000000000000
>>> [   77.339080] c00000062523b078
>>> [   77.339138]
>>>                GPR24:
>>> [   77.339178] c00000062523b080
>>> [   77.339240] c000000000da2b58
>>> [   77.339290] 0000000000000000
>>> [   77.339347] c00000062e539600
>>> [   77.339398]
>>>                GPR28:
>>> [   77.339485] 0000000000060000
>>> [   77.339536] c00000062523b000
>>> [   77.339594] c00000062e539600
>>> [   77.339644] c00000062e539688
>>>
>>> [   77.339740] NIP [c0000000005cf018] .btrfs_qgroup_free_refroot+0x188/0x220
>>> [   77.339852] LR [c0000000005ceff8] .btrfs_qgroup_free_refroot+0x168/0x220
>>> [   77.339959] Call Trace:
>>> [   77.339998] [c00000062b9a76d0] [c0000000005cefcc] .btrfs_qgroup_free_refroot+0x13c/0x220
>>> [   77.340123]  (unreliable)
>>> [   77.340193] [c00000062b9a7790] [c00000000054210c] .commit_fs_roots+0x19c/0x240
>>> [   77.340355] [c00000062b9a78a0] [c0000000005451a0] .btrfs_commit_transaction.part.5+0x480/0xbe0
>>> [   77.340554] [c00000062b9a7970] [c000000000503bd4] .btrfs_sync_fs+0x74/0x1c0
>>> [   77.340725] [c00000062b9a7a10] [c0000000002d6ce0] .sync_filesystem+0xd0/0x100
>>> [   77.340891] [c00000062b9a7a90] [c000000000294f88] .generic_shutdown_super+0x38/0x1a0
>>> [   77.341052] [c00000062b9a7b10] [c000000000295508] .kill_anon_super+0x18/0x30
>>> [   77.342243] [c00000062b9a7b90] [c000000000503db8] .btrfs_kill_super+0x18/0xd0
>>> [   77.342411] [c00000062b9a7c10] [c0000000002958c8] .deactivate_locked_super+0x98/0xe0
>>> [   77.342573] [c00000062b9a7c90] [c0000000002be114] .cleanup_mnt+0x54/0xa0
>>> [   77.342723] [c00000062b9a7d10] [c0000000000d7e74] .task_work_run+0x124/0x180
>>> [   77.342862] [c00000062b9a7db0] [c00000000001c354] .do_notify_resume+0xa4/0xb0
>>> [   77.343030] [c00000062b9a7e30] [c00000000000c344] .ret_from_except_lite+0x70/0x74
>>> [   77.343187] Instruction dump:
>>> [   77.343276] 3b400000 e87d0c78 38810070 4bffab1d 60000000 2c230000 4182ff40 e8dfffc8
>>> [   77.343522] eb630008 7d5c3010 7d294910 7d2900d0 <0b090000> 7fbc3040 41dd0070 f95fffc8
>>> [   77.343771] ---[ end trace 8130fb71377d4ff8 ]---
>>> [   77.343857] BTRFS warning (device loop1): qgroup 5 reserved space underflow, have: 389120, to free: 393216
>>> [   77.735193] BTRFS info (device loop1): disabling disk space caching
>>> [   77.736629] BTRFS info (device loop1): has skinny extents
>>>
>>>
>>> The above call trace happens because of the following:
>>>
>>>  |--------------------------------+-----------------------------------|
>>>  | Task A                         | Task B                            |
>>>  |--------------------------------+-----------------------------------|
>>>  | Write 4k bytes to a file       |                                   |
>>>  | at offset range [0, 4095]      |                                   |
>>>  | - __btrfs_buffered_write       |                                   |
>>>  | -- btrfs_check_data_free_space |                                   |
>>>  | --- Set EXTENT_QGROUP_RESERVED |                                   |
>>>  |     bit for range [0, 64k-1]   |                                   |
>>>  | -- Copy 4k data from userspace |                                   |
>>>  |    to page cache               |                                   |
>>>  |                                | Write 4k bytes to the file        |
>>>  |                                | at offset range [4096, 8191]      |
>>>  |                                | - __btrfs_buffered_write          |
>>>  |                                | -- btrfs_check_data_free_space    |
>>>  |                                | --- Since EXTENT_QGROUP_RESERVED  |
>>>  |                                | is already set we don't           |
>>>  |                                | reserve qgroup space              |
>>>  |                                | -- Assume the call to             |
>>>  |                                | btrfs_delalloc_reserve_metadata() |
>>>  |                                | fails                             |
>>>  |                                | -- btrfs_free_reserved_data_space |
>>>  |                                | --- Clear EXTENT_QGROUP_RESERVED  |
>>>  |                                |     file range [4096, 8191]       |
>>>  |--------------------------------+-----------------------------------|
>>
>> Task B part seems a little strange.
>>
>> For the lastest for-next branch, for-next-20161125, in
>> btrfs_delalloc_reserve_metadata(), it will roundup @start and @len.
>
> I was using for-next-20161118. But the problem is still reproducible on
> for-next-20161125. I guess, you meant to mention
> btrfs_free_reserved_data_space() instead of
> btrfs_delalloc_reserve_metadata().

My fault. And yes, I was meant to mention btrfs_free_reserved_data_space().
>>
>> So for btrfs_qgroup_free_data(), we will free the range of [0, 64k-1],
>> just like what we reserved in Task A.
>
> So with the new code, Instead of 4k, Task B frees 64k worth of qgroup space
> that it had *not* reserved.

For 64K page size, we only support 64K sectorsize. (Without your subpage 
size support patches)
And in that case, file extent will be 64K size, so we reserve 64K and 
free 64K, which is correct.

> The reservation was originally done by Task A. So
> when Task A's file extent item is being inserted, it will end up releasing 64k
> additional qgroup reservation.

You are right about the case.

If Tasl A's data isn't written into disk(buffered write), then Task B
doesn't need to reserve space, just reuse the space Task A reserved.

And in that case, you're completely right, in error path for Task B, the 
free will be deadly.

Two fix seems to be available:
1) Stop buffered write for the reserved space of Task A
    But since Task A succeeded in buffered write, it should assume the
    data will reach disk, and we will break the assumption.
2) Use accurate free_reserved range in error path
    I think it's possible to export the extent_changeset structure and
    use them to record what range we reserved, so we can free accurate
    amount of space.
    But the change may be a little large. Several interface needs to be
    changed.

If I misunderstood the problem again, please point it out in case I
missed something again.


BTW, does the 64K sectorsize of PPC64 makes metadata much easier to hit 
ENOSPC?

Thanks again for your detailed report,
Qu

>
> Executing "perf record -e btrfs:btrfs_qgroup_release_data -e
> btrfs:btrfs_qgroup_reserve_data -a -g ./check btrfs/126" gives the following,
>
> xfs_io  9536 [002]   454.601476: btrfs:btrfs_qgroup_reserve_data: (nil)U: root=5, ino=257, start=0, len=65536, reserved=65536, op=reserve
> xfs_io  9536 [002]   454.601522: btrfs:btrfs_qgroup_reserve_data: (nil)U: root=5, ino=257, start=0, len=65536, reserved=0, op=reserve
> xfs_io  9536 [002]   454.601530: btrfs:btrfs_qgroup_release_data: (nil)U: root=5, ino=257, start=0, len=65536, reserved=65536, op=free
> kthreadd  9171 [003]   454.704145: btrfs:btrfs_qgroup_release_data: (nil)U: root=5, ino=257, start=0, len=65536, reserved=0, op=release
>
> Please note that in the above perf ouput, Instead of two tasks, the same task
> writes two 4k blocks of data.
>


