Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.artfiles.de ([80.252.97.80]:47450 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaBRVdc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 16:33:32 -0500
Received: from [178.13.125.3] (helo=fuckup.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80.1)
	id 1WFsIE-00080q-5z
	for linux-btrfs@vger.kernel.org; Tue, 18 Feb 2014 22:33:30 +0100
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Read i/o errs and disk replacement
Date: Tue, 18 Feb 2014 22:33:28 +0100
Message-ID: <116064537.O3CH7laqNI@fuckup>
In-Reply-To: <4122CB7E-0AF1-4808-9FF6-91E875D6E1E9@colorremedies.com>
References: <8051054.BLVnDBVVi7@fuckup> <4122CB7E-0AF1-4808-9FF6-91E875D6E1E9@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 18 February 2014 11:48:49 Chris Murphy wrote:
> On Feb 18, 2014, at 6:19 AM, Wolfgang Mader <Wolfgang_Mader@brain-frog.de> 
wrote:
> > Hi all,
> > 
> > well, I hit the first incidence where I really have to work with my btrfs
> > setup. To get things straight I want to double-check here to not screw
> > things up right from the start. We are talking about a home server. There
> > is no time or user pressure involved, and there are backups, too.
> > 
> > 
> > Software
> > -------------
> > Linux 3.13.3
> > Btrfs v3.12
> > 
> > 
> > Hardware
> > ---------------
> > 5 1T hard drives configured to be a raid 10 for both data and metadata
> > 
> >    Data, RAID10: total=282.00GiB, used=273.33GiB
> >    System, RAID10: total=64.00MiB, used=36.00KiB
> >    Metadata, RAID10: total=1.00GiB, used=660.48MiB
> > 
> > Error
> > --------
> > This is not btrfs' fault but due to an hd error. I saw in the system logs
> > 
> >    btrfs: bdev /dev/sdb errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
> > 
> > and a subsequent check on btrfs showed
> > 
> >    [/dev/sdb].write_io_errs   0
> >    [/dev/sdb].read_io_errs    2
> >    [/dev/sdb].flush_io_errs   0
> >    [/dev/sdb].corruption_errs 0
> >    [/dev/sdb].generation_errs 0
> > 
> > So, I have a read error on sdb.
> > 
> > 
> > Questions
> > ---------------
> > 1)
> > Do I have to take action immediately (shutdown the system, umount the file
> > system)? Can I even ignore the error? Unfortunately, I can not access
> > SMART
> > information through the sata interface of the enclosure which hosts the
> > hds.
> A full dmesg should be sufficient to determine if this is due to the drive
> reporting a read error, in which case Btrfs is expected to get a copy of
> the missing data from a mirror, send it up to the application layer without
> error, and then write it to the LBAs of the device(s) that reported the
> original read error. It is kinda important to make sure that there wasn't a
> device reset, but an explicit read error. If the drive merely hangs while
> in recovery, upon reset any way of knowing what sectors were slow or bad is
> lost.

Thank you for your quick response.

The first read error is occurring during system start up when the raid is 
activated for the first time

[Tue Feb 18 13:02:08 2014] btrfs: use lzo compression
[Tue Feb 18 13:02:08 2014] btrfs: disk space caching is enabled
[Tue Feb 18 13:02:09 2014] btrfs: bdev /dev/sdb errs: wr 0, rd 1, flush 0, 
corrupt 0, gen 0

and then dmsg is silent for the next 10 minutes.


The second read error happens while the device is in use and is preceded by

-------start----------
Feb 18 13:14:09 deck kernel: ata2.15: exception Emask 0x1 SAct 0x0 SErr 0x0 
action 0x6
Feb 18 13:14:09 deck kernel: ata2.15: edma_err_cause=00000084 
pp_flags=00000001, dev error, EDMA self-disable
Feb 18 13:14:09 deck kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 
action 0x0
Feb 18 13:14:09 deck kernel: ata2.00: failed command: READ DMA
Feb 18 13:14:09 deck kernel: ata2.00: cmd c8/00:08:60:f2:30/00:00:00:00:00/e0 
tag 0 dma 4096 in
                                      res 51/04:08:60:f2:30/00:00:00:00:00/e0 
