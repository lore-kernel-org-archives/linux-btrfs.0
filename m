Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34491 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758777AbeD1Qol (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 12:44:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 57991AC4F
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Apr 2018 16:44:40 +0000 (UTC)
Date: Sat, 28 Apr 2018 18:42:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: trace: Remove unnecessary fs_info parameter for
 btrfs__reserve_extent event class
Message-ID: <20180428164206.GI21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426062425.8574-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180426062425.8574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2018 at 02:24:25PM +0800, Qu Wenruo wrote:
> fs_info can be extracted from btrfs_block_group_cache, and all
> btrfs_block_group_cache is created by btrfs_create_block_group_cache()
> with fs_info initialized, no need to worry about NULL pointer
> dereference.

Famous last words.

[   46.484499] Btrfs loaded, crc32c=crc32c-generic, debug=on, assert=on, ref-verify=on
[   46.484968] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
[   46.484972] BTRFS: selftest: Running btrfs free space cache tests
[   46.485096] BTRFS: selftest: Running extent only tests
[   46.485209] BTRFS: selftest: Running bitmap only tests
[   46.485311] BTRFS: selftest: Running bitmap and extent tests
[   46.485549] BTRFS: selftest: Running space stealing from bitmap to extent
[   46.486194] BTRFS: selftest: Free space cache tests finished
[   46.486197] BTRFS: selftest: Running extent buffer operation tests
[   46.486200] BTRFS: selftest: Running btrfs_split_item tests
[   46.486488] BTRFS: selftest: Running extent I/O tests
[   46.486491] BTRFS: selftest: Running find delalloc tests
[   46.865265] BTRFS: selftest: Running extent buffer bitmap tests
[   46.884948] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
[   46.893206] PGD 210b6c067 P4D 210b6c067 PUD 214917067 PMD 0
[   46.899102] Oops: 0000 [#1] PREEMPT SMP
[   46.903058] Modules linked in: btrfs(+) stp llc iscsi_ibft iscsi_boot_sysfs xor zstd_decompress zstd_compress xxhash i2c_algo_bit drm_kms_helper raid6_pq syscopyarea sysfillrect sysimgblt libcrc32c fb_sys_fop
s ttm dm_mod drm tpm_infineon kvm_amd dax tpm_tis kvm tg3 tpm_tis_core tpm i2c_piix4 libphy k10temp mptctl acpi_cpufreq shpchp button pcspkr irqbypass ext4 mbcache jbd2 sr_mod cdrom ohci_pci ata_generic mptsas o
hci_hcd ehci_pci scsi_transport_sas ehci_hcd mptscsih serio_raw mptbase pata_serverworks usbcore sata_svw sg scsi_dh_rdac scsi_dh_emc scsi_dh_alua
[   46.953728] CPU: 1 PID: 676 Comm: modprobe Not tainted 4.17.0-rc2-1.ge195904-vanilla+ #225
[   46.962245] Hardware name: empty empty/S3993, BIOS PAQEX0-3 02/24/2008
[   46.969082] RIP: 0010:memzero_extent_buffer+0xd3/0x1b0 [btrfs]
[   46.975082] RSP: 0018:ffffa953816dbba8 EFLAGS: 00010297
[   46.980435] RAX: 0000000000000000 RBX: ffff98f02b6fc000 RCX: 0000000000000000
[   46.987692] RDX: 0000000000001000 RSI: 0000000000000000 RDI: ffff98f02b6fd000
[   46.994951] RBP: 0000000000001000 R08: 0000000000000001 R09: ffff98f057a30000
[   47.002208] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000800
[   47.009468] R13: 0000000000000004 R14: ffff98f03a509f88 R15: 0000000000000000
[   47.016753] FS:  00007fcb43cbf700(0000) GS:ffff98f066800000(0000) knlGS:0000000000000000
[   47.025062] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   47.030951] CR2: 0000000000000020 CR3: 00000002163ec000 CR4: 00000000000006e0
[   47.038251] Call Trace:
[   47.040889]  __test_eb_bitmaps+0x39/0x2b0 [btrfs]
[   47.045789]  btrfs_test_extent_io+0xd9/0x140 [btrfs]
[   47.050932]  btrfs_run_sanity_tests+0x91/0x140 [btrfs]
[   47.056250]  ? trace_event_define_fields_btrfs__block_group+0xdb/0xdb [btrfs]
[   47.063561]  init_btrfs_fs+0xca/0x129 [btrfs]
[   47.068066]  do_one_initcall+0x5f/0x412
[   47.072047]  ? rcu_read_lock_sched_held+0x6b/0x80
[   47.076894]  ? kmem_cache_alloc_trace+0x27f/0x310
[   47.081750]  do_init_module+0x64/0x21a
[   47.085639]  load_module+0x1d84/0x23a0
[   47.089530]  ? vfs_read+0x127/0x150
[   47.093172]  ? __do_sys_finit_module+0xb7/0xd0
[   47.097743]  __do_sys_finit_module+0xb7/0xd0
[   47.102176]  do_syscall_64+0x62/0x1c0
[   47.105977]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   47.111165] RIP: 0033:0x7fcb437f8849
[   47.114866] RSP: 002b:00007ffdb3760278 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   47.122638] RAX: ffffffffffffffda RBX: 0000000001080390 RCX: 00007fcb437f8849
[   47.129920] RDX: 0000000000000000 RSI: 000000000041983b RDI: 0000000000000005
[   47.137180] RBP: 000000000041983b R08: 0000000000000000 R09: 0000000001080590
[   47.144452] R10: 0000000000000005 R11: 0000000000000246 R12: 00000000010801c0
[   47.151734] R13: 0000000000000000 R14: 0000000000040000 R15: 0000000000000000
[   47.159017] Code: 40 f6 c5 02 c6 01 00 0f 85 95 00 00 00 49 83 c5 01 45 31 ff 49 29 ec 74 65 49 83 fd 0f 0f 87 bb 00 00 00 4b 8b b4 ee a0 01 00 00 <48> 8b 4e 20 48 8d 51 ff 83 e1 01 48 0f 44 d6 48 8b 12 83 e2
 08 
 [   47.178282] RIP: memzero_extent_buffer+0xd3/0x1b0 [btrfs] RSP: ffffa953816dbba8
 [   47.185792] CR2: 0000000000000020
 [   47.189613] ---[ end trace 3db5ec59da242443 ]---
