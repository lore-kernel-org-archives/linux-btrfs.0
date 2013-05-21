Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:40790 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab3EUIhn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 04:37:43 -0400
Received: by mail-lb0-f175.google.com with SMTP id v10so466682lbd.6
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 01:37:42 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 May 2013 10:37:41 +0200
Message-ID: <CAPsrAuDfFLFPVVkya3WZDZnjc-ChWQr5NNrFXWBXGUcvadvTwA@mail.gmail.com>
Subject: panic BTRFS error (device sdp) in __btrfs_inc_extent_ref:1935: Object
 already exists [Linux 3.8.4]
From: Joeri Vanthienen <mail@joerivanthienen.be>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I tried to replace a failed device in a btrfs filesystem on Linux kernel 3.8.4.
After adding a new harddisk (/dev/sdf) to the btrfs pool and removing
the failed device with "btrfs device delete missing /btrfs" the server
panicked.
We can still mount the filesystem in degraded mode, what are the
options to resolve this :) ?

SANOS1:~ # btrfs fi show
Label: 'firstpool'  uuid: 517e8cfa-4275-4589-8da4-6a46ad613daa
        Total devices 15 FS bytes used 2.68TB
        devid   14 size 931.51GB used 394.87GB path /dev/sdp
        devid   13 size 931.51GB used 394.87GB path /dev/sdo
        devid   12 size 931.51GB used 394.87GB path /dev/sdn
        devid   11 size 931.51GB used 394.87GB path /dev/sdm
        devid   10 size 931.51GB used 394.87GB path /dev/sdl
        devid    9 size 931.51GB used 394.87GB path /dev/sdk
        devid    8 size 931.51GB used 394.87GB path /dev/sdj
        devid    7 size 931.51GB used 394.87GB path /dev/sdi
        devid    6 size 931.51GB used 394.87GB path /dev/sdh
        devid   16 size 931.51GB used 373.29GB path /dev/sdf
        devid    5 size 931.51GB used 394.87GB path /dev/sdg
        devid   15 size 931.51GB used 394.87GB path /dev/sde
        devid    2 size 931.51GB used 394.87GB path /dev/sdd
        devid    1 size 931.51GB used 394.87GB path /dev/sdc
        *** Some devices missing

May 20 22:54:00 SANOS1 kernel: btrfs: found 3289 extents
May 20 22:54:07 SANOS1 kernel: ------------[ cut here ]------------
May 20 22:54:07 SANOS1 kernel: WARNING: at fs/btrfs/delayed-ref.c:454
update_existing_ref+0x109/0x140 [btrfs]()
May 20 22:54:07 SANOS1 kernel: Hardware name: X8DTN+-F
May 20 22:54:07 SANOS1 kernel: Modules linked in: joydev st sr_mod
cdrom dm_mod iscsi_scst(O) scst_vdisk(O) scst(O) loop btrfs
zlib_deflate libcrc32c mpt2sas raid_class cpufreq_conservative
cpufreq_userspace cpufreq_powersave iTCO_wdt acpi_cpufreq mperf sg ses
ixgbe igb ptp pps_core iTCO_vendor_support coretemp mdio kvm_intel kvm
crc32c_intel pcspkr serio_raw i2c_i801 lpc_ich mfd_core enclosure
ioatdma i7core_edac edac_core dca mptctl button edd binfmt_misc
microcode autofs4 processor thermal_sys scsi_dh_emc scsi_dh_rdac
scsi_dh_alua scsi_dh_hp_sw scsi_dh mptsas mptscsih mptbase
scsi_transport_sas ata_generic ata_piix [last unloaded: scst]
May 20 22:54:07 SANOS1 kernel: Pid: 9181, comm: btrfs Tainted: G
    O 3.8.4-SCST-1 #2
