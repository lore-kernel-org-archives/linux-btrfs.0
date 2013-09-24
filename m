Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49868 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756705Ab3IYBOF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 21:14:05 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:50731 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VOb7k-000L2i-66
	for linux-btrfs@vger.kernel.org; Tue, 24 Sep 2013 16:30:28 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: balance induced csum errors
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
Date: Tue, 24 Sep 2013 16:30:25 -0600
Message-Id: <ACEE693A-F96D-4ADA-AB7B-AC53BAFCD9AD@colorremedies.com>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com> <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com> <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK so now I'm able to reproduce this with Fedora 20 alpha RC4 on a HDD, which uses:

kernel-3.11.1-300.fc20.x86_64
btrfs-progs-0.20.rc1.20130917git194aa4a-1.fc20.x86_64

Since it's HDD, metadata profile DUP is used. But I still get munged checksums with balance, and the corruption isn't fixable by a subsequent scrub. So even though the data is probably OK and this is just a checksum problem, it's apparently not fixable (?).

[root@oldlaptop ~]# btrfs balance start /
Done, had to relocate 5 out of 5 chunks

[root@oldlaptop ~]# dmesg (snippet)
[  390.770699] btrfs: relocating block group 1103101952 flags 1
[  406.639113] btrfs: found 10341 extents
[  414.172873] btrfs: found 10331 extents
[  414.530059] btrfs: relocating block group 29360128 flags 36
[  418.761208] btrfs: found 9281 extents
[  419.136338] btrfs: relocating block group 20971520 flags 34
[  419.536539] btrfs: found 1 extents
[  419.880757] btrfs: relocating block group 12582912 flags 1
[  420.380511] btrfs: found 282 extents
[  421.080667] btrfs: found 282 extents
[  421.426891] btrfs: relocating block group 4194304 flags 4



[root@oldlaptop ~]# btrfs scrub start /
scrub started on /, fsid 1463a31b-472a-47cd-a8c8-86bf09f978fa (pid=894)

[root@oldlaptop ~]# dmesg (snippet)
[  460.533990] btrfs: checksum error at logical 2607853568 on dev /dev/sda5, sector 7207000, root 256, inode 24622, offset 4247552, length 4096, links 1 (path: var/log/journal/d212cf4a840f4e78a33781c56189a7da/system.journal)
[  460.534045] btrfs: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[  460.534082] btrfs: unable to fixup (regular) error at logical 2607853568 on dev /dev/sda5
[  460.534581] btrfs: checksum error at logical 2607869952 on dev /dev/sda5, sector 7207032, root 256, inode 24622, offset 4263936, length 4096, links 1 (path: var/log/journal/d212cf4a840f4e78a33781c56189a7da/system.journal)
[  460.534594] btrfs: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[  460.534614] btrfs: unable to fixup (regular) error at logical 2607869952 on dev /dev/sda5
[  460.535128] btrfs: checksum error at logical 2607886336 on dev /dev/sda5, sector 7207064, root 256, inode 24622, offset 4280320, length 4096, links 1 (path: var/log/journal/d212cf4a840f4e78a33781c56189a7da/system.journal)
[  460.535140] btrfs: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
[  460.535161] btrfs: unable to fixup (regular) error at logical 2607886336 on dev /dev/sda5
[  460.535607] btrfs: checksum error at logical 2607902720 on dev /dev/sda5, sector 7207096, root 256, inode 24622, offset 4296704, length 4096, links 1 (path: var/log/journal/d212cf4a840f4e78a33781c56189a7da/system.journal)
[  460.535619] btrfs: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
[  460.535639] btrfs: unable to fixup (regular) error at logical 2607902720 on dev /dev/sda5
[  460.536421] btrfs: checksum error at logical 2608025600 on dev /dev/sda5, sector 7207336, root 256, inode 24622, offset 4313088, length 4096, links 1 (path: var/log/journal/d212cf4a840f4e78a33781c56189a7da/system.journal)
[  460.536437] btrfs: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
[  460.536457] btrfs: unable to fixup (regular) error at logical 2608025600 on dev /dev/sda5
[  460.779192] btrfs: checksum error at logical 2626674688 on dev /dev/sda5, sector 7243760, root 256, inode 24622, offset 4595712, length 4096, links 1 (path: var/log/journal/d212cf4a840f4e78a33781c56189a7da/system.journal)
[  460.779210] btrfs: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
[  460.779245] btrfs: unable to fixup (regular) error at logical 2626674688 on dev /dev/sda5
[  460.779822] btrfs: checksum error at logical 2626715648 on dev /dev/sda5, sector 7243840, root 256, inode 24622, offset 4231168, length 4096, links 1 (path: var/log/journal/d212cf4a840f4e78a33781c56189a7da/system.journal)
[  460.779834] btrfs: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[  460.779854] btrfs: unable to fixup (regular) error at logical 2626715648 on dev /dev/sda5


And now on reboot:
[root@f20s ~]# dmesg | grep -i btrfs
[    1.725224] Btrfs loaded
[    1.980491] btrfs: disk space caching is enabled
[    2.001684] btrfs: bdev /dev/sda5 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[    3.011628] SELinux: initialized (dev sda5, type btrfs), uses xattr
[    5.092593] btrfs: disk space caching is enabled
[    8.703883] btrfs no csum found for inode 24622 start 4235264
[    8.844562] btrfs no csum found for inode 24622 start 4251648
[    8.844589] btrfs no csum found for inode 24622 start 4272128
[    8.844611] btrfs no csum found for inode 24622 start 4288512
[    8.844632] btrfs no csum found for inode 24622 start 4304896
[    8.844658] btrfs no csum found for inode 24622 start 4321280
[    8.856069] BTRFS info (device sda5): csum failed ino 24622 off 4251648 csum 1113579642 private 0
[    8.856084] BTRFS info (device sda5): csum failed ino 24622 off 4272128 csum 2433646103 private 0
[    8.856092] BTRFS info (device sda5): csum failed ino 24622 off 4288512 csum 2276263411 private 0
[    8.857248] BTRFS info (device sda5): csum failed ino 24622 off 4304896 csum 1156822344 private 0
[    8.857424] BTRFS info (device sda5): csum failed ino 24622 off 4321280 csum 3967991073 private 0
[    8.867242] BTRFS info (device sda5): csum failed ino 24622 off 4235264 csum 172180530 private 0



Other info:
[root@oldlaptop ~]# btrfs fi show
bfailed to open /dev/sr0: No medium found
Label: 'fedora'  uuid: 1463a31b-472a-47cd-a8c8-86bf09f978fa
	Total devices 1 FS bytes used 700.04MB
	devid    1 size 432.62GB used 3.04GB path /dev/sda5

Btrfs v0.20-rc1
[root@oldlaptop ~]# btrfs fi df /
Data: total=1.01GB, used=662.47MB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=37.57MB
Metadata: total=8.00MB, used=0.00



Chris Murphy