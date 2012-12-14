Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49073 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2LNWEJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Dec 2012 17:04:09 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so2732364pad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2012 14:04:08 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 14 Dec 2012 23:04:08 +0100
Message-ID: <CAMQ-g0fNocHwEvbeDAf-HK+Nh4XcQDDD7Mi_ZxDSqv-moFKn5g@mail.gmail.com>
Subject: BUG during log recovery
From: Jan Steffens <jan.steffens@gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After a lockup requiring a hard reset, the btrfs could not be mounted,
throwing the following error:

[   75.969198] device label shine-root devid 1 transid 1204626 /dev/sdb3
[   75.972211] btrfs: disk space caching is enabled
[   80.118478] ------------[ cut here ]------------
[   80.118611] kernel BUG at fs/btrfs/extent-tree.c:6185!
[   80.118737] invalid opcode: 0000 [#1] PREEMPT SMP
[   80.118884] Modules linked in: btrfs crc32c libcrc32c zlib_deflate
act_police sch_ingress cls_u32 cls_fw sch_sfb sch_htb sit tunnel4
pppoe pppox xt_mark iptable_mangle ipt_REJECT iptable_filter
ipt_MASQUERADE ip6table_raw iptable_nat nf_nat_ipv4 xt_sctp
nf_conntrack_pptp nf_conntrack_proto_gre ip6t_REJECT nf_conntrack_ipv4
nf_defrag_ipv4 xt_LOG ppp_generic slhc xt_tcpudp nf_conntrack_ipv6
nf_defrag_ipv6 xt_CT ip6t_rt iptable_raw xt_conntrack ip_tables
ip6table_filter ip6_tables x_tables arc4 rt2800pci rt2800lib
snd_hda_codec_realtek rt2x00pci rt2x00lib eeprom_93cx6 eeepc_laptop
mac80211 sparse_keymap cfg80211 i915 snd_hda_intel rfkill
snd_hda_codec snd_hwdep snd_pcm drm_kms_helper snd_page_alloc drm
crc_ccitt snd_timer snd iTCO_wdt iTCO_vendor_support ums_realtek
intel_agp intel_gtt agpgart r8169
[   80.121214]  pci_hotplug uas lpc_ich i2c_i801 joydev coretemp
soundcore evdev i2c_algo_bit microcode psmouse serio_raw pcspkr
i2c_core mii hid_microsoft button video bridge stp llc tun nf_nat_irc
nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack
acpi_cpufreq mperf processor ext4 crc16 jbd2 mbcache usbhid hid
usb_storage sd_mod ata_generic pata_acpi uhci_hcd ata_piix libata
scsi_mod ehci_hcd usbcore usb_common
[   80.121437] Pid: 694, comm: mount Not tainted 3.7.0-0.1-zen #1
ASUSTeK Computer INC. B202/P5LD2EB-DHS
[   80.121437] EIP: 0060:[<f89d4c72>] EFLAGS: 00010286 CPU: 0
[   80.121437] EIP is at btrfs_alloc_logged_file_extent+0x252/0x260 [btrfs]
[   80.121437] EAX: fffffff5 EBX: 000a9000 ECX: 00000000 EDX: 00000000
[   80.121437] ESI: 00000000 EDI: 00000000 EBP: f403bacc ESP: f403ba68
[   80.121437]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   80.121437] CR0: 8005003b CR2: b7769000 CR3: 32924000 CR4: 000007c0
[   80.121437] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   80.121437] DR6: ffff0ff0 DR7: 00000400
[   80.121437] Process mount (pid: 694, ti=f403a000 task=f3361fe0
task.ti=f403a000)
[   80.121437] Stack:
[   80.121437]  00000000 00000000 f8a063ae f89c0bb0 f89c0bb0 f482a2a0
00000001 f568e800
[   80.121437]  f403ba94 f89c0bb0 f482a2a0 f403bacc f54c4a80 f482a2a0
00000000 f4b42000
[   80.121437]  000a9000 00000000 00000000 f568e800 ff84f000 0000002b
f403bc02 f4b8cb9c
[   80.121437] Call Trace:
[   80.121437]  [<f8a063ae>] ? free_extent_buffer+0x2e/0x80 [btrfs]
[   80.121437]  [<f89c0bb0>] ? btrfs_free_path+0x20/0x30 [btrfs]
[   80.121437]  [<f89c0bb0>] ? btrfs_free_path+0x20/0x30 [btrfs]
[   80.121437]  [<f89c0bb0>] ? btrfs_free_path+0x20/0x30 [btrfs]
[   80.121437]  [<f8a1d37b>] replay_one_extent+0x75b/0x810 [btrfs]
[   80.121437]  [<c02547a1>] ? destroy_inode+0x31/0x50
[   80.121437]  [<c02548ac>] ? evict+0xec/0x170
[   80.121437]  [<f8a1e3a7>] replay_one_buffer+0x2c7/0x3a0 [btrfs]
[   80.121437]  [<f8a1aef9>] walk_down_log_tree+0x209/0x390 [btrfs]
[   80.121437]  [<f8a1b0f4>] walk_log_tree+0x74/0x1c0 [btrfs]
[   80.121437]  [<f8a21405>] btrfs_recover_log_trees+0x1e5/0x370 [btrfs]
[   80.121437]  [<f8a1e0e0>] ? replay_one_dir_item+0xd0/0xd0 [btrfs]
[   80.121437]  [<f89e4897>] open_ctree+0x1407/0x19c0 [btrfs]
[   80.121437]  [<c03010f9>] ? strlcpy+0x39/0x50
[   80.121437]  [<f89bda45>] btrfs_mount+0x775/0x8b0 [btrfs]
[   80.121437]  [<c04e4f7d>] ? mutex_unlock+0xd/0x10
[   80.121437]  [<c020cef4>] ? pcpu_alloc+0x754/0x830
[   80.121437]  [<c02fcaa6>] ? ida_get_new_above+0x196/0x1e0
[   80.121437]  [<c022f6a3>] ? __kmalloc_track_caller+0x73/0x150
[   80.121437]  [<c02415b6>] mount_fs+0x36/0x180
[   80.121437]  [<c020cfdf>] ? __alloc_percpu+0xf/0x20
[   80.121437]  [<c02582ce>] vfs_kern_mount+0x4e/0xe0
[   80.121437]  [<c02586fc>] do_kern_mount+0x3c/0xf0
[   80.121437]  [<c0259f68>] do_mount+0x308/0x730
[   80.121437]  [<c0208429>] ? strndup_user+0x49/0x70
[   80.121437]  [<c025a3fb>] sys_mount+0x6b/0xa0
[   80.121437]  [<c04ed84d>] sysenter_do_call+0x12/0x28
[   80.121437] Code: a5 5d ff ff 85 c0 74 29 8b 5d dc 8b 75 e0 8b 55
ec 8b 4d f0 8b 45 cc 89 1c 24 89 74 24 04 e8 36 fc 04 00 85 c0 0f 84
c2 fe ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 8d 74 26 00 55 89 e5 57 56
53 83
[   80.121437] EIP: [<f89d4c72>]
btrfs_alloc_logged_file_extent+0x252/0x260 [btrfs] SS:ESP
0068:f403ba68
[   80.331077] ---[ end trace 79ea8a12340fc4c5 ]---

Bug affected at least 3.6.10, 3.7.0, i686 and x86_64.

btrfs-zero-log made the FS mountable again.
