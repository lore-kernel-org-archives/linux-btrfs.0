Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65066 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaLGCqA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Dec 2014 21:46:00 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so1940800wiw.9
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Dec 2014 18:45:58 -0800 (PST)
MIME-Version: 1.0
Reply-To: andrew.j.wade@gmail.com
In-Reply-To: <m5imaf$s9b$1@ger.gmane.org>
References: <m5imaf$s9b$1@ger.gmane.org>
Date: Sat, 6 Dec 2014 21:45:57 -0500
Message-ID: <CAAuLxcZJ1VDTrvRtaaXgqUo91sBcBkLYUUTe-_CNLm1zMEZp7g@mail.gmail.com>
Subject: Re: Kernel lockup: "fs/btrfs/delayed-inoce.c:1410 btrfs_assert_delayed_root_empty"
From: Andrew Wade <andrew.j.wade@gmail.com>
To: Bernardo Donadio <bcdonadio@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've had repeated lockups as well; I can trigger them by attempting to
copy files off of a damaged DVD.

I saw the btrfs_assert_delayed_root_empty warning as well, but not
during the lockup; instead I saw it on a boot after a lockup.

During the lockup I sometimes get a different message:

Dec  6 19:41:11 pluto kernel: [347280.104032] INFO: task init:1228
blocked for more than 120 seconds.
Dec  6 19:41:11 pluto kernel: [347280.104038]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:41:11 pluto kernel: [347280.104039] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:41:11 pluto kernel: [347280.104041] init            D
ffff88011fc13640     0  1228   1215 0x00000000
Dec  6 19:41:11 pluto kernel: [347280.104045]  ffff8800d82bbb88
0000000000000082 ffff8800361b1900 ffff8800d82bbfd8
Dec  6 19:41:11 pluto kernel: [347280.104048]  0000000000013640
0000000000013640 ffff8800b8f58000 ffff8800361b1900
Dec  6 19:41:11 pluto kernel: [347280.104050]  ffff8800d82bbc30
ffff88011fc13f40 ffff8800d82bbc30 ffff88011ffdd3e8
Dec  6 19:41:11 pluto kernel: [347280.104053] Call Trace:
Dec  6 19:41:11 pluto kernel: [347280.104061]  [<ffffffff817694b0>] ?
bit_wait+0x50/0x50
Dec  6 19:41:11 pluto kernel: [347280.104064]  [<ffffffff81768c91>]
io_schedule+0xa1/0x140
Dec  6 19:41:11 pluto kernel: [347280.104067]  [<ffffffff817694dc>]
bit_wait_io+0x2c/0x50
Dec  6 19:41:11 pluto kernel: [347280.104069]  [<ffffffff81769115>]
__wait_on_bit+0x65/0x90
Dec  6 19:41:11 pluto kernel: [347280.104073]  [<ffffffff813880c3>] ?
radix_tree_lookup_slot+0x13/0x30
Dec  6 19:41:11 pluto kernel: [347280.104077]  [<ffffffff811671b7>]
wait_on_page_bit+0xc7/0xd0
Dec  6 19:41:11 pluto kernel: [347280.104081]  [<ffffffff810ae5c0>] ?
autoremove_wake_function+0x40/0x40
Dec  6 19:41:11 pluto kernel: [347280.104109]  [<ffffffffa0260edc>]
prepare_pages.isra.19+0xac/0x1a0 [btrfs]
Dec  6 19:41:12 pluto kernel: [347280.104122]  [<ffffffffa0261acc>]
__btrfs_buffered_write+0x1cc/0x590 [btrfs]
Dec  6 19:41:12 pluto kernel: [347280.104126]  [<ffffffff8109a832>] ?
default_wake_function+0x12/0x20
Dec  6 19:41:12 pluto kernel: [347280.104128]  [<ffffffff810ae0c8>] ?
__wake_up+0x48/0x60
Dec  6 19:41:12 pluto kernel: [347280.104142]  [<ffffffffa0262117>]
btrfs_file_write_iter+0x287/0x4e0 [btrfs]
Dec  6 19:41:12 pluto kernel: [347280.104146]  [<ffffffff811dc591>]
new_sync_write+0x81/0xb0
Dec  6 19:41:12 pluto kernel: [347280.104148]  [<ffffffff811dceb7>]
vfs_write+0xb7/0x1f0
Dec  6 19:41:12 pluto kernel: [347280.104151]  [<ffffffff811dd936>]
SyS_write+0x46/0xb0
Dec  6 19:41:12 pluto kernel: [347280.104154]  [<ffffffff8176d06d>]
system_call_fastpath+0x16/0x1b
Dec  6 19:43:11 pluto kernel: [347400.104029] INFO: task khugepaged:27
blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104036]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104037] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104039] khugepaged      D
ffff88011fc93640     0    27      2 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104043]  ffff88011957bcd0
0000000000000046 ffff880119570000 ffff88011957bfd8
Dec  6 19:43:11 pluto kernel: [347400.104046]  0000000000013640
0000000000013640 ffff880119696400 ffff880119570000
Dec  6 19:43:11 pluto kernel: [347400.104049]  ffff880119420000
ffff880119570000 ffff88008f0166e0 ffff88008f0166f8
Dec  6 19:43:11 pluto kernel: [347400.104051] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104060]  [<ffffffff81768989>]
schedule+0x29/0x70
Dec  6 19:43:11 pluto kernel: [347400.104063]  [<ffffffff8176b705>]
rwsem_down_read_failed+0xe5/0x140
Dec  6 19:43:11 pluto kernel: [347400.104067]  [<ffffffff810d4c52>] ?
del_timer_sync+0x52/0x60
Dec  6 19:43:11 pluto kernel: [347400.104071]  [<ffffffff81390384>]
call_rwsem_down_read_failed+0x14/0x30
Dec  6 19:43:11 pluto kernel: [347400.104073]  [<ffffffff8176ad84>] ?
down_read+0x24/0x30
Dec  6 19:43:11 pluto kernel: [347400.104077]  [<ffffffff811c7b20>]
khugepaged+0x2e0/0x1220
Dec  6 19:43:11 pluto kernel: [347400.104081]  [<ffffffff810ae580>] ?
prepare_to_wait_event+0x110/0x110
Dec  6 19:43:11 pluto kernel: [347400.104083]  [<ffffffff811c7840>] ?
maybe_pmd_mkwrite+0x30/0x30
Dec  6 19:43:11 pluto kernel: [347400.104086]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 19:43:11 pluto kernel: [347400.104089]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 19:43:11 pluto kernel: [347400.104091]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 19:43:11 pluto kernel: [347400.104094]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 19:43:11 pluto kernel: [347400.104103] INFO: task
btrfs-transacti:665 blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104105]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104106] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104107] btrfs-transacti D
ffff88011fc93640     0   665      2 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104110]  ffff8800d6183988
0000000000000046 ffff880035fc3200 ffff8800d6183fd8
Dec  6 19:43:11 pluto kernel: [347400.104112]  0000000000013640
0000000000013640 ffff8800b8f58000 ffff880035fc3200
Dec  6 19:43:11 pluto kernel: [347400.104114]  ffff8800d6183a30
ffff88011fc93f40 ffff8800d6183a30 ffff88011ffd67e8
Dec  6 19:43:11 pluto kernel: [347400.104117] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104120]  [<ffffffff817694b0>] ?
bit_wait+0x50/0x50
Dec  6 19:43:11 pluto kernel: [347400.104122]  [<ffffffff81768c91>]
io_schedule+0xa1/0x140
Dec  6 19:43:11 pluto kernel: [347400.104124]  [<ffffffff817694dc>]
bit_wait_io+0x2c/0x50
Dec  6 19:43:11 pluto kernel: [347400.104127]  [<ffffffff81769115>]
__wait_on_bit+0x65/0x90
Dec  6 19:43:11 pluto kernel: [347400.104130]  [<ffffffff811671b7>]
wait_on_page_bit+0xc7/0xd0
Dec  6 19:43:11 pluto kernel: [347400.104133]  [<ffffffff810ae5c0>] ?
autoremove_wake_function+0x40/0x40
Dec  6 19:43:11 pluto kernel: [347400.104162]  [<ffffffffa027254a>]
read_extent_buffer_pages+0x2ca/0x300 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104173]  [<ffffffffa0245f60>] ?
free_root_pointers+0x60/0x60 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104185]  [<ffffffffa02471a3>]
btree_read_extent_buffer_pages.constprop.50+0xb3/0x120 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104197]  [<ffffffffa0248340>]
read_tree_block+0x40/0x70 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104206]  [<ffffffffa022906c>]
read_block_for_search.isra.33+0x12c/0x370 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104216]  [<ffffffffa022b33a>]
btrfs_search_slot+0x3ca/0xa20 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104227]  [<ffffffffa0246c2e>] ?
btree_set_page_dirty+0xe/0x10 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104238]  [<ffffffffa023eb87>]
btrfs_write_dirty_block_groups+0xe7/0x6d0 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104251]  [<ffffffffa02c3464>]
commit_cowonly_roots+0x17b/0x230 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104263]  [<ffffffffa024f602>]
btrfs_commit_transaction+0x432/0xa90 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104276]  [<ffffffffa024fcf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104288]  [<ffffffffa024b0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104299]  [<ffffffffa024af00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104302]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 19:43:11 pluto kernel: [347400.104304]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 19:43:11 pluto kernel: [347400.104307]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 19:43:11 pluto kernel: [347400.104309]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 19:43:11 pluto kernel: [347400.104317] INFO: task init:1228
blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104319]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104320] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104321] init            D
ffff88011fc13640     0  1228   1215 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104324]  ffff8800d82bbb88
0000000000000082 ffff8800361b1900 ffff8800d82bbfd8
Dec  6 19:43:11 pluto kernel: [347400.104326]  0000000000013640
0000000000013640 ffff8800b8f58000 ffff8800361b1900
Dec  6 19:43:11 pluto kernel: [347400.104329]  ffff8800d82bbc30
ffff88011fc13f40 ffff8800d82bbc30 ffff88011ffdd3e8
Dec  6 19:43:11 pluto kernel: [347400.104331] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104334]  [<ffffffff817694b0>] ?
bit_wait+0x50/0x50
Dec  6 19:43:11 pluto kernel: [347400.104336]  [<ffffffff81768c91>]
io_schedule+0xa1/0x140
Dec  6 19:43:11 pluto kernel: [347400.104338]  [<ffffffff817694dc>]
bit_wait_io+0x2c/0x50
Dec  6 19:43:11 pluto kernel: [347400.104341]  [<ffffffff81769115>]
__wait_on_bit+0x65/0x90
Dec  6 19:43:11 pluto kernel: [347400.104343]  [<ffffffff813880c3>] ?
radix_tree_lookup_slot+0x13/0x30
Dec  6 19:43:11 pluto kernel: [347400.104346]  [<ffffffff811671b7>]
wait_on_page_bit+0xc7/0xd0
Dec  6 19:43:11 pluto kernel: [347400.104349]  [<ffffffff810ae5c0>] ?
autoremove_wake_function+0x40/0x40
Dec  6 19:43:11 pluto kernel: [347400.104362]  [<ffffffffa0260edc>]
prepare_pages.isra.19+0xac/0x1a0 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104375]  [<ffffffffa0261acc>]
__btrfs_buffered_write+0x1cc/0x590 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104378]  [<ffffffff8109a832>] ?
default_wake_function+0x12/0x20
Dec  6 19:43:11 pluto kernel: [347400.104381]  [<ffffffff810ae0c8>] ?
__wake_up+0x48/0x60
Dec  6 19:43:11 pluto kernel: [347400.104394]  [<ffffffffa0262117>]
btrfs_file_write_iter+0x287/0x4e0 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104398]  [<ffffffff811dc591>]
new_sync_write+0x81/0xb0
Dec  6 19:43:11 pluto kernel: [347400.104401]  [<ffffffff811dceb7>]
vfs_write+0xb7/0x1f0
Dec  6 19:43:11 pluto kernel: [347400.104403]  [<ffffffff811dd936>]
SyS_write+0x46/0xb0
Dec  6 19:43:11 pluto kernel: [347400.104406]  [<ffffffff8176d06d>]
system_call_fastpath+0x16/0x1b
Dec  6 19:43:11 pluto kernel: [347400.104438] INFO: task firefox:3605
blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104440]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104441] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104442] firefox         D
ffff88011fc93640     0  3605   1664 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104445]  ffff8800226dbd30
0000000000000082 ffff88006e070000 ffff8800226dbfd8
Dec  6 19:43:11 pluto kernel: [347400.104447]  0000000000013640
0000000000013640 ffff880119b8b200 ffff88006e070000
Dec  6 19:43:11 pluto kernel: [347400.104450]  0000000000000000
ffff88006e070000 ffff88008f0166e0 ffff88008f0166f8
Dec  6 19:43:11 pluto kernel: [347400.104452] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104455]  [<ffffffff81768989>]
schedule+0x29/0x70
Dec  6 19:43:11 pluto kernel: [347400.104457]  [<ffffffff8176b705>]
rwsem_down_read_failed+0xe5/0x140
Dec  6 19:43:11 pluto kernel: [347400.104461]  [<ffffffff811f7cb0>] ?
touch_atime+0x110/0x140
Dec  6 19:43:11 pluto kernel: [347400.104464]  [<ffffffff81390384>]
call_rwsem_down_read_failed+0x14/0x30
Dec  6 19:43:11 pluto kernel: [347400.104466]  [<ffffffff8176ad84>] ?
down_read+0x24/0x30
Dec  6 19:43:11 pluto kernel: [347400.104470]  [<ffffffff8105d221>]
__do_page_fault+0x1f1/0x550
Dec  6 19:43:11 pluto kernel: [347400.104472]  [<ffffffff8109f248>] ?
__enqueue_entity+0x78/0x80
Dec  6 19:43:11 pluto kernel: [347400.104475]  [<ffffffff810a104d>] ?
set_next_entity+0x9d/0xb0
Dec  6 19:43:11 pluto kernel: [347400.104477]  [<ffffffff810a8e4b>] ?
pick_next_task_fair+0x61b/0x880
Dec  6 19:43:11 pluto kernel: [347400.104481]  [<ffffffff81011625>] ?
__switch_to+0x165/0x590
Dec  6 19:43:11 pluto kernel: [347400.104484]  [<ffffffff8105d5b1>]
do_page_fault+0x31/0x70
Dec  6 19:43:11 pluto kernel: [347400.104486]  [<ffffffff8176f068>]
page_fault+0x28/0x30
Dec  6 19:43:11 pluto kernel: [347400.104489] INFO: task Socket
Thread:3610 blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104490]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104491] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104492] Socket Thread   D
ffff88011fc93640     0  3610   1664 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104495]  ffff880100bafd30
0000000000000082 ffff88006e1c1900 ffff880100baffd8
Dec  6 19:43:11 pluto kernel: [347400.104497]  0000000000013640
0000000000013640 ffff880119b8b200 ffff88006e1c1900
Dec  6 19:43:11 pluto kernel: [347400.104500]  000000000000058a
ffff88006e1c1900 ffff88008f0166e0 ffff88008f0166f8
Dec  6 19:43:11 pluto kernel: [347400.104502] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104505]  [<ffffffff81768989>]
schedule+0x29/0x70
Dec  6 19:43:11 pluto kernel: [347400.104507]  [<ffffffff8176b705>]
rwsem_down_read_failed+0xe5/0x140
Dec  6 19:43:11 pluto kernel: [347400.104510]  [<ffffffff81390384>]
call_rwsem_down_read_failed+0x14/0x30
Dec  6 19:43:11 pluto kernel: [347400.104513]  [<ffffffff8176ad84>] ?
down_read+0x24/0x30
Dec  6 19:43:11 pluto kernel: [347400.104515]  [<ffffffff8105d221>]
__do_page_fault+0x1f1/0x550
Dec  6 19:43:11 pluto kernel: [347400.104518]  [<ffffffff811f3993>] ?
__dentry_kill+0x173/0x210
Dec  6 19:43:11 pluto kernel: [347400.104520]  [<ffffffff811f3ad5>] ?
dput+0xa5/0x180
Dec  6 19:43:11 pluto kernel: [347400.104523]  [<ffffffff811fcc34>] ?
mntput+0x24/0x40
Dec  6 19:43:11 pluto kernel: [347400.104525]  [<ffffffff811de900>] ?
__fput+0x190/0x220
Dec  6 19:43:11 pluto kernel: [347400.104528]  [<ffffffff8105d5b1>]
do_page_fault+0x31/0x70
Dec  6 19:43:11 pluto kernel: [347400.104530]  [<ffffffff8176f068>]
page_fault+0x28/0x30
Dec  6 19:43:11 pluto kernel: [347400.104533] INFO: task JS
Watchdog:3617 blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104535]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104536] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104537] JS Watchdog     D
ffff88011fc93640     0  3617   1664 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104540]  ffff880006193e18
0000000000000082 ffff880119573200 ffff880006193fd8
Dec  6 19:43:11 pluto kernel: [347400.104542]  0000000000013640
0000000000013640 ffff8800b8f58000 ffff880119573200
Dec  6 19:43:11 pluto kernel: [347400.104544]  00003ffffffff000
ffff880119573200 ffff88008f0166f8 ffff88008f0166e0
Dec  6 19:43:11 pluto kernel: [347400.104547] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104549]  [<ffffffff81768989>]
schedule+0x29/0x70
Dec  6 19:43:11 pluto kernel: [347400.104552]  [<ffffffff8176b48d>]
rwsem_down_write_failed+0x1dd/0x370
Dec  6 19:43:11 pluto kernel: [347400.104555]  [<ffffffff810b655d>] ?
__rwsem_do_wake+0xed/0x170
Dec  6 19:43:11 pluto kernel: [347400.104558]  [<ffffffff813903b3>]
call_rwsem_down_write_failed+0x13/0x20
Dec  6 19:43:11 pluto kernel: [347400.104560]  [<ffffffff8176adc1>] ?
down_write+0x31/0x50
Dec  6 19:43:11 pluto kernel: [347400.104564]  [<ffffffff8119e5c1>]
SyS_mprotect+0xc1/0x270
Dec  6 19:43:11 pluto kernel: [347400.104567]  [<ffffffff8176d06d>]
system_call_fastpath+0x16/0x1b
Dec  6 19:43:11 pluto kernel: [347400.104569] INFO: task Cache2
I/O:3623 blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104571]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104572] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104573] Cache2 I/O      D
ffff88011fc93640     0  3623   1664 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104576]  ffff8800061cbb38
0000000000000082 ffff8800aa620000 ffff8800061cbfd8
Dec  6 19:43:11 pluto kernel: [347400.104578]  0000000000013640
0000000000013640 ffff880119b8b200 ffff8800aa620000
Dec  6 19:43:11 pluto kernel: [347400.104581]  ffff8800061cbb48
ffff8800c7cfdb40 ffff8800daf0c1f0 ffff8800daf0c1f0
Dec  6 19:43:11 pluto kernel: [347400.104583] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104586]  [<ffffffff81768989>]
schedule+0x29/0x70
Dec  6 19:43:11 pluto kernel: [347400.104598]  [<ffffffffa024e7cf>]
wait_current_trans.isra.20+0x9f/0x100 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104601]  [<ffffffff810ae580>] ?
prepare_to_wait_event+0x110/0x110
Dec  6 19:43:11 pluto kernel: [347400.104613]  [<ffffffffa024ffdf>]
start_transaction+0x37f/0x590 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104625]  [<ffffffffa025020b>]
btrfs_start_transaction+0x1b/0x20 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104638]  [<ffffffffa025de7b>]
btrfs_create+0x3b/0x210 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104642]  [<ffffffff812f67fc>] ?
security_inode_permission+0x1c/0x30
Dec  6 19:43:11 pluto kernel: [347400.104644]  [<ffffffff811e89b5>]
vfs_create+0xd5/0x140
Dec  6 19:43:11 pluto kernel: [347400.104646]  [<ffffffff811ec153>]
do_last+0x1013/0x1210
Dec  6 19:43:11 pluto kernel: [347400.104649]  [<ffffffff811e73f8>] ?
inode_permission+0x18/0x50
Dec  6 19:43:11 pluto kernel: [347400.104651]  [<ffffffff811e9969>] ?
link_path_walk+0x69/0x820
Dec  6 19:43:11 pluto kernel: [347400.104655]  [<ffffffff81332200>] ?
apparmor_ptrace_access_check+0x20/0x40
Dec  6 19:43:11 pluto kernel: [347400.104657]  [<ffffffff812f6b46>] ?
security_file_alloc+0x16/0x20
Dec  6 19:43:11 pluto kernel: [347400.104659]  [<ffffffff811ec404>]
path_openat+0xb4/0x640
Dec  6 19:43:11 pluto kernel: [347400.104662]  [<ffffffff810a3bc4>] ?
update_curr+0xe4/0x180
Dec  6 19:43:11 pluto kernel: [347400.104664]  [<ffffffff810ade68>] ?
__wake_up_common+0x58/0x90
Dec  6 19:43:11 pluto kernel: [347400.104667]  [<ffffffff811edb2a>]
do_filp_open+0x3a/0x90
Dec  6 19:43:11 pluto kernel: [347400.104669]  [<ffffffff811fa8d7>] ?
__alloc_fd+0xa7/0x130
Dec  6 19:43:11 pluto kernel: [347400.104672]  [<ffffffff811dbeb8>]
do_sys_open+0x128/0x220
Dec  6 19:43:11 pluto kernel: [347400.104675]  [<ffffffff811dbfce>]
SyS_open+0x1e/0x20
Dec  6 19:43:11 pluto kernel: [347400.104677]  [<ffffffff8176d06d>]
system_call_fastpath+0x16/0x1b
Dec  6 19:43:11 pluto kernel: [347400.104680] INFO: task mozStorage
#1:3637 blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104682]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104683] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104684] mozStorage #1   D
ffff88011fc93640     0  3637   1664 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104686]  ffff880006203a58
0000000000000082 ffff8800361b0000 ffff880006203fd8
Dec  6 19:43:11 pluto kernel: [347400.104689]  0000000000013640
0000000000013640 ffff88006e070000 ffff8800361b0000
Dec  6 19:43:11 pluto kernel: [347400.104691]  ffff880006203a68
ffff8800c7cfdb40 ffff8800daf0c1f0 ffff8800daf0c1f0
Dec  6 19:43:11 pluto kernel: [347400.104694] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104696]  [<ffffffff81768989>]
schedule+0x29/0x70
Dec  6 19:43:11 pluto kernel: [347400.104708]  [<ffffffffa024e7cf>]
wait_current_trans.isra.20+0x9f/0x100 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104711]  [<ffffffff810ae580>] ?
prepare_to_wait_event+0x110/0x110
Dec  6 19:43:11 pluto kernel: [347400.104723]  [<ffffffffa024ff00>]
start_transaction+0x2a0/0x590 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104736]  [<ffffffffa0250247>]
btrfs_join_transaction+0x17/0x20 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104748]  [<ffffffffa0255d98>]
btrfs_dirty_inode+0x48/0xe0 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104758]  [<ffffffffa022f17b>] ?
block_rsv_add_bytes+0x4b/0x60 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104770]  [<ffffffffa0255e94>]
btrfs_update_time+0x64/0xd0 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104773]  [<ffffffff811f7b05>]
update_time+0x25/0xc0
Dec  6 19:43:11 pluto kernel: [347400.104776]  [<ffffffff810d2aa6>] ?
current_fs_time+0x16/0x60
Dec  6 19:43:11 pluto kernel: [347400.104778]  [<ffffffff811f7d60>]
file_update_time+0x80/0xd0
Dec  6 19:43:11 pluto kernel: [347400.104791]  [<ffffffffa025ee6c>]
btrfs_page_mkwrite+0xac/0x310 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104805]  [<ffffffffa026b951>] ?
free_extent_state+0x21/0x30 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104808]  [<ffffffff81191c8d>]
do_page_mkwrite+0x3d/0x70
Dec  6 19:43:11 pluto kernel: [347400.104811]  [<ffffffff81193e27>]
do_wp_page+0x627/0x770
Dec  6 19:43:11 pluto kernel: [347400.104814]  [<ffffffff8119624c>]
handle_mm_fault+0x80c/0x10f0
Dec  6 19:43:11 pluto kernel: [347400.104817]  [<ffffffff8105d1ce>]
__do_page_fault+0x19e/0x550
Dec  6 19:43:11 pluto kernel: [347400.104819]  [<ffffffff811df375>] ?
__sb_end_write+0x35/0x70
Dec  6 19:43:11 pluto kernel: [347400.104822]  [<ffffffff811dcf72>] ?
vfs_write+0x172/0x1f0
Dec  6 19:43:11 pluto kernel: [347400.104824]  [<ffffffff8105d5b1>]
do_page_fault+0x31/0x70
Dec  6 19:43:11 pluto kernel: [347400.104827]  [<ffffffff8176f068>]
page_fault+0x28/0x30
Dec  6 19:43:11 pluto kernel: [347400.104831] INFO: task mozStorage
#9:3683 blocked for more than 120 seconds.
Dec  6 19:43:11 pluto kernel: [347400.104832]       Tainted: G
   E  3.18.0-rc7-ajw #78
