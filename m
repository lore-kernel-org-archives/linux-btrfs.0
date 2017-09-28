Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:37708 "EHLO
        licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751689AbdI1QyK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 12:54:10 -0400
Message-ID: <1506617343.2373.29.camel@daevel.fr>
Subject: =?ISO-8859-1?Q?Re=A0=3A?= [Xen-devel] =?ISO-8859-1?Q?Re=A0=3A?=
 task btrfs-transacti:651 blocked for more than 120 seconds
From: Olivier Bonvalet <xen.list@daevel.fr>
To: xen-devel@lists.xenproject.org
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 28 Sep 2017 18:49:03 +0200
In-Reply-To: <1506608901.2373.10.camel@daevel.fr>
References: <1506593789.26660.28.camel@daevel.fr>
         <ed2732d4-966a-3f17-bb5e-27f7615668ea@gmail.com>
         <1506608901.2373.10.camel@daevel.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le jeudi 28 septembre 2017 à 16:28 +0200, Olivier Bonvalet a écrit :
> [ 3263.452023] INFO: task systemd:1 blocked for more than 120
> seconds.
> [ 3263.452040]       Tainted: G        W       4.9-dae-xen #2
> [ 3263.452044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3263.452052] systemd         D    0     1      0 0x00000000
> [ 3263.452060]  ffff8803a71ca000 0000000000000000 ffff8803af857880
> ffff8803a9762dc0
> [ 3263.452070]  ffff8803a96fcc80 ffffc9001623f990 ffffffff8150ff1f
> 0000000000000000
> [ 3263.452079]  ffff8803a96fcc80 7fffffffffffffff ffffffff81510710
> ffffc9001623faa0
> [ 3263.452087] Call Trace:
> [ 3263.452099]  [<ffffffff8150ff1f>] ? __schedule+0x17f/0x530
> [ 3263.452105]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
> [ 3263.452110]  [<ffffffff815102fd>] ? schedule+0x2d/0x80
> [ 3263.452116]  [<ffffffff815132be>] ? schedule_timeout+0x17e/0x2a0
> [ 3263.452121]  [<ffffffff8101bb71>] ?
> xen_clocksource_get_cycles+0x11/0x20
> [ 3263.452126]  [<ffffffff810f2196>] ? ktime_get+0x36/0xa0
> [ 3263.452130]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
> [ 3263.452134]  [<ffffffff8150fd38>] ? io_schedule_timeout+0x98/0x100
> [ 3263.452137]  [<ffffffff81513de1>] ?
> _raw_spin_unlock_irqrestore+0x11/0x20
> [ 3263.452141]  [<ffffffff81510722>] ? bit_wait_io+0x12/0x60
> [ 3263.452145]  [<ffffffff815107be>] ? __wait_on_bit+0x4e/0x80
> [ 3263.452149]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
> [ 3263.452153]  [<ffffffff81510859>] ?
> out_of_line_wait_on_bit+0x69/0x80
> [ 3263.452157]  [<ffffffff810d4ab0>] ?
> autoremove_wake_function+0x30/0x30
> [ 3263.452163]  [<ffffffff81220ed0>] ? ext4_find_entry+0x350/0x5d0
> [ 3263.452168]  [<ffffffff811b9020>] ? d_alloc_parallel+0xa0/0x480
> [ 3263.452172]  [<ffffffff811b6d18>] ? __d_lookup_done+0x68/0xd0
> [ 3263.452175]  [<ffffffff811b7f38>] ? d_splice_alias+0x158/0x3b0
> [ 3263.452179]  [<ffffffff81221662>] ? ext4_lookup+0x42/0x1f0
> [ 3263.452184]  [<ffffffff811ab28e>] ? lookup_slow+0x8e/0x130
> [ 3263.452187]  [<ffffffff811ab71a>] ? walk_component+0x1ca/0x300
> [ 3263.452193]  [<ffffffff811ac0fe>] ? link_path_walk+0x18e/0x570
> [ 3263.452199]  [<ffffffff811abe13>] ? path_init+0x1c3/0x320
> [ 3263.452207]  [<ffffffff811ae4c2>] ? path_openat+0xe2/0x1380
> [ 3263.452214]  [<ffffffff811b0329>] ? do_filp_open+0x79/0xd0
> [ 3263.452222]  [<ffffffff81185fc1>] ? kmem_cache_alloc+0x71/0x400
> [ 3263.452228]  [<ffffffff8119d507>] ? __check_object_size+0xf7/0x1c4
> [ 3263.452235]  [<ffffffff8119f8cf>] ? do_sys_open+0x11f/0x1f0
> [ 3263.452238]  [<ffffffff815141b7>] ?
> entry_SYSCALL_64_fastpath+0x1a/0xa9

