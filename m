Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39559 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaAYQTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 11:19:16 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Options for SSD - autodefrag etc?
Date: Sat, 25 Jan 2014 17:19:13 +0100
Message-ID: <14052103.lIFe4uiThX@merkaba>
In-Reply-To: <00tcra-bh7.ln1@hurikhan77.spdns.de>
References: <52E19667.6090005@gmail.com> <1730344.q7ECaAgUWV@merkaba> <00tcra-bh7.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 25. Januar 2014, 15:06:24 schrieb Kai Krakow:
> Martin Steigerwald <Martin@lichtvoll.de> schrieb:
> > Okay, I have seen 260 MB/s. But frankly I am pretty sure that Virtuoso
> > isn´t doing this kind of large scale I/O on a highly fragmented file. Its
> > a database. Its random access. My oppinion is that Virtuoso couldn´t care
> > less about the fragmentation of the file. As long as it is stored on the
> > SSD.
> 
> I think it makes no real difference here since access to virtuoso is random
> anyway. And if I got you right you run it nocow, so upon writes you aren't
> introducing more fragmentation to the file. All is good... It probably would
> even be good with cow as virtuoso is read-most, so rarely written to.

No, its not nocow.

> For VM images it might be a whole different story. The guest system sees a
> block device and expects it to be continuous. All optimizations for access
> patterns cannot work right if btrfs is constantly moving parts of the file
> around for doing cow. So make it nocow and all should be as good as it can
> get.

I have some VirtualBox based VMs. I never see any issue with that. They are 
just fast. But then, for write based workloads I read hints that Virtualbox 
may not honor fsync() that closely.

> > Well… take this with caveat. This is LZO compressed, those 2,4 GiB / 128
> > KiB gives at least about 20000 extents already provided that my
> > calculation is correct. And these extents could be sequential (I doubt it
> > tough also give the high free space fragmention I suspect to be on this
> > FS).
> 
> Your CPU is more mighty than the flash chips. LZO improves read performance.
> But does it make sense on Intel drives? I think they already do
> compression.

Not the Intel SSD 320 to my knowledge.

> > Anyway: I do not perceive any noticable performance issues due to file
> > fragmentation on SSD and think that at least on highly filled BTRFS
> > filesystem autodefrag may do more harm than good (like fragment free space
> > and then let btrfs-delalloc go crazy on new allocations). I know xfs_fsr
> > for defragmenting XFS in the background, even via cron job. And I think I
> > remember Dave Chinner telling in some post that even for harddisks it may
> > not be a very wise idea to run this frequently due to the risk to fragment
> > free space.
> > 
> > There are several kinds of fragmentations. And defragmenting files may
> > increase freespace fragmentation.
> 
> This is why I wondered if btrfs will be optimized for keeping free space
> together in the future for SSD. But it's not as simple as this. It should
> not scatter file blocks all over the disk just to fill tiny holes. It should
> try to keep file blocks together so the read-modify-write-erase cycle of
> SSDs can work optimally.

I am reluctant about conclusions about the behavior or SSDs. I am not sure 
whether a modern SSDs cares that much about scattering file blocks all over the 
disk. AFAIK all modern SSDs don´t tell the OS a thing about in which erase 
block they store something and all SSDs use some caching. So a modern SSD may 
just sort several write accesses even if there are at different ends of the 
block device together into adjacent erase blocks. Well, actually I think thats 
the whole point of SSD firmwares. I am pretty much sure that the blocks of the 
block device that Linux sees are not mapped sequentially to flash chips by the 
SSD firmware. AFAIK all SSDs have some internal mapping.

So I wonder whether it even matters…

Heck a SSD firmware even copies over stuff to distribute erase cycles evenly 
onto all flash chips in the background and whatnot.

> > Thus, I am not yet convinced regarding autodefrag on SSDs.
> 
> I think everything would be easier if btrfs exposed some stats about what
> the autodefrag thread is really doing...

… and if we actually knew how SSD firmwares really behave.

But well… regarding autodefrag… I don´t know… my gut feeling is to disable it 
for SSDs for the reasons I outlined.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
