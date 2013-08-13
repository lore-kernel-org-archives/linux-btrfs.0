Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60246 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3HMEG3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 00:06:29 -0400
Received: by mail-ob0-f180.google.com with SMTP id up14so4208616obb.11
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Aug 2013 21:06:27 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Aug 2013 23:06:27 -0500
Message-ID: <CAKcLGm_DXiwJrAMYG66ZiEmXtSKe0z0LUPfxat0Repb0jfDnNA@mail.gmail.com>
Subject: Kernel BUG on Snapshot Deletion (3.11.0-rc5)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm hitting a btrfs Kernel BUG running a snapshot stress script with
linux-3.11.0-rc5.

I'm running with lzo compression, autodefrag, and the partition is
formated with 16k leafsize/inodesize.

[   72.170431] device fsid 8a6be667-d041-4367-80f7-e4cb42356e85 devid
1 transid 4 /dev/sda7
[   72.297512] device fsid 8a6be667-d041-4367-80f7-e4cb42356e85 devid
1 transid 4 /dev/sda7
[   72.298928] device fsid 8a6be667-d041-4367-80f7-e4cb42356e85 devid
1 transid 4 /dev/sda7
[   72.299390] btrfs: setting 8 feature flag
[   72.299395] btrfs: force lzo compression
[   72.299401] btrfs: enabling auto defrag
[   72.299404] btrfs: disk space caching is enabled
[   72.299407] btrfs flagging fs with big metadata feature
[ 2234.790218] ------------[ cut here ]------------
[ 2234.790257] WARNING: CPU: 0 PID: 4246 at fs/btrfs/extent-tree.c:840
btrfs_lookup_extent_info+0x328/0x36e [btrfs]()
[ 2234.790262] Modules linked in: ipv6 tg3 serio_raw ppdev
snd_hda_codec_analog iTCO_wdt iTCO_vendor_support snd_hda_intel floppy
snd_hda_codec sr_mod snd_hwdep pcspkr snd_pcm lpc_ich i2c_i801
parport_pc parport ptp snd_page_alloc pps_core snd_timer snd xts
ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 sha256_generic
fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3
jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd
ehci_pci ehci_hcd
[ 2234.790333] CPU: 0 PID: 4246 Comm: btrfs-cleaner Not tainted 3.11.0-rc5 #1
[ 2234.790337] Hardware name: Dell Inc.                 OptiPlex 745
              /0WF810, BIOS 2.6.4  03/01/2010
