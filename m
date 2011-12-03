From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Blocked for more than 120 seconds
Date: Sat, 03 Dec 2011 16:36:44 +0200
Message-ID: <4EDA33FC.5020206@gmail.com>
References: <4ED34359.6010305@robotech.de> <1322472549.1962.2.camel@Nokia-N900> <4ED5FAEF.8070400@robotech.de> <20111130141006.GY24338@shiny> <4ED738E5.3080200@robotech.de> <20111201184158.GB10535@shiny> <4ED8D6C8.4020609@robotech.de> <4ED8ED36.3080105@gmail.com> <4ED8F34F.8090609@robotech.de> <4ED92CA6.3030302@gmail.com> <4ED96EE6.2010308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED96EE6.2010308@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

unfortunately i was wrong. rc4 does not fix this issue for me when=20
rsyncing large amounts of data...

my mount options:
mount -o loop,compress=3Dzlib,compress-force btrfs_test /storage/btrfs
the filesystem is a file on a raid5 xfs volume.

[15481.098588] INFO: task loop0:1729 blocked for more than 120 seconds.
[15481.099571] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15481.100564] loop0           D 000000010044b6c5     0  1729      2=20
0x00000000
[15481.101550]  ffff8801f9b31b30 0000000000000046 0000000000000000=20
0000000000000000
[15481.102548]  ffff880200950e40 ffff8801f9b31fd8 ffff8801f9b31fd8=20
ffff8801f9b31fd8
[15481.103539]  ffff880202cb7200 ffff880200950e40 0000000000000002=20
ffff8801f9b31b78
[15481.104533] Call Trace:
[15481.105531]  [<ffffffff81101a55>] ? find_get_pages_tag+0x125/0x150
[15481.106541]  [<ffffffff8110e205>] ? pagevec_lookup_tag+0x25/0x40
[15481.107552]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[15481.108576]  [<ffffffff8108f14d>] ? ktime_get_ts+0xad/0xe0
[15481.109592]  [<ffffffff81101d60>] ? __lock_page+0x70/0x70
[15481.110607]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15481.111619]  [<ffffffff8141416f>] io_schedule+0x8f/0xd0
[15481.112641]  [<ffffffff81101d6e>] sleep_on_page+0xe/0x20
[15481.113639]  [<ffffffff8141491f>] __wait_on_bit+0x5f/0x90
[15481.114629]  [<ffffffff81101f58>] wait_on_page_bit+0x78/0x80
[15481.115628]  [<ffffffff81085790>] ?=20
autoremove_wake_function+0x40/0x40
[15481.116614]  [<ffffffff811020cc>] filemap_fdatawait_range+0x10c/0x1a=
0
[15481.117613]  [<ffffffff811030c8>]=20
filemap_write_and_wait_range+0x68/0x80
[15481.118630]  [<ffffffffa03a7234>] xfs_file_fsync+0x54/0x340 [xfs]
[15481.119629]  [<ffffffff8119148b>] vfs_fsync+0x2b/0x40
[15481.120627]  [<ffffffffa04dacf2>] do_bio_filebacked+0x1b2/0x320=20
[loop]
[15481.121645]  [<ffffffffa050efac>] ? end_workqueue_bio+0x9c/0xa0=20
[btrfs]
[15481.122668]  [<ffffffffa04daf1b>] loop_thread+0xbb/0x260 [loop]
[15481.123674]  [<ffffffff81085750>] ? abort_exclusive_wait+0xb0/0xb0
[15481.124676]  [<ffffffffa04dae60>] ? do_bio_filebacked+0x320/0x320=20
[loop]
[15481.125698]  [<ffffffff81084e0c>] kthread+0x8c/0xa0
[15481.126710]  [<ffffffff81419a34>] kernel_thread_helper+0x4/0x10
[15481.127721]  [<ffffffff81084d80>] ? kthread_worker_fn+0x190/0x190
[15481.128742]  [<ffffffff81419a30>] ? gs_change+0x13/0x13
[15481.129728] INFO: task btrfs-transacti:1756 blocked for more than=20
120 seconds.
[15481.130706] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15481.131702] btrfs-transacti D ffff8801f9ab7200     0  1756      2=20
0x00000000
[15481.132723]  ffff8801e7533bc0 0000000000000046 ffff88020fc93400=20
0000000000000002
[15481.133744]  ffff8801f9ab7200 ffff8801e7533fd8 ffff8801e7533fd8=20
ffff8801e7533fd8
[15481.134771]  ffff880200950e40 ffff8801f9ab7200 ffff8801e7533b10=20
0000000081051ae2
[15481.135813] Call Trace:
[15481.136828]  [<ffffffff8105ad36>] ?=20
ttwu_do_activate.constprop.172+0x66/0x70
[15481.137863]  [<ffffffff8105bd6e>] ? try_to_wake_up+0x1de/0x290
[15481.138914]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15481.139956]  [<ffffffff814147d5>] schedule_timeout+0x305/0x390
[15481.141007]  [<ffffffff8104d003>] ? __wake_up+0x53/0x70
[15481.142074]  [<ffffffff81413348>] wait_for_common+0xc8/0x160
[15481.143124]  [<ffffffff8105be20>] ? try_to_wake_up+0x290/0x290
[15481.144170]  [<ffffffff814133fd>] wait_for_completion+0x1d/0x20
[15481.145229]  [<ffffffffa050f0bb>] write_dev_flush+0x4b/0x140 [btrfs]
[15481.146275]  [<ffffffffa0511086>] write_all_supers+0x6f6/0x800=20
[btrfs]
[15481.147317]  [<ffffffffa05111a3>] write_ctree_super+0x13/0x20 [btrfs=
]
[15481.148354]  [<ffffffffa05164dd>]=20
btrfs_commit_transaction+0x63d/0x880 [btrfs]
[15481.149397]  [<ffffffff81085750>] ? abort_exclusive_wait+0xb0/0xb0
[15481.150416]  [<ffffffffa0516b74>] ? start_transaction+0x94/0x2b0=20
[btrfs]
[15481.151444]  [<ffffffffa050ed4d>] transaction_kthread+0x26d/0x290=20
[btrfs]
[15481.152492]  [<ffffffffa050eae0>] ? btrfs_congested_fn+0xd0/0xd0=20
[btrfs]
[15481.153519]  [<ffffffff81084e0c>] kthread+0x8c/0xa0
[15481.154542]  [<ffffffff81419a34>] kernel_thread_helper+0x4/0x10
[15481.155553]  [<ffffffff81084d80>] ? kthread_worker_fn+0x190/0x190
[15481.156522]  [<ffffffff81419a30>] ? gs_change+0x13/0x13
[15481.157501] INFO: task smbd:2058 blocked for more than 120 seconds.
[15481.158513] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15481.159519] smbd            D 000000010044b8d7     0  2058    823=20
0x00000004
[15481.160544]  ffff88005cf37a08 0000000000000082 ffff88005cf37938=20
ffffffff81371188
[15481.161588]  ffff8802012e63c0 ffff88005cf37fd8 ffff88005cf37fd8=20
ffff88005cf37fd8
[15481.162658]  ffff880202d21c80 ffff8802012e63c0 ffff8802012769c0=20
0000000000000246
[15481.163708] Call Trace:
[15481.164736]  [<ffffffff81371188>] ? sch_direct_xmit+0x68/0x1d0
[15481.165781]  [<ffffffff81355a00>] ? dev_queue_xmit+0x200/0x680
[15481.166805]  [<ffffffff81389200>] ? ip_forward_options+0x1c0/0x1c0
[15481.167822]  [<ffffffff8138adbe>] ? ip_finish_output+0x18e/0x310
[15481.168850]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[15481.169853]  [<ffffffff8108f14d>] ? ktime_get_ts+0xad/0xe0
[15481.170849]  [<ffffffff81101d60>] ? __lock_page+0x70/0x70
[15481.171858]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15481.172851]  [<ffffffff8141416f>] io_schedule+0x8f/0xd0
[15481.173844]  [<ffffffff81101d6e>] sleep_on_page+0xe/0x20
[15481.174836]  [<ffffffff8141491f>] __wait_on_bit+0x5f/0x90
[15481.175845]  [<ffffffff81101f58>] wait_on_page_bit+0x78/0x80
[15481.176842]  [<ffffffff81085790>] ?=20
autoremove_wake_function+0x40/0x40
[15481.177845]  [<ffffffff81102845>]=20
grab_cache_page_write_begin+0x95/0xe0
[15481.178872]  [<ffffffffa03a1150>] ? xfs_get_blocks_direct+0x20/0x20=20
[xfs]
[15481.179888]  [<ffffffff811967b8>] block_write_begin+0x38/0xa0
[15481.180904]  [<ffffffffa03a1213>] xfs_vm_write_begin+0x43/0x70 [xfs]
[15481.181928]  [<ffffffff8110233c>]=20
generic_file_buffered_write+0x10c/0x270
[15481.182955]  [<ffffffffa03aad66>] ? xfs_iunlock+0x116/0x180 [xfs]
[15481.183979]  [<ffffffffa03a7fef>]=20
xfs_file_buffered_aio_write+0x10f/0x200 [xfs]
[15481.185011]  [<ffffffffa03a8252>] xfs_file_aio_write+0x172/0x2a0=20
[xfs]
[15481.186052]  [<ffffffff81162d62>] do_sync_write+0xd2/0x110
[15481.187073]  [<ffffffff811f0fcc>] ?=20
security_file_permission+0x2c/0xb0
[15481.188096]  [<ffffffff81163311>] ? rw_verify_area+0x61/0xf0
[15481.189127]  [<ffffffff8116366f>] vfs_write+0xaf/0x180
[15481.190141]  [<ffffffff81163b12>] sys_pwrite64+0x82/0xb0
[15481.191149]  [<ffffffff814178c2>] system_call_fastpath+0x16/0x1b
[15481.192171] INFO: task kworker/2:3:3713 blocked for more than 120=20
seconds.
[15481.193191] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15481.194224] kworker/2:3     D 0000000000000000     0  3713      2=20
0x00000000
[15481.195273]  ffff880005d49cc0 0000000000000046 0000000246417c40=20
0000000800000000
[15481.196304]  ffff8802013eaac0 ffff880005d49fd8 ffff880005d49fd8=20
ffff880005d49fd8
[15481.197329]  ffff8802013eeae0 ffff8802013eaac0 ffff880005d49c20=20
ffffffffa03a3fcb
[15481.198345] Call Trace:
[15481.199365]  [<ffffffffa03a3fcb>] ? xfs_buf_iorequest+0x6b/0x100=20
[xfs]
[15481.200393]  [<ffffffffa03fa603>] ? xlog_bdstrat+0x23/0x60 [xfs]
[15481.201408]  [<ffffffffa03fb287>] ? xlog_sync+0x1d7/0x3c0 [xfs]
[15481.202419]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15481.203418]  [<ffffffffa03fe62b>] _xfs_log_force_lsn+0x29b/0x2d0=20
[xfs]
[15481.204420]  [<ffffffff8105be20>] ? try_to_wake_up+0x290/0x290
[15481.205438]  [<ffffffffa03fa23b>] xfs_trans_commit+0x29b/0x2b0 [xfs]
[15481.206450]  [<ffffffffa03b4c60>] ? xfs_sync_inode_attr+0xf0/0xf0=20
[xfs]
[15481.207466]  [<ffffffffa03aa162>] xfs_fs_log_dummy+0x62/0x90 [xfs]
[15481.208486]  [<ffffffff8111ff90>] ? refresh_cpu_vm_stats+0x1a0/0x1a0
[15481.209504]  [<ffffffffa03b4ce4>] xfs_sync_worker+0x84/0x90 [xfs]
[15481.210518]  [<ffffffff8107f446>] process_one_work+0x116/0x4d0
[15481.211531]  [<ffffffff8107fdde>] worker_thread+0x15e/0x350
[15481.212559]  [<ffffffff8107fc80>] ?=20
manage_workers.isra.29+0x230/0x230
[15481.213573]  [<ffffffff81084e0c>] kthread+0x8c/0xa0
[15481.214577]  [<ffffffff81419a34>] kernel_thread_helper+0x4/0x10
[15481.215596]  [<ffffffff81084d80>] ? kthread_worker_fn+0x190/0x190
[15481.216600]  [<ffffffff81419a30>] ? gs_change+0x13/0x13
[15601.215172] INFO: task xfsbufd/md127:527 blocked for more than 120=20
seconds.
[15601.216198] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15601.217226] xfsbufd/md127   D 00000001004562e8     0   527      2=20
0x00000000
[15601.218264]  ffff8801f912fab0 0000000000000046 0000000100000000=20
0000000300000001
[15601.219326]  ffff8802009dc740 ffff8801f912ffd8 ffff8801f912ffd8=20
ffff8801f912ffd8
[15601.220375]  ffffffff8180d020 ffff8802009dc740 ffff8801f912fa10=20
ffffffff8104d003
[15601.221411] Call Trace:
[15601.222441]  [<ffffffff8104d003>] ? __wake_up+0x53/0x70
[15601.223461]  [<ffffffff8114d48b>] ? kfree+0x3b/0x170
[15601.224479]  [<ffffffffa01c732b>] ? plugger_unplug+0x3b/0x50 [md_mod=
]
[15601.225507]  [<ffffffff8121b457>] ? blk_flush_plug_list+0xa7/0x250
[15601.226516]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15601.227516]  [<ffffffffa0378209>] get_active_stripe+0x2e9/0x600=20
[raid456]
[15601.228540]  [<ffffffff8105be20>] ? try_to_wake_up+0x290/0x290
[15601.229552]  [<ffffffffa037be22>] make_request+0x192/0x430 [raid456]
[15601.230569]  [<ffffffff81085750>] ? abort_exclusive_wait+0xb0/0xb0
[15601.231588]  [<ffffffffa01c964a>] md_make_request+0xfa/0x240 [md_mod=
]
[15601.232628]  [<ffffffff811047a5>] ? mempool_alloc_slab+0x15/0x20
[15601.233654]  [<ffffffff81219917>] generic_make_request+0xc7/0x100
[15601.234682]  [<ffffffff812199d7>] submit_bio+0x87/0x110
[15601.235731]  [<ffffffffa03a3e6c>] _xfs_buf_ioapply+0x15c/0x1c0 [xfs]
[15601.236772]  [<ffffffffa03a4d75>] ? xfs_bdstrat_cb+0x65/0x120 [xfs]
[15601.237815]  [<ffffffffa03a3fb9>] xfs_buf_iorequest+0x59/0x100 [xfs]
[15601.238874]  [<ffffffffa03a4d75>] xfs_bdstrat_cb+0x65/0x120 [xfs]
[15601.239916]  [<ffffffffa03a4f3e>] xfsbufd+0x10e/0x170 [xfs]
[15601.240949]  [<ffffffff8105be32>] ? default_wake_function+0x12/0x20
[15601.241995]  [<ffffffffa03a4e30>] ? xfs_bdstrat_cb+0x120/0x120 [xfs]
[15601.243026]  [<ffffffff81084e0c>] kthread+0x8c/0xa0
[15601.244051]  [<ffffffff81419a34>] kernel_thread_helper+0x4/0x10
[15601.245076]  [<ffffffff81084d80>] ? kthread_worker_fn+0x190/0x190
[15601.246114]  [<ffffffff81419a30>] ? gs_change+0x13/0x13
[15601.247129] INFO: task md127_resync:529 blocked for more than 120=20
seconds.
[15601.248156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15601.249209] md127_resync    D 00000001004562fa     0   529      2=20
0x00000000
[15601.250259]  ffff8801f9073b80 0000000000000046 0000000100000000=20
ffffffff81233ce7
[15601.251316]  ffff8802013e8720 ffff8801f9073fd8 ffff8801f9073fd8=20
ffff8801f9073fd8
[15601.252392]  ffff880202cb4e60 ffff8802013e8720 ffff880200b70138=20
ffff880004bff300
[15601.253459] Call Trace:
[15601.254516]  [<ffffffff81233ce7>] ? kobject_put+0x27/0x60
[15601.255590]  [<ffffffff8121b913>] ? blk_queue_bio+0x2c3/0x410
[15601.256642]  [<ffffffff814171a6>] ? retint_kernel+0x26/0x30
[15601.257679]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15601.258721]  [<ffffffffa0378209>] get_active_stripe+0x2e9/0x600=20
[raid456]
[15601.259756]  [<ffffffff8105be20>] ? try_to_wake_up+0x290/0x290
[15601.260792]  [<ffffffffa037559a>] sync_request+0x35a/0x370 [raid456]
[15601.261838]  [<ffffffffa01c9a08>] ? is_mddev_idle+0x128/0x140=20
[md_mod]
[15601.262867]  [<ffffffffa01cd2bf>] md_do_sync+0x7ff/0xc70 [md_mod]
[15601.263895]  [<ffffffff81085750>] ? abort_exclusive_wait+0xb0/0xb0
[15601.264926]  [<ffffffff810748cb>] ? recalc_sigpending+0x1b/0x50
[15601.265972]  [<ffffffffa01c9dce>] md_thread+0x10e/0x140 [md_mod]
[15601.267002]  [<ffffffffa01c9cc0>] ? md_register_thread+0x110/0x110=20
[md_mod]
[15601.268033]  [<ffffffff81084e0c>] kthread+0x8c/0xa0
[15601.269074]  [<ffffffff81419a34>] kernel_thread_helper+0x4/0x10
[15601.270103]  [<ffffffff81084d80>] ? kthread_worker_fn+0x190/0x190
[15601.271132]  [<ffffffff81419a30>] ? gs_change+0x13/0x13
[15601.272170] INFO: task loop0:1729 blocked for more than 120 seconds.
[15601.273202] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15601.274249] loop0           D 000000010044b6c5     0  1729      2=20
0x00000000
[15601.275320]  ffff8801f9b31b30 0000000000000046 0000000000000000=20
0000000000000000
[15601.276385]  ffff880200950e40 ffff8801f9b31fd8 ffff8801f9b31fd8=20
ffff8801f9b31fd8
[15601.277454]  ffff880202cb7200 ffff880200950e40 0000000000000002=20
ffff8801f9b31b78
[15601.278536] Call Trace:
[15601.279594]  [<ffffffff81101a55>] ? find_get_pages_tag+0x125/0x150
[15601.280671]  [<ffffffff8110e205>] ? pagevec_lookup_tag+0x25/0x40
[15601.281736]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[15601.282801]  [<ffffffff8108f14d>] ? ktime_get_ts+0xad/0xe0
[15601.283840]  [<ffffffff81101d60>] ? __lock_page+0x70/0x70
[15601.284870]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15601.285902]  [<ffffffff8141416f>] io_schedule+0x8f/0xd0
[15601.286919]  [<ffffffff81101d6e>] sleep_on_page+0xe/0x20
[15601.287924]  [<ffffffff8141491f>] __wait_on_bit+0x5f/0x90
[15601.288938]  [<ffffffff81101f58>] wait_on_page_bit+0x78/0x80
[15601.289944]  [<ffffffff81085790>] ?=20
autoremove_wake_function+0x40/0x40
[15601.290953]  [<ffffffff811020cc>] filemap_fdatawait_range+0x10c/0x1a=
0
[15601.291972]  [<ffffffff811030c8>]=20
filemap_write_and_wait_range+0x68/0x80
[15601.292985]  [<ffffffffa03a7234>] xfs_file_fsync+0x54/0x340 [xfs]
[15601.293993]  [<ffffffff8119148b>] vfs_fsync+0x2b/0x40
[15601.294993]  [<ffffffffa04dacf2>] do_bio_filebacked+0x1b2/0x320=20
[loop]
[15601.296022]  [<ffffffffa050efac>] ? end_workqueue_bio+0x9c/0xa0=20
[btrfs]
[15601.297029]  [<ffffffffa04daf1b>] loop_thread+0xbb/0x260 [loop]
[15601.298032]  [<ffffffff81085750>] ? abort_exclusive_wait+0xb0/0xb0
[15601.299049]  [<ffffffffa04dae60>] ? do_bio_filebacked+0x320/0x320=20
[loop]
[15601.300057]  [<ffffffff81084e0c>] kthread+0x8c/0xa0
[15601.301063]  [<ffffffff81419a34>] kernel_thread_helper+0x4/0x10
[15601.302084]  [<ffffffff81084d80>] ? kthread_worker_fn+0x190/0x190
[15601.303093]  [<ffffffff81419a30>] ? gs_change+0x13/0x13
[15601.304098] INFO: task btrfs-transacti:1756 blocked for more than=20
120 seconds.
[15601.305126] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15601.306162] btrfs-transacti D ffff8801f9ab7200     0  1756      2=20
0x00000000
[15601.307205]  ffff8801e7533bc0 0000000000000046 ffff88020fc93400=20
0000000000000002
[15601.308257]  ffff8801f9ab7200 ffff8801e7533fd8 ffff8801e7533fd8=20
ffff8801e7533fd8
[15601.309327]  ffff880200950e40 ffff8801f9ab7200 ffff8801e7533b10=20
0000000081051ae2
[15601.310384] Call Trace:
[15601.311427]  [<ffffffff8105ad36>] ?=20
ttwu_do_activate.constprop.172+0x66/0x70
[15601.312509]  [<ffffffff8105bd6e>] ? try_to_wake_up+0x1de/0x290
[15601.313568]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15601.314612]  [<ffffffff814147d5>] schedule_timeout+0x305/0x390
[15601.315658]  [<ffffffff8104d003>] ? __wake_up+0x53/0x70
[15601.316680]  [<ffffffff81413348>] wait_for_common+0xc8/0x160
[15601.317699]  [<ffffffff8105be20>] ? try_to_wake_up+0x290/0x290
[15601.318730]  [<ffffffff814133fd>] wait_for_completion+0x1d/0x20
[15601.319745]  [<ffffffffa050f0bb>] write_dev_flush+0x4b/0x140 [btrfs]
[15601.320760]  [<ffffffffa0511086>] write_all_supers+0x6f6/0x800=20
[btrfs]
[15601.321791]  [<ffffffffa05111a3>] write_ctree_super+0x13/0x20 [btrfs=
]
[15601.322809]  [<ffffffffa05164dd>]=20
btrfs_commit_transaction+0x63d/0x880 [btrfs]
[15601.323831]  [<ffffffff81085750>] ? abort_exclusive_wait+0xb0/0xb0
[15601.324855]  [<ffffffffa0516b74>] ? start_transaction+0x94/0x2b0=20
[btrfs]
[15601.325894]  [<ffffffffa050ed4d>] transaction_kthread+0x26d/0x290=20
[btrfs]
[15601.326918]  [<ffffffffa050eae0>] ? btrfs_congested_fn+0xd0/0xd0=20
[btrfs]
[15601.327937]  [<ffffffff81084e0c>] kthread+0x8c/0xa0
[15601.328963]  [<ffffffff81419a34>] kernel_thread_helper+0x4/0x10
[15601.329979]  [<ffffffff81084d80>] ? kthread_worker_fn+0x190/0x190
[15601.330995]  [<ffffffff81419a30>] ? gs_change+0x13/0x13
[15601.332024] INFO: task flush-9:127:1891 blocked for more than 120=20
seconds.
[15601.333049] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15601.334083] flush-9:127     D 00000000a01fc200     0  1891      2=20
0x00000000
[15601.335141]  ffff880171771540 0000000000000046 0000000100000000=20
0000000300000001
[15601.336194]  ffff8802009d9c80 ffff880171771fd8 ffff880171771fd8=20
ffff880171771fd8
[15601.337252]  ffff8802009dc740 ffff8802009d9c80 ffff8801717714a0=20
ffffffff8104d003
[15601.338304] Call Trace:
[15601.339347]  [<ffffffff8104d003>] ? __wake_up+0x53/0x70
[15601.340376]  [<ffffffff8114d48b>] ? kfree+0x3b/0x170
[15601.341398]  [<ffffffffa01c732b>] ? plugger_unplug+0x3b/0x50 [md_mod=
]
[15601.342432]  [<ffffffff8121b457>] ? blk_flush_plug_list+0xa7/0x250
[15601.343453]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15601.344460]  [<ffffffffa0378209>] get_active_stripe+0x2e9/0x600=20
[raid456]
[15601.345487]  [<ffffffffa01c6400>] ? md_wakeup_thread+0x10/0x30=20
[md_mod]
[15601.346503]  [<ffffffff8105be20>] ? try_to_wake_up+0x290/0x290
[15601.347519]  [<ffffffffa037be22>] make_request+0x192/0x430 [raid456]
[15601.348555]  [<ffffffff81085750>] ? abort_exclusive_wait+0xb0/0xb0
[15601.348559]  [<ffffffffa01c964a>] md_make_request+0xfa/0x240 [md_mod=
]
[15601.348561]  [<ffffffff81219917>] generic_make_request+0xc7/0x100
[15601.348563]  [<ffffffff812199d7>] submit_bio+0x87/0x110
[15601.348565]  [<ffffffff8118b300>] ? __mark_inode_dirty+0x40/0x230
[15601.348571]  [<ffffffffa03a16f7>]=20
xfs_submit_ioend_bio.isra.11+0x57/0x80 [xfs]
[15601.348578]  [<ffffffffa03a180e>] xfs_submit_ioend+0xee/0x110 [xfs]
[15601.348585]  [<ffffffffa03a1a65>] xfs_vm_writepage+0x235/0x530 [xfs]
[15601.348588]  [<ffffffff8110b75a>] __writepage+0x1a/0x50
[15601.348591]  [<ffffffff8110bc21>] write_cache_pages+0x1e1/0x4e0
[15601.348599]  [<ffffffffa03bab27>] ? kmem_alloc+0x67/0xe0 [xfs]
[15601.348602]  [<ffffffff8110b740>] ? bdi_set_max_ratio+0x90/0x90
[15601.348606]  [<ffffffff8110bf6d>] generic_writepages+0x4d/0x70
[15601.348612]  [<ffffffffa03a06ad>] xfs_vm_writepages+0x4d/0x60 [xfs]
[15601.348615]  [<ffffffff8110d6a4>] do_writepages+0x24/0x40
[15601.348618]  [<ffffffff8118b76f>] writeback_single_inode+0x10f/0x3f0
[15601.348621]  [<ffffffff8118be4a>] writeback_sb_inodes+0x1aa/0x270
[15601.348624]  [<ffffffff8118bfae>] __writeback_inodes_wb+0x9e/0xd0
[15601.348627]  [<ffffffff8118c5cb>] wb_writeback+0x37b/0x3b0
[15601.348631]  [<ffffffff8117d562>] ? get_nr_inodes+0x52/0x70
[15601.348634]  [<ffffffff8117e262>] ? get_nr_dirty_inodes+0x52/0x80
[15601.348636]  [<ffffffff8118c69f>] wb_check_old_data_flush+0x9f/0xb0
[15601.348639]  [<ffffffff8118db7c>] wb_do_writeback+0x19c/0x230
[15601.348642]  [<ffffffff81414643>] ? schedule_timeout+0x173/0x390
[15601.348645]  [<ffffffff81071b10>] ?=20
init_timer_deferrable_key+0x30/0x30
[15601.348648]  [<ffffffff8118dc9c>] bdi_writeback_thread+0x8c/0x340
[15601.348651]  [<ffffffff8118dc10>] ? wb_do_writeback+0x230/0x230
[15601.348654]  [<ffffffff81084e0c>] kthread+0x8c/0xa0
[15601.348657]  [<ffffffff81419a34>] kernel_thread_helper+0x4/0x10
[15601.348660]  [<ffffffff81084d80>] ? kthread_worker_fn+0x190/0x190
[15601.348663]  [<ffffffff81419a30>] ? gs_change+0x13/0x13
[15601.348665] INFO: task smbd:2058 blocked for more than 120 seconds.
[15601.348667] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
[15601.348669] smbd            D 000000010044b8d7     0  2058    823=20
0x00000004
[15601.348672]  ffff88005cf37a08 0000000000000082 ffff88005cf37938=20
ffffffff81371188
[15601.348676]  ffff8802012e63c0 ffff88005cf37fd8 ffff88005cf37fd8=20
ffff88005cf37fd8
[15601.348680]  ffff880202d21c80 ffff8802012e63c0 ffff8802012769c0=20
0000000000000246
[15601.348684] Call Trace:
[15601.348687]  [<ffffffff81371188>] ? sch_direct_xmit+0x68/0x1d0
[15601.348691]  [<ffffffff81355a00>] ? dev_queue_xmit+0x200/0x680
[15601.348694]  [<ffffffff81389200>] ? ip_forward_options+0x1c0/0x1c0
[15601.348697]  [<ffffffff8138adbe>] ? ip_finish_output+0x18e/0x310
[15601.348700]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[15601.348703]  [<ffffffff8108f14d>] ? ktime_get_ts+0xad/0xe0
[15601.348705]  [<ffffffff81101d60>] ? __lock_page+0x70/0x70
[15601.348708]  [<ffffffff814140bf>] schedule+0x3f/0x60
[15601.348711]  [<ffffffff8141416f>] io_schedule+0x8f/0xd0
[15601.348714]  [<ffffffff81101d6e>] sleep_on_page+0xe/0x20
[15601.348716]  [<ffffffff8141491f>] __wait_on_bit+0x5f/0x90
[15601.348719]  [<ffffffff81101f58>] wait_on_page_bit+0x78/0x80
[15601.348722]  [<ffffffff81085790>] ?=20
autoremove_wake_function+0x40/0x40
[15601.348725]  [<ffffffff81102845>]=20
grab_cache_page_write_begin+0x95/0xe0
[15601.348732]  [<ffffffffa03a1150>] ? xfs_get_blocks_direct+0x20/0x20=20
[xfs]
[15601.348736]  [<ffffffff811967b8>] block_write_begin+0x38/0xa0
[15601.348743]  [<ffffffffa03a1213>] xfs_vm_write_begin+0x43/0x70 [xfs]
[15601.348746]  [<ffffffff8110233c>]=20
generic_file_buffered_write+0x10c/0x270
[15601.348754]  [<ffffffffa03aad66>] ? xfs_iunlock+0x116/0x180 [xfs]
[15601.348761]  [<ffffffffa03a7fef>]=20
xfs_file_buffered_aio_write+0x10f/0x200 [xfs]
[15601.348768]  [<ffffffffa03a8252>] xfs_file_aio_write+0x172/0x2a0=20
[xfs]
[15601.348772]  [<ffffffff81162d62>] do_sync_write+0xd2/0x110
[15601.348775]  [<ffffffff811f0fcc>] ?=20
security_file_permission+0x2c/0xb0
[15601.348778]  [<ffffffff81163311>] ? rw_verify_area+0x61/0xf0
[15601.348781]  [<ffffffff8116366f>] vfs_write+0xaf/0x180
[15601.348784]  [<ffffffff81163b12>] sys_pwrite64+0x82/0xb0
[15601.348787]  [<ffffffff814178c2>] system_call_fastpath+0x16/0x1b


