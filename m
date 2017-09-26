Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21362 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964864AbdIZXcX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 19:32:23 -0400
Date: Tue, 26 Sep 2017 16:28:32 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: dmesg: csum "varying number" expected csum 0x0 mirror 1 (with
 trace/oops)
Message-ID: <20170926232832.GA27095@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170927002155.4f1959f9@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170927002155.4f1959f9@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 27, 2017 at 12:21:55AM +0200, Kai Krakow wrote:
> Hello!
> 
> I came across noting some kernel messages which seem to be related to
> btrfs, should I worry?
> 
> I'm currently running scrub on the device now.
> 
> inode-resolve points to an unimportant, easily recoverable file:
> 
> $ sudo btrfs inspect-internal inode-resolve -v 1229624 /mnt/btrfs-pool/gentoo/usr/portage/
> ioctl ret=0, bytes_left=4033, bytes_missing=0, cnt=1, missed=0
> /mnt/btrfs-pool/gentoo/usr/portage//packages/dev-lang/tcl/tcl-8.6.6-2.xpak
> 
> The file wasn't modified in month and it has been in order previously
> because the backup didn't choke on it:
> 
> $ ls -alt
> -rw-r--r-- 1 root root 11241835 19. Apr 22:11 /mnt/btrfs-pool/gentoo/usr/portage//packages/dev-lang/tcl/tcl-8.6.6-2.xpak
> 
> I can read the file without problems, no new messages in dmesg:
> 
> $ cat /mnt/btrfs-pool/gentoo/usr/portage//packages/dev-lang/tcl/tcl-8.6.6-2.xpak >/dev/null
> 
> What's strange is the long time gaps between the btrfs reports and the
> kernel backtraces... Also, expected csum=0 looks strange.
> 
> That mount is subvol_id=0. Not sure if inode-resolve works that way. I
> retried for the important subvolumes and it resolved for none.
> 
> Just in case, I have a backlog of multiple daily backups.
> 
> $ uname -a
> Linux jupiter 4.12.14-ck #1 SMP PREEMPT Fri Sep 22 02:47:44 CEST 2017
> x86_64 Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz GenuineIntel GNU/Linux
> 
> 
> [88597.792462] BTRFS info (device bcache48): no csum found for inode 1229624 start 1650688
> [88597.793304] BTRFS warning (device bcache48): csum failed root 280 ino 1229624 off 1650688 csum 0x953c1e92 expected csum 0x00000000 mirror 1
> [128569.451376] ------------[ cut here ]------------
> [128569.451382] WARNING: CPU: 7 PID: 146 at kernel/workqueue.c:2041 process_one_work+0x44/0x310
> [128569.451383] Modules linked in: cifs ccm fuse bridge stp llc veth rfcomm bnep cachefiles btusb af_packet btintel iTCO_wdt bluetooth tun iTCO_vendor_support rfkill ecdh_generic kvm_intel snd_hda_codec_hdmi snd_hda_codec_realtek kvm snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core rtc_cmos snd_pcm snd_timer snd soundcore lpc_ich irqbypass uas usb_storage r8168(O) nvidia_drm(PO) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_modeset(PO) nvidia(PO) nct6775 hwmon_vid coretemp hwmon efivarfs
> [128569.451406] CPU: 7 PID: 146 Comm: bcache Tainted: P           O    4.12.14-ck #1
> [128569.451407] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
> [128569.451410] task: ffff880419bf8bc0 task.stack: ffffc900005c4000
> [128569.451412] RIP: 0010:process_one_work+0x44/0x310
> [128569.451412] RSP: 0000:ffffc900005c7e78 EFLAGS: 00013002
> [128569.451413] RAX: 0000000000000007 RBX: ffff880419bdcf00 RCX: ffff88042f2d8020
> [128569.451414] RDX: ffff88042f2d8018 RSI: ffff880120454f08 RDI: ffff880419bdcf00
> [128569.451415] RBP: ffff88042f2d8000 R08: 0000000000000000 R09: 0000000000000000
> [128569.451415] R10: 00008a209a609e79 R11: 0000000000000000 R12: 0000000000000000
> [128569.451416] R13: ffff88042f2e1b00 R14: ffff88042f2e1b80 R15: ffff880419bdcf30
> [128569.451417] FS:  0000000000000000(0000) GS:ffff88042f3c0000(0000) knlGS:0000000000000000
> [128569.451418] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [128569.451418] CR2: 00000000000000b0 CR3: 00000003f23ef000 CR4: 00000000001406e0
> [128569.451419] Call Trace:
> [128569.451422]  ? rescuer_thread+0x20b/0x370
> [128569.451424]  ? kthread+0xf2/0x130
> [128569.451425]  ? process_one_work+0x310/0x310
> [128569.451426]  ? kthread_create_on_node+0x40/0x40
> [128569.451428]  ? ret_from_fork+0x22/0x30
> [128569.451429] Code: 04 b8 00 00 00 00 4c 0f 44 e8 49 8b 45 08 44 8b a0 00 01 00 00 41 83 e4 20 f6 45 10 04 75 0e 65 8b 05 79 38 f7 7e 3b 45 04 74 02 <0f> ff 48 ba eb 83 b5 80 46 86 c8 61 48 0f af d6 48 c1 ea 3a 48 
> [128569.451449] ---[ end trace d00a1585e5166d18 ]---
> [148997.934146] BUG: unable to handle kernel paging request at ffffc900006af000
> [148997.934154] IP: memcpy_erms+0x6/0x10
> [148997.934155] PGD 41d021067
> [148997.934156] P4D 41d021067
> [148997.934157] PUD 41d022067
> [148997.934158] PMD 41961c067
> [148997.934158] PTE 0
> [148997.934162] Oops: 0002 [#1] PREEMPT SMP
> [148997.934163] Modules linked in: cifs ccm fuse bridge stp llc veth rfcomm bnep cachefiles btusb af_packet btintel iTCO_wdt bluetooth tun iTCO_vendor_support rfkill ecdh_generic kvm_intel snd_hda_codec_hdmi snd_hda_codec_realtek kvm snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core rtc_cmos snd_pcm snd_timer snd soundcore lpc_ich irqbypass uas usb_storage r8168(O) nvidia_drm(PO) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_modeset(PO) nvidia(PO) nct6775 hwmon_vid coretemp hwmon efivarfs
> [148997.934188] CPU: 6 PID: 966 Comm: kworker/u16:16 Tainted: P        W  O    4.12.14-ck #1
> [148997.934190] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
> [148997.934193] Workqueue: btrfs-endio btrfs_endio_helper
> [148997.934194] task: ffff88001496a340 task.stack: ffffc90011b68000
> [148997.934196] RIP: 0010:memcpy_erms+0x6/0x10
> [148997.934197] RSP: 0018:ffffc90011b6bd78 EFLAGS: 00010202
> [148997.934199] RAX: ffffc900006aeff8 RBX: 0000000000001000 RCX: 0000000000000ff8
> [148997.934200] RDX: 0000000000001000 RSI: ffff88010fe8d008 RDI: ffffc900006af000
> [148997.934201] RBP: ffff88010fe8d000 R08: ffffc900006ad000 R09: 0000000000000000
> [148997.934203] R10: 0000000000000000 R11: 0000000000001000 R12: 0000000000000000
> [148997.934204] R13: 00000000036034c0 R14: 00000000036034c8 R15: ffff880403d76c98
> [148997.934205] FS:  0000000000000000(0000) GS:ffff88042f380000(0000) knlGS:0000000000000000
> [148997.934206] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [148997.934208] CR2: ffffc900006af000 CR3: 00000000045b6000 CR4: 00000000001406e0
> [148997.934209] Call Trace:
> [148997.934212]  ? lzo_decompress_bio+0x197/0x240
> [148997.934214]  ? end_compressed_bio_read+0x29a/0x360
> [148997.934218]  ? process_one_work+0x114/0x310
> [148997.934219]  ? worker_thread+0x42/0x3d0
> [148997.934222]  ? kthread+0xf2/0x130
> [148997.934223]  ? create_worker+0x190/0x190
> [148997.934225]  ? kthread_create_on_node+0x40/0x40
> [148997.934227]  ? do_group_exit+0x35/0xa0
> [148997.934229]  ? ret_from_fork+0x22/0x30
> [148997.934230] Code: 90 90 90 90 90 eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38
> [148997.934252] RIP: memcpy_erms+0x6/0x10 RSP: ffffc90011b6bd78
> [148997.934253] CR2: ffffc900006af000
> [148997.934255] ---[ end trace d00a1585e5166d19 ]---
> 
> 
> Also, this looks very inconsistent:
> 
> $ dmesg|grep csum
> [88597.792462] BTRFS info (device bcache48): no csum found for inode 1229624 start 1650688
> [88597.793304] BTRFS warning (device bcache48): csum failed root 280 ino 1229624 off 1650688 csum 0x953c1e92 expected csum 0x00000000 mirror 1
> [174974.122658] BTRFS info (device bcache48): no csum found for inode 1229624 start 1650688
> [174974.131443] BTRFS warning (device bcache48): csum failed root 280 ino 1229624 off 1650688 csum 0x31588b99 expected csum 0x00000000 mirror 1
> [261351.328665] BTRFS info (device bcache48): no csum found for inode 1229624 start 1650688
> [261351.329472] BTRFS warning (device bcache48): csum failed root 280 ino 1229624 off 1650688 csum 0x9de9452c expected csum 0x00000000 mirror 1
> [343346.197852] BTRFS info (device bcache48): no csum found for inode 1229624 start 1650688
> [343346.215808] BTRFS warning (device bcache48): csum failed root 280 ino 1229624 off 1650688 csum 0x8df498cc expected csum 0x00000000 mirror 1

Seems unrelated to btrfs, which just reads the same sector on every
try but gets different results every time.

> 
> 
> While not tested lately, I'm pretty sure this is no hardware problem.
> The hardware components were each tested at install time, hard disks
> show no errors, the system is stable.
>

We've recently queued a fix in end_compressed_bio_read, which is shown
in your kernel log, but looks like yours is a different problem.

Would you please show more log before these lines?

> [88597.792462] BTRFS info (device bcache48): no csum found for inode 1229624 start 1650688
> [88597.793304] BTRFS warning (device bcache48): csum failed root 280 ino 1229624 off 1650688 csum 0x953c1e92 expected csum 0x00000000 mirror 1
> [128569.451376] ------------[ cut here ]------------


Basically we want to know if there is a 'mirror 0' ahead of these
messages, which may give us a hint about who issues this compression
read.

thanks,

-liubo
