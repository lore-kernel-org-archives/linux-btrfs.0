From: Roman Mamedov <rm@romanrm.ru>
Subject: btrfs lock-up on copying files
Date: Thu, 30 Jun 2011 12:37:38 +0600
Message-ID: <20110630123738.6042e563@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t9_BcqNHKspdO+RNP3nEC=0"; protocol="application/pgp-signature"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/t9_BcqNHKspdO+RNP3nEC=0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I was copying a set of files to a btrfs filesystem, and the copy process lo=
cked-up with the following messages in dmesg.

The kernel version is 2.6.39.1; the filesystem was recently resized from 3 =
to 4TB (if that matters).

It is mounted remotely via AoE but the remote host is up and no errors rega=
rding block devices are registered on it.
The network is fine and the AoE device with btrfs continues to be accessibl=
e normally on the client.

---------------------------------------------------------------------------=
---------------------------
[2054595.220707] device fsid df4e3e1ef28f59c2-60011bb47a1f19ab devid 1 tran=
sid 120743 /dev/etherd/e1.1
[2054595.221402] btrfs: use zlib compression
[2054595.221405] btrfs: force clearing of disk cache
[2054595.291517] btrfs: disk space caching is enabled
[2055480.556022] INFO: task kthreadd:2 blocked for more than 120 seconds.
[2055480.556026] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055480.556028] kthreadd        D ffff8800bfd13cc0     0     2      0 0x00=
000000
[2055480.556032]  ffff8800bc2786c0 0000000000000046 ffff8800bfd16eb8 000000=
0000000000
[2055480.556036]  ffff880095d3e540 0000000000013cc0 ffff8800bc277fd8 000000=
0000013cc0
[2055480.556039]  ffff8800bc276000 ffff8800bc277fd8 0000000000013cc0 ffff88=
00bc2786c0
[2055480.556043] Call Trace:
[2055480.556050]  [<ffffffff810e5930>] ? __lock_page+0x70/0x70
[2055480.556054]  [<ffffffff813fc7b4>] ? io_schedule+0x84/0xd0
[2055480.556057]  [<ffffffff810e5939>] ? sleep_on_page+0x9/0x10
[2055480.556059]  [<ffffffff813fd15a>] ? __wait_on_bit_lock+0x4a/0xb0
[2055480.556062]  [<ffffffff810e591e>] ? __lock_page+0x5e/0x70
[2055480.556066]  [<ffffffff810789b0>] ? autoremove_wake_function+0x30/0x30
[2055480.556069]  [<ffffffff813fc9af>] ? _cond_resched+0x2f/0x40
[2055480.556073]  [<ffffffff8113123b>] ? move_to_new_page+0x23b/0x240
[2055480.556076]  [<ffffffff81131763>] ? migrate_pages+0x3f3/0x490
[2055480.556078]  [<ffffffff81124e00>] ? perf_trace_mm_compaction_migratepa=
ges+0xf0/0xf0
[2055480.556081]  [<ffffffff81125831>] ? compact_zone+0x591/0x880
[2055480.556084]  [<ffffffff81125d09>] ? compact_zone_order+0xa9/0xf0
[2055480.556087]  [<ffffffff810be4a2>] ? delayacct_end+0x82/0xa0
[2055480.556090]  [<ffffffff81125e40>] ? try_to_compact_pages+0xf0/0x120
[2055480.556093]  [<ffffffff810ed15e>] ? __alloc_pages_direct_compact+0xde/=
0x1b0
[2055480.556096]  [<ffffffff810ed707>] ? __alloc_pages_nodemask+0x4d7/0x920
[2055480.556100]  [<ffffffff810555c8>] ? copy_process+0x148/0x1230
[2055480.556103]  [<ffffffff81056751>] ? do_fork+0x71/0x380
[2055480.556106]  [<ffffffff81010d21>] ? native_sched_clock+0x11/0x60
[2055480.556110]  [<ffffffff810498fa>] ? update_curr+0xea/0x1f0
[2055480.556113]  [<ffffffff81011a5c>] ? kernel_thread+0x7c/0x90
[2055480.556116]  [<ffffffff81078330>] ? kthread_worker_fn+0x1a0/0x1a0
[2055480.556119]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055480.556121]  [<ffffffff810787e6>] ? kthreadd+0x106/0x140
[2055480.556124]  [<ffffffff81407464>] ? kernel_thread_helper+0x4/0x10
[2055480.556127]  [<ffffffff810786e0>] ? tsk_fork_get_node+0x20/0x20
[2055480.556129]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055480.556166] INFO: task btrfs-transacti:24692 blocked for more than 120=
 seconds.