On =CE=A3=CE=AC=CE=B2=CE=B2=CE=B1=CF=84=CE=BF, 3 =CE=94=CE=B5=CE=BA=CE=AD=
=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 2:35:50 =CF=80=CE=BC, Konstan=
tinos Skarlatos wrote:
> After about 1TB of rsyncs from multiple servers at the same time, plu=
s=20
> some heavy filesystem loading, i believe that 3.2rc4 solves the=20
> problem for me. Now if only we had deduplication and an fsck tool :)
> On =CE=A0=CE=B1=CF=81=CE=B1=CF=83=CE=BA=CE=B5=CF=85=CE=AE, 2 =CE=94=CE=
=B5=CE=BA=CE=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 9:53:10 =CE=BC=
=CE=BC, Konstantinos Skarlatos wrote:
>> I see they got into 3.2rc4, so I am now compiling it. I will report=20
>> back in a few hours
>>
>> On =CE=A0=CE=B1=CF=81=CE=B1=CF=83=CE=BA=CE=B5=CF=85=CE=AE, 2 =CE=94=CE=
=B5=CE=BA=CE=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 5:48:31 =CE=BC=
=CE=BC, Tobias wrote:
>>> Am 02.12.2011 16:22, schrieb Konstantinos Skarlatos:
>>>>>> So, the transaction close is in btrfs_evict_inode, which sounds=20
>>>>>> like a
>>>>>> deadlock recently fixed by this commit:
>>>>>>
>>>>>> http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-btrfs.gi=
t;a=3Dcommit;h=3Daa38a711a893accf5b5192f3d705a120deaa81e0=20
>>>>>>
>>>>>>
>>>>>> If you pull the for-linus branch from today, hopefully the=20
>>>>>> problem will
>>>>>> be gone.
>>>>>>
>>>>>
>>>>> This looks very good. With this Kernel i still have some hangs,=20
>>>>> but only in rsync, only under high load and they don't lock up th=
e=20
>>>>> system - so i guess it's ok now.
>>>>
>>>> I still have hangs and lock ups under the same situation (rsync of=
=20
>>>> many files) under 3.2rc3. rc3 made the hang appear after 200gb of=20
>>>> files, while in rc2 i had hangs after only 11gb .
>>>
>>> Yes, i had them too in 3.2rc3! The problem where solved with patche=
s=20
>>> from the "btrfs-for-linus" -branch. (see link above).
>>>
>>> Tobias
>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
