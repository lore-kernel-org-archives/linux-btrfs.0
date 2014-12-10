Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:45422 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbaLJNgZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:36:25 -0500
Received: by mail-yh0-f44.google.com with SMTP id c41so1260195yho.17
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 05:36:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548839EE.6080404@pobox.com>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
	<CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com>
	<54878210.8030807@pobox.com>
	<CAA7pwKPYwq73m4j-1-rf+-2owEvrDAaUJgxrGaY9uLm16Gs__Q@mail.gmail.com>
	<548839EE.6080404@pobox.com>
Date: Wed, 10 Dec 2014 14:36:24 +0100
Message-ID: <CAA7pwKMsHdbKLz77kFKYD7cymOwpWL42kqzOU8cb3LEyJ0PDSg@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 December 2014 at 13:17, Robert White <rwhite@pobox.com> wrote:
> On 12/09/2014 11:19 PM, Patrik Lundquist wrote:
>>
> BUT FIRST UNDERSTAND: you do _not_ need to balance a newly converted
> filesystem. That is, the recommended balance (and recursive defrag) is _not_
> a useability issue, its an efficiency issue.

But if I can't start with an efficient filesystem I'd rather start
over now/soon. I intend to add four more old disks for a RAID1 and it
will be problematic to start over later on (I'd have to buy new, large
disks).

I deleted the subvolume after being satisfied with the conversion,
defragged recursively, and balanced. In that order.


> Because you made a backup and everything yes?

Shh!


> So anyway. Your system isn't "bugged" or "broken" it's "full" but its a
> fragmented fullness that has lots of free sectors but insufficent contiguous
> free sectors, so it cannot satisfy the request.

It's a half full 3TB disk. There _is_ space, somewhere. I can't speak
for contiguous space though.


>> I don't know how to interpret the space_info error. Why is only
>> 4773171200 (4,4GiB) free?
>> Can I inspect block group 1821099687936 to try to find out what makes
>> it problematic?
>>
>> BTRFS info (device sdc1): relocating block group 1821099687936 flags 1
>> BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
>> BTRFS: space_info 1 has 4773171200 free, is not full
>> BTRFS: space_info total=1494648619008, used=1489775505408, pinned=0,
>> reserved=99700736, may_use=2102390784, readonly=241664
>
>
> So it was looking for a single chunk 2013265920 bytes long and it couldn't
> find one because all the spaces were smaller and there was no room to make a
> new suitable space.
>
> The problem is that it wanted 2013265920 bytes and while the system as a
> whole had no way to satisfy that desire. It asked for something just shy of
> two gigs as a single extent. That's a tough order on a full platter.
>
> Since your entire free size is 2102390784 that is an attempt to allocate
> about 80% of your free space as one contiguous block. That's never going to
> happen. 8-)

What about "space_info 1 has 4773171200 free"? Besides the other 1,5TB
free space.


> I don't even know if 2GiB is normally a legal size for an extent. My
> understanding is that data is allocated in 1G chunks, so I'd expect all
> extents to be smaller than 1G.

The 'summary' after the failed balances is always something like "98
enospc errors" which now makes me suspect that I have 98 files with
extents larger than 1GiB that the defrag didn't take care of.

So if I can find out which files have >1GiB extents I can then copy
them back and forth to solve the problem.

Maybe running defrag more times can also solve it? Can I get a list of
fragmented files?

Suppose an old file with 2GiB extent isn't fragmented, will btrfs
defrag still try to defrag it?


> After a quick glance at the btrfs-convert, it looks like it might make some
> pretty atypical extents if the underlying donor filesystem needed needed
> them. It wouldn't have had a choice. So it's easily within the realm of
> reason that you'd have some really fascinating data as a result of
> converting a nearly full EXT4 file system of the Terabyte+ size.

It was about half full at conversion.


> This would
> be quadruply true if you'd tweaked the block group ratios when you made the
> original file system.

Ext4 created with defaults, but I think it has been completely full at one time.


> So since you have nice backups... you should probably drop the ext2_saved
> subvolume and then get on with your life for good or ill.

Done before defrag and balance attempts.


> Think of the time and worry you'd have saved if you'd copied the thing in
> the first place. 8-)

But then I wouldn't learn as much. :-)


>>> P.S. you should re-balance your System and Metadata as "DUP" for now. Two
>>> copies of that stuff is better than one as right now you have no real
>>> recovery path for that stuff. If you didn't make that change on purpose
>>> it
>>> probably got down-revved from DUP automagically when you tired to RAID
>>> it.
>>
>>
>> Good point. Maybe btrfs-convert should do that by default? I don't
>> think it has ever been DUP.
>
> Eyup.

And the metadata is now DUP. That's ~1.5GB extra metadata that was
allocated just fine after the failed balance.
