Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50418 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaIUBjV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 21:39:21 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 0453A2082A
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Sep 2014 11:39:18 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: deleting a dead device
Date: Sun, 21 Sep 2014 11:39:17 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201409211139.17295.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On a system running the Debian 3.14.15-2 kernel I added a new drive to a 
RAID-1 array.  My aim was to add a device and remove one of the old devices.

Sep 21 11:26:51 server kernel: [2070145.375221] BTRFS: lost page write due to 
I/O error on /dev/sdc3
Sep 21 11:26:51 server kernel: [2070145.375225] BTRFS: bdev /dev/sdc3 errs: wr 
269, rd 0, flush 0, corrupt 0, gen 0
Sep 21 11:27:21 server kernel: [2070175.517691] BTRFS: lost page write due to 
I/O error on /dev/sdc3
Sep 21 11:27:21 server kernel: [2070175.517699] BTRFS: bdev /dev/sdc3 errs: wr 
270, rd 0, flush 0, corrupt 0, gen 0
Sep 21 11:27:21 server kernel: [2070175.517712] BTRFS: lost page write due to 
I/O error on /dev/sdc3
Sep 21 11:27:21 server kernel: [2070175.517715] BTRFS: bdev /dev/sdc3 errs: wr 
271, rd 0, flush 0, corrupt 0, gen 0
Sep 21 11:27:51 server kernel: [2070205.665947] BTRFS: lost page write due to 
I/O error on /dev/sdc3
Sep 21 11:27:51 server kernel: [2070205.665955] BTRFS: bdev /dev/sdc3 errs: wr 
272, rd 0, flush 0, corrupt 0, gen 0
Sep 21 11:27:51 server kernel: [2070205.665967] BTRFS: lost page write due to 
I/O error on /dev/sdc3
Sep 21 11:27:51 server kernel: [2070205.665971] BTRFS: bdev /dev/sdc3 errs: wr 
273, rd 0, flush 0, corrupt 0, gen 0

Anyway the new drive turned out to have some errors, writes failed and I've 
got a heap of errors such as the above.  The errors started immediately after 
adding the drive and the system wasn't actively writing to the filesystem.  So 
very few (if any) writes made it to the device.

# btrfs device delete /dev/sdc3 /
ERROR: error removing the device '/dev/sdc3' - Invalid argument

It seems that I can't remove the device because removing requires writing.

# btrfs device delete /dev/sdc3 /
ERROR: error removing the device '/dev/sdc3' - No such file or directory
# btrfs device stats /
[/dev/sda3].write_io_errs   0
[/dev/sda3].read_io_errs    0
[/dev/sda3].flush_io_errs   0
[/dev/sda3].corruption_errs 57
[/dev/sda3].generation_errs 0
[/dev/sdb3].write_io_errs   0
[/dev/sdb3].read_io_errs    0
[/dev/sdb3].flush_io_errs   0
[/dev/sdb3].corruption_errs 0
[/dev/sdb3].generation_errs 0
[/dev/sdc3].write_io_errs   267
[/dev/sdc3].read_io_errs    0
[/dev/sdc3].flush_io_errs   0
[/dev/sdc3].corruption_errs 0
[/dev/sdc3].generation_errs 0

The drive is attached by USB so I turned off the USB device and then got the 
above result.  So it still seems impossible to remove the device even though 
it's physically not present.  I've connected a new USB disk which is now 
/dev/sdd, so it seems that BTRFS is keeping the name /dev/sdc locked.

Should there be a way to fix this without rebooting or anything?

Also as an aside, while the stats about write errors are useful, in this case 
it would be really good if there was a count of successful writes, it would be 
useful to know if the successful write count was close to 0.  My understanding 
of the BTRFS design is that there would be no performance penalty for adding 
counts of the number of successful reads and writes to the superblock.  Could 
this be done?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
