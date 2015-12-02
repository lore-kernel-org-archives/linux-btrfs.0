Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34738 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbbLBVBD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 16:01:03 -0500
Received: by lffu14 with SMTP id u14so67352199lff.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 13:01:01 -0800 (PST)
MIME-Version: 1.0
From: Martin Tippmann <martin.tippmann@gmail.com>
Date: Wed, 2 Dec 2015 22:00:41 +0100
Message-ID: <CABL_Pd_bOgBASMmaz8S+UO7RZ-xLp79NA42O2EiiEgaxe2Pxjw@mail.gmail.com>
Subject: Bug Report: btrfs hangs / freezes on 4.3
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

just saw this in the logs on a few machines, Kernel 4.3.0, Mount options:

/dev/sda /media/storage1 btrfs
rw,noatime,compress=lzo,space_cache,subvolid=5,subvol=/ 0 0

[414675.258270] INFO: task java:19267 blocked for more than 120 seconds.
[414675.258312]       Not tainted 4.3.0-040300-generic #201511020846
[414675.258353] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[414675.258429] java            D ffff88081f996980     0 19267  18965 0x00000000
[414675.258436]  ffff880337d67bb8 0000000000000082 ffff88081c2f3800
ffff880019be9c00
[414675.258438]  ffff880337d68000 ffff88101b7627bc ffff880019be9c00
00000000ffffffff
[414675.258440]  ffff88101b7627c0 ffff880337d67bd0 ffffffff817af3f3
ffff88101b7627b8
[414675.258442] Call Trace:
[414675.258445]  [<ffffffff817af3f3>] schedule+0x33/0x80
[414675.258450]  [<ffffffff817af6ae>] schedule_preempt_disabled+0xe/0x10
[414675.258454]  [<ffffffff817b0fb5>] __mutex_lock_slowpath+0x95/0x110
[414675.258458]  [<ffffffff817b104f>] mutex_lock+0x1f/0x30
[414675.258470]  [<ffffffffc02c3352>]
btrfs_wait_ordered_roots+0x42/0x1d0 [btrfs]
[414675.258480]  [<ffffffffc0294c8f>]
btrfs_check_data_free_space+0x1ff/0x2f0 [btrfs]
[414675.258491]  [<ffffffffc02bb30f>] __btrfs_buffered_write+0x13f/0x5a0 [btrfs]
[414675.258495]  [<ffffffff816fb001>] ? tcp_recvmsg+0x3d1/0xb70
[414675.258505]  [<ffffffffc02be971>] btrfs_file_write_iter+0x171/0x560 [btrfs]
[414675.258510]  [<ffffffff810aeacc>] ? set_next_entity+0x9c/0xb0
[414675.258515]  [<ffffffff811f13c7>] __vfs_write+0xa7/0xf0
[414675.258520]  [<ffffffff811f1a16>] vfs_write+0xa6/0x1a0
[414675.258524]  [<ffffffff811f2616>] SyS_write+0x46/0xa0
[414675.258528]  [<ffffffff817b3036>] entry_SYSCALL_64_fastpath+0x16/0x75
[414675.258533] INFO: task java:19268 blocked for more than 120 seconds.
[414675.258576]       Not tainted 4.3.0-040300-generic #201511020846
[414675.258616] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[414675.258684] java            D ffff88081f996980     0 19268  18965 0x00000000
[414675.258692]  ffff880634f23bb8 0000000000000082 ffff88081c2f3800
ffff880019beaa00
[414675.258704]  ffff880634f24000 ffff88101b7627bc ffff880019beaa00
00000000ffffffff
[414675.258715]  ffff88101b7627c0 ffff880634f23bd0 ffffffff817af3f3
ffff88101b7627b8
[414675.258727] Call Trace:
[414675.258732]  [<ffffffff817af3f3>] schedule+0x33/0x80
[414675.258736]  [<ffffffff817af6ae>] schedule_preempt_disabled+0xe/0x10
[414675.258741]  [<ffffffff817b0fb5>] __mutex_lock_slowpath+0x95/0x110
[414675.258745]  [<ffffffff817b104f>] mutex_lock+0x1f/0x30
[414675.258756]  [<ffffffffc02c3352>]
btrfs_wait_ordered_roots+0x42/0x1d0 [btrfs]
[414675.258764]  [<ffffffffc0294c8f>]
btrfs_check_data_free_space+0x1ff/0x2f0 [btrfs]
[414675.258772]  [<ffffffffc02bb30f>] __btrfs_buffered_write+0x13f/0x5a0 [btrfs]
[414675.258774]  [<ffffffff816fb001>] ? tcp_recvmsg+0x3d1/0xb70
[414675.258783]  [<ffffffffc02be971>] btrfs_file_write_iter+0x171/0x560 [btrfs]
[414675.258785]  [<ffffffff8169561b>] ? sock_recvmsg+0x3b/0x50
[414675.258787]  [<ffffffff811f13c7>] __vfs_write+0xa7/0xf0
[414675.258790]  [<ffffffff811f1a16>] vfs_write+0xa6/0x1a0
[414675.258791]  [<ffffffff810e65c5>] ? ktime_get_ts64+0x45/0xf0
[414675.258793]  [<ffffffff811f2616>] SyS_write+0x46/0xa0
[414675.258795]  [<ffffffff817b3036>] entry_SYSCALL_64_fastpath+0x16/0x75
[414675.258812] INFO: task java:19067 blocked for more than 120 seconds.
[414675.258856]       Not tainted 4.3.0-040300-generic #201511020846
[414675.258898] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[414675.258964] java            D ffff88081f8d6980     0 19067   2602 0x00000000
[414675.258967]  ffff880056957bb8 0000000000000082 ffff88081c2c6200
ffff8810188e0000
[414675.258968]  ffff880056958000 ffff88101b7627bc ffff8810188e0000
00000000ffffffff
[414675.258970]  ffff88101b7627c0 ffff880056957bd0 ffffffff817af3f3
ffff88101b7627b8
[414675.258972] Call Trace:
[414675.258975]  [<ffffffff817af3f3>] schedule+0x33/0x80
[414675.258977]  [<ffffffff817af6ae>] schedule_preempt_disabled+0xe/0x10
[414675.258979]  [<ffffffff817b0fb5>] __mutex_lock_slowpath+0x95/0x110
[414675.258981]  [<ffffffff817b104f>] mutex_lock+0x1f/0x30
[414675.258992]  [<ffffffffc02c3352>]
btrfs_wait_ordered_roots+0x42/0x1d0 [btrfs]
[414675.259003]  [<ffffffffc0294c8f>]
btrfs_check_data_free_space+0x1ff/0x2f0 [btrfs]
[414675.259013]  [<ffffffffc02bb30f>] __btrfs_buffered_write+0x13f/0x5a0 [btrfs]
[414675.259019]  [<ffffffff81314dc3>] ? security_inode_need_killpriv+0x33/0x50
[414675.259029]  [<ffffffffc02be971>] btrfs_file_write_iter+0x171/0x560 [btrfs]
[414675.259035]  [<ffffffff811f13c7>] __vfs_write+0xa7/0xf0
[414675.259040]  [<ffffffff811f1a16>] vfs_write+0xa6/0x1a0
[414675.259046]  [<ffffffff81063d24>] ? __do_page_fault+0x1b4/0x400
[414675.259051]  [<ffffffff811f2616>] SyS_write+0x46/0xa0
[414675.259055]  [<ffffffff817b3036>] entry_SYSCALL_64_fastpath+0x16/0x75

regards
Martin
