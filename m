Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:38191 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbeD1Sy4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 14:54:56 -0400
Received: by mail-pf0-f171.google.com with SMTP id o76so3843487pfi.5
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Apr 2018 11:54:56 -0700 (PDT)
MIME-Version: 1.0
From: Paul Richards <paul.richards@gmail.com>
Date: Sat, 28 Apr 2018 19:54:54 +0100
Message-ID: <CAMoswehF-GGV-yi_5fFnuvmZWVkeb71F7OcgOgr80r1F-=R_tg@mail.gmail.com>
Subject: fs/btrfs/ctree.h:1559 warnings
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I recently upgraded from Linux 4.4.0 to 4.13.0 (Ubuntu 16.04 stock to
hwe kernel).

Since then, I've noticed lots of btrfs warnings in dmesg (example at
the end).  I believe these warnings to be benign, and they relate to
my partition not being a multiple of 4KiB in size (I confirmed that
alignment is okay in this instance).

I would like to confirm a couple of things:

1. Is this warning definitely safe to ignore?

2. If this warning is a false alarm, has it been removed in more
recent kernel versions (after 4.13)?  I'd like to know if the warning
will go away when I upgrade the kernel further, or if I'll have to
recreate my partitions in order to resolve these warnings (which clog
dmesg).


Thanks.

Example:

[101320.529729] ------------[ cut here ]------------

[101320.529761] WARNING: CPU: 1 PID: 5027 at
/build/linux-hwe-v6kHHF/linux-hwe-4.13.0/fs/btrfs/ctree.h:1559
btrfs_update_device+0x1b4/0x1c0 [btrfs]

[101320.529762] Modules linked in: binfmt_misc dm_crypt crypto_simd
glue_helper aes_x86_64 algif_skcipher af_alg gpio_ich intel_rapl
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
intel_cstate intel_rapl_perf ipmi_ssif serio_raw ipmi_si hpilo
acpi_power_meter ipmi_devintf ipmi_msghandler mac_hid lpc_ich shpchp
ie31200_edac ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 btrfs raid10
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq libcrc32c raid1 raid0 multipath linear mgag200 i2c_algo_bit
ttm crct10dif_pclmul uas drm_kms_helper tg3 syscopyarea sysfillrect
sysimgblt fb_sys_fops crc32_pclmul ptp ghash_clmulni_intel cryptd
psmouse ahci libahci usb_storage drm pps_core

[101320.529803] CPU: 1 PID: 5027 Comm: kworker/u128:8 Tainted: G
 W       4.13.0-39-generic #44~16.04.1-Ubuntu

[101320.529804] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 06/06/2014

[101320.529809] Workqueue: writeback wb_workfn (flush-btrfs-2)

[101320.529811] task: ffff9602b332d900 task.stack: ffffa4ca02e08000

[101320.529829] RIP: 0010:btrfs_update_device+0x1b4/0x1c0 [btrfs]

[101320.529830] RSP: 0018:ffffa4ca02e0b498 EFLAGS: 00010206

[101320.529831] RAX: 0000000000000fff RBX: 0000000000000000 RCX:
0000074702251e00

[101320.529832] RDX: 0000000000000004 RSI: 0000000000003f5c RDI:
ffff9602947aedf0

[101320.529833] RBP: ffffa4ca02e0b4e0 R08: 0000000000003f60 R09:
ffffa4ca02e0b450

[101320.529834] R10: 0000000000001000 R11: 0000000000000003 R12:
ffff9602b3a391c0

[101320.529835] R13: ffff9602f1bbe400 R14: 0000000000003f3c R15:
ffff9602947aedf0

[101320.529837] FS:  0000000000000000(0000) GS:ffff9602fa440000(0000)
knlGS:0000000000000000

[101320.529838] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

[101320.529839] CR2: 00007feb823bb000 CR3: 000000002740a005 CR4:
00000000001606e0

[101320.529840] Call Trace:

[101320.529860]  btrfs_finish_chunk_alloc+0x134/0x510 [btrfs]

[101320.529877]  ? free_extent_buffer+0x4b/0xa0 [btrfs]

[101320.529891]  ? btrfs_insert_item+0x80/0xf0 [btrfs]

[101320.529906]  btrfs_create_pending_block_groups+0x135/0x250 [btrfs]

[101320.529919]  ? btrfs_create_pending_block_groups+0x135/0x250 [btrfs]

[101320.529936]  __btrfs_end_transaction+0x8e/0x2e0 [btrfs]

[101320.529951]  btrfs_end_transaction+0x10/0x20 [btrfs]

[101320.529965]  find_free_extent+0xd12/0xfe0 [btrfs]

[101320.529981]  ? btrfs_defrag_leaves+0x360/0x360 [btrfs]

[101320.529996]  btrfs_reserve_extent+0x9b/0x1f0 [btrfs]

[101320.530011]  cow_file_range.isra.62+0x15b/0x430 [btrfs]

[101320.530026]  run_delalloc_range+0x2ba/0x3a0 [btrfs]

[101320.530042]  ? find_lock_delalloc_range.constprop.55+0x1d3/0x200 [btrfs]

[101320.530058]  writepage_delalloc.isra.45+0x10d/0x170 [btrfs]

[101320.530073]  __extent_writepage+0xd9/0x300 [btrfs]

[101320.530088]  extent_write_cache_pages.constprop.52+0x2c5/0x400 [btrfs]

[101320.530104]  extent_writepages+0x5c/0x90 [btrfs]

[101320.530119]  ? btrfs_releasepage+0x20/0x20 [btrfs]

[101320.530133]  btrfs_writepages+0x28/0x30 [btrfs]

[101320.530136]  do_writepages+0x1f/0x70

[101320.530138]  __writeback_single_inode+0x45/0x330

[101320.530141]  ? fprop_reflect_period_percpu.isra.5+0x8e/0xc0

[101320.530143]  writeback_sb_inodes+0x26a/0x600

[101320.530146]  __writeback_inodes_wb+0x92/0xc0

[101320.530148]  wb_writeback+0x274/0x330

[101320.530151]  wb_workfn+0x18a/0x3b0

[101320.530152]  ? wb_workfn+0x18a/0x3b0

[101320.530156]  process_one_work+0x15b/0x410

[101320.530158]  worker_thread+0x4b/0x460

[101320.530161]  kthread+0x10c/0x140

[101320.530163]  ? process_one_work+0x410/0x410

[101320.530164]  ? kthread_create_on_node+0x70/0x70

[101320.530166]  ret_from_fork+0x35/0x40

[101320.530168] Code: 00 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8
73 23 ff ff 4c 89 ff e8 7b f5 fc ff e9 d9 fe ff ff b8 f4 ff ff ff e9
d9 fe ff ff <0f> ff eb b8 e8 53 08 01 cb 0f 1f 00 0f 1f 44 00 00 55 48
89 e5

[101320.530199] ---[ end trace 7a108943044dc9ba ]---