[2055480.556167] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055480.556169] btrfs-transacti D ffff8800bfd13cc0     0 24692      2 0x00=
000000
[2055480.556173]  ffff8800871d4380 0000000000000046 0000000000000ec2 ffff88=
0000000000
[2055480.556176]  ffff8800bc27ca40 0000000000013cc0 ffff88008a643fd8 000000=
0000013cc0
[2055480.556179]  ffff88008a642000 ffff88008a643fd8 0000000000013cc0 ffff88=
00871d4380
[2055480.556182] Call Trace:
[2055480.556185]  [<ffffffff813fcfcd>] ? schedule_timeout+0x22d/0x310
[2055480.556219]  [<ffffffffa02fb707>] ? btrfs_run_delayed_refs+0xc7/0x210 =
[btrfs]
[2055480.556222]  [<ffffffff813fd3f6>] ? mutex_lock+0x16/0x50
[2055480.556233]  [<ffffffffa032aa1d>] ? btrfs_run_ordered_operations+0x1cd=
/0x1f0 [btrfs]
[2055480.556245]  [<ffffffffa030bc8d>] ? btrfs_commit_transaction+0x26d/0x7=
a0 [btrfs]
[2055480.556248]  [<ffffffff81078980>] ? wake_up_bit+0x40/0x40
[2055480.556258]  [<ffffffffa0305363>] ? transaction_kthread+0x273/0x290 [b=
trfs]
[2055480.556268]  [<ffffffffa03050f0>] ? btrfs_congested_fn+0x90/0x90 [btrf=
s]
[2055480.556278]  [<ffffffffa03050f0>] ? btrfs_congested_fn+0x90/0x90 [btrf=
s]
[2055480.556281]  [<ffffffff810783c6>] ? kthread+0x96/0xa0
[2055480.556284]  [<ffffffff81407464>] ? kernel_thread_helper+0x4/0x10
[2055480.556287]  [<ffffffff81078330>] ? kthread_worker_fn+0x1a0/0x1a0
[2055480.556289]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055480.556291] INFO: task mirrordir:24715 blocked for more than 120 secon=
ds.
[2055480.556293] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055480.556295] mirrordir       D ffff8800bfd13cc0     0 24715  24660 0x00=
000000
[2055480.556298]  ffff880087278d80 0000000000000082 0000000000000003 ffff88=
000d8b1910
[2055480.556301]  ffff880095d3e540 0000000000013cc0 ffff88000d8b1fd8 000000=
0000013cc0
[2055480.556304]  ffff88000d8b0000 ffff88000d8b1fd8 0000000000013cc0 ffff88=
0087278d80
[2055480.556307] Call Trace:
[2055480.556317]  [<ffffffffa032e9d6>] ? __extent_writepage+0x386/0x760 [bt=
rfs]
[2055480.556320]  [<ffffffff810e5930>] ? __lock_page+0x70/0x70
[2055480.556323]  [<ffffffff813fc7b4>] ? io_schedule+0x84/0xd0
[2055480.556326]  [<ffffffff810e5939>] ? sleep_on_page+0x9/0x10
[2055480.556328]  [<ffffffff813fd15a>] ? __wait_on_bit_lock+0x4a/0xb0
[2055480.556331]  [<ffffffff810e591e>] ? __lock_page+0x5e/0x70
[2055480.556334]  [<ffffffff810789b0>] ? autoremove_wake_function+0x30/0x30
[2055480.556345]  [<ffffffffa032ef63>] ? extent_write_cache_pages.clone.18.=
clone.25+0x1b3/0x2e0 [btrfs]
[2055480.556356]  [<ffffffffa032f340>] ? extent_writepages+0x40/0x60 [btrfs]
[2055480.556367]  [<ffffffffa030f370>] ? btrfs_writepage_fixup_worker+0x150=
/0x150 [btrfs]
[2055480.556371]  [<ffffffff8115ede4>] ? writeback_single_inode+0x104/0x250
[2055480.556373]  [<ffffffff8115f196>] ? writeback_sb_inodes+0xf6/0x1a0
[2055480.556376]  [<ffffffff8115f3bd>] ? writeback_inodes_wb+0x8d/0x1a0
[2055480.556379]  [<ffffffff810efecb>] ? balance_dirty_pages_ratelimited_nr=
+0x3bb/0x4b0
[2055480.556391]  [<ffffffffa031a76c>] ? __btrfs_buffered_write.clone.13+0x=
22c/0x2f0 [btrfs]
[2055480.556394]  [<ffffffff8105cbdd>] ? current_fs_time+0xd/0x50
[2055480.556405]  [<ffffffffa031aa5d>] ? btrfs_file_aio_write+0x22d/0x4a0 [=
btrfs]
[2055480.556416]  [<ffffffffa031a832>] ? btrfs_file_aio_write+0x2/0x4a0 [bt=
rfs]
[2055480.556420]  [<ffffffff811398bf>] ? do_sync_write+0xbf/0x100
[2055480.556424]  [<ffffffff811bfa64>] ? security_file_permission+0x24/0xc0
[2055480.556427]  [<ffffffff8113a056>] ? vfs_write+0xc6/0x180
[2055480.556430]  [<ffffffff8113a36e>] ? sys_write+0x4e/0x90
[2055480.556433]  [<ffffffff81406352>] ? system_call_fastpath+0x16/0x1b
[2055480.556436] INFO: task btrfs-delalloc-:24754 blocked for more than 120=
 seconds.