May 20 22:54:07 SANOS1 kernel: Call Trace:
May 20 22:54:07 SANOS1 kernel:  [<ffffffff8104457a>] ?
warn_slowpath_common+0x7a/0xb0
May 20 22:54:07 SANOS1 kernel:  [<ffffffff810445c5>] ?
warn_slowpath_null+0x15/0x20
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa04541f9>] ?
update_existing_ref+0x109/0x140 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045448a>] ?
add_delayed_tree_ref+0xca/0x1a0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045405a>] ?
add_delayed_ref_head.isra.7+0xca/0x160 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0454c82>] ?
btrfs_add_delayed_tree_ref+0xf2/0x170 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa03fff69>] ?
btrfs_free_extent+0x99/0xf0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0458a62>] ?
replace_path+0x782/0x7f0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045b528>] ?
merge_reloc_root+0x1f8/0x510 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa03eeff5>] ?
btrfs_free_path+0x25/0x30 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045b94a>] ?
merge_reloc_roots+0x10a/0x140 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045be36>] ?
relocate_block_group+0x266/0x690 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045c405>] ?
btrfs_relocate_block_group+0x1a5/0x2e0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0434990>] ?
btrfs_relocate_chunk.isra.56+0x70/0x730 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa04310d2>] ?
free_extent_buffer+0x32/0x90 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0438a71>] ?
btrfs_shrink_device+0x1f1/0x420 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa043bbbd>] ?
btrfs_rm_device+0x24d/0x770 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0443791>] ?
btrfs_ioctl+0xb11/0x1b00 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa04437b3>] ?
btrfs_ioctl+0xb33/0x1b00 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffff815c23b4>] ?
__do_page_fault+0x234/0x4d0
May 20 22:54:07 SANOS1 kernel:  [<ffffffff8116fc4f>] ? do_vfs_ioctl+0x8f/0x530
May 20 22:54:07 SANOS1 kernel:  [<ffffffff8116d241>] ? final_putname+0x21/0x50
May 20 22:54:07 SANOS1 kernel:  [<ffffffff81170181>] ? sys_ioctl+0x91/0xb0
May 20 22:54:07 SANOS1 kernel:  [<ffffffff815c676d>] ?
system_call_fastpath+0x1a/0x1f
May 20 22:54:07 SANOS1 kernel: ---[ end trace 53a7c1fa7b405ba9 ]---
May 20 22:54:07 SANOS1 kernel: ------------[ cut here ]------------
May 20 22:54:07 SANOS1 kernel: WARNING: at fs/btrfs/super.c:256
__btrfs_abort_transaction+0xb9/0xd0 [btrfs]()
May 20 22:54:07 SANOS1 kernel: Hardware name: X8DTN+-F
May 20 22:54:07 SANOS1 kernel: btrfs: Transaction aborted
May 20 22:54:07 SANOS1 kernel: Modules linked in: joydev st sr_mod
cdrom dm_mod iscsi_scst(O) scst_vdisk(O) scst(O) loop btrfs
zlib_deflate libcrc32c mpt2sas raid_class cpufreq_conservative
cpufreq_userspace cpufreq_powersave iTCO_wdt acpi_cpufreq mperf sg ses
ixgbe igb ptp pps_core iTCO_vendor_support coretemp mdio kvm_intel kvm
crc32c_intel pcspkr serio_raw i2c_i801 lpc_ich mfd_core enclosure
ioatdma i7core_edac edac_core dca mptctl button edd binfmt_misc
microcode autofs4 processor thermal_sys scsi_dh_emc scsi_dh_rdac
scsi_dh_alua scsi_dh_hp_sw scsi_dh mptsas mptscsih mptbase
scsi_transport_sas ata_generic ata_piix [last unloaded: scst]
May 20 22:54:07 SANOS1 kernel: Pid: 9181, comm: btrfs Tainted: G
 W  O 3.8.4-SCST-1 #2
