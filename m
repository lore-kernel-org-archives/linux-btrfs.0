Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:43008 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751179AbeEQMsQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 08:48:16 -0400
Received: by mail-lf0-f65.google.com with SMTP id n18-v6so8548473lfh.10
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 05:48:15 -0700 (PDT)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Thu, 17 May 2018 08:48:13 -0400
Message-ID: <CAJtFHUTHna09ST-_EEiyWmDH6gAqS6wa=zMNMBsifj8ABu99cw@mail.gmail.com>
Subject: btrfs hang on rsync in linux 4.16.8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

running an rsync -av --del as the only process hiting my btrfs backup
filesystem. rsync is now stuck and so is all other access to the
filesystem. Looking at ps it seems the btrfs-cleaner is running, so
maybe that deadlocked with Stack for the rsync:

[<0>] balance_dirty_pages_ratelimited+0x270/0xca0
[<0>] __btrfs_buffered_write+0x3ae/0x730 [btrfs]
[<0>] btrfs_file_write_iter+0x36e/0x510 [btrfs]
[<0>] __vfs_write+0xcf/0x130
[<0>] vfs_write+0xab/0x190
[<0>] SyS_write+0x3d/0x90
[<0>] do_syscall_64+0x55/0x100
[<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[<0>] 0xffffffffffffffff

dmesg has a bunch of stuff starting with:
[245043.379979] WARNING: CPU: 4 PID: 2608 at fs/btrfs/locking.c:251
btrfs_tree_lock+0x1be/0x1d0 [btrfs]
[245043.381571] Modules linked in: ipmi_si mpt3sas raid_class
scsi_transport_sas dell_rbu nfsv3 nfsv4 nfs fscache ext2 mgag200
intel_powerclamp i2c_algo_bit coretemp crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel drm_kms_helper aes_x86_64 joydev evdev
crypto_simd iTCO_wdt cryptd syscopyarea iTCO_vendor_support
sysfillrect sysimgblt dcdbas sg fb_sys_fops ttm glue_helper drm pcspkr
serio_raw ipmi_devintf ipmi_msghandler lpc_ich acpi_power_meter
i7core_edac mfd_core button nfsd auth_rpcgss oid_registry nfs_acl
lockd grace sunrpc loop autofs4 ext4 crc32c_generic crc16 mbcache jbd2
btrfs xor zstd_decompress zstd_compress xxhash raid6_pq hid_generic
usbhid hid sd_mod psmouse crc32c_intel i2c_core ehci_pci uhci_hcd
ehci_hcd ixgbe mdio megaraid_sas usbcore ptp usb_common pps_core
scsi_mod bnx2
[245043.391437]  [last unloaded: ipmi_si]
[245043.392792] CPU: 4 PID: 2608 Comm: btrfs-transacti Tainted: G
  W I      4.16.8 #1
[245043.395489] RIP: 0010:btrfs_tree_lock+0x1be/0x1d0 [btrfs]
[245043.396791] RSP: 0018:ffffc9000424b840 EFLAGS: 00010246
[245043.398093] RAX: 0000000000000a30 RBX: ffff8807e20a3d20 RCX:
0000000000000001
[245043.399414] RDX: 0000000000000001 RSI: 0000000000000002 RDI:
ffff8807e20a3d20
[245043.400732] RBP: 0000000000000001 R08: ffff88041f39a700 R09:
ffff880000000000
[245043.402021] R10: 0000000000000040 R11: ffff8807e20a3d20 R12:
ffff8807cb220630
[245043.403296] R13: 0000000000000001 R14: ffff8807cb220628 R15:
ffff88041fbdf000
[245043.404780] FS:  0000000000000000(0000) GS:ffff88082fc80000(0000)
knlGS:0000000000000000
[245043.406050] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[245043.407321] CR2: 00007fffdbdb9f10 CR3: 0000000001c09005 CR4:
00000000000206e0
[245043.408670] Call Trace:
[245043.409977]  btrfs_search_slot+0x761/0xa60 [btrfs]
[245043.411278]  btrfs_insert_empty_items+0x62/0xb0 [btrfs]
[245043.412572]  btrfs_insert_item+0x5b/0xc0 [btrfs]
[245043.413922]  btrfs_create_pending_block_groups+0xfb/0x1e0 [btrfs]
[245043.415216]  do_chunk_alloc+0x1e5/0x2a0 [btrfs]
[245043.416487]  find_free_extent+0xcd0/0xf60 [btrfs]
[245043.417813]  btrfs_reserve_extent+0x96/0x1e0 [btrfs]
[245043.419105]  btrfs_alloc_tree_block+0xfb/0x4a0 [btrfs]
[245043.420378]  __btrfs_cow_block+0x127/0x550 [btrfs]
[245043.421652]  btrfs_cow_block+0xee/0x190 [btrfs]
[245043.422979]  btrfs_search_slot+0x227/0xa60 [btrfs]
[245043.424279]  ? btrfs_update_inode_item+0x59/0x100 [btrfs]
[245043.425538]  ? iput+0x72/0x1e0
[245043.426798]  write_one_cache_group.isra.49+0x20/0x90 [btrfs]
[245043.428131]  btrfs_start_dirty_block_groups+0x102/0x420 [btrfs]
[245043.429419]  btrfs_commit_transaction+0x11b/0x880 [btrfs]
[245043.430712]  ? start_transaction+0x8e/0x410 [btrfs]
[245043.432006]  transaction_kthread+0x184/0x1a0 [btrfs]
[245043.433341]  kthread+0xf0/0x130
[245043.434628]  ? btrfs_cleanup_transaction+0x4e0/0x4e0 [btrfs]
[245043.435928]  ? kthread_create_worker_on_cpu+0x40/0x40
[245043.437236]  ret_from_fork+0x1f/0x30
[245043.438472] Code: 43 58 85 c0 75 2c f0 ff 43 58 f0 ff 43 44 65 48
8b 04 25 00 4d 01 00 8b 80 00 04 00 00 89 43 40 48 83 c4 28 5b 5d 41
5c 41 5d c3 <0f> 0b e9 60 fe ff ff 0f 0b eb d0 0f 1f 80 00 00 00 00 8b
47 4c
[245043.441054] ---[ end trace 15abaa2aaf36827f ]---

ending with a stuck btrfs-transcaction:

245770.403336] btrfs-transacti D    0  2608      2 0x80000000
[245770.404281] Call Trace:
[245770.405276]  ? __schedule+0x2b1/0x770
[245770.406205]  schedule+0x2d/0x80
[245770.407150]  btrfs_tree_lock+0x111/0x1d0 [btrfs]
[245770.408073]  ? wait_woken+0x80/0x80
[245770.409059]  btrfs_search_slot+0x761/0xa60 [btrfs]
[245770.409994]  btrfs_insert_empty_items+0x62/0xb0 [btrfs]
[245770.410913]  btrfs_insert_item+0x5b/0xc0 [btrfs]
[245770.411817]  btrfs_create_pending_block_groups+0xfb/0x1e0 [btrfs]
[245770.412738]  do_chunk_alloc+0x1e5/0x2a0 [btrfs]
[245770.413627]  find_free_extent+0xcd0/0xf60 [btrfs]
[245770.414513]  btrfs_reserve_extent+0x96/0x1e0 [btrfs]
[245770.415398]  btrfs_alloc_tree_block+0xfb/0x4a0 [btrfs]
[245770.416285]  __btrfs_cow_block+0x127/0x550 [btrfs]
[245770.417230]  btrfs_cow_block+0xee/0x190 [btrfs]
[245770.418118]  btrfs_search_slot+0x227/0xa60 [btrfs]
[245770.419004]  ? btrfs_update_inode_item+0x59/0x100 [btrfs]
[245770.419880]  ? iput+0x72/0x1e0
[245770.420791]  write_one_cache_group.isra.49+0x20/0x90 [btrfs]
[245770.421692]  btrfs_start_dirty_block_groups+0x102/0x420 [btrfs]
[245770.422602]  btrfs_commit_transaction+0x11b/0x880 [btrfs]
[245770.423507]  ? start_transaction+0x8e/0x410 [btrfs]
[245770.424464]  transaction_kthread+0x184/0x1a0 [btrfs]
[245770.425350]  kthread+0xf0/0x130
[245770.426239]  ? btrfs_cleanup_transaction+0x4e0/0x4e0 [btrfs]
[245770.427124]  ? kthread_create_worker_on_cpu+0x40/0x40
[245770.428008]  ret_from_fork+0x1f/0x30
