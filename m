Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:52984 "EHLO
        licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdI1KVe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 06:21:34 -0400
Message-ID: <1506593789.26660.28.camel@daevel.fr>
Subject: task btrfs-transacti:651 blocked for more than 120 seconds
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: linux-btrfs@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
Date: Thu, 28 Sep 2017 12:16:29 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi !

I have a virtual server (Xen) which very frequently hangs with only
this error in logs :

[ 1330.144124] INFO: task btrfs-transacti:651 blocked for more than 120 seconds.
[ 1330.144141]       Not tainted 4.9-dae-xen #2
[ 1330.144146] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1330.144179] btrfs-transacti D    0   651      2 0x00000000
[ 1330.144184]  ffff8803a6c85b40 0000000000000000 ffff8803af857880 ffff8803a9762180
[ 1330.144190]  ffff8803a7bb8140 ffffc900173bfb10 ffffffff8150ff1f 0000000000000000
[ 1330.144195]  ffff8803a7bb8140 7fffffffffffffff ffffffff81510710 ffffc900173bfc18
[ 1330.144200] Call Trace:
[ 1330.144211]  [<ffffffff8150ff1f>] ? __schedule+0x17f/0x530
[ 1330.144215]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
[ 1330.144218]  [<ffffffff815102fd>] ? schedule+0x2d/0x80
[ 1330.144221]  [<ffffffff815132be>] ? schedule_timeout+0x17e/0x2a0
[ 1330.144226]  [<ffffffff8101bb71>] ? xen_clocksource_get_cycles+0x11/0x20
[ 1330.144231]  [<ffffffff810f2196>] ? ktime_get+0x36/0xa0
[ 1330.144234]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
[ 1330.144237]  [<ffffffff8150fd38>] ? io_schedule_timeout+0x98/0x100
[ 1330.144240]  [<ffffffff81513de1>] ? _raw_spin_unlock_irqrestore+0x11/0x20
[ 1330.144246]  [<ffffffff81510722>] ? bit_wait_io+0x12/0x60
[ 1330.144250]  [<ffffffff815107be>] ? __wait_on_bit+0x4e/0x80
[ 1330.144256]  [<ffffffff8113772c>] ? wait_on_page_bit+0x6c/0x80
[ 1330.144261]  [<ffffffff810d4ab0>] ? autoremove_wake_function+0x30/0x30
[ 1330.144265]  [<ffffffff81137808>] ? __filemap_fdatawait_range+0xc8/0x110
[ 1330.144270]  [<ffffffff81137859>] ? filemap_fdatawait_range+0x9/0x20
[ 1330.144298]  [<ffffffffa014b033>] ? btrfs_wait_ordered_range+0x63/0x100 [btrfs]
[ 1330.144310]  [<ffffffffa0175a68>] ? btrfs_wait_cache_io+0x58/0x1e0 [btrfs]
[ 1330.144320]  [<ffffffffa011ded2>] ? btrfs_start_dirty_block_groups+0x1c2/0x450 [btrfs]
[ 1330.144328]  [<ffffffff810a2ba5>] ? do_group_exit+0x35/0xa0
[ 1330.144338]  [<ffffffffa012efa7>] ? btrfs_commit_transaction+0x147/0x9b0 [btrfs]
[ 1330.144348]  [<ffffffffa012f8a2>] ? start_transaction+0x92/0x3f0 [btrfs]
[ 1330.144357]  [<ffffffffa012a0e7>] ? transaction_kthread+0x1d7/0x1f0 [btrfs]
[ 1330.144366]  [<ffffffffa0129f10>] ? btrfs_cleanup_transaction+0x4f0/0x4f0 [btrfs]
[ 1330.144373]  [<ffffffff810ba352>] ? kthread+0xc2/0xe0
[ 1330.144377]  [<ffffffff810ba290>] ? kthread_create_on_node+0x40/0x40
[ 1330.144381]  [<ffffffff81514405>] ? ret_from_fork+0x25/0x30


It's a Debian Stretch system, running a 4.9.52 Linux kernel (on a Xen 4.8.2 hypervisor).
With an old 4.1.x Linux kernel, I haven't any problem.


Is it a Btrfs bug ? Should I try a more recent kernel ? (which one ?)

Thanks in advance,

Olivier