[2055480.556437] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055480.556439] btrfs-delalloc- D ffff8800bfd13cc0     0 24754      2 0x00=
000000
[2055480.556442]  ffff880095d39b00 0000000000000046 ffff8800bffe7c08 000000=
0200000001
[2055480.556446]  ffff8800af69d7c0 0000000000013cc0 ffff8800060c3fd8 000000=
0000013cc0
[2055480.556449]  ffff8800060c2000 ffff8800060c3fd8 0000000000013cc0 ffff88=
0095d39b00
[2055480.556452] Call Trace:
[2055480.556455]  [<ffffffff813fcfcd>] ? schedule_timeout+0x22d/0x310
[2055480.556458]  [<ffffffff81047a63>] ? select_task_rq_fair+0x2f3/0x750
[2055480.556461]  [<ffffffff813fcaa1>] ? wait_for_common+0xe1/0x1a0
[2055480.556464]  [<ffffffff81050e20>] ? try_to_wake_up+0x320/0x320
[2055480.556466]  [<ffffffff81050bbc>] ? try_to_wake_up+0xbc/0x320
[2055480.556471]  [<ffffffff8107862f>] ? kthread_create_on_node+0x8f/0x110
[2055480.556480]  [<ffffffffa02f76e0>] ? btrfs_put_block_group+0x70/0x70 [b=
trfs]
[2055480.556484]  [<ffffffff812162ba>] ? rwsem_wake+0x4a/0x60
[2055480.556487]  [<ffffffff8121b7f7>] ? call_rwsem_wake+0x17/0x30
[2055480.556498]  [<ffffffffa02f757a>] ? cache_block_group+0x1ba/0x2a0 [btr=
fs]
[2055480.556508]  [<ffffffffa02fc230>] ? find_free_extent.clone.64+0x400/0x=
aa0 [btrfs]
[2055480.556518]  [<ffffffffa02fd5ea>] ? btrfs_reserve_extent+0xea/0x1b0 [b=
trfs]
[2055480.556529]  [<ffffffffa03129db>] ? cow_file_range+0x16b/0x370 [btrfs]
[2055480.556540]  [<ffffffffa03138e8>] ? submit_compressed_extents+0x228/0x=
440 [btrfs]
[2055480.556544]  [<ffffffff8106678a>] ? try_to_del_timer_sync+0x7a/0xd0
[2055480.556554]  [<ffffffffa0338f43>] ? run_ordered_completions+0x63/0xc0 =
[btrfs]
[2055480.556564]  [<ffffffffa03397f1>] ? worker_loop+0xb1/0x510 [btrfs]
[2055480.556574]  [<ffffffffa0339740>] ? btrfs_queue_worker+0x2f0/0x2f0 [bt=
rfs]
[2055480.556583]  [<ffffffffa0339740>] ? btrfs_queue_worker+0x2f0/0x2f0 [bt=
rfs]
[2055480.556587]  [<ffffffff810783c6>] ? kthread+0x96/0xa0
[2055480.556589]  [<ffffffff81407464>] ? kernel_thread_helper+0x4/0x10
[2055480.556593]  [<ffffffff81078330>] ? kthread_worker_fn+0x1a0/0x1a0
[2055480.556595]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055600.556049] INFO: task btrfs-transacti:24692 blocked for more than 120=
 seconds.
