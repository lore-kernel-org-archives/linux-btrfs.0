Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44944 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaGNPEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jul 2014 11:04:25 -0400
Received: from merkaba.localnet (unknown [91.221.105.244])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 51D83493
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 17:04:23 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS hang with 3.16-rc5
Date: Mon, 14 Jul 2014 17:04:22 +0200
Message-ID: <1502954.OtX3SzjMKZ@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several days of
usage, with 3-16-rc5 I had a hang again. Less than a hour since booting it.

Since the hang bug I and others had with 3.15 and upto 3.16-rc2 usually
didn´t happen that quickly after boot and since backtrace looks a bit
different from what I have in memory, I post this in a new thread.
See thread "Blocked tasks on 3.15.1" for a discussion of previous hang
issues.

I lost a mail I was about to send with kmail.

merkaba:/boot> ps aux | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       162  0.0  0.0      0     0 ?        D    15:16   0:02 [kworker/u8:4]
root       166  0.0  0.0      0     0 ?        D    15:16   0:01 [kworker/u8:8]
root       694  0.0  0.0      0     0 ?        D    15:16   0:03 [btrfs-transacti]
martin    2230  0.1  0.3 407396 51868 ?        DN   15:16   0:04 /usr/local/bin/akonadi_baloo_indexer --identifier akonadi_baloo_indexer
ms        2720  0.0  0.2 323316 33936 ?        DN   15:20   0:02 /usr/local/bin/baloo_file
ms        3025  0.1  0.4 823300 66296 ?        D    15:21   0:04 /usr/bin/owncloud -session 10cec7d36b000140534103000000249840025_1405343620_420735
ms        3790  7.4  2.3 1750408 386120 ?      Dl   15:30   4:14 /usr/bin/iceweasel
root      3901  0.0  0.0      0     0 ?        D    15:31   0:01 [kworker/u8:0]
root      3956  0.0  0.0      0     0 ?        D    15:45   0:00 [kworker/u8:7]
[…]




