Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58675 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbcETROM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 13:14:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b3ns5-0001kQ-NV
	for linux-btrfs@vger.kernel.org; Fri, 20 May 2016 19:05:57 +0200
Received: from 145.132.48.198 ([145.132.48.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 19:05:57 +0200
Received: from ftoth by 145.132.48.198 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 19:05:57 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@exalondelft.nl>
Subject: Re: Hot data tracking / hybrid storage
Date: Fri, 20 May 2016 17:02:00 +0000 (UTC)
Message-ID: <nhnfu8$igq$1@ger.gmane.org>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
	<20160516010524.7e208f96@jupiter.sol.kaishome.de>
	<nhedk2$dpq$1@ger.gmane.org>
	<0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
	<20160517203335.5ff99a05@jupiter.sol.kaishome.de>
	<nhir96$8n4$1@ger.gmane.org>
	<20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
	<e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
	<CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
	<1c1358af-4549-618a-c408-b93832d33225@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op Fri, 20 May 2016 08:03:12 -0400, schreef Austin S. Hemmelgarn:

> On 2016-05-19 19:23, Henk Slager wrote:
>> On Thu, May 19, 2016 at 8:51 PM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> On 2016-05-19 14:09, Kai Krakow wrote:
>>>>
>>>> Am Wed, 18 May 2016 22:44:55 +0000 (UTC)
>>>> schrieb Ferry Toth <ftoth@exalondelft.nl>:
>>>>
>>>>> Op Tue, 17 May 2016 20:33:35 +0200, schreef Kai Krakow:
>>>> Bcache is actually low maintenance, no knobs to turn. Converting to
>>>> bcache protective superblocks is a one-time procedure which can be
>>>> done online. The bcache devices act as normal HDD if not attached to
>>>> a caching SSD. It's really less pain than you may think. And it's a
>>>> solution available now. Converting back later is easy: Just detach
>>>> the HDDs from the SSDs and use them for some other purpose if you
>>>> feel so later. Having the bcache protective superblock still in place
>>>> doesn't hurt then. Bcache is a no-op without caching device attached.
>>>
>>> No, bcache is _almost_ a no-op without a caching device.  From a
>>> userspace perspective, it does nothing, but it is still another layer
>>> of indirection in the kernel, which does have a small impact on
>>> performance.  The same is true of using LVM with a single volume
>>> taking up the entire partition, it looks almost no different from just
>>> using the partition, but it will perform worse than using the
>>> partition directly.  I've actually done profiling of both to figure
>>> out base values for the overhead, and while bcache with no cache
>>> device is not as bad as the LVM example, it can still be a roughly
>>> 0.5-2% slowdown (it gets more noticeable the faster your backing
>>> storage is).
>>>
>>> You also lose the ability to mount that filesystem directly on a
>>> kernel without bcache support (this may or may not be an issue for
>>> you).
>>
>> The bcache (protective) superblock is in an 8KiB block in front of the
>> file system device. In case the current, non-bcached HDD's use modern
>> partitioning, you can do a 5-minute remove or add of bcache, without
>> moving/copying filesystem data. So in case you have a bcache-formatted
>> HDD that had just 1 primary partition (512 byte logical sectors), the
>> partition start is at sector 2048 and the filesystem start is at 2064.
>> Hard removing bcache (so making sure the module is not
>> needed/loaded/used the next boot) can be done done by changing the
>> start-sector of the partition from 2048 to 2064. In gdisk one has to
>> change the alignment to 16 first, otherwise this it refuses. And of
>> course, also first flush+stop+de-register bcache for the HDD.
>>
>> The other way around is also possible, i.e. changing the start-sector
>> from 2048 to 2032. So that makes adding bcache to an existing
>> filesystem a 5 minute action and not a GBs- or TBs copy action. It is
>> not online of course, but just one reboot is needed (or just umount,
>> gdisk, partprobe, add bcache etc).
>> For RAID setups, one could just do 1 HDD first.
> My argument about the overhead was not about the superblock, it was
> about the bcache layer itself.  It isn't practical to just access the
> data directly if you plan on adding a cache device, because then you
> couldn't do so online unless you're going through bcache.  This extra
> layer of indirection in the kernel does add overhead, regardless of the
> on-disk format.
> 
> Secondarily, having a HDD with just one partition is not a typical use
> case, and that argument about the slack space resulting from the 1M
> alignment only holds true if you're using an MBR instead of a GPT layout
> (or for that matter, almost any other partition table format), and
> you're not booting from that disk (because GRUB embeds itself there).
> It's also fully possible to have an MBR formatted disk which doesn't
> have any spare space there too (which is how most flash drives get
> formatted).

We have 4 1TB drives in MBR, 1MB free at the beginning, grub on all 4, 
then 8GB swap, then all the rest btrfs (no LVM used). The 4 btrfs 
partitions are in the same pool, which is in btrfs RAID10 format. /boot 
is in subvolume @boot.

In this configuration nothing would beat btrfs if I could just add 2 
SSD's to the pool that would be clever enough to be paired in RAID1 and 
would be preferred for small (<1GB) file writes. Then balance should be 
able to move not often used files to the HDD.

None of the methods mentioned here sound easy or quick to do, or even 
well tested.

> This also doesn't change the fact that without careful initial
> formatting (it is possible on some filesystems to embed the bcache SB at
> the beginning of the FS itself, many of them have some reserved space at
> the beginning of the partition for bootloaders, and this space doesn't
> have to exist when mounting the FS) or manual alteration of the
> partition, it's not possible to mount the FS on a system without bcache
> support.
>>
>> There is also a tool doing the conversion in-place (I haven't used it
>> myself, my python(s) had trouble; I could do the partition table edit
>> much faster/easier):
>> https://github.com/g2p/blocks#bcache-conversion
>>
> I actually hadn't known about this tool, thanks for mentioning it.


