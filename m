Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35912 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaGDBTj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 21:19:39 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1X2sA6-0003vZ-Cl
	for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 18:19:38 -0700
Date: Thu, 3 Jul 2014 18:19:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Is btrfs related to OOM death problems on my 8GB server with both 3.15.1 and 3.14?
Message-ID: <20140704011938.GO11539@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I upgraded my server from 3.14 to 3.15.1 last week, and since then it's been
running out of memory and deadlocking (panic= doesn't even work).
I downgraded back to 3.14, but I already had the problem once since then.

OOM comes in, even though I have 0 swap used and AFAIK all my RAM isn't
gone, it then fails to kill enough stuff and eventually it dies like this:
[80943.542209] Swap cache stats: add 814596, delete 814595, find 2567491/2808869
[80943.565106] Free swap  = 15612448kB
[80943.577607] Total swap = 15616764kB
[80943.589766] 2021665 pages RAM
[80943.600281] 0 pages HighMem/MovableOnly
[80943.613284] 28468 pages reserved
[80943.624330] 0 pages hwpoisoned
[80943.634824] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[80943.659669] [  918]     0   918      855        0       5      236         -1000 udevd
[80943.684789] [ 8022]     0  8022     3074        0       5       89         -1000 auditd
[80943.710154] [ 8253]     0  8253     1813        0       6      123         -1000 sshd
[80943.735024] [12001]     0 12001      854        0       5      241         -1000 udevd
[80943.760152] [18969]     0 18969      854        0       5      223         -1000 udevd
[80943.785293] Kernel panic - not syncing: Out of memory and no killable processes...


Here is my more recent capture on 3.14 when I was able to catch it
before the panic and dump a bunch of sysrq data.
http://marc.merlins.org/tmp/btrfs-oom.txt

Things to note in that log:
[90621.895715] 2962 total pagecache pages
[90621.895716] 5 pages in swap cache
[90621.895717] Swap cache stats: add 145004, delete 144999, find 3314901/3316382
[90621.895718] Free swap  = 15230536kB
[90621.895718] Total swap = 15616764kB
[90621.895718] Total swap = 15616764kB
[90621.895719] 2021665 pages RAM
[90621.895720] 0 pages HighMem/MovableOnly
[90621.895720] 28468 pages reserved
I'm not a VM person so I don't know how to read this, but am I out of RAM
but not out of swap (since clearly none was used), or am I out of a specific
memory region that is causing me problems?

I'm not 100% certain btrfs is to blame, but somehow it's suspect when
ugprading to 3.15 and getting btrfs problems then caused my 3 months running
fine 3.14.0 kernel also to die with the same OOM problems.
Then again, I understand it could be red herring. Suggestions either way are
appreciated :)

I tried raising this:
gargamel:~# echo 100 > /proc/sys/vm/swappiness

But so far I have too much unused RAM for any swap to be touched.
gargamel:~# free
             total       used       free     shared    buffers     cached
Mem:       7894792    4938596    2956196          0       2396    2909204
-/+ buffers/cache:    2026996    5867796
Swap:     15616764          0   15616764


The log is too big to paste here, but you can grep it for:
[90817.715833] SysRq : Show Memory
[90817.715833] SysRq : Show Memory
[90817.715833] SysRq : Show Memory
[90893.571151] SysRq : Show backtrace of all active CPUs
[90921.781599] SysRq : Show Blocked State
[91075.976611] SysRq : Show State
[91406.972046] SysRq : Terminate All Tasks
[91410.771584] SysRq : Emergency Remount R/O
[91413.222483] SysRq : Emergency Sync
[91430.316955] SysRq : Power Off
^^^^^^^^^^^^^^^^^^^^^^^
note the kernel was wedged enough that Power Off didn't work, apparently because it failed
to swap:
[91447.490142] CPU: 3 PID: 48 Comm: kswapd0 Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[91447.490143] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[91447.490145] task: ffff8802126b6490 ti: ffff8802126e4000 task.ti: ffff8802126e4000
[91447.490146] RIP: 0010:[<ffffffff810898f5>]  [<ffffffff810898f5>] do_raw_spin_lock+0x23/0x27