Dec  6 19:43:11 pluto kernel: [347400.104833] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  6 19:43:11 pluto kernel: [347400.104834] mozStorage #9   D
ffff88011fc93640     0  3683   1664 0x00000000
Dec  6 19:43:11 pluto kernel: [347400.104837]  ffff88008b877b38
0000000000000082 ffff8800dae8cb00 ffff88008b877fd8
Dec  6 19:43:11 pluto kernel: [347400.104839]  0000000000013640
0000000000013640 ffff88006e070000 ffff8800dae8cb00
Dec  6 19:43:11 pluto kernel: [347400.104842]  ffff88008b877b48
ffff8800c7cfdb40 ffff8800daf0c1f0 ffff8800daf0c1f0
Dec  6 19:43:11 pluto kernel: [347400.104844] Call Trace:
Dec  6 19:43:11 pluto kernel: [347400.104847]  [<ffffffff81768989>]
schedule+0x29/0x70
Dec  6 19:43:11 pluto kernel: [347400.104859]  [<ffffffffa024e7cf>]
wait_current_trans.isra.20+0x9f/0x100 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104862]  [<ffffffff810ae580>] ?
prepare_to_wait_event+0x110/0x110
Dec  6 19:43:11 pluto kernel: [347400.104874]  [<ffffffffa024ffdf>]
start_transaction+0x37f/0x590 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104886]  [<ffffffffa025020b>]
btrfs_start_transaction+0x1b/0x20 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104899]  [<ffffffffa025de7b>]
btrfs_create+0x3b/0x210 [btrfs]
Dec  6 19:43:11 pluto kernel: [347400.104901]  [<ffffffff812f67fc>] ?
security_inode_permission+0x1c/0x30
Dec  6 19:43:11 pluto kernel: [347400.104903]  [<ffffffff811e89b5>]
vfs_create+0xd5/0x140
Dec  6 19:43:11 pluto kernel: [347400.104906]  [<ffffffff811ec153>]
do_last+0x1013/0x1210
Dec  6 19:43:11 pluto kernel: [347400.104908]  [<ffffffff811e73f8>] ?
inode_permission+0x18/0x50
Dec  6 19:43:11 pluto kernel: [347400.104910]  [<ffffffff811e9969>] ?
link_path_walk+0x69/0x820
Dec  6 19:43:11 pluto kernel: [347400.104913]  [<ffffffff81332200>] ?
apparmor_ptrace_access_check+0x20/0x40
Dec  6 19:43:11 pluto kernel: [347400.104915]  [<ffffffff812f6b46>] ?
security_file_alloc+0x16/0x20
Dec  6 19:43:11 pluto kernel: [347400.104917]  [<ffffffff811ec404>]
path_openat+0xb4/0x640
Dec  6 19:43:11 pluto kernel: [347400.104919]  [<ffffffff811ecc59>] ?
putname+0x29/0x40
Dec  6 19:43:11 pluto kernel: [347400.104921]  [<ffffffff811eda2f>] ?
user_path_at_empty+0x5f/0xa0
Dec  6 19:43:11 pluto kernel: [347400.104924]  [<ffffffff811edb2a>]
do_filp_open+0x3a/0x90
Dec  6 19:43:11 pluto kernel: [347400.104926]  [<ffffffff811fa8d7>] ?
__alloc_fd+0xa7/0x130
Dec  6 19:43:11 pluto kernel: [347400.104929]  [<ffffffff811dbeb8>]
do_sys_open+0x128/0x220
Dec  6 19:43:11 pluto kernel: [347400.104932]  [<ffffffff811dbfce>]
SyS_open+0x1e/0x20
Dec  6 19:43:11 pluto kernel: [347400.104934]  [<ffffffff8176d06d>]
system_call_fastpath+0x16/0x1b

