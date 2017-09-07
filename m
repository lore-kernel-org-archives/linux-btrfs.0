Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:38400 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755153AbdIGMEk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 08:04:40 -0400
Received: by mail-lf0-f49.google.com with SMTP id q132so23968892lfe.5
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Sep 2017 05:04:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <315fef6d-e60a-3155-e10c-bebdf21cb55a@prismatelecomtesting.com>
References: <737e0bff-dad1-d779-4de8-46f8995d5f42@prismatelecomtesting.com>
 <20170905162718.GC14677@dhcp-10-211-47-181.usdhcp.oraclecorp.com> <315fef6d-e60a-3155-e10c-bebdf21cb55a@prismatelecomtesting.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Thu, 7 Sep 2017 14:04:37 +0200
Message-ID: <CAEtw4r0By7Gmdo6=yFKi2t6LyKHAOygKdMW-+2OUkQ041zWZ7Q@mail.gmail.com>
Subject: Re: Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
To: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Cc: bo.li.liu@oracle.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You can check the usage of each block group with the following
scripts. If there are many blockgroups with low usage you should run
btrfs balance -musage=<percent> -dusage=<percent> /data

cd /tmp
wget https://raw.githubusercontent.com/kdave/btrfs-progs/master/btrfs-debugfs
chmod +x btrfs-debugfs
stats=$(sudo ./btrfs-debugfs -b /)

echo "00-49: " $(echo "$stats" | grep "usage 0.[0-4]" -c)
echo "50-79: " $(echo "$stats" | grep "usage 0.[5-7]" -c)
echo "80-89: " $(echo "$stats" | grep "usage 0.8" -c)
echo "90-99: " $(echo "$stats" | grep "usage 0.9" -c)
echo "100:   " $(echo "$stats" | grep "usage 1." -c)

The btrfs-debugfs script is from the btrfs progs source and report the
usage of each block group. The following script groups the result.

This script should take less than a few minutes to complete.

I qick script that could free some space:

btrfs balance start -musage=0 /data
btrfs balance start -dusage=10 /data
btrfs balance start -musage=50 /data
btrfs balance start -musage=70 /data

