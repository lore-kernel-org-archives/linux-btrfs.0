Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36538 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdEARft (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 13:35:49 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.87 #1)
        id 1d5EmX-0001jU-TL by authid <merlin>
        for <linux-btrfs@vger.kernel.org>; Mon, 01 May 2017 10:06:41 -0700
Date: Mon, 1 May 2017 10:06:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 4.11 relocate crash, null pointer
Message-ID: <20170501170641.GG3516@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a filesystem that sadly got corrupted by a SAS card I just installed yesterday.

I don't think in a case like this, there is there a way to roll back all
writes across all subvolumes in the last 24H, correct?

Is the best thing to go in each subvolume, delete the recent snapshots and
rename the one from 24H as the current one?

BTRFS warning (device dm-5): failed to load free space cache for block group 6746013696000, rebuilding it now
BTRFS warning (device dm-5): block group 6754603630592 has wrong amount of free space
BTRFS warning (device dm-5): failed to load free space cache for block group 6754603630592, rebuilding it now
BTRFS warning (device dm-5): block group 7125178777600 has wrong amount of free space
BTRFS warning (device dm-5): failed to load free space cache for block group 7125178777600, rebuilding it now
BTRFS error (device dm-5): bad tree block start 3981076597540270796 2899180224512
BTRFS error (device dm-5): bad tree block start 942082474969670243 2899180224512
BTRFS: error (device dm-5) in __btrfs_free_extent:6944: errno=-5 IO failure
BTRFS info (device dm-5): forced readonly
BTRFS: error (device dm-5) in btrfs_run_delayed_refs:2961: errno=-5 IO failure
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: __del_reloc_root+0x3f/0xa6
PGD 189a0e067
PUD 189a0f067
PMD 0

Oops: 0000 [#1] PREEMPT SMP
Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_cmipci snd_hda_codec_generic snd_hda_intel snd_mpu401_uart snd_hda_codec snd_opl3_lib snd_rawmidi snd_hda_core snd_seq_device snd_hwdep eeepc_wmi snd_pcm asus_wmi rc_ati_x10
 asix snd_timer ati_remote sparse_keymap usbnet rfkill snd hwmon soundcore rc_core evdev libphy tpm_infineon pcspkr i915 parport_pc i2c_i801 input_leds mei_me lpc_ich parport tpm_tis battery usbserial tpm_tis_core tpm wmi e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci sata_sil24 xhci_hcd mvsas ehci_hcd r8169 usbcore mii libsas scsi_transport_sas thermal fan [last unloaded: ftdi_sio]
CPU: 0 PID: 9056 Comm: btrfs Tainted: G     U          4.11.0-amd64-preempt-sysrq-20170406 #2
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
task: ffff88374d2a60c0 task.stack: ffffa6f226424000
RIP: 0010:__del_reloc_root+0x3f/0xa6
RSP: 0018:ffffa6f226427a40 EFLAGS: 00210246
RAX: 0000000000000000 RBX: ffff8838ee256000 RCX: 00000000ffffffe2
RDX: 0000000000000001 RSI: ffffffff9f83b410 RDI: ffff8837992da568
RBP: ffffa6f226427a68 R08: 0000000000000000 R09: ffffffff9fd69480
R10: 0000000000000000 R11: 0000000000000000 R12: ffffa6f226427ab0
R13: ffff883768938000 R14: ffff8837992da568 R15: ffff8837992da570
FS:  00007facd18d28c0(0000) GS:ffff883a5e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000189a10000 CR4: 00000000001406f0
Call Trace:
 free_reloc_roots+0x4f/0x5d
 merge_reloc_roots+0x159/0x1ba
 relocate_block_group+0x410/0x492
 btrfs_relocate_block_group+0x12d/0x253
 btrfs_relocate_chunk+0x3e/0xb1
 btrfs_balance+0xd16/0xf36
 btrfs_ioctl_balance+0x24f/0x2cd
 ? __alloc_pages_nodemask+0x134/0x1e0
 btrfs_ioctl+0x1447/0x1e22
 ? mem_cgroup_charge_statistics+0x1e/0x88
 ? get_page+0x9/0x26
 ? __lru_cache_add+0x2a/0x6c
 ? set_pte_at+0x9/0xd
 ? __handle_mm_fault+0x61d/0xa6f
 vfs_ioctl+0x21/0x38
 ? vfs_ioctl+0x21/0x38
 do_vfs_ioctl+0x4ef/0x537
 ? current_kernel_time64+0x10/0x36
 ? __audit_syscall_entry+0xc2/0xe6
 ? syscall_trace_enter+0x1ac/0x20e
 SyS_ioctl+0x57/0x7b
 do_syscall_64+0x6b/0x7d
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7facd097ecc7
RSP: 002b:00007ffefd3c3128 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007facd097ecc7
RDX: 00007ffefd3c31b8 RSI: 00000000c4009420 RDI: 0000000000000003
RBP: 00007ffefd3c31b8 R08: 0000000000000003 R09: 0000000000008040
R10: 0000000000000541 R11: 0000000000000206 R12: 0000000000000003
R13: 00007ffefd3c4cc9 R14: 0000000000000001 R15: 0000000000000001
Code: af f0 01 00 00 48 89 fb 4d 8b b5 10 0b 00 00 4d 8d be 70 05 00 00 49 81 c6 68 05 00 00 4c 89 ff e8 0f 44 43 00 48 8b 03 4c 89 f7 <48> 8b 30 e8 0e fc ff ff 48 85 c0 49 89 c4 74 0b 4c 89 f6 48 89
RIP: __del_reloc_root+0x3f/0xa6 RSP: ffffa6f226427a40
CR2: 0000000000000000
---[ end trace 64c3fa4dc953d295 ]---
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x1e000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
Rebooting in 20 seconds..
ACPI MEMORY or I/O RESET_REG.

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
