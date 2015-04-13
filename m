Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57658 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbbDMMoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 08:44:09 -0400
Received: from merkaba.localnet (ppp-88-217-116-190.dynamic.mnet-online.de [88.217.116.190])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 82D78195
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:44:07 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: [4.0] BTRFS + ecryptfs: Iceweasel cache process hanging on evicting inodes
Date: Mon, 13 Apr 2015 14:44:06 +0200
Message-ID: <4484014.EqXoRQqIH3@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

This may or may not be related to

Bug 90401 - btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random write into big file 
https://bugzilla.kernel.org/show_bug.cgi?id=90401

BTRFS free space handling still needs more work: Hangs again
Martin Steigerwald | 26 Dec 14:37 2014
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/41790


I am not sure cause I didn´t check CPU usage of processes.

It may be a different issue thus reporting here first.

This is 4.0 kernel with just the patch from Lutz included to make trimming
work.

In case you suspect this to be an ecryptfs issue please tell me and I will
forward to ecryptfs mailing list. I really hope that BTRFS will take on the
Ext4 and probably F2FS work to include encryption within the filesystem
directly.


After seeing Iceweasel not responding anymore in several tabs I saw this
in syslog:

Apr 13 12:49:23 merkaba kernel: [ 4080.770733] INFO: task Cache2 I/O:3529 blocked for more than 120 seconds.
Apr 13 12:49:23 merkaba kernel: [ 4080.770741]       Tainted: G           O    4.0.0-tp520-btrfs-trim+ #25
Apr 13 12:49:23 merkaba kernel: [ 4080.770744] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 13 12:49:23 merkaba kernel: [ 4080.770746] Cache2 I/O      D ffff88030d0b7c58     0  3529   3060 0x00000000
Apr 13 12:49:23 merkaba kernel: [ 4080.770752]  ffff88030d0b7c58 ffff88030d0b7c38 ffff8802dd6d49b0 ffff88030d0b7c38
Apr 13 12:49:23 merkaba kernel: [ 4080.770758]  ffff88030d0b7fd8 ffff8802999ec488 ffff88031915e2ac ffff88030d0b7cd8
Apr 13 12:49:23 merkaba kernel: [ 4080.770763]  ffff88031915e290 ffff88030d0b7c78 ffffffff814c28e8 0000000000000000
Apr 13 12:49:23 merkaba kernel: [ 4080.770768] Call Trace:
Apr 13 12:49:23 merkaba kernel: [ 4080.770777]  [<ffffffff814c28e8>] schedule+0x6f/0x7e
Apr 13 12:49:23 merkaba kernel: [ 4080.770822]  [<ffffffffc04f2426>] lock_extent_bits+0x100/0x188 [btrfs]
Apr 13 12:49:23 merkaba kernel: [ 4080.770828]  [<ffffffff8106ecf5>] ? finish_wait+0x5f/0x5f
Apr 13 12:49:23 merkaba kernel: [ 4080.770855]  [<ffffffffc04e4060>] btrfs_evict_inode+0x14a/0x423 [btrfs]
Apr 13 12:49:23 merkaba kernel: [ 4080.770865]  [<ffffffff8115067d>] evict+0xa8/0x150
Apr 13 12:49:23 merkaba kernel: [ 4080.770869]  [<ffffffff8115128b>] iput+0x16f/0x1bb
Apr 13 12:49:23 merkaba kernel: [ 4080.770880]  [<ffffffffc057561d>] ecryptfs_evict_inode+0x29/0x2d [ecryptfs]
Apr 13 12:49:23 merkaba kernel: [ 4080.770888]  [<ffffffffc05755f4>] ? ecryptfs_show_options+0x11e/0x11e [ecryptfs]
Apr 13 12:49:23 merkaba kernel: [ 4080.770893]  [<ffffffff8115067d>] evict+0xa8/0x150
Apr 13 12:49:23 merkaba kernel: [ 4080.770896]  [<ffffffff8115128b>] iput+0x16f/0x1bb
Apr 13 12:49:23 merkaba kernel: [ 4080.770901]  [<ffffffff8114861d>] do_unlinkat+0x151/0x1f0
Apr 13 12:49:23 merkaba kernel: [ 4080.770906]  [<ffffffff8100d1eb>] ? user_exit+0x13/0x15
Apr 13 12:49:23 merkaba kernel: [ 4080.770910]  [<ffffffff8100e4a5>] ? syscall_trace_enter_phase1+0x57/0x12a
Apr 13 12:49:23 merkaba kernel: [ 4080.770914]  [<ffffffff8100e7bc>] ? syscall_trace_leave+0xcb/0x108
Apr 13 12:49:23 merkaba kernel: [ 4080.770918]  [<ffffffff811492ac>] SyS_unlink+0x11/0x13
Apr 13 12:49:23 merkaba kernel: [ 4080.770923]  [<ffffffff814c5732>] system_call_fastpath+0x12/0x17


