Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from neo-zeon.de ([173.228.7.105]:60216 "EHLO neo-zeon.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760033Ab3HNWZa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 18:25:30 -0400
Received: from [10.20.23.68] (70-35-47-130.static.wiline.com [70.35.47.130])
	(authenticated bits=0)
	by neo-zeon.de (8.14.7/8.14.5) with ESMTP id r7EMHlKZ009826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 15:17:50 -0700 (PDT)
	(envelope-from cam@neo-zeon.de)
Message-ID: <520C0206.1040900@neo-zeon.de>
Date: Wed, 14 Aug 2013 15:17:42 -0700
From: Cameron Berkenpas <cam@neo-zeon.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: unable to fixup (regular) error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I hope this is the correct mailing list.

I have btrfs running on a 6TB (5.5ish TiB) raid10 array on a 3ware 
9750-4i controller. I decided to run a script and a got 5 checksum 
errors for the same file (errors from dmesg below).

I deleted the file without any issues, reran scrub, and now I don't see 
any errors. The file itself was unimportant as it was from a backup of 
another box that I already have multiple backups of (and the box itself 
is still fine). The disks in the array appear to all be fine and the 
array is also healthy. I also run "verify" regularly. Verify appears to 
be the controller's equivalent to scrub.

Additionally, according to smartctl, things are healthly although it 
seems error logging isn't supported:
Vendor:               LSI
Product:              9750-4i    DISK
Revision:             5.12
User Capacity:        5,999,977,037,824 bytes [5.99 TB]
Logical block size:   512 bytes
Logical Unit id:      0x600050e016538a004567000011970000
Serial number:        9XK0C13D16538A004567
Device type:          disk
Local Time is:        Wed Aug 14 15:15:42 2013 PDT
Device supports SMART and is Disabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Error Counter logging not supported
Device does not support Self Test logging

Any idea what may have happened here? Is this something to worry about?

Thanks,

-Cameron

[101511.280510] btrfs: checksum error at logical 1590664605696 on dev 
/dev/sda3, sector 3119366104, root 681, inode 1668516, offset 3473408, 
length 4096, links 1 (path: path/to/some/file)
[101511.288676] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 
1, gen 0
[101511.291611] btrfs: unable to fixup (regular) error at logical 
1590664605696 on dev /dev/sda3
[101511.390081] btrfs: checksum error at logical 1590664609792 on dev 
/dev/sda3, sector 3119366112, root 681, inode 1668516, offset 3477504, 
length 4096, links 1 (path: path/to/some/file)
[101511.399321] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 
2, gen 0
[101511.402552] btrfs: unable to fixup (regular) error at logical 
1590664609792 on dev /dev/sda3
[101511.406038] btrfs: checksum error at logical 1590664613888 on dev 
/dev/sda3, sector 3119366120, root 681, inode 1668516, offset 3481600, 
length 4096, links 1 (path: path/to/some/file)
[101511.416438] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 
3, gen 0
[101511.420050] btrfs: unable to fixup (regular) error at logical 
1590664613888 on dev /dev/sda3
[101511.424238] btrfs: checksum error at logical 1590664617984 on dev 
/dev/sda3, sector 3119366128, root 681, inode 1668516, offset 3485696, 
length 4096, links 1 (path: path/to/some/file)
[101511.435928] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 
4, gen 0
[101511.440241] btrfs: unable to fixup (regular) error at logical 
1590664617984 on dev /dev/sda3
[101511.523988] btrfs: checksum error at logical 1590664622080 on dev 
/dev/sda3, sector 3119366136, root 681, inode 1668516, offset 3489792, 
length 4096, links 1 (path: path/to/some/file)
[101511.537097] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 
5, gen 0
[101511.541636] btrfs: unable to fixup (regular) error at logical 
1590664622080 on dev /dev/sda3



