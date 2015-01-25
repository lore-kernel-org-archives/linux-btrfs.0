Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out14.tpgi.com.au ([220.244.226.124]:56490 "EHLO
	mail14.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750720AbbAYFUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Jan 2015 00:20:05 -0500
From: Paul Jones <paul@pauljones.id.au>
To: Daniel Pocock <daniel@pocock.pro>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: RAID1 migrate to bigger disks
Date: Sun, 25 Jan 2015 05:07:02 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64593FD52E52@Server.waterlogic.com.au>
References: <54C3AD0C.7080407@pocock.pro>
 <20150124143632.GF1654@carfax.org.uk> <54C3B03E.8080002@pocock.pro>
In-Reply-To: <54C3B03E.8080002@pocock.pro>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Daniel Pocock
> Sent: Sunday, 25 January 2015 1:46 AM
> To: Hugo Mills; linux-btrfs@vger.kernel.org
> Subject: Re: RAID1 migrate to bigger disks
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> 
> 
> On 24/01/15 15:36, Hugo Mills wrote:
> > On Sat, Jan 24, 2015 at 03:32:44PM +0100, Daniel Pocock wrote:
> >>
> >>
> >>
> >> I've got a RAID1 on two 1TB partitions, /dev/sda3 and /dev/sdb3
> >>
> >> I'm adding two new disks, they will have bigger partitions
> >> /dev/sdc3 and /dev/sdd3
> >>
> >> I'd like the BtrFs to migrate from the old partitions to the new ones
> >> as safely and quickly as possible and if it is reasonable to do so,
> >> keeping it online throughout the migration.
> >>
> >> Should I do the following:
> >>
> >> btrfs device add /dev/sdc3 /dev/sdd3 /mnt/btrfs0 btrfs device delete
> >> /dev/sda3 /dev/sdb3 /mnt/btrfs0
> >>
> >> or should I do it this way:
> >>
> >> btrfs device add /dev/sdc3 /mnt/btrfs0 btrfs device delete
> >> /dev/sda3 /mnt/btrfs0 btrfs device add /dev/sdd3 /mnt/btrfs0 btrfs
> >> device delete /dev/sdb3 /mnt/btrfs0
> >>
> >> or is there some other way to go about it?
> >
> > btrfs replace start /dev/sda3 /dev/sdc3 /mountpoint btrfs fi resize
> > 3:max /mountpoint btrfs replace start /dev/sdb3 /dev/sdd3 /mountpoint
> > btrfs fi resize 4:max /mountpoint
> >
> > The 3 and 4 in the resize commands should be the devid of the
> > newly-added device.
> 
> Thanks for the fast reply
> 
> In the event of power failure, can I safely shutdown the server during this
> operation and resume after starting again?
> 
> I get more than 2 hours runtime from the UPS but I suspect that migrating
> 1TB will take at least 12 hours.

I know that removing a device can be interrupted safely by a reboot - I do it all the time as there is no cancel option for removal. It seems to operate the same way balance does, by moving data around, and when there is nothing left on the disk it is removed and de-associated.

Paul.
 