Jul 14 16:00:13 merkaba kernel: [ 2640.529614] INFO: task kworker/u8:4:162 blocked for more than 120 seconds.
Jul 14 16:00:13 merkaba kernel: [ 2640.529627]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:00:13 merkaba kernel: [ 2640.529631] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:00:13 merkaba kernel: [ 2640.529635] kworker/u8:4    D ffff880405cab660     0   162      2 0x00000000
Jul 14 16:00:13 merkaba kernel: [ 2640.529720] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.529725]  ffff8804055d3b18 0000000000000002 ffff880407f66240 ffff8804055d3fd8
Jul 14 16:00:13 merkaba kernel: [ 2640.529734]  ffff880405cab120 0000000000013080 ffff880405cab120 ffff88041e313080
Jul 14 16:00:13 merkaba kernel: [ 2640.529741]  ffff88041e5e7b68 ffff8804055d3bb0 0000000000000002 ffffffff810daffc
Jul 14 16:00:13 merkaba kernel: [ 2640.529749] Call Trace:
Jul 14 16:00:13 merkaba kernel: [ 2640.529762]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:00:13 merkaba kernel: [ 2640.529772]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:00:13 merkaba kernel: [ 2640.529779]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:00:13 merkaba kernel: [ 2640.529785]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:00:13 merkaba kernel: [ 2640.529792]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:00:13 merkaba kernel: [ 2640.529799]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:00:13 merkaba kernel: [ 2640.529809]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:00:13 merkaba kernel: [ 2640.529862]  [<ffffffffc0362590>] lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.529906]  [<ffffffffc0362590>] ? lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.529953]  [<ffffffffc036686d>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.529964]  [<ffffffff81067fd7>] ? account_entity_enqueue+0x55/0x86
Jul 14 16:00:13 merkaba kernel: [ 2640.529972]  [<ffffffff810680c7>] ? __enqueue_entity+0x67/0x69
Jul 14 16:00:13 merkaba kernel: [ 2640.530016]  [<ffffffffc0366d95>] extent_writepages+0x46/0x57 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530061]  [<ffffffffc03510a2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530103]  [<ffffffffc034f60f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530109]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 14 16:00:13 merkaba kernel: [ 2640.530116]  [<ffffffff810dc6ad>] __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:00:13 merkaba kernel: [ 2640.530122]  [<ffffffff810dcfd6>] filemap_flush+0x17/0x19
Jul 14 16:00:13 merkaba kernel: [ 2640.530163]  [<ffffffffc0351de9>] btrfs_run_delalloc_work+0x2e/0x64 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530211]  [<ffffffffc0372350>] normal_work_helper+0xdf/0x224 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530221]  [<ffffffff81052d7c>] process_one_work+0x16f/0x2b8
Jul 14 16:00:13 merkaba kernel: [ 2640.530229]  [<ffffffff81053626>] worker_thread+0x27b/0x32e
Jul 14 16:00:13 merkaba kernel: [ 2640.530238]  [<ffffffff810533ab>] ? cancel_delayed_work_sync+0x10/0x10
Jul 14 16:00:13 merkaba kernel: [ 2640.530245]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 14 16:00:13 merkaba kernel: [ 2640.530253]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 14 16:00:13 merkaba kernel: [ 2640.530260]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.530267]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 14 16:00:13 merkaba kernel: [ 2640.530274]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.530280] INFO: task kworker/u8:8:166 blocked for more than 120 seconds.
Jul 14 16:00:13 merkaba kernel: [ 2640.530285]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:00:13 merkaba kernel: [ 2640.530288] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:00:13 merkaba kernel: [ 2640.530292] kworker/u8:8    D ffff880405b84ef0     0   166      2 0x00000000
Jul 14 16:00:13 merkaba kernel: [ 2640.530340] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530344]  ffff880405643b18 0000000000000002 ffff880407f649b0 ffff880405643fd8
Jul 14 16:00:13 merkaba kernel: [ 2640.530351]  ffff880405b849b0 0000000000013080 ffff880405b849b0 ffff88041e293080
Jul 14 16:00:13 merkaba kernel: [ 2640.530358]  ffff88041e5d0168 ffff880405643bb0 0000000000000002 ffffffff810daffc
Jul 14 16:00:13 merkaba kernel: [ 2640.530366] Call Trace:
Jul 14 16:00:13 merkaba kernel: [ 2640.530373]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:00:13 merkaba kernel: [ 2640.530381]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:00:13 merkaba kernel: [ 2640.530388]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:00:13 merkaba kernel: [ 2640.530394]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:00:13 merkaba kernel: [ 2640.530401]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:00:13 merkaba kernel: [ 2640.530407]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:00:13 merkaba kernel: [ 2640.530415]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:00:13 merkaba kernel: [ 2640.530458]  [<ffffffffc0362590>] lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530498]  [<ffffffffc0362590>] ? lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530542]  [<ffffffffc036686d>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530618]  [<ffffffffc0366d95>] extent_writepages+0x46/0x57 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530683]  [<ffffffffc03510a2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530748]  [<ffffffffc034f60f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530772]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 14 16:00:13 merkaba kernel: [ 2640.530799]  [<ffffffff810dc6ad>] __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:00:13 merkaba kernel: [ 2640.530829]  [<ffffffff810dcfd6>] filemap_flush+0x17/0x19
Jul 14 16:00:13 merkaba kernel: [ 2640.530890]  [<ffffffffc0351de9>] btrfs_run_delalloc_work+0x2e/0x64 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530953]  [<ffffffffc0372350>] normal_work_helper+0xdf/0x224 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.530979]  [<ffffffff81052d7c>] process_one_work+0x16f/0x2b8
Jul 14 16:00:13 merkaba kernel: [ 2640.531000]  [<ffffffff81053626>] worker_thread+0x27b/0x32e
Jul 14 16:00:13 merkaba kernel: [ 2640.531008]  [<ffffffff810533ab>] ? cancel_delayed_work_sync+0x10/0x10
Jul 14 16:00:13 merkaba kernel: [ 2640.531015]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 14 16:00:13 merkaba kernel: [ 2640.531023]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 14 16:00:13 merkaba kernel: [ 2640.531030]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.531036]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 14 16:00:13 merkaba kernel: [ 2640.531043]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.531064] INFO: task btrfs-transacti:694 blocked for more than 120 seconds.
Jul 14 16:00:13 merkaba kernel: [ 2640.531069]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:00:13 merkaba kernel: [ 2640.531072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:00:13 merkaba kernel: [ 2640.531076] btrfs-transacti D ffff88040231b660     0   694      2 0x00000000
Jul 14 16:00:13 merkaba kernel: [ 2640.531083]  ffff880036d87c80 0000000000000002 ffff880407fc0000 ffff880036d87fd8
Jul 14 16:00:13 merkaba kernel: [ 2640.531091]  ffff88040231b120 0000000000013080 ffff88040231b120 7fffffffffffffff
Jul 14 16:00:13 merkaba kernel: [ 2640.531099]  ffff8800beee1278 0000000000000002 ffffffff81470270 ffff8800beee1270
Jul 14 16:00:13 merkaba kernel: [ 2640.531106] Call Trace:
Jul 14 16:00:13 merkaba kernel: [ 2640.531115]  [<ffffffff81470270>] ? michael_mic.part.6+0x1e/0x1e
Jul 14 16:00:13 merkaba kernel: [ 2640.531122]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:00:13 merkaba kernel: [ 2640.531129]  [<ffffffff8147029f>] schedule_timeout+0x2f/0x114
Jul 14 16:00:13 merkaba kernel: [ 2640.531137]  [<ffffffff81062c4d>] ? get_parent_ip+0xd/0x3c
Jul 14 16:00:13 merkaba kernel: [ 2640.531142]  [<ffffffff81062cf7>] ? preempt_count_add+0x7b/0x8e
Jul 14 16:00:13 merkaba kernel: [ 2640.531150]  [<ffffffff8147149d>] __wait_for_common+0x11e/0x163
Jul 14 16:00:13 merkaba kernel: [ 2640.531158]  [<ffffffff8147149d>] ? __wait_for_common+0x11e/0x163
Jul 14 16:00:13 merkaba kernel: [ 2640.531165]  [<ffffffff810647e9>] ? wake_up_state+0xd/0xd
Jul 14 16:00:13 merkaba kernel: [ 2640.531173]  [<ffffffff81471501>] wait_for_completion+0x1f/0x21
Jul 14 16:00:13 merkaba kernel: [ 2640.531218]  [<ffffffffc0359c10>] btrfs_wait_and_free_delalloc_work+0x11/0x23 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531263]  [<ffffffffc0361b56>] btrfs_run_ordered_operations+0x1ea/0x21a [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531331]  [<ffffffffc034d392>] btrfs_commit_transaction+0x22/0x8df [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531385]  [<ffffffffc0349fb6>] transaction_kthread+0x107/0x1b9 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531446]  [<ffffffffc0349eaf>] ? btrfs_cleanup_transaction+0x43a/0x43a [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531469]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 14 16:00:13 merkaba kernel: [ 2640.531477]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 14 16:00:13 merkaba kernel: [ 2640.531484]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.531490]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 14 16:00:13 merkaba kernel: [ 2640.531497]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.531589] INFO: task mysqld:2758 blocked for more than 120 seconds.
Jul 14 16:00:13 merkaba kernel: [ 2640.531595]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:00:13 merkaba kernel: [ 2640.531598] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:00:13 merkaba kernel: [ 2640.531601] mysqld          D ffff88034079cef0     0  2758   2738 0x00000000
Jul 14 16:00:13 merkaba kernel: [ 2640.531625]  ffff88033d9dfbd8 0000000000000002 ffff880407f66240 ffff88033d9dffd8
Jul 14 16:00:13 merkaba kernel: [ 2640.531645]  ffff88034079c9b0 0000000000013080 ffff88034079c9b0 ffff88041e313080
Jul 14 16:00:13 merkaba kernel: [ 2640.531652]  ffff88041e5c9268 ffff88033d9dfc70 0000000000000002 ffffffff810daffc
Jul 14 16:00:13 merkaba kernel: [ 2640.531660] Call Trace:
Jul 14 16:00:13 merkaba kernel: [ 2640.531668]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:00:13 merkaba kernel: [ 2640.531675]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:00:13 merkaba kernel: [ 2640.531702]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:00:13 merkaba kernel: [ 2640.531708]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:00:13 merkaba kernel: [ 2640.531715]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:00:13 merkaba kernel: [ 2640.531721]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:00:13 merkaba kernel: [ 2640.531741]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:00:13 merkaba kernel: [ 2640.531787]  [<ffffffffc0362590>] lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531835]  [<ffffffffc0362590>] ? lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531880]  [<ffffffffc036686d>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531925]  [<ffffffffc0366d95>] extent_writepages+0x46/0x57 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.531967]  [<ffffffffc03510a2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532006]  [<ffffffffc034f60f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532012]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 14 16:00:13 merkaba kernel: [ 2640.532018]  [<ffffffff810dc6ad>] __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:00:13 merkaba kernel: [ 2640.532025]  [<ffffffff810dc714>] filemap_fdatawrite_range+0xe/0x10
Jul 14 16:00:13 merkaba kernel: [ 2640.532067]  [<ffffffffc035aa0a>] btrfs_sync_file+0x67/0x2bd [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532074]  [<ffffffff810dc6ad>] ? __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:00:13 merkaba kernel: [ 2640.532083]  [<ffffffff81155fab>] vfs_fsync_range+0x1c/0x1e
Jul 14 16:00:13 merkaba kernel: [ 2640.532090]  [<ffffffff81155fc4>] vfs_fsync+0x17/0x19
Jul 14 16:00:13 merkaba kernel: [ 2640.532104]  [<ffffffffc02aa32a>] ecryptfs_fsync+0x2f/0x34 [ecryptfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532111]  [<ffffffff81155fab>] vfs_fsync_range+0x1c/0x1e
Jul 14 16:00:13 merkaba kernel: [ 2640.532117]  [<ffffffff81155fc4>] vfs_fsync+0x17/0x19
Jul 14 16:00:13 merkaba kernel: [ 2640.532124]  [<ffffffff811561eb>] do_fsync+0x2c/0x45
Jul 14 16:00:13 merkaba kernel: [ 2640.532132]  [<ffffffff811563d1>] SyS_fsync+0xb/0xf
Jul 14 16:00:13 merkaba kernel: [ 2640.532138]  [<ffffffff81473e8b>] tracesys+0xdd/0xe2
Jul 14 16:00:13 merkaba kernel: [ 2640.532147] INFO: task mysqld:2832 blocked for more than 120 seconds.
Jul 14 16:00:13 merkaba kernel: [ 2640.532151]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:00:13 merkaba kernel: [ 2640.532155] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:00:13 merkaba kernel: [ 2640.532158] mysqld          D ffff88009699b660     0  2832   2738 0x00000000
Jul 14 16:00:13 merkaba kernel: [ 2640.532165]  ffff88032f9fbbd8 0000000000000002 ffffffff81a15500 ffff88032f9fbfd8
Jul 14 16:00:13 merkaba kernel: [ 2640.532173]  ffff88009699b120 0000000000013080 ffff88009699b120 ffff88041e213080
Jul 14 16:00:13 merkaba kernel: [ 2640.532180]  ffff88041e5bb468 ffff88032f9fbc70 0000000000000002 ffffffff810daffc
Jul 14 16:00:13 merkaba kernel: [ 2640.532187] Call Trace:
Jul 14 16:00:13 merkaba kernel: [ 2640.532194]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:00:13 merkaba kernel: [ 2640.532201]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:00:13 merkaba kernel: [ 2640.532209]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:00:13 merkaba kernel: [ 2640.532214]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:00:13 merkaba kernel: [ 2640.532221]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:00:13 merkaba kernel: [ 2640.532227]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:00:13 merkaba kernel: [ 2640.532236]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:00:13 merkaba kernel: [ 2640.532283]  [<ffffffffc0362590>] lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532323]  [<ffffffffc0362590>] ? lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532366]  [<ffffffffc036686d>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532410]  [<ffffffffc0366d95>] extent_writepages+0x46/0x57 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532452]  [<ffffffffc03510a2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532490]  [<ffffffffc034f60f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532497]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 14 16:00:13 merkaba kernel: [ 2640.532507]  [<ffffffff810dc6ad>] __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:00:13 merkaba kernel: [ 2640.532513]  [<ffffffff810dc714>] filemap_fdatawrite_range+0xe/0x10
Jul 14 16:00:13 merkaba kernel: [ 2640.532577]  [<ffffffffc035aa0a>] btrfs_sync_file+0x67/0x2bd [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532608]  [<ffffffff810dc6ad>] ? __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:00:13 merkaba kernel: [ 2640.532643]  [<ffffffff81155fab>] vfs_fsync_range+0x1c/0x1e
Jul 14 16:00:13 merkaba kernel: [ 2640.532677]  [<ffffffff81155fc4>] vfs_fsync+0x17/0x19
Jul 14 16:00:13 merkaba kernel: [ 2640.532712]  [<ffffffffc02aa32a>] ecryptfs_fsync+0x2f/0x34 [ecryptfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.532741]  [<ffffffff81155fab>] vfs_fsync_range+0x1c/0x1e
Jul 14 16:00:13 merkaba kernel: [ 2640.532774]  [<ffffffff81155fc4>] vfs_fsync+0x17/0x19
Jul 14 16:00:13 merkaba kernel: [ 2640.532785]  [<ffffffff811561eb>] do_fsync+0x2c/0x45
Jul 14 16:00:13 merkaba kernel: [ 2640.532792]  [<ffffffff811563d1>] SyS_fsync+0xb/0xf
Jul 14 16:00:13 merkaba kernel: [ 2640.532798]  [<ffffffff81473e8b>] tracesys+0xdd/0xe2
Jul 14 16:00:13 merkaba kernel: [ 2640.532821] INFO: task Cache I/O:3820 blocked for more than 120 seconds.
Jul 14 16:00:13 merkaba kernel: [ 2640.532826]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:00:13 merkaba kernel: [ 2640.532829] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:00:13 merkaba kernel: [ 2640.532833] Cache I/O       D ffff880272b08540     0  3820   2660 0x00000000
Jul 14 16:00:13 merkaba kernel: [ 2640.532840]  ffff880272aabbd8 0000000000000002 ffffffff81a15500 ffff880272aabfd8
Jul 14 16:00:13 merkaba kernel: [ 2640.532847]  ffff880272b08000 0000000000013080 ffff880272b08000 ffff88041e213080
Jul 14 16:00:13 merkaba kernel: [ 2640.532854]  ffff88041e5c5968 ffff880272aabc70 0000000000000002 ffffffff810daffc
Jul 14 16:00:13 merkaba kernel: [ 2640.532862] Call Trace:
Jul 14 16:00:13 merkaba kernel: [ 2640.532869]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:00:13 merkaba kernel: [ 2640.532876]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:00:13 merkaba kernel: [ 2640.532883]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:00:13 merkaba kernel: [ 2640.532889]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:00:13 merkaba kernel: [ 2640.532896]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:00:13 merkaba kernel: [ 2640.532902]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:00:13 merkaba kernel: [ 2640.532910]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:00:13 merkaba kernel: [ 2640.532953]  [<ffffffffc0362590>] lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533013]  [<ffffffffc0362590>] ? lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533082]  [<ffffffffc036686d>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533111]  [<ffffffff810e33cf>] ? rcu_read_unlock_sched_notrace+0x17/0x17
Jul 14 16:00:13 merkaba kernel: [ 2640.533117]  [<ffffffff810db5c2>] ? generic_perform_write+0x13c/0x179
Jul 14 16:00:13 merkaba kernel: [ 2640.533124]  [<ffffffff810db8a5>] ? find_get_pages_tag+0xfc/0x123
Jul 14 16:00:13 merkaba kernel: [ 2640.533166]  [<ffffffffc0366d95>] extent_writepages+0x46/0x57 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533209]  [<ffffffffc03510a2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533263]  [<ffffffffc034f60f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533269]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 14 16:00:13 merkaba kernel: [ 2640.533279]  [<ffffffff810dc6ad>] __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:00:13 merkaba kernel: [ 2640.533285]  [<ffffffff810dc714>] filemap_fdatawrite_range+0xe/0x10
Jul 14 16:00:13 merkaba kernel: [ 2640.533328]  [<ffffffffc035aa27>] btrfs_sync_file+0x84/0x2bd [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533334]  [<ffffffff810dc6ad>] ? __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:00:13 merkaba kernel: [ 2640.533342]  [<ffffffff81155fab>] vfs_fsync_range+0x1c/0x1e
Jul 14 16:00:13 merkaba kernel: [ 2640.533349]  [<ffffffff81155fc4>] vfs_fsync+0x17/0x19
Jul 14 16:00:13 merkaba kernel: [ 2640.533362]  [<ffffffffc02aa32a>] ecryptfs_fsync+0x2f/0x34 [ecryptfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533369]  [<ffffffff81155fab>] vfs_fsync_range+0x1c/0x1e
Jul 14 16:00:13 merkaba kernel: [ 2640.533375]  [<ffffffff81155fc4>] vfs_fsync+0x17/0x19
Jul 14 16:00:13 merkaba kernel: [ 2640.533382]  [<ffffffff811561eb>] do_fsync+0x2c/0x45
Jul 14 16:00:13 merkaba kernel: [ 2640.533389]  [<ffffffff811563d1>] SyS_fsync+0xb/0xf
Jul 14 16:00:13 merkaba kernel: [ 2640.533395]  [<ffffffff81473e8b>] tracesys+0xdd/0xe2
Jul 14 16:00:13 merkaba kernel: [ 2640.533405] INFO: task kworker/u8:0:3901 blocked for more than 120 seconds.
Jul 14 16:00:13 merkaba kernel: [ 2640.533409]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:00:13 merkaba kernel: [ 2640.533413] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:00:13 merkaba kernel: [ 2640.533416] kworker/u8:0    D ffff880407f00540     0  3901      2 0x00000000
Jul 14 16:00:13 merkaba kernel: [ 2640.533466] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533470]  ffff880062757838 0000000000000002 ffff880407f649b0 ffff880062757fd8
Jul 14 16:00:13 merkaba kernel: [ 2640.533478]  ffff880407f00000 0000000000013080 ffff880407f00000 ffff88041e293080
Jul 14 16:00:13 merkaba kernel: [ 2640.533485]  ffff88041e5d2e68 ffff8800627578d0 0000000000000002 ffffffff810daffc
Jul 14 16:00:13 merkaba kernel: [ 2640.533493] Call Trace:
Jul 14 16:00:13 merkaba kernel: [ 2640.533499]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:00:13 merkaba kernel: [ 2640.533507]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:00:13 merkaba kernel: [ 2640.533514]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:00:13 merkaba kernel: [ 2640.533537]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:00:13 merkaba kernel: [ 2640.533545]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:00:13 merkaba kernel: [ 2640.533556]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:00:13 merkaba kernel: [ 2640.533588]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:00:13 merkaba kernel: [ 2640.533623]  [<ffffffff810db8fe>] lock_page+0x19/0x1c
Jul 14 16:00:13 merkaba kernel: [ 2640.533652]  [<ffffffff810db8fe>] ? lock_page+0x19/0x1c
Jul 14 16:00:13 merkaba kernel: [ 2640.533676]  [<ffffffff810dc02b>] pagecache_get_page+0x60/0x149
Jul 14 16:00:13 merkaba kernel: [ 2640.533726]  [<ffffffffc0380ee6>] io_ctl_prepare_pages+0x63/0x127 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533774]  [<ffffffffc0382af8>] __load_free_space_cache+0x1ca/0x521 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533821]  [<ffffffffc0382f30>] load_free_space_cache+0xe1/0x18f [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533869]  [<ffffffffc033657e>] cache_block_group+0x1b9/0x330 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533884]  [<ffffffff81070f4a>] ? finish_wait+0x5d/0x5d
Jul 14 16:00:13 merkaba kernel: [ 2640.533927]  [<ffffffffc033d249>] find_free_extent+0x3b0/0x970 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.533965]  [<ffffffffc033d985>] btrfs_reserve_extent+0x6f/0x119 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534008]  [<ffffffffc0352b35>] cow_file_range+0x1a6/0x377 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534054]  [<ffffffffc0366d3d>] ? extent_write_locked_range+0x10c/0x11e [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534096]  [<ffffffffc03537d4>] submit_compressed_extents+0x100/0x3fc [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534105]  [<ffffffff8111d44d>] ? kfree+0xf0/0x130
Jul 14 16:00:13 merkaba kernel: [ 2640.534148]  [<ffffffffc0353b52>] async_cow_submit+0x82/0x87 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534195]  [<ffffffffc03723c4>] normal_work_helper+0x153/0x224 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534204]  [<ffffffff81052d7c>] process_one_work+0x16f/0x2b8
Jul 14 16:00:13 merkaba kernel: [ 2640.534212]  [<ffffffff81053626>] worker_thread+0x27b/0x32e
Jul 14 16:00:13 merkaba kernel: [ 2640.534220]  [<ffffffff810533ab>] ? cancel_delayed_work_sync+0x10/0x10
Jul 14 16:00:13 merkaba kernel: [ 2640.534226]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 14 16:00:13 merkaba kernel: [ 2640.534235]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 14 16:00:13 merkaba kernel: [ 2640.534242]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.534248]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 14 16:00:13 merkaba kernel: [ 2640.534254]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.534262] INFO: task kworker/u8:7:3956 blocked for more than 120 seconds.
Jul 14 16:00:13 merkaba kernel: [ 2640.534266]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:00:13 merkaba kernel: [ 2640.534269] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:00:13 merkaba kernel: [ 2640.534273] kworker/u8:7    D ffff880268063660     0  3956      2 0x00000000
Jul 14 16:00:13 merkaba kernel: [ 2640.534290] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-2)
Jul 14 16:00:13 merkaba kernel: [ 2640.534299]  ffff8802470b79b8 0000000000000002 ffff880407fc0000 ffff8802470b7fd8
Jul 14 16:00:13 merkaba kernel: [ 2640.534312]  ffff880268063120 0000000000013080 ffff880268063120 ffff88041e393080
Jul 14 16:00:13 merkaba kernel: [ 2640.534323]  ffff88041e5d0a68 ffff8802470b7a50 0000000000000002 ffffffff810daffc
Jul 14 16:00:13 merkaba kernel: [ 2640.534332] Call Trace:
Jul 14 16:00:13 merkaba kernel: [ 2640.534339]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:00:13 merkaba kernel: [ 2640.534351]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:00:13 merkaba kernel: [ 2640.534358]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:00:13 merkaba kernel: [ 2640.534363]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:00:13 merkaba kernel: [ 2640.534371]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:00:13 merkaba kernel: [ 2640.534377]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:00:13 merkaba kernel: [ 2640.534384]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:00:13 merkaba kernel: [ 2640.534428]  [<ffffffffc0362590>] lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534468]  [<ffffffffc0362590>] ? lock_page+0x1e/0x21 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534512]  [<ffffffffc036686d>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534573]  [<ffffffffc0366d95>] extent_writepages+0x46/0x57 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534638]  [<ffffffffc03510a2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534701]  [<ffffffffc034f60f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 14 16:00:13 merkaba kernel: [ 2640.534728]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 14 16:00:13 merkaba kernel: [ 2640.534762]  [<ffffffff81151d0d>] __writeback_single_inode+0x58/0x212
Jul 14 16:00:13 merkaba kernel: [ 2640.534792]  [<ffffffff81152c0f>] writeback_sb_inodes+0x1e9/0x32e
Jul 14 16:00:13 merkaba kernel: [ 2640.534806]  [<ffffffff81152dce>] __writeback_inodes_wb+0x7a/0xb0
Jul 14 16:00:13 merkaba kernel: [ 2640.534814]  [<ffffffff81152f1a>] wb_writeback+0x116/0x270
Jul 14 16:00:13 merkaba kernel: [ 2640.534821]  [<ffffffff811532c9>] bdi_writeback_workfn+0x171/0x313
Jul 14 16:00:13 merkaba kernel: [ 2640.534830]  [<ffffffff81052d7c>] process_one_work+0x16f/0x2b8
Jul 14 16:00:13 merkaba kernel: [ 2640.534838]  [<ffffffff81053626>] worker_thread+0x27b/0x32e
Jul 14 16:00:13 merkaba kernel: [ 2640.534846]  [<ffffffff810533ab>] ? cancel_delayed_work_sync+0x10/0x10
Jul 14 16:00:13 merkaba kernel: [ 2640.534853]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 14 16:00:13 merkaba kernel: [ 2640.534861]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 14 16:00:13 merkaba kernel: [ 2640.534868]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:00:13 merkaba kernel: [ 2640.534874]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 14 16:00:13 merkaba kernel: [ 2640.534881]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:02:13 merkaba kernel: [ 2760.554316] INFO: task kworker/u8:4:162 blocked for more than 120 seconds.
Jul 14 16:02:13 merkaba kernel: [ 2760.554328]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:02:13 merkaba kernel: [ 2760.554332] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:02:13 merkaba kernel: [ 2760.554336] kworker/u8:4    D ffff880405cab660     0   162      2 0x00000000
Jul 14 16:02:13 merkaba kernel: [ 2760.554429] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554436]  ffff8804055d3b18 0000000000000002 ffff880407f66240 ffff8804055d3fd8
Jul 14 16:02:13 merkaba kernel: [ 2760.554444]  ffff880405cab120 0000000000013080 ffff880405cab120 ffff88041e313080
Jul 14 16:02:13 merkaba kernel: [ 2760.554451]  ffff88041e5e7b68 ffff8804055d3bb0 0000000000000002 ffffffff810daffc
Jul 14 16:02:13 merkaba kernel: [ 2760.554459] Call Trace:
Jul 14 16:02:13 merkaba kernel: [ 2760.554473]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:02:13 merkaba kernel: [ 2760.554483]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:02:13 merkaba kernel: [ 2760.554491]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:02:13 merkaba kernel: [ 2760.554497]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:02:13 merkaba kernel: [ 2760.554504]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:02:13 merkaba kernel: [ 2760.554510]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:02:13 merkaba kernel: [ 2760.554521]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:02:13 merkaba kernel: [ 2760.554577]  [<ffffffffc0362590>] lock_page+0x1e/0x21 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554624]  [<ffffffffc0362590>] ? lock_page+0x1e/0x21 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554673]  [<ffffffffc036686d>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554685]  [<ffffffff81067fd7>] ? account_entity_enqueue+0x55/0x86
Jul 14 16:02:13 merkaba kernel: [ 2760.554693]  [<ffffffff810680c7>] ? __enqueue_entity+0x67/0x69
Jul 14 16:02:13 merkaba kernel: [ 2760.554740]  [<ffffffffc0366d95>] extent_writepages+0x46/0x57 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554787]  [<ffffffffc03510a2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554832]  [<ffffffffc034f60f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554838]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 14 16:02:13 merkaba kernel: [ 2760.554845]  [<ffffffff810dc6ad>] __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:02:13 merkaba kernel: [ 2760.554852]  [<ffffffff810dcfd6>] filemap_flush+0x17/0x19
Jul 14 16:02:13 merkaba kernel: [ 2760.554897]  [<ffffffffc0351de9>] btrfs_run_delalloc_work+0x2e/0x64 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554949]  [<ffffffffc0372350>] normal_work_helper+0xdf/0x224 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.554959]  [<ffffffff81052d7c>] process_one_work+0x16f/0x2b8
Jul 14 16:02:13 merkaba kernel: [ 2760.554967]  [<ffffffff81053626>] worker_thread+0x27b/0x32e
Jul 14 16:02:13 merkaba kernel: [ 2760.554975]  [<ffffffff810533ab>] ? cancel_delayed_work_sync+0x10/0x10
Jul 14 16:02:13 merkaba kernel: [ 2760.554982]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 14 16:02:13 merkaba kernel: [ 2760.554991]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 14 16:02:13 merkaba kernel: [ 2760.554998]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:02:13 merkaba kernel: [ 2760.555005]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 14 16:02:13 merkaba kernel: [ 2760.555012]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:02:13 merkaba kernel: [ 2760.555019] INFO: task kworker/u8:8:166 blocked for more than 120 seconds.
Jul 14 16:02:13 merkaba kernel: [ 2760.555024]       Tainted: G           O  3.16.0-rc5-tp520 #4
Jul 14 16:02:13 merkaba kernel: [ 2760.555028] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 14 16:02:13 merkaba kernel: [ 2760.555031] kworker/u8:8    D ffff880405b84ef0     0   166      2 0x00000000
Jul 14 16:02:13 merkaba kernel: [ 2760.555085] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555089]  ffff880405643b18 0000000000000002 ffff880407f649b0 ffff880405643fd8
Jul 14 16:02:13 merkaba kernel: [ 2760.555097]  ffff880405b849b0 0000000000013080 ffff880405b849b0 ffff88041e293080
Jul 14 16:02:13 merkaba kernel: [ 2760.555104]  ffff88041e5d0168 ffff880405643bb0 0000000000000002 ffffffff810daffc
Jul 14 16:02:13 merkaba kernel: [ 2760.555112] Call Trace:
Jul 14 16:02:13 merkaba kernel: [ 2760.555120]  [<ffffffff810daffc>] ? wait_on_page_read+0x37/0x37
Jul 14 16:02:13 merkaba kernel: [ 2760.555128]  [<ffffffff81470c70>] schedule+0x64/0x66
Jul 14 16:02:13 merkaba kernel: [ 2760.555136]  [<ffffffff81470df7>] io_schedule+0x57/0x76
Jul 14 16:02:13 merkaba kernel: [ 2760.555141]  [<ffffffff810db005>] sleep_on_page+0x9/0xd
Jul 14 16:02:13 merkaba kernel: [ 2760.555149]  [<ffffffff814711d7>] __wait_on_bit_lock+0x41/0x85
Jul 14 16:02:13 merkaba kernel: [ 2760.555155]  [<ffffffff810db0c2>] __lock_page+0x70/0x7c
Jul 14 16:02:13 merkaba kernel: [ 2760.555162]  [<ffffffff81070f79>] ? autoremove_wake_function+0x2f/0x2f
Jul 14 16:02:13 merkaba kernel: [ 2760.555246]  [<ffffffffc0362590>] lock_page+0x1e/0x21 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555299]  [<ffffffffc0362590>] ? lock_page+0x1e/0x21 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555371]  [<ffffffffc036686d>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555435]  [<ffffffffc0366d95>] extent_writepages+0x46/0x57 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555497]  [<ffffffffc03510a2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555557]  [<ffffffffc034f60f>] btrfs_writepages+0x23/0x25 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555588]  [<ffffffff810e5381>] do_writepages+0x1b/0x24
Jul 14 16:02:13 merkaba kernel: [ 2760.555615]  [<ffffffff810dc6ad>] __filemap_fdatawrite_range+0x50/0x52
Jul 14 16:02:13 merkaba kernel: [ 2760.555645]  [<ffffffff810dcfd6>] filemap_flush+0x17/0x19
Jul 14 16:02:13 merkaba kernel: [ 2760.555691]  [<ffffffffc0351de9>] btrfs_run_delalloc_work+0x2e/0x64 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555738]  [<ffffffffc0372350>] normal_work_helper+0xdf/0x224 [btrfs]
Jul 14 16:02:13 merkaba kernel: [ 2760.555747]  [<ffffffff81052d7c>] process_one_work+0x16f/0x2b8
Jul 14 16:02:13 merkaba kernel: [ 2760.555755]  [<ffffffff81053626>] worker_thread+0x27b/0x32e
Jul 14 16:02:13 merkaba kernel: [ 2760.555763]  [<ffffffff810533ab>] ? cancel_delayed_work_sync+0x10/0x10
Jul 14 16:02:13 merkaba kernel: [ 2760.555770]  [<ffffffff81058002>] kthread+0xb2/0xba
Jul 14 16:02:13 merkaba kernel: [ 2760.555778]  [<ffffffff81470000>] ? iommu_prepare_identity_map+0x1d/0x19d
Jul 14 16:02:13 merkaba kernel: [ 2760.555785]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:02:13 merkaba kernel: [ 2760.555791]  [<ffffffff81473bec>] ret_from_fork+0x7c/0xb0
Jul 14 16:02:13 merkaba kernel: [ 2760.555798]  [<ffffffff81057f50>] ? __kthread_parkme+0x62/0x62
Jul 14 16:07:16 merkaba kernel: [ 3063.762354] e1000e: eth0 NIC Link is Down
Jul 14 16:07:48 merkaba kernel: [ 3095.667377] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
Jul 14 16:07:48 merkaba kernel: [ 3095.667490] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Jul 14 16:29:12 merkaba kernel: [    0.000000] Initializing cgroup subsys cpuset
Jul 14 16:29:12 merkaba kernel: [    0.000000] Initializing cgroup subsys cpu
Jul 14 16:29:12 merkaba kernel: [    0.000000] Initializing cgroup subsys cpuacct
Jul 14 16:29:12 merkaba kernel: [    0.000000] Linux version 3.16.0-rc5-tp520 (martin@merkaba) (gcc version 4.9.0 (Debian 4.9.0-10) ) #4 SMP PREEMPT Mon Jul 14 14:21:02 CEST 2014
Jul 14 16:29:12 merkaba kernel: [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.16.0-rc5-tp520 root=/dev/mapper/sata-debian ro rootflags=subvol=debian init=/bin/systemd resume=/dev/mapper/sata-swap

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
