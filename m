From: Martin Mailand <martin@tuxadero.com>
Subject: OSD blocked for more than 120 seconds
Date: Thu, 13 Oct 2011 22:39:35 +0200
Message-ID: <4E974C87.2070204@tuxadero.com>
Reply-To: martin@tuxadero.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
on one of my OSDs the ceph-osd task hung for more than 120 sec. The OSD 
had almost no load, therefore it cannot be an overload problem. I think 
it is a btrfs problem, could someone clarify it?

This was in the dmesg.

[29280.890040] INFO: task btrfs-cleaner:1708 blocked for more than 120 
seconds.
[29280.905659] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[29280.922916] btrfs-cleaner   D ffff8801153bdf80     0  1708      2 
0x00000000
[29280.922931]  ffff88011698bbd0 0000000000000046 ffff88011698bb90 
ffffffff81090d7d
[29280.922960]  ffff880100000000 ffff88011698bfd8 ffff88011698a000 
ffff88011698bfd8
[29280.922988]  ffffffff81a0d020 ffff8801153bdbc0 ffff88011698bbd0 
0000000181090d7d
[29280.923018] Call Trace:
[29280.923043]  [<ffffffff81090d7d>] ? ktime_get_ts+0xad/0xe0
[29280.923062]  [<ffffffff8110cf10>] ? __lock_page+0x70/0x70
[29280.923082]  [<ffffffff815d93df>] schedule+0x3f/0x60
[29280.923098]  [<ffffffff815d948c>] io_schedule+0x8c/0xd0
[29280.923114]  [<ffffffff8110cf1e>] sleep_on_page+0xe/0x20
[29280.923130]  [<ffffffff815d9c6f>] __wait_on_bit+0x5f/0x90
[29280.923147]  [<ffffffff8110d168>] wait_on_page_bit+0x78/0x80
[29280.923165]  [<ffffffff81086bd0>] ? autoremove_wake_function+0x40/0x40
[29280.923227]  [<ffffffffa0065ecb>] btrfs_defrag_file+0x4fb/0xc10 [btrfs]
[29280.923246]  [<ffffffff8117f6ac>] ? find_inode+0xac/0xb0
[29280.923281]  [<ffffffffa003a2d0>] ? 
btrfs_clean_old_snapshots+0x160/0x160 [btrfs]
[29280.923302]  [<ffffffff812e369b>] ? radix_tree_lookup+0xb/0x10
[29280.923337]  [<ffffffffa0034f62>] ? 
btrfs_read_fs_root_no_name+0x1c2/0x2e0 [btrfs]
[29280.923375]  [<ffffffffa004897e>] btrfs_run_defrag_inodes+0x15e/0x210 
[btrfs]
[29280.923410]  [<ffffffffa003278f>] cleaner_kthread+0x17f/0x1a0 [btrfs]
[29280.923443]  [<ffffffffa0032610>] ? btrfs_congested_fn+0xb0/0xb0 [btrfs]
[29280.923460]  [<ffffffff81086436>] kthread+0x96/0xa0
[29280.923477]  [<ffffffff815e5934>] kernel_thread_helper+0x4/0x10
[29280.923493]  [<ffffffff810863a0>] ? flush_kthread_worker+0xb0/0xb0
[29280.923510]  [<ffffffff815e5930>] ? gs_change+0x13/0x13
[29280.923521] INFO: task btrfs-transacti:1709 blocked for more than 120 
seconds.
[29280.939551] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[29280.956782] btrfs-transacti D ffff880115745f80     0  1709      2 
0x00000000
[29280.956792]  ffff880115e6fd50 0000000000000046 ffff880115e6fd20 
ffff880111a5a3e0
[29280.956800]  ffff880100000000 ffff880115e6ffd8 ffff880115e6e000 
ffff880115e6ffd8
[29280.956809]  ffffffff81a0d020 ffff880115745bc0 0000000000000282 
0000000116758450
[29280.956817] Call Trace:
[29280.956827]  [<ffffffff815d93df>] schedule+0x3f/0x60
[29280.956855]  [<ffffffffa0037de5>] wait_for_commit.clone.16+0x55/0x90 
[btrfs]
[29280.956864]  [<ffffffff81086b90>] ? wake_up_bit+0x40/0x40
[29280.956891]  [<ffffffffa0039726>] 
btrfs_commit_transaction+0x776/0x860 [btrfs]
[29280.956900]  [<ffffffff8115653c>] ? kmem_cache_alloc+0x3c/0x130
[29280.956907]  [<ffffffff815db6fe>] ? _raw_spin_lock+0xe/0x20
[29280.956933]  [<ffffffffa003879d>] ? 
join_transaction.clone.24+0x5d/0x240 [btrfs]
[29280.956941]  [<ffffffff81086b90>] ? wake_up_bit+0x40/0x40
[29280.956966]  [<ffffffffa0033323>] transaction_kthread+0x273/0x290 [btrfs]
[29280.956991]  [<ffffffffa00330b0>] ? check_leaf.clone.68+0x320/0x320 
[btrfs]
[29280.956999]  [<ffffffff81086436>] kthread+0x96/0xa0
[29280.957007]  [<ffffffff815e5934>] kernel_thread_helper+0x4/0x10
[29280.957015]  [<ffffffff810863a0>] ? flush_kthread_worker+0xb0/0xb0
[29280.957022]  [<ffffffff815e5930>] ? gs_change+0x13/0x13
[29280.957030] INFO: task ceph-osd:1855 blocked for more than 120 seconds.
[29280.971860] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[29280.989164] ceph-osd        D ffff880114865f80     0  1855      1 
0x00000004
[29280.989173]  ffff880115229c48 0000000000000082 ffff880115229bf8 
ffff880115230fb8
[29280.989181]  ffff880115229c00 ffff880115229fd8 ffff880115228000 
ffff880115229fd8
[29280.989189]  ffff8801151744d0 ffff880114865bc0 0000000000000282 
ffff880117864208
[29280.989209] Call Trace:
[29280.989226]  [<ffffffff815d93df>] schedule+0x3f/0x60
[29280.989263]  [<ffffffffa003a017>] 
btrfs_commit_transaction_async+0x1f7/0x270 [btrfs]
[29280.989296]  [<ffffffffa002375b>] ? block_rsv_add_bytes+0x5b/0x80 [btrfs]
[29280.989314]  [<ffffffff81086b90>] ? wake_up_bit+0x40/0x40
[29280.989344]  [<ffffffffa00237ba>] ? block_rsv_migrate_bytes+0x3a/0x50 
[btrfs]
[29280.989380]  [<ffffffffa00655b1>] btrfs_mksubvol+0x301/0x3a0 [btrfs]
[29280.989416]  [<ffffffffa0065750>] 
btrfs_ioctl_snap_create_transid+0x100/0x160 [btrfs]
[29280.989453]  [<ffffffffa00658d2>] 
btrfs_ioctl_snap_create_v2.clone.57+0xa2/0x100 [btrfs]
[29280.989491]  [<ffffffffa0066d5d>] btrfs_ioctl+0x1fd/0xe20 [btrfs]
[29280.989507]  [<ffffffff811657c2>] ? do_sync_write+0xd2/0x110
[29280.989525]  [<ffffffff811a053d>] ? fsnotify+0x1cd/0x2e0
[29280.989541]  [<ffffffff811779f8>] do_vfs_ioctl+0x98/0x540
[29280.989557]  [<ffffffff81177f31>] sys_ioctl+0x91/0xa0
[29280.989575]  [<ffffffff815e37c2>] system_call_fastpath+0x16/0x1b


Best Regards,
  marti
