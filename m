Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34361 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbcFLVW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 17:22:27 -0400
Received: by mail-lf0-f66.google.com with SMTP id k192so9774674lfb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 14:22:27 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Maximilian_B=C3=B6hm?= <winlux@gmail.com>
Date: Sun, 12 Jun 2016 23:22:11 +0200
Message-ID: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
Subject: dd on wrong device, 1.9 GiB from the beginning has been overwritten,
 how to restore partition?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there, I did something terribly wrong, all blame on me. I wanted to
write to an USB stick but /dev/sdc wasn't the stick in this case but
an attached HDD with GPT and an 8 TB btrfs partition…

$ sudo dd bs=4M if=manjaro-kde-16.06.1-x86_64.iso of=/dev/sdc
483+1 Datensätze ein
483+1 Datensätze aus
2028060672 bytes (2,0 GB, 1,9 GiB) copied, 16,89 s, 120 MB/s

So, shit.

$ sudo btrfs check --repair /dev/sdc
enabling repair mode
No valid Btrfs found on /dev/sdc
Couldn't open file system

$ sudo btrfs-find-root /dev/sdc
No valid Btrfs found on /dev/sdc
ERROR: open ctree failed

$ sudo btrfs-show-super /dev/sdc --all
superblock: bytenr=65536, device=/dev/sdc
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/sdc at 65536

superblock: bytenr=67108864, device=/dev/sdc
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/sdc at 67108864

superblock: bytenr=274877906944, device=/dev/sdc
---------------------------------------------------------
ERROR: bad magic on superblock on /dev/sdc at 274877906944


System infos:

$ uname -a
Linux Mongo 4.6.2-1-MANJARO #1 SMP PREEMPT Wed Jun 8 11:00:08 UTC 2016
x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.5.3

Don't think dmesg is necessary here.


OK, the btrfs wiki says there is a second superblock at 64 MiB
(overwritten too in my case) and a third at 256 GiB ("0x4000000000").
But how to restore it? And how to restore the general btrfs header
metadata? How to restore GPT without doing something terrible again?
Would be glad for any help!
