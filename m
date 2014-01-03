Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:54880 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbaACWZx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 17:25:53 -0500
Received: from [192.168.0.50] (mail.coastalscience.com [66.83.151.234])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim@jrs-s.net)
	by mail.jrs-s.net (Postfix) with ESMTPSA id 6236CD2A4
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jan 2014 17:25:53 -0500 (EST)
Message-ID: <52C73987.7000106@jrs-s.net>
Date: Fri, 03 Jan 2014 17:28:23 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using Ubuntu 12.04.3 with an up-to-date 3.11 kernel, and the 
btrfs-progs from Debian Sid (since the ones from Ubuntu are ancient).

I discovered to my horror during testing today that neither raid1 nor 
raid10 arrays are fault tolerant of losing an actual disk.

mkfs.btrfs -d raid10 -m raid10 /dev/vdc /dev/vdd /dev/vdd /dev/vde
mkdir /test
mount /dev/vdb /test
echo "test" > /test/test
btrfs filesystem sync /test
shutdown -hP now

After shutting down the VM, I can remove ANY of the drives from the 
btrfs raid10 array, and be unable to mount the array. In this case, I 
removed the drive that was at /dev/vde, then restarted the VM.

btrfs fi show
Label: none  uuid: 94af1f5d-6ad2-4582-ab4a-5410c410c455
         Total devices 4 FS bytes used 156.00KB
          devid    3 size 1.00GB used 212.75MB path /dev/vdd
          devid    3 size 1.00GB used 212.75MB path /dev/vdc
          devid    3 size 1.00GB used 232.75MB path /dev/vdb
          *** Some devices missing

OK, we have three of four raid10 devices present. Should be fine. Let's 
mount it:

mount -t btrfs /dev/vdb /test
mount: wrong fs type, bad option, bad superblock on /dev/vdb,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail or so

What's the kernel log got to say about it?

dmesg | tail -n 4
[  536.694363] device fsid 94af1f5d-6ad2-4582-ab4a-5410c410c455 devid 1 
transid 7 /dev/vdb
[  536.700515] btrfs: disk space caching is enabled
[  536.703491] btrfs: failed to read the system array on vdd
[  536.708337] btrfs: open_ctree failed

Same behavior persists whether I create a raid1 or raid10 array, and 
whether I create it as that raid level using mkfs.btrfs or convert it 
afterwards using btrfs balance start -dconvert=raidn -mconvert=raidn. 
Also persists even if I both scrub AND sync the array before shutting 
the machine down and removing one of the disks.

What's up with this? This is a MASSIVE bug, and I haven't seen anybody 
else talking about it... has nobody tried actually failing out a disk 
yet, or what?
