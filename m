Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37652 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2GaSEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 14:04:15 -0400
Received: from [173.11.111.150] (port=60486 helo=gandalfthegreat.merlins.org)
	by mail1.merlins.org with esmtpa (Exim 4.77 #2)
	id 1SwGnm-0005aU-6z by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 11:04:14 -0700
Received: from merlin by gandalfthegreat.merlins.org with local (Exim 4.77)
	(envelope-from <merlin@gandalfthegreat.merlins.org>)
	id 1SwGnk-0002kq-Fi
	for linux-btrfs@vger.kernel.org; Tue, 31 Jul 2012 11:04:12 -0700
Date: Tue, 31 Jul 2012 11:04:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS crash on mount with 3.4.4
Message-ID: <20120731180412.GA10520@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My kernel crashed for some other reason, and now I can't mount my btrfs
filesystem.
I don't care about the data, it's backed up.

I'll compile a 3.5 kernel, but is there any info you'd like off that
filesystem to see why btrfs is crashing on mount?

Marc

[  313.152857] device label btrfs_pool1 devid 1 transid 20769 /dev/mapper/disk1
[  313.171318] btrfs: disk space caching is enabled
[  316.324225] Btrfs detected SSD devices, enabling SSD mode
[  316.544820] ------------[ cut here ]------------
[  316.544890] kernel BUG at fs/btrfs/free-space-cache.c:1519!
[  316.544956] invalid opcode: 0000 [#1] PREEMPT SMP 
[  316.545022] CPU 0 
[  316.545048] Modules linked in: tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ppdev rfcomm bnep autofs4 binfmt_misc uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 mbcache jbd2 configs parport_pc lp parport loop firewire_sbp2 firewire_core crc_itu_t btusb uvcvideo videobuf2_core videodev media videobuf2_vmalloc bluetooth crc16 videobuf2_memops snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_pcm_oss snd_mixer_oss snd_pcm thinkpad_acpi acpi_cpufreq mperf snd_seq_midi snd_rawmidi snd_seq_midi_event iwlwifi i915 snd_seq mac80211 snd_timer mei(C) drm_kms_helper drm pcspkr i2c_algo_bit i2c_i801 battery psmouse coretemp i2c_core serio_raw iTCO_wdt tpm_tis tpm snd_seq_device xhci_hcd ac iTCO_vendor_support tpm_bios ehci_hcd processor evdev crc32c_intel usbcore snd e1000e sdhci_pci sdhci wmi cfg80211 soundcore nvram mmc_core power_supply usb_common snd_page_alloc rfkill ghash_clmulni_intel microcode video button raid10 r
aid456 raid1 raid0 multipath linear btrfs zlib_deflate md_mod dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq raid6_pq async_xor async_memcpy async_tx xor libcrc32c crc32c blowfish_x86_64 blowfish_common ecb xts gf128mul sd_mod crc_t10dif aesni_intel cryptd aes_x86_64 thermal thermal_sys ahci libahci libata scsi_mod
[  316.546794] 
[  316.546818] Pid: 8416, comm: mount Tainted: G         C   3.4.4-amd64-preempt-noide-20120410 #1 LENOVO 2429A78/2429A78
[  316.546948] RIP: 0010:[<ffffffffa01ad738>]  [<ffffffffa01ad738>] remove_from_bitmap+0x75/0x199 [btrfs]
[  316.547091] RSP: 0018:ffff8801cfde7778  EFLAGS: 00010286
[  316.547153] RAX: 00000000ffffffff RBX: ffff8801e8aae4a0 RCX: 000000000000010b
[  316.547234] RDX: 000000000000000b RSI: 0000000000008000 RDI: 0000000000000000
[  316.547315] RBP: ffff8801cf424d00 R08: 0000000000008000 R09: ffff8801d573c000
[  316.547395] R10: 0000000000000000 R11: ffff8801e8aae4a0 R12: ffff8801cfde77d8
[  316.547476] R13: 0000000cc1c00000 R14: ffff8801cfde77e0 R15: 0000000000000000
[  316.547558] FS:  00007f98a7abb7e0(0000) GS:ffff88021e200000(0000) knlGS:0000000000000000
[  316.547649] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  316.547715] CR2: ffffffffff600400 CR3: 00000001cf4ff000 CR4: 00000000001407f0
[  316.547796] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  316.547878] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  316.547959] Process mount (pid: 8416, threadinfo ffff8801cfde6000, task ffff8802125ba040)
[  316.548050] Stack:
[  316.548076]  0000000000000286 ffff8801cf424d24 0000000cc10b6000 0000000000008000
[  316.548172]  0000000000008050 ffff8801e8aae4a0 ffff8801cf424d00 0000000000000000
[  316.548267]  ffff8801d3d162c0 ffff8801cfde7943 0000000000000000 ffffffffa01af105
[  316.548363] Call Trace:
[  316.548429]  [<ffffffffa01af105>] ? btrfs_remove_free_space+0x24c/0x276 [btrfs]
[  316.548540]  [<ffffffffa0170d2f>] ? btrfs_alloc_logged_file_extent+0x86/0x18d [btrfs]
[  316.548658]  [<ffffffffa01aa42a>] ? replay_one_extent+0x2fa/0x43e [btrfs]
[  316.548742]  [<ffffffff8109b605>] ? __call_rcu+0x5d/0x16e
[  316.548835]  [<ffffffffa01ab873>] ? replay_one_buffer+0x1cf/0x22b [btrfs]
[  316.548938]  [<ffffffffa01aa704>] ? walk_up_log_tree+0x11b/0x1fb [btrfs]
[  316.549042]  [<ffffffffa01ab170>] ? walk_log_tree+0x99/0x1bd [btrfs]
[  316.549145]  [<ffffffffa017a13d>] ? btrfs_read_fs_root_no_name+0x92/0x24f [btrfs]
[  316.549257]  [<ffffffffa01aca6e>] ? btrfs_recover_log_trees+0x1da/0x2d8 [btrfs]
[  316.549367]  [<ffffffffa01ab6a4>] ? replay_one_dir_item+0xb9/0xb9 [btrfs]
[  316.549474]  [<ffffffffa017c2ce>] ? open_ctree+0x1300/0x16aa [btrfs]
[  316.549552]  [<ffffffff811b8118>] ? ida_get_new_above+0x176/0x198
[  316.549644]  [<ffffffffa01613c2>] ? btrfs_mount+0x370/0x4ca [btrfs]
[  316.549722]  [<ffffffff810d3e0d>] ? pcpu_next_pop+0x35/0x41
[  316.549790]  [<ffffffff810d4de8>] ? pcpu_alloc+0x7aa/0x7ec
[  316.549864]  [<ffffffff81105705>] ? mount_fs+0x61/0x144
[  316.549933]  [<ffffffff811187ca>] ? vfs_kern_mount+0x61/0xcc
[  316.550006]  [<ffffffff81118c13>] ? do_kern_mount+0x49/0xd8
[  316.550073]  [<ffffffff8111a34a>] ? do_mount+0x663/0x6c9
[  316.550138]  [<ffffffff810d0fa2>] ? memdup_user+0x31/0x56
[  316.550203]  [<ffffffff8111a492>] ? sys_mount+0x88/0xc3
[  316.550267]  [<ffffffff8136723d>] ? system_call_fastpath+0x1a/0x1f
[  316.550339] Code: 49 8b 04 24 48 39 c2 48 0f 46 c2 48 8d 54 24 10 48 89 44 24 18 e8 8b fe ff ff 85 c0 78 0d 48 8b 74 24 10 49 8b 16 48 39 d6 74 02 <0f> 0b 48 8b 43 18 4d 8d 7d ff 48 39 c6 76 43 48 89 f0 49 03 04 
[  316.550738] RIP  [<ffffffffa01ad738>] remove_from_bitmap+0x75/0x199 [btrfs]
[  316.550841]  RSP <ffff8801cfde7778>
[  316.639437] ---[ end trace 12849f5941c11591 ]---
[  316.639444] note: mount[8416] exited with preempt_count 1
[  316.639472] BUG: scheduling while atomic: mount/8416/0x10000002
[  316.639475] Modules linked in: tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ppdev rfcomm bnep autofs4 binfmt_misc uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 mbcache jbd2 configs parport_pc lp parport loop firewire_sbp2 firewire_core crc_itu_t btusb uvcvideo videobuf2_core videodev media videobuf2_vmalloc bluetooth crc16 videobuf2_memops snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_pcm_oss snd_mixer_oss snd_pcm thinkpad_acpi acpi_cpufreq mperf snd_seq_midi snd_rawmidi snd_seq_midi_event iwlwifi i915 snd_seq mac80211 snd_timer mei(C) drm_kms_helper drm pcspkr i2c_algo_bit i2c_i801 battery psmouse coretemp i2c_core serio_raw iTCO_wdt tpm_tis tpm snd_seq_device xhci_hcd ac iTCO_vendor_support tpm_bios ehci_hcd processor evdev crc32c_intel usbcore snd e1000e sdhci_pci sdhci wmi cfg80211 soundcore nvram mmc_core power_supply usb_common snd_page_alloc rfkill ghash_clmulni_intel microcode video button raid10 r
aid456 raid1 raid0 multipath linear btrfs zlib_deflate md_mod dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq raid6_pq async_xor async_memcpy async_tx xor libcrc32c crc32c blowfish_x86_64 blowfish_common ecb xts gf128mul sd_mod crc_t10dif aesni_intel cryptd aes_x86_64 thermal thermal_sys ahci libahci libata scsi_mod
[  316.639639] Pid: 8416, comm: mount Tainted: G      D  C   3.4.4-amd64-preempt-noide-20120410 #1
[  316.639642] Call Trace:
[  316.639651]  [<ffffffff8135cb5c>] ? __schedule_bug+0x3e/0x46
[  316.639657]  [<ffffffff81361ae9>] ? __schedule+0x90/0x508
[  316.639664]  [<ffffffff8105e21c>] ? __cond_resched+0x10/0x1b
[  316.639669]  [<ffffffff813621d4>] ? _cond_resched+0x12/0x1c
[  316.639675]  [<ffffffff810d79ab>] ? unmap_single_vma+0x57e/0x620
[  316.639683]  [<ffffffff810c4e47>] ? del_page_from_lru_list+0x73/0x73
[  316.639688]  [<ffffffff810d812f>] ? unmap_vmas+0x58/0x9c
[  316.639694]  [<ffffffff810dd0d8>] ? exit_mmap+0x8f/0xd9
[  316.639700]  [<ffffffff8103744a>] ? mmput+0x51/0xf8
[  316.639706]  [<ffffffff8103ccbe>] ? exit_mm+0x10e/0x119
[  316.639711]  [<ffffffff8103cf0d>] ? do_exit+0x244/0x7da
[  316.639717]  [<ffffffff8136299c>] ? _raw_spin_lock_irqsave+0x1c/0x41
[  316.639722]  [<ffffffff8103b2aa>] ? kmsg_dump+0x95/0xf3
[  316.639729]  [<ffffffff81363ad2>] ? oops_end+0xb2/0xb7
[  316.639737]  [<ffffffff8100ed6c>] ? do_invalid_op+0x87/0x91
[  316.639764]  [<ffffffffa01ad738>] ? remove_from_bitmap+0x75/0x199 [btrfs]
[  316.639790]  [<ffffffffa0177112>] ? lock_page+0x11/0x11 [btrfs]
[  316.639796]  [<ffffffff8136851b>] ? invalid_op+0x1b/0x20
[  316.639822]  [<ffffffffa01ad738>] ? remove_from_bitmap+0x75/0x199 [btrfs]
[  316.639846]  [<ffffffffa01ad727>] ? remove_from_bitmap+0x64/0x199 [btrfs]
[  316.639872]  [<ffffffffa01af105>] ? btrfs_remove_free_space+0x24c/0x276 [btrfs]
[  316.639896]  [<ffffffffa0170d2f>] ? btrfs_alloc_logged_file_extent+0x86/0x18d [btrfs]
[  316.639922]  [<ffffffffa01aa42a>] ? replay_one_extent+0x2fa/0x43e [btrfs]
[  316.639928]  [<ffffffff8109b605>] ? __call_rcu+0x5d/0x16e
[  316.639954]  [<ffffffffa01ab873>] ? replay_one_buffer+0x1cf/0x22b [btrfs]
[  316.639978]  [<ffffffffa01aa704>] ? walk_up_log_tree+0x11b/0x1fb [btrfs]
[  316.640002]  [<ffffffffa01ab170>] ? walk_log_tree+0x99/0x1bd [btrfs]
[  316.640028]  [<ffffffffa017a13d>] ? btrfs_read_fs_root_no_name+0x92/0x24f [btrfs]
[  316.640054]  [<ffffffffa01aca6e>] ? btrfs_recover_log_trees+0x1da/0x2d8 [btrfs]
[  316.640078]  [<ffffffffa01ab6a4>] ? replay_one_dir_item+0xb9/0xb9 [btrfs]
[  316.640104]  [<ffffffffa017c2ce>] ? open_ctree+0x1300/0x16aa [btrfs]
[  316.640110]  [<ffffffff811b8118>] ? ida_get_new_above+0x176/0x198
[  316.640130]  [<ffffffffa01613c2>] ? btrfs_mount+0x370/0x4ca [btrfs]
[  316.640136]  [<ffffffff810d3e0d>] ? pcpu_next_pop+0x35/0x41
[  316.640142]  [<ffffffff810d4de8>] ? pcpu_alloc+0x7aa/0x7ec
[  316.640151]  [<ffffffff81105705>] ? mount_fs+0x61/0x144
[  316.640160]  [<ffffffff811187ca>] ? vfs_kern_mount+0x61/0xcc
[  316.640168]  [<ffffffff81118c13>] ? do_kern_mount+0x49/0xd8
[  316.640174]  [<ffffffff8111a34a>] ? do_mount+0x663/0x6c9
[  316.640179]  [<ffffffff810d0fa2>] ? memdup_user+0x31/0x56
[  316.640185]  [<ffffffff8111a492>] ? sys_mount+0x88/0xc3
[  316.640191]  [<ffffffff8136723d>] ? system_call_fastpath+0x1a/0x1f
imklog 5.8.6, log source = /proc/kmsg started.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4-amd64-preempt-noide-20120410 (root@gandalfthegreat) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1 SMP PREEMPT Sun Jun 24 15:32:40 PDT 2012
[    0.000000] Command line: BOOT_IMAGE=linux344x64 ro root=/dev/mapper/cryptroot panic=20 resume=/dev/sdb3 usbcore.autosuspend=1 i915.modeset=1 pcie_aspm=force rootflags=subvol=backuproot cryptopts=source=/dev/sdb4,keyscript=/sbin/cryptgetpw
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040004000 (usable)
[    0.000000]  BIOS-e820: 0000000040004000 - 0000000040005000 (reserved)
[    0.000000]  BIOS-e820: 0000000040005000 - 00000000d0380000 (usable)
[    0.000000]  BIOS-e820: 00000000d0380000 - 00000000daa9f000 (reserved)
[    0.000000]  BIOS-e820: 00000000daa9f000 - 00000000dab9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dab9f000 - 00000000dabff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dabff000 - 00000000dfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021e600000 (usable)
[    0.000000]  BIOS-e820: 000000021e600000 - 000000021f000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: LENOVO 2429A78/2429A78, BIOS G4ET35WW (1.10 ) 05/21/2012
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 0DAC00000 mask FFFC00000 uncachable
[    0.000000]   7 base 100000000 mask F00000000 write-back
[    0.000000]   8 base 200000000 mask FE0000000 write-back
[    0.000000]   9 base 21F000000 mask FFF000000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xd0380 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f0100] f0100
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000d0380000
[    0.000000]  0000000000 - 00d0200000 page 2M
[    0.000000]  00d0200000 - 00d0380000 page 4k
[    0.000000] kernel direct mapping tables up to d0380000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000021e600000
[    0.000000]  0100000000 - 021e600000 page 2M
[    0.000000] kernel direct mapping tables up to 21e600000 @ d0376000-d0380000
[    0.000000] RAMDISK: 7fbb7000 - 80000000
[    0.000000] ACPI: RSDP 00000000000f0120 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000dabfe170 000BC (v01 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: FACP 00000000dabe6000 000F4 (v04 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dabe9000 0F311 (v01 LENOVO TP-G4    00001100 INTL 20061109)
[    0.000000] ACPI: FACS 00000000dab5a000 00040
[    0.000000] ACPI: SLIC 00000000dabfd000 00176 (v01 LENOVO TP-G4    00001100 PTL  00000001)
[    0.000000] ACPI: TCPA 00000000dabfc000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000dabfb000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dabfa000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dabf9000 00797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dabe5000 00038 (v01 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dabe4000 00098 (v01 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dabe3000 0003C (v01 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dabe2000 00052 (v01 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: FPDT 00000000dabe1000 00054 (v01 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dabe8000 000A5 (v32 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dabe0000 0003E (v01 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dabdf000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: POAT 00000000dabde000 00055 (v03 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: SSDT 00000000dabdd000 00C78 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dabdc000 00A7E (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dabdb000 000B8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dabda000 002A6 (v01 LENOVO TP-G4    00001100 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000021e600000
[    0.000000] Initmem setup node 0 0000000000000000-000000021e600000
[    0.000000]   NODE_DATA [000000021e5fc000 - 000000021e5fffff]
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880215e00000-ffff88021cdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021e600
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040004
[    0.000000]     0: 0x00040005 -> 0x000d0380
[    0.000000]     0: 0x00100000 -> 0x0021e600
[    0.000000] On node 0 totalpages: 2025228
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833975 pages, LIFO batch:31
[    0.000000]   Normal zone: 16037 pages used for memmap
[    0.000000]   Normal zone: 1156955 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040004000 - 0000000040005000
[    0.000000] PM: Registered nosave memory: 00000000d0380000 - 00000000daa9f000
[    0.000000] PM: Registered nosave memory: 00000000daa9f000 - 00000000dab9f000
[    0.000000] PM: Registered nosave memory: 00000000dab9f000 - 00000000dabff000
[    0.000000] PM: Registered nosave memory: 00000000dabff000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
[    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
[    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at dfa00000 (gap: dfa00000:18600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88021e200000 s82624 r8192 d23872 u262144
[    0.000000] pcpu-alloc: s82624 r8192 d23872 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1994850
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=linux344x64 ro root=/dev/mapper/cryptroot panic=20 resume=/dev/sdb3 usbcore.autosuspend=1 i915.modeset=1 pcie_aspm=force rootflags=subvol=backuproot cryptopts=source=/dev/sdb4,keyscript=/sbin/cryptgetpw
[    0.000000] PCIe ASPM is forcibly enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7906336k/8886272k available (3499k kernel code, 785360k absent, 194576k reserved, 3216k data, 556k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:33024 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x60
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33030144 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2893.643 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5787.28 BogoMIPS (lpj=11574572)
[    0.000150] pid_max: default: 32768 minimum: 301
[    0.000300] Security Framework initialized
[    0.001294] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.009268] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011149] Mount-cache hash table entries: 256
[    0.011535] Initializing cgroup subsys cpuacct
[    0.011605] Initializing cgroup subsys memory
[    0.011685] Initializing cgroup subsys devices
[    0.011755] Initializing cgroup subsys freezer
[    0.011824] Initializing cgroup subsys net_cls
[    0.011892] Initializing cgroup subsys blkio
[    0.012011] CPU: Physical Processor ID: 0
[    0.012079] CPU: Processor Core ID: 0
[    0.012154] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.012155] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.013034] mce: CPU supports 7 MCE banks
[    0.013123] CPU0: Thermal monitoring enabled (TM1)
[    0.013205] using mwait in idle threads.
[    0.013971] ACPI: Core revision 20120320
[    0.028139] DMAR: Host address width 36
[    0.028210] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.028290] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.028382] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.028460] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.028550] DMAR: RMRR base: 0x000000d9ff0000 end: 0x000000da006fff
[    0.028624] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.029230] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.068893] CPU0: Intel(R) Core(TM) i7-3520M CPU @ 2.90GHz stepping 09
[    0.174270] Performance Events: PEBS fmt1+, generic architected perfmon, Intel PMU driver.
[    0.174505] ... version:                3
[    0.174574] ... bit width:              48
[    0.174643] ... generic registers:      4
[    0.174712] ... value mask:             0000ffffffffffff
[    0.174784] ... max period:             000000007fffffff
[    0.174855] ... fixed-purpose events:   3
[    0.174926] ... event mask:             000000070000000f
[    0.186365] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.198229] Booting Node   0, Processors  #1
[    0.212584] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.218190]  #2
[    0.232176] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.238136]  #3
[    0.252119] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.252301] Brought up 4 CPUs
[    0.252368] ----------------
[    0.252434] | NMI testsuite:
[    0.252500] --------------------
[    0.252567]   remote IPI:  ok  |
[    0.252758]    local IPI:  ok  |
[    0.254076] --------------------
[    0.254143] Good, all   2 testcases passed! |
[    0.254213] ---------------------------------
[    0.254284] Total of 4 processors activated (23149.14 BogoMIPS).
[    0.261662] devtmpfs: initialized
[    0.268084] EVM: security.selinux
[    0.268151] EVM: security.capability
[    0.268333] PM: Registering ACPI NVS region [mem 0xdaa9f000-0xdab9efff] (1048576 bytes)
[    0.268624] dummy: 
[    0.268804] NET: Registered protocol family 16
[    0.269133] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.269224] ACPI: bus type pci registered
[    0.269540] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.269637] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.283260] PCI: Using configuration type 1 for base access
[    0.284548] bio: create slab <bio-0> at 0
[    0.284814] ACPI: Added _OSI(Module Device)
[    0.284884] ACPI: Added _OSI(Processor Device)
[    0.284955] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.285026] ACPI: Added _OSI(Processor Aggregator Device)
[    0.288656] ACPI: EC: EC description table is found, configuring boot EC
[    0.298786] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.303066] ACPI: SSDT 00000000daa3a018 00A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.304184] ACPI: Dynamic OEM Table Load:
[    0.304344] ACPI: SSDT           (null) 00A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.305064] ACPI: SSDT 00000000daa3ba98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.306246] ACPI: Dynamic OEM Table Load:
[    0.306407] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.306828] ACPI: SSDT 00000000daa39d98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.307919] ACPI: Dynamic OEM Table Load:
[    0.308084] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.309483] ACPI: Interpreter enabled
[    0.309554] ACPI: (supports S0 S3 S4 S5)
[    0.309842] ACPI: Using IOAPIC for interrupt routing
[    0.314612] ACPI: Power Resource [PUBS] (on)
[    0.320006] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.321563] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.321641] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.321892] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.322011] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.322088] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.322164] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.322255] pci_root PNP0A08:00: host bridge window [mem 0xdfa00000-0xfebfffff]
[    0.322345] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
[    0.322487] PCI host bridge to bus 0000:00
[    0.322558] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.322633] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.322708] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.322784] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.322860] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.322948] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.323016] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.323037] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.323049] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.323059] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.323166] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.323211] pci 0000:00:14.0: reg 10: [mem 0xf2520000-0xf252ffff 64bit]
[    0.323355] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.323402] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.323445] pci 0000:00:16.0: reg 10: [mem 0xf2535000-0xf253500f 64bit]
[    0.323590] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.323638] pci 0000:00:16.3: [8086:1e3d] type 00 class 0x070002
[    0.323672] pci 0000:00:16.3: reg 10: [io  0x50b0-0x50b7]
[    0.323689] pci 0000:00:16.3: reg 14: [mem 0xf253c000-0xf253cfff]
[    0.323870] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.323906] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.323925] pci 0000:00:19.0: reg 14: [mem 0xf253b000-0xf253bfff]
[    0.323943] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    0.324076] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.324127] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.324166] pci 0000:00:1a.0: reg 10: [mem 0xf253a000-0xf253a3ff]
[    0.324342] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.324396] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.324429] pci 0000:00:1b.0: reg 10: [mem 0xf2530000-0xf2533fff 64bit]
[    0.324582] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.324632] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.324788] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.324840] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.324992] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.325040] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
[    0.325199] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.325266] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.325306] pci 0000:00:1d.0: reg 10: [mem 0xf2539000-0xf25393ff]
[    0.325473] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.325520] pci 0000:00:1f.0: [8086:1e55] type 00 class 0x060100
[    0.325728] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.325771] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    0.325788] pci 0000:00:1f.2: reg 14: [io  0x50bc-0x50bf]
[    0.325806] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    0.325822] pci 0000:00:1f.2: reg 1c: [io  0x50b8-0x50bb]
[    0.325838] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.325857] pci 0000:00:1f.2: reg 24: [mem 0xf2538000-0xf25387ff]
[    0.325954] pci 0000:00:1f.2: PME# supported from D3hot
[    0.325991] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.326024] pci 0000:00:1f.3: reg 10: [mem 0xf2534000-0xf25340ff 64bit]
[    0.326073] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.326317] pci 0000:02:00.0: [1180:e823] type 00 class 0x088001
[    0.326340] pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[    0.326622] pci 0000:02:00.0: reg 10: [mem 0xf1d00000-0xf1d000ff]
[    0.326840] pci 0000:02:00.0: supports D1 D2
[    0.326844] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.336470] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.336548] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.336556] pci 0000:00:1c.0:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.336568] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.336707] pci 0000:03:00.0: [8086:4238] type 00 class 0x028000
[    0.336767] pci 0000:03:00.0: reg 10: [mem 0xf1c00000-0xf1c01fff 64bit]
[    0.337054] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.344244] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.344326] pci 0000:00:1c.1:   bridge window [mem 0xf1c00000-0xf1cfffff]
[    0.344425] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.344502] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.344509] pci 0000:00:1c.2:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.344521] pci 0000:00:1c.2:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.344556] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.344762] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.344827] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.344879] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.345088]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.345361]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.345453] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.350077] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.350706] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11)
[    0.351330] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11)
[    0.351952] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11)
[    0.352585] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 9 10 11)
[    0.353213] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11)
[    0.353840] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.354460] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.355140] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.355243] vgaarb: loaded
[    0.355309] vgaarb: bridge control possible 0000:00:02.0
[    0.355440] PCI: Using ACPI for IRQ routing
[    0.359332] PCI: pci_cache_line_size set to 64 bytes
[    0.359725] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.359730] reserve RAM buffer: 0000000040004000 - 0000000043ffffff 
[    0.359734] reserve RAM buffer: 00000000d0380000 - 00000000d3ffffff 
[    0.359738] reserve RAM buffer: 000000021e600000 - 000000021fffffff 
[    0.359961] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.360453] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.362545] Switching to clocksource hpet
[    0.365947] pnp: PnP ACPI init
[    0.366031] ACPI: bus type pnp registered
[    0.366762] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.366766] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.366770] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.366773] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.366776] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.366779] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.366783] pnp 00:00: [mem 0x000d4000-0x000d7fff]
[    0.366786] pnp 00:00: [mem 0x000d8000-0x000dbfff]
[    0.366791] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.366794] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.366797] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.366800] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.366804] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.366807] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.366810] pnp 00:00: [mem 0x00100000-0xdf9fffff]
[    0.366814] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.366817] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.366902] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.366979] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.367056] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.367134] system 00:00: [mem 0x000c8000-0x000cbfff] could not be reserved
[    0.367211] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
[    0.367286] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
[    0.371218] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.371296] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.371373] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.371449] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.371526] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.371603] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.371680] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.371757] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.371833] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.371910] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.371988] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.372067] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.372102] pnp 00:01: [bus 00-3f]
[    0.372106] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.372110] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.372113] pnp 00:01: [io  0x0d00-0xffff window]
[    0.372117] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.372120] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.372124] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.372128] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.372131] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.372135] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.372138] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.372142] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.372145] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.372148] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.372152] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.372156] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.372159] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.372163] pnp 00:01: [mem 0xdfa00000-0xfebfffff window]
[    0.372166] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.372247] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.372353] pnp 00:02: [io  0x0010-0x001f]
[    0.372356] pnp 00:02: [io  0x0090-0x009f]
[    0.372361] pnp 00:02: [io  0x0024-0x0025]
[    0.372364] pnp 00:02: [io  0x0028-0x0029]
[    0.372367] pnp 00:02: [io  0x002c-0x002d]
[    0.372371] pnp 00:02: [io  0x0030-0x0031]
[    0.372374] pnp 00:02: [io  0x0034-0x0035]
[    0.372377] pnp 00:02: [io  0x0038-0x0039]
[    0.372380] pnp 00:02: [io  0x003c-0x003d]
[    0.372383] pnp 00:02: [io  0x00a4-0x00a5]
[    0.372386] pnp 00:02: [io  0x00a8-0x00a9]
[    0.372389] pnp 00:02: [io  0x00ac-0x00ad]
[    0.372392] pnp 00:02: [io  0x00b0-0x00b5]
[    0.372395] pnp 00:02: [io  0x00b8-0x00b9]
[    0.372398] pnp 00:02: [io  0x00bc-0x00bd]
[    0.372401] pnp 00:02: [io  0x0050-0x0053]
[    0.372404] pnp 00:02: [io  0x0072-0x0077]
[    0.372407] pnp 00:02: [io  0x0400-0x047f]
[    0.372410] pnp 00:02: [io  0x0500-0x057f]
[    0.372413] pnp 00:02: [io  0x0800-0x080f]
[    0.372416] pnp 00:02: [io  0x15e0-0x15ef]
[    0.372419] pnp 00:02: [io  0x1600-0x167f]
[    0.372423] pnp 00:02: [mem 0xf8000000-0xfbffffff]
[    0.372426] pnp 00:02: [mem 0xfffff000-0xffffffff]
[    0.372429] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.372433] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.372436] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.372439] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.372442] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.372549] system 00:02: [io  0x0400-0x047f] has been reserved
[    0.372624] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.372699] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.372774] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.372848] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.372924] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.373000] system 00:02: [mem 0xfffff000-0xffffffff] has been reserved
[    0.373076] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.373152] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.373228] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.373305] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.373381] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.373458] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.373536] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.373583] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.373599] pnp 00:04: [io  0x0000-0x000f]
[    0.373604] pnp 00:04: [io  0x0080-0x008f]
[    0.373608] pnp 00:04: [io  0x00c0-0x00df]
[    0.373611] pnp 00:04: [dma 4]
[    0.373657] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.373671] pnp 00:05: [io  0x0061]
[    0.373715] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.373731] pnp 00:06: [io  0x00f0]
[    0.373742] pnp 00:06: [irq 13]
[    0.373790] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.373804] pnp 00:07: [io  0x0070-0x0071]
[    0.373812] pnp 00:07: [irq 8]
[    0.373857] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.373872] pnp 00:08: [io  0x0060]
[    0.373875] pnp 00:08: [io  0x0064]
[    0.373883] pnp 00:08: [irq 1]
[    0.373929] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.373948] pnp 00:09: [irq 12]
[    0.374002] pnp 00:09: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.374059] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.374109] pnp 00:0a: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.374662] pnp: PnP ACPI: found 11 devices
[    0.374731] ACPI: ACPI bus type pnp unregistered
[    0.382309] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.382385] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.382466] pci 0000:00:1c.0:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.382547] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.382660] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.382739] pci 0000:00:1c.1:   bridge window [mem 0xf1c00000-0xf1cfffff]
[    0.382827] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.382902] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.382982] pci 0000:00:1c.2:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.383063] pci 0000:00:1c.2:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.383209] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.383213] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.383217] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.383220] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.383224] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.383228] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.383232] pci_bus 0000:02: resource 1 [mem 0xf1d00000-0xf24fffff]
[    0.383236] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.383240] pci_bus 0000:03: resource 1 [mem 0xf1c00000-0xf1cfffff]
[    0.383244] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.383247] pci_bus 0000:04: resource 1 [mem 0xf1400000-0xf1bfffff]
[    0.383251] pci_bus 0000:04: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.383413] NET: Registered protocol family 2
[    0.383810] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.385322] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.387395] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.387659] TCP: Hash tables configured (established 524288 bind 65536)
[    0.387733] TCP: reno registered
[    0.387824] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.387950] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.388232] NET: Registered protocol family 1
[    0.388324] pci 0000:00:02.0: Boot video device
[    0.388340] pci 0000:00:14.0: power state changed by ACPI to D0
[    0.388418] pci 0000:00:14.0: power state changed by ACPI to D0
[    0.388595] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.388672] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.388815] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.388893] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.389148] PCI: CLS 64 bytes, default 64
[    0.389217] Unpacking initramfs...
[    0.544482] Freeing initrd memory: 4388k freed
[    0.545529] DMAR: No ATSR found
[    0.545668] IOMMU 0 0xfed90000: using Queued invalidation
[    0.545744] IOMMU 1 0xfed91000: using Queued invalidation
[    0.545820] IOMMU: Setting RMRR:
[    0.545910] IOMMU: Setting identity map for device 0000:00:02.0 [0xdb800000 - 0xdf9fffff]
[    0.546779] IOMMU: Setting identity map for device 0000:00:1d.0 [0xd9ff0000 - 0xda006fff]
[    0.546919] IOMMU: Setting identity map for device 0000:00:1a.0 [0xd9ff0000 - 0xda006fff]
[    0.547050] IOMMU: Setting identity map for device 0000:00:14.0 [0xd9ff0000 - 0xda006fff]
[    0.547168] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.547256] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    0.547882] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.552294] audit: initializing netlink socket (disabled)
[    0.552384] type=2000 audit(1343731153.444:1): initialized
[    0.579921] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.581272] VFS: Disk quotas dquot_6.5.2
[    0.581386] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.581584] msgmni has been set to 15579
[    0.582180] alg: No test for stdrng (krng)
[    0.582308] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.582437] io scheduler noop registered
[    0.582507] io scheduler deadline registered
[    0.582626] io scheduler cfq registered (default)
[    0.583472] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    0.583543] crc32: self tests passed, processed 225944 bytes in 374140 nsec
[    0.583995] crc32c: CRC_LE_BITS = 64
[    0.584063] crc32c: self tests passed, processed 225944 bytes in 187664 nsec
[    0.584608] intel_idle: does not run on family 6 model 58
[    0.584652] GHES: HEST is not enabled!
[    0.584788] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.605670] 0000:00:16.3: ttyS0 at I/O 0x50b0 (irq = 19) is a 16550A
[    0.606154] Linux agpgart interface v0.103
[    0.606375] agpgart-intel 0000:00:00.0: Intel Ivybridge Chipset
[    0.606597] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.608982] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.609263] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.609516] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.611353] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.611470] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.611706] mousedev: PS/2 mouse device common for all mice
[    0.611848] rtc_cmos 00:07: RTC can wake from S4
[    0.612091] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.612215] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.612315] cpuidle: using governor ladder
[    0.612386] cpuidle: using governor menu
[    0.612638] TCP: cubic registered
[    0.612870] NET: Registered protocol family 10
[    0.613044] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.613566] Mobile IPv6
[    0.613633] NET: Registered protocol family 17
[    0.613707] Registering the dns_resolver key type
[    0.614027] PM: Checking hibernation image partition /dev/sdb3
[    0.619849] PM: Hibernation image not present or could not be loaded.
[    0.619878] registered taskstats version 1
[    0.627489] rtc_cmos 00:07: setting system clock to 2012-07-31 10:39:14 UTC (1343731154)
[    0.627699] Initializing network drop monitor service
[    0.655929] Freeing unused kernel memory: 556k freed
[    0.656102] Write protecting the kernel read-only data: 6144k
[    0.659542] Freeing unused kernel memory: 580k freed
[    0.663482] Freeing unused kernel memory: 672k freed
[    0.736784] SCSI subsystem initialized
[    0.741237] thermal LNXTHERM:00: registered as thermal_zone0
[    0.741322] ACPI: Thermal Zone [THM0] (48 C)
[    0.741630] libata version 3.00 loaded.
[    0.742731] ahci 0000:00:1f.2: version 3.0
[    0.742827] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    0.742878] ahci: SSS flag set, parallel bus scan disabled
[    0.757732] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
[    0.757842] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pio slum part ems sxs apst 
[    0.757952] ahci 0000:00:1f.2: setting latency timer to 64
[    0.772415] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.776804] scsi0 : ahci
[    0.777439] scsi1 : ahci
[    0.777775] scsi2 : ahci
[    0.778285] scsi3 : ahci
[    0.778505] scsi4 : ahci
[    0.778842] scsi5 : ahci
[    0.779996] ata1: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538100 irq 42
[    0.780103] ata2: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538180 irq 42
[    0.780204] ata3: DUMMY
[    0.780271] ata4: DUMMY
[    0.784437] ata5: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538300 irq 42
[    0.784530] ata6: DUMMY
[    1.100747] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.111392] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.111400] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.118499] ata1.00: ATA-9: SAMSUNG SSD 830 Series, CXM03B1Q, max UDMA/133
[    1.118576] ata1.00: 1000215216 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.137133] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.137139] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.148146] ata1.00: configured for UDMA/133
[    1.148407] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD 830  CXM0 PQ: 0 ANSI: 5
[    1.467802] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.469310] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.469317] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.470509] ata2.00: ATA-8: Hitachi HTS541010A9E680, JA0OA480, max UDMA/133
[    1.470585] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.502882] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.502888] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.504115] ata2.00: configured for UDMA/133
[    1.504335] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HTS54101 JA0O PQ: 0 ANSI: 5
[    1.547589] Refined TSC clocksource calibration: 2893.427 MHz.
[    1.547666] Switching to clocksource tsc
[    1.822883] ata5: SATA link down (SStatus 0 SControl 300)
[    1.829620] sd 0:0:0:0: [sda] 1000215216 512-byte logical blocks: (512 GB/476 GiB)
[    1.829668] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.829673] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.829793] sd 1:0:0:0: [sdb] Write Protect is off
[    1.829799] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.829846] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.830246] sd 0:0:0:0: [sda] Write Protect is off
[    1.830321] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.830370] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.847630]  sda: sda1 sda2 sda3 sda4
[    1.848381] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.886298]  sdb: sdb1 sdb2 sdb3 sdb4
[    1.886963] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.633302] xor: automatically using best checksumming function: generic_sse
[    2.652747]    generic_sse:  4971.000 MB/sec
[    2.652825] xor: using function: generic_sse (4971.000 MB/sec)
[    2.655122] async_tx: api initialized (async)
[    2.724586] raid6: int64x1   1394 MB/s
[    2.792410] raid6: int64x2   1301 MB/s
[    2.860244] raid6: int64x4   1192 MB/s
[    2.928061] raid6: int64x8    992 MB/s
[    2.995877] raid6: sse2x1    3210 MB/s
[    3.063691] raid6: sse2x2    4024 MB/s
[    3.131523] raid6: sse2x4    4553 MB/s
[    3.131592] raid6: using algorithm sse2x4 (4553 MB/s)
[    3.140527] device-mapper: uevent: version 1.0.3
[    3.140722] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    3.164093] Btrfs loaded
[    3.182303] md: linear personality registered for level -1
[    3.184560] md: multipath personality registered for level -4
[    3.186717] md: raid0 personality registered for level 0
[    3.189181] md: raid1 personality registered for level 1
[    3.191941] md: raid6 personality registered for level 6
[    3.192021] md: raid5 personality registered for level 5
[    3.192099] md: raid4 personality registered for level 4
[    3.198496] md: raid10 personality registered for level 10
[    3.202864] mdadm: sending ioctl 800c0910 to a partition!
[    3.202954] mdadm: sending ioctl 800c0910 to a partition!
[    3.203035] mdadm: sending ioctl 1261 to a partition!
[    3.203108] mdadm: sending ioctl 1261 to a partition!
[    3.213666] mdadm: sending ioctl 1261 to a partition!
[    3.213741] mdadm: sending ioctl 1261 to a partition!
[    3.220447] mdadm: sending ioctl 1261 to a partition!
[    3.220517] mdadm: sending ioctl 1261 to a partition!
[    3.230688] mdadm: sending ioctl 1261 to a partition!
[    3.230761] mdadm: sending ioctl 1261 to a partition!
[   20.870770] device label btrfs_pool2 devid 1 transid 11425 /dev/dm-0
[   20.873807] PM: Starting manual resume from disk
[   20.873882] PM: Hibernation image partition 8:19 present
[   20.873885] PM: Looking for hibernation image.
[   20.874038] PM: Image not found (code -22)
[   20.874044] PM: Hibernation image not present or could not be loaded.
[   20.878879] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
[   20.878888] PM: Marking nosave pages: [mem 0x20000000-0x201fffff]
[   20.878905] PM: Marking nosave pages: [mem 0x40004000-0x40004fff]
[   20.878908] PM: Marking nosave pages: [mem 0xd0380000-0xffffffff]
[   20.881133] PM: Basic memory bitmaps created
[   20.950518] PM: Basic memory bitmaps freed
[   20.954623] device label btrfs_pool2 devid 1 transid 11425 /dev/mapper/cryptroot
[   20.955168] btrfs: disk space caching is enabled
[   26.043834] btrfs: disk space caching is enabled
[   26.236611] btrfs: unlinked 9 orphans
[   26.236683] btrfs: truncated 1 orphans
[   27.964396] btrfs: disk space caching is enabled
[   31.438601] cfg80211: Calling CRDA to update world regulatory domain
[   31.600191] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[   31.600488] ACPI: Lid Switch [LID]
[   31.600668] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[   31.600767] ACPI: Sleep Button [SLPB]
[   31.600935] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   31.601028] ACPI: Power Button [PWRF]
[   31.681859] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x12
[   31.912235] ACPI: Requesting acpi_cpufreq
[   31.913963] Monitor-Mwait will be used to enter C-1 state
[   31.914013] Monitor-Mwait will be used to enter C-2 state
[   31.914203] Monitor-Mwait will be used to enter C-3 state
[   31.914230] ACPI: acpi_idle registered with cpuidle
[   31.987659] usbcore: registered new interface driver usbfs
[   31.987791] usbcore: registered new interface driver hub
[   31.988049] usbcore: registered new device driver usb
[   32.004867] Non-volatile memory driver v1.3
[   32.012760] iTCO_vendor_support: vendor-support=0
[   32.018325] wmi: Mapper loaded
[   32.123044] ACPI: Battery Slot [BAT0] (battery present)
[   32.195758] mei: module is from the staging directory, the quality is unknown, you have been warned.
[   32.196306] mei 0000:00:16.0: setting latency timer to 64
[   32.196421] mei 0000:00:16.0: irq 43 for MSI/MSI-X
[   32.209259] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[   32.209345] Copyright(c) 2003-2012 Intel Corporation
[   32.209575] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[   32.209650] iwlwifi 0000:03:00.0: pci_resource_base = ffffc900057ac000
[   32.209725] iwlwifi 0000:03:00.0: HW Revision ID = 0x3E
[   32.209911] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
[   32.229239] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   32.229314] thinkpad_acpi: http://ibm-acpi.sf.net/
[   32.229379] thinkpad_acpi: ThinkPad BIOS G4ET35WW (1.10 ), EC unknown
[   32.229451] thinkpad_acpi: Lenovo ThinkPad T530, model 2429A78
[   32.230284] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   32.230561] thinkpad_acpi: radio switch found; radios are enabled
[   32.233016] thinkpad_acpi: asked for hotkey mask 0x03bc7fff, but firmware forced it to 0x03bc7ffb
[   32.234141] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   32.234703] Registered led device: tpacpi::thinklight
[   32.234788] Registered led device: tpacpi::power
[   32.234836] Registered led device: tpacpi::standby
[   32.235420] Registered led device: tpacpi::thinkvantage
[   32.235617] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   32.235895] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   32.238083] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input4
[   32.378760] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[   32.379013] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[   32.379138] iTCO_wdt: cannot register miscdev on minor=130 (err=-16)
[   32.379253] iTCO_wdt: probe of iTCO_wdt failed with error -16
[   32.512745] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[   32.512831] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   32.512985] e1000e 0000:00:19.0: setting latency timer to 64
[   32.513133] e1000e 0000:00:19.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   32.513299] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   32.523387] sdhci: Secure Digital Host Controller Interface driver
[   32.523472] sdhci: Copyright(c) Pierre Ossman
[   32.544006] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   32.586210] sdhci-pci 0000:02:00.0: SDHCI controller found [1180:e823] (rev 4)
[   32.586541] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[   32.586842] mmc0: no vmmc regulator found
[   32.587129] Registered led device: mmc0::
[   32.588345] mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
[   32.716091] ACPI: AC Adapter [AC] (off-line)
[   32.725824] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x12
[   32.730099] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x12
[   32.735007] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x12
[   32.744108] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   32.751452] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   32.755068] [drm] Initialized drm 1.1.0 20060810
[   32.765178] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) f0:de:f1:f6:03:80
[   32.765274] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   32.765402] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[   32.765518] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[   32.765617] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[   32.765792] xhci_hcd 0000:00:14.0: setting latency timer to 64
[   32.765802] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   32.765930] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[   32.766174] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[   32.766187] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf2520000
[   32.766339] xhci_hcd 0000:00:14.0: irq 46 for MSI/MSI-X
[   32.766425] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   32.766502] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   32.766592] usb usb1: Product: xHCI Host Controller
[   32.766664] usb usb1: Manufacturer: Linux 3.4.4-amd64-preempt-noide-20120410 xhci_hcd
[   32.766767] usb usb1: SerialNumber: 0000:00:14.0
[   32.767003] xHCI xhci_add_endpoint called for root hub
[   32.767009] xHCI xhci_check_bandwidth called for root hub
[   32.767061] hub 1-0:1.0: USB hub found
[   32.767140] hub 1-0:1.0: 4 ports detected
[   32.767318] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   32.767397] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[   32.767540] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[   32.767618] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   32.767713] usb usb2: Product: xHCI Host Controller
[   32.767787] usb usb2: Manufacturer: Linux 3.4.4-amd64-preempt-noide-20120410 xhci_hcd
[   32.767879] usb usb2: SerialNumber: 0000:00:14.0
[   32.768123] xHCI xhci_add_endpoint called for root hub
[   32.768129] xHCI xhci_check_bandwidth called for root hub
[   32.768198] hub 2-0:1.0: USB hub found
[   32.768280] hub 2-0:1.0: 4 ports detected
[   32.779586] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   32.779686] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   32.779843] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[   32.779852] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[   32.779942] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   32.780101] ehci_hcd 0000:00:1a.0: debug port 2
[   32.784065] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[   32.784081] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf253a000
[   32.795431] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   32.795544] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   32.795621] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   32.795712] usb usb3: Product: EHCI Host Controller
[   32.795784] usb usb3: Manufacturer: Linux 3.4.4-amd64-preempt-noide-20120410 ehci_hcd
[   32.795874] usb usb3: SerialNumber: 0000:00:1a.0
[   32.796357] hub 3-0:1.0: USB hub found
[   32.796436] hub 3-0:1.0: 3 ports detected
[   32.796679] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   32.796767] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   32.796893] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[   32.796900] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[   32.796992] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[   32.797147] ehci_hcd 0000:00:1d.0: debug port 2
[   32.801115] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[   32.801154] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf2539000
[   32.811418] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   32.811538] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[   32.811644] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   32.811947] usb usb4: Product: EHCI Host Controller
[   32.812107] usb usb4: Manufacturer: Linux 3.4.4-amd64-preempt-noide-20120410 ehci_hcd
[   32.812199] usb usb4: SerialNumber: 0000:00:1d.0
[   32.812486] hub 4-0:1.0: USB hub found
[   32.812561] hub 4-0:1.0: 3 ports detected
[   32.932432] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   32.946152] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input6
[   33.099612] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   33.106664] usb 3-1: new high-speed USB device number 2 using ehci_hcd
[   33.239083] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
[   33.239142] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   33.239555] hub 3-1:1.0: USB hub found
[   33.239803] hub 3-1:1.0: 6 ports detected
[   33.350113] usb 4-1: new high-speed USB device number 2 using ehci_hcd
[   33.479182] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1 build 25532
[   33.479349] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   33.479463] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   33.479520] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   33.479577] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[   33.479634] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
[   33.479689] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
[   33.479817] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   33.482029] usb 4-1: New USB device found, idVendor=8087, idProduct=0024
[   33.482104] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   33.482435] hub 4-1:1.0: USB hub found
[   33.482651] hub 4-1:1.0: 8 ports detected
[   33.487895] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[   33.491432] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   33.492307] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   33.496890] iwlwifi 0000:03:00.0: device EEPROM VER=0x43a, CALIB=0x6
[   33.496892] iwlwifi 0000:03:00.0: Device SKU: 0x1F0
[   33.496894] iwlwifi 0000:03:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
[   33.496912] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   33.496987] Registered led device: phy0-led
[   33.497009] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   33.500603] i915 0000:00:02.0: power state changed by ACPI to D0
[   33.500667] i915 0000:00:02.0: power state changed by ACPI to D0
[   33.500915] i915 0000:00:02.0: setting latency timer to 64
[   33.527264] mtrr: no more MTRRs available
[   33.527321] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   33.527503] i915 0000:00:02.0: irq 48 for MSI/MSI-X
[   33.527510] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   33.527568] [drm] Driver supports precise vblank timestamp query.
[   33.527945] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   33.553678] usb 3-1.4: new full-speed USB device number 3 using ehci_hcd
[   33.650312] usb 3-1.4: New USB device found, idVendor=0a5c, idProduct=21e6
[   33.650380] usb 3-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   33.650457] usb 3-1.4: Product: BCM20702A0
[   33.650517] usb 3-1.4: Manufacturer: Broadcom Corp
[   33.650577] usb 3-1.4: SerialNumber: C01885DB4409
[   33.664033] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   33.721425] usb 3-1.6: new high-speed USB device number 4 using ehci_hcd
[   33.821862] usb 3-1.6: New USB device found, idVendor=04f2, idProduct=b2ea
[   33.821921] usb 3-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   33.821988] usb 3-1.6: Product: Integrated Camera
[   33.822040] usb 3-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[   33.909802] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   33.909806] cfg80211: World regulatory domain updated:
[   33.909870] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   33.909948] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   33.910024] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   33.910100] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   33.910175] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   33.910251] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   33.955613] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   34.248153] fbcon: inteldrmfb (fb0) is primary device
[   34.462786] Console: switching to colour frame buffer device 240x67
[   34.467701] fb0: inteldrmfb frame buffer device
[   34.467702] drm: registered panic notifier
[   34.469107] acpi device:01: registered as cooling_device4
[   34.469218] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10
[   34.469290] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   34.469353] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   34.586839] Linux media interface: v0.10
[   34.647324] Bluetooth: Core ver 2.16
[   34.648953] NET: Registered protocol family 31
[   34.650514] Bluetooth: HCI device and connection manager initialized
[   34.652040] Bluetooth: HCI socket layer initialized
[   34.653539] Bluetooth: L2CAP socket layer initialized
[   34.655074] Bluetooth: SCO socket layer initialized
[   34.726231] usbcore: registered new interface driver btusb
[   34.851806] Linux video capture interface: v2.00
[   34.963782] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b2ea)
[   34.969914] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.6/3-1.6:1.0/input/input11
[   34.972047] usbcore: registered new interface driver uvcvideo
[   34.973922] USB Video Class driver (1.1.1)
[   36.235995] Adding 9130124k swap on /dev/sdb3.  Priority:-1 extents:1 across:9130124k 
[   36.244714] btrfs: use lzo compression
[   36.248450] btrfs: not using ssd allocation scheme
[   36.248455] btrfs: disk space caching is enabled
[   36.377695] scsi_verify_blk_ioctl: 114 callbacks suppressed
[   36.379470] mdadm: sending ioctl 800c0910 to a partition!
[   36.380914] mdadm: sending ioctl 800c0910 to a partition!
[   36.382345] mdadm: sending ioctl 1261 to a partition!
[   36.383741] mdadm: sending ioctl 1261 to a partition!
[   36.392116] mdadm: sending ioctl 1261 to a partition!
[   36.393534] mdadm: sending ioctl 1261 to a partition!
[   36.405362] mdadm: sending ioctl 1261 to a partition!
[   36.406731] mdadm: sending ioctl 1261 to a partition!
[   36.414905] mdadm: sending ioctl 1261 to a partition!
[   36.416218] mdadm: sending ioctl 1261 to a partition!
[   36.472494] loop: module loaded
[   36.533348] thinkpad_ec: disagrees about version of symbol module_layout
[   36.536815] thinkpad_ec: disagrees about version of symbol module_layout
[   36.775141] lp: driver loaded but no devices found
[   45.896217] scsi_verify_blk_ioctl: 86 callbacks suppressed
[   45.899014] dd: sending ioctl 80306d02 to a partition!
[   45.900135] dd: sending ioctl 80306d02 to a partition!
[   45.907069] usbfs: unrecognised mount option "default" or missing value
[   45.909892] usbfs: mount parameter error.
[   46.060143] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[   46.063849] device label btrfs_pool2 devid 1 transid 11431 /dev/mapper/cryptroot
[   47.695187] RPC: Registered named UNIX socket transport module.
[   47.698356] RPC: Registered udp transport module.
[   47.701587] RPC: Registered tcp transport module.
[   47.702906] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   47.754729] FS-Cache: Loaded
[   47.772165] NFS: Registering the id_resolver key type
[   47.773456] FS-Cache: Netfs 'nfs' registered for caching
[   47.794880] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   48.044507] fuse init (API version 7.18)
[   48.915988] auditd (2486): /proc/2486/oom_adj is deprecated, please use /proc/2486/oom_score_adj instead.
[   49.128965] thinkpad_ec: disagrees about version of symbol module_layout
[   49.292167] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   49.315944] NFSD: starting 90-second grace period
[   49.581446] vboxdrv: disagrees about version of symbol module_layout
[   49.736789] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input12
[   56.621851] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   56.621855] Bluetooth: BNEP filters: protocol multicast
[   56.792672] Bluetooth: RFCOMM TTY layer initialized
[   56.792678] Bluetooth: RFCOMM socket layer initialized
[   56.792680] Bluetooth: RFCOMM ver 1.11
[   57.597274] ppdev: user-space parallel port driver
[   69.673261] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   69.776647] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   69.777182] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   69.779137] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   69.786644] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[   70.040760] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   70.047568] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[   70.150777] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   71.915743] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy0
[   74.031045] cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on phy0
[   77.685248] wlan0: authenticate with 2c:b0:5d:3c:7d:f1
[   77.716712] wlan0: send auth to 2c:b0:5d:3c:7d:f1 (try 1/3)
[   77.919663] wlan0: send auth to 2c:b0:5d:3c:7d:f1 (try 2/3)
[   77.920334] wlan0: authenticated
[   77.923639] wlan0: associate with 2c:b0:5d:3c:7d:f1 (try 1/3)
[   77.924470] wlan0: RX AssocResp from 2c:b0:5d:3c:7d:f1 (capab=0x11 status=0 aid=1)
[   77.924477] wlan0: associated
[   77.930392] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   88.723871] wlan0: no IPv6 routers present
[   90.220148] btrfs: use lzo compression
[   90.220157] btrfs: not using ssd allocation scheme
[   90.220164] btrfs: disk space caching is enabled
[   90.231528] EXT4-fs (sdb2): re-mounted. Opts: stripe=4,data=ordered,commit=600
[   90.396650] btrfs: use lzo compression
[   90.396659] btrfs: not using ssd allocation scheme
[   90.396666] btrfs: disk space caching is enabled
[   90.443518] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3
[   90.459475] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[   94.732456] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[   99.219571] tun: Universal TUN/TAP device driver, 1.6
[   99.219581] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   99.219945] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-tun instead.
[   99.225243] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-tun instead.
[   99.230935] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-tun instead.
[   99.238116] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-tun instead.
[  204.738101] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  204.753588] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  204.753650] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  204.753655] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  204.753667] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  212.437838] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  260.072682] Monitor-Mwait will be used to enter C-2 state
[  260.079613] thinkpad_acpi: EC reports that Thermal Table has changed
[  260.266900] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  269.203274] btrfs: use lzo compression
[  269.203277] btrfs: not using ssd allocation scheme
[  269.203279] btrfs: disk space caching is enabled
[  269.225550] EXT4-fs (sdb2): re-mounted. Opts: stripe=4,data=ordered,commit=0
[  269.547043] btrfs: use lzo compression
[  269.547052] btrfs: not using ssd allocation scheme
[  269.547058] btrfs: disk space caching is enabled
[  269.568436] NMI watchdog: enabled, takes one hw-pmu counter.
[  269.568567] NMI watchdog: enabled, takes one hw-pmu counter.
[  269.568621] NMI watchdog: enabled, takes one hw-pmu counter.
[  269.568668] NMI watchdog: enabled, takes one hw-pmu counter.
[  269.630078] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  269.642689] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  269.642785] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  269.642793] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  269.642811] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  269.834283] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  269.850191] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  269.850493] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  269.850501] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  269.850518] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  269.930195] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[  269.945908] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[  269.946007] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[  269.946014] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[  269.946028] xhci_hcd 0000:00:14.0: setting latency timer to 64
[  620.736114] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  623.805795] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[  623.807035] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  624.989189] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-tun instead.
[  624.991523] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-tun instead.
[  624.994138] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-tun instead.
[  624.996681] Loading kernel module for a network device with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-tun instead.
[  634.456683] eth0: no IPv6 routers present

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
par error:
Word too long: decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
