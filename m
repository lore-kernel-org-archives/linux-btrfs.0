Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:51726 "EHLO
        licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbdI1O2Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:28:24 -0400
Message-ID: <1506608901.2373.10.camel@daevel.fr>
Subject: =?ISO-8859-1?Q?Re=A0=3A?= task btrfs-transacti:651 blocked for more
 than 120 seconds
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
Date: Thu, 28 Sep 2017 16:28:21 +0200
In-Reply-To: <ed2732d4-966a-3f17-bb5e-27f7615668ea@gmail.com>
References: <1506593789.26660.28.camel@daevel.fr>
         <ed2732d4-966a-3f17-bb5e-27f7615668ea@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le jeudi 28 septembre 2017 à 14:18 +0300, Nikolay Borisov a écrit :
> So what this stack trace means is that transaction commit has hung.
> And
> judging by the called functions (assuming they are correct, though
> the ?
> aren't very encouraging). Concretely, it means that an io has been
> started for a certain range of addresses and transaction commit is
> now
> waiting to be awaken upon completion of write. When this occurs can
> you
> see if there is io activity from that particular guest (assuming you
> have access to the hypervisor)? It might be a bug in btrfs or you
> might
> be hitting something else in the hypervisor


Hello,

thanks for your answer. From the hypervisor, I don't see any IO during
this hang.

I tried to clone the VM to simulate the problem, and I also have the
problem without Btrfs :

[ 3263.452023] INFO: task systemd:1 blocked for more than 120 seconds.
[ 3263.452040]       Tainted: G        W       4.9-dae-xen #2
[ 3263.452044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3263.452052] systemd         D    0     1      0 0x00000000
[ 3263.452060]  ffff8803a71ca000 0000000000000000 ffff8803af857880 ffff8803a9762dc0
[ 3263.452070]  ffff8803a96fcc80 ffffc9001623f990 ffffffff8150ff1f 0000000000000000
[ 3263.452079]  ffff8803a96fcc80 7fffffffffffffff ffffffff81510710 ffffc9001623faa0
[ 3263.452087] Call Trace:
[ 3263.452099]  [<ffffffff8150ff1f>] ? __schedule+0x17f/0x530
[ 3263.452105]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
[ 3263.452110]  [<ffffffff815102fd>] ? schedule+0x2d/0x80
[ 3263.452116]  [<ffffffff815132be>] ? schedule_timeout+0x17e/0x2a0
[ 3263.452121]  [<ffffffff8101bb71>] ? xen_clocksource_get_cycles+0x11/0x20
[ 3263.452126]  [<ffffffff810f2196>] ? ktime_get+0x36/0xa0
[ 3263.452130]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
[ 3263.452134]  [<ffffffff8150fd38>] ? io_schedule_timeout+0x98/0x100
[ 3263.452137]  [<ffffffff81513de1>] ? _raw_spin_unlock_irqrestore+0x11/0x20
[ 3263.452141]  [<ffffffff81510722>] ? bit_wait_io+0x12/0x60
[ 3263.452145]  [<ffffffff815107be>] ? __wait_on_bit+0x4e/0x80
[ 3263.452149]  [<ffffffff81510710>] ? bit_wait+0x50/0x50
[ 3263.452153]  [<ffffffff81510859>] ? out_of_line_wait_on_bit+0x69/0x80
[ 3263.452157]  [<ffffffff810d4ab0>] ? autoremove_wake_function+0x30/0x30
[ 3263.452163]  [<ffffffff81220ed0>] ? ext4_find_entry+0x350/0x5d0
[ 3263.452168]  [<ffffffff811b9020>] ? d_alloc_parallel+0xa0/0x480
[ 3263.452172]  [<ffffffff811b6d18>] ? __d_lookup_done+0x68/0xd0
[ 3263.452175]  [<ffffffff811b7f38>] ? d_splice_alias+0x158/0x3b0
[ 3263.452179]  [<ffffffff81221662>] ? ext4_lookup+0x42/0x1f0
[ 3263.452184]  [<ffffffff811ab28e>] ? lookup_slow+0x8e/0x130
[ 3263.452187]  [<ffffffff811ab71a>] ? walk_component+0x1ca/0x300
[ 3263.452193]  [<ffffffff811ac0fe>] ? link_path_walk+0x18e/0x570
[ 3263.452199]  [<ffffffff811abe13>] ? path_init+0x1c3/0x320
[ 3263.452207]  [<ffffffff811ae4c2>] ? path_openat+0xe2/0x1380
[ 3263.452214]  [<ffffffff811b0329>] ? do_filp_open+0x79/0xd0
[ 3263.452222]  [<ffffffff81185fc1>] ? kmem_cache_alloc+0x71/0x400
[ 3263.452228]  [<ffffffff8119d507>] ? __check_object_size+0xf7/0x1c4
[ 3263.452235]  [<ffffffff8119f8cf>] ? do_sys_open+0x11f/0x1f0
[ 3263.452238]  [<ffffffff815141b7>] ? entry_SYSCALL_64_fastpath+0x1a/0xa9


So I will try to see with Xen developpers.

Thanks,

Olivier
