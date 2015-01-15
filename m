Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:35668 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbbAOWCv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 17:02:51 -0500
Received: by mail-qa0-f52.google.com with SMTP id x12so13111599qac.11
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 14:02:50 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Jan 2015 23:02:50 +0100
Message-ID: <CAH4oapfPVFrUGy4nEhYcEkN=m99dByAPFGVDF=MD6KVG9buBzw@mail.gmail.com>
Subject: filesystem corruption/unable to scrub
From: Pavol Cupka <pavol.cupka@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am having trouble with my btrfs setup. An unwanted reset probably
caused the corruption. I can mount the filesystem, but cannot perform
scrub as this ends with GPF.

uname -a
Linux sysresccd 3.14.24-alt441-amd64 #2 SMP Sun Nov 16 08:27:16 UTC
2014 x86_64 AMD Phenom(tm) II X4 965 Processor AuthenticAMD GNU/Linux

btrfs --version
Btrfs v3.17.1

btrfs fi show
Label: 'suc_storage'  uuid: 76bf605a-936b-4fce-8a74-1eb2c750f51c
        Total devices 2 FS bytes used 2.57TiB
        devid    1 size 3.64TiB used 3.63TiB path /dev/sda1
        devid    2 size 3.64TiB used 3.63TiB path /dev/sdb1

btrfs fi df /home # Replace /home with the mount point of your btrfs-filesystem
Data, RAID1: total=3.63TiB, used=2.56TiB
System, RAID1: total=32.00MiB, used=532.00KiB
Metadata, RAID1: total=7.00GiB, used=5.83GiB

dmesg > dmesg.log

[14408.258515] general protection fault: 0000 [#1] SMP
[14408.258520] Modules linked in: ppdev microcode parport_pc parport
acpi_cpufreq serio_raw edac_core edac_mce_amd k10temp sp5100_tco
i2c_piix4 shpchp raid10 raid456 async_raid6_recov async_pq async_xor
async_memcpy async_tx raid1 raid0 multipath linear ata_generic
pata_acpi usb_storage nouveau firewire_ohci firewire_core pata_atiixp
ttm drm_kms_helper drm r8169 mii i2c_algo_bit i2c_core mxm_wmi video
wmi
[14408.258543] CPU: 3 PID: 3100 Comm: btrfs-scrub-2 Not tainted
3.14.24-alt441-amd64 #2
[14408.258546] Hardware name: Gigabyte Technology Co., Ltd.
GA-MA785GT-UD3H/GA-MA785GT-UD3H, BIOS F8 05/25/2010
[14408.258549] task: ffff88007158a600 ti: ffff88011b9e4000 task.ti:
ffff88011b9e4000
[14408.258551] RIP: 0010:[<ffffffff81423e91>]  [<ffffffff81423e91>]
scrub_bio_end_io_worker+0xb6/0x5fb
[14408.258558] RSP: 0000:ffff88011b9e5d28  EFLAGS: 00010287
[14408.258560] RAX: ffff8800779ace00 RBX: fffe880118114e40 RCX: ffff8800b79dd800
[14408.258562] RDX: ffff8800b79dd8a8 RSI: 0000000000000001 RDI: 0000000000000014
[14408.258564] RBP: ffff88011b9e5df8 R08: ffffea0004604518 R09: ffff88011b9e5ce8
[14408.258566] R10: ffffffff81420d8a R11: ffff880100000001 R12: ffff8800779ac100
[14408.258568] R13: 0000000000000000 R14: ffff8800779ac100 R15: 0000000000000000
[14408.258570] FS:  0000000000000000(0000) GS:ffff88013fcc0000(0000)
knlGS:00000000f75ccb40
[14408.258572] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[14408.258574] CR2: 00000000f77c6000 CR3: 000000003ee94000 CR4: 00000000000007e0
[14408.258575] Stack:
[14408.258577]  ffff88011b9e5d88 ffff88011b9e5da8 ffff880139ab7200
ffff880000000001
[14408.258581]  ffff880118114f00 ffff8800b79dd940 ffff8800b7fa1800
0000000100d8f612
[14408.258583]  ffff8800b79dd8a8 000000158107d8ca ffff8800b79dd800
ffff8800b7fa1800
[14408.258586] Call Trace:
[14408.258592]  [<ffffffff817b73c1>] ? schedule_timeout+0xa1/0xbd
[14408.258596]  [<ffffffff8107d3aa>] ? lock_timer_base+0x4d/0x4d
[14408.258600]  [<ffffffff81401d95>] worker_loop+0x194/0x527
[14408.258604]  [<ffffffff81401c01>] ? btrfs_queue_worker+0x239/0x239
[14408.258607]  [<ffffffff8108eb43>] kthread+0xc9/0xd1
[14408.258611]  [<ffffffff8108ea7a>] ? kthread_freezable_should_stop+0x60/0x60
[14408.258614]  [<ffffffff817c11cc>] ret_from_fork+0x7c/0xb0
[14408.258617]  [<ffffffff8108ea7a>] ? kthread_freezable_should_stop+0x60/0x60
[14408.258618] Code: 02 48 8b 09 80 a1 98 00 00 00 fb 48 8b 4d 80 48
83 c2 08 3b 81 38 01 00 00 7c dc eb 9c 48 8b 95 70 ff ff ff 48 8b 42
38 48 8b 18 <f0> ff 8b 84 00 00 00 0f 94 c0 84 c0 0f 84 2c 04 00 00 f6
83 98
[14408.258639] RIP  [<ffffffff81423e91>] scrub_bio_end_io_worker+0xb6/0x5fb
[14408.258642]  RSP <ffff88011b9e5d28>
[14408.258645] ---[ end trace 168b2c0c1e0d1fcc ]---

Running btrfsck with --repair ends also with errors.
...
Device extent[2, 1522566955008, 1073741824] didn't find its device.
Device extent[2, 1523640696832, 1073741824] didn't find its device.
Device extent[2, 1524714438656, 1073741824] didn't find its device.
Device extent[2, 1525788180480, 1073741824] didn't find its device.
Device extent[2, 1526861922304, 1073741824] didn't find its device.
Device extent[2, 1527935664128, 1073741824] didn't find its device.
Errors found in extent allocation tree or chunk allocation
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
bad key ordering 1 2
Deleting bad dir index [618631,96,57124] root 270
volumes.c:978: btrfs_alloc_chunk: Assertion `ret` failed.
btrfs check[0x8083f7d]
btrfs check[0x8087624]
btrfs check[0x807d132]
btrfs check[0x807d4fc]
btrfs check[0x807dfc4]
btrfs check[0x80710d7]
btrfs check[0x8071774]
btrfs check[0x80737c0]
btrfs check[0x808060a]
btrfs check[0x805f56d]
btrfs check[0x8061f82]
btrfs check[0x8067797]
btrfs check[0x804afd9]
/lib/libc.so.6(__libc_start_main+0xe6)[0xf7619346]
btrfs check[0x804ac31]

Could you please help me as how could I correct current state.

Thank you in advance
Pavol
