Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48226 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbbAXPrv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Jan 2015 10:47:51 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Daniel Pocock <daniel@pocock.pro>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: RAID1 migrate to bigger disks
Date: Sat, 24 Jan 2015 16:47:49 +0100
Message-ID: <1427188.PHcY3qXV8q@merkaba>
In-Reply-To: <54C3B03E.8080002@pocock.pro>
References: <54C3AD0C.7080407@pocock.pro> <20150124143632.GF1654@carfax.org.uk> <54C3B03E.8080002@pocock.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 24. Januar 2015, 15:46:22 schrieb Daniel Pocock:
> On 24/01/15 15:36, Hugo Mills wrote:
> > On Sat, Jan 24, 2015 at 03:32:44PM +0100, Daniel Pocock wrote:
> >> I've got a RAID1 on two 1TB partitions, /dev/sda3 and /dev/sdb3
> >> 
> >> I'm adding two new disks, they will have bigger partitions
> >> /dev/sdc3 and /dev/sdd3
> >> 
> >> I'd like the BtrFs to migrate from the old partitions to the new
> >> ones as safely and quickly as possible and if it is reasonable to
> >> do so, keeping it online throughout the migration.
> >> 
> >> Should I do the following:
> >> 
> >> btrfs device add /dev/sdc3 /dev/sdd3 /mnt/btrfs0 btrfs device
> >> delete /dev/sda3 /dev/sdb3 /mnt/btrfs0
> >> 
> >> or should I do it this way:
> >> 
> >> btrfs device add /dev/sdc3 /mnt/btrfs0 btrfs device delete
> >> /dev/sda3 /mnt/btrfs0 btrfs device add /dev/sdd3 /mnt/btrfs0
> >> btrfs device delete /dev/sdb3 /mnt/btrfs0
> >> 
> >> or is there some other way to go about it?
> > 
> > btrfs replace start /dev/sda3 /dev/sdc3 /mountpoint btrfs fi resize
> > 3:max /mountpoint btrfs replace start /dev/sdb3 /dev/sdd3
> > /mountpoint btrfs fi resize 4:max /mountpoint
> > 
> > The 3 and 4 in the resize commands should be the devid of the
> > newly-added device.
> 
> Thanks for the fast reply
> 
> In the event of power failure, can I safely shutdown the server during
> this operation and resume after starting again?
> 
> I get more than 2 hours runtime from the UPS but I suspect that
> migrating 1TB will take at least 12 hours.

You can at least cancel the replacing:

merkaba:~> btrfs replace --help
usage: btrfs replace <command> [<args>]

    btrfs replace start [-Bfr] <srcdev>|<devid> <targetdev> <mount_point>
        Replace device of a btrfs filesystem.
    btrfs replace status [-1] <mount_point>
        Print status and progress information of a running device replace
    btrfs replace cancel <mount_point>
        Cancel a running device replace operation.

I thought you could resume it then later, but I don't see this. The man 
page doesn't see it either.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
