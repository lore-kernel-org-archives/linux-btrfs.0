Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:45522 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751553AbeBAVG2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Feb 2018 16:06:28 -0500
Received: by mail-pg0-f54.google.com with SMTP id m136so12988503pga.12
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Feb 2018 13:06:28 -0800 (PST)
MIME-Version: 1.0
From: Patrik Ostrihon <patrik.ostrihon@gmail.com>
Date: Thu, 1 Feb 2018 22:06:27 +0100
Message-ID: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
Subject: btrfs - kernel warning
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Today I saw warning in dmesg output. But I don't know what it means.
Could you help me please? Is it something dangerous for my dato on
this filesystem?

Thanks

pa3k

root@merkur:~# uname -a

Linux merkur 4.14.8-041408-generic #201712200555 SMP Wed Dec 20
10:57:38 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

root@merkur:~# btrfs --version
Btrfs v3.12

root@merkur:~# btrfs fi show

Label: none  uuid: 96f60fa9-c20e-4a13-82b1-9074dd942eab
        Total devices 2 FS bytes used 2.43TiB
        devid    1 size 8.19TiB used 2.45TiB path /dev/sdc2
        devid    2 size 8.19TiB used 2.45TiB path /dev/sdd2

Label: none  uuid: 2da0261b-143a-4814-aacb-de46373aebe9
        Total devices 2 FS bytes used 203.11GiB
        devid    1 size 930.00GiB used 206.03GiB path /dev/sdc1
        devid    2 size 930.00GiB used 206.01GiB path /dev/sdd1

Btrfs v3.12


root@merkur:~# btrfs fi df /usr/local/data

Data, RAID1: total=2.44TiB, used=2.43TiB
Data, single: total=8.00MiB, used=0.00
System, RAID1: total=8.00MiB, used=368.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=5.00GiB, used=3.33GiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=512.00MiB, used=0.00
root@merkur:~# btrfs fi df /usr/local/data/hts
Data, RAID1: total=205.00GiB, used=202.90GiB
Data, single: total=8.00MiB, used=0.00
System, RAID1: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=1.00GiB, used=213.25MiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=211.78MiB, used=0.00


