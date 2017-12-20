Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37917 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdLTCsR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 21:48:17 -0500
Received: by mail-wm0-f45.google.com with SMTP id 64so7049191wme.3
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 18:48:16 -0800 (PST)
MIME-Version: 1.0
From: Adam Bahe <adambahe@gmail.com>
Date: Tue, 19 Dec 2017 20:47:35 -0600
Message-ID: <CACzgC9i6xUJTe6nbDP8pC+ZjViryLYfhMk+3du638cKnmjpsKw@mail.gmail.com>
Subject: Cannot balance, ENOSPC errors 4.14.2 vanilla kernel
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have been having ENOSPC errors on any btrfs device delete, btrfs
balance, btrfs device add actions for awhile now. How do I fix this? I
need to be able to remove devices and balance my filesystem again.

[Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): relocating block
group 190774812082176 flags system|raid10
[Tue Dec 19 15:25:26 2017] BTRFS: Transaction aborted (error -27)
[Tue Dec 19 15:25:26 2017] ------------[ cut here ]------------
[Tue Dec 19 15:25:26 2017] WARNING: CPU: 1 PID: 17036 at
fs/btrfs/extent-tree.c:10151
btrfs_create_pending_block_groups+0x250/0x260 [btrfs]
[Tue Dec 19 15:25:26 2017] Modules linked in: dm_mod dax rpcrdma
ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi
ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm
ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel
crypto_simd glue_helper cryptd ext4 intel_cstate jbd2 intel_rapl_perf
mbcache iTCO_wdt iTCO_vendor_support ses mei_me lpc_ich pcspkr joydev
input_leds i2c_i801 mfd_core mei enclosure ioatdma sg wmi shpchp
ipmi_si ipmi_devintf ipmi_msghandler acpi_pad acpi_power_meter nfsd
auth_rpcgss nfs_acl lockd grace sunrpc ip_tables btrfs xor raid6_pq
mlx4_en sd_mod crc32c_intel ast i2c_algo_bit mlx4_core drm_kms_helper
ata_generic syscopyarea
[Tue Dec 19 15:25:26 2017]  pata_acpi sysfillrect sysimgblt
fb_sys_fops ttm drm ata_piix ixgbe mdio ptp mpt3sas pps_core libata
raid_class dca scsi_transport_sas 8021q garp mrp
[Tue Dec 19 15:25:26 2017] CPU: 1 PID: 17036 Comm: btrfs Not tainted
4.14.2-1.x86_64 #1
[Tue Dec 19 15:25:26 2017] Hardware name: Supermicro Super
Server/X10DRi-T4+, BIOS 2.0 12/17/2015
[Tue Dec 19 15:25:26 2017] task: ffff8804620416c0 task.stack: ffffc90026f64000
[Tue Dec 19 15:25:26 2017] RIP:
0010:btrfs_create_pending_block_groups+0x250/0x260 [btrfs]
[Tue Dec 19 15:25:26 2017] RSP: 0018:ffffc90026f679e8 EFLAGS: 00010246
[Tue Dec 19 15:25:26 2017] RAX: 0000000000000026 RBX: 00000000ffffffe5
RCX: 0000000000000000
[Tue Dec 19 15:25:26 2017] RDX: 0000000000000000 RSI: ffff88046f84e108
RDI: ffff88046f84e108
[Tue Dec 19 15:25:26 2017] RBP: ffffc90026f67a68 R08: 0000000000000000
R09: 0000000000003611
[Tue Dec 19 15:25:26 2017] R10: 0000000000000004 R11: 0000000000003610
R12: ffff8804679c38e8
[Tue Dec 19 15:25:26 2017] R13: ffff880108578000 R14: ffff8804679c3828
R15: ffff880108578128
[Tue Dec 19 15:25:26 2017] FS:  00007f46ad2e48c0(0000)
GS:ffff88046f840000(0000) knlGS:0000000000000000
[Tue Dec 19 15:25:26 2017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Tue Dec 19 15:25:26 2017] CR2: 00007f2daae8a000 CR3: 000000048be96000
CR4: 00000000001406e0
[Tue Dec 19 15:25:26 2017] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[Tue Dec 19 15:25:26 2017] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[Tue Dec 19 15:25:26 2017] Call Trace:
[Tue Dec 19 15:25:26 2017]  do_chunk_alloc+0x278/0x2f0 [btrfs]
[Tue Dec 19 15:25:26 2017]  btrfs_force_chunk_alloc+0x30/0x40 [btrfs]
[Tue Dec 19 15:25:26 2017]  relocate_block_group+0xd2/0x610 [btrfs]
[Tue Dec 19 15:25:26 2017]  btrfs_relocate_block_group+0x187/0x240 [btrfs]
[Tue Dec 19 15:25:26 2017]  btrfs_relocate_chunk+0x3b/0xc0 [btrfs]
[Tue Dec 19 15:25:26 2017]  __btrfs_balance+0x854/0xc20 [btrfs]
[Tue Dec 19 15:25:26 2017]  btrfs_balance+0x2f4/0x670 [btrfs]
[Tue Dec 19 15:25:26 2017]  btrfs_ioctl_balance+0x439/0x560 [btrfs]
[Tue Dec 19 15:25:26 2017]  btrfs_ioctl+0xf03/0x20f0 [btrfs]
[Tue Dec 19 15:25:26 2017]  ? tty_write_unlock+0x31/0x40
[Tue Dec 19 15:25:26 2017]  ? tty_ldisc_deref+0x16/0x20
[Tue Dec 19 15:25:26 2017]  ? tty_write+0x1e4/0x2c0
[Tue Dec 19 15:25:26 2017]  ? process_echoes+0x70/0x70
[Tue Dec 19 15:25:26 2017]  ? __vfs_write+0x37/0x140
[Tue Dec 19 15:25:26 2017]  do_vfs_ioctl+0xa7/0x5f0
[Tue Dec 19 15:25:26 2017]  ? getnstimeofday64+0xe/0x20
[Tue Dec 19 15:25:26 2017]  ? __audit_syscall_entry+0xb3/0xf0
[Tue Dec 19 15:25:26 2017]  ? syscall_trace_enter+0x1d0/0x2b0
[Tue Dec 19 15:25:26 2017]  SyS_ioctl+0x79/0x90
[Tue Dec 19 15:25:26 2017]  do_syscall_64+0x67/0x150
[Tue Dec 19 15:25:26 2017]  entry_SYSCALL64_slow_path+0x25/0x25
[Tue Dec 19 15:25:26 2017] RIP: 0033:0x7f46ac36b537
[Tue Dec 19 15:25:26 2017] RSP: 002b:00007ffcceffa448 EFLAGS: 00000206
ORIG_RAX: 0000000000000010
[Tue Dec 19 15:25:26 2017] RAX: ffffffffffffffda RBX: 0000000000000003
RCX: 00007f46ac36b537
[Tue Dec 19 15:25:26 2017] RDX: 00007ffcceffa4e0 RSI: 00000000c4009420
RDI: 0000000000000003
[Tue Dec 19 15:25:26 2017] RBP: 00007ffcceffa4e0 R08: 00007f46ac639a00
R09: 00007ffcceffa1c0
[Tue Dec 19 15:25:26 2017] R10: 00007ffcceffa1d0 R11: 0000000000000206
R12: 00007f46ac638870
[Tue Dec 19 15:25:26 2017] R13: 00007ffcceffc893 R14: 0000000000000000
R15: 0000000000000000
[Tue Dec 19 15:25:26 2017] Code: 79 ff ff ff 49 8b 7c 24 60 89 da 48
c7 c6 a8 55 57 a0 31 c0 e8 52 50 fe ff eb 9b 89 de 48 c7 c7 78 55 57
a0 31 c0 e8 be 8a cd e0 <0f> ff eb 87 66 90 66 2e 0f 1f 84 00 00 00 00
00 0f 1f 44 00 00
[Tue Dec 19 15:25:26 2017] ---[ end trace 7b033857aa29250b ]---
[Tue Dec 19 15:25:26 2017] BTRFS: error (device sdc) in
btrfs_create_pending_block_groups:10151: errno=-27 unknown
[Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): forced readonly
[Tue Dec 19 15:25:26 2017] BTRFS info (device sdc): 3388 enospc errors
during balance