After a couple of hard resets I got the errors below. In the session
with the errors below I was able to shutdown cleanly:

Dec  6 20:43:26 pluto kernel: [   77.297712] ------------[ cut here
]------------
Dec  6 20:43:26 pluto kernel: [   77.297747] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:43:26 pluto kernel: [   77.297749] Modules linked in:
bnep(E) rfcomm(E) bluetooth(E) snd_hda_codec_via(E) joydev(E)
snd_hda_codec_generic(E) snd_hda_intel(E) snd_hda_controller(E)
snd_hda_codec(E) snd_hwdep(E) snd_pcm(E) snd_seq_midi(E)
snd_seq_midi_event(E) snd_rawmidi(E) snd_seq(E) snd_seq_device(E)
snd_timer(E) snd(E) soundcore(E) coretemp(E) lpc_ich(E) serio_raw(E)
asus_atk0110(E) mac_hid(E) parport_pc(E) ppdev(E) lp(E) parport(E)
btrfs(E) xor(E) raid6_pq(E) hid_generic(E) usbhid(E) hid(E) psmouse(E)
atl1e(E) i915(E) video(E) i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:43:26 pluto kernel: [   77.297775] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:43:26 pluto kernel: [   77.297777] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:43:26 pluto kernel: [   77.297779]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:43:26 pluto kernel: [   77.297781]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800d9c0c0b8
Dec  6 20:43:26 pluto kernel: [   77.297784]  ffff8800d9e93780
ffff8800d8ec4800 ffff8800d9c0c000 ffff8800da8fc1a0
Dec  6 20:43:26 pluto kernel: [   77.297786] Call Trace:
Dec  6 20:43:26 pluto kernel: [   77.297793]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:43:26 pluto kernel: [   77.297797]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:43:26 pluto kernel: [   77.297800]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:43:26 pluto kernel: [   77.297814]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:43:26 pluto kernel: [   77.297826]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:43:26 pluto kernel: [   77.297839]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:43:26 pluto kernel: [   77.297851]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:43:26 pluto kernel: [   77.297863]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:43:26 pluto kernel: [   77.297866]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:43:26 pluto kernel: [   77.297868]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:43:26 pluto kernel: [   77.297872]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:43:26 pluto kernel: [   77.297874]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:43:26 pluto kernel: [   77.297876] ---[ end trace
f2fbb6fd3e4e0d99 ]---
Dec  6 20:43:49 pluto kernel: [  100.439860] UDF-fs: INFO Mounting
volume 'Stuff for Mugg', timestamp 2006/09/17 18:21 (1ed4)
Dec  6 20:43:58 pluto kernel: [  109.922161] ------------[ cut here
]------------
Dec  6 20:43:58 pluto kernel: [  109.922198] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:43:58 pluto kernel: [  109.922200] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:43:58 pluto kernel: [  109.922228] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:43:58 pluto kernel: [  109.922229] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:43:58 pluto kernel: [  109.922231]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:43:58 pluto kernel: [  109.922233]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800b5e4c0b8
Dec  6 20:43:58 pluto kernel: [  109.922236]  ffff8800d5b4d1e0
ffff8800d8ec4800 ffff8800b5e4c000 ffff8800da8fc1a0
Dec  6 20:43:58 pluto kernel: [  109.922239] Call Trace:
Dec  6 20:43:58 pluto kernel: [  109.922246]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:43:58 pluto kernel: [  109.922250]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:43:58 pluto kernel: [  109.922253]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:43:58 pluto kernel: [  109.922267]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:43:58 pluto kernel: [  109.922279]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:43:58 pluto kernel: [  109.922292]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:43:58 pluto kernel: [  109.922304]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:43:58 pluto kernel: [  109.922316]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:43:58 pluto kernel: [  109.922319]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:43:58 pluto kernel: [  109.922321]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:43:58 pluto kernel: [  109.922325]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:43:58 pluto kernel: [  109.922328]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:43:58 pluto kernel: [  109.922329] ---[ end trace
f2fbb6fd3e4e0d9a ]---
Dec  6 20:44:35 pluto kernel: [  146.375065] ------------[ cut here
]------------
Dec  6 20:44:35 pluto kernel: [  146.375101] WARNING: CPU: 0 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:44:35 pluto kernel: [  146.375102] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:44:35 pluto kernel: [  146.375130] CPU: 0 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:44:35 pluto kernel: [  146.375132] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:44:35 pluto kernel: [  146.375133]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:44:35 pluto kernel: [  146.375136]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800d9c0c0b8
Dec  6 20:44:35 pluto kernel: [  146.375138]  ffff8800d9c31be0
ffff8800d8ec4800 ffff8800d9c0c000 ffff8800da8fc1a0
Dec  6 20:44:35 pluto kernel: [  146.375141] Call Trace:
Dec  6 20:44:35 pluto kernel: [  146.375147]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:44:35 pluto kernel: [  146.375152]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:44:35 pluto kernel: [  146.375154]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:44:35 pluto kernel: [  146.375168]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:44:35 pluto kernel: [  146.375181]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:44:35 pluto kernel: [  146.375193]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:44:35 pluto kernel: [  146.375205]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:44:35 pluto kernel: [  146.375217]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:44:35 pluto kernel: [  146.375220]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:44:35 pluto kernel: [  146.375223]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:44:35 pluto kernel: [  146.375226]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:44:35 pluto kernel: [  146.375228]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:44:35 pluto kernel: [  146.375230] ---[ end trace
f2fbb6fd3e4e0d9b ]---
Dec  6 20:45:16 pluto kernel: [  187.676554] ------------[ cut here
]------------
Dec  6 20:45:16 pluto kernel: [  187.676595] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:45:16 pluto kernel: [  187.676598] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:45:16 pluto kernel: [  187.676639] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:45:16 pluto kernel: [  187.676641] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:45:16 pluto kernel: [  187.676643]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:45:16 pluto kernel: [  187.676647]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800b5e4c1a8
Dec  6 20:45:16 pluto kernel: [  187.676651]  ffff88007eb9cdc0
ffff8800d8ec4800 ffff8800b5e4c0f0 ffff8800da8fc1a0
Dec  6 20:45:16 pluto kernel: [  187.676655] Call Trace:
Dec  6 20:45:16 pluto kernel: [  187.676663]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:45:16 pluto kernel: [  187.676669]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:45:16 pluto kernel: [  187.676673]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:45:16 pluto kernel: [  187.676695]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:45:16 pluto kernel: [  187.676714]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:45:16 pluto kernel: [  187.676733]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:45:16 pluto kernel: [  187.676752]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:45:16 pluto kernel: [  187.676771]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:45:16 pluto kernel: [  187.676775]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:45:16 pluto kernel: [  187.676779]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:45:16 pluto kernel: [  187.676784]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:45:16 pluto kernel: [  187.676788]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:45:16 pluto kernel: [  187.676790] ---[ end trace
f2fbb6fd3e4e0d9c ]---
Dec  6 20:45:55 pluto kernel: [  226.634233] ------------[ cut here
]------------
Dec  6 20:45:55 pluto kernel: [  226.634281] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:45:55 pluto kernel: [  226.634284] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:45:55 pluto kernel: [  226.634336] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:45:55 pluto kernel: [  226.634340] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:45:55 pluto kernel: [  226.634342]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:45:55 pluto kernel: [  226.634348]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800b5e4c298
Dec  6 20:45:55 pluto kernel: [  226.634353]  ffff88007eb9c460
ffff8800d8ec4800 ffff8800b5e4c1e0 ffff8800da8fc1a0
Dec  6 20:45:55 pluto kernel: [  226.634358] Call Trace:
Dec  6 20:45:55 pluto kernel: [  226.634368]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:45:55 pluto kernel: [  226.634375]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:45:55 pluto kernel: [  226.634380]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:45:55 pluto kernel: [  226.634410]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:45:55 pluto kernel: [  226.634435]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:45:55 pluto kernel: [  226.634461]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:45:55 pluto kernel: [  226.634486]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:45:55 pluto kernel: [  226.634511]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:45:55 pluto kernel: [  226.634517]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:45:55 pluto kernel: [  226.634522]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:45:55 pluto kernel: [  226.634528]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:45:55 pluto kernel: [  226.634533]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:45:55 pluto kernel: [  226.634536] ---[ end trace
f2fbb6fd3e4e0d9d ]---
Dec  6 20:46:30 pluto kernel: [  262.177167] ------------[ cut here
]------------
Dec  6 20:46:30 pluto kernel: [  262.177202] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:46:30 pluto kernel: [  262.177204] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:46:30 pluto kernel: [  262.177232] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:46:30 pluto kernel: [  262.177233] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:46:30 pluto kernel: [  262.177235]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:46:30 pluto kernel: [  262.177237]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800b5e4c1a8
Dec  6 20:46:30 pluto kernel: [  262.177240]  ffff8800c02548c0
ffff8800d8ec4800 ffff8800b5e4c0f0 ffff8800da8fc1a0
Dec  6 20:46:30 pluto kernel: [  262.177242] Call Trace:
Dec  6 20:46:30 pluto kernel: [  262.177249]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:46:30 pluto kernel: [  262.177253]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:46:30 pluto kernel: [  262.177255]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:46:30 pluto kernel: [  262.177269]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:46:30 pluto kernel: [  262.177282]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:46:30 pluto kernel: [  262.177294]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:46:30 pluto kernel: [  262.177307]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:46:30 pluto kernel: [  262.177318]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:46:30 pluto kernel: [  262.177322]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:46:30 pluto kernel: [  262.177324]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:46:30 pluto kernel: [  262.177328]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:46:30 pluto kernel: [  262.177330]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:46:30 pluto kernel: [  262.177332] ---[ end trace
f2fbb6fd3e4e0d9e ]---
Dec  6 20:46:35 pluto kernel: [  266.504104] usb 3-1: USB disconnect,
device number 2
Dec  6 20:46:36 pluto kernel: [  267.896063] usb 3-1: new low-speed
USB device number 3 using uhci_hcd
Dec  6 20:46:36 pluto kernel: [  268.073875] usb 3-1: New USB device
found, idVendor=19ff, idProduct=0238
Dec  6 20:46:36 pluto kernel: [  268.073883] usb 3-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=0
Dec  6 20:46:36 pluto kernel: [  268.073888] usb 3-1: Product:
DynexWired USB Optical Mouse
Dec  6 20:46:36 pluto kernel: [  268.073892] usb 3-1: Manufacturer: PixArt
Dec  6 20:46:36 pluto kernel: [  268.093492] input: PixArt DynexWired
USB Optical Mouse as
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/0003:19FF:0238.0004/input/input16
Dec  6 20:46:36 pluto kernel: [  268.093739] hid-generic
0003:19FF:0238.0004: input,hidraw2: USB HID v1.11 Mouse [PixArt
DynexWired USB Optical Mouse] on usb-0000:00:1d.1-1/input0
Dec  6 20:47:05 pluto kernel: [  296.353457] ------------[ cut here
]------------
Dec  6 20:47:05 pluto kernel: [  296.353492] WARNING: CPU: 0 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:47:05 pluto kernel: [  296.353494] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:47:05 pluto kernel: [  296.353522] CPU: 0 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:47:05 pluto kernel: [  296.353524] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:47:05 pluto kernel: [  296.353526]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:47:05 pluto kernel: [  296.353528]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800d9c0c0b8
Dec  6 20:47:05 pluto kernel: [  296.353531]  ffff8801162760a0
ffff8800d8ec4800 ffff8800d9c0c000 ffff8800da8fc1a0
Dec  6 20:47:05 pluto kernel: [  296.353533] Call Trace:
Dec  6 20:47:05 pluto kernel: [  296.353540]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:47:05 pluto kernel: [  296.353544]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:47:05 pluto kernel: [  296.353546]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:47:05 pluto kernel: [  296.353560]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:47:05 pluto kernel: [  296.353573]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:47:05 pluto kernel: [  296.353585]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:47:05 pluto kernel: [  296.353598]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:47:05 pluto kernel: [  296.353609]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:47:05 pluto kernel: [  296.353613]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:47:05 pluto kernel: [  296.353615]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:47:05 pluto kernel: [  296.353619]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:47:05 pluto kernel: [  296.353621]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:47:05 pluto kernel: [  296.353623] ---[ end trace
f2fbb6fd3e4e0d9f ]---
Dec  6 20:47:38 pluto kernel: [  330.118574] ------------[ cut here
]------------
Dec  6 20:47:38 pluto kernel: [  330.118612] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:47:38 pluto kernel: [  330.118614] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:47:38 pluto kernel: [  330.118642] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:47:38 pluto kernel: [  330.118643] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:47:38 pluto kernel: [  330.118645]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:47:38 pluto kernel: [  330.118648]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800d9c0c1a8
Dec  6 20:47:38 pluto kernel: [  330.118650]  ffff8800c0254500
ffff8800d8ec4800 ffff8800d9c0c0f0 ffff8800da8fc1a0
Dec  6 20:47:38 pluto kernel: [  330.118653] Call Trace:
Dec  6 20:47:38 pluto kernel: [  330.118659]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:47:38 pluto kernel: [  330.118663]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:47:38 pluto kernel: [  330.118666]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:47:38 pluto kernel: [  330.118680]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:47:38 pluto kernel: [  330.118692]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:47:38 pluto kernel: [  330.118705]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:47:38 pluto kernel: [  330.118717]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:47:38 pluto kernel: [  330.118729]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:47:38 pluto kernel: [  330.118732]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:47:38 pluto kernel: [  330.118735]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:47:38 pluto kernel: [  330.118738]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:47:38 pluto kernel: [  330.118741]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:47:38 pluto kernel: [  330.118742] ---[ end trace
f2fbb6fd3e4e0da0 ]---
Dec  6 20:48:14 pluto kernel: [  365.783231] ------------[ cut here
]------------
Dec  6 20:48:14 pluto kernel: [  365.783274] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:48:14 pluto kernel: [  365.783275] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:48:14 pluto kernel: [  365.783303] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:48:14 pluto kernel: [  365.783305] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:48:14 pluto kernel: [  365.783306]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:48:14 pluto kernel: [  365.783309]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800d9c0c1a8
Dec  6 20:48:14 pluto kernel: [  365.783311]  ffff88007eb9cbe0
ffff8800d8ec4800 ffff8800d9c0c0f0 ffff8800da8fc1a0
Dec  6 20:48:14 pluto kernel: [  365.783314] Call Trace:
Dec  6 20:48:14 pluto kernel: [  365.783321]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:48:14 pluto kernel: [  365.783325]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:48:14 pluto kernel: [  365.783327]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:48:14 pluto kernel: [  365.783341]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:48:14 pluto kernel: [  365.783354]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:48:14 pluto kernel: [  365.783366]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:48:14 pluto kernel: [  365.783378]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:48:14 pluto kernel: [  365.783390]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:48:14 pluto kernel: [  365.783393]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:48:14 pluto kernel: [  365.783396]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:48:14 pluto kernel: [  365.783400]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:48:14 pluto kernel: [  365.783402]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:48:14 pluto kernel: [  365.783404] ---[ end trace
f2fbb6fd3e4e0da1 ]---
Dec  6 20:48:30 pluto kernel: [  381.576084] usb 3-1: USB disconnect,
device number 3
Dec  6 20:48:31 pluto kernel: [  383.040035] usb 3-1: new low-speed
USB device number 4 using uhci_hcd
Dec  6 20:48:31 pluto kernel: [  383.217855] usb 3-1: New USB device
found, idVendor=19ff, idProduct=0238
Dec  6 20:48:31 pluto kernel: [  383.217862] usb 3-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=0
Dec  6 20:48:31 pluto kernel: [  383.217867] usb 3-1: Product:
DynexWired USB Optical Mouse
Dec  6 20:48:31 pluto kernel: [  383.217871] usb 3-1: Manufacturer: PixArt
Dec  6 20:48:31 pluto kernel: [  383.237747] input: PixArt DynexWired
USB Optical Mouse as
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/0003:19FF:0238.0005/input/input17
Dec  6 20:48:31 pluto kernel: [  383.238083] hid-generic
0003:19FF:0238.0005: input,hidraw2: USB HID v1.11 Mouse [PixArt
DynexWired USB Optical Mouse] on usb-0000:00:1d.1-1/input0
Dec  6 20:50:15 pluto kernel: [  486.575362] ------------[ cut here
]------------
Dec  6 20:50:15 pluto kernel: [  486.575413] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:50:15 pluto kernel: [  486.575414] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:50:15 pluto kernel: [  486.575475] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:50:15 pluto kernel: [  486.575477] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:50:15 pluto kernel: [  486.575479]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 000000007b607b60
Dec  6 20:50:15 pluto kernel: [  486.575483]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800d9c0c1a8
Dec  6 20:50:15 pluto kernel: [  486.575487]  ffff8800bf8d70a0
ffff8800d8ec4800 ffff8800d9c0c0f0 ffff8800da8fc1a0
Dec  6 20:50:15 pluto kernel: [  486.575490] Call Trace:
Dec  6 20:50:15 pluto kernel: [  486.575493]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:50:15 pluto kernel: [  486.575501]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:50:15 pluto kernel: [  486.575507]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:50:15 pluto kernel: [  486.575512]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:50:15 pluto kernel: [  486.575539]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:50:15 pluto kernel: [  486.575563]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:50:15 pluto kernel: [  486.575588]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:50:15 pluto kernel: [  486.575611]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:50:15 pluto kernel: [  486.575633]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:50:15 pluto kernel: [  486.575638]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:50:15 pluto kernel: [  486.575641]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:50:15 pluto kernel: [  486.575646]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:50:15 pluto kernel: [  486.575650] ---[ end trace
f2fbb6fd3e4e0da2 ]---
Dec  6 20:50:38 pluto kernel: [  509.544080] usb 3-1: USB disconnect,
device number 4
Dec  6 20:50:39 pluto kernel: [  511.000037] usb 3-1: new low-speed
USB device number 5 using uhci_hcd
Dec  6 20:50:39 pluto kernel: [  511.177046] usb 3-1: New USB device
found, idVendor=19ff, idProduct=0238
Dec  6 20:50:39 pluto kernel: [  511.177054] usb 3-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=0
Dec  6 20:50:39 pluto kernel: [  511.177059] usb 3-1: Product:
DynexWired USB Optical Mouse
Dec  6 20:50:39 pluto kernel: [  511.177063] usb 3-1: Manufacturer: PixArt
Dec  6 20:50:39 pluto kernel: [  511.196961] input: PixArt DynexWired
USB Optical Mouse as
/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/0003:19FF:0238.0006/input/input18
Dec  6 20:50:39 pluto kernel: [  511.197306] hid-generic
0003:19FF:0238.0006: input,hidraw2: USB HID v1.11 Mouse [PixArt
DynexWired USB Optical Mouse] on usb-0000:00:1d.1-1/input0
Dec  6 20:50:50 pluto kernel: [  522.101424] ------------[ cut here
]------------
Dec  6 20:50:50 pluto kernel: [  522.101472] WARNING: CPU: 1 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:50:50 pluto kernel: [  522.101476] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:50:50 pluto kernel: [  522.101528] CPU: 1 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:50:50 pluto kernel: [  522.101531] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:50:50 pluto kernel: [  522.101534]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:50:50 pluto kernel: [  522.101539]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800d9c0c0b8
Dec  6 20:50:50 pluto kernel: [  522.101544]  ffff8800d9e93460
ffff8800d8ec4800 ffff8800d9c0c000 ffff8800da8fc1a0
Dec  6 20:50:50 pluto kernel: [  522.101550] Call Trace:
Dec  6 20:50:50 pluto kernel: [  522.101560]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:50:50 pluto kernel: [  522.101567]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:50:50 pluto kernel: [  522.101572]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:50:50 pluto kernel: [  522.101601]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:50:50 pluto kernel: [  522.101627]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:50:50 pluto kernel: [  522.101652]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:50:50 pluto kernel: [  522.101678]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:50:50 pluto kernel: [  522.101702]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:50:50 pluto kernel: [  522.101708]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:50:50 pluto kernel: [  522.101713]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:50:50 pluto kernel: [  522.101720]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:50:50 pluto kernel: [  522.101724]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:50:50 pluto kernel: [  522.101728] ---[ end trace
f2fbb6fd3e4e0da3 ]---
Dec  6 20:52:11 pluto kernel: [  602.588612] ------------[ cut here
]------------
Dec  6 20:52:11 pluto kernel: [  602.588659] WARNING: CPU: 0 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:52:11 pluto kernel: [  602.588662] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:52:11 pluto kernel: [  602.588714] CPU: 0 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:52:11 pluto kernel: [  602.588717] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:52:11 pluto kernel: [  602.588720]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:52:11 pluto kernel: [  602.588726]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800d9c0c298
Dec  6 20:52:11 pluto kernel: [  602.588731]  ffff8800835f1500
ffff8800d8ec4800 ffff8800d9c0c1e0 ffff8800da8fc1a0
Dec  6 20:52:11 pluto kernel: [  602.588736] Call Trace:
Dec  6 20:52:11 pluto kernel: [  602.588746]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:52:11 pluto kernel: [  602.588753]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:52:11 pluto kernel: [  602.588758]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:52:11 pluto kernel: [  602.588787]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:52:11 pluto kernel: [  602.588813]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:52:11 pluto kernel: [  602.588838]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:52:11 pluto kernel: [  602.588864]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:52:11 pluto kernel: [  602.588888]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:52:11 pluto kernel: [  602.588894]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:52:11 pluto kernel: [  602.588899]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:52:11 pluto kernel: [  602.588906]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:52:11 pluto kernel: [  602.588910]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:52:11 pluto kernel: [  602.588914] ---[ end trace
f2fbb6fd3e4e0da4 ]---
Dec  6 20:52:42 pluto kernel: [  633.775152] ------------[ cut here
]------------
Dec  6 20:52:42 pluto kernel: [  633.775193] WARNING: CPU: 0 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:52:42 pluto kernel: [  633.775194] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:52:42 pluto kernel: [  633.775222] CPU: 0 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:52:42 pluto kernel: [  633.775224] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:52:42 pluto kernel: [  633.775226]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:52:42 pluto kernel: [  633.775229]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800b5e4c1a8
Dec  6 20:52:42 pluto kernel: [  633.775231]  ffff88007eb9ce60
ffff8800d8ec4800 ffff8800b5e4c0f0 ffff8800da8fc1a0
Dec  6 20:52:42 pluto kernel: [  633.775234] Call Trace:
Dec  6 20:52:42 pluto kernel: [  633.775241]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:52:42 pluto kernel: [  633.775245]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:52:42 pluto kernel: [  633.775247]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:52:42 pluto kernel: [  633.775261]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:52:42 pluto kernel: [  633.775274]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:52:42 pluto kernel: [  633.775286]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:52:42 pluto kernel: [  633.775298]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:52:42 pluto kernel: [  633.775310]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:52:42 pluto kernel: [  633.775313]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:52:42 pluto kernel: [  633.775316]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:52:42 pluto kernel: [  633.775319]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:52:42 pluto kernel: [  633.775322]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:52:42 pluto kernel: [  633.775323] ---[ end trace
f2fbb6fd3e4e0da5 ]---
Dec  6 20:53:18 pluto kernel: [  670.246781] ------------[ cut here
]------------
Dec  6 20:53:18 pluto kernel: [  670.246824] WARNING: CPU: 0 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:53:18 pluto kernel: [  670.246826] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:53:18 pluto kernel: [  670.246855] CPU: 0 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:53:18 pluto kernel: [  670.246856] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:53:18 pluto kernel: [  670.246858]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:53:18 pluto kernel: [  670.246861]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800b5e4c298
Dec  6 20:53:18 pluto kernel: [  670.246863]  ffff8800bf8d7e60
ffff8800d8ec4800 ffff8800b5e4c1e0 ffff8800da8fc1a0
Dec  6 20:53:18 pluto kernel: [  670.246866] Call Trace:
Dec  6 20:53:18 pluto kernel: [  670.246873]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:53:18 pluto kernel: [  670.246877]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:53:18 pluto kernel: [  670.246880]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:53:18 pluto kernel: [  670.246894]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:53:18 pluto kernel: [  670.246906]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:53:18 pluto kernel: [  670.246918]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:53:18 pluto kernel: [  670.246930]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:53:18 pluto kernel: [  670.246942]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:53:18 pluto kernel: [  670.246945]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:53:18 pluto kernel: [  670.246948]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:53:18 pluto kernel: [  670.246952]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:53:18 pluto kernel: [  670.246954]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:53:18 pluto kernel: [  670.246956] ---[ end trace
f2fbb6fd3e4e0da6 ]---
Dec  6 20:53:51 pluto kernel: [  702.280760] ------------[ cut here
]------------
Dec  6 20:53:51 pluto kernel: [  702.280808] WARNING: CPU: 0 PID: 664
at fs/btrfs/delayed-inode.c:1410
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]()
Dec  6 20:53:51 pluto kernel: [  702.280811] Modules linked in:
nls_utf8(E) udf(E) crc_itu_t(E) bnep(E) rfcomm(E) bluetooth(E)
snd_hda_codec_via(E) joydev(E) snd_hda_codec_generic(E)
snd_hda_intel(E) snd_hda_controller(E) snd_hda_codec(E) snd_hwdep(E)
snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E)
snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E)
coretemp(E) lpc_ich(E) serio_raw(E) asus_atk0110(E) mac_hid(E)
parport_pc(E) ppdev(E) lp(E) parport(E) btrfs(E) xor(E) raid6_pq(E)
hid_generic(E) usbhid(E) hid(E) psmouse(E) atl1e(E) i915(E) video(E)
i2c_algo_bit(E) drm_kms_helper(E) drm(E)
Dec  6 20:53:51 pluto kernel: [  702.280863] CPU: 0 PID: 664 Comm:
btrfs-transacti Tainted: G        W   E  3.18.0-rc7-ajw #78
Dec  6 20:53:51 pluto kernel: [  702.280866] Hardware name: System
manufacturer System Product Name/P5KPL-CM, BIOS 0512    05/19/2008
Dec  6 20:53:51 pluto kernel: [  702.280869]  0000000000000009
ffff8800d877fd78 ffffffff81764c2c 0000000000000000
Dec  6 20:53:51 pluto kernel: [  702.280874]  0000000000000000
ffff8800d877fdb8 ffffffff8106f0b1 ffff8800b5e4c388
Dec  6 20:53:51 pluto kernel: [  702.280879]  ffff880116276c80
ffff8800d8ec4800 ffff8800b5e4c2d0 ffff8800da8fc1a0
Dec  6 20:53:51 pluto kernel: [  702.280885] Call Trace:
Dec  6 20:53:51 pluto kernel: [  702.280895]  [<ffffffff81764c2c>]
dump_stack+0x46/0x58
Dec  6 20:53:51 pluto kernel: [  702.280902]  [<ffffffff8106f0b1>]
warn_slowpath_common+0x81/0xa0
Dec  6 20:53:51 pluto kernel: [  702.280907]  [<ffffffff8106f18a>]
warn_slowpath_null+0x1a/0x20
Dec  6 20:53:51 pluto kernel: [  702.280936]  [<ffffffffa02889d4>]
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dec  6 20:53:51 pluto kernel: [  702.280962]  [<ffffffffa0233584>]
btrfs_commit_transaction+0x3b4/0xa90 [btrfs]
Dec  6 20:53:51 pluto kernel: [  702.280987]  [<ffffffffa0233cf3>] ?
start_transaction+0x93/0x590 [btrfs]
Dec  6 20:53:51 pluto kernel: [  702.281013]  [<ffffffffa022f0b5>]
transaction_kthread+0x1b5/0x240 [btrfs]
Dec  6 20:53:51 pluto kernel: [  702.281037]  [<ffffffffa022ef00>] ?
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
Dec  6 20:53:51 pluto kernel: [  702.281043]  [<ffffffff8108d6b2>]
kthread+0xd2/0xf0
Dec  6 20:53:51 pluto kernel: [  702.281048]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:53:51 pluto kernel: [  702.281055]  [<ffffffff8176cfbc>]
ret_from_fork+0x7c/0xb0
Dec  6 20:53:51 pluto kernel: [  702.281059]  [<ffffffff8108d5e0>] ?
kthread_create_on_node+0x180/0x180
Dec  6 20:53:51 pluto kernel: [  702.281063] ---[ end trace
f2fbb6fd3e4e0da7 ]---
