Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:50849 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751750Ab2JZK5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 06:57:31 -0400
Received: from 168.139.79.188.dynamic.jazztel.es ([188.79.139.168] helo=mail.viric.name)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1TRhbS-000BrN-S2
	for linux-btrfs@vger.kernel.org; Fri, 26 Oct 2012 10:57:27 +0000
Date: Fri, 26 Oct 2012 12:57:22 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Can't replace a faulty disk of raid1
Message-ID: <20121026105721.GU2052@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had a raid1 btrfs (540GB) on vanilla 3.6.3, a disk failed, and removed it at
power off, plugged in a new one, partitioned it (to 110GB, by error), and added
it to btrfs.

I tried to remove the missing device, and it said "Input/output error" after a
while. Next attempts simply gave "Invalid argument".

I repartitioned, rebooted the system, and made the partition grow: "btrfs fi
resize 3:max /"

# btrfs fi show
Label: 'mainbtrfs'  uuid: 2ebf9e90-104c-47a4-adff-fada1ce3b682
    Total devices 3 FS bytes used 445.06GB
    devid    1 size 539.95GB used 539.95GB path /dev/sda5
    devid    3 size 539.95GB used 96.90GB path /dev/sdb1   <= New disk
    *** Some devices missing

The size appeared fine (I checked it at byte-amount level, to ensure I have not
set 4K smaller for example). But attempting the 'btrfs device delete missing /'
again gave the same outcome.

I tried "btrfs balance start /", and after a while, also ends with "Input/output
error". In any of the cases above, I have an error message in dmesg. dmesg only
shows usual 'relocating block...' and 'found 4 extents'.

I see that the /dev/sdb1, in any operation above I do, never goes beyond those 'used
96.90GB'. So, I'm stuck not being able to go back to raid1, with a degraded
mount.

Some data:

# btrfs fi df /
Data, RAID1: total=507.62GB, used=417.08GB
Data: total=25.32GB, used=22.48GB
System, RAID1: total=32.00MB, used=92.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=19.97GB, used=5.50GB

Mount log:
[   10.939163] device label mainbtrfs devid 1 transid 194548 /dev/sda5
[   10.939856] btrfs: allowing degraded mounts
[   10.939939] btrfs: disk space caching is enabled
[   10.940652] warning devid 2 missing
[   10.987500] btrfs: bdev (null) errs: wr 6702, rd 2632, flush 312, corrupt 1970, gen 573
[   10.987636] btrfs: bdev /dev/sda5 errs: wr 52, rd 13, flush 0, corrupt 2, gen 8
[   14.391309] btrfs: unlinked 1 orphans
[   22.319849] btrfs: use lzo compression
[   22.319937] btrfs: disk space caching is enabled
[   27.481405] udevd[1451]: starting version 173
[   28.493786] device label mainbtrfs devid 3 transid 194549 /dev/sdb1
[   28.930870] device fsid 30781650-3053-4273-b640-ec86a442c945 devid 1 transid 2272 /dev/sda3
[   28.947632] device label mainbtrfs devid 1 transid 194549 /dev/sda5


Any help?

Thank you,
Lluís.
