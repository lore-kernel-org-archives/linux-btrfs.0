Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59081 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753033AbcIIMls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 08:41:48 -0400
MIME-Version: 1.0
Message-ID: <trinity-2d94fea3-703e-4378-9700-43d6af78481f-1473424905009@3capp-gmx-bs47>
From: "Jan Koester" <jan.koester@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: segfault btrfs scrub
Content-Type: text/plain; charset=UTF-8
Date: Fri, 9 Sep 2016 14:41:45 +0200
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


 
 
Hi,

i got from btrfs scrub command segfault. I use btrfs tools 4.7.2.
 
root@dibsi:/home/jan# btrfs scrub status /local
Speicherzugriffsfehler
root@dibsi:/home/jan# dmesg
[78294.556713] BTRFS error (device sda): bad tree block start 18427384836265136347 2304683610112
[78294.556956] BTRFS error (device sda): bad tree block start 17385487456874290426 2304683610112
[78294.558323] BTRFS error (device sda): bad tree block start 17385487456874290426 2304683610112
[78294.558397] ------------[ cut here ]------------
[78294.569900] kernel BUG at fs/btrfs/ctree.c:5202!
[78294.581634] invalid opcode: 0000 [#15] SMP
[78294.593089] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c binfmt_misc btrfs xor raid6_pq kvm_amd kvm irqbypass serio_raw snd_usb_audio input_leds joydev snd_usbmidi_lib snd_hda_codec_hdmi edac_mce_amd snd_hda_intel edac_core snd_hda_codec k10temp snd_ctxfi snd_hda_core snd_hwdep snd_pcm i2c_piix4 snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore tpm_infineon mac_hid 8250_fintek shpchp sunrpc parport_pc ppdev lp parport autofs4 hid_generic usbhid hid amdkfd amd_iommu_v2 radeon i2c_algo_bit ttm drm_kms_helper e1000e syscopyarea sysfillrect sysimgblt ptp fb_sys_fops r8169 drm mii ahci pps_core libahci wmi fjes
[78294.629504] CPU: 3 PID: 16486 Comm: btrfs Tainted: G      D W       4.6.0-rc4 #1
[78294.629506] Hardware name: Gigabyte Technology Co., Ltd. GA-970A-D3/GA-970A-D3, BIOS F12 09/03/2013
[78294.629510] task: ffff880070766800 ti: ffff8801c2d30000 task.ti: ffff8801c2d30000
[78294.629568] RIP: 0010:[<ffffffffc088f54d>]  [<ffffffffc088f54d>] btrfs_search_forward+0x24d/0x330 [btrfs]
[78294.629572] RSP: 0018:ffff8801c2d33c10  EFLAGS: 00010246
[78294.629581] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
[78294.629583] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff880080638d40
[78294.629585] RBP: ffff8801c2d33c70 R08: 0000021899d90000 R09: 000002189fd90000
[78294.629587] R10: 0000000000000000 R11: 0000000000000003 R12: ffff88008826e8c0
[78294.629589] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
[78294.629593] FS:  00007ff69486f8c0(0000) GS:ffff88022fcc0000(0000) knlGS:00000000e71e3b40
[78294.629595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[78294.629598] CR2: 0000000001a94088 CR3: 0000000221fe6000 CR4: 00000000000006e0
[78294.629599] Stack:
[78294.629605]  00000000024280ca ffff8801c2d33cbf ffff880223bfa800 01ffffff00000000
[78294.629609]  d800000000000000 0000000000000001 00000000db9fb905 ffff88008826e8c0
[78294.629613]  ffff8801c2d33d18 ffff8802008ee000 ffff8801c2d33cbf ffff8801f91e6800
[78294.629614] Call Trace:
[78294.629669]  [<ffffffffc08e9ed2>] search_ioctl+0xf2/0x1a0 [btrfs]
[78294.629720]  [<ffffffffc08e9ff2>] btrfs_ioctl_tree_search+0x72/0xc0 [btrfs]
[78294.629769]  [<ffffffffc08ee6e4>] btrfs_ioctl+0x3e4/0x21a0 [btrfs]
[78294.629777]  [<ffffffff811c9cbf>] ? handle_mm_fault+0x14cf/0x1e60
[78294.629782]  [<ffffffff81223213>] ? cp_new_stat+0x153/0x180
[78294.629789]  [<ffffffff81231cc1>] do_vfs_ioctl+0xa1/0x5b0
[78294.629794]  [<ffffffff8106b5c5>] ? __do_page_fault+0x205/0x4d0
[78294.629800]  [<ffffffff81232249>] SyS_ioctl+0x79/0x90
[78294.629806]  [<ffffffff818360f6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
[78294.629847] Code: 8b 4d a0 48 8b 55 a8 4d 89 f8 48 8b 7d b0 4c 89 e6 e8 68 fb ff ff 85 c0 0f 85 bf 00 00 00 4c 89 e7 e8 88 7f ff ff e9 fa fd ff ff <0f> 0b 48 8d 04 92 43 89 54 ac 40 48 8d 75 bf b9 11 00 00 00 48
[78294.629885] RIP  [<ffffffffc088f54d>] btrfs_search_forward+0x24d/0x330 [btrfs]
[78294.629887]  RSP <ffff8801c2d33c10>
[78294.629969] ---[ end trace fa1ffcf4f496deaf ]---
