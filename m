Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38748 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdIER2o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 13:28:44 -0400
Date: Tue, 5 Sep 2017 10:27:18 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Workqueue: events_unbound btrfs_async_reclaim_metadata_space
 [btrfs]
Message-ID: <20170905162718.GC14677@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <737e0bff-dad1-d779-4de8-46f8995d5f42@prismatelecomtesting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <737e0bff-dad1-d779-4de8-46f8995d5f42@prismatelecomtesting.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 05, 2017 at 11:47:26AM +0200, Marco Lorenzo Crociani wrote:
> Hi,
> I was transferring some data with rsync to a btrfs filesystem when I got:
> 
> set 04 14:59:05  kernel: INFO: task kworker/u33:2:25015 blocked for more
> than 120 seconds.
> set 04 14:59:05  kernel:       Not tainted 4.12.10-1.el7.elrepo.x86_64 #1
> set 04 14:59:05  kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> set 04 14:59:05  kernel: kworker/u33:2   D    0 25015      2 0x00000080
> set 04 14:59:05  kernel: Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> set 04 14:59:05  kernel: Call Trace:
> set 04 14:59:05  kernel:  __schedule+0x28a/0x880
> set 04 14:59:05  kernel:  schedule+0x36/0x80
> set 04 14:59:05  kernel:  wb_wait_for_completion+0x64/0x90
> set 04 14:59:05  kernel:  ? remove_wait_queue+0x60/0x60
> set 04 14:59:05  kernel:  __writeback_inodes_sb_nr+0x8e/0xb0
> set 04 14:59:05  kernel:  writeback_inodes_sb_nr+0x10/0x20
> set 04 14:59:05  kernel:  flush_space+0x469/0x580 [btrfs]
> set 04 14:59:05  kernel:  ? dequeue_task_fair+0x577/0x830
> set 04 14:59:05  kernel:  ? pick_next_task_fair+0x122/0x550
> set 04 14:59:05  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
> [btrfs]
> set 04 14:59:05  kernel:  process_one_work+0x149/0x360
> set 04 14:59:05  kernel:  worker_thread+0x4d/0x3c0
> set 04 14:59:05  kernel:  kthread+0x109/0x140
> set 04 14:59:05  kernel:  ? rescuer_thread+0x380/0x380
> set 04 14:59:05  kernel:  ? kthread_park+0x60/0x60
> set 04 14:59:05  kernel:  ? do_syscall_64+0x67/0x150
> set 04 14:59:05  kernel:  ret_from_fork+0x25/0x30
> 
> btrfs fi df /data
> Data, single: total=20.63TiB, used=20.63TiB
> System, DUP: total=8.00MiB, used=2.20MiB
> Metadata, DUP: total=41.50GiB, used=40.61GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> btrfs fi show /dev/sdo
> Label: 'Storage'  uuid: 429e42f4-dd9e-4267-b353-aa0831812f87
> 	Total devices 1 FS bytes used 20.67TiB
> 	devid    1 size 36.38TiB used 20.71TiB path /dev/sdo
> 
> Is it serious? Can I provide other info?
>

I think we're still cool here, the stack shows that btrfs is trying to
gain metadata space by flushing dirty pages via writeback threads, and
perhaps there're too much to flush to get enough metadata.


Thanks,

-liubo