[2055600.556052] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055600.556055] btrfs-transacti D ffff8800bfd13cc0     0 24692      2 0x00=
000000
[2055600.556059]  ffff8800871d4380 0000000000000046 0000000000000ec2 ffff88=
0000000000
[2055600.556063]  ffff8800bc27ca40 0000000000013cc0 ffff88008a643fd8 000000=
0000013cc0
[2055600.556066]  ffff88008a642000 ffff88008a643fd8 0000000000013cc0 ffff88=
00871d4380
[2055600.556069] Call Trace:
[2055600.556077]  [<ffffffff813fcfcd>] ? schedule_timeout+0x22d/0x310
[2055600.556110]  [<ffffffffa02fb707>] ? btrfs_run_delayed_refs+0xc7/0x210 =
[btrfs]
[2055600.556113]  [<ffffffff813fd3f6>] ? mutex_lock+0x16/0x50
[2055600.556125]  [<ffffffffa032aa1d>] ? btrfs_run_ordered_operations+0x1cd=
/0x1f0 [btrfs]
[2055600.556136]  [<ffffffffa030bc8d>] ? btrfs_commit_transaction+0x26d/0x7=
a0 [btrfs]
[2055600.556141]  [<ffffffff81078980>] ? wake_up_bit+0x40/0x40
[2055600.556151]  [<ffffffffa0305363>] ? transaction_kthread+0x273/0x290 [b=
trfs]
[2055600.556161]  [<ffffffffa03050f0>] ? btrfs_congested_fn+0x90/0x90 [btrf=
s]
[2055600.556171]  [<ffffffffa03050f0>] ? btrfs_congested_fn+0x90/0x90 [btrf=
s]
[2055600.556174]  [<ffffffff810783c6>] ? kthread+0x96/0xa0
[2055600.556178]  [<ffffffff81407464>] ? kernel_thread_helper+0x4/0x10
[2055600.556181]  [<ffffffff81078330>] ? kthread_worker_fn+0x1a0/0x1a0
[2055600.556183]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055600.556186] INFO: task mirrordir:24715 blocked for more than 120 secon=
ds.
[2055600.556187] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055600.556189] mirrordir       D ffff8800bfd13cc0     0 24715  24660 0x00=
000000
[2055600.556193]  ffff880087278d80 0000000000000082 0000000000000003 ffff88=
000d8b1910
[2055600.556196]  ffff880095d3e540 0000000000013cc0 ffff88000d8b1fd8 000000=
0000013cc0
[2055600.556199]  ffff88000d8b0000 ffff88000d8b1fd8 0000000000013cc0 ffff88=
0087278d80
[2055600.556203] Call Trace:
[2055600.556214]  [<ffffffffa032e9d6>] ? __extent_writepage+0x386/0x760 [bt=
rfs]
[2055600.556217]  [<ffffffff810e5930>] ? __lock_page+0x70/0x70
[2055600.556220]  [<ffffffff813fc7b4>] ? io_schedule+0x84/0xd0
[2055600.556223]  [<ffffffff810e5939>] ? sleep_on_page+0x9/0x10
[2055600.556226]  [<ffffffff813fd15a>] ? __wait_on_bit_lock+0x4a/0xb0
[2055600.556228]  [<ffffffff810e591e>] ? __lock_page+0x5e/0x70
[2055600.556231]  [<ffffffff810789b0>] ? autoremove_wake_function+0x30/0x30
[2055600.556242]  [<ffffffffa032ef63>] ? extent_write_cache_pages.clone.18.=
clone.25+0x1b3/0x2e0 [btrfs]
[2055600.556253]  [<ffffffffa032f340>] ? extent_writepages+0x40/0x60 [btrfs]
[2055600.556264]  [<ffffffffa030f370>] ? btrfs_writepage_fixup_worker+0x150=
/0x150 [btrfs]
[2055600.556268]  [<ffffffff8115ede4>] ? writeback_single_inode+0x104/0x250
[2055600.556271]  [<ffffffff8115f196>] ? writeback_sb_inodes+0xf6/0x1a0
[2055600.556274]  [<ffffffff8115f3bd>] ? writeback_inodes_wb+0x8d/0x1a0
[2055600.556277]  [<ffffffff810efecb>] ? balance_dirty_pages_ratelimited_nr=
+0x3bb/0x4b0
[2055600.556288]  [<ffffffffa031a76c>] ? __btrfs_buffered_write.clone.13+0x=
22c/0x2f0 [btrfs]
[2055600.556292]  [<ffffffff8105cbdd>] ? current_fs_time+0xd/0x50
[2055600.556303]  [<ffffffffa031aa5d>] ? btrfs_file_aio_write+0x22d/0x4a0 [=
btrfs]
[2055600.556314]  [<ffffffffa031a832>] ? btrfs_file_aio_write+0x2/0x4a0 [bt=
rfs]
[2055600.556318]  [<ffffffff811398bf>] ? do_sync_write+0xbf/0x100
[2055600.556323]  [<ffffffff811bfa64>] ? security_file_permission+0x24/0xc0
[2055600.556325]  [<ffffffff8113a056>] ? vfs_write+0xc6/0x180
[2055600.556328]  [<ffffffff8113a36e>] ? sys_write+0x4e/0x90
[2055600.556331]  [<ffffffff81406352>] ? system_call_fastpath+0x16/0x1b
[2055600.556334] INFO: task btrfs-delalloc-:24754 blocked for more than 120=
 seconds.