Right after OOM started kicking in, console showed apparent deadlocks in btrfs.
But is it possible that btrfs is then also eating all my memory somehow?

You can find the long details here:
http://marc.merlins.org/tmp/btrfs-oom.txt

[90801.680821] INFO: task btrfs-transacti:3433 blocked for more than 120 seconds.
[90801.712345]       Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[90801.734394] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[90801.882691] btrfs-transacti D ffff88021387e800     0  3433      2 0x00000000
[90801.904863]  ffff88020b20de10 0000000000000046 ffff88020b20dfd8 ffff88021387e2d0
[90801.928448]  00000000000141c0 ffff88021387e2d0 ffff880211e94800 ffff880029c00dc0
[90801.952015]  ffff8802009d1f28 ffff8802009d1ed0 0000000000000000 ffff88020b20de20
[90801.975701] Call Trace:
[90801.984443]  [<ffffffff8160d2a1>] schedule+0x73/0x75
[90802.000438]  [<ffffffff8122b575>] btrfs_commit_transaction+0x330/0x849
[90802.021140]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
[90802.038438]  [<ffffffff81227c48>] transaction_kthread+0xf8/0x1ab
[90802.057571]  [<ffffffff81227b50>] ? btrfs_cleanup_transaction+0x43f/0x43f
[90802.079092]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[90802.094838]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[90802.113485]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[90802.130821]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[90802.153881] INFO: task bash:6863 blocked for more than 120 seconds.
[90802.174582]       Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[90802.195291] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[90802.220747] bash            D ffff88016177e780     0  6863   6862 0x20120086
[90802.268599]  ffff88006f7eb918 0000000000000046 ffff88006f7ebfd8 ffff88016177e250
[90802.292124]  00000000000141c0 ffff88016177e250 ffff88006f7eb980 ffff8801ad7a484c
[90802.315631]  0000000001ddc000 ffff88006f7eb998 ffff8801ad7a4830 ffff88006f7eb928
[90802.339144] Call Trace:
[90802.347518]  [<ffffffff8160d2a1>] schedule+0x73/0x75
[90802.363446]  [<ffffffff81242468>] lock_extent_bits+0x11e/0x195
[90802.382008]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
[90802.399262]  [<ffffffff81238674>] lock_and_cleanup_extent_if_need+0x6c/0x198
[90802.421485]  [<ffffffff81239a21>] __btrfs_buffered_write+0x1e9/0x427
[90802.441622]  [<ffffffff8160dd00>] ? mutex_unlock+0x16/0x18
[90802.459170]  [<ffffffff8123a028>] btrfs_file_aio_write+0x3c9/0x4b7
[90802.478803]  [<ffffffff811552b8>] do_sync_write+0x59/0x78
[90802.496102]  [<ffffffff810b3677>] do_acct_process+0x314/0x39c
[90802.514452]  [<ffffffff810b3ca7>] acct_process+0x77/0x92
[90802.531520]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[90802.547785]  [<ffffffff812986dd>] ? security_task_wait+0x16/0x18
[90802.566914]  [<ffffffff8105c571>] ? __dequeue_signal+0x1c/0x101
[90802.585790]  [<ffffffff81052731>] do_group_exit+0x6f/0xa2
[90802.603094]  [<ffffffff8105ed02>] get_signal_to_deliver+0x4e6/0x533
[90802.623011]  [<ffffffff8100f38f>] do_signal+0x49/0x5dc
[90802.639553]  [<ffffffff810b6499>] ? C_SYSC_wait4+0x28/0xba
[90802.657105]  [<ffffffff813b6353>] ? tty_ldisc_deref+0x16/0x18
[90802.675433]  [<ffffffff8115d770>] ? path_put+0x1e/0x21
[90802.691916]  [<ffffffff8100f957>] do_notify_resume+0x35/0x72
[90802.709952]  [<ffffffff816166ea>] int_signal+0x12/0x17

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
