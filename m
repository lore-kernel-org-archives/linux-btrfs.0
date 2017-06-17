Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35097 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdFQXGj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Jun 2017 19:06:39 -0400
Received: by mail-io0-f179.google.com with SMTP id k93so47013526ioi.2
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Jun 2017 16:06:38 -0700 (PDT)
MIME-Version: 1.0
From: Jesse <btrfs_mail_list@mymail.isbest.biz>
Date: Sun, 18 Jun 2017 07:06:37 +0800
Message-ID: <CAAsnU-9VvSzqpW2S0qpv8Ypwfx4L4ine9Pi2ENuGmg8id0Q0gA@mail.gmail.com>
Subject: Please help. Repair probably bitflip damage and suspected bug
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My Linux Mint system is starting up and usable, however, I am unable
to complete any scrub as they abort before finished. There are various
inode errors in dmesg. Badblocks (readonly) finds no errors. checking
extents gives bad block 5123372711936 on both /dev/sda2 and /dev/sda2.
A btrfscheck (readonly) results in a 306MB text file of output of root
xxx inode errors.
There are two drives 3TB each in RAID 1 for sda2/sdb2 for which
partition 2 is nearly the entire drive.

Currently I am now using a Manjaro Live Boot with btrfs tools
btrfs-progs v4.10.1 in an attempt to recover/repair what seems to be
bitflip
(The original Linux Mint System has btrfs-progs v4.5.3)

When doing a scrub on '/', the status of /dev/sdb2 aborts always at ~
383GiB with 0 errors. Whereas the /dev/sda2 and thus the '/' scrub
aborts at more diverse values starting at 537.90GiB with 0 errors.

btrfs inspect-internal dump-tree -b 5123372711936 has one item
evidently out of order:
2551224532992 -> 2551253647360 -> 2551251468288

I am currently attempting to copy files off the system while in
Manjaro using rsync prior to attempting whatever the knowlegable
people here recommend. It has resulting in two files not being able to
be read so far, however, a lot of messages in dmesg for btrfs errors
https://ptpb.pw/L9Z9

Pastebins from original machine:
System specs as on original Linux Mint system: https://ptpb.pw/dFz3
dmesg btrfs grep from prior to errors starting until scrub attempts:
https://ptpb.pw/rTzs

Pastebins from subsequent live boot with newer btrfs tools 4.10:
LiveBoot Repair (Manjaro Arch) specs: https://ptpb.pw/ikMM
Scrub failing/aborting at same place on /dev/sdb: https://ptpb.pw/-vcP
badblock_extent_btrfscheck_5123372711936: https://ptpb.pw/T1rD
'btrfs inspect-internal dump-tree -b 5123372711936 /dev/sda2':
https://ptpb.pw/zcyI
'btrfs inspect-internal dump-tree -b 5123372711936 /dev/sdb2':
https://ptpb.pw/zcyI
dmesg on Manjaro attempting to rsync recover files: https://ptpb.pw/L9Z9

I have also just noticed that btrfs causes a complete system crash
when copying a certain file(s).

RTP: [<ffffffffa055b122>] btrfs_check_repairable+0xf2/0x100 [btrfs]
BUG: unable to handle kernel paging request at 000000000dealc93
IP: [<ffffffff810c3e0b>] __wake_up _common+0x2b/0x80
I have taken a photo of the last part of this. As it is in the live
DVD boot distro during repair, it did not save the trace to a file
that would be accessible later.
The photo is at https://pasteboard.co/MTP2OGMK.jpg

Could someone please advise the steps to repair this.

Thankyou

Jesse