[2055600.556336] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055600.556337] btrfs-delalloc- D ffff8800bfd13cc0     0 24754      2 0x00=
000000
[2055600.556341]  ffff880095d39b00 0000000000000046 ffff8800bffe7c08 000000=
0200000001
[2055600.556344]  ffff8800af69d7c0 0000000000013cc0 ffff8800060c3fd8 000000=
0000013cc0
[2055600.556347]  ffff8800060c2000 ffff8800060c3fd8 0000000000013cc0 ffff88=
0095d39b00
[2055600.556350] Call Trace:
[2055600.556353]  [<ffffffff813fcfcd>] ? schedule_timeout+0x22d/0x310
[2055600.556356]  [<ffffffff81047a63>] ? select_task_rq_fair+0x2f3/0x750
[2055600.556359]  [<ffffffff813fcaa1>] ? wait_for_common+0xe1/0x1a0
[2055600.556363]  [<ffffffff81050e20>] ? try_to_wake_up+0x320/0x320
[2055600.556365]  [<ffffffff81050bbc>] ? try_to_wake_up+0xbc/0x320
[2055600.556370]  [<ffffffff8107862f>] ? kthread_create_on_node+0x8f/0x110
[2055600.556379]  [<ffffffffa02f76e0>] ? btrfs_put_block_group+0x70/0x70 [b=
trfs]
[2055600.556383]  [<ffffffff812162ba>] ? rwsem_wake+0x4a/0x60
[2055600.556386]  [<ffffffff8121b7f7>] ? call_rwsem_wake+0x17/0x30
[2055600.556397]  [<ffffffffa02f757a>] ? cache_block_group+0x1ba/0x2a0 [btr=
fs]
[2055600.556406]  [<ffffffffa02fc230>] ? find_free_extent.clone.64+0x400/0x=
aa0 [btrfs]
[2055600.556417]  [<ffffffffa02fd5ea>] ? btrfs_reserve_extent+0xea/0x1b0 [b=
trfs]
[2055600.556428]  [<ffffffffa03129db>] ? cow_file_range+0x16b/0x370 [btrfs]
[2055600.556439]  [<ffffffffa03138e8>] ? submit_compressed_extents+0x228/0x=
440 [btrfs]
[2055600.556443]  [<ffffffff8106678a>] ? try_to_del_timer_sync+0x7a/0xd0
[2055600.556453]  [<ffffffffa0338f43>] ? run_ordered_completions+0x63/0xc0 =
[btrfs]
[2055600.556463]  [<ffffffffa03397f1>] ? worker_loop+0xb1/0x510 [btrfs]
[2055600.556473]  [<ffffffffa0339740>] ? btrfs_queue_worker+0x2f0/0x2f0 [bt=
rfs]
[2055600.556483]  [<ffffffffa0339740>] ? btrfs_queue_worker+0x2f0/0x2f0 [bt=
rfs]
[2055600.556486]  [<ffffffff810783c6>] ? kthread+0x96/0xa0
[2055600.556488]  [<ffffffff81407464>] ? kernel_thread_helper+0x4/0x10
[2055600.556492]  [<ffffffff81078330>] ? kthread_worker_fn+0x1a0/0x1a0
[2055600.556494]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055720.556041] INFO: task kthreadd:2 blocked for more than 120 seconds.
[2055720.556044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055720.556047] kthreadd        D ffff8800bfc13cc0     0     2      0 0x00=
000000
[2055720.556051]  ffff8800bc2786c0 0000000000000046 ffff8800bfd16eb8 000000=
0000000000
[2055720.556055]  ffffffff8180b020 0000000000013cc0 ffff8800bc277fd8 000000=
0000013cc0
[2055720.556058]  ffff8800bc276000 ffff8800bc277fd8 0000000000013cc0 ffff88=
00bc2786c0
[2055720.556061] Call Trace:
[2055720.556069]  [<ffffffff810e5930>] ? __lock_page+0x70/0x70
[2055720.556073]  [<ffffffff813fc7b4>] ? io_schedule+0x84/0xd0
[2055720.556076]  [<ffffffff810e5939>] ? sleep_on_page+0x9/0x10
[2055720.556079]  [<ffffffff813fd15a>] ? __wait_on_bit_lock+0x4a/0xb0
[2055720.556082]  [<ffffffff810e591e>] ? __lock_page+0x5e/0x70
[2055720.556086]  [<ffffffff810789b0>] ? autoremove_wake_function+0x30/0x30
[2055720.556089]  [<ffffffff813fc9af>] ? _cond_resched+0x2f/0x40
[2055720.556093]  [<ffffffff8113123b>] ? move_to_new_page+0x23b/0x240
[2055720.556096]  [<ffffffff81131763>] ? migrate_pages+0x3f3/0x490
[2055720.556099]  [<ffffffff81124e00>] ? perf_trace_mm_compaction_migratepa=
ges+0xf0/0xf0
[2055720.556101]  [<ffffffff81125831>] ? compact_zone+0x591/0x880
[2055720.556104]  [<ffffffff81125d09>] ? compact_zone_order+0xa9/0xf0
[2055720.556107]  [<ffffffff810be4a2>] ? delayacct_end+0x82/0xa0
[2055720.556110]  [<ffffffff81125e40>] ? try_to_compact_pages+0xf0/0x120
[2055720.556114]  [<ffffffff810ed15e>] ? __alloc_pages_direct_compact+0xde/=
0x1b0
[2055720.556117]  [<ffffffff810ed707>] ? __alloc_pages_nodemask+0x4d7/0x920
[2055720.556121]  [<ffffffff810555c8>] ? copy_process+0x148/0x1230
[2055720.556124]  [<ffffffff81056751>] ? do_fork+0x71/0x380
[2055720.556127]  [<ffffffff81010d21>] ? native_sched_clock+0x11/0x60
[2055720.556131]  [<ffffffff810498fa>] ? update_curr+0xea/0x1f0
[2055720.556133]  [<ffffffff81011a5c>] ? kernel_thread+0x7c/0x90
[2055720.556137]  [<ffffffff81078330>] ? kthread_worker_fn+0x1a0/0x1a0
[2055720.556139]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055720.556142]  [<ffffffff810787e6>] ? kthreadd+0x106/0x140
[2055720.556145]  [<ffffffff81407464>] ? kernel_thread_helper+0x4/0x10
[2055720.556148]  [<ffffffff810786e0>] ? tsk_fork_get_node+0x20/0x20
[2055720.556150]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055720.556184] INFO: task kworker/1:3:24047 blocked for more than 120 sec=
onds.
[2055720.556186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055720.556188] kworker/1:3     D ffff8800bfd13cc0     0 24047      2 0x00=
000000
[2055720.556191]  ffff88008718de80 0000000000000046 0000000000013cc0 000000=
0000000000
[2055720.556194]  ffff8800bc27ca40 0000000000013cc0 ffff8800b9e5ffd8 000000=
0000013cc0
[2055720.556198]  ffff8800b9e5e000 ffff8800b9e5ffd8 0000000000013cc0 ffff88=
008718de80
[2055720.556201] Call Trace:
[2055720.556204]  [<ffffffff813fcfcd>] ? schedule_timeout+0x22d/0x310
[2055720.556207]  [<ffffffff81010d21>] ? native_sched_clock+0x11/0x60
[2055720.556210]  [<ffffffff813fcaa1>] ? wait_for_common+0xe1/0x1a0
[2055720.556213]  [<ffffffff81050e20>] ? try_to_wake_up+0x320/0x320
[2055720.556217]  [<ffffffff8107862f>] ? kthread_create_on_node+0x8f/0x110
[2055720.556220]  [<ffffffff81073960>] ? manage_workers.clone.21+0x230/0x230
[2055720.556223]  [<ffffffff8112ccd7>] ? kmem_cache_alloc_trace+0xd7/0x130
[2055720.556226]  [<ffffffff810736ae>] ? create_worker+0x13e/0x1c0
[2055720.556229]  [<ffffffff8107384d>] ? manage_workers.clone.21+0x11d/0x230
[2055720.556232]  [<ffffffff81073bef>] ? worker_thread+0x28f/0x340
[2055720.556235]  [<ffffffff81073960>] ? manage_workers.clone.21+0x230/0x230
[2055720.556237]  [<ffffffff81073960>] ? manage_workers.clone.21+0x230/0x230
[2055720.556240]  [<ffffffff810783c6>] ? kthread+0x96/0xa0
[2055720.556243]  [<ffffffff81407464>] ? kernel_thread_helper+0x4/0x10
[2055720.556246]  [<ffffffff81078330>] ? kthread_worker_fn+0x1a0/0x1a0
[2055720.556248]  [<ffffffff81407460>] ? gs_change+0x13/0x13
[2055720.556253] INFO: task btrfs-transacti:24692 blocked for more than 120=
 seconds.
