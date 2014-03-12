Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57026 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaCLPSY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 11:18:24 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:34537 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WNkv6-0001mL-6j by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Mar 2014 08:18:23 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WNkv2-00051Z-MR
	for linux-btrfs@vger.kernel.org; Wed, 12 Mar 2014 08:18:08 -0700
Date: Wed, 12 Mar 2014 08:18:08 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140312151808.GE16865@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: 3.14.0-rc3: btrfs send/receive blocks btrfs IO on other devices
 (near deadlocks)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a file server with 4 cpu cores and 5 btrfs devices:
Label: btrfs_boot  uuid: e4c1daa8-9c39-4a59-b0a9-86297d397f3b
        Total devices 1 FS bytes used 48.92GiB
        devid    1 size 79.93GiB used 73.04GiB path /dev/mapper/cryptroot

Label: varlocalspace  uuid: 9f46dbe2-1344-44c3-b0fb-af2888c34f18
        Total devices 1 FS bytes used 1.10TiB
        devid    1 size 1.63TiB used 1.50TiB path /dev/mapper/cryptraid0

Label: btrfs_pool1  uuid: 6358304a-2234-4243-b02d-4944c9af47d7
        Total devices 1 FS bytes used 7.16TiB
        devid    1 size 14.55TiB used 7.50TiB path /dev/mapper/dshelf1

Label: btrfs_pool2  uuid: cb9df6d3-a528-4afc-9a45-4fed5ec358d6
        Total devices 1 FS bytes used 3.34TiB
        devid    1 size 7.28TiB used 3.42TiB path /dev/mapper/dshelf2

Label: bigbackup  uuid: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
        Total devices 5 FS bytes used 6.02TiB
        devid    1 size 1.82TiB used 1.43TiB path /dev/dm-9
        devid    2 size 1.82TiB used 1.43TiB path /dev/dm-6
        devid    3 size 1.82TiB used 1.43TiB path /dev/dm-5
        devid    4 size 1.82TiB used 1.43TiB path /dev/dm-7
        devid    5 size 1.82TiB used 1.43TiB path /dev/dm-8


