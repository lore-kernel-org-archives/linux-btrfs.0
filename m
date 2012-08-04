Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40699 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab2HDJTu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2012 05:19:50 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: filesystem finder / fixer
Date: Sat, 4 Aug 2012 11:19:49 +0200
Cc: serialhex@lavabit.com
References: <36321.99.101.148.183.1343705202.squirrel@lavabit.com> <jv9618$6nr$1@dough.gmane.org> <47537.70.88.36.65.1344024666.squirrel@lavabit.com> (sfid-20120803_221125_225351_0ED8A8C7)
In-Reply-To: <47537.70.88.36.65.1344024666.squirrel@lavabit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208041119.49662.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 3. August 2012 schrieb serialhex@lavabit.com:
> > Alex Elsayed wrote:
> > 
> > Just realized I messed up sending this to the list.
> > 
> > Roman Mamedov wrote:
> >> On Mon, 30 Jul 2012 23:26:42 -0400 (EDT)
> >> 
> >> serialhex@lavabit.com wrote:
> >>> 1) is there a tool to help me recover data from my fs? I don't have
> >>> a backup of my partition table and so I have about 500GB of space
> >>> where a few partitionns might reside... GPT partitions mind you
> >> 
> >> If you only lost the partition table, there's a tool
> >> (strangely)named TestDisk, which can find the actual partitions on
> >> disk and restore it. Don't know if it supports GPT and BTRFS,
> >> though.
> > 
> > If TestDisk doesn't support it, then you may be able to do it
> > manually with
> > some trial and error.
> > 
> > I just dumped the first 4 megabytes of my disk, and it looks like at
> > offset
> > 0x10040 (64K + 64 bytes) there's the string BHRfS (hex 5F 42 48 52 66
> > 53 5f). That matches the documentation (the first superblock should
> > be at 64K).
> 
> ok, so it's been a few days, because it took me a few days to get
> everything back up and running, but here's what i did:
> 
> (tl;dr - i got my data back!)
> 
> i did as Alex suggested.  but i was getting a *lot* of false positives.
> the string _BHRfS_H is in the source code, some binaries, or
> something.... so the fact that bits are bits when reading the device
> as a file, i have to ignore all of those.  then there were a handful
> of other ones that looked to be the first superblock, but every time i
> tried it didn't work...  so i read up on btrfs some more.  the
> _BHRfS_H string starts at 0x40 (64 bytes) and the first bytes are a
> checksum of everything after. so i started with that, and found a
> number of the _BHRfS_H strings to have 00's before it, so a checksum
> of zero... which is *HIGHLY* unlikely.  so i looked for that, and the
> first one i found with a checksum >0 i tried, and succeeded!!
> 
> Thanks for the help & advice!!  i've now got my stuff back (and need to
> do an actual backup :P )

Now that would be either a good addition to testdisk or gpart if not 
already there or a nice thing for a btrfs recovery tool. Find my BTRFS 
partition. ;)

I think I will update my backup script to do sfdisk -d or gdisk -something 
> /root/partitioning before backuping ;). Always wanted to do that ;).

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
