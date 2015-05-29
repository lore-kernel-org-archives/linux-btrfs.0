Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33455 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbbE2VON (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 May 2015 17:14:13 -0400
Received: by qcmi9 with SMTP id i9so31220656qcm.0
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2015 14:14:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 29 May 2015 23:14:13 +0200
Message-ID: <CAB8YbStYrFTnY6Jt03b=etgJ73pWO_xSN0SMingNtOOnMbjTvg@mail.gmail.com>
Subject: BTRFS issue: deleting default snapshot causes kernel oops
From: Markus Schauler <mschauler@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm having an issue with Btrfs on an opensuse Tumbleweed system using
kernel 4.0.4-1

Here's what happened:
I use the snapper tool to create periodic snapshots of the root FS
After having problems with an update, I rolled back my system by
seting the default subvolume for / to snapshot 398 (the last good
snapshot)
After rebooting, everything was fine.

Some days later, snapper decided to delete the old snapshot 398 (that
was mounted as /)
Then, the system stopped with this error:


Mai 29 22:45:45 linux.site dbus[1113]: [system] Activating service
name='org.opensuse.Snapper' (using servicehelper)
Mai 29 22:45:45 linux.site dbus[1113]: [system] Successfully activated
service 'org.opensuse.Snapper'
Mai 29 22:45:46 linux.site kernel: BTRFS error (device dm-1): deleting
default subvolume 398 is not allowed
Mai 29 22:45:46 linux.site kernel: BUG: unable to handle kernel NULL
pointer dereference at           (null)
Mai 29 22:45:46 linux.site kernel: IP: [<ffffffff81207810>] pin_remove+0x50/0xb0
Mai 29 22:45:46 linux.site kernel: PGD 6edfe067 PUD 9bee4067 PMD 0
Mai 29 22:45:46 linux.site kernel: Oops: 0002 [#1] PREEMPT SMP
Mai 29 22:45:46 linux.site kernel: Modules linked in: fuse bnep
bluetooth rfkill af_packet ppdev snd_hda_codec_hdmi sn
Mai 29 22:45:46 linux.site kernel: CPU: 0 PID: 3827 Comm: snapperd Not
tainted 4.0.4-1-desktop #1
Mai 29 22:45:46 linux.site kernel: Hardware name: Gigabyte Technology
Co., Ltd. GA-MA74GM-S2H/GA-MA74GM-S2H, BIOS FDd
Mai 29 22:45:46 linux.site kernel: task: ffff88007066a290 ti:
ffff88006e81c000 task.ti: ffff88006e81c000
Mai 29 22:45:46 linux.site kernel: RIP: 0010:[<ffffffff81207810>]
[<ffffffff81207810>] pin_remove+0x50/0xb0
Mai 29 22:45:46 linux.site kernel: RSP: 0018:ffff88006e81fe78  EFLAGS: 00010246
Mai 29 22:45:46 linux.site kernel: RAX: 0000000000000000 RBX:
ffff8800c9a1bc20 RCX: 00000000000001d9
Mai 29 22:45:46 linux.site kernel: RDX: 0000000000000000 RSI:
000000000000000a RDI: ffffffff821dc6b0
Mai 29 22:45:46 linux.site kernel: RBP: ffff88006e81feb8 R08:
ffffffff81ef5ec8 R09: 0000000000000246
Mai 29 22:45:46 linux.site kernel: R10: 0000000000000412 R11:
0000000000000000 R12: ffff88007066a290
Mai 29 22:45:46 linux.site kernel: R13: ffff88007066a290 R14:
00007f9e3c000a00 R15: 00007f9e3c003560
Mai 29 22:45:46 linux.site kernel: FS:  00007f9e44350700(0000)
GS:ffff88012fc00000(0000) knlGS:0000000000000000
Mai 29 22:45:46 linux.site kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Mai 29 22:45:46 linux.site kernel: CR2: 0000000000000000 CR3:
000000006ef32000 CR4: 00000000000007f0
Mai 29 22:45:46 linux.site kernel: Stack:
Mai 29 22:45:46 linux.site kernel:  ffff8800c9a1bc20 ffffffff811f59aa
ffff8800c9a1bc20 ffffffff8120797c
Mai 29 22:45:46 linux.site kernel:  ffff8800c93b70e0 ffffffff00000000
ffff88007066a290 ffffffff810a4400
Mai 29 22:45:46 linux.site kernel:  ffff88006e81feb8 ffff88006e81feb8
ffff8800be75c640 ffffffff820eca00
Mai 29 22:45:46 linux.site kernel: Call Trace:
Mai 29 22:45:46 linux.site kernel:  [<ffffffff811f59aa>]
drop_mountpoint+0x1a/0x30
Mai 29 22:45:46 linux.site kernel:  [<ffffffff8120797c>] pin_kill+0x6c/0x100
Mai 29 22:45:46 linux.site kernel:  [<ffffffff81207a29>] mnt_pin_kill+0x19/0x30
Mai 29 22:45:46 linux.site kernel:  [<ffffffff811f4dc2>] cleanup_mnt+0x72/0x80
Mai 29 22:45:46 linux.site kernel:  [<ffffffff8107f944>] task_work_run+0xc4/0xe0
Mai 29 22:45:46 linux.site kernel:  [<ffffffff81002f79>]
do_notify_resume+0x69/0x90
Mai 29 22:45:46 linux.site kernel:  [<ffffffff8168306b>] int_signal+0x12/0x17
Mai 29 22:45:46 linux.site kernel:  [<00007f9e46413497>] 0x7f9e46413497
Mai 29 22:45:46 linux.site kernel: Code: 48 89 50 08 48 b8 00 01 10 00
00 00 ad de 48 8b 53 28 48 89 43 30 48 b8 00 02
Mai 29 22:45:46 linux.site kernel: RIP  [<ffffffff81207810>]
pin_remove+0x50/0xb0
Mai 29 22:45:46 linux.site kernel:  RSP <ffff88006e81fe78>
Mai 29 22:45:46 linux.site kernel: CR2: 0000000000000000
Mai 29 22:45:46 linux.site kernel: ---[ end trace 60632488b661379d ]---
Mai 29 22:45:46 linux.site kernel: note: snapperd[3827] exited with
preempt_count 1
