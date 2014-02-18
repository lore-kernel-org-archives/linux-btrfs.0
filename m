Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55242 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750939AbaBRSst convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 13:48:49 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Read i/o errs and disk replacement
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <8051054.BLVnDBVVi7@fuckup>
Date: Tue, 18 Feb 2014 11:48:49 -0700
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <4122CB7E-0AF1-4808-9FF6-91E875D6E1E9@colorremedies.com>
References: <8051054.BLVnDBVVi7@fuckup>
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 18, 2014, at 6:19 AM, Wolfgang Mader <Wolfgang_Mader@brain-frog.de> wrote:

> Hi all,
> 
> well, I hit the first incidence where I really have to work with my btrfs 
> setup. To get things straight I want to double-check here to not screw things 
> up right from the start. We are talking about a home server. There is no time 
> or user pressure involved, and there are backups, too.
> 
> 
> Software
> -------------
> Linux 3.13.3
> Btrfs v3.12
> 
> 
> Hardware
> ---------------
> 5 1T hard drives configured to be a raid 10 for both data and metadata
>    Data, RAID10: total=282.00GiB, used=273.33GiB
>    System, RAID10: total=64.00MiB, used=36.00KiB
>    Metadata, RAID10: total=1.00GiB, used=660.48MiB
> 
> 
> Error
> --------
> This is not btrfs' fault but due to an hd error. I saw in the system logs
>    btrfs: bdev /dev/sdb errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
> and a subsequent check on btrfs showed
>    [/dev/sdb].write_io_errs   0
>    [/dev/sdb].read_io_errs    2
>    [/dev/sdb].flush_io_errs   0
>    [/dev/sdb].corruption_errs 0
>    [/dev/sdb].generation_errs 0
> 
> So, I have a read error on sdb.
> 
> 
> Questions
> ---------------
> 1)
> Do I have to take action immediately (shutdown the system, umount the file 
> system)? Can I even ignore the error? Unfortunately, I can not access SMART 
> information through the sata interface of the enclosure which hosts the hds.

A full dmesg should be sufficient to determine if this is due to the drive reporting a read error, in which case Btrfs is expected to get a copy of the missing data from a mirror, send it up to the application layer without error, and then write it to the LBAs of the device(s) that reported the original read error. It is kinda important to make sure that there wasn't a device reset, but an explicit read error. If the drive merely hangs while in recovery, upon reset any way of knowing what sectors were slow or bad is lost.



> 
> 2)
> I only can replace the disk, not add a new one and than swap over. There is no 
> space left in the disk enclosure I am using. I also can not guarantee that if 
> I remove sdb and start the system up again that all the other disks are named 
> the same as they are now, and that the newly added disk will be names sdb 
> again. Is this an issue?
> 
> 3)
> I know that btrfs can handle disks of different sizes. Is there a downside if I 
> go for a 3T disk and add it to the 1T disks? Is there e.g. more stuff saved on 
> the 3T disk, and if this ones fails I lose redundancy? Is a soft transition to 
> 3T where I replace every dying 1T disk with a 3T disk advisable?
> 
> 
> Proposed solution for the current issue
> --------------------------------------------------------------
> 1)
> Delete the faulted drive using
>    btrfs device delete /dev/sdb /path/to/pool
> 2)
> Format the new disk with btrfs
>    mkfs.btrfs
> 3)
> Add the new disk to the filesystem using
>    btrfs device add /dev/newdiskname /path/to/pool
> 4)
> Balance the file system
>    btrfs fs balance /path/to/pool
> 
> Is this the proper way to deal with the situation?

I wouldn't do anything until you really understand what the problem is.


Chris Murphy