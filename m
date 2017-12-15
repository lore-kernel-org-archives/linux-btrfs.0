Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37075 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754953AbdLOJo2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 04:44:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ePmXS-0001xR-Vb
        for linux-btrfs@vger.kernel.org; Fri, 15 Dec 2017 10:44:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: [4.14] WARNING: CPU: 2 PID: 779 at fs/btrfs/backref.c:1255
 find_parent_nodes+0x892/0x1340
Date: Fri, 15 Dec 2017 10:25:04 +0100
Message-ID: <g0hcge-n36.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

During balance I'm seeing the following in dmesg:

[194123.693226] ------------[ cut here ]------------
[194123.693231] WARNING: CPU: 2 PID: 779 at fs/btrfs/backref.c:1255 find_parent_nodes+0x892/0x1340
[194123.693232] Modules linked in: f2fs bridge stp llc cifs ccm xfs rfcomm bnep fuse cachefiles snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic af_packet iTCO_wdt iTCO_vendor_support btusb btintel bluetooth kvm_intel snd_hda_intel rfkill snd_hda_codec kvm ecdh_generic snd_hda_core rtc_cmos lpc_ich irqbypass snd_pcm snd_timer snd soundcore uas usb_storage r8168(O) nvidia_drm(PO) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_uvm(PO) nvidia_modeset(PO) nvidia(PO) nct6775 hwmon_vid coretemp hwmon efivarfs
[194123.693252] CPU: 2 PID: 779 Comm: crawl Tainted: P           O    4.14.0-pf5 #3
[194123.693252] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
[194123.693253] task: ffff8803e0a53840 task.stack: ffffc90003f24000
[194123.693254] RIP: 0010:find_parent_nodes+0x892/0x1340
[194123.693255] RSP: 0018:ffffc90003f27b30 EFLAGS: 00010286
[194123.693256] RAX: 00000000ffffffff RBX: ffff88000bcdb3a0 RCX: ffff88000bef7d68
[194123.693256] RDX: ffff88000bef7d68 RSI: ffff88042f29b620 RDI: ffff88000bef7c60
[194123.693256] RBP: ffffc90003f27c50 R08: 000000000001b620 R09: ffffffff812949c0
[194123.693257] R10: ffffea00002f36c0 R11: ffff88041d003980 R12: 0000000000000000
[194123.693257] R13: ffff88000bef7c60 R14: ffff8801c1487a40 R15: ffff88000bef7d68
[194123.693258] FS:  00007f4cae8cb700(0000) GS:ffff88042f280000(0000) knlGS:0000000000000000
[194123.693258] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[194123.693259] CR2: 00007f63e7953038 CR3: 00000003e190a002 CR4: 00000000001606e0
[194123.693259] Call Trace:
[194123.693262]  ? kmem_cache_free+0x13d/0x170
[194123.693265]  ? btrfs_find_all_roots_safe+0x89/0xf0
[194123.693266]  btrfs_find_all_roots_safe+0x89/0xf0
[194123.693267]  ? extent_same_check_offsets+0x60/0x60
[194123.693269]  iterate_extent_inodes+0x154/0x270
[194123.693270]  ? extent_same_check_offsets+0x60/0x60
[194123.693271]  ? iterate_inodes_from_logical+0x81/0x90
[194123.693272]  iterate_inodes_from_logical+0x81/0x90
[194123.693273]  btrfs_ioctl+0x8a3/0x2420
[194123.693275]  ? generic_file_read_iter+0x2c1/0x7c0
[194123.693276]  ? do_vfs_ioctl+0x8a/0x5c0
[194123.693277]  do_vfs_ioctl+0x8a/0x5c0
[194123.693278]  ? __fget+0x62/0xa0
[194123.693279]  SyS_ioctl+0x36/0x70
[194123.693281]  entry_SYSCALL_64_fastpath+0x13/0x94
[194123.693283] RIP: 0033:0x3d9acf0037
[194123.693283] RSP: 002b:00007f4cae8c8448 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[194123.693284] RAX: ffffffffffffffda RBX: 000000000000000a RCX: 0000003d9acf0037
[194123.693284] RDX: 00007f4cae8c85a8 RSI: 00000000c0389424 RDI: 0000000000000003
[194123.693285] RBP: 000000000000000a R08: 0000000000000000 R09: 0000000000000400
[194123.693285] R10: 0000000000000020 R11: 0000000000000246 R12: 000000000000000a
[194123.693285] R13: 0000000000000000 R14: 000000000000000a R15: 00007f4ca8080f70
[194123.693286] Code: 3d e4 f6 e2 00 4c 89 ee e8 2c 5e ed ff 44 89 f2 45 85 f6 0f 85 4a fe ff ff e9 4f fb ff ff 85 c0 0f 84 22 fc ff ff e9 5d fc ff ff <0f> ff 48 85 db 0f 84 49 fc ff ff e9 37 fc ff ff 41 f6 47 42 01 
[194123.693300] ---[ end trace 8c5a2104d4238bb7 ]---


-- 
Regards,
Kai

Replies to list-only preferred.

