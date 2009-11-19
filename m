From: John Dong <jdong@ubuntu.com>
Subject: Re: btrfsctl -d race with df -h causes hang?
Date: Thu, 19 Nov 2009 18:18:49 -0500
Message-ID: <900EA6DB-EECC-4BA8-B551-1A6831949824@ubuntu.com>
References: <549778BA-0D47-458D-8CE1-022885B2A2BB@ubuntu.com> <30183CDB-9359-493D-B400-3312291C968B@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: John Dong <jdong@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <30183CDB-9359-493D-B400-3312291C968B@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Managed to get some kernel logs this time. Some sort of deadlock?



Nov 19 18:16:54 hideout kernel: [  721.780120] INFO: task python:2318 blocked for more than 120 seconds.
Nov 19 18:16:54 hideout kernel: [  721.780127] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 19 18:16:54 hideout kernel: [  721.780130] python        D 00000000ffffffff     0  2318   2177 0x00000000
Nov 19 18:16:54 hideout kernel: [  721.780134]  ffff8800370114b8 0000000000000082 ffff880037011468 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780138]  ffff88003734c7c0 0000000000015880 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780141]  0000000000015880 ffff88003734c7c0 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780145] Call Trace:
Nov 19 18:16:54 hideout kernel: [  721.780158]  [<ffffffff810da710>] ? sync_page+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.780165]  [<ffffffff81527458>] io_schedule+0x28/0x40
Nov 19 18:16:54 hideout kernel: [  721.780167]  [<ffffffff810da74d>] sync_page+0x3d/0x50
Nov 19 18:16:54 hideout kernel: [  721.780170]  [<ffffffff81527a42>] __wait_on_bit_lock+0x52/0xb0
Nov 19 18:16:54 hideout kernel: [  721.780173]  [<ffffffff810da6f2>] __lock_page+0x62/0x70
Nov 19 18:16:54 hideout kernel: [  721.780179]  [<ffffffff81078b70>] ? wake_bit_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.780182]  [<ffffffff810db6c2>] ? unlock_page+0x22/0x30
Nov 19 18:16:54 hideout kernel: [  721.780222]  [<ffffffffa00cdebe>] T.904+0x25e/0x360 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780233]  [<ffffffffa008f35c>] ? generic_bin_search+0x19c/0x210 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780246]  [<ffffffffa00ce0d2>] extent_writepages+0x42/0x60 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780259]  [<ffffffffa00b6180>] ? btrfs_get_extent+0x0/0x8c0 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780271]  [<ffffffffa00d9a98>] ? btrfs_set_lock_blocking+0x18/0x20 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780284]  [<ffffffffa00b0ad2>] btrfs_writepages+0x22/0x30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780287]  [<ffffffff810e3918>] do_writepages+0x28/0x50
Nov 19 18:16:54 hideout kernel: [  721.780293]  [<ffffffff8113edec>] writeback_single_inode+0x1bc/0x450
Nov 19 18:16:54 hideout kernel: [  721.780297]  [<ffffffff815293a9>] ? _spin_lock+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780308]  [<ffffffffa0099a5d>] ? btrfs_delalloc_reserve_space+0x5d/0x90 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780311]  [<ffffffff8113f5c8>] generic_sync_sb_inodes+0x418/0x530
Nov 19 18:16:54 hideout kernel: [  721.780315]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780318]  [<ffffffff8113f7f3>] writeback_inodes+0x63/0x110
Nov 19 18:16:54 hideout kernel: [  721.780321]  [<ffffffff810e2ee8>] balance_dirty_pages+0x1c8/0x340
Nov 19 18:16:54 hideout kernel: [  721.780324]  [<ffffffff810e30ac>] balance_dirty_pages_ratelimited_nr+0x4c/0x60
Nov 19 18:16:54 hideout kernel: [  721.780337]  [<ffffffffa00ba3d4>] btrfs_file_write+0x5f4/0x820 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780341]  [<ffffffff8111ede8>] vfs_write+0xb8/0x1a0
Nov 19 18:16:54 hideout kernel: [  721.780347]  [<ffffffff811fb4b8>] ecryptfs_write_lower+0x78/0xf0
Nov 19 18:16:54 hideout kernel: [  721.780350]  [<ffffffff811fb04b>] ecryptfs_write_inode_size_to_header+0x6b/0xf0
Nov 19 18:16:54 hideout kernel: [  721.780352]  [<ffffffff811fb0e8>] ecryptfs_write_inode_size_to_metadata+0x18/0x30
Nov 19 18:16:54 hideout kernel: [  721.780355]  [<ffffffff811fb1ed>] ecryptfs_write_end+0xed/0x260
Nov 19 18:16:54 hideout kernel: [  721.780358]  [<ffffffff810da1e5>] generic_perform_write+0x125/0x1d0
Nov 19 18:16:54 hideout kernel: [  721.780361]  [<ffffffff810dafa3>] generic_file_buffered_write+0x83/0x140
Nov 19 18:16:54 hideout kernel: [  721.780364]  [<ffffffff810dc920>] __generic_file_aio_write_nolock+0x240/0x470
Nov 19 18:16:54 hideout kernel: [  721.780367]  [<ffffffff810ecef9>] ? shmem_truncate_range+0x489/0x810
Nov 19 18:16:54 hideout kernel: [  721.780370]  [<ffffffff810dcc70>] generic_file_aio_write+0x70/0xf0
Nov 19 18:16:54 hideout kernel: [  721.780372]  [<ffffffff810ed2a0>] ? shmem_delete_inode+0x0/0x100
Nov 19 18:16:54 hideout kernel: [  721.780375]  [<ffffffff8111eb02>] do_sync_write+0xf2/0x130
Nov 19 18:16:54 hideout kernel: [  721.780379]  [<ffffffff8104a809>] ? __wake_up_sync_key+0x59/0x70
Nov 19 18:16:54 hideout kernel: [  721.780382]  [<ffffffff81078b30>] ? autoremove_wake_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.780393]  [<ffffffff81220521>] ? security_file_permission+0x11/0x20
Nov 19 18:16:54 hideout kernel: [  721.780396]  [<ffffffff8111ede8>] vfs_write+0xb8/0x1a0
Nov 19 18:16:54 hideout kernel: [  721.780399]  [<ffffffff8111f89c>] sys_write+0x4c/0x80
Nov 19 18:16:54 hideout kernel: [  721.780402]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b
Nov 19 18:16:54 hideout kernel: [  721.780408] INFO: task python:23415 blocked for more than 120 seconds.
Nov 19 18:16:54 hideout kernel: [  721.780409] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 19 18:16:54 hideout kernel: [  721.780411] python        D 0000000000000000     0 23415  16021 0x00000000
Nov 19 18:16:54 hideout kernel: [  721.780414]  ffff880041d79598 0000000000000086 ffff88000d8e3910 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780422]  ffff880048579a60 0000000000015880 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780425]  0000000000015880 ffff880048579a60 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780428] Call Trace:
Nov 19 18:16:54 hideout kernel: [  721.780431]  [<ffffffff810da710>] ? sync_page+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.780433]  [<ffffffff81527458>] io_schedule+0x28/0x40
Nov 19 18:16:54 hideout kernel: [  721.780436]  [<ffffffff810da74d>] sync_page+0x3d/0x50
Nov 19 18:16:54 hideout kernel: [  721.780438]  [<ffffffff81527a42>] __wait_on_bit_lock+0x52/0xb0
Nov 19 18:16:54 hideout kernel: [  721.780441]  [<ffffffff810da6f2>] __lock_page+0x62/0x70
Nov 19 18:16:54 hideout kernel: [  721.780443]  [<ffffffff81078b70>] ? wake_bit_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.780446]  [<ffffffff810db6c2>] ? unlock_page+0x22/0x30
Nov 19 18:16:54 hideout kernel: [  721.780459]  [<ffffffffa00cdebe>] T.904+0x25e/0x360 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780472]  [<ffffffffa00ce0d2>] extent_writepages+0x42/0x60 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780484]  [<ffffffffa00b6180>] ? btrfs_get_extent+0x0/0x8c0 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780497]  [<ffffffffa00b0ad2>] btrfs_writepages+0x22/0x30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780500]  [<ffffffff810e3918>] do_writepages+0x28/0x50
Nov 19 18:16:54 hideout kernel: [  721.780502]  [<ffffffff8113edec>] writeback_single_inode+0x1bc/0x450
Nov 19 18:16:54 hideout kernel: [  721.780505]  [<ffffffff811144d1>] ? __slab_free+0x91/0x120
Nov 19 18:16:54 hideout kernel: [  721.780515]  [<ffffffffa0099a5d>] ? btrfs_delalloc_reserve_space+0x5d/0x90 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780518]  [<ffffffff8113f5c8>] generic_sync_sb_inodes+0x418/0x530
Nov 19 18:16:54 hideout kernel: [  721.780522]  [<ffffffff812762ce>] ? prop_fraction_single+0x4e/0x80
Nov 19 18:16:54 hideout kernel: [  721.780525]  [<ffffffff8113f7f3>] writeback_inodes+0x63/0x110
Nov 19 18:16:54 hideout kernel: [  721.780528]  [<ffffffff810e2ee8>] balance_dirty_pages+0x1c8/0x340
Nov 19 18:16:54 hideout kernel: [  721.780531]  [<ffffffff815293a9>] ? _spin_lock+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780534]  [<ffffffff810e30ac>] balance_dirty_pages_ratelimited_nr+0x4c/0x60
Nov 19 18:16:54 hideout kernel: [  721.780537]  [<ffffffff810f4443>] __do_fault+0x253/0x4e0
Nov 19 18:16:54 hideout kernel: [  721.780539]  [<ffffffff810f89d7>] handle_mm_fault+0x1a7/0x3c0
Nov 19 18:16:54 hideout kernel: [  721.780542]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780545]  [<ffffffff8152bf4a>] do_page_fault+0x16a/0x370
Nov 19 18:16:54 hideout kernel: [  721.780548]  [<ffffffff815298c5>] page_fault+0x25/0x30
Nov 19 18:16:54 hideout kernel: [  721.780551]  [<ffffffff810d9e4f>] ? file_read_actor+0x3f/0x180
Nov 19 18:16:54 hideout kernel: [  721.780553]  [<ffffffff810d9f6d>] ? file_read_actor+0x15d/0x180
Nov 19 18:16:54 hideout kernel: [  721.780556]  [<ffffffff810db923>] T.768+0x253/0x440
Nov 19 18:16:54 hideout kernel: [  721.780558]  [<ffffffff810dbbc6>] generic_file_aio_read+0xb6/0x1d0
Nov 19 18:16:54 hideout kernel: [  721.780561]  [<ffffffff8111ec32>] do_sync_read+0xf2/0x130
Nov 19 18:16:54 hideout kernel: [  721.780565]  [<ffffffff8112c5ba>] ? do_filp_open+0x2ca/0xac0
Nov 19 18:16:54 hideout kernel: [  721.780567]  [<ffffffff815293a9>] ? _spin_lock+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780570]  [<ffffffff81078b30>] ? autoremove_wake_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.780573]  [<ffffffff8112306f>] ? cp_new_stat+0xdf/0xf0
Nov 19 18:16:54 hideout kernel: [  721.780576]  [<ffffffff81220521>] ? security_file_permission+0x11/0x20
Nov 19 18:16:54 hideout kernel: [  721.780579]  [<ffffffff8111f215>] vfs_read+0xb5/0x1a0
Nov 19 18:16:54 hideout kernel: [  721.780581]  [<ffffffff8111f81c>] sys_read+0x4c/0x80
Nov 19 18:16:54 hideout kernel: [  721.780584]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b
Nov 19 18:16:54 hideout kernel: [  721.780587] INFO: task pdflush:24402 blocked for more than 120 seconds.
Nov 19 18:16:54 hideout kernel: [  721.780588] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 19 18:16:54 hideout kernel: [  721.780590] pdflush       D 00000000ffffffff     0 24402      2 0x00000000
Nov 19 18:16:54 hideout kernel: [  721.780593]  ffff8800210dba00 0000000000000046 0000000000000000 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780596]  ffff880033545e70 0000000000015880 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780600]  0000000000015880 ffff880033545e70 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780603] Call Trace:
Nov 19 18:16:54 hideout kernel: [  721.780605]  [<ffffffff810da710>] ? sync_page+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.780608]  [<ffffffff81527458>] io_schedule+0x28/0x40
Nov 19 18:16:54 hideout kernel: [  721.780610]  [<ffffffff810da74d>] sync_page+0x3d/0x50
Nov 19 18:16:54 hideout kernel: [  721.780613]  [<ffffffff81527a42>] __wait_on_bit_lock+0x52/0xb0
Nov 19 18:16:54 hideout kernel: [  721.780615]  [<ffffffff810da6f2>] __lock_page+0x62/0x70
Nov 19 18:16:54 hideout kernel: [  721.780618]  [<ffffffff81078b70>] ? wake_bit_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.780620]  [<ffffffff810db6c2>] ? unlock_page+0x22/0x30
Nov 19 18:16:54 hideout kernel: [  721.780632]  [<ffffffffa00cdebe>] T.904+0x25e/0x360 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780645]  [<ffffffffa00ce0d2>] extent_writepages+0x42/0x60 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780657]  [<ffffffffa00b6180>] ? btrfs_get_extent+0x0/0x8c0 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780673]  [<ffffffffa00b0ad2>] btrfs_writepages+0x22/0x30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780676]  [<ffffffff810e3918>] do_writepages+0x28/0x50
Nov 19 18:16:54 hideout kernel: [  721.780679]  [<ffffffff8113edec>] writeback_single_inode+0x1bc/0x450
Nov 19 18:16:54 hideout kernel: [  721.780682]  [<ffffffff81135166>] ? generic_forget_inode+0x1b6/0x240
Nov 19 18:16:54 hideout kernel: [  721.780685]  [<ffffffff811353a0>] ? generic_drop_inode+0x10/0x30
Nov 19 18:16:54 hideout kernel: [  721.780687]  [<ffffffff8113f5c8>] generic_sync_sb_inodes+0x418/0x530
Nov 19 18:16:54 hideout kernel: [  721.780690]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780693]  [<ffffffff8113f7f3>] writeback_inodes+0x63/0x110
Nov 19 18:16:54 hideout kernel: [  721.780696]  [<ffffffff810e2c4e>] background_writeout+0xae/0xe0
Nov 19 18:16:54 hideout kernel: [  721.780699]  [<ffffffff810e411e>] __pdflush+0x13e/0x260
Nov 19 18:16:54 hideout kernel: [  721.780701]  [<ffffffff810e4240>] ? pdflush+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.780704]  [<ffffffff810e4288>] pdflush+0x48/0x50
Nov 19 18:16:54 hideout kernel: [  721.780706]  [<ffffffff810e2ba0>] ? background_writeout+0x0/0xe0
Nov 19 18:16:54 hideout kernel: [  721.780709]  [<ffffffff810e4240>] ? pdflush+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.780712]  [<ffffffff81078746>] kthread+0xa6/0xb0
Nov 19 18:16:54 hideout kernel: [  721.780715]  [<ffffffff810130ea>] child_rip+0xa/0x20
Nov 19 18:16:54 hideout kernel: [  721.780717]  [<ffffffff810786a0>] ? kthread+0x0/0xb0
Nov 19 18:16:54 hideout kernel: [  721.780719]  [<ffffffff810130e0>] ? child_rip+0x0/0x20
Nov 19 18:16:54 hideout kernel: [  721.780721] INFO: task btrfsctl:27925 blocked for more than 120 seconds.
Nov 19 18:16:54 hideout kernel: [  721.780723] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 19 18:16:54 hideout kernel: [  721.780725] btrfsctl      D 00000000ffffffff     0 27925  13443 0x00000000
Nov 19 18:16:54 hideout kernel: [  721.780728]  ffff88000e3fb908 0000000000000086 0000000000000000 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780731]  ffff88005e52de70 0000000000015880 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780734]  0000000000015880 ffff88005e52de70 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780737] Call Trace:
Nov 19 18:16:54 hideout kernel: [  721.780740]  [<ffffffff810da710>] ? sync_page+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.780742]  [<ffffffff81527458>] io_schedule+0x28/0x40
Nov 19 18:16:54 hideout kernel: [  721.780745]  [<ffffffff810da74d>] sync_page+0x3d/0x50
Nov 19 18:16:54 hideout kernel: [  721.780747]  [<ffffffff81527a42>] __wait_on_bit_lock+0x52/0xb0
Nov 19 18:16:54 hideout kernel: [  721.780749]  [<ffffffff810da6f2>] __lock_page+0x62/0x70
Nov 19 18:16:54 hideout kernel: [  721.780752]  [<ffffffff81078b70>] ? wake_bit_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.780755]  [<ffffffff810db6c2>] ? unlock_page+0x22/0x30
Nov 19 18:16:54 hideout kernel: [  721.780767]  [<ffffffffa00cdebe>] T.904+0x25e/0x360 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780780]  [<ffffffffa00ce0d2>] extent_writepages+0x42/0x60 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780792]  [<ffffffffa00b6180>] ? btrfs_get_extent+0x0/0x8c0 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780804]  [<ffffffffa00b0ad2>] btrfs_writepages+0x22/0x30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780807]  [<ffffffff810e3918>] do_writepages+0x28/0x50
Nov 19 18:16:54 hideout kernel: [  721.780810]  [<ffffffff8113edec>] writeback_single_inode+0x1bc/0x450
Nov 19 18:16:54 hideout kernel: [  721.780813]  [<ffffffff81135166>] ? generic_forget_inode+0x1b6/0x240
Nov 19 18:16:54 hideout kernel: [  721.780815]  [<ffffffff811353a0>] ? generic_drop_inode+0x10/0x30
Nov 19 18:16:54 hideout kernel: [  721.780818]  [<ffffffff8113f5c8>] generic_sync_sb_inodes+0x418/0x530
Nov 19 18:16:54 hideout kernel: [  721.780821]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780824]  [<ffffffff8113f7f3>] writeback_inodes+0x63/0x110
Nov 19 18:16:54 hideout kernel: [  721.780827]  [<ffffffff810e2ee8>] balance_dirty_pages+0x1c8/0x340
Nov 19 18:16:54 hideout kernel: [  721.780830]  [<ffffffff810e30ac>] balance_dirty_pages_ratelimited_nr+0x4c/0x60
Nov 19 18:16:54 hideout kernel: [  721.780842]  [<ffffffffa00d9942>] btrfs_ioctl+0x8f2/0xa30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780845]  [<ffffffff8112ddfd>] vfs_ioctl+0x1d/0xa0
Nov 19 18:16:54 hideout kernel: [  721.780847]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780850]  [<ffffffff8112e2e5>] file_ioctl+0x35/0x100
Nov 19 18:16:54 hideout kernel: [  721.780853]  [<ffffffff8127834a>] ? __up_read+0x9a/0xc0
Nov 19 18:16:54 hideout kernel: [  721.780855]  [<ffffffff8112e6fb>] do_vfs_ioctl+0x34b/0x370
Nov 19 18:16:54 hideout kernel: [  721.780858]  [<ffffffff8107cf29>] ? up_read+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780861]  [<ffffffff8152bf74>] ? do_page_fault+0x194/0x370
Nov 19 18:16:54 hideout kernel: [  721.780863]  [<ffffffff8112e7a1>] sys_ioctl+0x81/0xa0
Nov 19 18:16:54 hideout kernel: [  721.780866]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b
Nov 19 18:16:54 hideout kernel: [  721.780868] INFO: task btrfsctl:27981 blocked for more than 120 seconds.
Nov 19 18:16:54 hideout kernel: [  721.780870] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 19 18:16:54 hideout kernel: [  721.780871] btrfsctl      D 0000000000000000     0 27981  13443 0x00000000
Nov 19 18:16:54 hideout kernel: [  721.780875]  ffff88000398f908 0000000000000086 0000000000000000 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780881]  ffff8800377a47c0 0000000000015880 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780884]  0000000000015880 ffff8800377a47c0 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.780887] Call Trace:
Nov 19 18:16:54 hideout kernel: [  721.780890]  [<ffffffff810da710>] ? sync_page+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.780892]  [<ffffffff81527458>] io_schedule+0x28/0x40
Nov 19 18:16:54 hideout kernel: [  721.780895]  [<ffffffff810da74d>] sync_page+0x3d/0x50
Nov 19 18:16:54 hideout kernel: [  721.780897]  [<ffffffff81527a42>] __wait_on_bit_lock+0x52/0xb0
Nov 19 18:16:54 hideout kernel: [  721.780899]  [<ffffffff810da6f2>] __lock_page+0x62/0x70
Nov 19 18:16:54 hideout kernel: [  721.780902]  [<ffffffff81078b70>] ? wake_bit_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.780905]  [<ffffffff810db6c2>] ? unlock_page+0x22/0x30
Nov 19 18:16:54 hideout kernel: [  721.780917]  [<ffffffffa00cdebe>] T.904+0x25e/0x360 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780930]  [<ffffffffa00ce0d2>] extent_writepages+0x42/0x60 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780942]  [<ffffffffa00b6180>] ? btrfs_get_extent+0x0/0x8c0 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780954]  [<ffffffffa00b0ad2>] btrfs_writepages+0x22/0x30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.780958]  [<ffffffff810e3918>] do_writepages+0x28/0x50
Nov 19 18:16:54 hideout kernel: [  721.780960]  [<ffffffff8113edec>] writeback_single_inode+0x1bc/0x450
Nov 19 18:16:54 hideout kernel: [  721.780963]  [<ffffffff815293a9>] ? _spin_lock+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780969]  [<ffffffff81110f06>] ? get_partial_node+0x86/0xa0
Nov 19 18:16:54 hideout kernel: [  721.780972]  [<ffffffff81114dfa>] ? __slab_alloc+0x8a/0x2d0
Nov 19 18:16:54 hideout kernel: [  721.780975]  [<ffffffff8113f5c8>] generic_sync_sb_inodes+0x418/0x530
Nov 19 18:16:54 hideout kernel: [  721.780978]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.780980]  [<ffffffff8113f7f3>] writeback_inodes+0x63/0x110
Nov 19 18:16:54 hideout kernel: [  721.780983]  [<ffffffff810e2ee8>] balance_dirty_pages+0x1c8/0x340
Nov 19 18:16:54 hideout kernel: [  721.780986]  [<ffffffff810e30ac>] balance_dirty_pages_ratelimited_nr+0x4c/0x60
Nov 19 18:16:54 hideout kernel: [  721.780999]  [<ffffffffa00d9942>] btrfs_ioctl+0x8f2/0xa30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781002]  [<ffffffff8112ddfd>] vfs_ioctl+0x1d/0xa0
Nov 19 18:16:54 hideout kernel: [  721.781004]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781007]  [<ffffffff8112e2e5>] file_ioctl+0x35/0x100
Nov 19 18:16:54 hideout kernel: [  721.781010]  [<ffffffff8127834a>] ? __up_read+0x9a/0xc0
Nov 19 18:16:54 hideout kernel: [  721.781012]  [<ffffffff8112e6fb>] do_vfs_ioctl+0x34b/0x370
Nov 19 18:16:54 hideout kernel: [  721.781015]  [<ffffffff8107cf29>] ? up_read+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781017]  [<ffffffff8152bf74>] ? do_page_fault+0x194/0x370
Nov 19 18:16:54 hideout kernel: [  721.781019]  [<ffffffff8112e7a1>] sys_ioctl+0x81/0xa0
Nov 19 18:16:54 hideout kernel: [  721.781022]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b
Nov 19 18:16:54 hideout kernel: [  721.781025] INFO: task btrfsctl:27982 blocked for more than 120 seconds.
Nov 19 18:16:54 hideout kernel: [  721.781026] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 19 18:16:54 hideout kernel: [  721.781028] btrfsctl      D 00000000ffffffff     0 27982  13443 0x00000000
Nov 19 18:16:54 hideout kernel: [  721.781031]  ffff880003991908 0000000000000082 ffff88005ef9bf40 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781035]  ffff880029d447c0 0000000000015880 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781038]  0000000000015880 ffff880029d447c0 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781041] Call Trace:
Nov 19 18:16:54 hideout kernel: [  721.781043]  [<ffffffff810da710>] ? sync_page+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.781046]  [<ffffffff81527458>] io_schedule+0x28/0x40
Nov 19 18:16:54 hideout kernel: [  721.781048]  [<ffffffff810da74d>] sync_page+0x3d/0x50
Nov 19 18:16:54 hideout kernel: [  721.781050]  [<ffffffff81527a42>] __wait_on_bit_lock+0x52/0xb0
Nov 19 18:16:54 hideout kernel: [  721.781053]  [<ffffffff810da6f2>] __lock_page+0x62/0x70
Nov 19 18:16:54 hideout kernel: [  721.781055]  [<ffffffff81078b70>] ? wake_bit_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.781058]  [<ffffffff810db6c2>] ? unlock_page+0x22/0x30
Nov 19 18:16:54 hideout kernel: [  721.781070]  [<ffffffffa00cdebe>] T.904+0x25e/0x360 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781083]  [<ffffffffa00ce0d2>] extent_writepages+0x42/0x60 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781095]  [<ffffffffa00b6180>] ? btrfs_get_extent+0x0/0x8c0 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781107]  [<ffffffffa00b0ad2>] btrfs_writepages+0x22/0x30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781110]  [<ffffffff810e3918>] do_writepages+0x28/0x50
Nov 19 18:16:54 hideout kernel: [  721.781113]  [<ffffffff8113edec>] writeback_single_inode+0x1bc/0x450
Nov 19 18:16:54 hideout kernel: [  721.781116]  [<ffffffff815293a9>] ? _spin_lock+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781119]  [<ffffffff81110e43>] ? add_partial+0x53/0x90
Nov 19 18:16:54 hideout kernel: [  721.781121]  [<ffffffff8113f5c8>] generic_sync_sb_inodes+0x418/0x530
Nov 19 18:16:54 hideout kernel: [  721.781124]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781127]  [<ffffffff8113f7f3>] writeback_inodes+0x63/0x110
Nov 19 18:16:54 hideout kernel: [  721.781133]  [<ffffffff810e2ee8>] balance_dirty_pages+0x1c8/0x340
Nov 19 18:16:54 hideout kernel: [  721.781136]  [<ffffffff810e30ac>] balance_dirty_pages_ratelimited_nr+0x4c/0x60
Nov 19 18:16:54 hideout kernel: [  721.781148]  [<ffffffffa00d9942>] btrfs_ioctl+0x8f2/0xa30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781151]  [<ffffffff8112ddfd>] vfs_ioctl+0x1d/0xa0
Nov 19 18:16:54 hideout kernel: [  721.781154]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781156]  [<ffffffff8112e2e5>] file_ioctl+0x35/0x100
Nov 19 18:16:54 hideout kernel: [  721.781159]  [<ffffffff8127834a>] ? __up_read+0x9a/0xc0
Nov 19 18:16:54 hideout kernel: [  721.781161]  [<ffffffff8112e6fb>] do_vfs_ioctl+0x34b/0x370
Nov 19 18:16:54 hideout kernel: [  721.781164]  [<ffffffff8107cf29>] ? up_read+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781167]  [<ffffffff8152bf74>] ? do_page_fault+0x194/0x370
Nov 19 18:16:54 hideout kernel: [  721.781169]  [<ffffffff8112e7a1>] sys_ioctl+0x81/0xa0
Nov 19 18:16:54 hideout kernel: [  721.781172]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b
Nov 19 18:16:54 hideout kernel: [  721.781174] INFO: task btrfsctl:27983 blocked for more than 120 seconds.
Nov 19 18:16:54 hideout kernel: [  721.781176] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 19 18:16:54 hideout kernel: [  721.781177] btrfsctl      D 00000000ffffffff     0 27983  13443 0x00000000
Nov 19 18:16:54 hideout kernel: [  721.781180]  ffff880003809908 0000000000000086 ffff8800038098c8 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781184]  ffff880029d45e70 0000000000015880 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781187]  0000000000015880 ffff880029d45e70 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781190] Call Trace:
Nov 19 18:16:54 hideout kernel: [  721.781192]  [<ffffffff810da710>] ? sync_page+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.781195]  [<ffffffff81527458>] io_schedule+0x28/0x40
Nov 19 18:16:54 hideout kernel: [  721.781197]  [<ffffffff810da74d>] sync_page+0x3d/0x50
Nov 19 18:16:54 hideout kernel: [  721.781200]  [<ffffffff81527a42>] __wait_on_bit_lock+0x52/0xb0
Nov 19 18:16:54 hideout kernel: [  721.781202]  [<ffffffff810da6f2>] __lock_page+0x62/0x70
Nov 19 18:16:54 hideout kernel: [  721.781205]  [<ffffffff81078b70>] ? wake_bit_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.781207]  [<ffffffff810db6c2>] ? unlock_page+0x22/0x30
Nov 19 18:16:54 hideout kernel: [  721.781219]  [<ffffffffa00cdebe>] T.904+0x25e/0x360 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781232]  [<ffffffffa00ce0d2>] extent_writepages+0x42/0x60 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781244]  [<ffffffffa00b6180>] ? btrfs_get_extent+0x0/0x8c0 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781257]  [<ffffffffa00b0ad2>] btrfs_writepages+0x22/0x30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781260]  [<ffffffff810e3918>] do_writepages+0x28/0x50
Nov 19 18:16:54 hideout kernel: [  721.781262]  [<ffffffff8113edec>] writeback_single_inode+0x1bc/0x450
Nov 19 18:16:54 hideout kernel: [  721.781265]  [<ffffffff815270f9>] ? thread_return+0x48/0x37f
Nov 19 18:16:54 hideout kernel: [  721.781268]  [<ffffffff8113f5c8>] generic_sync_sb_inodes+0x418/0x530
Nov 19 18:16:54 hideout kernel: [  721.781271]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781274]  [<ffffffff8113f7f3>] writeback_inodes+0x63/0x110
Nov 19 18:16:54 hideout kernel: [  721.781276]  [<ffffffff810e2ee8>] balance_dirty_pages+0x1c8/0x340
Nov 19 18:16:54 hideout kernel: [  721.781279]  [<ffffffff810e30ac>] balance_dirty_pages_ratelimited_nr+0x4c/0x60
Nov 19 18:16:54 hideout kernel: [  721.781291]  [<ffffffffa00d9942>] btrfs_ioctl+0x8f2/0xa30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781294]  [<ffffffff8112ddfd>] vfs_ioctl+0x1d/0xa0
Nov 19 18:16:54 hideout kernel: [  721.781297]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781299]  [<ffffffff8112e2e5>] file_ioctl+0x35/0x100
Nov 19 18:16:54 hideout kernel: [  721.781302]  [<ffffffff8127834a>] ? __up_read+0x9a/0xc0
Nov 19 18:16:54 hideout kernel: [  721.781304]  [<ffffffff8112e6fb>] do_vfs_ioctl+0x34b/0x370
Nov 19 18:16:54 hideout kernel: [  721.781307]  [<ffffffff8107cf29>] ? up_read+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781310]  [<ffffffff8152bf74>] ? do_page_fault+0x194/0x370
Nov 19 18:16:54 hideout kernel: [  721.781312]  [<ffffffff8112e7a1>] sys_ioctl+0x81/0xa0
Nov 19 18:16:54 hideout kernel: [  721.781315]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b
Nov 19 18:16:54 hideout kernel: [  721.781317] INFO: task btrfsctl:27985 blocked for more than 120 seconds.
Nov 19 18:16:54 hideout kernel: [  721.781319] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 19 18:16:54 hideout kernel: [  721.781320] btrfsctl      D 0000000000000000     0 27985  13443 0x00000000
Nov 19 18:16:54 hideout kernel: [  721.781323]  ffff880003a1d908 0000000000000086 ffff88005ef9bf40 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781327]  ffff880029d43110 0000000000015880 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781330]  0000000000015880 ffff880029d43110 0000000000015880 0000000000015880
Nov 19 18:16:54 hideout kernel: [  721.781333] Call Trace:
Nov 19 18:16:54 hideout kernel: [  721.781335]  [<ffffffff810da710>] ? sync_page+0x0/0x50
Nov 19 18:16:54 hideout kernel: [  721.781338]  [<ffffffff81527458>] io_schedule+0x28/0x40
Nov 19 18:16:54 hideout kernel: [  721.781340]  [<ffffffff810da74d>] sync_page+0x3d/0x50
Nov 19 18:16:54 hideout kernel: [  721.781424]  [<ffffffff81527a42>] __wait_on_bit_lock+0x52/0xb0
Nov 19 18:16:54 hideout kernel: [  721.781427]  [<ffffffff810da6f2>] __lock_page+0x62/0x70
Nov 19 18:16:54 hideout kernel: [  721.781429]  [<ffffffff81078b70>] ? wake_bit_function+0x0/0x40
Nov 19 18:16:54 hideout kernel: [  721.781432]  [<ffffffff810db6c2>] ? unlock_page+0x22/0x30
Nov 19 18:16:54 hideout kernel: [  721.781445]  [<ffffffffa00cdebe>] T.904+0x25e/0x360 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781458]  [<ffffffffa00ce0d2>] extent_writepages+0x42/0x60 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781470]  [<ffffffffa00b6180>] ? btrfs_get_extent+0x0/0x8c0 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781482]  [<ffffffffa00b0ad2>] btrfs_writepages+0x22/0x30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781485]  [<ffffffff810e3918>] do_writepages+0x28/0x50
Nov 19 18:16:54 hideout kernel: [  721.781488]  [<ffffffff8113edec>] writeback_single_inode+0x1bc/0x450
Nov 19 18:16:54 hideout kernel: [  721.781491]  [<ffffffff815270f9>] ? thread_return+0x48/0x37f
Nov 19 18:16:54 hideout kernel: [  721.781494]  [<ffffffff8113f5c8>] generic_sync_sb_inodes+0x418/0x530
Nov 19 18:16:54 hideout kernel: [  721.781497]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781500]  [<ffffffff8113f7f3>] writeback_inodes+0x63/0x110
Nov 19 18:16:54 hideout kernel: [  721.781502]  [<ffffffff810e2ee8>] balance_dirty_pages+0x1c8/0x340
Nov 19 18:16:54 hideout kernel: [  721.781506]  [<ffffffff810e30ac>] balance_dirty_pages_ratelimited_nr+0x4c/0x60
Nov 19 18:16:54 hideout kernel: [  721.781518]  [<ffffffffa00d9942>] btrfs_ioctl+0x8f2/0xa30 [btrfs]
Nov 19 18:16:54 hideout kernel: [  721.781520]  [<ffffffff8112ddfd>] vfs_ioctl+0x1d/0xa0
Nov 19 18:16:54 hideout kernel: [  721.781523]  [<ffffffff81036419>] ? default_spin_lock_flags+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781526]  [<ffffffff8112e2e5>] file_ioctl+0x35/0x100
Nov 19 18:16:54 hideout kernel: [  721.781528]  [<ffffffff8127834a>] ? __up_read+0x9a/0xc0
Nov 19 18:16:54 hideout kernel: [  721.781531]  [<ffffffff8112e6fb>] do_vfs_ioctl+0x34b/0x370
Nov 19 18:16:54 hideout kernel: [  721.781533]  [<ffffffff8107cf29>] ? up_read+0x9/0x10
Nov 19 18:16:54 hideout kernel: [  721.781536]  [<ffffffff8152bf74>] ? do_page_fault+0x194/0x370
Nov 19 18:16:54 hideout kernel: [  721.781538]  [<ffffffff8112e7a1>] sys_ioctl+0x81/0xa0
Nov 19 18:16:54 hideout kernel: [  721.781541]  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b




On Nov 19, 2009, at 6:10 PM, John Dong wrote:

> I forgot to mention, this is using Ubuntu Karmic's 2.6.31 kernel, with btrfs modules built from the btrfs-unstable.git latest head.
> On Nov 19, 2009, at 6:05 PM, John Dong wrote:
> 
>> While attempting to do a full filesystem defrag and checking output of df -h, I've been able to fairly consistently generate a hang:
>> 
>> 
>> i.e. find / -type f -print0 | xargs -0i btrfsctl -d '{}'
>> 
>> and in another terminal, did "watch df -h"
>> 
>> Before long, everything hangs, iowait is near 100%, and no IO happens. I'm unable to get anything out of the kernel logs postmortem, dmesg also hangs.
>> 
>> 
>> FWIW, I was mounted -o compress.--
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

