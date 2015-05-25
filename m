Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:61508 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbEYQGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 12:06:23 -0400
Received: from oxbsltgw09.schlund.de ([172.19.249.26]) by
 mrelayeu.kundenserver.de (mreue102) with ESMTPSA (Nemesis) id
 0M7sZ6-1ZJ09629Ro-00vKvF for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2015
 18:06:20 +0200
Date: Mon, 25 May 2015 18:06:20 +0200 (CEST)
From: Felix Koop <fdp@fkoop.de>
Reply-To: Felix Koop <fdp@fkoop.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <508094243.133459.1432569980190.JavaMail.open-xchange@oxbsltgw09.schlund.de>
Subject: Help needed to recover a RAID5 btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a RAID5 filesystem where one disk has crashed. Now the filesystem is not
recognized any more. Any help available?

Here is some info:

root@server:~# uname -a
Linux server 4.0.0-1-amd64 #1 SMP Debian 4.0.2-1 (2015-05-11) x86_64 GNU/Linux

root@server:~# btrfs --version
btrfs-progs v4.0

root@server:~# btrfs f sh /dev/Data1vg/afs0
warning, device 3 is missing
warning devid 3 not found already
checksum verify failed on 1111813750784 found 18019A1D wanted FCE227AB
checksum verify failed on 1111813750784 found 18019A1D wanted FCE227AB
bytenr mismatch, want=1111813750784, have=65536
Couldn't read tree root
Label: none uuid: 7d4b023a-a1ef-4991-b01d-31e7c4fdfbcf
 Total devices 3 FS bytes used 213.96GiB
 devid 2 size 150.00GiB used 108.53GiB path /dev/mapper/Data1vg-afs0
 devid 4 size 150.00GiB used 108.53GiB path /dev/mapper/Data3vg-afs0
 *** Some devices missing

btrfs-progs v4.0

root@server:~# mount -o degraded -r /dev/Data1vg/afs0 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/mapper/Data1vg-afs0,
 missing codepage or helper program, or other error

In some cases useful info is found in syslog – try
 dmesg | tail or so.

root@server:~# dmesg | tail
[104991.996065] BTRFS: open_ctree failed
[105527.836798] blk_update_request: I/O error, dev fd0, sector 0
[105527.839477] floppy: error -5 while reading block 0
[105555.615991] BTRFS info (device dm-52): allowing degraded mounts
[105555.616000] BTRFS info (device dm-52): disk space caching is enabled
[105555.665644] BTRFS: bdev (null) errs: wr 38, rd 0, flush 0, corrupt 0, gen 0
[105556.213570] BTRFS (device dm-52): bad tree block start 14290338419558610620
1111828267008
[105556.216649] BTRFS (device dm-52): bad tree block start 14290338419558610620
1111828267008
[105556.219364] BTRFS: Failed to read block groups: -5
[105556.236056] BTRFS: open_ctree failed


If more info is needed, just tell me what I should do. Thanks.

---

Kind greetings

Felix Koop