Just in case, an other example :

[ 1088.476044] INFO: task jbd2/xvdb-8:494 blocked for more than 120 seconds.
[ 1088.476058]       Tainted: G        W       4.9-dae-xen #2
[ 1088.476061] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1088.476066] jbd2/xvdb-8     D    0   494      2 0x00000000
[ 1088.476072]  ffff8800fd036480 0000000000000000 ffff8803af8d7880 ffff8803a8c6e580
[ 1088.476079]  ffff88038756d280 ffffc9001737fb90 ffffffff8150ff1f 0000100000000001
[ 1088.476085]  ffff88038756d280 7fffffffffffffff ffffffff81510710 ffffc9001737fc98
[ 1088.476091] Call Trace:
[ 1088.476102]  [<ffffffff8150ff1f>] ? __schedule+0x17f/0x530
[ 1088.476107]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
[ 1088.476114]  [<ffffffff815102fd>] ? schedule+0x2d/0x80
[ 1088.476117]  [<ffffffff815132be>] ? schedule_timeout+0x17e/0x2a0
[ 1088.476123]  [<ffffffff8101bb71>] ? xen_clocksource_get_cycles+0x11/0x20
[ 1088.476126]  [<ffffffff8101bb71>] ? xen_clocksource_get_cycles+0x11/0x20
[ 1088.476132]  [<ffffffff810f2196>] ? ktime_get+0x36/0xa0
[ 1088.476136]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
[ 1088.476139]  [<ffffffff8150fd38>] ? io_schedule_timeout+0x98/0x100
[ 1088.476143]  [<ffffffff81513de1>] ? _raw_spin_unlock_irqrestore+0x11/0x20
[ 1088.476147]  [<ffffffff81510722>] ? bit_wait_io+0x12/0x60
[ 1088.476151]  [<ffffffff815107be>] ? __wait_on_bit+0x4e/0x80
[ 1088.476155]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
[ 1088.476159]  [<ffffffff81510859>] ? out_of_line_wait_on_bit+0x69/0x80
[ 1088.476163]  [<ffffffff810d4ab0>] ? autoremove_wake_function+0x30/0x30
[ 1088.476170]  [<ffffffff812528ee>] ? jbd2_journal_commit_transaction+0xe7e/0x1610
[ 1088.476177]  [<ffffffff810eb7f6>] ? lock_timer_base+0x76/0x90
[ 1088.476182]  [<ffffffff81255b0d>] ? kjournald2+0xad/0x230
[ 1088.476189]  [<ffffffff810d4a80>] ? wake_atomic_t_function+0x50/0x50
[ 1088.476193]  [<ffffffff81255a60>] ? commit_timeout+0x10/0x10
[ 1088.476197]  [<ffffffff810a2ba5>] ? do_group_exit+0x35/0xa0
[ 1088.476201]  [<ffffffff810ba352>] ? kthread+0xc2/0xe0
[ 1088.476205]  [<ffffffff810ba290>] ? kthread_create_on_node+0x40/0x40
[ 1088.476209]  [<ffffffff81514405>] ? ret_from_fork+0x25/0x30



and also from the Dom0 (rewritten from screenshot) :

watchdog: BUG: soft lockup - CPU#11 stuck for 22s! [kworker/11:0:26273]
Modules linked in: ...
CPU: 11 PID: 26273 Comm: kworker/11:0 Taineted: G D W L 4.13-dae-dom0 #2
Harware name: Intel Corporation S2600CWR/S2600CWR, BIOS SE5C610.86B.01.01.0019.101220160604 10/12/2016
Workqueue: events wait_rcu_exp_gp
task: ... task.stack: ...
RIP: e030:smp_call_function_single+0x6b/0xc0
...
Call Trace:
 ? sync_rcu_exp_select_cpus+0x2b5/0x410
 ? rcu_barrier_func+0x40/0x40
 ? wait_rcu_rxp_gp+0x16/0x30
 ? process_one_work+0x1ad/0x340
 ? worker_thread+0x45/0x3f0
 ? kthread+0xf2/0x130
 ? process_one_work+0x340/0x340
 ? kthread_create_on_node+0x40/0x40
 ? do_group_exit+0x35/0xa0
 ? ret_from_fork+0x25/0x30
...



