Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:40940 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab3BVOqR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 09:46:17 -0500
Received: by mail-da0-f44.google.com with SMTP id z20so393886dae.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 06:46:16 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 22 Feb 2013 09:46:16 -0500
Message-ID: <CAMfhy91avz+euv1vtomHMv87o-f57paUDAgegEXtn9gQ==W3Fg@mail.gmail.com>
Subject: WARNING: at fs/btrfs/extent_io.c:4718 map_private_extent_buffer+0xd4/0xe0
 [btrfs]()
From: Mace Moneta <moneta.mace@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.redhat.com/show_bug.cgi?id=906142

With 3.8 kernels in Fedora 18, using encfs on btrfs I get the
following error.  It can take hours of use before I get a
reoccurrence, and I need to btrfsck, btrfs-zero-log, and/or mount with
'-o recovery' to get the filesystem back after a reboot.  No data
appears to be lost, and a scrub runs to completion with no errors.

[14691.074991] WARNING: at fs/btrfs/extent_io.c:4718
map_private_extent_buffer+0xd4/0xe0 [btrfs]()
[14691.074993] Hardware name: C2SEA
[14691.074995] btrfs bad mapping eb start 645984256 len 4096, wanted 4096 8
[14691.074997] Modules linked in: vfat fat usb_storage fuse rfcomm
bnep nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_conntrack ip6table_filter nf_conntrack ip6_tables
w83627ehf hwmon_vid snd_hda_codec_realtek snd_hda_intel snd_hda_codec
uvcvideo videobuf2_vmalloc snd_hwdep snd_seq snd_seq_device
videobuf2_memops btusb videobuf2_core videodev snd_pcm bluetooth
iTCO_wdt snd_page_alloc media rfkill coretemp snd_timer
iTCO_vendor_support i2c_i801 snd lpc_ich mfd_core soundcore microcode
r8169 mii vhost_net tun macvtap macvlan kvm_intel kvm binfmt_misc
i2c_dev uinput btrfs zlib_deflate libcrc32c ata_generic pata_acpi i915
video firewire_ohci i2c_algo_bit firewire_core drm_kms_helper
pata_it8213 crc_itu_t drm i2c_core
[14691.075070] Pid: 1926, comm: encfs Not tainted
3.8.0-0.rc7.git0.1.fc19.x86_64 #1
[14691.075072] Call Trace:
[14691.075093]  [<ffffffffa01a7c00>] ?
map_private_extent_buffer+0xb0/0xe0 [btrfs]
[14691.075099]  [<ffffffff8105c210>] warn_slowpath_common+0x70/0xa0
[14691.075102]  [<ffffffff8105c28c>] warn_slowpath_fmt+0x4c/0x50
[14691.075121]  [<ffffffffa01a7c24>] map_private_extent_buffer+0xd4/0xe0 [btrfs]
[14691.075139]  [<ffffffffa019da30>] btrfs_set_token_64+0x60/0xf0 [btrfs]
[14691.075159]  [<ffffffffa01be264>]
btrfs_log_changed_extents+0x384/0x600 [btrfs]
[14691.075178]  [<ffffffffa01c05b8>] btrfs_log_inode+0x3b8/0x660 [btrfs]
[14691.075196]  [<ffffffffa01c1519>] btrfs_log_inode_parent+0x169/0x450 [btrfs]
[14691.075216]  [<ffffffffa01c183a>] btrfs_log_dentry_safe+0x3a/0x60 [btrfs]
[14691.075234]  [<ffffffffa0198400>] btrfs_sync_file+0x150/0x1f0 [btrfs]
[14691.075239]  [<ffffffff811c48c6>] do_fsync+0x56/0x80
[14691.075242]  [<ffffffff811c4b50>] sys_fsync+0x10/0x20
[14691.075247]  [<ffffffff8163e419>] system_call_fastpath+0x16/0x1b
[14691.075253] ---[ end trace 0c19c78181b4038d ]---
[14691.075261] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[14691.075311] IP: [<ffffffffa01a7e23>] write_extent_buffer+0xd3/0x150 [btrfs]
[14691.075364] PGD 208a79067 PUD 2089a6067 PMD 0
[14691.075400] Oops: 0000 [#1] SMP
[14691.075425] Modules linked in: vfat fat usb_storage fuse rfcomm
bnep nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_conntrack ip6table_filter nf_conntrack ip6_tables
w83627ehf hwmon_vid snd_hda_codec_realtek snd_hda_intel snd_hda_codec
uvcvideo videobuf2_vmalloc snd_hwdep snd_seq snd_seq_device
videobuf2_memops btusb videobuf2_core videodev snd_pcm bluetooth
iTCO_wdt snd_page_alloc media rfkill coretemp snd_timer
iTCO_vendor_support i2c_i801 snd lpc_ich mfd_core soundcore microcode
r8169 mii vhost_net tun macvtap macvlan kvm_intel kvm binfmt_misc
i2c_dev uinput btrfs zlib_deflate libcrc32c ata_generic pata_acpi i915
video firewire_ohci i2c_algo_bit firewire_core drm_kms_helper
pata_it8213 crc_itu_t drm i2c_core
[14691.076012] CPU 2
[14691.076012] Pid: 1926, comm: encfs Tainted: G        W
3.8.0-0.rc7.git0.1.fc19.x86_64 #1 Supermicro C2SEA/C2SEA
[14691.076012] RIP: 0010:[<ffffffffa01a7e23>]  [<ffffffffa01a7e23>]
write_extent_buffer+0xd3/0x150 [btrfs]
[14691.076012] RSP: 0018:ffff88020b653c20  EFLAGS: 00010202
[14691.076012] RAX: 0000000000000000 RBX: 0000000000000008 RCX: 0000000000000008
[14691.076012] RDX: 0000000000001008 RSI: 0000000026810000 RDI: ffff8801316cf988
[14691.076012] RBP: ffff88020b653c50 R08: 000000000000000a R09: 00000000000003ea
[14691.076012] R10: 0000000000000000 R11: ffff88020b6538d6 R12: ffff88020b653c80
[14691.076012] R13: ffff8801316cf988 R14: 0000000000000000 R15: 0000000000000008
[14691.076012] FS:  00007fd04462b800(0000) GS:ffff880237d00000(0000)
knlGS:0000000000000000
[14691.076012] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14691.076012] CR2: 0000000000000000 CR3: 00000001e7e39000 CR4: 00000000000007e0
[14691.076012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[14691.076012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[14691.076012] Process encfs (pid: 1926, threadinfo ffff88020b652000,
task ffff8801f0c44620)
[14691.076012] Stack:
[14691.076012]  0000000000001000 ffff88020b653d70 ffff8801316cf988
0000000000001000
[14691.076012]  0000000000000025 0000000000000fdb ffff88020b653cb0
ffffffffa019dab0
[14691.076012]  0000000000000000 ffff880106418000 0000000000001000
0000000000001000
[14691.076012] Call Trace:
[14691.076012]  [<ffffffffa019dab0>] btrfs_set_token_64+0xe0/0xf0 [btrfs]
[14691.076012]  [<ffffffffa01be264>]
btrfs_log_changed_extents+0x384/0x600 [btrfs]
[14691.076012]  [<ffffffffa01c05b8>] btrfs_log_inode+0x3b8/0x660 [btrfs]
[14691.076012]  [<ffffffffa01c1519>] btrfs_log_inode_parent+0x169/0x450 [btrfs]
[14691.076012]  [<ffffffffa01c183a>] btrfs_log_dentry_safe+0x3a/0x60 [btrfs]
[14691.076012]  [<ffffffffa0198400>] btrfs_sync_file+0x150/0x1f0 [btrfs]
[14691.076012]  [<ffffffff811c48c6>] do_fsync+0x56/0x80
[14691.076012]  [<ffffffff811c4b50>] sys_fsync+0x10/0x20
[14691.076012]  [<ffffffff8163e419>] system_call_fastpath+0x16/0x1b
[14691.076012] Code: e0 0c 48 01 d0 4c 89 c2 4a 8d 3c 30 e8 57 df 14
e1 4c 8b 45 d0 4d 01 c4 4d 29 c7 74 3b 45 31 f6 49 8b 85 50 01 00 00
48 8b 04 18 <48> 8b 30 83 e6 08 75 95 be af 12 00 00 48 c7 c7 a4 2b 1f
a0 48
[14691.076012] RIP  [<ffffffffa01a7e23>] write_extent_buffer+0xd3/0x150 [btrfs]
[14691.076012]  RSP <ffff88020b653c20>
[14691.076012] CR2: 0000000000000000
[14691.106929] ---[ end trace 0c19c78181b4038e ]---