[ 4084.704514] ------------[ cut here ]------------
[ 4084.704561] WARNING: CPU: 3 PID: 1865 at
/home/kernel/COD/linux/fs/btrfs/ctree.h:1564
btrfs_update_device+0x1be/0x1d0 [btrfs]
[ 4084.704562] Modules linked in: snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic gpio_ich intel_powerclamp
coretemp mxl5xx i915 kvm_intel kvm video drm_kms_helper ftdi_sio drm
usbserial joydev irqbypass input_leds intel_cstate snd_hda_intel
snd_hda_codec snd_hda_core ddbridge snd_hwdep i2c_algo_bit snd_pcm
snd_timer fb_sys_fops syscopyarea snd cxd2099(C) sysfillrect soundcore
sysimgblt dvb_core lpc_ich mei_me nuvoton_cir mei mac_hid rc_core
shpchp 8021q garp mrp stp llc lp parport btrfs zstd_compress raid10
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
hid_generic e1000e usbhid uas ptp raid6_pq usb_storage hid libcrc32c
pps_core pata_acpi raid1 raid0 multipath linear
[ 4084.704598] CPU: 3 PID: 1865 Comm: btrfs-cleaner Tainted: G
C      4.14.8-041408-generic #201712200555
[ 4084.704598] Hardware name:                  /DH57JG, BIOS
JGIBX10J.86A.0663.2011.1019.0408 10/19/2011
[ 4084.704599] task: ffff9803b17f8000 task.stack: ffffa6f2822f0000
[ 4084.704616] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
[ 4084.704617] RSP: 0018:ffffa6f2822f3d40 EFLAGS: 00010206
[ 4084.704618] RAX: 0000000000000fff RBX: ffff9803b38bf9a0 RCX: 0000082fffff6e00
[ 4084.704619] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff980397b574c8
[ 4084.704619] RBP: ffffa6f2822f3d88 R08: ffffa6f2822f3cf0 R09: ffffa6f2822f3cf8
[ 4084.704620] R10: 0000000000001000 R11: 0000000000003000 R12: ffff980375d41000
[ 4084.704621] R13: 0000000000000000 R14: 0000000000003f3c R15: ffff980397b574c8
[ 4084.704622] FS:  0000000000000000(0000) GS:ffff9803b72c0000(0000)
knlGS:0000000000000000
[ 4084.704623] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4084.704624] CR2: 00007f883404d000 CR3: 000000001fa09003 CR4: 00000000000206e0
[ 4084.704625] Call Trace:
[ 4084.704644]  btrfs_remove_chunk+0x365/0x870 [btrfs]
[ 4084.704658]  btrfs_delete_unused_bgs+0x320/0x3c0 [btrfs]
[ 4084.704672]  cleaner_kthread+0x159/0x170 [btrfs]
[ 4084.704676]  kthread+0x125/0x140
[ 4084.704689]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[ 4084.704691]  ? kthread_create_on_node+0x70/0x70
[ 4084.704694]  ret_from_fork+0x25/0x30
[ 4084.704695] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 1a
20 ff ff 4c 89 ff e8 82 ea fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
d0 fe ff ff <0f> ff eb b6 e8 c9 15 9e de 66 0f 1f 84 00 00 00 00 00 66
66 66
[ 4084.704717] ---[ end trace 4a9fc911d4199609 ]---
[ 4084.705475] ------------[ cut here ]------------
[ 4084.705516] WARNING: CPU: 2 PID: 1865 at
/home/kernel/COD/linux/fs/btrfs/ctree.h:1564
btrfs_update_device+0x1be/0x1d0 [btrfs]
[ 4084.705517] Modules linked in: snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic gpio_ich intel_powerclamp
coretemp mxl5xx i915 kvm_intel kvm video drm_kms_helper ftdi_sio drm
usbserial joydev irqbypass input_leds intel_cstate snd_hda_intel
snd_hda_codec snd_hda_core ddbridge snd_hwdep i2c_algo_bit snd_pcm
snd_timer fb_sys_fops syscopyarea snd cxd2099(C) sysfillrect soundcore
sysimgblt dvb_core lpc_ich mei_me nuvoton_cir mei mac_hid rc_core
shpchp 8021q garp mrp stp llc lp parport btrfs zstd_compress raid10
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
hid_generic e1000e usbhid uas ptp raid6_pq usb_storage hid libcrc32c
pps_core pata_acpi raid1 raid0 multipath linear
[ 4084.705573] CPU: 2 PID: 1865 Comm: btrfs-cleaner Tainted: G
WC      4.14.8-041408-generic #201712200555
[ 4084.705574] Hardware name:                  /DH57JG, BIOS
JGIBX10J.86A.0663.2011.1019.0408 10/19/2011
[ 4084.705576] task: ffff9803b17f8000 task.stack: ffffa6f2822f0000
[ 4084.705611] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
[ 4084.705613] RSP: 0018:ffffa6f2822f3d40 EFLAGS: 00010206
[ 4084.705616] RAX: 0000000000000fff RBX: ffff9803b1787000 RCX: 0000082fffff6e00
[ 4084.705617] RDX: 0000000000001000 RSI: 0000000000003f5c RDI: ffff980397b574c8
[ 4084.705619] RBP: ffffa6f2822f3d88 R08: ffffa6f2822f3cf0 R09: ffffa6f2822f3cf8
[ 4084.705620] R10: 0000000000001000 R11: 0000000000003000 R12: ffff980375d41000
[ 4084.705622] R13: 0000000000000000 R14: 0000000000003f3c R15: ffff980397b574c8
[ 4084.705624] FS:  0000000000000000(0000) GS:ffff9803b7280000(0000)
knlGS:0000000000000000
[ 4084.705626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4084.705628] CR2: 00007f8834051000 CR3: 000000001fa09006 CR4: 00000000000206e0
[ 4084.705629] Call Trace:
[ 4084.705667]  btrfs_remove_chunk+0x365/0x870 [btrfs]
[ 4084.705698]  btrfs_delete_unused_bgs+0x320/0x3c0 [btrfs]
[ 4084.705729]  cleaner_kthread+0x159/0x170 [btrfs]
[ 4084.705732]  kthread+0x125/0x140
[ 4084.705762]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
[ 4084.705765]  ? kthread_create_on_node+0x70/0x70
[ 4084.705768]  ret_from_fork+0x25/0x30
[ 4084.705771] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 1a
20 ff ff 4c 89 ff e8 82 ea fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9
d0 fe ff ff <0f> ff eb b6 e8 c9 15 9e de 66 0f 1f 84 00 00 00 00 00 66
66 66
[ 4084.705819] ---[ end trace 4a9fc911d419960a ]---
