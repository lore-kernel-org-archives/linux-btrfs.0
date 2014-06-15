Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:35769 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaFOK1L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 06:27:11 -0400
Received: by mail-yk0-f169.google.com with SMTP id q200so3340238ykb.14
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 03:27:11 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 15 Jun 2014 12:27:10 +0200
Message-ID: <CAMdWP3HZPWTwAO+A9r+cX6rORphFVCt5WDrXk9KKmJ6w+NPiQw@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/ctree.h:2417
From: Tobias Hunger <tobias.hunger@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I keep running into this bug on a 2.14.3 kernel from arch linux. It
seems to be triggered by docker removing a machine. Docker is using
the btrfs backend here, so doing so involves some btrfs subvolume
magic (or so I guess:-).

Jun 14 22:18:05 ron kernel: ------------[ cut here ]------------
Jun 14 22:18:05 ron kernel: kernel BUG at fs/btrfs/ctree.h:2417!
Jun 14 22:18:06 ron kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Jun 14 22:18:06 ron kernel: Modules linked in: veth xt_nat xt_addrtype
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_tcpudp xt_LOG
xt_limit xt_physdev ip6t_REJECT nf_conntrack_ipv6 ipt_REJECT
nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 bridge xt_conntrack
stp nf_conntrack llc iptable_filter ip6table_filter ip_tables
ip6_tables x_tables nls_iso8859_1 nls_cp437 vfat fat sha256_ssse3
sha256_generic kvm_amd ppdev kvm radeon snd_hda_codec_hdmi microcode
psmouse snd_hda_intel joydev serio_raw mousedev evdev pcspkr
snd_hda_codec mac_hid k10temp i2c_piix4 r8169 ttm drm_kms_helper
snd_hwdep snd_pcm drm mii snd_timer snd hwmon i2c_algo_bit parport_pc
soundcore i2c_core acpi_cpufreq tpm_infineon parport tpm_tis shpchp
tpm processor button btrfs raid6_pq xor dm_crypt hid_lenovo_tpkbd
led_class usbhid hid dm_mod sd_mod
Jun 14 22:18:06 ron kernel:  crc_t10dif atkbd libps2 crct10dif_pclmul
crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
ehci_pci ohci_pci ohci_hcd ehci_hcd xhci_hcd ahci libahci libata
aacraid usbcore usb_common scsi_mod i8042 serio
Jun 14 22:18:06 ron kernel: CPU: 3 PID: 463 Comm: btrfs-cleaner Not
tainted 3.14.3-2-ARCH #1
Jun 14 22:18:06 ron kernel: Hardware name: Gigabyte Technology Co.,
Ltd. To be filled by O.E.M./F2A75M-D3H, BIOS F5 03/12/2013
Jun 14 22:18:06 ron kernel: task: ffff880424df6bf0 ti:
ffff880426b9c000 task.ti: ffff880426b9c000
Jun 14 22:18:06 ron kernel: RIP: 0010:[<ffffffffa0555b37>]
[<ffffffffa0555b37>] lookup_inline_extent_backref+0x427/0x5f0 [btrfs]
Jun 14 22:18:06 ron kernel: RSP: 0018:ffff880426b9da88  EFLAGS: 00010297
Jun 14 22:18:06 ron kernel: RAX: 0000000000000000 RBX:
ffff8803dd7d0dc0 RCX: ffff880426b9da30
Jun 14 22:18:06 ron kernel: RDX: ffff880000000000 RSI:
0000000000003fe3 RDI: 0000000000000000
Jun 14 22:18:06 ron kernel: RBP: ffff880426b9db28 R08:
0000000000004000 R09: ffff880426b9da40
Jun 14 22:18:06 ron kernel: R10: 0000000000000000 R11:
0000000000000003 R12: 0000000000003fe3
Jun 14 22:18:06 ron kernel: R13: 00000000000000b2 R14:
0000000000000000 R15: 0000000000004000
Jun 14 22:18:06 ron kernel: FS:  00007f7b38b4f700(0000)
GS:ffff88043ed80000(0000) knlGS:0000000000000000
Jun 14 22:18:06 ron kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 14 22:18:06 ron kernel: CR2: 00007fea76104000 CR3:
00000003fafcb000 CR4: 00000000000407e0
Jun 14 22:18:06 ron kernel: Stack:
Jun 14 22:18:06 ron kernel:  ffff88042468b800 ffff88042380a120
0000000000000035 ffff880426b9dbb0
Jun 14 22:18:06 ron kernel:  0000000000004000 ffff8804000000b2
ffff8803dd7d0dc0 0000000100eff000
Jun 14 22:18:06 ron kernel:  ffffffff00000850 f000880426b9db28
00a80000000100ef ff00000000000800
Jun 14 22:18:06 ron kernel: Call Trace:
Jun 14 22:18:06 ron kernel:  [<ffffffffa054a26a>] ?
btrfs_alloc_path+0x1a/0x20 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa0558a7b>]
__btrfs_free_extent+0x10b/0xa90 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa055db72>]
__btrfs_run_delayed_refs+0x442/0x1270 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffff812bcc3a>] ?
__percpu_counter_add+0x5a/0x90
Jun 14 22:18:06 ron kernel:  [<ffffffffa05570c6>] ?
add_pinned_bytes+0x46/0x60 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa05628eb>]
btrfs_run_delayed_refs.part.52+0x7b/0x260 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa0562ae7>]
btrfs_run_delayed_refs+0x17/0x20 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa0572ab8>]
btrfs_should_end_transaction+0x58/0x60 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa056108a>]
btrfs_drop_snapshot+0x44a/0x7e0 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa0574788>]
btrfs_clean_one_deleted_snapshot+0xd8/0x160 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa056a850>]
cleaner_kthread+0x150/0x1a0 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffffa056a700>] ?
free_fs_root+0xd0/0xd0 [btrfs]
Jun 14 22:18:06 ron kernel:  [<ffffffff8108f2ea>] kthread+0xea/0x100
Jun 14 22:18:06 ron kernel:  [<ffffffff8108f200>] ?
kthread_create_on_node+0x1a0/0x1a0
Jun 14 22:18:06 ron kernel:  [<ffffffff8151787c>] ret_from_fork+0x7c/0xb0
Jun 14 22:18:06 ron kernel:  [<ffffffff8108f200>] ?
kthread_create_on_node+0x1a0/0x1a0
Jun 14 22:18:06 ron kernel: Code: 48 39 45 10 74 74 0f 87 28 01 00 00
41 81 fe b6 00 00 00 74 1f 41 81 fe b0 00 00 00 74 16 41 81 fe b8 00
00 00 0f 84 69 01 00 00 <0f> 0b 0f 1f 80 00 00 00 00 b8 09 00 00 00 49
01 c4 4d 39 e7 0f
Jun 14 22:18:06 ron kernel: RIP  [<ffffffffa0555b37>]
lookup_inline_extent_backref+0x427/0x5f0 [btrfs]
Jun 14 22:18:06 ron kernel:  RSP <ffff880426b9da88>
Jun 14 22:18:06 ron kernel: ---[ end trace 85afc2ecac52e6f6 ]---
Jun 14 22:18:06 ron kernel: note: btrfs-cleaner[463] exited with preempt_count 2
Jun 14 22:18:36 ron kernel: BUG: soft lockup - CPU#2 stuck for 22s!
[btrfs-delalloc-:898]
Jun 14 22:18:36 ron kernel: Modules linked in: veth xt_nat xt_addrtype
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_tcpudp xt_LOG
xt_limit xt_physdev ip6t_REJECT nf_conntrack_ipv6 ipt_REJECT
nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 bridge xt_conntrack
stp nf_conntrack llc iptable_filter ip6table_filter ip_tables
ip6_tables x_tables nls_iso8859_1 nls_cp437 vfat fat sha256_ssse3
sha256_generic kvm_amd ppdev kvm radeon snd_hda_codec_hdmi microcode
psmouse snd_hda_intel joydev serio_raw mousedev evdev pcspkr
snd_hda_codec mac_hid k10temp i2c_piix4 r8169 ttm drm_kms_helper
snd_hwdep snd_pcm drm mii snd_timer snd hwmon i2c_algo_bit parport_pc
soundcore i2c_core acpi_cpufreq tpm_infineon parport tpm_tis shpchp
tpm processor button btrfs raid6_pq xor dm_crypt hid_lenovo_tpkbd
led_class usbhid hid dm_mod sd_mod
Jun 14 22:18:36 ron kernel:  crc_t10dif atkbd libps2 crct10dif_pclmul
crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
ehci_pci ohci_pci ohci_hcd ehci_hcd xhci_hcd ahci libahci libata
aacraid usbcore usb_common scsi_mod i8042 serio
Jun 14 22:18:36 ron kernel: CPU: 2 PID: 898 Comm: btrfs-delalloc-
Tainted: G      D      3.14.3-2-ARCH #1
Jun 14 22:18:36 ron kernel: Hardware name: Gigabyte Technology Co.,
Ltd. To be filled by O.E.M./F2A75M-D3H, BIOS F5 03/12/2013
Jun 14 22:18:36 ron kernel: task: ffff880424df2740 ti:
ffff8803defe0000 task.ti: ffff8803defe0000
Jun 14 22:18:36 ron kernel: BUG: soft lockup - CPU#3 stuck for 22s!
[btrfs-endio-wri:908]
Jun 14 22:18:36 ron kernel: Modules linked in: veth xt_nat xt_addrtype
ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_tcpudp xt_LOG
xt_limit xt_physdev ip6t_REJECT nf_conntrack_ipv6 ipt_REJECT
nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 bridge xt_conntrack
stp nf_conntrack llc iptable_filter ip6table_filter ip_tables
ip6_tables x_tables nls_iso8859_1 nls_cp437 vfat fat sha256_ssse3
sha256_generic kvm_amd ppdev kvm radeon snd_hda_codec_hdmi microcode
psmouse snd_hda_intel joydev serio_raw mousedev evdev pcspkr
snd_hda_codec mac_hid k10temp i2c_piix4 r8169 ttm drm_kms_helper
snd_hwdep snd_pcm drm mii snd_timer snd hwmon i2c_algo_bit parport_pc
soundcore i2c_core acpi_cpufreq tpm_infineon parport tpm_tis shpchp
tpm processor button btrfs raid6_pq xor dm_crypt hid_lenovo_tpkbd
led_class usbhid hid dm_mod sd_mod
Jun 14 22:18:36 ron kernel:  crc_t10dif atkbd libps2 crct10dif_pclmul
crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd
ehci_pci ohci_pci ohci_hcd ehci_hcd xhci_hcd ahci libahci libata
aacraid usbcore usb_common scsi_mod i8042 serio
Jun 14 22:18:36 ron kernel: CPU: 3 PID: 908 Comm: btrfs-endio-wri
Tainted: G      D      3.14.3-2-ARCH #1
Jun 14 22:18:36 ron kernel: Hardware name: Gigabyte Technology Co.,
Ltd. To be filled by O.E.M./F2A75M-D3H, BIOS F5 03/12/2013
Jun 14 22:18:36 ron kernel: task: ffff880424df5850 ti:
ffff8803dd338000 task.ti: ffff8803dd338000
Jun 14 22:18:36 ron kernel: RIP: 0010:[<ffffffff812a51eb>]
[<ffffffff812a51eb>] __write_lock_failed+0xb/0x20
Jun 14 22:18:36 ron kernel: RSP: 0018:ffff8803dd339930  EFLAGS: 00000287
Jun 14 22:18:36 ron kernel: RAX: 0000000000000000 RBX:
0000000000004000 RCX: 0000000000000001
Jun 14 22:18:36 ron kernel: RDX: 0000000000000000 RSI:
00000003dee52000 RDI: ffff880401f44e30
Jun 14 22:18:36 ron kernel: RBP: ffff8803dd339930 R08:
0000000000000001 R09: ffff880401f44dc0
Jun 14 22:18:36 ron kernel: R10: 0000000000000000 R11:
0000000000000000 R12: ffff8803dd3399c8
Jun 14 22:18:36 ron kernel: R13: 0000000000000086 R14:
ffffffffa056d3b6 R15: ffff8803dd3398b8
Jun 14 22:18:36 ron kernel: FS:  00007f2539d1c740(0000)
GS:ffff88043ed80000(0000) knlGS:0000000000000000
Jun 14 22:18:36 ron kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 14 22:18:36 ron kernel: CR2: 00007fbc8c3112d0 CR3:
00000003ebd44000 CR4: 00000000000407e0
Jun 14 22:18:36 ron kernel: Stack:
Jun 14 22:18:36 ron kernel:  ffff8803dd339940 ffffffff8150eb9f
ffff8803dd339960 ffffffffa05abaae
Jun 14 22:18:36 ron kernel:  ffff88042380a6c0 0000000000000001
ffff8803dd339a00 ffffffffa054f5e0
Jun 14 22:18:36 ron kernel:  ffff880000000000 0000160000000000
ffff88042380a6c8 0000000200000000
Jun 14 22:18:36 ron kernel: Call Trace:
Jun 14 22:18:36 ron kernel:  [<ffffffff8150eb9f>] _raw_write_lock+0x1f/0x30
Jun 14 22:18:36 ron kernel:  [<ffffffffa05abaae>]
btrfs_try_tree_write_lock+0x2e/0x80 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa054f5e0>]
btrfs_search_slot+0x480/0xa10 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05557e6>]
lookup_inline_extent_backref+0xd6/0x5f0 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa054a26a>] ?
btrfs_alloc_path+0x1a/0x20 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa0558a7b>]
__btrfs_free_extent+0x10b/0xa90 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa055db72>]
__btrfs_run_delayed_refs+0x442/0x1270 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa058f657>] ?
merge_state.part.32+0x137/0x140 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05628eb>]
btrfs_run_delayed_refs.part.52+0x7b/0x260 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa0562ae7>]
btrfs_run_delayed_refs+0x17/0x20 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05741a3>]
__btrfs_end_transaction+0x243/0x380 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05742f0>]
btrfs_end_transaction+0x10/0x20 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa057c368>]
btrfs_finish_ordered_io+0x148/0x5d0 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa057ca85>]
finish_ordered_fn+0x15/0x20 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05a362d>]
worker_loop+0x15d/0x5a0 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffff810b3915>] ? __wake_up_common+0x55/0x90
Jun 14 22:18:36 ron kernel:  [<ffffffffa05a34d0>] ?
btrfs_queue_worker+0x310/0x310 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffff8108f2ea>] kthread+0xea/0x100
Jun 14 22:18:36 ron kernel:  [<ffffffff8108f200>] ?
kthread_create_on_node+0x1a0/0x1a0
Jun 14 22:18:36 ron kernel:  [<ffffffff8151787c>] ret_from_fork+0x7c/0xb0
Jun 14 22:18:36 ron kernel:  [<ffffffff8108f200>] ?
kthread_create_on_node+0x1a0/0x1a0
Jun 14 22:18:36 ron kernel: Code: 48 89 01 31 c0 66 66 90 c3 b8 f2 ff
ff ff 66 66 90 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89
e5 f0 81 07 00 00 10 00 <f3> 90 81 3f 00 00 10 00 75 f6 f0 81 2f 00 00
10 00 75 e6 5d c3
Jun 14 22:18:36 ron kernel: RIP: 0010:[<ffffffff812a5209>]
[<ffffffff812a5209>] __read_lock_failed+0x9/0x20
Jun 14 22:18:36 ron kernel: RSP: 0018:ffff8803defe17a8  EFLAGS: 00000297
Jun 14 22:18:36 ron kernel: RAX: ffff8803defe17c8 RBX:
ffff880425d27628 RCX: 0000000000000004
Jun 14 22:18:36 ron kernel: RDX: 0000000000000004 RSI:
0000000000000005 RDI: ffff8803e1056bb0
Jun 14 22:18:36 ron kernel: RBP: ffff8803defe17a8 R08:
00000000ffffffff R09: 0000000000000001
Jun 14 22:18:36 ron kernel: R10: 0000057bddb759f7 R11:
ffffea00108e0a40 R12: ffff880425d27628
Jun 14 22:18:36 ron kernel: R13: 000000080041753f R14:
ffffffff810a991c R15: ffff8803defe1738
Jun 14 22:18:36 ron kernel: FS:  00007f7fb04af700(0000)
GS:ffff88043ed00000(0000) knlGS:0000000000000000
Jun 14 22:18:36 ron kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun 14 22:18:36 ron kernel: CR2: 00007fbc8c01e700 CR3:
0000000425e26000 CR4: 00000000000407e0
Jun 14 22:18:36 ron kernel: Stack:
Jun 14 22:18:36 ron kernel:  ffff8803defe17b8 ffffffff8150eb0b
ffff8803defe1820 ffffffffa05ab94f
Jun 14 22:18:36 ron kernel:  ffffffff8109e12b ffff880425d275c0
ffff8803defe1800 ffffffff8109e159
Jun 14 22:18:36 ron kernel:  ffff880425d275c0 0000000006e050f1
ffff8803e1056b40 ffff88042468b800
Jun 14 22:18:36 ron kernel: Call Trace:
Jun 14 22:18:36 ron kernel:  [<ffffffff8150eb0b>] _raw_read_lock+0x1b/0x20
Jun 14 22:18:36 ron kernel:  [<ffffffffa05ab94f>]
btrfs_tree_read_lock+0x5f/0x120 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffff8109e12b>] ? check_preempt_curr+0x7b/0x90
Jun 14 22:18:36 ron kernel:  [<ffffffff8109e159>] ? ttwu_do_wakeup+0x19/0xf0
Jun 14 22:18:36 ron kernel:  [<ffffffffa054a4fb>]
btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa054f8e9>]
btrfs_search_slot+0x789/0xa10 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffff81086e0e>] ? insert_work+0x6e/0xb0
Jun 14 22:18:36 ron kernel:  [<ffffffffa05557e6>]
lookup_inline_extent_backref+0xd6/0x5f0 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa054a26a>] ?
btrfs_alloc_path+0x1a/0x20 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa0558a7b>]
__btrfs_free_extent+0x10b/0xa90 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa055db72>]
__btrfs_run_delayed_refs+0x442/0x1270 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05512c9>] ?
setup_items_for_insert+0x2e9/0x410 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05539fb>] ?
block_rsv_add_bytes+0x4b/0x60 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05c8807>] ?
btrfs_delayed_update_inode+0x167/0x4f0 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05628eb>]
btrfs_run_delayed_refs.part.52+0x7b/0x260 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa0562ae7>]
btrfs_run_delayed_refs+0x17/0x20 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05741a3>]
__btrfs_end_transaction+0x243/0x380 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05742f0>]
btrfs_end_transaction+0x10/0x20 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa0579e68>]
cow_file_range_inline+0x258/0x310 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa057b8de>]
compress_file_range.constprop.57+0x23e/0x6e0 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa057bdc4>]
async_cow_start+0x44/0x80 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05a362d>]
worker_loop+0x15d/0x5a0 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffffa05a34d0>] ?
btrfs_queue_worker+0x310/0x310 [btrfs]
Jun 14 22:18:36 ron kernel:  [<ffffffff8108f2ea>] kthread+0xea/0x100
Jun 14 22:18:36 ron kernel:  [<ffffffff8108f200>] ?
kthread_create_on_node+0x1a0/0x1a0
Jun 14 22:18:36 ron kernel:  [<ffffffff8151787c>] ret_from_fork+0x7c/0xb0
Jun 14 22:18:36 ron kernel:  [<ffffffff8108f200>] ?
kthread_create_on_node+0x1a0/0x1a0
Jun 14 22:18:36 ron kernel: Code: 90 90 55 48 89 e5 f0 81 07 00 00 10
00 f3 90 81 3f 00 00 10 00 75 f6 f0 81 2f 00 00 10 00 75 e6 5d c3 55
48 89 e5 f0 ff 07 f3 90 <83> 3f 01 78 f9 f0 ff 0f 78 f1 5d c3 90 90 90
90 90 90 90 90 90

Is there anything I can do to help debug this issue?

Best Regards,
Tobias
