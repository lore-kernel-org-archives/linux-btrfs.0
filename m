Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:50875 "EHLO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbaJ1Qts (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 12:49:48 -0400
Received: from unknown (HELO undercity) (as13914087@sapo.pt@[5.43.61.212])
          (envelope-sender <ab@tevsa.net>)
          by mta-auth02 (qmail-ptmail-1.0.0) with SMTP
          for <linux-btrfs@vger.kernel.org>; 28 Oct 2014 16:49:39 -0000
Received: from [10.5.2.101] (faraday.azeroth.net [10.5.2.101])
	by undercity (Postfix) with ESMTP id 1280D687713
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 16:49:38 +0000 (WET)
Message-ID: <544FC921.2090900@tevsa.net>
Date: Tue, 28 Oct 2014 16:49:37 +0000
From: Alec Blayne <ab@tevsa.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Btrfs raid1 array has issues with rtorrent usage pattern.
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, it seems that when using rtorrent to download into a btrfs system,
it leads to the creation of files that fail to read properly.
For instance, I get rtorrent to crash, but if I try to rsync the file he
was writting into someplace else, rsync also fails with the message
"can't map file "$file": Input/Output error (5)".
If I give it time, eventually the file gets into a good state and I can
rsync it somewhere else (as long as rtorrent doesn't keep writting into
it). This doesn't happen using ext4 on the same system.

No btrfs errors, or any other errors, show up in any log. Scrubbing or
balancing don't turn up any issues. I've tried using a subvolume mounted
with nodatacow and/or flushoncommit, which didn't help. I'm not using
quotas and at some point had a single snapshot that I deleted. The
filesystem was originally created recently (on a 3.16.4+ kernel).

Here's what the array looks like:

Label: 'data'  uuid: ffe83a3d-f4ba-46b7-8424-4ec3380cb811
        Total devices 4 FS bytes used 3.14TiB
        devid    4 size 2.73TiB used 2.36TiB path /dev/sdd1
        devid    5 size 1.82TiB used 1.45TiB path /dev/sdc1
        devid    6 size 1.82TiB used 1.45TiB path /dev/sdb1
        devid    7 size 1.82TiB used 1.45TiB path /dev/sda1

Btrfs v3.17

Data, RAID1: total=3.34TiB, used=3.13TiB
System, RAID1: total=32.00MiB, used=512.00KiB
Metadata, RAID1: total=10.00GiB, used=7.31GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


On linux 3.17.1: Linux 3.17.1-gentoo-r1 #3 SMP PREEMPT Tue Oct 28
02:43:11 WET 2014 x86_64 AMD Athlon(tm) 5350 APU with Radeon(tm) R3
AuthenticAMD GNU/Linux

I'm utterly puzzled and clueless at how to dig into this issue.
