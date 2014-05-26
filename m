Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40342 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaEZMNc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 08:13:32 -0400
Received: from merkaba.localnet (blackhole.teamix.net [194.150.191.251])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 8D450BB
	for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 14:14:29 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Linux Btrfs Mailing List <linux-btrfs@vger.kernel.org>
Subject: unregular BTRFS hangs on SSD based BTRFS RAID 1
Date: Mon, 26 May 2014 14:13:28 +0200
Message-ID: <3949539.723lBlDIbC@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I am getting BTRFS hangs unregularily on SSD based BTRFS RAID 1.

Any hints?

If you need additional data please tell.


Raid is

merkaba:~> lsblk /dev/sda4 /dev/sdb3
NAME                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda4                    8:4    0   279G  0 part 
‚îú‚îÄsata-home (dm-4)    254:4    0   150G  0 lvm  
‚îú‚îÄsata-swap (dm-5)    254:5    0    12G  0 lvm  [SWAP]
‚îî‚îÄsata-debian (dm-6)  254:6    0    30G  0 lvm  
sdb3                    8:19   0 446,7G  0 part 
‚îú‚îÄmsata-home (dm-0)   254:0    0   150G  0 lvm  
‚îú‚îÄmsata-daten (dm-1)  254:1    0   200G  0 lvm  
‚îî‚îÄmsata-debian (dm-2) 254:2    0    30G  0 lvm 


I don¬¥t know where this unknown, single chunk came from:

merkaba:~> btrfs fi df /home
Data, RAID1: total=145.97GiB, used=125.69GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=4.00GiB, used=2.65GiB
unknown, single: total=512.00MiB, used=0.00
merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: [‚Ä¶]
        Total devices 2 FS bytes used 128.34GiB
        devid    1 size 150.00GiB used 150.00GiB path /dev/dm-0
        devid    2 size 150.00GiB used 150.00GiB path /dev/dm-4

Btrfs v3.14.1


Last scrub from last week was okay, but I will rescrub after installing
3.15-rc7.


One quite reliable trigger seems to run make-kpkg -j4 to build a new kernel:

  CC      arch/x86/boot/version.o
  CC      arch/x86/boot/compressed/eboot.o
  CC      arch/x86/boot/video-vga.o
  CC      arch/x86/boot/video-vesa.o
  CC      arch/x86/boot/video-bios.o
  HOSTCC  arch/x86/boot/tools/build
  CPUSTR  arch/x86/boot/cpustr.h
  LZ4     arch/x86/boot/compressed/vmlinux.bin.lz4
  CC      arch/x86/boot/cpu.o
[‚Ä¶ hangs ‚Ä¶]

merkaba:~> ps aux | grep " D"
root       758  0.0  0.0      0     0 ?        D    Mai25   0:40 [btrfs-transacti]
martin    2047  0.1  0.3 404932 25376 ?        DNl  Mai25   0:56 /usr/local/bin/baloo_file
martin    2702  1.2  3.8 1986456 309708 ?      Dl   Mai25  11:30 /usr/bin/iceweasel
root      5879  0.1  0.0      0     0 ?        D    12:55   0:05 [kworker/u8:5]
root      5920  0.2  0.0      0     0 ?        D    13:01   0:07 [kworker/u8:7]
martin    9670  0.1  3.7 914524 295560 ?       D    10:37   0:21 /usr/local/bin/akregator --icon akregator -caption Akregator
root     10969  0.2  0.0      0     0 ?        D    13:30   0:04 [kworker/u8:3]
root     10971  0.3  0.0      0     0 ?        D    13:30   0:04 [kworker/u8:11]
root     10972  0.2  0.0      0     0 ?        D    13:30   0:03 [kworker/u8:12]
root     10974  0.5  0.0      0     0 ?        D    13:30   0:08 [kworker/u8:14]
martin   11277  0.0  0.0   8848  3032 pts/1    S+   13:33   0:00 /usr/bin/make -f debian/rules DEBIAN_REVISION=1 APPEND_TO_VERSION=-tp520 INITRD=YES ROOT_CMD=fakeroot linux_image
martin   15141  0.1  0.5  71388 46800 pts/1    D+   13:44   0:00 /usr/lib/gcc/x86_64-linux-gnu/4.8/cc1 -quiet -nostdinc -I /home/martin/Computer/Merkaba/Kernel/linux/arch/x86/include -I arch/x86/include/generated -I include -I /home/martin/Computer/Merkaba/Kernel/linux/arch/x86/include/uapi -I arch/x86/include/generated/uapi -I /home/martin/Computer/Merkaba/Kernel/linux/include/uapi -I include/generated/uapi -imultiarch x86_64-linux-gnu -D __KERNEL__ -D __KERNEL__ -D DISABLE_BRANCH_PROFILING -D KBUILD_STR(s)=#s -D KBUILD_BASENAME=KBUILD_STR(eboot) -D KBUILD_MODNAME=KBUILD_STR(eboot) -isystem /usr/lib/gcc/x86_64-linux-gnu/4.8/include -include /home/martin/Computer/Merkaba/Kernel/linux/include/linux/kconfig.h -MD arch/x86/boot/compressed/.eboot.o.d arch/x86/boot/compressed/eboot.c -quiet -dumpbase eboot.c -m64 -mcmodel=small -mno-mmx -mno-sse -mno-red-zone -mtune=generic -march=x86-64 -auxbase-strip arch/x86/boot/compressed/.tmp_eboot.o -O2 -fno-strict-aliasing -fPIC -ffreestanding -fno-stack-protector -fshort-wchar -o /tmp/ccfJjgFy.s
martin   15216  0.0  0.0      0     0 pts/1    D+   13:44   0:00 [sh]
root     15388  0.0  0.0  10420  1596 pts/0    S+   13:54   0:00 grep  D
ms       25349  0.7  0.9 2993580 73400 ?       Dl   13:37   0:07 kwin -session 10cec7d36b000135944758200000236760000_1400767287_267701
ms       26663  0.0  0.5 319300 42080 ?        D    13:37   0:00 /usr/bin/ktimetracker -session 10cec7d36b000134492936800000256540013_1400767287_90582
ms       26675  0.1  0.9 1446388 76772 ?       Dl   13:37   0:01 /usr/bin/krunner
ms       26830  0.6  0.8 415968 69016 ?        D    13:38   0:06 /usr/bin/basket -session 10cec7d36b000139357629300000130090029_1400767287_86884
root     27222  0.1  0.0      0     0 ?        D    13:38   0:01 [kworker/u8:15]
root     30841  0.2  0.0      0     0 ?        D    13:39   0:02 [kworker/u8:16]
root     30842  0.2  0.0      0     0 ?        D    13:39   0:02 [kworker/u8:17]


