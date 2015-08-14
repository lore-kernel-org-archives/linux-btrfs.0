Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43157 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbbHNA00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 20:26:26 -0400
Received: from athena.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 71AA2ECEE
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 10:26:22 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: "=?utf-8?q?=E2=80=9Clinux-btrfs?=@
	=?utf-8?q?vger=2Ekernel=2Eorg=E2=80=9D?="
	<linux-btrfs@vger.kernel.org>
Subject: lack of scrub error data
Date: Fri, 14 Aug 2015 10:26:20 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201508141026.20762.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Below is the result of testing a corrupted filesystem.  What's going on here?  
The kernel message log and the btrfs output don't tell me how many errors 
there were.  Also the data is RAID-0 (the default for a filesystem created with 
2 devices) so if this was in a data area it should have lost data, but no data 
was lost so apparently not.

Debian kernel 4.0.8-2 and btrfs-tools 4.0-2.

# cp -r /lib /mnt/tmp
# btrfs scrub start -B /mnt/tmp
scrub done for c0992a26-3c7f-47b0-b8de-878dfe197469
        scrub started at Fri Aug 14 10:17:53 2015 and finished after 0 seconds
        total bytes scrubbed: 372.82MiB with 0 errors
# dd if=/dev/zero of=/dev/loop0 bs=1024k count=20 seek=100
20+0 records in
20+0 records out
20971520 bytes (21 MB) copied, 0.0267078 s, 785 MB/s
# btrfs scrub start -B /mnt/tmp
scrub done for c0992a26-3c7f-47b0-b8de-878dfe197469
        scrub started at Fri Aug 14 10:19:15 2015 and finished after 0 seconds
        total bytes scrubbed: 415.04MiB with 0 errors
WARNING: errors detected during scrubbing, corrected.
# btrfs scrub start -B /mnt/tmp
scrub done for c0992a26-3c7f-47b0-b8de-878dfe197469 
        scrub started at Fri Aug 14 10:20:25 2015 and finished after 0 seconds
        total bytes scrubbed: 415.04MiB with 0 errors
# btrfs fi df /mnt/tmp
Data, RAID0: total=800.00MiB, used=400.23MiB
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=400.00MiB, used=7.39MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=16.00MiB, used=0.00B
# btrfs device stats /mnt/tmp
[/dev/loop0].write_io_errs   0
[/dev/loop0].read_io_errs    0
[/dev/loop0].flush_io_errs   0
[/dev/loop0].corruption_errs 0
[/dev/loop0].generation_errs 0
[/dev/loop1].write_io_errs   0
[/dev/loop1].read_io_errs    0
[/dev/loop1].flush_io_errs   0
[/dev/loop1].corruption_errs 0
[/dev/loop1].generation_errs 0
# diff -ru /lib /mnt/tmp/lib
#

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
