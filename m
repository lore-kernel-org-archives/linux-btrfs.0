Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46474 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaCKNvF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 09:51:05 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so5518992lbv.24
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 06:51:04 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1393555579-11271-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 13:51:04 +0000
Message-ID: <CAL3q7H75EvWcQ_OwqrD33y0venCOx3wPiW8XWDE=J898G5Hoew@mail.gmail.com>
Subject: Re: [PATCH v5 00/18] Replace btrfs_workers with kernel workqueue
 based btrfs_workqueue
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 28, 2014 at 2:46 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Add a new btrfs_workqueue_struct which use kernel workqueue to implement
> most of the original btrfs_workers, to replace btrfs_workers.
>
> With this patchset, redundant workqueue codes are replaced with kernel
> workqueue infrastructure, which not only reduces the code size but also the
> effort to maintain it.
>
> The result(somewhat outdated though) from sysbench shows minor improvement on the following server:
> CPU: two-way Xeon X5660
> RAM: 4G
> HDD: SAS HDD, 150G total, 100G partition for btrfs test
>
> Test result on default mount option:
> https://docs.google.com/spreadsheet/ccc?key=0AhpkL3ehzX3pdENjajJTWFg5d1BWbExnYWFpMTJxeUE&usp=sharing
>
> Test result on "-o compress" mount option:
> https://docs.google.com/spreadsheet/ccc?key=0AhpkL3ehzX3pdHdTTEJ6OW96SXJFaDR5enB1SzMzc0E&usp=sharing
>
> Changelog:
> v1->v2:
>   - Fix some workqueue flags.
> v2->v3:
>   - Add the thresholding mechanism to simulate the old behavior
>   - Convert all the btrfs_workers to btrfs_workrqueue_struct.
>   - Fix some potential deadlock when executed in IRQ handler.
> v3->v4:
>   - Change the ordered workqueue implement to fix the performance drop in 32K
>     multi thread random write.
>   - Change the high priority workqueue implement to get an independent high
>     workqueue without starving problem.
>   - Simplify the btrfs_alloc_workqueue parameters.
>   - Coding style cleanup.
>   - Remove the redundant "_struct" suffix.
> v4->v5:
>   - Fix a multithread free-and-use bug reported by Josef and David.
>
> Qu Wenruo (18):
>   btrfs: Cleanup the unused struct async_sched.
>   btrfs: Added btrfs_workqueue_struct implemented ordered execution
>     based on kernel workqueue
>   btrfs: Add high priority workqueue support for btrfs_workqueue_struct
>   btrfs: Add threshold workqueue based on kernel workqueue
>   btrfs: Replace fs_info->workers with btrfs_workqueue.
>   btrfs: Replace fs_info->delalloc_workers with btrfs_workqueue
>   btrfs: Replace fs_info->submit_workers with btrfs_workqueue.
>   btrfs: Replace fs_info->flush_workers with btrfs_workqueue.
>   btrfs: Replace fs_info->endio_* workqueue with btrfs_workqueue.
>   btrfs: Replace fs_info->rmw_workers workqueue with btrfs_workqueue.
>   btrfs: Replace fs_info->cache_workers workqueue with btrfs_workqueue.
>   btrfs: Replace fs_info->readahead_workers workqueue with
>     btrfs_workqueue.
>   btrfs: Replace fs_info->fixup_workers workqueue with btrfs_workqueue.
>   btrfs: Replace fs_info->delayed_workers workqueue with
>     btrfs_workqueue.
>   btrfs: Replace fs_info->qgroup_rescan_worker workqueue with
>     btrfs_workqueue.
>   btrfs: Replace fs_info->scrub_* workqueue with btrfs_workqueue.
>   btrfs: Cleanup the old btrfs_worker.
>   btrfs: Cleanup the "_struct" suffix in btrfs_workequeue
>
>  fs/btrfs/async-thread.c  | 830 ++++++++++++-----------------------------------
>  fs/btrfs/async-thread.h  | 119 ++-----
>  fs/btrfs/ctree.h         |  39 ++-
>  fs/btrfs/delayed-inode.c |   6 +-
>  fs/btrfs/disk-io.c       | 212 +++++-------
>  fs/btrfs/extent-tree.c   |   4 +-
>  fs/btrfs/inode.c         |  38 +--
>  fs/btrfs/ordered-data.c  |  11 +-
>  fs/btrfs/qgroup.c        |  15 +-
>  fs/btrfs/raid56.c        |  21 +-
>  fs/btrfs/reada.c         |   4 +-
>  fs/btrfs/scrub.c         |  70 ++--
>  fs/btrfs/super.c         |  36 +-
>  fs/btrfs/volumes.c       |  16 +-
>  14 files changed, 446 insertions(+), 975 deletions(-)
>
> --
> 1.9.0