[ 2234.790341]  0000000000000348 ffff880077739b68 ffffffff81625def
0000000000000006
[ 2234.790349]  0000000000000000 ffff880077739ba8 ffffffff810374f0
ffff88000556e800
[ 2234.790356]  ffffffffa0185d5c ffff88007721de10 ffff88000556e800
0000000000000000
[ 2234.790363] Call Trace:
[ 2234.790375]  [<ffffffff81625def>] dump_stack+0x46/0x58
[ 2234.790384]  [<ffffffff810374f0>] warn_slowpath_common+0x81/0x9b
[ 2234.790403]  [<ffffffffa0185d5c>] ?
btrfs_lookup_extent_info+0x328/0x36e [btrfs]
[ 2234.790411]  [<ffffffff81037524>] warn_slowpath_null+0x1a/0x1c
[ 2234.790429]  [<ffffffffa0185d5c>]
btrfs_lookup_extent_info+0x328/0x36e [btrfs]
[ 2234.790449]  [<ffffffffa018837e>] do_walk_down+0x142/0x438 [btrfs]
[ 2234.790467]  [<ffffffffa01860d4>] ?
btrfs_delayed_refs_qgroup_accounting+0xbd/0xcc [btrfs]
[ 2234.790487]  [<ffffffffa018871a>] walk_down_tree+0xa6/0xd4 [btrfs]
[ 2234.790507]  [<ffffffffa018aec3>] btrfs_drop_snapshot+0x32d/0x65d [btrfs]
[ 2234.790531]  [<ffffffffa019b1df>]
btrfs_clean_one_deleted_snapshot+0xda/0x103 [btrfs]
[ 2234.790552]  [<ffffffffa0193c0c>] cleaner_kthread+0x130/0x157 [btrfs]
[ 2234.790573]  [<ffffffffa0193adc>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
[ 2234.790580]  [<ffffffff810522bc>] kthread+0xba/0xc2
[ 2234.790586]  [<ffffffff81052202>] ? kthread_freezable_should_stop+0x52/0x52
[ 2234.790593]  [<ffffffff8162d89c>] ret_from_fork+0x7c/0xb0
[ 2234.790599]  [<ffffffff81052202>] ? kthread_freezable_should_stop+0x52/0x52
[ 2234.790604] ---[ end trace 21a428587abe0e9d ]---
[ 2234.790610] BTRFS error (device sda7): Missing references.
[ 2234.790637] ------------[ cut here ]------------
[ 2234.790688] kernel BUG at fs/btrfs/extent-tree.c:7191!
[ 2234.790736] invalid opcode: 0000 [#1] SMP
[ 2234.790779] Modules linked in: ipv6 tg3 serio_raw ppdev
snd_hda_codec_analog iTCO_wdt iTCO_vendor_support snd_hda_intel floppy
snd_hda_codec sr_mod snd_hwdep pcspkr snd_pcm lpc_ich i2c_i801
parport_pc parport ptp snd_page_alloc pps_core snd_timer snd xts
ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 sha256_generic
fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3
jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd
ehci_pci ehci_hcd
[ 2234.791005] CPU: 0 PID: 4246 Comm: btrfs-cleaner Tainted: G
W    3.11.0-rc5 #1
[ 2234.791005] Hardware name: Dell Inc.                 OptiPlex 745
              /0WF810, BIOS 2.6.4  03/01/2010
[ 2234.791005] task: ffff88007c97c380 ti: ffff880077738000 task.ti:
ffff880077738000
[ 2234.791005] RIP: 0010:[<ffffffffa01883be>]  [<ffffffffa01883be>]
do_walk_down+0x182/0x438 [btrfs]
[ 2234.791005] RSP: 0000:ffff880077739c58  EFLAGS: 00010296
[ 2234.791005] RAX: 000000000000002e RBX: ffff88000c6706c0 RCX: 0000000000000046
[ 2234.791005] RDX: 0000000000000006 RSI: 0000000000000046 RDI: ffff88007f20d210
[ 2234.791005] RBP: ffff880077739d18 R08: 0000000000000002 R09: 00000000fffffffe
[ 2234.791005] R10: 0000000000000001 R11: ffffffff81e2ee38 R12: ffff88002a930500
[ 2234.791005] R13: ffff880077210000 R14: ffff88000556e800 R15: 0000000000000002
[ 2234.791005] FS:  0000000000000000(0000) GS:ffff88007f200000(0000)
knlGS:0000000000000000
[ 2234.791005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2234.791005] CR2: 00007f312ced67bd CR3: 00000000255e0000 CR4: 00000000000007f0
[ 2234.791005] Stack:
[ 2234.791005]  ffff88000c670708 ffffffffa01860d4 0000000000000000
ffff8800771df3c0
[ 2234.791005]  ffff880077739c98 0000000000000001 0000000100000000
ffff8800771df3c0
[ 2234.791005]  ffff880077739d44 000000000000008c 0000400000000001
000000037595c000
[ 2234.791005] Call Trace:
[ 2234.791005]  [<ffffffffa01860d4>] ?
btrfs_delayed_refs_qgroup_accounting+0xbd/0xcc [btrfs]
[ 2234.791005]  [<ffffffffa018871a>] walk_down_tree+0xa6/0xd4 [btrfs]
[ 2234.791005]  [<ffffffffa018aec3>] btrfs_drop_snapshot+0x32d/0x65d [btrfs]
[ 2234.791005]  [<ffffffffa019b1df>]
btrfs_clean_one_deleted_snapshot+0xda/0x103 [btrfs]
[ 2234.791005]  [<ffffffffa0193c0c>] cleaner_kthread+0x130/0x157 [btrfs]
[ 2234.791005]  [<ffffffffa0193adc>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
[ 2234.791005]  [<ffffffff810522bc>] kthread+0xba/0xc2
[ 2234.791005]  [<ffffffff81052202>] ? kthread_freezable_should_stop+0x52/0x52
[ 2234.791005]  [<ffffffff8162d89c>] ret_from_fork+0x7c/0xb0
[ 2234.791005]  [<ffffffff81052202>] ? kthread_freezable_should_stop+0x52/0x52
[ 2234.791005] Code: 39 d6 03 00 8b 85 68 ff ff ff e9 c0 02 00 00 4a
83 3c d3 00 75 17 49 8b be e8 01 00 00 48 c7 c6 ec af 1f a0 31 c0 e8
bf e8 fe ff <0f> 0b 48 8b 45 80 c7 00 00 00 00 00 83 bb 94 00 00 00 01
0f 85
[ 2234.791005] RIP  [<ffffffffa01883be>] do_walk_down+0x182/0x438 [btrfs]
[ 2234.791005]  RSP <ffff880077739c58>
[ 2234.801856] ---[ end trace 21a428587abe0e9e ]---
