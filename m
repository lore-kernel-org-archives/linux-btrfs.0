Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.wth.in ([37.235.56.71]:53110 "EHLO mail.wth.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbHXLUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 07:20:43 -0400
Received: from wth.in (mail.wth.in [37.235.56.71])
	(Authenticated sender: jan@wth.in)
	by mail.wth.in (Postfix) with ESMTPSA id ABB1B80AE5
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 13:20:41 +0200 (CEST)
Mime-Version: 1.0
Date: Mon, 24 Aug 2015 11:20:41 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <82aaa9565d7e4304b47cbccb63eddae4@wth.in>
From: jan@wth.in
Subject: Trying to balance/delete after drive failure
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Guys,

I am running a raid1 btrfs with 4 disks. One of my disks died the other day. So I replaced it with a new one. After that I tried to delete the failed (now missing) disk. This resulted in some but not much IO and some messages like these:

kernel: BTRFS info (device sdd): found 9 extents
kernel: [22138.202334] BTRFS info (device sdd): relocating block group 10093403832320 flags 17

Perf show this:
  47.21%  [kernel]                    [k] rb_next
  29.89%  [kernel]                    [k] comp_entry
   9.54%  [kernel]                    [k] btrfs_merge_delayed_refs

And top this:
27742 root      20   0       0      0      0 R 100.0  0.0  19:22.90 kworker/u8:7

But at one point no new messages appeared and no IO could be seen. I thought maybe the process hung. So I rebooted the machine. After that I tried a balance with the same result.

Here some information that might be important:

uname -a
Linux thales 4.1.5-100.fc21.x86_64 #1 SMP Tue Aug 11 00:24:23 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

###

btrfs --version
btrfs-progs v4.1

###

btrfs --version
btrfs-progs v4.1
[root@thales ~]# btrfs fi show
Label: 'data'  uuid: 1f7e44b4-39ed-475d-b341-93b2e44f8f89
        Total devices 5 FS bytes used 3.40TiB
        devid    1 size 2.73TiB used 2.58TiB path /dev/sdb
        devid    4 size 931.51GiB used 779.00GiB path /dev/sde
        devid    5 size 931.51GiB used 779.00GiB path /dev/sdd
        devid    6 size 5.46TiB used 379.00GiB path /dev/sda
        *** Some devices missing

btrfs-progs v4.1

###

btrfs fi df /mnt/data/
Data, RAID1: total=3.46TiB, used=3.40TiB
System, RAID1: total=32.00MiB, used=528.00KiB
Metadata, RAID1: total=9.00GiB, used=7.63GiB
GlobalReserve, single: total=512.00MiB, used=15.74MiB

###

dmesg
[...]
[33209.949992] BTRFS info (device sdd): found 11 extents
[33244.802181] BTRFS info (device sdd): found 11 extents
[33247.178590] BTRFS info (device sdd): relocating block group 9826042118144 flags 20

###

Thanks for your help,
Jan