Hi Qu,

On latest btrfs-next/master, which includes these patches, kmemleak is
reporting many leaks that seems related to the work queues.
I can reliably reproduce it by running the xfstests.

Dmesg:

[ 1308.359146] kmemleak: 1308 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)

Sample of kmemleak stack traces:

unreferenced object 0xffff8800d3f84408 (size 16):
comm "mount", pid 4214, jiffies 4294927007 (age 1198.824s)
hex dump (first 16 bytes):
30 4c 6b d4 00 88 ff ff 78 5e 6b d4 00 88 ff ff 0Lk.....x^k.....
backtrace:
[<ffffffff816e5b46>] kmemleak_alloc+0x26/0x50
[<ffffffff8118ec1d>] kmem_cache_alloc_trace+0x11d/0x1e0
[<ffffffffa029ce84>] btrfs_alloc_workqueue+0x44/0x2a0 [btrfs]
[<ffffffffa026ac15>] open_ctree+0xff5/0x20a0 [btrfs]
[<ffffffffa0240eac>] btrfs_mount+0x6ec/0x8d0 [btrfs]
[<ffffffff811a4d53>] mount_fs+0x43/0x1b0
[<ffffffff811c2403>] vfs_kern_mount+0x73/0x160
[<ffffffff811c4d49>] do_mount+0x259/0xb70
[<ffffffff811c594e>] SyS_mount+0x8e/0xe0
[<ffffffff81703212>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800d3f85830 (size 16):
comm "mount", pid 4214, jiffies 4294927008 (age 1198.820s)
hex dump (first 16 bytes):
58 16 0f f5 01 88 ff ff 00 00 00 00 00 00 00 00 X...............
backtrace:
[<ffffffff816e5b46>] kmemleak_alloc+0x26/0x50
[<ffffffff8118ec1d>] kmem_cache_alloc_trace+0x11d/0x1e0
[<ffffffffa029ce84>] btrfs_alloc_workqueue+0x44/0x2a0 [btrfs]
[<ffffffffa026ac35>] open_ctree+0x1015/0x20a0 [btrfs]
[<ffffffffa0240eac>] btrfs_mount+0x6ec/0x8d0 [btrfs]
[<ffffffff811a4d53>] mount_fs+0x43/0x1b0
[<ffffffff811c2403>] vfs_kern_mount+0x73/0x160
[<ffffffff811c4d49>] do_mount+0x259/0xb70
[<ffffffff811c594e>] SyS_mount+0x8e/0xe0
[<ffffffff81703212>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800d3f84560 (size 16):
comm "mount", pid 4214, jiffies 4294927008 (age 1198.820s)
hex dump (first 16 bytes):
00 40 93 fc 01 88 ff ff 00 00 00 00 00 00 00 00 .@..............
backtrace:
[<ffffffff816e5b46>] kmemleak_alloc+0x26/0x50
[<ffffffff8118ec1d>] kmem_cache_alloc_trace+0x11d/0x1e0
[<ffffffffa029ce84>] btrfs_alloc_workqueue+0x44/0x2a0 [btrfs]
[<ffffffffa026ac52>] open_ctree+0x1032/0x20a0 [btrfs]
[<ffffffffa0240eac>] btrfs_mount+0x6ec/0x8d0 [btrfs]
[<ffffffff811a4d53>] mount_fs+0x43/0x1b0
[<ffffffff811c2403>] vfs_kern_mount+0x73/0x160
[<ffffffff811c4d49>] do_mount+0x259/0xb70
[<ffffffff811c594e>] SyS_mount+0x8e/0xe0
[<ffffffff81703212>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800d3f856d8 (size 16):
comm "mount", pid 4214, jiffies 4294927008 (age 1198.820s)
hex dump (first 16 bytes):
f0 7c 93 fc 01 88 ff ff 00 00 00 00 00 00 00 00 .|..............
backtrace:
[<ffffffff816e5b46>] kmemleak_alloc+0x26/0x50
[<ffffffff8118ec1d>] kmem_cache_alloc_trace+0x11d/0x1e0
[<ffffffffa029ce84>] btrfs_alloc_workqueue+0x44/0x2a0 [btrfs]
[<ffffffffa026ac6f>] open_ctree+0x104f/0x20a0 [btrfs]
[<ffffffffa0240eac>] btrfs_mount+0x6ec/0x8d0 [btrfs]
[<ffffffff811a4d53>] mount_fs+0x43/0x1b0
[<ffffffff811c2403>] vfs_kern_mount+0x73/0x160
[<ffffffff811c4d49>] do_mount+0x259/0xb70
[<ffffffff811c594e>] SyS_mount+0x8e/0xe0
[<ffffffff81703212>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800d3f846b8 (size 16):

(....)

Can you confirm if it's related to any of these changes or something else?
Thanks.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
