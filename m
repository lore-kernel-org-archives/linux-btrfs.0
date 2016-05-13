Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35911 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbcEMEtc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 00:49:32 -0400
Received: by mail-pa0-f43.google.com with SMTP id bt5so36313072pac.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 21:49:32 -0700 (PDT)
Message-ID: <1463114957.3636.140.camel@clone1.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: "Richard A. Lochner" <lochner@clone1.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Thu, 12 May 2016 23:49:17 -0500
In-Reply-To: <CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
	 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
	 <1463075341.3636.56.camel@clone1.com>
	 <CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

See notes inline.

On Thu, 2016-05-12 at 19:41 -0600, Chris Murphy wrote:
> On Thu, May 12, 2016 at 11:49 AM, Richard A. Lochner <lochner@clone1.
> com> wrote:
> 
> > 
> > I suspected, and I still suspect that the error occurred upon a
> > metadata update that corrupted the checksum for the file, probably
> > due
> > to silent memory corruption.  If the checksum was silently
> > corrupted,
> > it would be simply written to both drives causing this type of
> > error.
> Metadata is checksummed independently of data. So if the data isn't
> updated, its checksum doesn't change, only metadata checksum is
> changed.
> > 
> > 
> > btrfs dmesg(s):
> > 
> > [16510.334020] BTRFS warning (device sdb1): checksum error at
> > logical
> > 3037444042752 on dev /dev/sdb1, sector 4988789496, root 259, inode
> > 1437377, offset 75754369024, length 4096, links 1 (path:
> > Rick/sda4.img)
> > [16510.334043] BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr
> > 0, rd
> > 0, flush 0, corrupt 5, gen 0
> > [16510.345662] BTRFS error (device sdb1): unable to fixup (regular)
> > error at logical 3037444042752 on dev /dev/sdb1
> > 
> > [17606.978439] BTRFS warning (device sdb1): checksum error at
> > logical
> > 3037444042752 on dev /dev/sdc1, sector 4988750584, root 259, inode
> > 1437377, offset 75754369024, length 4096, links 1 (path:
> > Rick/sda4.img)
> > [17606.978460] BTRFS error (device sdb1): bdev /dev/sdc1 errs: wr
> > 0, rd
> > 13, flush 0, corrupt 4, gen 0
> > [17606.989497] BTRFS error (device sdb1): unable to fixup (regular)
> > error at logical 3037444042752 on dev /dev/sdc1
> This is confusing. Are these the same boot? The later time has a
> lower
> corrupt count. Can you just 'dd if=sda4.img of=/dev/null' and report
> all (new) messages in dmesg? It seems to me there should be pretty
> much all the same monotonic-time for the problem with both devices.

My apologies, they were from different boots.  After the dd, I get
these:

[109479.550836] BTRFS warning (device sdb1): csum failed ino 1437377
off 75754369024 csum 1689728329 expected csum 2165338402
[109479.596626] BTRFS warning (device sdb1): csum failed ino 1437377
off 75754369024 csum 1689728329 expected csum 2165338402
[109479.601969] BTRFS warning (device sdb1): csum failed ino 1437377
off 75754369024 csum 1689728329 expected csum 2165338402
[109479.602189] BTRFS warning (device sdb1): csum failed ino 1437377
off 75754369024 csum 1689728329 expected csum 2165338402
[109479.602323] BTRFS warning (device sdb1): csum failed ino 1437377
off 75754369024 csum 1689728329 expected csum 2165338402
> 
> Also what do you get for these for each device:
> 
> smartctl scterc -l /dev/sdX
> cat /sys/block/sdX/device/timeout
> 
# smartctl -l scterc  /dev/sdb
sartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.4.8-300.fc23.x86_64]
(local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools
.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

# smartctl -l scterc  /dev/sdc
smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.4.8-300.fc23.x86_64]
(local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools
.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

# cat /sys/block/sdb/device/timeout
30
# cat /sys/block/sdc/device/timeout
30
> 
