Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:41423 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752477AbeENMdK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 08:33:10 -0400
Received: by mail-lf0-f51.google.com with SMTP id m17-v6so12555466lfj.8
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 05:33:09 -0700 (PDT)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Mon, 14 May 2018 08:33:06 -0400
Message-ID: <CAJtFHUS3y_qTk5nYSkDfXRGYqTZNH6ris=AvaCZopUzP2DVX3Q@mail.gmail.com>
Subject: Hang/deadlock in 4.14.40 running rsync
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running an rsync to copy data onto a btrfs filesystem used for
backups. It's appearing to deadlock/hang. The rsync process stops
doing any IO, and no other IO is ongoing against the filesystem. The
rsync is in state D in ps and is unkillable even with kill -9. The
/proc/<pid>/stack for the rsync:

[<ffffffffa029a520>] btrfs_async_run_delayed_refs+0x110/0x130 [btrfs]
[<ffffffffa02b5eac>] __btrfs_end_transaction+0x1cc/0x2d0 [btrfs]
[<ffffffffa02bbd25>] btrfs_dirty_inode+0x65/0xc0 [btrfs]
[<ffffffffa02c13d0>] btrfs_setattr+0x90/0x380 [btrfs]
[<ffffffff811cd75e>] notify_change+0x2ce/0x400
[<ffffffff811acdba>] chown_common+0xfa/0x150
[<ffffffff811ae05c>] SyS_lchown+0x6c/0xb0
[<ffffffff81001a85>] do_syscall_64+0x55/0x100
[<ffffffff81600071>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[<ffffffffffffffff>] 0xffffffffffffffff


dmesg with the btrfs stuff, including the initial mount:

[ 6813.213251] BTRFS info (device sdc): enabling ssd optimizations
[ 6813.213296] BTRFS info (device sdc): using spread ssd allocation scheme
[ 6813.213342] BTRFS info (device sdc): use zstd compression
[ 6813.213373] BTRFS info (device sdc): using free space tree
[ 6813.213404] BTRFS info (device sdc): has skinny extents
[36775.729252] BTRFS info (device sdc): left=1048576, need=2097152, flags=20
[36775.729333] BTRFS info (device sdc): space_info 2 has 1048576 free,
is not full
[36775.729376] BTRFS info (device sdc): space_info total=8388608,
used=3145728, pinned=0, reserved=0, may_use=4194304, readonly=0
[82104.402887] ------------[ cut here ]------------
[82104.402948] WARNING: CPU: 10 PID: 6015 at fs/btrfs/locking.c:251
btrfs_tree_lock+0x1be/0x1d0 [btrfs]
[82104.402996] Modules linked in: ipmi_si mpt3sas raid_class
scsi_transport_sas dell_rbu nfsv3 nfsv4 nfs fscache ext2 mgag200
i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops ttm drm intel_powerclamp iTCO_wdt coretemp
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
iTCO_vendor_support dcdbas joydev evdev aes_x86_64 crypto_simd cryptd
serio_raw pcspkr glue_helper sg ipmi_devintf ipmi_msghandler
acpi_power_meter lpc_ich i7core_edac mfd_core button nfsd auth_rpcgss
oid_registry nfs_acl lockd grace sunrpc loop autofs4 ext4
crc32c_generic crc16 mbcache jbd2 btrfs xor zstd_decompress
zstd_compress xxhash raid6_pq hid_generic usbhid hid sd_mod
crc32c_intel psmouse i2c_core ehci_pci uhci_hcd ehci_hcd megaraid_sas
usbcore ixgbe usb_common mdio ptp pps_core scsi_mod bnx2
[82104.403404]  [last unloaded: ipmi_si]
[82104.403429] CPU: 10 PID: 6015 Comm: btrfs-transacti Tainted: G
    I     4.14.40 #1
[82104.403513] task: ffff88041df0f040 task.stack: ffffc90004250000
[82104.403562] RIP: 0010:btrfs_tree_lock+0x1be/0x1d0 [btrfs]
[82104.403592] RSP: 0018:ffffc90004253848 EFLAGS: 00010246
[82104.403622] RAX: 000000000000177f RBX: ffff88013dbd9c48 RCX: 0000000000000001
[82104.403660] RDX: 0000000000000001 RSI: 0000000000000002 RDI: ffff88013dbd9c48
[82104.403698] RBP: 0000000000000001 R08: ffff88041df0f040 R09: ffff880000000000
[82104.403736] R10: 0000000000000040 R11: ffff88013dbd9c48 R12: ffff88081c1af470
[82104.403773] R13: 0000000000000001 R14: ffff88081c1af468 R15: ffff88041eba5000
[82104.403812] FS:  0000000000000000(0000) GS:ffff88082fd40000(0000)
knlGS:0000000000000000
[82104.403855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[82104.403886] CR2: 0000557275467dd0 CR3: 0000000001c09001 CR4: 00000000000206e0
[82104.403923] Call Trace:
[82104.405350]  btrfs_search_slot+0x761/0xa60 [btrfs]
[82104.406762]  btrfs_insert_empty_items+0x62/0xb0 [btrfs]
[82104.408194]  btrfs_insert_item+0x5b/0xc0 [btrfs]
[82104.409595]  btrfs_create_pending_block_groups+0xfb/0x1e0 [btrfs]
[82104.410997]  do_chunk_alloc+0x1e5/0x2a0 [btrfs]
[82104.412404]  find_free_extent+0xcd0/0xf60 [btrfs]
[82104.413801]  btrfs_reserve_extent+0x96/0x1e0 [btrfs]
[82104.415191]  btrfs_alloc_tree_block+0xfb/0x4a0 [btrfs]
[82104.416569]  __btrfs_cow_block+0x127/0x570 [btrfs]
[82104.417913]  btrfs_cow_block+0xdd/0x1c0 [btrfs]
[82104.419247]  btrfs_search_slot+0x227/0xa60 [btrfs]
[82104.420570]  ? btrfs_update_inode_item+0x59/0x100 [btrfs]
[82104.421883]  ? iput+0x72/0x1e0
[82104.423200]  write_one_cache_group.isra.45+0x20/0x90 [btrfs]
[82104.424518]  btrfs_start_dirty_block_groups+0xff/0x420 [btrfs]
[82104.425837]  btrfs_commit_transaction+0x121/0x890 [btrfs]
[82104.427161]  ? start_transaction+0x84/0x410 [btrfs]
[82104.428500]  transaction_kthread+0x184/0x1a0 [btrfs]
[82104.429826]  kthread+0xf7/0x130
[82104.431128]  ? btrfs_cleanup_transaction+0x4e0/0x4e0 [btrfs]
[82104.432420]  ? kthread_create_on_node+0x40/0x40
[82104.433700]  ? SyS_exit_group+0xb/0x10
[82104.434958]  ret_from_fork+0x1f/0x30
[82104.436182] Code: 43 58 85 c0 75 2c f0 ff 43 58 f0 ff 43 44 65 48
8b 04 25 00 4d 01 00 8b 80 10 04 00 00 89 43 40 48 83 c4 28 5b 5d 41
5c 41 5d c3 <0f> 0b e9 60 fe ff ff 0f 0b eb d0 0f 1f 80 00 00 00 00 8b
47 4c
[82104.438766] ---[ end trace 2d8eafbb1dc47717 ]---
[82286.641371] INFO: task btrfs-transacti:6015 blocked for more than
120 seconds.
[82286.642665]       Tainted: G        W I     4.14.40 #1
[82286.643866] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.645058] btrfs-transacti D    0  6015      2 0x80000000
[82286.646242] Call Trace:
[82286.647418]  ? __schedule+0x2aa/0x720
[82286.648506]  schedule+0x2d/0x80
[82286.649643]  btrfs_tree_lock+0x111/0x1d0 [btrfs]
[82286.650724]  ? wait_woken+0x80/0x80
[82286.651791]  btrfs_search_slot+0x761/0xa60 [btrfs]
[82286.652852]  btrfs_insert_empty_items+0x62/0xb0 [btrfs]
[82286.653929]  btrfs_insert_item+0x5b/0xc0 [btrfs]
[82286.654984]  btrfs_create_pending_block_groups+0xfb/0x1e0 [btrfs]
[82286.656040]  do_chunk_alloc+0x1e5/0x2a0 [btrfs]
[82286.657093]  find_free_extent+0xcd0/0xf60 [btrfs]
[82286.658178]  btrfs_reserve_extent+0x96/0x1e0 [btrfs]
[82286.659237]  btrfs_alloc_tree_block+0xfb/0x4a0 [btrfs]
[82286.660301]  __btrfs_cow_block+0x127/0x570 [btrfs]
[82286.661377]  btrfs_cow_block+0xdd/0x1c0 [btrfs]
[82286.662423]  btrfs_search_slot+0x227/0xa60 [btrfs]
[82286.663462]  ? btrfs_update_inode_item+0x59/0x100 [btrfs]
[82286.664484]  ? iput+0x72/0x1e0
[82286.665536]  write_one_cache_group.isra.45+0x20/0x90 [btrfs]
[82286.666575]  btrfs_start_dirty_block_groups+0xff/0x420 [btrfs]
[82286.667624]  btrfs_commit_transaction+0x121/0x890 [btrfs]
[82286.668671]  ? start_transaction+0x84/0x410 [btrfs]
[82286.669731]  transaction_kthread+0x184/0x1a0 [btrfs]
[82286.670760]  kthread+0xf7/0x130
[82286.671793]  ? btrfs_cleanup_transaction+0x4e0/0x4e0 [btrfs]
[82286.672828]  ? kthread_create_on_node+0x40/0x40
[82286.673890]  ? SyS_exit_group+0xb/0x10
[82286.674948]  ret_from_fork+0x1f/0x30
[82286.675971] INFO: task rsync:6043 blocked for more than 120 seconds.
[82286.677009]       Tainted: G        W I     4.14.40 #1
[82286.678067] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.679227] rsync           D    0  6043   6042 0x00000000
[82286.680286] Call Trace:
[82286.681352]  ? __schedule+0x2aa/0x720
[82286.682417]  schedule+0x2d/0x80
[82286.683452]  schedule_timeout+0x1bb/0x340
[82286.684482]  ? ttwu_do_wakeup+0x14/0x140
[82286.685521]  ? try_to_wake_up+0x3f/0x400
[82286.686575]  ? btrfs_search_slot+0x48a/0xa60 [btrfs]
[82286.687589]  ? wait_for_completion+0x93/0x100
[82286.688607]  ? __queue_work+0x15f/0x410
[82286.689625]  wait_for_completion+0x93/0x100
[82286.690615]  ? wake_up_q+0x70/0x70
[82286.691566]  btrfs_async_run_delayed_refs+0x110/0x130 [btrfs]
[82286.692524]  __btrfs_end_transaction+0x1cc/0x2d0 [btrfs]
[82286.693489]  btrfs_dirty_inode+0x65/0xc0 [btrfs]
[82286.694447]  btrfs_setattr+0x90/0x380 [btrfs]
[82286.695348]  notify_change+0x2ce/0x400
[82286.696246]  chown_common+0xfa/0x150
[82286.697141]  SyS_lchown+0x6c/0xb0
[82286.698058]  do_syscall_64+0x55/0x100
[82286.698987]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[82286.699881] RIP: 0033:0x7fafb5b27777
[82286.700770] RSP: 002b:00007ffd9f6d6ef8 EFLAGS: 00000246 ORIG_RAX:
000000000000005e
[82286.701710] RAX: ffffffffffffffda RBX: 0000000000008124 RCX: 00007fafb5b27777
[82286.702664] RDX: 000000005d3ac9e8 RSI: 00000000000003e9 RDI: 00007ffd9f6d9190
[82286.703593] RBP: 00007ffd9f6d9190 R08: 0000000000000000 R09: 0000000000000001
[82286.704513] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd9f6d6f20
[82286.705457] R13: 000000005d3ac9e8 R14: 00005572794cb4e8 R15: 0000000000000001
[82286.706418] INFO: task kworker/u34:2:1115 blocked for more than 120 seconds.
[82286.707352]       Tainted: G        W I     4.14.40 #1
[82286.708281] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.709257] kworker/u34:2   D    0  1115      2 0x80000000
[82286.710264] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[82286.711243] Call Trace:
[82286.712208]  ? __schedule+0x2aa/0x720
[82286.713169]  schedule+0x2d/0x80
[82286.714145]  schedule_timeout+0x1bb/0x340
[82286.715129]  ? try_to_wake_up+0x3f/0x400
[82286.716069]  ? wait_for_completion+0x93/0x100
[82286.717007]  wait_for_completion+0x93/0x100
[82286.717961]  ? wake_up_q+0x70/0x70
[82286.718922]  btrfs_async_run_delayed_refs+0x110/0x130 [btrfs]
[82286.719871]  __btrfs_end_transaction+0x1cc/0x2d0 [btrfs]
[82286.720827]  btrfs_finish_ordered_io+0x180/0x6f0 [btrfs]
[82286.721811]  btrfs_scrubparity_helper+0xc3/0x2e0 [btrfs]
[82286.722778]  process_one_work+0x1c0/0x3a0
[82286.723700]  worker_thread+0x42/0x3e0
[82286.724603]  kthread+0xf7/0x130
[82286.725502]  ? create_worker+0x170/0x170
[82286.726407]  ? kthread_create_on_node+0x40/0x40
[82286.727290]  ? SyS_exit_group+0xb/0x10
[82286.728173]  ret_from_fork+0x1f/0x30
[82286.729058] INFO: task kworker/u33:5:2451 blocked for more than 120 seconds.
[82286.729999]       Tainted: G        W I     4.14.40 #1
[82286.730962] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.731913] kworker/u33:5   D    0  2451      2 0x80000000
[82286.732884] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[82286.733875] Call Trace:
[82286.734868]  ? __schedule+0x2aa/0x720
[82286.735854]  ? btrfs_get_token_32+0x56/0x110 [btrfs]
[82286.736824]  schedule+0x2d/0x80
[82286.737820]  btrfs_tree_lock+0xce/0x1d0 [btrfs]
[82286.738808]  ? wait_woken+0x80/0x80
[82286.739778]  btrfs_lock_root_node+0x2a/0x40 [btrfs]
[82286.740757]  btrfs_search_slot+0x9bf/0xa60 [btrfs]
[82286.741758]  ? setup_items_for_insert+0x2f2/0x3d0 [btrfs]
[82286.742779]  lookup_inline_extent_backref+0xf0/0x5e0 [btrfs]
[82286.743788]  ? free_extent_buffer+0x2a/0x90 [btrfs]
[82286.744788]  ? btrfs_release_path+0xe/0x80 [btrfs]
[82286.745801]  ? kmem_cache_alloc+0x175/0x4b0
[82286.746809]  __btrfs_free_extent.isra.61+0xd3/0xbc0 [btrfs]
[82286.747788]  ? alloc_reserved_file_extent+0x22a/0x2b0 [btrfs]
[82286.748774]  ? btrfs_merge_delayed_refs+0x59/0x550 [btrfs]
[82286.749781]  __btrfs_run_delayed_refs+0x4a9/0x11f0 [btrfs]
[82286.750791]  ? ___cache_free+0x24a/0x2b0
[82286.751775]  btrfs_run_delayed_refs+0x79/0x240 [btrfs]
[82286.752753]  delayed_ref_async_start+0x88/0xa0 [btrfs]
[82286.753745]  btrfs_scrubparity_helper+0xc3/0x2e0 [btrfs]
[82286.754713]  process_one_work+0x1c0/0x3a0
[82286.755640]  worker_thread+0x42/0x3e0
[82286.756551]  kthread+0xf7/0x130
[82286.757461]  ? create_worker+0x170/0x170
[82286.758381]  ? kthread_create_on_node+0x40/0x40
[82286.759294]  ? SyS_exit_group+0xb/0x10
[82286.760196]  ret_from_fork+0x1f/0x30
[82286.761100] INFO: task kworker/u33:7:2558 blocked for more than 120 seconds.
[82286.762057]       Tainted: G        W I     4.14.40 #1
[82286.763028] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.763990] kworker/u33:7   D    0  2558      2 0x80000000
[82286.764968] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[82286.765960] Call Trace:
[82286.766952]  ? __schedule+0x2aa/0x720
[82286.767932]  ? generic_bin_search.constprop.33+0x84/0x200 [btrfs]
[82286.768917]  schedule+0x2d/0x80
[82286.769941]  btrfs_tree_lock+0xce/0x1d0 [btrfs]
[82286.770965]  ? wait_woken+0x80/0x80
[82286.771965]  btrfs_lock_root_node+0x2a/0x40 [btrfs]
[82286.772972]  btrfs_search_slot+0x9bf/0xa60 [btrfs]
[82286.774049]  ? set_page_dirty+0x9/0xa0
[82286.775087]  lookup_inline_extent_backref+0xf0/0x5e0 [btrfs]
[82286.776261]  ? kmem_cache_alloc+0x175/0x4b0
[82286.777308]  __btrfs_free_extent.isra.61+0xd3/0xbc0 [btrfs]
[82286.778330]  ? alloc_reserved_file_extent+0x22a/0x2b0 [btrfs]
[82286.779319]  ? btrfs_merge_delayed_refs+0x59/0x550 [btrfs]
[82286.780295]  __btrfs_run_delayed_refs+0x4a9/0x11f0 [btrfs]
[82286.781340]  ? ___cache_free+0x24a/0x2b0
[82286.782344]  btrfs_run_delayed_refs+0x79/0x240 [btrfs]
[82286.783318]  delayed_ref_async_start+0x88/0xa0 [btrfs]
[82286.784293]  btrfs_scrubparity_helper+0xc3/0x2e0 [btrfs]
[82286.785290]  process_one_work+0x1c0/0x3a0
[82286.786280]  worker_thread+0x42/0x3e0
[82286.787235]  kthread+0xf7/0x130
[82286.788181]  ? create_worker+0x170/0x170
[82286.789125]  ? kthread_create_on_node+0x40/0x40
[82286.790154]  ? SyS_exit_group+0xb/0x10
[82286.791129]  ret_from_fork+0x1f/0x30
[82286.792063] INFO: task kworker/u34:10:3110 blocked for more than 120 seconds.
[82286.793022]       Tainted: G        W I     4.14.40 #1
[82286.794060] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.795077] kworker/u34:10  D    0  3110      2 0x80000000
[82286.796074] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[82286.797068] Call Trace:
[82286.798128]  ? __schedule+0x2aa/0x720
[82286.799156]  ? btrfs_buffer_uptodate+0x42/0x60 [btrfs]
[82286.800148]  schedule+0x2d/0x80
[82286.801145]  btrfs_tree_lock+0x111/0x1d0 [btrfs]
[82286.802213]  ? wait_woken+0x80/0x80
[82286.803240]  btrfs_search_slot+0x761/0xa60 [btrfs]
[82286.804249]  btrfs_insert_empty_items+0x62/0xb0 [btrfs]
[82286.805304]  __btrfs_run_delayed_refs+0xe41/0x11f0 [btrfs]
[82286.806353]  btrfs_run_delayed_refs+0x79/0x240 [btrfs]
[82286.807374]  delayed_ref_async_start+0x88/0xa0 [btrfs]
[82286.808398]  btrfs_scrubparity_helper+0xc3/0x2e0 [btrfs]
[82286.809487]  process_one_work+0x1c0/0x3a0
[82286.810516]  worker_thread+0x42/0x3e0
[82286.811491]  kthread+0xf7/0x130
[82286.812442]  ? create_worker+0x170/0x170
[82286.813467]  ? kthread_create_on_node+0x40/0x40
[82286.814427]  ret_from_fork+0x1f/0x30
[82286.815360] INFO: task kworker/u34:5:3242 blocked for more than 120 seconds.
[82286.816313]       Tainted: G        W I     4.14.40 #1
[82286.817285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.818288] kworker/u34:5   D    0  3242      2 0x80000000
[82286.819287] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[82286.820283] Call Trace:
[82286.821344]  ? __schedule+0x2aa/0x720
[82286.822378]  ? btrfs_get_token_32+0x56/0x110 [btrfs]
[82286.823368]  schedule+0x2d/0x80
[82286.824362]  btrfs_tree_lock+0xce/0x1d0 [btrfs]
[82286.825427]  ? wait_woken+0x80/0x80
[82286.826438]  btrfs_lock_root_node+0x2a/0x40 [btrfs]
[82286.827423]  btrfs_search_slot+0x9bf/0xa60 [btrfs]
[82286.828407]  ? setup_items_for_insert+0x2f2/0x3d0 [btrfs]
[82286.829471]  lookup_inline_extent_backref+0xf0/0x5e0 [btrfs]
[82286.830497]  ? free_extent_buffer+0x2a/0x90 [btrfs]
[82286.831488]  ? btrfs_release_path+0xe/0x80 [btrfs]
[82286.832467]  ? kmem_cache_alloc+0x175/0x4b0
[82286.833529]  __btrfs_free_extent.isra.61+0xd3/0xbc0 [btrfs]
[82286.834561]  ? alloc_reserved_file_extent+0x22a/0x2b0 [btrfs]
[82286.835569]  ? btrfs_merge_delayed_refs+0x59/0x550 [btrfs]
[82286.836582]  __btrfs_run_delayed_refs+0x4a9/0x11f0 [btrfs]
[82286.837682]  ? compress_file_range.constprop.71+0x6cb/0x740 [btrfs]
[82286.838747]  btrfs_run_delayed_refs+0x79/0x240 [btrfs]
[82286.839778]  delayed_ref_async_start+0x88/0xa0 [btrfs]
[82286.840797]  btrfs_scrubparity_helper+0xc3/0x2e0 [btrfs]
[82286.841887]  process_one_work+0x1c0/0x3a0
[82286.842900]  worker_thread+0x42/0x3e0
[82286.843859]  kthread+0xf7/0x130
[82286.844800]  ? create_worker+0x170/0x170
[82286.845808]  ? kthread_create_on_node+0x40/0x40
[82286.846776]  ? SyS_exit_group+0xb/0x10
[82286.847710]  ret_from_fork+0x1f/0x30
[82286.848635] INFO: task kworker/u34:7:3534 blocked for more than 120 seconds.
[82286.849663]       Tainted: G        W I     4.14.40 #1
[82286.850644] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.851621] kworker/u34:7   D    0  3534      2 0x80000000
[82286.852625] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[82286.853698] Call Trace:
[82286.854721]  ? __schedule+0x2aa/0x720
[82286.855710]  schedule+0x2d/0x80
[82286.856689]  schedule_timeout+0x1bb/0x340
[82286.857742]  ? try_to_wake_up+0x3f/0x400
[82286.858744]  ? wait_for_completion+0x93/0x100
[82286.859722]  wait_for_completion+0x93/0x100
[82286.860700]  ? wake_up_q+0x70/0x70
[82286.861759]  btrfs_async_run_delayed_refs+0x110/0x130 [btrfs]
[82286.862798]  __btrfs_end_transaction+0x1cc/0x2d0 [btrfs]
[82286.863796]  btrfs_finish_ordered_io+0x180/0x6f0 [btrfs]
[82286.864778]  btrfs_scrubparity_helper+0xc3/0x2e0 [btrfs]
[82286.865816]  process_one_work+0x1c0/0x3a0
[82286.866778]  worker_thread+0x42/0x3e0
[82286.867699]  kthread+0xf7/0x130
[82286.868600]  ? create_worker+0x170/0x170
[82286.869590]  ? kthread_create_on_node+0x40/0x40
[82286.870527]  ? SyS_exit_group+0xb/0x10
[82286.871426]  ret_from_fork+0x1f/0x30
[82286.872320] INFO: task kworker/u34:13:3539 blocked for more than 120 seconds.
[82286.873288]       Tainted: G        W I     4.14.40 #1
[82286.874240] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.875191] kworker/u34:13  D    0  3539      2 0x80000000
[82286.876164] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[82286.877129] Call Trace:
[82286.878157]  ? __schedule+0x2aa/0x720
[82286.879150]  schedule+0x2d/0x80
[82286.880098]  schedule_timeout+0x1bb/0x340
[82286.881041]  ? try_to_wake_up+0x3f/0x400
[82286.882055]  ? wait_for_completion+0x93/0x100
[82286.883022]  wait_for_completion+0x93/0x100
[82286.883961]  ? wake_up_q+0x70/0x70
[82286.884889]  btrfs_async_run_delayed_refs+0x110/0x130 [btrfs]
[82286.885913]  __btrfs_end_transaction+0x1cc/0x2d0 [btrfs]
[82286.886899]  btrfs_finish_ordered_io+0x180/0x6f0 [btrfs]
[82286.887838]  btrfs_scrubparity_helper+0xc3/0x2e0 [btrfs]
[82286.888756]  process_one_work+0x1c0/0x3a0
[82286.889753]  worker_thread+0x42/0x3e0
[82286.890700]  kthread+0xf7/0x130
[82286.891613]  ? create_worker+0x170/0x170
[82286.892530]  ? kthread_create_on_node+0x40/0x40
[82286.893529]  ret_from_fork+0x1f/0x30
[82286.894477] INFO: task kworker/u34:1:3915 blocked for more than 120 seconds.
[82286.895408]       Tainted: G        W I     4.14.40 #1
[82286.896329] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[82286.897290] kworker/u34:1   D    0  3915      2 0x80000000
[82286.898328] Workqueue: btrfs-delalloc btrfs_delalloc_helper [btrfs]
[82286.899258] Call Trace:
[82286.900167]  ? __schedule+0x2aa/0x720
[82286.901079]  schedule+0x2d/0x80
[82286.902073]  schedule_timeout+0x1bb/0x340
[82286.903019]  ? try_to_wake_up+0x3f/0x400
[82286.903932]  ? wait_for_completion+0x93/0x100
[82286.904848]  wait_for_completion+0x93/0x100
[82286.905857]  ? wake_up_q+0x70/0x70
[82286.906811]  btrfs_async_run_delayed_refs+0x110/0x130 [btrfs]
[82286.907747]  __btrfs_end_transaction+0x1cc/0x2d0 [btrfs]
[82286.908681]  cow_file_range_inline+0x491/0x630 [btrfs]
[82286.909695]  compress_file_range.constprop.71+0x4de/0x740 [btrfs]
[82286.910686]  ? submit_compressed_extents+0x460/0x460 [btrfs]
[82286.911642]  async_cow_start+0x2e/0x50 [btrfs]
[82286.912600]  btrfs_scrubparity_helper+0xc3/0x2e0 [btrfs]
[82286.913636]  process_one_work+0x1c0/0x3a0
[82286.914620]  worker_thread+0x42/0x3e0
[82286.915572]  kthread+0xf7/0x130
[82286.916516]  ? create_worker+0x170/0x170
[82286.917546]  ? kthread_create_on_node+0x40/0x40
[82286.918514]  ? SyS_exit_group+0xb/0x10
[82286.919436]  ret_from_fork+0x1f/0x30