2017-09-07 13:17 GMT+02:00 Marco Lorenzo Crociani
<marcoc@prismatelecomtesting.com>:
> On 05/09/2017 18:27, Liu Bo wrote:
>>
>> On Tue, Sep 05, 2017 at 11:47:26AM +0200, Marco Lorenzo Crociani wrote:
>>>
>>> Hi,
>>> I was transferring some data with rsync to a btrfs filesystem when I got:
>>>
>>> set 04 14:59:05  kernel: INFO: task kworker/u33:2:25015 blocked for more
>>> than 120 seconds.
>>> set 04 14:59:05  kernel:       Not tainted 4.12.10-1.el7.elrepo.x86_64 #1
>>> set 04 14:59:05  kernel: "echo 0 >
>>> /proc/sys/kernel/hung_task_timeout_secs"
>>> disables this message.
>>> set 04 14:59:05  kernel: kworker/u33:2   D    0 25015      2 0x00000080
>>> set 04 14:59:05  kernel: Workqueue: events_unbound
>>> btrfs_async_reclaim_metadata_space [btrfs]
>>> set 04 14:59:05  kernel: Call Trace:
>>> set 04 14:59:05  kernel:  __schedule+0x28a/0x880
>>> set 04 14:59:05  kernel:  schedule+0x36/0x80
>>> set 04 14:59:05  kernel:  wb_wait_for_completion+0x64/0x90
>>> set 04 14:59:05  kernel:  ? remove_wait_queue+0x60/0x60
>>> set 04 14:59:05  kernel:  __writeback_inodes_sb_nr+0x8e/0xb0
>>> set 04 14:59:05  kernel:  writeback_inodes_sb_nr+0x10/0x20
>>> set 04 14:59:05  kernel:  flush_space+0x469/0x580 [btrfs]
>>> set 04 14:59:05  kernel:  ? dequeue_task_fair+0x577/0x830
>>> set 04 14:59:05  kernel:  ? pick_next_task_fair+0x122/0x550
>>> set 04 14:59:05  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
>>> [btrfs]
>>> set 04 14:59:05  kernel:  process_one_work+0x149/0x360
>>> set 04 14:59:05  kernel:  worker_thread+0x4d/0x3c0
>>> set 04 14:59:05  kernel:  kthread+0x109/0x140
>>> set 04 14:59:05  kernel:  ? rescuer_thread+0x380/0x380
>>> set 04 14:59:05  kernel:  ? kthread_park+0x60/0x60
>>> set 04 14:59:05  kernel:  ? do_syscall_64+0x67/0x150
>>> set 04 14:59:05  kernel:  ret_from_fork+0x25/0x30
>>>
>>> btrfs fi df /data
>>> Data, single: total=20.63TiB, used=20.63TiB
>>> System, DUP: total=8.00MiB, used=2.20MiB
>>> Metadata, DUP: total=41.50GiB, used=40.61GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>
>>> btrfs fi show /dev/sdo
>>> Label: 'Storage'  uuid: 429e42f4-dd9e-4267-b353-aa0831812f87
>>>         Total devices 1 FS bytes used 20.67TiB
>>>         devid    1 size 36.38TiB used 20.71TiB path /dev/sdo
>>>
>>> Is it serious? Can I provide other info?
>>>
>>
>> I think we're still cool here, the stack shows that btrfs is trying to
>> gain metadata space by flushing dirty pages via writeback threads, and
>> perhaps there're too much to flush to get enough metadata.
>>
>>
>> Thanks,
>>
>> -liubo
>>
>
> Hi,
> they are growing:
>
> set 05 20:46:59  kernel:  writeback_inodes_sb_nr+0x10/0x20
> set 05 20:46:59  kernel:  flush_space+0x469/0x580 [btrfs]
> set 05 20:46:59  kernel:  ? dequeue_task_fair+0x577/0x830
> set 05 20:46:59  kernel:  ? pick_next_task_fair+0x122/0x550
> set 05 20:46:59  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
> [btrfs]
> set 05 20:46:59  kernel:  process_one_work+0x149/0x360
> set 05 20:46:59  kernel:  worker_thread+0x4d/0x3c0
> set 05 20:46:59  kernel:  kthread+0x109/0x140
> set 05 20:46:59  kernel:  ? rescuer_thread+0x380/0x380
> set 05 20:46:59  kernel:  ? kthread_park+0x60/0x60
> set 05 20:46:59  kernel:  ? kthread_park+0x60/0x60
> set 05 20:46:59  kernel:  ret_from_fork+0x25/0x30
> set 05 20:49:02  kernel: INFO: task kworker/u34:4:10439 blocked for more
> than 120 seconds.
> set 05 20:49:02  kernel:       Not tainted 4.12.10-1.el7.elrepo.x86_64 #1
> set 05 20:49:02  kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> set 05 20:49:02  kernel: kworker/u34:4   D    0 10439      2 0x00000080
> set 05 20:49:02  kernel: Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> set 05 20:49:02  kernel: Call Trace:
> set 05 20:49:02  kernel:  __schedule+0x28a/0x880
> set 05 20:49:02  kernel:  schedule+0x36/0x80
> set 05 20:49:02  kernel:  wb_wait_for_completion+0x64/0x90
> set 05 20:49:02  kernel:  ? remove_wait_queue+0x60/0x60
> set 05 20:49:02  kernel:  __writeback_inodes_sb_nr+0x8e/0xb0
> set 05 20:49:02  kernel:  writeback_inodes_sb_nr+0x10/0x20
> set 05 20:49:02  kernel:  flush_space+0x469/0x580 [btrfs]
> set 05 20:49:02  kernel:  ? dequeue_task_fair+0x577/0x830
> set 05 20:49:02  kernel:  ? pick_next_task_fair+0x122/0x550
> set 05 20:49:02  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
> [btrfs]
> set 05 20:49:02  kernel:  process_one_work+0x149/0x360
> set 05 20:49:02  kernel:  worker_thread+0x4d/0x3c0
> set 05 20:49:02  kernel:  kthread+0x109/0x140
> set 05 20:49:02  kernel:  ? rescuer_thread+0x380/0x380
> set 05 20:49:02  kernel:  ? kthread_park+0x60/0x60
> set 05 20:49:02  kernel:  ? kthread_park+0x60/0x60
> set 05 20:49:02  kernel:  ret_from_fork+0x25/0x30
>
> Other round, more:
>
> set 06 20:30:20  kernel: INFO: task kworker/u33:8:25153 blocked for more
> than 120 seconds.
> set 06 20:30:20  kernel:       Not tainted 4.12.10-1.el7.elrepo.x86_64 #1
> set 06 20:30:20  kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> set 06 20:30:20  kernel: kworker/u33:8   D    0 25153      2 0x00000080
> set 06 20:30:20  kernel: Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> set 06 20:30:20  kernel: Call Trace:
> set 06 20:30:20  kernel:  __schedule+0x28a/0x880
> set 06 20:30:20  kernel:  schedule+0x36/0x80
> set 06 20:30:20  kernel:  wb_wait_for_completion+0x64/0x90
> set 06 20:30:20  kernel:  ? remove_wait_queue+0x60/0x60
> set 06 20:30:20  kernel:  __writeback_inodes_sb_nr+0x8e/0xb0
> set 06 20:30:20  kernel:  writeback_inodes_sb_nr+0x10/0x20
> set 06 20:30:20  kernel:  flush_space+0x469/0x580 [btrfs]
> set 06 20:30:20  kernel:  ? dequeue_task_fair+0x577/0x830
> set 06 20:30:20  kernel:  ? pick_next_task_fair+0x122/0x550
> set 06 20:30:20  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
> [btrfs]
> set 06 20:30:20  kernel:  process_one_work+0x149/0x360
> set 06 20:30:20  kernel:  worker_thread+0x4d/0x3c0
> set 06 20:30:20  kernel:  kthread+0x109/0x140
> set 06 20:30:20  kernel:  ? rescuer_thread+0x380/0x380
> set 06 20:30:20  kernel:  ? kthread_park+0x60/0x60
> set 06 20:30:20  kernel:  ? do_syscall_64+0x67/0x150
> set 06 20:30:20  kernel:  ret_from_fork+0x25/0x30
> set 06 20:32:23  kernel: INFO: task kworker/u33:8:25153 blocked for more
> than 120 seconds.
> set 06 20:32:23  kernel:       Not tainted 4.12.10-1.el7.elrepo.x86_64 #1
> set 06 20:32:23  kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> set 06 20:32:23  kernel: kworker/u33:8   D    0 25153      2 0x00000080
> set 06 20:32:23  kernel: Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> set 06 20:32:23  kernel: Call Trace:
> set 06 20:32:23  kernel:  __schedule+0x28a/0x880
> set 06 20:32:23  kernel:  schedule+0x36/0x80
> set 06 20:32:23  kernel:  wb_wait_for_completion+0x64/0x90
> set 06 20:32:23  kernel:  ? remove_wait_queue+0x60/0x60
> set 06 20:32:23  kernel:  __writeback_inodes_sb_nr+0x8e/0xb0
> set 06 20:32:23  kernel:  writeback_inodes_sb_nr+0x10/0x20
> set 06 20:32:23  kernel:  flush_space+0x469/0x580 [btrfs]
> set 06 20:32:23  kernel:  ? dequeue_task_fair+0x577/0x830
> set 06 20:32:23  kernel:  ? pick_next_task_fair+0x122/0x550
> set 06 20:32:23  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
> [btrfs]
> set 06 20:32:23  kernel:  process_one_work+0x149/0x360
> set 06 20:32:23  kernel:  worker_thread+0x4d/0x3c0
> set 06 20:32:23  kernel:  kthread+0x109/0x140
> set 06 20:32:23  kernel:  ? rescuer_thread+0x380/0x380
> set 06 20:32:23  kernel:  ? kthread_park+0x60/0x60
> set 06 20:32:23  kernel:  ? do_syscall_64+0x67/0x150
> set 06 20:32:23  kernel:  ret_from_fork+0x25/0x30
> set 06 20:34:26  kernel: INFO: task kworker/u33:8:25153 blocked for more
> than 120 seconds.
> set 06 20:34:26  kernel:       Not tainted 4.12.10-1.el7.elrepo.x86_64 #1
> set 06 20:34:26  kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> set 06 20:34:26  kernel: kworker/u33:8   D    0 25153      2 0x00000080
> set 06 20:34:26  kernel: Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> set 06 20:34:26  kernel: Call Trace:
> set 06 20:34:26  kernel:  __schedule+0x28a/0x880
> set 06 20:34:26  kernel:  schedule+0x36/0x80
> set 06 20:34:26  kernel:  wb_wait_for_completion+0x64/0x90
> set 06 20:34:26  kernel:  ? remove_wait_queue+0x60/0x60
> set 06 20:34:26  kernel:  __writeback_inodes_sb_nr+0x8e/0xb0
> set 06 20:34:26  kernel:  writeback_inodes_sb_nr+0x10/0x20
> set 06 20:34:26  kernel:  flush_space+0x469/0x580 [btrfs]
> set 06 20:34:26  kernel:  ? dequeue_task_fair+0x577/0x830
> set 06 20:34:26  kernel:  ? pick_next_task_fair+0x122/0x550
> set 06 20:34:26  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
> [btrfs]
> set 06 20:34:26  kernel:  process_one_work+0x149/0x360
> set 06 20:34:26  kernel:  worker_thread+0x4d/0x3c0
> set 06 20:34:26  kernel:  kthread+0x109/0x140
> set 06 20:34:26  kernel:  ? rescuer_thread+0x380/0x380
> set 06 20:34:26  kernel:  ? kthread_park+0x60/0x60
> set 06 20:34:26  kernel:  ? do_syscall_64+0x67/0x150
> set 06 20:34:26  kernel:  ret_from_fork+0x25/0x30
> set 06 20:36:29  kernel: INFO: task kworker/u33:8:25153 blocked for more
> than 120 seconds.
> set 06 20:36:29  kernel:       Not tainted 4.12.10-1.el7.elrepo.x86_64 #1
> set 06 20:36:29  kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> set 06 20:36:29  kernel: kworker/u33:8   D    0 25153      2 0x00000080
> set 06 20:36:29  kernel: Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> set 06 20:36:29  kernel: Call Trace:
> set 06 20:36:29  kernel:  __schedule+0x28a/0x880
> set 06 20:36:29  kernel:  schedule+0x36/0x80
> set 06 20:36:29  kernel:  wb_wait_for_completion+0x64/0x90
> set 06 20:36:29  kernel:  ? remove_wait_queue+0x60/0x60
> set 06 20:36:29  kernel:  __writeback_inodes_sb_nr+0x8e/0xb0
> set 06 20:36:29  kernel:  writeback_inodes_sb_nr+0x10/0x20
> set 06 20:36:29  kernel:  flush_space+0x469/0x580 [btrfs]
> set 06 20:36:29  kernel:  ? dequeue_task_fair+0x577/0x830
> set 06 20:36:29  kernel:  ? pick_next_task_fair+0x122/0x550
> set 06 20:36:29  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
> [btrfs]
> set 06 20:36:29  kernel:  process_one_work+0x149/0x360
> set 06 20:36:29  kernel:  worker_thread+0x4d/0x3c0
> set 06 20:36:29  kernel:  kthread+0x109/0x140
> set 06 20:36:29  kernel:  ? rescuer_thread+0x380/0x380
> set 06 20:36:29  kernel:  ? kthread_park+0x60/0x60
> set 06 20:36:29  kernel:  ? do_syscall_64+0x67/0x150
> set 06 20:36:29  kernel:  ret_from_fork+0x25/0x30
> set 06 20:38:32  kernel: INFO: task kworker/u33:8:25153 blocked for more
> than 120 seconds.
> set 06 20:38:32  kernel:       Not tainted 4.12.10-1.el7.elrepo.x86_64 #1
> set 06 20:38:32  kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> set 06 20:38:32  kernel: kworker/u33:8   D    0 25153      2 0x00000080
> set 06 20:38:32  kernel: Workqueue: events_unbound
> btrfs_async_reclaim_metadata_space [btrfs]
> set 06 20:38:32  kernel: Call Trace:
> set 06 20:38:32  kernel:  __schedule+0x28a/0x880
> set 06 20:38:32  kernel:  schedule+0x36/0x80
> set 06 20:38:32  kernel:  wb_wait_for_completion+0x64/0x90
> set 06 20:38:32  kernel:  ? remove_wait_queue+0x60/0x60
> set 06 20:38:32  kernel:  __writeback_inodes_sb_nr+0x8e/0xb0
> set 06 20:38:32  kernel:  writeback_inodes_sb_nr+0x10/0x20
> set 06 20:38:32  kernel:  flush_space+0x469/0x580 [btrfs]
> set 06 20:38:32  kernel:  ? dequeue_task_fair+0x577/0x830
> set 06 20:38:32  kernel:  ? pick_next_task_fair+0x122/0x550
> set 06 20:38:32  kernel:  btrfs_async_reclaim_metadata_space+0x112/0x430
> [btrfs]
> set 06 20:38:32  kernel:  process_one_work+0x149/0x360
> set 06 20:38:32  kernel:  worker_thread+0x4d/0x3c0
> set 06 20:38:32  kernel:  kthread+0x109/0x140
> set 06 20:38:32  kernel:  ? rescuer_thread+0x380/0x380
> set 06 20:38:32  kernel:  ? kthread_park+0x60/0x60
> set 06 20:38:32  kernel:  ? do_syscall_64+0x67/0x150
> set 06 20:38:32  kernel:  ret_from_fork+0x25/0x30
>
> It's happening near the end of rsync each time:
> lun  4 set 2017, 15.00.40, CEST
> mar  5 set 2017, 20.55.20, CEST
> mer  6 set 2017, 20.40.25, CEST
>
> Should I run balance or something else?
>
> Regards,
>
> --
> Marco Crociani
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
