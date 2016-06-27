Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35975 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbcF0D5x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 23:57:53 -0400
Received: by mail-qk0-f177.google.com with SMTP id p10so194805507qke.3
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 20:57:52 -0700 (PDT)
MIME-Version: 1.0
From: Nick Austin <nick@smartaustin.com>
Date: Sun, 26 Jun 2016 20:57:32 -0700
Message-ID: <CAPrP9G8gH4szLy3uHmVcH4dBsoze4XhNZA9t-qUxecnwOgYNVg@mail.gmail.com>
Subject: Strange behavior when replacing device on BTRFS RAID 5 array.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 4 device BTRFS RAID 5 filesystem.

One of the device members of this file system (sdr) had badblocks, so I
decided to replace it.

(I don't have a copy of fi show from before the replace. :-/ )

I ran this command:
sudo btrfs replace start 4 /dev/sdw /mnt/newdata

I had to shrink /dev/sdr by ~250 megs since the replacement drive was a tiny bit
smaller.

Jun 25 17:26:52 frank kernel: BTRFS info (device sdr): resizing devid 4
Jun 25 17:26:52 frank kernel: BTRFS info (device sdr): new size for /dev/sdr is
6001175121920
Jun 25 17:27:45 frank kernel: BTRFS info (device sdr): dev_replace from /dev/sdr
 (devid 4) to /dev/sdw started

The replace started, all seemed well.

3 hours into the replace, sdr dropped off the SATA bus and was redetected
as sdx. Bummer, but shouldn't be fatal.

This event really seemed to throw BTRFS for a loop.


Jun 25 20:32:35 frank kernel: sd 10:0:19:0: device_block, handle(0x0019)
Jun 25 20:33:05 frank kernel: sd 10:0:19:0: device_unblock and setting
to running, handle(0x0019)
Jun 25 20:33:05 frank kernel: scsi 10:0:19:0: rejecting I/O to offline device
Jun 25 20:33:05 frank kernel: scsi 10:0:19:0: [sdr] killing request
Jun 25 20:33:05 frank kernel: scsi 10:0:19:0: rejecting I/O to offline device
Jun 25 20:33:05 frank kernel: scsi 10:0:19:0: [sdr] killing request
Jun 25 20:33:05 frank kernel: scsi 10:0:19:0: rejecting I/O to offline device
Jun 25 20:33:05 frank kernel: scsi 10:0:19:0: [sdr] killing request
Jun 25 20:33:05 frank kernel: scsi 10:0:19:0: [sdr] FAILED Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun 25 20:33:05 frank kernel: blk_update_request: I/O error, dev sdr,
sector 1785876480
Jun 25 20:33:05 frank kernel: mpt2sas_cm0: removing handle(0x0019),
sas_addr(0x500194000687e20e)
Jun 25 20:33:05 frank kernel: mpt2sas_cm0: removing : enclosure
logical id(0x500194000687e23f), slot(14)
Jun 25 20:33:16 frank kernel: scsi 10:0:21:0: Direct-Access     ATA
  WL6000GSA12872E  1C01 PQ: 0 ANSI: 5

Here you can see btrfs seems to figure out sdr has become sdx (based on the
"dev /dev/sdx" entry showing up on the BTRFS warning lines).

Unfortunately, all remaining IO for the device formerly known as sdr results in
btrf errors like the ones listed below. iostat confirms no IO on sdx.

Jun 25 20:33:17 frank kernel: sd 10:0:21:0: [sdx] Attached SCSI disk
...
Jun 25 20:33:20 frank kernel: scrub_handle_errored_block: 31983
callbacks suppressed
Jun 25 20:33:20 frank kernel: BTRFS warning (device sdr): i/o error at
logical 2742536544256 on dev /dev/sdx, sector 1786897488, root 5,
inode 222965, offset 296329216, length 4096, links 1 (path:
/path/to/file)
Jun 25 20:33:20 frank kernel: btrfs_dev_stat_print_on_error: 32107
callbacks suppressed

These messages continue for many hours as the replace continues running.

sudo btrfs replace status /mnt/newdata
Started on 25.Jun 17:27:45, finished on 26.Jun 12:48:22, 0 write errs,
0 uncorr. read errs

...
Jun 26 12:48:22 frank kernel: BTRFS warning (device sdr): lost page
write due to IO error on /dev/sdx  (Many, many of these)
Jun 26 12:48:22 frank kernel: BTRFS info (device sdr): dev_replace
from /dev/sdx (devid 4) to /dev/sdw finished


Great! /dev/sdx replaced by /dev/sdw!

Now let's confirm:

sudo btrfs fi show /mnt/newdata
Label: '/var/data'  uuid: e4a2eb77-956e-447a-875e-4f6595a5d3ec
        Total devices 4 FS bytes used 8.07TiB
        devid    1 size 5.46TiB used 2.70TiB path /dev/sdg
        devid    2 size 5.46TiB used 2.70TiB path /dev/sdl
        devid    3 size 5.46TiB used 2.70TiB path /dev/sdm
        devid    4 size 5.46TiB used 2.70TiB path /dev/sdx

Bummer, this doesn't look right.

sdx is still in the array (failing drive).

Additionally, /dev/sdw isn't listed at all! Worse still, it looks like the
array has lost redundancy (it has 8TiB of data, and that's the amount shown as
used divided by number of devices). It looks like it tried to add the new
device, but did a balance across all of them instead?

% sudo btrfs fi df /mnt/newdata
Data, RAID5: total=8.07TiB, used=8.06TiB
System, RAID10: total=80.00MiB, used=576.00KiB
Metadata, RAID10: total=12.00GiB, used=10.26GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Any advice would be appreciated.

%  uname -a
Linux frank 4.5.5-201.fc23.x86_64 #1 SMP Sat May 21 15:29:49 UTC 2016 x86_64
x86_64 x86_64 GNU/Linux

% lsb_release
Description:    Fedora release 24 (Twenty Three)

% btrfs --version
btrfs-progs v4.4.1