dmesg:

[23283.736043] INFO: task btrfs-transacti:758 blocked for more than 120 seconds.
[23283.736057]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.736061] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.736067] btrfs-transacti D 0000000000000003     0   758      2 0x00000000
[23283.736079]  ffff8800cdf2dc90 0000000000000002 ffff880036fd1fe2 ffff8800cdf2dfd8
[23283.736089]  ffff88020f6f9880 0000000000012dc0 7fffffffffffffff ffff8801b4dc2310
[23283.736098]  0000000000000002 ffffffff8144a100 7fffffffffffffff ffff8800cdf2dca0
[23283.736107] Call Trace:
[23283.736124]  [<ffffffff8144a100>] ? michael_mic.part.6+0x1e/0x1e
[23283.736131]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.736138]  [<ffffffff8144a124>] schedule_timeout+0x24/0xff
[23283.736147]  [<ffffffff8144d040>] ? _raw_spin_unlock_irqrestore+0x13/0x26
[23283.736159]  [<ffffffff8105d8c8>] ? get_parent_ip+0xd/0x3c
[23283.736168]  [<ffffffff8145039b>] ? preempt_count_add+0x75/0x88
[23283.736176]  [<ffffffff8144b210>] __wait_for_common+0x111/0x155
[23283.736183]  [<ffffffff8105f365>] ? wake_up_state+0xd/0xd
[23283.736190]  [<ffffffff8144b273>] wait_for_completion+0x1f/0x21
[23283.736267]  [<ffffffffa026e4fa>] btrfs_wait_and_free_delalloc_work+0x11/0x23 [btrfs]
[23283.736327]  [<ffffffffa0276271>] btrfs_run_ordered_operations+0x1e6/0x215 [btrfs]
[23283.736378]  [<ffffffffa0261ca8>] btrfs_commit_transaction+0x22/0x8a3 [btrfs]
[23283.736426]  [<ffffffffa025e856>] transaction_kthread+0xf3/0x1a6 [btrfs]
[23283.736470]  [<ffffffffa025e763>] ? btrfs_cleanup_transaction+0x436/0x436 [btrfs]
[23283.736478]  [<ffffffff8105305d>] kthread+0xa9/0xb1
[23283.736486]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.736492]  [<ffffffff81451dfc>] ret_from_fork+0x7c/0xb0
[23283.736499]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.736535] INFO: task baloo_file:2047 blocked for more than 120 seconds.
[23283.736541]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.736545] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.736549] baloo_file      D 0000000000000003     0  2047      1 0x00000000
[23283.736558]  ffff8800c214bc30 0000000000000002 ffff880203ac8ba0 ffff8800c214bfd8
[23283.736567]  ffff880210cce200 0000000000012dc0 ffff880203ac8b28 ffff880203ac8ba0
[23283.736575]  ffff8800c4f57858 0000000000002000 0000000000000001 ffff8800c214bc40
[23283.736584] Call Trace:
[23283.736591]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.736645]  [<ffffffffa0276335>] btrfs_start_ordered_extent+0x95/0xea [btrfs]
[23283.736654]  [<ffffffff8106b68e>] ? finish_wait+0x60/0x60
[23283.736705]  [<ffffffffa026edaf>] lock_and_cleanup_extent_if_need+0xde/0x194 [btrfs]
[23283.736753]  [<ffffffffa0270170>] __btrfs_buffered_write+0x226/0x45b [btrfs]
[23283.736763]  [<ffffffff8105d8c8>] ? get_parent_ip+0xd/0x3c
[23283.736809]  [<ffffffffa0270767>] btrfs_file_aio_write+0x3c2/0x4af [btrfs]
[23283.736820]  [<ffffffff810d2aac>] ? generic_file_aio_read+0x509/0x533
[23283.736831]  [<ffffffff8112535a>] do_sync_write+0x54/0x73
[23283.736840]  [<ffffffff8112568e>] vfs_write+0xa6/0x102
[23283.736849]  [<ffffffff81125e75>] SyS_pwrite64+0x58/0x7d
[23283.736855]  [<ffffffff8145209b>] tracesys+0xdd/0xe2
[23283.736884] INFO: task BrowserBlocking:3615 blocked for more than 120 seconds.
[23283.736889]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.736893] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.736897] BrowserBlocking D 0000000000000000     0  3615   2002 0x00000000
[23283.736906]  ffff880184699c30 0000000000000002 ffff880184699c00 ffff880184699fd8
[23283.736915]  ffff88021285c980 0000000000012dc0 ffff88021e212dc0 ffff88021285c980
[23283.736923]  ffff880184699cd0 0000000000000002 ffffffff810d0e57 ffff880184699c40
[23283.736932] Call Trace:
[23283.736941]  [<ffffffff810d0e57>] ? wait_on_page_read+0x37/0x37
[23283.736947]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.736953]  [<ffffffff8144abc7>] io_schedule+0x5b/0x75
[23283.736960]  [<ffffffff810d0e60>] sleep_on_page+0x9/0xd
[23283.736967]  [<ffffffff8144af72>] __wait_on_bit_lock+0x41/0x85
[23283.737009]  [<ffffffff810d0f11>] __lock_page+0x64/0x66
[23283.737038]  [<ffffffff8106b6bd>] ? autoremove_wake_function+0x2f/0x2f
[23283.737117]  [<ffffffffa0277454>] lock_page+0x1e/0x21 [btrfs]
[23283.737203]  [<ffffffffa027ad3e>] extent_write_cache_pages.isra.21.constprop.43+0x197/0x2c6 [btrfs]
[23283.737240]  [<ffffffff810eef31>] ? pagefault_enable+0xe/0x21
[23283.737273]  [<ffffffff810ef094>] ? copy_page_to_iter+0x150/0x24a
[23283.737308]  [<ffffffff810d100a>] ? file_accessed+0x13/0x15
[23283.737386]  [<ffffffffa027b0f5>] extent_writepages+0x46/0x57 [btrfs]
[23283.737443]  [<ffffffffa0265bd7>] ? btrfs_submit_direct+0x3ea/0x3ea [btrfs]
[23283.737489]  [<ffffffffa0263f12>] btrfs_writepages+0x23/0x25 [btrfs]
[23283.737521]  [<ffffffff810dac33>] do_writepages+0x19/0x27
[23283.737546]  [<ffffffff810d2525>] __filemap_fdatawrite_range+0x50/0x52
[23283.737567]  [<ffffffff810d254e>] filemap_fdatawrite_range+0xe/0x10
[23283.737615]  [<ffffffffa026f39d>] btrfs_sync_file+0x84/0x298 [btrfs]
[23283.737623]  [<ffffffff8144d01a>] ? _raw_spin_unlock+0x11/0x24
[23283.737636]  [<ffffffff81149037>] vfs_fsync_range+0x13/0x1b
[23283.737649]  [<ffffffff81149056>] vfs_fsync+0x17/0x19
[23283.737661]  [<ffffffff81149266>] do_fsync+0x27/0x47
[23283.737679]  [<ffffffff81149468>] SyS_fdatasync+0xe/0x12
[23283.737690]  [<ffffffff8145209b>] tracesys+0xdd/0xe2
[23283.737703] INFO: task BrowserBlocking:3641 blocked for more than 120 seconds.
[23283.737710]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.737717] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.737723] BrowserBlocking D 0000000000000003     0  3641   2002 0x00000000
[23283.737736]  ffff88015e221848 0000000000000002 ffff8801399956f8 ffff88015e221fd8
[23283.737750]  ffff880210cf8000 0000000000012dc0 ffff880139995680 ffff8801399956f0
[23283.737762]  ffff8801399956f8 ffff88015e221880 ffff880210cf8000 ffff88015e221858
[23283.737775] Call Trace:
[23283.737788]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.737867]  [<ffffffffa028d190>] btrfs_tree_read_lock+0xa3/0xd7 [btrfs]
[23283.737879]  [<ffffffff8106b68e>] ? finish_wait+0x60/0x60
[23283.737930]  [<ffffffffa0243f23>] btrfs_read_lock_root_node+0x1d/0x3d [btrfs]
[23283.737985]  [<ffffffffa0247435>] btrfs_search_slot+0x190/0x6e5 [btrfs]
[23283.738068]  [<ffffffffa024c380>] lookup_inline_extent_backref+0xd5/0x424 [btrfs]
[23283.738097]  [<ffffffff8145039b>] ? preempt_count_add+0x75/0x88
[23283.738165]  [<ffffffffa024de9d>] __btrfs_free_extent+0xea/0x76b [btrfs]
[23283.738257]  [<ffffffffa029a500>] ? btrfs_merge_delayed_refs+0x16c/0x1b9 [btrfs]
[23283.738315]  [<ffffffffa0252fb6>] __btrfs_run_delayed_refs+0x8f2/0xbc6 [btrfs]
[23283.738326]  [<ffffffff8144b451>] ? mutex_unlock+0x11/0x13
[23283.738404]  [<ffffffffa02a189c>] ? __btrfs_release_delayed_node+0x186/0x1d8 [btrfs]
[23283.738467]  [<ffffffffa0254d98>] btrfs_run_delayed_refs+0x76/0x188 [btrfs]
[23283.738531]  [<ffffffffa0262bba>] __btrfs_end_transaction+0xe7/0x2be [btrfs]
[23283.738592]  [<ffffffffa0262d9c>] btrfs_end_transaction+0xb/0xd [btrfs]
[23283.738660]  [<ffffffffa026c9fe>] btrfs_create+0x18c/0x1c9 [btrfs]
[23283.738677]  [<ffffffff8112f751>] vfs_create+0x61/0x87
[23283.738689]  [<ffffffff81130469>] do_last+0x587/0x9ff
[23283.738703]  [<ffffffff81130b13>] path_openat+0x232/0x4d9
[23283.738718]  [<ffffffff81131ec5>] do_filp_open+0x35/0x7a
[23283.738732]  [<ffffffff8144d01a>] ? _raw_spin_unlock+0x11/0x24
[23283.738748]  [<ffffffff8113b6b4>] ? __alloc_fd+0xe5/0xf4
[23283.738762]  [<ffffffff81124cad>] do_sys_open+0x6b/0xfa
[23283.738774]  [<ffffffff8100cac2>] ? syscall_trace_enter+0xe0/0x1ce
[23283.738783]  [<ffffffff81124d55>] SyS_open+0x19/0x1b
[23283.738789]  [<ffffffff8145209b>] tracesys+0xdd/0xe2
[23283.738808] INFO: task kworker/u8:5:5879 blocked for more than 120 seconds.
[23283.738813]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.738817] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.738821] kworker/u8:5    D 0000000000000000     0  5879      2 0x00000000
[23283.738883] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[23283.738888]  ffff8801ee7af980 0000000000000002 ffff880115595338 ffff8801ee7affd8
[23283.738897]  ffff8800cd726200 0000000000012dc0 ffff8801155952c0 ffff880115595338
[23283.738905]  ffff8800cec29800 0000000000000001 0000000000000001 ffff8801ee7af990
[23283.738914] Call Trace:
[23283.738921]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.738974]  [<ffffffffa028d460>] btrfs_tree_lock+0x9d/0x1b8 [btrfs]
[23283.739007]  [<ffffffff8106b68e>] ? finish_wait+0x60/0x60
[23283.739064]  [<ffffffffa0247833>] btrfs_search_slot+0x58e/0x6e5 [btrfs]
[23283.739120]  [<ffffffffa024c380>] lookup_inline_extent_backref+0xd5/0x424 [btrfs]
[23283.739158]  [<ffffffff8145039b>] ? preempt_count_add+0x75/0x88
[23283.739225]  [<ffffffffa024de9d>] __btrfs_free_extent+0xea/0x76b [btrfs]
[23283.739316]  [<ffffffffa029a500>] ? btrfs_merge_delayed_refs+0x16c/0x1b9 [btrfs]
[23283.739409]  [<ffffffffa0252fb6>] __btrfs_run_delayed_refs+0x8f2/0xbc6 [btrfs]
[23283.739429]  [<ffffffff8144d01a>] ? _raw_spin_unlock+0x11/0x24
[23283.739491]  [<ffffffffa0254d98>] btrfs_run_delayed_refs+0x76/0x188 [btrfs]
[23283.739547]  [<ffffffffa024f1b9>] ? btrfs_delayed_refs_qgroup_accounting+0xd5/0xe3 [btrfs]
[23283.739612]  [<ffffffffa0262bba>] __btrfs_end_transaction+0xe7/0x2be [btrfs]
[23283.739673]  [<ffffffffa0262d9c>] btrfs_end_transaction+0xb/0xd [btrfs]
[23283.739739]  [<ffffffffa0269161>] btrfs_finish_ordered_io+0x302/0x3b8 [btrfs]
[23283.739801]  [<ffffffffa026940c>] finish_ordered_fn+0x10/0x12 [btrfs]
[23283.739870]  [<ffffffffa0286635>] normal_work_helper+0xe0/0x227 [btrfs]
[23283.739889]  [<ffffffff8104e23c>] process_one_work+0x175/0x2ae
[23283.739900]  [<ffffffff8104e73d>] worker_thread+0x144/0x1f0
[23283.739910]  [<ffffffff8104e5f9>] ? rescuer_thread+0x25a/0x25a
[23283.739920]  [<ffffffff8105305d>] kthread+0xa9/0xb1
[23283.739930]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.739940]  [<ffffffff81451dfc>] ret_from_fork+0x7c/0xb0
[23283.739951]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.740002] INFO: task kworker/u8:7:5920 blocked for more than 120 seconds.
[23283.740011]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.740018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.740025] kworker/u8:7    D 0000000000000000     0  5920      2 0x00000000
[23283.740104] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[23283.740114]  ffff880066e87780 0000000000000002 ffff880066e87750 ffff880066e87fd8
[23283.740128]  ffff880212b16200 0000000000012dc0 ffff88021e392dc0 ffff880212b16200
[23283.740141]  ffff880066e87820 0000000000000002 ffffffff810d0e57 ffff880066e87790
[23283.740155] Call Trace:
[23283.740169]  [<ffffffff810d0e57>] ? wait_on_page_read+0x37/0x37
[23283.740176]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.740182]  [<ffffffff8144abc7>] io_schedule+0x5b/0x75
[23283.740189]  [<ffffffff810d0e60>] sleep_on_page+0x9/0xd
[23283.740196]  [<ffffffff8144af72>] __wait_on_bit_lock+0x41/0x85
[23283.740203]  [<ffffffff810d0f11>] __lock_page+0x64/0x66
[23283.740212]  [<ffffffff8106b6bd>] ? autoremove_wake_function+0x2f/0x2f
[23283.740273]  [<ffffffffa0277454>] lock_page+0x1e/0x21 [btrfs]
[23283.740327]  [<ffffffffa027c4b9>] read_extent_buffer_pages+0xca/0x1fe [btrfs]
[23283.740373]  [<ffffffffa025aa99>] ? free_root_pointers+0x56/0x56 [btrfs]
[23283.740418]  [<ffffffffa025b764>] btree_read_extent_buffer_pages.constprop.51+0x61/0xfb [btrfs]
[23283.740463]  [<ffffffffa025df66>] btrfs_read_buffer+0x27/0x29 [btrfs]
[23283.740501]  [<ffffffffa0245de0>] read_block_for_search.isra.30+0xa9/0x280 [btrfs]
[23283.740544]  [<ffffffffa02477d3>] btrfs_search_slot+0x52e/0x6e5 [btrfs]
[23283.740584]  [<ffffffffa024c380>] lookup_inline_extent_backref+0xd5/0x424 [btrfs]
[23283.740593]  [<ffffffff8145039b>] ? preempt_count_add+0x75/0x88
[23283.740634]  [<ffffffffa024de9d>] __btrfs_free_extent+0xea/0x76b [btrfs]
[23283.740691]  [<ffffffffa029a500>] ? btrfs_merge_delayed_refs+0x16c/0x1b9 [btrfs]
[23283.740739]  [<ffffffffa0252fb6>] __btrfs_run_delayed_refs+0x8f2/0xbc6 [btrfs]
[23283.740808]  [<ffffffffa02772cd>] ? free_extent_state.part.23+0x48/0x79 [btrfs]
[23283.740880]  [<ffffffffa0277716>] ? free_extent_state+0x22/0x25 [btrfs]
[23283.740942]  [<ffffffffa0254d98>] btrfs_run_delayed_refs+0x76/0x188 [btrfs]
[23283.741001]  [<ffffffffa024f1b9>] ? btrfs_delayed_refs_qgroup_accounting+0xd5/0xe3 [btrfs]
[23283.741081]  [<ffffffffa0262bba>] __btrfs_end_transaction+0xe7/0x2be [btrfs]
[23283.741126]  [<ffffffffa0262d9c>] btrfs_end_transaction+0xb/0xd [btrfs]
[23283.741173]  [<ffffffffa0269161>] btrfs_finish_ordered_io+0x302/0x3b8 [btrfs]
[23283.741222]  [<ffffffffa026940c>] finish_ordered_fn+0x10/0x12 [btrfs]
[23283.741277]  [<ffffffffa0286635>] normal_work_helper+0xe0/0x227 [btrfs]
[23283.741286]  [<ffffffff8104e23c>] process_one_work+0x175/0x2ae
[23283.741294]  [<ffffffff8104e73d>] worker_thread+0x144/0x1f0
[23283.741302]  [<ffffffff8104e5f9>] ? rescuer_thread+0x25a/0x25a
[23283.741308]  [<ffffffff8105305d>] kthread+0xa9/0xb1
[23283.741316]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.741322]  [<ffffffff81451dfc>] ret_from_fork+0x7c/0xb0
[23283.741329]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.741338] INFO: task kworker/u8:3:10969 blocked for more than 120 seconds.
[23283.741343]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.741348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.741352] kworker/u8:3    D ffff88008c843638     0 10969      2 0x00000000
[23283.741407] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[23283.741412]  ffff880193fa9948 0000000000000002 ffff8801399956f8 ffff880193fa9fd8
[23283.741426]  ffff88008c843100 0000000000012dc0 ffff880139995680 ffff8801399956f0
[23283.741434]  ffff8801399956f8 ffff880193fa9980 ffff88008c843100 ffff880193fa9958
[23283.741449] Call Trace:
[23283.741462]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.741530]  [<ffffffffa028d190>] btrfs_tree_read_lock+0xa3/0xd7 [btrfs]
[23283.741562]  [<ffffffff8106b68e>] ? finish_wait+0x60/0x60
[23283.741622]  [<ffffffffa0243f23>] btrfs_read_lock_root_node+0x1d/0x3d [btrfs]
[23283.741682]  [<ffffffffa0247435>] btrfs_search_slot+0x190/0x6e5 [btrfs]
[23283.741761]  [<ffffffffa024c380>] lookup_inline_extent_backref+0xd5/0x424 [btrfs]
[23283.741793]  [<ffffffff8145039b>] ? preempt_count_add+0x75/0x88
[23283.741861]  [<ffffffffa024de9d>] __btrfs_free_extent+0xea/0x76b [btrfs]
[23283.741950]  [<ffffffffa029a500>] ? btrfs_merge_delayed_refs+0x16c/0x1b9 [btrfs]
[23283.742042]  [<ffffffffa0252fb6>] __btrfs_run_delayed_refs+0x8f2/0xbc6 [btrfs]
[23283.742128]  [<ffffffffa02772cd>] ? free_extent_state.part.23+0x48/0x79 [btrfs]
[23283.742209]  [<ffffffffa0277716>] ? free_extent_state+0x22/0x25 [btrfs]
[23283.742289]  [<ffffffffa0254d98>] btrfs_run_delayed_refs+0x76/0x188 [btrfs]
[23283.742357]  [<ffffffffa024f1b9>] ? btrfs_delayed_refs_qgroup_accounting+0xd5/0xe3 [btrfs]
[23283.742426]  [<ffffffffa0262bba>] __btrfs_end_transaction+0xe7/0x2be [btrfs]
[23283.742490]  [<ffffffffa0262d9c>] btrfs_end_transaction+0xb/0xd [btrfs]
[23283.742555]  [<ffffffffa0269161>] btrfs_finish_ordered_io+0x302/0x3b8 [btrfs]
[23283.742618]  [<ffffffffa026940c>] finish_ordered_fn+0x10/0x12 [btrfs]
[23283.742675]  [<ffffffffa0286635>] normal_work_helper+0xe0/0x227 [btrfs]
[23283.742684]  [<ffffffff8104e23c>] process_one_work+0x175/0x2ae
[23283.742692]  [<ffffffff8104e73d>] worker_thread+0x144/0x1f0
[23283.742700]  [<ffffffff8104e5f9>] ? rescuer_thread+0x25a/0x25a
[23283.742707]  [<ffffffff8105305d>] kthread+0xa9/0xb1
[23283.742714]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.742721]  [<ffffffff81451dfc>] ret_from_fork+0x7c/0xb0
[23283.742728]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.742737] INFO: task kworker/u8:11:10971 blocked for more than 120 seconds.
[23283.742743]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.742747] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.742751] kworker/u8:11   D 0000000000000000     0 10971      2 0x00000000
[23283.742805] Workqueue: btrfs-endio-write normal_work_helper [btrfs]
[23283.742811]  ffff8801e47c5948 0000000000000002 ffff8801399956f8 ffff8801e47c5fd8
[23283.742824]  ffff88008c846200 0000000000012dc0 ffff880139995680 ffff8801399956f0
[23283.742832]  ffff8801399956f8 ffff8801e47c5980 ffff88008c846200 ffff8801e47c5958
[23283.742841] Call Trace:
[23283.742849]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.742901]  [<ffffffffa028d190>] btrfs_tree_read_lock+0xa3/0xd7 [btrfs]
[23283.742909]  [<ffffffff8106b68e>] ? finish_wait+0x60/0x60
[23283.742946]  [<ffffffffa0243f23>] btrfs_read_lock_root_node+0x1d/0x3d [btrfs]
[23283.742984]  [<ffffffffa0247435>] btrfs_search_slot+0x190/0x6e5 [btrfs]
[23283.743040]  [<ffffffffa024c380>] lookup_inline_extent_backref+0xd5/0x424 [btrfs]
[23283.743054]  [<ffffffff8145039b>] ? preempt_count_add+0x75/0x88
[23283.743095]  [<ffffffffa024de9d>] __btrfs_free_extent+0xea/0x76b [btrfs]
[23283.743150]  [<ffffffffa029a500>] ? btrfs_merge_delayed_refs+0x16c/0x1b9 [btrfs]
[23283.743194]  [<ffffffffa0252fb6>] __btrfs_run_delayed_refs+0x8f2/0xbc6 [btrfs]
[23283.743247]  [<ffffffffa02772cd>] ? free_extent_state.part.23+0x48/0x79 [btrfs]
[23283.743296]  [<ffffffffa0277716>] ? free_extent_state+0x22/0x25 [btrfs]
[23283.743344]  [<ffffffffa0254d98>] btrfs_run_delayed_refs+0x76/0x188 [btrfs]
[23283.743385]  [<ffffffffa024f1b9>] ? btrfs_delayed_refs_qgroup_accounting+0xd5/0xe3 [btrfs]
[23283.743458]  [<ffffffffa0262bba>] __btrfs_end_transaction+0xe7/0x2be [btrfs]
[23283.743521]  [<ffffffffa0262d9c>] btrfs_end_transaction+0xb/0xd [btrfs]
[23283.743575]  [<ffffffffa0269161>] btrfs_finish_ordered_io+0x302/0x3b8 [btrfs]
[23283.743644]  [<ffffffffa026940c>] finish_ordered_fn+0x10/0x12 [btrfs]
[23283.743700]  [<ffffffffa0286635>] normal_work_helper+0xe0/0x227 [btrfs]
[23283.743708]  [<ffffffff8104e23c>] process_one_work+0x175/0x2ae
[23283.743728]  [<ffffffff8104e73d>] worker_thread+0x144/0x1f0
[23283.743764]  [<ffffffff8104e5f9>] ? rescuer_thread+0x25a/0x25a
[23283.743800]  [<ffffffff8105305d>] kthread+0xa9/0xb1
[23283.743822]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.743829]  [<ffffffff81451dfc>] ret_from_fork+0x7c/0xb0
[23283.743836]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.743843] INFO: task kworker/u8:12:10972 blocked for more than 120 seconds.
[23283.743848]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.743852] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.743855] kworker/u8:12   D ffff88020397e738     0 10972      2 0x00000000
[23283.743869] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-2)
[23283.743875]  ffff8801b5201a00 0000000000000002 ffff8801b52019d0 ffff8801b5201fd8
[23283.743884]  ffff88020397e200 0000000000012dc0 ffff88021e212dc0 ffff88020397e200
[23283.743892]  ffff8801b5201aa0 0000000000000002 ffffffff810d0e57 ffff8801b5201a10
[23283.743901] Call Trace:
[23283.743910]  [<ffffffff810d0e57>] ? wait_on_page_read+0x37/0x37
[23283.743916]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.743922]  [<ffffffff8144abc7>] io_schedule+0x5b/0x75
[23283.743929]  [<ffffffff810d0e60>] sleep_on_page+0x9/0xd
[23283.743935]  [<ffffffff8144af72>] __wait_on_bit_lock+0x41/0x85
[23283.743943]  [<ffffffff810d0f11>] __lock_page+0x64/0x66
[23283.743951]  [<ffffffff8106b6bd>] ? autoremove_wake_function+0x2f/0x2f
[23283.744008]  [<ffffffffa0277454>] lock_page+0x1e/0x21 [btrfs]
[23283.744126]  [<ffffffffa027ad3e>] extent_write_cache_pages.isra.21.constprop.43+0x197/0x2c6 [btrfs]
[23283.744224]  [<ffffffffa027b0f5>] extent_writepages+0x46/0x57 [btrfs]
[23283.744300]  [<ffffffffa0265bd7>] ? btrfs_submit_direct+0x3ea/0x3ea [btrfs]
[23283.744316]  [<ffffffff81450398>] ? preempt_count_add+0x72/0x88
[23283.744379]  [<ffffffffa0263f12>] btrfs_writepages+0x23/0x25 [btrfs]
[23283.744407]  [<ffffffff810dac33>] do_writepages+0x19/0x27
[23283.744420]  [<ffffffff81144f73>] __writeback_single_inode+0x58/0x212
[23283.744433]  [<ffffffff81145c40>] writeback_sb_inodes+0x1df/0x325
[23283.744449]  [<ffffffff81145e00>] __writeback_inodes_wb+0x7a/0xb0
[23283.744461]  [<ffffffff81145f4c>] wb_writeback+0x116/0x274
[23283.744475]  [<ffffffff8114653c>] bdi_writeback_workfn+0x173/0x315
[23283.744489]  [<ffffffff81062114>] ? arch_vtime_task_switch+0x6a/0x6f
[23283.744503]  [<ffffffff8104e23c>] process_one_work+0x175/0x2ae
[23283.744515]  [<ffffffff8104e73d>] worker_thread+0x144/0x1f0
[23283.744527]  [<ffffffff8104e5f9>] ? rescuer_thread+0x25a/0x25a
[23283.744537]  [<ffffffff8105305d>] kthread+0xa9/0xb1
[23283.744549]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.744560]  [<ffffffff81451dfc>] ret_from_fork+0x7c/0xb0
[23283.744572]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.744584] INFO: task kworker/u8:14:10974 blocked for more than 120 seconds.
[23283.744593]       Tainted: G           O  3.15.0-rc5-tp520 #57
[23283.744599] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23283.744606] kworker/u8:14   D ffff8801d1293638     0 10974      2 0x00000000
[23283.744686] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
[23283.744696]  ffff8801dd969b60 0000000000000002 ffff8801dd969b30 ffff8801dd969fd8
[23283.744712]  ffff8801d1293100 0000000000012dc0 ffff88021e212dc0 ffff8801d1293100
[23283.744726]  ffff8801dd969c00 0000000000000002 ffffffff810d0e57 ffff8801dd969b70
[23283.744742] Call Trace:
[23283.744756]  [<ffffffff810d0e57>] ? wait_on_page_read+0x37/0x37
[23283.744767]  [<ffffffff8144aa3b>] schedule+0x6e/0x70
[23283.744778]  [<ffffffff8144abc7>] io_schedule+0x5b/0x75
[23283.744789]  [<ffffffff810d0e60>] sleep_on_page+0x9/0xd
[23283.744801]  [<ffffffff8144af72>] __wait_on_bit_lock+0x41/0x85
[23283.744809]  [<ffffffff810d0f11>] __lock_page+0x64/0x66
[23283.744817]  [<ffffffff8106b6bd>] ? autoremove_wake_function+0x2f/0x2f
[23283.744871]  [<ffffffffa0277454>] lock_page+0x1e/0x21 [btrfs]
[23283.744927]  [<ffffffffa027ad3e>] extent_write_cache_pages.isra.21.constprop.43+0x197/0x2c6 [btrfs]
[23283.744979]  [<ffffffffa027b0f5>] extent_writepages+0x46/0x57 [btrfs]
[23283.745051]  [<ffffffffa0265bd7>] ? btrfs_submit_direct+0x3ea/0x3ea [btrfs]
[23283.745066]  [<ffffffff8105d8c8>] ? get_parent_ip+0xd/0x3c
[23283.745128]  [<ffffffffa0263f12>] btrfs_writepages+0x23/0x25 [btrfs]
[23283.745145]  [<ffffffff810dac33>] do_writepages+0x19/0x27
[23283.745157]  [<ffffffff810d2525>] __filemap_fdatawrite_range+0x50/0x52
[23283.745169]  [<ffffffff810d253e>] filemap_flush+0x17/0x19
[23283.745262]  [<ffffffffa02667d9>] btrfs_run_delalloc_work+0x2d/0x64 [btrfs]
[23283.745366]  [<ffffffffa0286635>] normal_work_helper+0xe0/0x227 [btrfs]
[23283.745414]  [<ffffffff8104e23c>] process_one_work+0x175/0x2ae
[23283.745454]  [<ffffffff8104e73d>] worker_thread+0x144/0x1f0
[23283.745492]  [<ffffffff8104e5f9>] ? rescuer_thread+0x25a/0x25a
[23283.745515]  [<ffffffff8105305d>] kthread+0xa9/0xb1
[23283.745528]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c
[23283.745539]  [<ffffffff81451dfc>] ret_from_fork+0x7c/0xb0
[23283.745551]  [<ffffffff81052fb4>] ? __kthread_parkme+0x5c/0x5c

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