Emask 0x1 (device error)
Feb 18 13:14:09 deck kernel: ata2.00: status: { DRDY ERR }
Feb 18 13:14:09 deck kernel: ata2.00: error: { ABRT }
Feb 18 13:14:09 deck kernel: ata2.15: hard resetting link
Feb 18 13:14:14 deck kernel: ata2.15: link is slow to respond, please be 
patient (ready=0)
Feb 18 13:14:19 deck kernel: ata2.15: SRST failed (errno=-16)
Feb 18 13:14:19 deck kernel: ata2.15: hard resetting link
Feb 18 13:14:24 deck kernel: ata2.15: link is slow to respond, please be 
patient (ready=0)
Feb 18 13:14:29 deck kernel: ata2.15: SATA link up 3.0 Gbps (SStatus 123 
SControl F300)
Feb 18 13:14:29 deck kernel: 
Feb 18 13:14:30 deck kernel: ata2.01: hard resetting link
Feb 18 13:14:31 deck kernel: ata2.02: hard resetting link
Feb 18 13:14:31 deck kernel: ata2.03: hard resetting link
Feb 18 13:14:32 deck kernel: ata2.04: hard resetting link
Feb 18 13:14:32 deck kernel: ata2.05: hard resetting link
Feb 18 13:14:33 deck kernel: ata2.06: hard resetting link
Feb 18 13:14:34 deck kernel: ata2.07: hard resetting link
Feb 18 13:14:34 deck kernel: ata2.00: configured for UDMA/133
Feb 18 13:14:34 deck kernel: ata2.01: configured for UDMA/133
Feb 18 13:14:35 deck kernel: ata2.02: configured for UDMA/133
Feb 18 13:14:35 deck kernel: ata2.03: configured for UDMA/133
Feb 18 13:14:35 deck kernel: ata2.04: configured for UDMA/133
Feb 18 13:14:35 deck kernel: ata2.05: configured for UDMA/133
Feb 18 13:14:35 deck kernel: ata2.06: configured for UDMA/133
Feb 18 13:14:35 deck kernel: ata2.07: configured for UDMA/133
Feb 18 13:14:35 deck kernel: ata2: EH complete
-------end-------

This output it repeated several times and than end in this read error

[Tue Feb 18 13:15:48 2014] btrfs: bdev /dev/sdb errs: wr 0, rd 2, flush 0, 
corrupt 0, gen 0
[Tue Feb 18 13:15:48 2014] ata2: EH complete
[Tue Feb 18 13:15:48 2014] btrfs read error corrected: ino 1 off 29184540672 
(dev /dev/sdb sector 3207776)

This might have to do with the fact, that my hds power down after 15 min of 
idle time. I will investigate this.


Best,
Wolfgang




> > 2)
> > I only can replace the disk, not add a new one and than swap over. There
> > is no space left in the disk enclosure I am using. I also can not
> > guarantee that if I remove sdb and start the system up again that all the
> > other disks are named the same as they are now, and that the newly added
> > disk will be names sdb again. Is this an issue?
> > 
> > 3)
> > I know that btrfs can handle disks of different sizes. Is there a downside
> > if I go for a 3T disk and add it to the 1T disks? Is there e.g. more
> > stuff saved on the 3T disk, and if this ones fails I lose redundancy? Is
> > a soft transition to 3T where I replace every dying 1T disk with a 3T
> > disk advisable?
> > 
> > 
> > Proposed solution for the current issue
> > --------------------------------------------------------------
> > 1)
> > Delete the faulted drive using
> > 
> >    btrfs device delete /dev/sdb /path/to/pool
> > 
> > 2)
> > Format the new disk with btrfs
> > 
> >    mkfs.btrfs
> > 
> > 3)
> > Add the new disk to the filesystem using
> > 
> >    btrfs device add /dev/newdiskname /path/to/pool
> > 
> > 4)
> > Balance the file system
> > 
> >    btrfs fs balance /path/to/pool
> > 
> > Is this the proper way to deal with the situation?
> 
> I wouldn't do anything until you really understand what the problem is.
> 
> 
> Chris Murphy

