Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pecan2-mail.exetel.com.au ([220.233.0.71]:45978 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaJRMcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 08:32:55 -0400
Received: from 233.33.70.115.static.exetel.com.au ([115.70.33.233] helo=office.waterlogic.com.au)
	by smtp.po.exetel.com.au with esmtp (Exim 4.80)
	(envelope-from <paul@pauljones.id.au>)
	id 1XfSgA-0004tL-Va
	for linux-btrfs@vger.kernel.org; Sat, 18 Oct 2014 23:00:15 +1100
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: 3.17.1 blocked task
Date: Sat, 18 Oct 2014 12:00:09 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64593B0C9CF2@Server.waterlogic.com.au>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

Just found this stack trace in dmesg while running a scrub on one of my file systems. I haven‚Äôt seen this reported yet so I thought I should report it ‚ò∫
All filesystems are raid1.

vm-server ~ # btrfs fi sh
Label: 'Root'  uuid: 58d27dbd-7c1e-4ef7-8d43-e93df1537b08
        Total devices 2 FS bytes used 21.29GiB
        devid    3 size 40.00GiB used 40.00GiB path /dev/sde3
        devid    4 size 40.00GiB used 40.00GiB path /dev/sdd3

Label: 'storage'  uuid: df3d4a9c-ed6c-4867-8991-a018276f6f3c
        Total devices 5 FS bytes used 2.24TiB
        devid    6 size 2.69TiB used 2.10TiB path /dev/sda1
        devid    7 size 901.92GiB used 422.00GiB path /dev/sdf1
        devid    8 size 892.25GiB used 410.00GiB path /dev/sdg1
        devid    9 size 892.25GiB used 412.00GiB path /dev/sdh1
        devid   10 size 2.73TiB used 2.08TiB path /dev/sdb2

Label: 'Fast'  uuid: 9baf63f7-a9d6-456c-8fdd-1a8fdb21958f
        Total devices 2 FS bytes used 352.54GiB
        devid    2 size 407.12GiB used 407.12GiB path /dev/sde1
        devid    3 size 407.12GiB used 407.12GiB path /dev/sdd1

Linux vm-server 3.17.1-gentoo-r1 #1 SMP PREEMPT Sat Oct 18 16:53:06 AEDT 2014 x86_64 Intel(R) Core(TM) i7-2600K CPU @ 3.40GHz GenuineIntel GNU/Linux

[ 4372.838272] BTRFS: checksum error at logical 14375409094656 on dev /dev/sdb2, sector 1565551496, root 5, inode 3082523, offset 6035542016, length 4096, links 1 (path: shared/backup/Normal/Paul-PC_2014_07_06_13_00_27_323D24.TIB)
[ 4372.838277] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 16, gen 0
[ 4374.425936] BTRFS: fixed up error at logical 14375409094656 on dev /dev/sdb2
[ 4374.442320] BTRFS: checksum error at logical 14375409098752 on dev /dev/sdb2, sector 1565551504, root 5, inode 3082523, offset 6035546112, length 4096, links 1 (path: shared/backup/Normal/Paul-PC_2014_07_06_13_00_27_323D24.TIB)
[ 4374.442325] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 17, gen 0
[ 4374.475939] BTRFS: fixed up error at logical 14375409098752 on dev /dev/sdb2
[ 4374.476219] BTRFS: checksum error at logical 14375409102848 on dev /dev/sdb2, sector 1565551512, root 5, inode 3082523, offset 6035550208, length 4096, links 1 (path: shared/backup/Normal/Paul-PC_2014_07_06_13_00_27_323D24.TIB)
[ 4374.476222] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 18, gen 0
[ 4374.500941] BTRFS: fixed up error at logical 14375409102848 on dev /dev/sdb2
[ 4374.501569] BTRFS: checksum error at logical 14375409106944 on dev /dev/sdb2, sector 1565551520, root 5, inode 3082523, offset 6035554304, length 4096, links 1 (path: shared/backup/Normal/Paul-PC_2014_07_06_13_00_27_323D24.TIB)
[ 4374.501572] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 19, gen 0
[ 4374.534256] BTRFS: fixed up error at logical 14375409106944 on dev /dev/sdb2
[ 4374.534586] BTRFS: checksum error at logical 14375409111040 on dev /dev/sdb2, sector 1565551528, root 5, inode 3082523, offset 6035558400, length 4096, links 1 (path: shared/backup/Normal/Paul-PC_2014_07_06_13_00_27_323D24.TIB)
[ 4374.534589] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 20, gen 0
[ 4374.567606] BTRFS: fixed up error at logical 14375409111040 on dev /dev/sdb2
[ 5396.970316] INFO: task kworker/u16:8:7540 blocked for more than 120 seconds.
[ 5396.970318]       Not tainted 3.17.1-gentoo-r1 #1
[ 5396.970319] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5396.970319] kworker/u16:8   D ffff880302e4a2a0     0  7540      2 0x00000000
[ 5396.970325] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-3)
[ 5396.970326]  ffff88052741b6b8 0000000000000046 ffff8805fe758ab0 ffff8805fe758ab0
[ 5396.970328]  0000000000011480 0000000000004000 ffff8805ffa13610 ffff8805fe758ab0
[ 5396.970329]  ffff8805fe758ab0 ffff88061f291480 0000000000011480 ffff8805fe758ab0
[ 5396.970331] Call Trace:
[ 5396.970336]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5396.970338]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5396.970341]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5396.970342]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5396.970343]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5396.970344]  [<ffffffff811a6f5e>] run_delalloc_nocow+0x871/0x8bc
[ 5396.970346]  [<ffffffff811a7009>] run_delalloc_range+0x60/0x2de
[ 5396.970348]  [<ffffffff811b9462>] writepage_delalloc.isra.35+0xa1/0x125
[ 5396.970350]  [<ffffffff811bb287>] __extent_writepage+0x135/0x1d9
[ 5396.970351]  [<ffffffff811bb4c8>] extent_write_cache_pages.isra.28.constprop.46+0x19d/0x2f0
[ 5396.970353]  [<ffffffff811bba55>] extent_writepages+0x46/0x57
[ 5396.970354]  [<ffffffff811a413b>] ? btrfs_update_inode_item+0xe9/0xe9
[ 5396.970355]  [<ffffffff811a3097>] btrfs_writepages+0x23/0x25
[ 5396.970357]  [<ffffffff810ac28b>] do_writepages+0x19/0x27
[ 5396.970358]  [<ffffffff810fd1e9>] __writeback_single_inode+0x3e/0xf1
[ 5396.970359]  [<ffffffff810fe089>] writeback_sb_inodes+0x1bf/0x2da
[ 5396.970360]  [<ffffffff810fe213>] __writeback_inodes_wb+0x6f/0xb4
[ 5396.970361]  [<ffffffff810fe359>] wb_writeback+0x101/0x192
[ 5396.970364]  [<ffffffff810f2eac>] ? get_nr_inodes+0x3a/0x50
[ 5396.970365]  [<ffffffff810fe5fc>] bdi_writeback_workfn+0x152/0x297
[ 5396.970367]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5396.970368]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5396.970369]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5396.970370]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5396.970372]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5396.970374]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5396.970375]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5396.970377] INFO: task kworker/u16:14:7688 blocked for more than 120 seconds.
[ 5396.970378]       Not tainted 3.17.1-gentoo-r1 #1
[ 5396.970379] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5396.970379] kworker/u16:14  D ffff88061f211480     0  7688      2 0x00000000
[ 5396.970383] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 5396.970384]  ffff88051694bc28 0000000000000046 ffff88061f251480 ffff8805ffe3cf70
[ 5396.970385]  0000000000011480 0000000000004000 ffffffff817e2460 ffff8805ffe3cf70
[ 5396.970387]  ffff88051694bb88 ffffffff811b7987 000004c8cb6bc278 ffff88040e81e930
[ 5396.970389] Call Trace:
[ 5396.970391]  [<ffffffff811b7987>] ? split_state+0xb1/0xd1
[ 5396.970392]  [<ffffffff811b7f4d>] ? __set_extent_bit+0x3ac/0x406
[ 5396.970394]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5396.970396]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5396.970398]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5396.970399]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5396.970401]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5396.970403]  [<ffffffff811a834a>] btrfs_finish_ordered_io+0x1c9/0x452
[ 5396.970405]  [<ffffffff8153a00c>] ? __schedule+0x6dc/0x847
[ 5396.970406]  [<ffffffff811a85e3>] finish_ordered_fn+0x10/0x12
[ 5396.970408]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5396.970409]  [<ffffffff811c77c8>] btrfs_endio_write_helper+0xd/0xf
[ 5396.970410]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5396.970411]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5396.970412]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5396.970414]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5396.970415]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5396.970416]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5396.970417]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5396.970419] INFO: task kworker/u16:18:7692 blocked for more than 120 seconds.
[ 5396.970419]       Not tainted 3.17.1-gentoo-r1 #1
[ 5396.970420] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5396.970420] kworker/u16:18  D ffff88061f211480     0  7692      2 0x00000000
[ 5396.970422] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 5396.970423]  ffff88051d573c28 0000000000000046 ffff88061f2d1480 ffff8805fe22e0d0
[ 5396.970424]  0000000000011480 0000000000004000 ffffffff817e2460 ffff8805fe22e0d0
[ 5396.970425]  ffff88051d573b88 ffffffff811b7987 0000000000000bfc ffff8805ec4e6930
[ 5396.970426] Call Trace:
[ 5396.970427]  [<ffffffff811b7987>] ? split_state+0xb1/0xd1
[ 5396.970428]  [<ffffffff811b7f4d>] ? __set_extent_bit+0x3ac/0x406
[ 5396.970430]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5396.970431]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5396.970432]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5396.970433]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5396.970434]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5396.970435]  [<ffffffff811a834a>] btrfs_finish_ordered_io+0x1c9/0x452
[ 5396.970437]  [<ffffffff8104b45b>] ? check_preempt_curr+0x3e/0x6d
[ 5396.970438]  [<ffffffff811a85e3>] finish_ordered_fn+0x10/0x12
[ 5396.970440]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5396.970441]  [<ffffffff811c77c8>] btrfs_endio_write_helper+0xd/0xf
[ 5396.970442]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5396.970443]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5396.970444]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5396.970445]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5396.970447]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5396.970448]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5396.970449]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5396.970452] INFO: task kworker/u16:7:8315 blocked for more than 120 seconds.
[ 5396.970453]       Not tainted 3.17.1-gentoo-r1 #1
[ 5396.970453] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5396.970454] kworker/u16:7   D ffff88061f211480     0  8315      2 0x00000000
[ 5396.970456] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 5396.970456]  ffff88038a06fc28 0000000000000046 ffff88061f391480 ffff8805fe780b30
[ 5396.970457]  0000000000011480 0000000000004000 ffffffff817e2460 ffff8805fe780b30
[ 5396.970459]  ffff88038a06fb88 ffffffff811b7987 000004cc847fc5b9 ffff8800ae32c750
[ 5396.970460] Call Trace:
[ 5396.970461]  [<ffffffff811b7987>] ? split_state+0xb1/0xd1
[ 5396.970462]  [<ffffffff811b7f4d>] ? __set_extent_bit+0x3ac/0x406
[ 5396.970463]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5396.970464]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5396.970465]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5396.970466]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5396.970467]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5396.970469]  [<ffffffff811a834a>] btrfs_finish_ordered_io+0x1c9/0x452
[ 5396.970470]  [<ffffffff8153a00c>] ? __schedule+0x6dc/0x847
[ 5396.970471]  [<ffffffff811a85e3>] finish_ordered_fn+0x10/0x12
[ 5396.970472]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5396.970474]  [<ffffffff811c77c8>] btrfs_endio_write_helper+0xd/0xf
[ 5396.970475]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5396.970476]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5396.970477]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5396.970478]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5396.970479]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5396.970480]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5396.970481]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5858.037250] BTRFS: defrag_file cancelled
[ 5996.595671] INFO: task kworker/u16:3:780 blocked for more than 120 seconds.
[ 5996.595673]       Not tainted 3.17.1-gentoo-r1 #1
[ 5996.595674] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5996.595675] kworker/u16:3   D ffff88061f291480     0   780      2 0x00000000
[ 5996.595681] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 5996.595682]  ffff8805fe407c28 0000000000000046 ffff88061f2d1480 ffff8805fff4e3d0
[ 5996.595684]  0000000000011480 0000000000004000 ffff880600217150 ffff8805fff4e3d0
[ 5996.595685]  ffff8805fe407b88 ffffffff811b7987 000005585c3cbe1b ffff88000f6ef630
[ 5996.595686] Call Trace:
[ 5996.595689]  [<ffffffff811b7987>] ? split_state+0xb1/0xd1
[ 5996.595690]  [<ffffffff811b7f4d>] ? __set_extent_bit+0x3ac/0x406
[ 5996.595693]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5996.595695]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5996.595698]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5996.595700]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5996.595701]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5996.595702]  [<ffffffff811a834a>] btrfs_finish_ordered_io+0x1c9/0x452
[ 5996.595704]  [<ffffffff8153a00c>] ? __schedule+0x6dc/0x847
[ 5996.595705]  [<ffffffff811a85e3>] finish_ordered_fn+0x10/0x12
[ 5996.595706]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5996.595708]  [<ffffffff811c77c8>] btrfs_endio_write_helper+0xd/0xf
[ 5996.595710]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5996.595711]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5996.595712]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5996.595713]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5996.595715]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595716]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5996.595717]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595742] INFO: task kworker/u16:6:6782 blocked for more than 120 seconds.
[ 5996.595743]       Not tainted 3.17.1-gentoo-r1 #1
[ 5996.595743] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5996.595744] kworker/u16:6   D ffff88061f251480     0  6782      2 0x00000000
[ 5996.595746] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
[ 5996.595746]  ffff8800bce17cb8 0000000000000046 ffff88061f291480 ffff8800d7de8970
[ 5996.595747]  0000000000011480 0000000000004000 ffff88060020c0d0 ffff8800d7de8970
[ 5996.595749]  ffff8800bce17c18 ffff8805f8d0bb20 0000000000000003 0000000000000000
[ 5996.595750] Call Trace:
[ 5996.595753]  [<ffffffff8104dd11>] ? default_wake_function+0xd/0xf
[ 5996.595754]  [<ffffffff8105b011>] ? autoremove_wake_function+0xf/0x32
[ 5996.595756]  [<ffffffff8105aa54>] ? __wake_up_common+0x49/0x80
[ 5996.595757]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5996.595758]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5996.595759]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5996.595760]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5996.595761]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5996.595763]  [<ffffffff811934e5>] delayed_ref_async_start+0x13/0x76
[ 5996.595765]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5996.595766]  [<ffffffff811c7813>] btrfs_extent_refs_helper+0xd/0xf
[ 5996.595767]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5996.595768]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5996.595769]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5996.595770]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5996.595771]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595772]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5996.595773]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595775] INFO: task kworker/u16:1:7137 blocked for more than 120 seconds.
[ 5996.595775]       Not tainted 3.17.1-gentoo-r1 #1
[ 5996.595776] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5996.595776] kworker/u16:1   D ffff88061f251480     0  7137      2 0x00000000
[ 5996.595778] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 5996.595779]  ffff88054d027c28 0000000000000046 ffff88061f3d1480 ffff8805ffd57510
[ 5996.595780]  0000000000011480 0000000000004000 ffff88060020c0d0 ffff8805ffd57510
[ 5996.595781]  ffff88054d027b88 ffffffff811b7987 00000558e38a30b8 ffff8805f89fc4b0
[ 5996.595782] Call Trace:
[ 5996.595783]  [<ffffffff811b7987>] ? split_state+0xb1/0xd1
[ 5996.595784]  [<ffffffff811b7f4d>] ? __set_extent_bit+0x3ac/0x406
[ 5996.595786]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5996.595787]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5996.595788]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5996.595789]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5996.595790]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5996.595791]  [<ffffffff811a834a>] btrfs_finish_ordered_io+0x1c9/0x452
[ 5996.595792]  [<ffffffff8153a00c>] ? __schedule+0x6dc/0x847
[ 5996.595794]  [<ffffffff811a85e3>] finish_ordered_fn+0x10/0x12
[ 5996.595795]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5996.595796]  [<ffffffff811c77c8>] btrfs_endio_write_helper+0xd/0xf
[ 5996.595797]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5996.595798]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5996.595799]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5996.595800]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5996.595802]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595803]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5996.595804]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595806] INFO: task kworker/u16:16:7690 blocked for more than 120 seconds.
[ 5996.595807]       Not tainted 3.17.1-gentoo-r1 #1
[ 5996.595807] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5996.595808] kworker/u16:16  D ffff88061f251480     0  7690      2 0x00000000
[ 5996.595810] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 5996.595810]  ffff8800af957c28 0000000000000046 ffff88061f2d1480 ffff8805f09552d0
[ 5996.595811]  0000000000011480 0000000000004000 ffff88060020c0d0 ffff8805f09552d0
[ 5996.595812]  ffff8800af957b88 ffffffff811b7987 00000558e652445e ffff8805f89fca50
[ 5996.595814] Call Trace:
[ 5996.595815]  [<ffffffff811b7987>] ? split_state+0xb1/0xd1
[ 5996.595816]  [<ffffffff811b7f4d>] ? __set_extent_bit+0x3ac/0x406
[ 5996.595817]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5996.595818]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5996.595819]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5996.595820]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5996.595821]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5996.595822]  [<ffffffff811a834a>] btrfs_finish_ordered_io+0x1c9/0x452
[ 5996.595824]  [<ffffffff8153a00c>] ? __schedule+0x6dc/0x847
[ 5996.595825]  [<ffffffff811a85e3>] finish_ordered_fn+0x10/0x12
[ 5996.595826]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5996.595827]  [<ffffffff811c77c8>] btrfs_endio_write_helper+0xd/0xf
[ 5996.595828]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5996.595829]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5996.595830]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5996.595832]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5996.595833]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595834]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5996.595835]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595837] INFO: task kworker/u16:24:7771 blocked for more than 120 seconds.
[ 5996.595837]       Not tainted 3.17.1-gentoo-r1 #1
[ 5996.595838] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5996.595838] kworker/u16:24  D ffff88061f211480     0  7771      2 0x00000000
[ 5996.595840] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 5996.595840]  ffff88034fe77c28 0000000000000046 ffff88061f2d1480 ffff8805fdb5d210
[ 5996.595842]  0000000000011480 0000000000004000 ffffffff817e2460 ffff8805fdb5d210
[ 5996.595843]  ffff88034fe77b88 ffffffff811b7987 ffff8803699a3940 ffff8805ec4c0ab0
[ 5996.595844] Call Trace:
[ 5996.595845]  [<ffffffff811b7987>] ? split_state+0xb1/0xd1
[ 5996.595846]  [<ffffffff811b7f4d>] ? __set_extent_bit+0x3ac/0x406
[ 5996.595847]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5996.595848]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5996.595850]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5996.595851]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5996.595852]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5996.595853]  [<ffffffff811a834a>] btrfs_finish_ordered_io+0x1c9/0x452
[ 5996.595854]  [<ffffffff811a85e3>] finish_ordered_fn+0x10/0x12
[ 5996.595855]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5996.595856]  [<ffffffff811c77c8>] btrfs_endio_write_helper+0xd/0xf
[ 5996.595857]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5996.595858]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5996.595859]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5996.595861]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5996.595862]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595863]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5996.595864]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595866] INFO: task kworker/u16:7:8315 blocked for more than 120 seconds.
[ 5996.595866]       Not tainted 3.17.1-gentoo-r1 #1
[ 5996.595867] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5996.595867] kworker/u16:7   D ffff88061f211480     0  8315      2 0x00000000
[ 5996.595869] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[ 5996.595870]  ffff88038a06fc28 0000000000000046 ffff88061f351480 ffff8805fe780b30
[ 5996.595871]  0000000000011480 0000000000004000 ffffffff817e2460 ffff8805fe780b30
[ 5996.595872]  ffff88038a06fb88 ffffffff811b7987 00000558154ec912 ffff88061c7be330
[ 5996.595873] Call Trace:
[ 5996.595874]  [<ffffffff811b7987>] ? split_state+0xb1/0xd1
[ 5996.595875]  [<ffffffff811b7f4d>] ? __set_extent_bit+0x3ac/0x406
[ 5996.595876]  [<ffffffff8153a263>] schedule+0x65/0x67
[ 5996.595877]  [<ffffffff811a0649>] wait_current_trans.isra.32+0x94/0xec
[ 5996.595879]  [<ffffffff8105b002>] ? add_wait_queue+0x44/0x44
[ 5996.595880]  [<ffffffff811a195e>] start_transaction+0x206/0x472
[ 5996.595881]  [<ffffffff811a1c53>] btrfs_join_transaction+0x12/0x14
[ 5996.595882]  [<ffffffff811a834a>] btrfs_finish_ordered_io+0x1c9/0x452
[ 5996.595883]  [<ffffffff8153a00c>] ? __schedule+0x6dc/0x847
[ 5996.595884]  [<ffffffff811a85e3>] finish_ordered_fn+0x10/0x12
[ 5996.595885]  [<ffffffff811c7661>] normal_work_helper+0xbb/0x170
[ 5996.595887]  [<ffffffff811c77c8>] btrfs_endio_write_helper+0xd/0xf
[ 5996.595888]  [<ffffffff8104354f>] process_one_work+0x18a/0x2ad
[ 5996.595889]  [<ffffffff810438fe>] worker_thread+0x262/0x361
[ 5996.595890]  [<ffffffff8104369c>] ? process_scheduled_works+0x2a/0x2a
[ 5996.595891]  [<ffffffff810470c9>] kthread+0xcd/0xd5
[ 5996.595892]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
[ 5996.595893]  [<ffffffff8153d46c>] ret_from_fork+0x7c/0xb0
[ 5996.595894]  [<ffffffff81046ffc>] ? kthread_freezable_should_stop+0x43/0x43
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