[2055720.556254] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
[2055720.556256] btrfs-transacti D ffff8800bfd13cc0     0 24692      2 0x00=
000000
[2055720.556259]  ffff8800871d4380 0000000000000046 0000000000000ec2 ffff88=
0000000000
[2055720.556262]  ffff8800bc27ca40 0000000000013cc0 ffff88008a643fd8 000000=
0000013cc0
[2055720.556265]  ffff88008a642000 ffff88008a643fd8 0000000000013cc0 ffff88=
00871d4380
[2055720.556268] Call Trace:
[2055720.556271]  [<ffffffff813fcfcd>] ? schedule_timeout+0x22d/0x310
[2055720.556303]  [<ffffffffa02fb707>] ? btrfs_run_delayed_refs+0xc7/0x210 =
[btrfs]
[2055720.556306]  [<ffffffff813fd3f6>] ? mutex_lock+0x16/0x50
[2055720.556318]  [<ffffffffa032aa1d>] ? btrfs_run_ordered_operations+0x1cd=
/0x1f0 [btrfs]
[2055720.556330]  [<ffffffffa030bc8d>] ? btrfs_commit_transaction+0x26d/0x7=
a0 [btrfs]
[2055720.556333]  [<ffffffff81078980>] ? wake_up_bit+0x40/0x40
[2055720.556343]  [<ffffffffa0305363>] ? transaction_kthread+0x273/0x290 [b=
trfs]
[2055720.556353]  [<ffffffffa03050f0>] ? btrfs_congested_fn+0x90/0x90 [btrf=
s]
[2055720.556363]  [<ffffffffa03050f0>] ? btrfs_congested_fn+0x90/0x90 [btrf=
s]
[2055720.556366]  [<ffffffff810783c6>] ? kthread+0x96/0xa0
[2055720.556369]  [<ffffffff81407464>] ? kernel_thread_helper+0x4/0x10
[2055720.556372]  [<ffffffff81078330>] ? kthread_worker_fn+0x1a0/0x1a0
[2055720.556374]  [<ffffffff81407460>] ? gs_change+0x13/0x13

--=20
With respect,
Roman

--Sig_/t9_BcqNHKspdO+RNP3nEC=0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEARECAAYFAk4MGbIACgkQTLKSvz+PZwiDmgCUDY1gXRt0rYM8nkqNQSkCknZS
QwCgjj6dhibssc0dXkvmo/EGM7+ZQh4=
=+OGE
-----END PGP SIGNATURE-----

--Sig_/t9_BcqNHKspdO+RNP3nEC=0--