I have a very long running btrfs send/receive from btrfs_pool1 to bigbackup
(long running meaning that it's been slowly copying over 5 days)

The problem is that this is blocking IO to btrfs_pool2 which is using
totally different drives.
By blocking IO I mean that IO to pool2 kind of works sometimes, and
hangs for very long times at other times.

It looks as if one rsync to btrfs_pool2 or one piece of IO hangs on a shared lock
and once that happens, all IO to btrfs_pool2 stops for a long time.
It does recover eventually without reboot, but the wait times are ridiculous (it 
could be 1H or more).

As I write this, I have a killall -9 rsync that waited for over 10mn before
these processes would finally die:
23555       07:36 wait_current_trans.isra.15     rsync -av -SH --delete (...)
23556       07:36 exit                           [rsync] <defunct>
25387  2-04:41:22 wait_current_trans.isra.15     rsync --password-file  (...)
27481       31:26 wait_current_trans.isra.15     rsync --password-file  (...)
29268    04:41:34 wait_current_trans.isra.15     rsync --password-file  (...)
29343    04:41:31 exit                           [rsync] <defunct>
29492    04:41:27 wait_current_trans.isra.15     rsync --password-file  (...)

14559    07:14:49 wait_current_trans.isra.15     cp -i -al current 20140312-feisty

This is all stuck in btrfs kernel code.
If someeone wants sysrq-w, there it is.
http://marc.merlins.org/tmp/btrfs_full.txt

A quick summary:
SysRq : Show Blocked State
  task                        PC stack   pid father
btrfs-cleaner   D ffff8802126b0840     0  3332      2 0x00000000
 ffff8800c5dc9d00 0000000000000046 ffff8800c5dc9fd8 ffff8800c69f6310
 00000000000141c0 ffff8800c69f6310 ffff88017574c170 ffff880211e671e8
 0000000000000000 ffff880211e67000 ffff8801e5936e20 ffff8800c5dc9d10
Call Trace:
 [<ffffffff8160b0d9>] schedule+0x73/0x75
 [<ffffffff8122a3c7>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff81085062>] ? finish_wait+0x65/0x65
 [<ffffffff8122b86c>] start_transaction+0x48e/0x4f2
 [<ffffffff8122bc4f>] ? __btrfs_end_transaction+0x2a1/0x2c6
 [<ffffffff8122b8eb>] btrfs_start_transaction+0x1b/0x1d
 [<ffffffff8121c5cd>] btrfs_drop_snapshot+0x443/0x610
 [<ffffffff8160d7b3>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff81074efb>] ? finish_task_switch+0x51/0xdb
 [<ffffffff8160afbf>] ? __schedule+0x537/0x5de
 [<ffffffff8122c08d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
 [<ffffffff81224859>] cleaner_kthread+0x103/0x136
 [<ffffffff81224756>] ? btrfs_alloc_root+0x26/0x26
 [<ffffffff8106bc1b>] kthread+0xae/0xb6
 [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816141bc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
btrfs-transacti D ffff88021387eb00     0  3333      2 0x00000000
 ffff8800c5dcb890 0000000000000046 ffff8800c5dcbfd8 ffff88021387e5d0
 00000000000141c0 ffff88021387e5d0 ffff88021f2141c0 ffff88021387e5d0
 ffff8800c5dcb930 ffffffff810fe574 0000000000000002 ffff8800c5dcb8a0
Call Trace:
 [<ffffffff810fe574>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8160b0d9>] schedule+0x73/0x75
 [<ffffffff8160b27e>] io_schedule+0x60/0x7a
 [<ffffffff810fe582>] sleep_on_page+0xe/0x12
 [<ffffffff8160b510>] __wait_on_bit+0x48/0x7a
 [<ffffffff810fe522>] wait_on_page_bit+0x7a/0x7c
 [<ffffffff81085096>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81245c70>] read_extent_buffer_pages+0x1bf/0x204
 [<ffffffff81223710>] ? free_root_pointers+0x5b/0x5b
 [<ffffffff81224412>] btree_read_extent_buffer_pages.constprop.45+0x66/0x100
 [<ffffffff81225367>] read_tree_block+0x2f/0x47
 [<ffffffff8120e4b6>] read_block_for_search.isra.26+0x24a/0x287
 [<ffffffff8120fcf7>] btrfs_search_slot+0x4f4/0x6bb
 [<ffffffff81214c3d>] lookup_inline_extent_backref+0xda/0x3fb
 [<ffffffff812167e1>] __btrfs_free_extent+0xf4/0x712
 [<ffffffff8121ba57>] __btrfs_run_delayed_refs+0x939/0xbdf
 [<ffffffff8121d896>] btrfs_run_delayed_refs+0x81/0x18f
 [<ffffffff8122af3e>] btrfs_commit_transaction+0x3a9/0x849
 [<ffffffff81085062>] ? finish_wait+0x65/0x65
 [<ffffffff81227598>] transaction_kthread+0xf8/0x1ab
 [<ffffffff812274a0>] ? btrfs_cleanup_transaction+0x43f/0x43f
 [<ffffffff8106bc1b>] kthread+0xae/0xb6
 [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816141bc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61


Worse, taking that dump gave me:
gargamel:/etc/udev/rules.d# echo w > /proc/sysrq-trigger 
Message from syslogd@gargamel at Mar 12 07:13:16 ...
 kernel:[1234536.531251] BUG: soft lockup - CPU#1 stuck for 22s! [mysqld:12552]
Message from syslogd@gargamel at Mar 12 07:13:16 ...
 kernel:[1234536.559276] BUG: soft lockup - CPU#2 stuck for 22s! [mysqld:4955]
Message from syslogd@gargamel at Mar 12 07:13:16 ...
 kernel:[1234540.538636] BUG: soft lockup - CPU#0 stuck for 22s! [kswapd0:48]
(there are more in the logs attached on what those lockups are)

Thankfully my btrfs send/receive is still working and should finish
today, but the amount of time it's been taking has been painful, and
the effect it's been having on the rest of my system, making it hang
or rendering its devices unusable for long periods of time, has been
punishing.

Can someone figure out from the kernel logs what is causing those near deadlocks?

Actually this was so bad apparently that sysrq w didn't even all make it
to syslog/disk (also on btrfs) but thankfully I got it on serial console.


I also found this suring sysrq. Shouldit be reported to someone else?
INFO: rcu_preempt detected stalls on CPUs/tasks:
	3: (1 GPs behind) idle=395/140000000000000/0 softirq=284540927/284540928 last_accelerate: ed62/2821, nonlazy_posted: 1, ..
	(detected by 0, t=15002 jiffies, g=100566635, c=100566634, q=87438)
sending NMI to all CPUs:
NMI backtrace for cpu 3
CPU: 3 PID: 21730 Comm: bash Not tainted 3.14.0-rc3-amd64-i915-preempt-20140216 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
task: ffff88001cf3a710 ti: ffff880037f78000 task.ti: ffff880037f78000
RIP: 0010:[<ffffffff81309a80>]  [<ffffffff81309a80>] paravirt_read_tsc+0x0/0xd
RSP: 0018:ffff880037f79ac0  EFLAGS: 00000046
RAX: 0000000000000003 RBX: 0000000094b043ff RCX: 0000000000000000
RDX: 0000000000000004 RSI: 00000000000003fd RDI: 0000000000000001
RBP: ffff880037f79ae8 R08: ffffffff81cf24d0 R09: 00000000fffffffe
R10: 0000000000001a18 R11: 0000000000000000 R12: 00000000000009fb
R13: 0000000000000003 R14: 0000000094b047d7 R15: 0000000000000036
FS:  0000000000000000(0000) GS:ffff88021f380000(0063) knlGS:00000000f754b6c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000ffc13412 CR3: 0000000145622000 CR4: 00000000000407e0
Stack:
 ffffffff81309b59 ffffffff81f27560 00000000000026f0 0000000000000020
 ffffffff813c9e1b ffff880037f79af8 ffffffff81309ac9 ffff880037f79b08
 ffffffff81309aef ffff880037f79b30 ffffffff813c9cc6 ffffffff81f27560
Call Trace:
 [<ffffffff81309b59>] ? delay_tsc+0x3d/0xa4
 [<ffffffff813c9e1b>] ? serial8250_console_write+0x10d/0x10d
 [<ffffffff81309ac9>] __delay+0xf/0x11
 [<ffffffff81309aef>] __const_udelay+0x24/0x26
 [<ffffffff813c9cc6>] wait_for_xmitr+0x49/0x91
 [<ffffffff813c9e37>] serial8250_console_putchar+0x1c/0x2e
 [<ffffffff813c5d97>] uart_console_write+0x3f/0x54
 [<ffffffff813c9dc8>] serial8250_console_write+0xba/0x10d
 [<ffffffff8109363b>] call_console_drivers.constprop.6+0xbc/0xf0
 [<ffffffff81093bf7>] console_unlock+0x269/0x302
 [<ffffffff8109405e>] vprintk_emit+0x3ce/0x3ff
 [<ffffffff81604702>] printk+0x54/0x56
 [<ffffffff81089799>] ? arch_local_irq_save+0x15/0x1b
 [<ffffffff8108752e>] print_cfs_rq+0x4fc/0xd71
 [<ffffffff81080fff>] print_cfs_stats+0x5a/0x9e
 [<ffffffff81086c65>] print_cpu+0x538/0x8e3
 [<ffffffff81087f7e>] sysrq_sched_debug_show+0x1f/0x42
 [<ffffffff81078874>] show_state_filter+0x92/0x9f
 [<ffffffff813b7c7a>] sysrq_handle_showstate_blocked+0x13/0x15
 [<ffffffff813b82c3>] __handle_sysrq+0xa0/0x138
 [<ffffffff813b8630>] write_sysrq_trigger+0x28/0x37
 [<ffffffff811a565a>] proc_reg_write+0x5a/0x7c
 [<ffffffff81155417>] vfs_write+0xab/0x107
 [<ffffffff81155b19>] SyS_write+0x46/0x79
 [<ffffffff81615f6c>] sysenter_dispatch+0x7/0x21
Code: 89 e5 e8 a2 fe ff ff 89 c2 66 31 c0 c1 e2 10 01 d0 15 ff ff 00 00 f7 d0 c1 e8 10 5d c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <55> 48 89 e5 e8 9c c4 d0 ff 66 90 5d c3 66 66 66 66 90 55 48 89 


Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
