Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49868 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756924Ab3IYBOG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 21:14:06 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50365 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VOaHW-0001JW-S2
	for linux-btrfs@vger.kernel.org; Tue, 24 Sep 2013 15:36:31 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: balance induced csum errors
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
Date: Tue, 24 Sep 2013 15:36:28 -0600
Message-Id: <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com> <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm able to reproduce this on a different drive, HDD (WDC WD5000BEVT-22ZAT0), also with data and metadata set to single. There are no problems reported when scrubbing before balance, and then there is corruption reported after balance.

File system is created with:
kernel-3.9.5-301.fc19.x86_64
btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19.x86_64


Then updated to:
kernel-3.11.1-200.fc19.x86_64
btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19.x86_64

Then scrubbed with no errors.
Then balanced with no errors (unlike the previous report with SSD which stopped)
Then scrubbed with errors, see below the balance followed by 2nd scrub.



[  226.333352] btrfs: relocating block group 2168455168 flags 1
[  233.032499] btrfs: found 2816 extents
[  234.522162] btrfs: found 2816 extents
[  234.818501] btrfs: relocating block group 1094713344 flags 1
[  261.631679] btrfs: found 13255 extents
[  266.133269] btrfs: found 13254 extents
[  266.464119] btrfs: relocating block group 20971520 flags 4
[  268.665678] btrfs: found 2018 extents
[  268.976324] btrfs: relocating block group 12582912 flags 1
[  269.397991] btrfs: found 246 extents
[  269.931383] btrfs: found 246 extents
[  270.209504] btrfs: relocating block group 4194304 flags 4
[  270.642570] btrfs: found 378 extents
[  318.029771] btrfs: checksum error at logical 2209439744 on dev /dev/sda4, sector 6412464, root 256, inode 25764, offset 6746112, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  318.029793] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[  318.029827] btrfs: unable to fixup (regular) error at logical 2209439744 on dev /dev/sda4
[  318.045206] btrfs: checksum error at logical 2207895552 on dev /dev/sda4, sector 6409448, root 256, inode 25764, offset 6668288, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  318.045211] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[  318.045224] btrfs: unable to fixup (regular) error at logical 2207895552 on dev /dev/sda4
[  318.172649] btrfs: checksum error at logical 2211979264 on dev /dev/sda4, sector 6417424, root 256, inode 25764, offset 7389184, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  318.172657] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
[  318.172671] btrfs: unable to fixup (regular) error at logical 2211979264 on dev /dev/sda4
[  318.175607] btrfs: checksum error at logical 2212261888 on dev /dev/sda4, sector 6417976, root 256, inode 25764, offset 7065600, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  318.175611] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
[  318.175619] btrfs: unable to fixup (regular) error at logical 2212261888 on dev /dev/sda4
[  318.175979] btrfs: checksum error at logical 2212278272 on dev /dev/sda4, sector 6418008, root 256, inode 25764, offset 7081984, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  318.175984] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
[  318.175992] btrfs: unable to fixup (regular) error at logical 2212278272 on dev /dev/sda4
[  318.200069] btrfs: checksum error at logical 2213355520 on dev /dev/sda4, sector 6420112, root 256, inode 25764, offset 7581696, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  318.200074] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
[  318.200083] btrfs: unable to fixup (regular) error at logical 2213355520 on dev /dev/sda4
[  318.207868] btrfs: checksum error at logical 2214825984 on dev /dev/sda4, sector 6422984, root 256, inode 25764, offset 7806976, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  318.207872] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[  318.207881] btrfs: unable to fixup (regular) error at logical 2214825984 on dev /dev/sda4
[  323.564405] btrfs: checksum error at logical 2650460160 on dev /dev/sda4, sector 7273832, root 256, inode 25764, offset 4247552, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  323.564422] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 8, gen 0
[  323.564456] btrfs: unable to fixup (regular) error at logical 2650460160 on dev /dev/sda4
[  325.307954] btrfs: checksum error at logical 2792796160 on dev /dev/sda4, sector 7551832, root 256, inode 25764, offset 5857280, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  325.307975] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 9, gen 0
[  325.308088] btrfs: unable to fixup (regular) error at logical 2792796160 on dev /dev/sda4
[  325.317607] btrfs: checksum error at logical 2791784448 on dev /dev/sda4, sector 7549856, root 256, inode 25764, offset 5378048, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  325.317621] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 10, gen 0
[  325.317648] btrfs: unable to fixup (regular) error at logical 2791784448 on dev /dev/sda4
[  325.431833] btrfs: checksum error at logical 2791858176 on dev /dev/sda4, sector 7550000, root 256, inode 25764, offset 5455872, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  325.431849] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 11, gen 0
[  325.431877] btrfs: unable to fixup (regular) error at logical 2791858176 on dev /dev/sda4
[  325.432530] btrfs: checksum error at logical 2791907328 on dev /dev/sda4, sector 7550096, root 256, inode 25764, offset 5505024, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  325.432543] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 12, gen 0
[  325.432567] btrfs: unable to fixup (regular) error at logical 2791907328 on dev /dev/sda4
[  327.321507] btrfs: checksum error at logical 2792157184 on dev /dev/sda4, sector 7550584, root 256, inode 25764, offset 5758976, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  327.321525] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 13, gen 0
[  327.321560] btrfs: unable to fixup (regular) error at logical 2792157184 on dev /dev/sda4
[  329.996557] btrfs: checksum error at logical 3165069312 on dev /dev/sda4, sector 8278928, root 256, inode 25764, offset 6369280, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  329.996575] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 14, gen 0
[  329.996604] btrfs: unable to fixup (regular) error at logical 3165069312 on dev /dev/sda4
[  329.997239] btrfs: checksum error at logical 3165126656 on dev /dev/sda4, sector 8279040, root 256, inode 25764, offset 6430720, length 4096, links 1 (path: var/log/journal/10db2764a11a4829bf82a94c6559d121/system.journal)
[  329.997253] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 15, gen 0
[  329.997279] btrfs: unable to fixup (regular) error at logical 3165126656 on dev /dev/sda4



Also on reboot now it is reported:

[root@f19s ~]# dmesg | grep -i btrfs
[    1.835049] Btrfs loaded
[    1.966412] btrfs: disk space caching is enabled
[    1.980436] btrfs: bdev /dev/sda4 errs: wr 0, rd 0, flush 0, corrupt 15, gen 0
[    3.233524] SELinux: initialized (dev sda4, type btrfs), uses xattr
[    4.316491] btrfs: disk space caching is enabled
[    9.715052] btrfs no csum found for inode 25764 start 6402048
[    9.715503] btrfs no csum found for inode 25764 start 6754304
[    9.827785] BTRFS info (device sda4): csum failed ino 25764 off 6402048 csum 3000251694 private 0
[   10.204708] BTRFS info (device sda4): csum failed ino 25764 off 6754304 csum 1612034066 private 0
[   11.187301] btrfs no csum found for inode 25764 start 7393280
[   11.187578] btrfs no csum found for inode 25764 start 7585792
[   11.187866] btrfs no csum found for inode 25764 start 7819264
[   11.403389] BTRFS info (device sda4): csum failed ino 25764 off 7393280 csum 3889482771 private 0
[   11.427616] BTRFS info (device sda4): csum failed ino 25764 off 7819264 csum 4086456643 private 0
[   11.486405] BTRFS info (device sda4): csum failed ino 25764 off 7585792 csum 3911271769 private 0



Chris Murphy