May 20 22:54:07 SANOS1 kernel: Call Trace:
May 20 22:54:07 SANOS1 kernel:  [<ffffffff8104457a>] ?
warn_slowpath_common+0x7a/0xb0
May 20 22:54:07 SANOS1 kernel:  [<ffffffff81044651>] ?
warn_slowpath_fmt+0x41/0x50
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa03ebe39>] ?
__btrfs_abort_transaction+0xb9/0xd0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa03fb140>] ?
__btrfs_inc_extent_ref+0x1c0/0x210 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0400c8d>] ?
run_clustered_refs+0x6cd/0xb60 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa03eec01>] ?
btrfs_set_path_blocking+0x31/0x70 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa04048b0>] ?
btrfs_run_delayed_refs+0xc0/0x2e0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa03ef555>] ?
btrfs_put_tree_mod_seq+0x105/0x150 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0414826>] ?
__btrfs_end_transaction+0xe6/0x3f0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0414b4e>] ?
btrfs_end_transaction_throttle+0xe/0x10 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045b7ad>] ?
merge_reloc_root+0x47d/0x510 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa03eeff5>] ?
btrfs_free_path+0x25/0x30 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045b94a>] ?
merge_reloc_roots+0x10a/0x140 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045be36>] ?
relocate_block_group+0x266/0x690 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045c405>] ?
btrfs_relocate_block_group+0x1a5/0x2e0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0434990>] ?
btrfs_relocate_chunk.isra.56+0x70/0x730 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa04310d2>] ?
free_extent_buffer+0x32/0x90 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0438a71>] ?
btrfs_shrink_device+0x1f1/0x420 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa043bbbd>] ?
btrfs_rm_device+0x24d/0x770 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0443791>] ?
btrfs_ioctl+0xb11/0x1b00 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa04437b3>] ?
btrfs_ioctl+0xb33/0x1b00 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffff815c23b4>] ?
__do_page_fault+0x234/0x4d0
May 20 22:54:07 SANOS1 kernel:  [<ffffffff8116fc4f>] ? do_vfs_ioctl+0x8f/0x530
May 20 22:54:07 SANOS1 kernel:  [<ffffffff8116d241>] ? final_putname+0x21/0x50
May 20 22:54:07 SANOS1 kernel:  [<ffffffff81170181>] ? sys_ioctl+0x91/0xb0
May 20 22:54:07 SANOS1 kernel:  [<ffffffff815c676d>] ?
system_call_fastpath+0x1a/0x1f
May 20 22:54:07 SANOS1 kernel: ---[ end trace 53a7c1fa7b405baa ]---
May 20 22:54:07 SANOS1 kernel: BTRFS error (device sdp) in
__btrfs_inc_extent_ref:1935: Object already exists
May 20 22:54:07 SANOS1 kernel: btrfs is forced readonly
May 20 22:54:07 SANOS1 kernel: ------------[ cut here ]------------
May 20 22:54:07 SANOS1 kernel: kernel BUG at fs/btrfs/relocation.c:2278!
May 20 22:54:07 SANOS1 kernel: invalid opcode: 0000 [#1] SMP
May 20 22:54:07 SANOS1 kernel: Modules linked in: joydev st sr_mod
cdrom dm_mod iscsi_scst(O) scst_vdisk(O) scst(O) loop btrfs
zlib_deflate libcrc32c mpt2sas raid_class cpufreq_conservative
cpufreq_userspace cpufreq_powersave iTCO_wdt acpi_cpufreq mperf sg ses
ixgbe igb ptp pps_core iTCO_vendor_support coretemp mdio kvm_intel kvm
crc32c_intel pcspkr serio_raw i2c_i801 lpc_ich mfd_core enclosure
ioatdma i7core_edac edac_core dca mptctl button edd binfmt_misc
microcode autofs4 processor thermal_sys scsi_dh_emc scsi_dh_rdac
scsi_dh_alua scsi_dh_hp_sw scsi_dh mptsas mptscsih mptbase
scsi_transport_sas ata_generic ata_piix [last unloaded: scst]
May 20 22:54:07 SANOS1 kernel: CPU 0
May 20 22:54:07 SANOS1 kernel: Pid: 9181, comm: btrfs Tainted: G
 W  O 3.8.4-SCST-1 #2 Supermicro X8DTN+-F/X8DTN+-F
May 20 22:54:07 SANOS1 kernel: RIP: 0010:[<ffffffffa045b972>]
[<ffffffffa045b972>] merge_reloc_roots+0x132/0x140 [btrfs]
May 20 22:54:07 SANOS1 kernel: RSP: 0018:ffff88038b99ba98  EFLAGS: 00010286
May 20 22:54:07 SANOS1 kernel: RAX: 00000000ffffffe2 RBX:
ffff88002cf81000 RCX: 00000000ffffffe2
May 20 22:54:07 SANOS1 kernel: RDX: 0000000000000001 RSI:
ffffffffa047c360 RDI: ffff88082d27e000
May 20 22:54:07 SANOS1 kernel: RBP: ffff88038b99bac8 R08:
0000000000000000 R09: ffff8804aad365c0
May 20 22:54:07 SANOS1 kernel: R10: ffff8800602834c0 R11:
ffff88010469a940 R12: ffff88007a20b000
May 20 22:54:07 SANOS1 kernel: R13: ffff88038b99ba98 R14:
ffff88007a20b590 R15: ffff88007a20b000
May 20 22:54:07 SANOS1 kernel: FS:  00007f82fbf8b740(0000)
GS:ffff8804adc00000(0000) knlGS:0000000000000000
May 20 22:54:07 SANOS1 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 20 22:54:07 SANOS1 kernel: CR2: 00007f57ea573210 CR3:
00000005e55d1000 CR4: 00000000000007f0
May 20 22:54:07 SANOS1 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 20 22:54:07 SANOS1 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 20 22:54:07 SANOS1 kernel: Process btrfs (pid: 9181, threadinfo
ffff88038b99a000, task ffff8802ce00c200)
May 20 22:54:07 SANOS1 kernel: Stack:
May 20 22:54:07 SANOS1 kernel:  ffff8804a0fe1c40 ffff8803e8da6440
0000000000000000 ffff88007a20b020
May 20 22:54:07 SANOS1 kernel:  ffff88007a20b0e8 ffff88013ef8e640
ffff88038b99bb58 ffffffffa045be36
May 20 22:54:07 SANOS1 kernel:  ffffea0019132140 ffff88038b99bb20
0000000000000001 0000000014e62280
May 20 22:54:07 SANOS1 kernel: Call Trace:
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045be36>]
relocate_block_group+0x266/0x690 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa045c405>]
btrfs_relocate_block_group+0x1a5/0x2e0 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0434990>]
btrfs_relocate_chunk.isra.56+0x70/0x730 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa04310d2>] ?
free_extent_buffer+0x32/0x90 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0438a71>]
btrfs_shrink_device+0x1f1/0x420 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa043bbbd>]
btrfs_rm_device+0x24d/0x770 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa0443791>] ?
btrfs_ioctl+0xb11/0x1b00 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffffa04437b3>]
btrfs_ioctl+0xb33/0x1b00 [btrfs]
May 20 22:54:07 SANOS1 kernel:  [<ffffffff815c23b4>] ?
__do_page_fault+0x234/0x4d0
May 20 22:54:07 SANOS1 kernel:  [<ffffffff8116fc4f>] do_vfs_ioctl+0x8f/0x530
May 20 22:54:07 SANOS1 kernel:  [<ffffffff8116d241>] ? final_putname+0x21/0x50
May 20 22:54:07 SANOS1 kernel:  [<ffffffff81170181>] sys_ioctl+0x91/0xb0
May 20 22:54:07 SANOS1 kernel:  [<ffffffff815c676d>]
system_call_fastpath+0x1a/0x1f
May 20 22:54:07 SANOS1 kernel: Code: f9 ff ff 85 c0 74 97 0f 0b 85 d2
0f 85 10 ff ff ff 49 83 bc 24 80 05 00 00 00 75 15 48 83 c4 10 31 c0
5b 41 5c 41 5d 41 5e 5d c3 <0f> 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 44 00 00
55 48 89 e5 41 57 48
May 20 22:54:07 SANOS1 kernel: RIP  [<ffffffffa045b972>]
merge_reloc_roots+0x132/0x140 [btrfs]
May 20 22:54:07 SANOS1 kernel:  RSP <ffff88038b99ba98>
May 20 22:54:07 SANOS1 kernel: ---[ end trace 53a7c1fa7b405bab ]---