Apr 13 12:51:23 merkaba kernel: [ 4200.790479] INFO: task Cache2 I/O:3529 blocked for more than 120 seconds.
Apr 13 12:51:23 merkaba kernel: [ 4200.790492]       Tainted: G           O    4.0.0-tp520-btrfs-trim+ #25
Apr 13 12:51:23 merkaba kernel: [ 4200.790496] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 13 12:51:23 merkaba kernel: [ 4200.790500] Cache2 I/O      D ffff88030d0b7c58     0  3529   3060 0x00000000
Apr 13 12:51:23 merkaba kernel: [ 4200.790511]  ffff88030d0b7c58 ffff88030d0b7c38 ffff8802dd6d49b0 ffff88030d0b7c38
Apr 13 12:51:23 merkaba kernel: [ 4200.790520]  ffff88030d0b7fd8 ffff8802999ec488 ffff88031915e2ac ffff88030d0b7cd8
Apr 13 12:51:23 merkaba kernel: [ 4200.790527]  ffff88031915e290 ffff88030d0b7c78 ffffffff814c28e8 0000000000000000
Apr 13 12:51:23 merkaba kernel: [ 4200.790536] Call Trace:
Apr 13 12:51:23 merkaba kernel: [ 4200.790552]  [<ffffffff814c28e8>] schedule+0x6f/0x7e
Apr 13 12:51:23 merkaba kernel: [ 4200.790637]  [<ffffffffc04f2426>] lock_extent_bits+0x100/0x188 [btrfs]
Apr 13 12:51:23 merkaba kernel: [ 4200.790645]  [<ffffffff8106ecf5>] ? finish_wait+0x5f/0x5f
Apr 13 12:51:23 merkaba kernel: [ 4200.790700]  [<ffffffffc04e4060>] btrfs_evict_inode+0x14a/0x423 [btrfs]
Apr 13 12:51:23 merkaba kernel: [ 4200.790716]  [<ffffffff8115067d>] evict+0xa8/0x150
Apr 13 12:51:23 merkaba kernel: [ 4200.790721]  [<ffffffff8115128b>] iput+0x16f/0x1bb
Apr 13 12:51:23 merkaba kernel: [ 4200.790742]  [<ffffffffc057561d>] ecryptfs_evict_inode+0x29/0x2d [ecryptfs]
Apr 13 12:51:23 merkaba kernel: [ 4200.790758]  [<ffffffffc05755f4>] ? ecryptfs_show_options+0x11e/0x11e [ecryptfs]
Apr 13 12:51:23 merkaba kernel: [ 4200.790765]  [<ffffffff8115067d>] evict+0xa8/0x150
Apr 13 12:51:23 merkaba kernel: [ 4200.790770]  [<ffffffff8115128b>] iput+0x16f/0x1bb
Apr 13 12:51:23 merkaba kernel: [ 4200.790777]  [<ffffffff8114861d>] do_unlinkat+0x151/0x1f0
Apr 13 12:51:23 merkaba kernel: [ 4200.790786]  [<ffffffff8100d1eb>] ? user_exit+0x13/0x15
Apr 13 12:51:23 merkaba kernel: [ 4200.790793]  [<ffffffff8100e4a5>] ? syscall_trace_enter_phase1+0x57/0x12a
Apr 13 12:51:23 merkaba kernel: [ 4200.790799]  [<ffffffff8100e7bc>] ? syscall_trace_leave+0xcb/0x108
Apr 13 12:51:23 merkaba kernel: [ 4200.790806]  [<ffffffff811492ac>] SyS_unlink+0x11/0x13
Apr 13 12:51:23 merkaba kernel: [ 4200.790813]  [<ffffffff814c5732>] system_call_fastpath+0x12/0x17

[two more of these]




merkaba:~> df -hT /home  
Dateisystem            Typ   Größe Benutzt Verf. Verw% Eingehängt auf
/dev/mapper/msata-home btrfs  170G    128G   40G   77% /home
merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 126.88GiB
        devid    1 size 170.00GiB used 170.00GiB path /dev/mapper/msata-home
        devid    2 size 170.00GiB used 170.00GiB path /dev/mapper/sata-home

Btrfs v3.18
merkaba:~> btrfs fi df /home
Data, RAID1: total=163.98GiB, used=124.14GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=5.99GiB, used=2.74GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
merkaba:~> btrfs fi balance /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail


I know I didn´t do it incrementally like in -dusage=80 or so… but still
with almost 40 GiB free inside the allocated data chunks?


After this error I have:

merkaba:~#1> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 126.83GiB
        devid    1 size 170.00GiB used 134.04GiB path /dev/mapper/msata-home
        devid    2 size 170.00GiB used 134.04GiB path /dev/mapper/sata-home

Btrfs v3.18
merkaba:~> btrfs fi df /home
Data, RAID1: total=130.01GiB, used=124.13GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=4.00GiB, used=2.69GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


I will see whether this usual "I did rebalance while it should not be needed
at all" thing again will help as it did in the past. I really hope that one
day this won´t be necessary anymore to keep BTRFS running. That written,
this is still the first and only BTRFS filesystem showing this issue.

But on the otherhand 40 GiB of free space, there really shouldn´t be any
issues with that amount of free space inside the chunks still left.

Again BTRFS Dual SSD RAID 1 on ThinkPad T520.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
