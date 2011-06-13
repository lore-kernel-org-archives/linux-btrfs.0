From: "Jim Schutt" <jaschut@sandia.gov>
Subject: stalls with latest btrfs merge into 3.0-rc2
Date: Mon, 13 Jun 2011 15:07:18 -0600
Message-ID: <4DF67C06.4000307@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: ceph-devel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On a system under a heavy write load from multiple ceph OSDs,
I'm running into the following hung tasks where btrfs is implicated.
I'm running commit 3c25fa740e2 from Linus' tree merged with
commit cb9b41c92fa from git://ceph.newdream.net/git/ceph-client.git.

Let me know what else I can do to help sort this out.

[  961.318047] INFO: task kworker/1:2:2346 blocked for more than 120 seconds.
[  961.324993] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  961.332891]  ffff8802253dbcd0 0000000000000046 ffff8802253dbcb0 ffff88021c138000
[  961.340398]  ffff880222c3dac0 ffff880222c3dac0 00000000000108c0 ffff88021c138000
[  961.347893]  ffff880222c3de80 0000000000000001 ffff8802253dbd00 ffffffff813b0f69
[  961.355384] Call Trace:
[  961.357838]  [<ffffffff813b0f69>] schedule+0x164/0x19e
[  961.363041]  [<ffffffffa066069c>] btrfs_start_ordered_extent+0xa8/0xc4 [btrfs]
[  961.370268]  [<ffffffff81066544>] ? list_del_init+0x21/0x21
[  961.376075]  [<ffffffffa0660f93>] btrfs_wait_ordered_extents+0xd8/0x143 [btrfs]
[  961.383387]  [<ffffffffa0647065>] btrfs_commit_transaction+0x20b/0x5a4 [btrfs]
[  961.390642]  [<ffffffff81066544>] ? list_del_init+0x21/0x21
[  961.396284]  [<ffffffffa064741d>] do_async_commit+0x1f/0x2c [btrfs]
[  961.402638]  [<ffffffff81060bba>] process_one_work+0x124/0x1e0
[  961.408478]  [<ffffffffa06473fe>] ? btrfs_commit_transaction+0x5a4/0x5a4 [btrfs]
[  961.415917]  [<ffffffff81062219>] ? destroy_workqueue+0x161/0x161
[  961.422155]  [<ffffffff810622a8>] worker_thread+0x8f/0x124
[  961.427642]  [<ffffffff8106603f>] kthread+0x72/0x7a
[  961.432636]  [<ffffffff813b9e94>] kernel_thread_helper+0x4/0x10
[  961.438561]  [<ffffffff813b272d>] ? retint_restore_args+0xe/0xe
[  961.444530]  [<ffffffff81065fcd>] ? kthread_bind+0x53/0x53
[  961.450100]  [<ffffffff813b9e90>] ? gs_change+0xb/0xb
[  961.455188] INFO: task btrfs-transacti:7653 blocked for more than 120 seconds.
[  961.462506] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  961.477512]  ffff88021c24fd90 0000000000000046 ffff88021c24fd70 ffff880190a65ac0
[  961.491735]  ffff8802246cad60 ffff8802246cad60 00000000000108c0 ffff880190a65ac0
[  961.505853]  ffff8802246cb120 0000000000000001 ffff88021c24fdc0 ffffffff813b0f69
[  961.521106] Call Trace:
[  961.526052]  [<ffffffff813b0f69>] schedule+0x164/0x19e
[  961.531910]  [<ffffffffa06460b4>] wait_current_trans+0xb8/0xec [btrfs]
[  961.544101]  [<ffffffff81066544>] ? list_del_init+0x21/0x21
[  961.550394]  [<ffffffffa0645cd2>] ? spin_lock+0xe/0x10 [btrfs]
[  961.556471]  [<ffffffffa0647970>] start_transaction+0xd1/0x206 [btrfs]
[  961.563023]  [<ffffffffa0643ec7>] ? btree_readpage_end_io_hook+0x192/0x192 [btrfs]
[  961.570597]  [<ffffffffa0647ae8>] btrfs_join_transaction+0x15/0x17 [btrfs]
[  961.577609]  [<ffffffffa064401b>] transaction_kthread+0x154/0x22d [btrfs]
[  961.584465]  [<ffffffff81036a33>] ? need_resched+0x23/0x2d
[  961.589967]  [<ffffffff8106603f>] kthread+0x72/0x7a
[  961.594843]  [<ffffffff813b9e94>] kernel_thread_helper+0x4/0x10
[  961.600777]  [<ffffffff813b272d>] ? retint_restore_args+0xe/0xe
[  961.606702]  [<ffffffff81065fcd>] ? kthread_bind+0x53/0x53
[  961.612206]  [<ffffffff813b9e90>] ? gs_change+0xb/0xb
[  961.617322] INFO: task cosd:16719 blocked for more than 120 seconds.
[  961.623702] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  961.631542]  ffff8801bf163cb8 0000000000000086 ffff8801bf163c98 ffff880226db16b0
[  961.639072]  ffff8801df4f5ac0 ffff8801df4f5ac0 00000000000108c0 ffff880226db16b0
[  961.646516]  ffff8801df4f5e80 0000000000000001 ffff8801bf163ce8 ffffffff813b0f69
[  961.653955] Call Trace:
[  961.656483]  [<ffffffff813b0f69>] schedule+0x164/0x19e
[  961.661725]  [<ffffffffa0645dbd>] wait_current_trans_commit_start_and_unblock+0xa9/0xce [btrfs]
[  961.670461]  [<ffffffff81066544>] ? list_del_init+0x21/0x21
[  961.676028]  [<ffffffff81061512>] ? queue_work+0x1f/0x21
[  961.681436]  [<ffffffffa0647bbd>] btrfs_commit_transaction_async+0xd3/0x115 [btrfs]
[  961.689118]  [<ffffffffa066d8b3>] create_snapshot+0xe5/0x177 [btrfs]
[  961.695546]  [<ffffffffa0671559>] btrfs_mksubvol+0xfa/0x167 [btrfs]
[  961.702416]  [<ffffffffa06716c5>] btrfs_ioctl_snap_create_transid+0xff/0x121 [btrfs]
[  961.710454]  [<ffffffffa067176f>] btrfs_ioctl_snap_create_v2+0x88/0xea [btrfs]
[  961.718000]  [<ffffffffa0671a40>] btrfs_ioctl+0x208/0x358 [btrfs]
[  961.724088]  [<ffffffff8112221a>] vfs_ioctl+0x1d/0x34
[  961.729159]  [<ffffffff81122895>] do_vfs_ioctl+0x171/0x17a
[  961.734732]  [<ffffffff811154bb>] ? fget_light+0x69/0x81
[  961.740057]  [<ffffffff811228fa>] sys_ioctl+0x5c/0x7c
[  961.745333]  [<ffffffffa0534af5>] ? jbd_free_handle+0x1b/0x1d [jbd]
[  961.752028]  [<ffffffff813b8dab>] system_call_fastpath+0x16/0x1b
[  961.758429] INFO: task cosd:16720 blocked for more than 120 seconds.
[  961.765416] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  961.776419]  ffff8801bf123bb8 0000000000000086 ffff8801bf123b98 ffff8801664bad60
[  961.792604]  ffff8801df4f2d60 ffff8801df4f2d60 00000000000108c0 ffff8801664bad60
[  961.814250]  ffff8801df4f3120 0000000000000000 ffff8801bf123be8 ffffffff813b0f69
[  961.825356] Call Trace:
[  961.830932]  [<ffffffff813b0f69>] schedule+0x164/0x19e
[  961.837403]  [<ffffffffa06460b4>] wait_current_trans+0xb8/0xec [btrfs]
[  961.844413]  [<ffffffff81066544>] ? list_del_init+0x21/0x21
[  961.850203]  [<ffffffff81109fe6>] ? kmem_cache_alloc+0xad/0xb9
[  961.856255]  [<ffffffffa0647970>] start_transaction+0xd1/0x206 [btrfs]
[  961.863351]  [<ffffffffa0647c12>] btrfs_start_transaction+0x13/0x15 [btrfs]
[  961.870549]  [<ffffffffa064dc24>] btrfs_create+0x3b/0x197 [btrfs]
[  961.876889]  [<ffffffff8111edd8>] vfs_create+0x72/0x92
[  961.882115]  [<ffffffff8111f024>] do_last+0x22c/0x40b
[  961.887195]  [<ffffffff8111fd02>] path_openat+0xc0/0x2ef
[  961.892581]  [<ffffffff81121011>] do_filp_open+0x3d/0x87
[  961.897888]  [<ffffffff811e070c>] ? strncpy_from_user+0x43/0x4d
[  961.903880]  [<ffffffff8111e78d>] ? getname_flags+0x2e/0x80
[  961.909463]  [<ffffffff8111e711>] ? do_getname+0x14b/0x173
[  961.915472]  [<ffffffff8111e74f>] ? audit_getname+0x16/0x26
[  961.921259]  [<ffffffff8112a743>] ? spin_lock+0xe/0x10
[  961.926480]  [<ffffffff811122d1>] do_sys_open+0x69/0xae
[  961.931759]  [<ffffffff81112349>] sys_open+0x20/0x22
[  961.936730]  [<ffffffff813b8dab>] system_call_fastpath+0x16/0x1b
[  961.942878] INFO: task cosd:16721 blocked for more than 120 seconds.
[  961.949231] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  961.957398]  ffff8801502dfb38 0000000000000086 ffff8801502dfb18 ffff8801dd19c410
[  961.965782]  ffff880150314410 ffff880150314410 00000000000108c0 ffff8801dd19c410
[  961.973784]  ffff8801503147d0 0000000000400000 ffff8801502dfb68 ffffffff813b0f69
[  961.981702] Call Trace:
[  961.984239]  [<ffffffff813b0f69>] schedule+0x164/0x19e
[  961.989445]  [<ffffffffa06460b4>] wait_current_trans+0xb8/0xec [btrfs]
[  961.995993]  [<ffffffff81066544>] ? list_del_init+0x21/0x21
[  962.001781]  [<ffffffffa0647692>] btrfs_throttle+0x1f/0x21 [btrfs]
[  962.008040]  [<ffffffffa0655672>] __btrfs_buffered_write+0x29e/0x2dd [btrfs]
[  962.015217]  [<ffffffffa06559df>] btrfs_file_aio_write+0x203/0x2df [btrfs]
[  962.022152]  [<ffffffffa06557dc>] ? __btrfs_direct_write+0x12b/0x12b [btrfs]
[  962.029240]  [<ffffffff81113a17>] do_sync_readv_writev+0xc1/0x109
[  962.035448]  [<ffffffff8112c187>] ? mnt_dec_count+0x11/0x13
[  962.041016]  [<ffffffff81036a33>] ? need_resched+0x23/0x2d
[  962.046796]  [<ffffffff81036a4b>] ? should_resched+0xe/0x2f
[  962.057128]  [<ffffffff811986c3>] ? security_file_permission+0x2c/0x31
[  962.068078]  [<ffffffff81113d21>] ? rw_verify_area+0xac/0xdb
[  962.073949]  [<ffffffff811140a6>] do_readv_writev+0xbf/0x127
[  962.079741]  [<ffffffff8111e78d>] ? getname_flags+0x2e/0x80
[  962.096720]  [<ffffffff81106005>] ? compound_head+0x12/0x20
[  962.103380]  [<ffffffff81036a33>] ? need_resched+0x23/0x2d
[  962.109497]  [<ffffffff81036a4b>] ? should_resched+0xe/0x2f
[  962.119919]  [<ffffffff813b117f>] ? _cond_resched+0xe/0x22
[  962.131022]  [<ffffffff813b1895>] ? mutex_lock+0x16/0x34
[  962.137370]  [<ffffffff81114151>] vfs_writev+0x43/0x4e
[  962.142531]  [<ffffffff81114729>] sys_writev+0x4c/0x71
[  962.148853]  [<ffffffff813b8dab>] system_call_fastpath+0x16/0x1b
[  962.155452] INFO: task btrfs-endio-wri:23430 blocked for more than 120 seconds.
[  962.162885] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  962.170846]  ffff8801dd943c20 0000000000000046 ffff8801dd943c00 ffff8801df4f5ac0
[  962.178326]  ffff880182060000 ffff880182060000 00000000000108c0 ffff8801df4f5ac0
[  962.185821]  ffff8801820603c0 0000000000000001 ffff8801dd943c50 ffffffff813b0f69
[  962.193386] Call Trace:
[  962.195837]  [<ffffffff813b0f69>] schedule+0x164/0x19e
[  962.201044]  [<ffffffffa06460b4>] wait_current_trans+0xb8/0xec [btrfs]
[  962.208020]  [<ffffffff81066544>] ? list_del_init+0x21/0x21
[  962.213751]  [<ffffffffa0645cd2>] ? spin_lock+0xe/0x10 [btrfs]
[  962.219713]  [<ffffffffa0647970>] start_transaction+0xd1/0x206 [btrfs]
[  962.226247]  [<ffffffffa0647ae8>] btrfs_join_transaction+0x15/0x17 [btrfs]
[  962.233127]  [<ffffffffa064ec90>] btrfs_finish_ordered_io+0x135/0x2c1 [btrfs]
[  962.240308]  [<ffffffffa064ee59>] btrfs_writepage_end_io_hook+0x3d/0x45 [btrfs]
[  962.247648]  [<ffffffffa0665e20>] end_bio_extent_writepage+0xaa/0x15a [btrfs]
[  962.255291]  [<ffffffff8113d194>] bio_endio+0x2d/0x2f
[  962.260613]  [<ffffffffa0642c2c>] end_workqueue_fn+0x72/0x7b [btrfs]
[  962.267510]  [<ffffffffa066cd4f>] worker_loop+0x60/0x1f6 [btrfs]
[  962.273543]  [<ffffffff81033dad>] ? calc_load_account_idle+0xe/0x1d
[  962.279841]  [<ffffffffa066ccef>] ? run_ordered_completions+0x99/0x99 [btrfs]
[  962.286968]  [<ffffffff8106603f>] kthread+0x72/0x7a
[  962.291965]  [<ffffffff813b9e94>] kernel_thread_helper+0x4/0x10
[  962.297888]  [<ffffffff813b272d>] ? retint_restore_args+0xe/0xe
[  962.303801]  [<ffffffff81065fcd>] ? kthread_bind+0x53/0x53
[  962.309278]  [<ffffffff813b9e90>] ? gs_change+0xb/0xb

-- Jim

