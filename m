Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57239 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389AbaLAVYn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 16:24:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvYSX-00039f-H0
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 22:24:41 +0100
Received: from 179.181.70.116 ([179.181.70.116])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 22:24:41 +0100
Received: from bcdonadio by 179.181.70.116 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 22:24:41 +0100
To: linux-btrfs@vger.kernel.org
From: Bernardo Donadio <bcdonadio@gmail.com>
Subject: Kernel lockup: "fs/btrfs/delayed-inoce.c:1410 btrfs_assert_delayed_root_empty"
Date: Mon, 01 Dec 2014 19:24:30 -0200
Message-ID: <m5imaf$s9b$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm having fairly frequent kernel lockups caused by btrfs, which I think 
it might be a serious bug. I'm using linux-3.17.3.200.fc20.x86_64. It 
freezes the whole system, and spits the error trace in the journal a few 
seconds later.

Here's the journal log, notice that there are 2 stack traces with little 
time between them:

Dez 01 19:15:12 darwin.donadio.be kernel: ------------[ cut here 
]------------
Dez 01 19:15:12 darwin.donadio.be kernel: WARNING: CPU: 3 PID: 494 at 
fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empty+0x34/0x40 
[btrfs]()
Dez 01 19:15:12 darwin.donadio.be kernel: Modules linked in: ufs hfsplus 
hfs minix vfat msdos fat jfs xfs libcrc32c reiserfs rfcomm fuse 
xt_CHECKSUM iptable_mangle tun bridge stp llc ip6table_filter ip6_tables 
ebtable_nat ebtables cfg80211 bnep usblp btusb bluetooth rfkill uvcvideo 
videobuf2_vmalloc videobuf2_memops videobuf2_core snd_usb_audio 
v4l2_common videodev snd_usbmidi_lib snd_rawmidi media joydev kvm_amd 
kvm serio_raw k10temp edac_core snd_hda_codec_realtek snd_hda_codec_hdmi 
snd_hda_codec_generic edac_mce_amd snd_hda_intel snd_hda_controller 
sp5100_tco snd_hda_codec snd_seq i2c_piix4 snd_hwdep snd_seq_device 
snd_pcm snd_timer snd soundcore shpchp acpi_cpufreq binfmt_misc nfsd 
auth_rpcgss nfs_acl lockd sunrpc btrfs xor raid6_pq r8169 mii radeon 
i2c_algo_bit drm_kms_helper ttm drm
Dez 01 19:15:12 darwin.donadio.be kernel: CPU: 3 PID: 494 Comm: 
btrfs-transacti Tainted: G        W      3.17.3-200.fc20.x86_64 #1
Dez 01 19:15:12 darwin.donadio.be kernel: Hardware name: ECS 
A890GXM-A/A890GXM-A, BIOS 080015  03/24/2010
Dez 01 19:15:12 darwin.donadio.be kernel:  0000000000000000 
00000000314b2122 ffff8802213e3db8 ffffffff81728acc
Dez 01 19:15:12 darwin.donadio.be kernel:  0000000000000000 
ffff8802213e3df0 ffffffff81094e6d ffff8801e6d78000
Dez 01 19:15:12 darwin.donadio.be kernel:  ffff88022101e800 
ffff8802097d9f00 0000000000000000 0000000000000000
Dez 01 19:15:12 darwin.donadio.be kernel: Call Trace:
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffff81728acc>] 
dump_stack+0x45/0x56
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffff81094e6d>] 
warn_slowpath_common+0x7d/0xa0
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffff81094f9a>] 
warn_slowpath_null+0x1a/0x20
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffffa02cc674>] 
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffffa02771b2>] 
btrfs_commit_transaction+0x3a2/0x9c0 [btrfs]
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffffa0272c45>] 
transaction_kthread+0x1c5/0x250 [btrfs]
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffffa0272a80>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffff810b2498>] 
kthread+0xd8/0xf0
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffff810b23c0>] ? 
kthread_create_on_node+0x190/0x190
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffff817300fc>] 
ret_from_fork+0x7c/0xb0
Dez 01 19:15:12 darwin.donadio.be kernel:  [<ffffffff810b23c0>] ? 
kthread_create_on_node+0x190/0x190
Dez 01 19:15:12 darwin.donadio.be kernel: ---[ end trace 
81e909e70c8984e0 ]---
Dez 01 19:15:42 darwin.donadio.be kernel: ------------[ cut here 
]------------
Dez 01 19:15:42 darwin.donadio.be kernel: WARNING: CPU: 2 PID: 494 at 
fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empty+0x34/0x40 
[btrfs]()
Dez 01 19:15:42 darwin.donadio.be kernel: Modules linked in: ufs hfsplus 
hfs minix vfat msdos fat jfs xfs libcrc32c reiserfs rfcomm fuse 
xt_CHECKSUM iptable_mangle tun bridge stp llc ip6table_filter ip6_tables 
ebtable_nat ebtables cfg80211 bnep usblp btusb bluetooth rfkill uvcvideo 
videobuf2_vmalloc videobuf2_memops videobuf2_core snd_usb_audio 
v4l2_common videodev snd_usbmidi_lib snd_rawmidi media joydev kvm_amd 
kvm serio_raw k10temp edac_core snd_hda_codec_realtek snd_hda_codec_hdmi 
snd_hda_codec_generic edac_mce_amd snd_hda_intel snd_hda_controller 
sp5100_tco snd_hda_codec snd_seq i2c_piix4 snd_hwdep snd_seq_device 
snd_pcm snd_timer snd soundcore shpchp acpi_cpufreq binfmt_misc nfsd 
auth_rpcgss nfs_acl lockd sunrpc btrfs xor raid6_pq r8169 mii radeon 
i2c_algo_bit drm_kms_helper ttm drm
Dez 01 19:15:42 darwin.donadio.be kernel: CPU: 2 PID: 494 Comm: 
btrfs-transacti Tainted: G        W      3.17.3-200.fc20.x86_64 #1
Dez 01 19:15:42 darwin.donadio.be kernel: Hardware name: ECS 
A890GXM-A/A890GXM-A, BIOS 080015  03/24/2010
Dez 01 19:15:42 darwin.donadio.be kernel:  0000000000000000 
00000000314b2122 ffff8802213e3db8 ffffffff81728acc
Dez 01 19:15:42 darwin.donadio.be kernel:  0000000000000000 
ffff8802213e3df0 ffffffff81094e6d ffff8801eb8fc140
Dez 01 19:15:42 darwin.donadio.be kernel:  ffff88022101e800 
ffff88009da84b40 0000000000000000 0000000000000000
Dez 01 19:15:42 darwin.donadio.be kernel: Call Trace:
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffff81728acc>] 
dump_stack+0x45/0x56
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffff81094e6d>] 
warn_slowpath_common+0x7d/0xa0
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffff81094f9a>] 
warn_slowpath_null+0x1a/0x20
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffffa02cc674>] 
btrfs_assert_delayed_root_empty+0x34/0x40 [btrfs]
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffffa02771b2>] 
btrfs_commit_transaction+0x3a2/0x9c0 [btrfs]
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffffa0272c45>] 
transaction_kthread+0x1c5/0x250 [btrfs]
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffffa0272a80>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffff810b2498>] 
kthread+0xd8/0xf0
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffff810b23c0>] ? 
kthread_create_on_node+0x190/0x190
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffff817300fc>] 
ret_from_fork+0x7c/0xb0
Dez 01 19:15:42 darwin.donadio.be kernel:  [<ffffffff810b23c0>] ? 
kthread_create_on_node+0x190/0x190
Dez 01 19:15:42 darwin.donadio.be kernel: ---[ end trace 
81e909e70c8984e1 ]---

--
Bernardo Donadio

