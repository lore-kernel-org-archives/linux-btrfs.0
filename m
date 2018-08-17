Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55543 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbeHRAbl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 20:31:41 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
Date: Fri, 17 Aug 2018 23:26:39 +0200
Message-ID: <3017700.9JUpqBsAt1@merkaba>
In-Reply-To: <06e2c72d-8c46-e8a1-b371-6477e2d01d71@gmail.com>
References: <2331408.nK7QgfhVWv@merkaba> <1598008.Z1BGxZKWFL@merkaba> <06e2c72d-8c46-e8a1-b371-6477e2d01d71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn - 17.08.18, 14:55:
> On 2018-08-17 08:28, Martin Steigerwald wrote:
> > Thanks for your detailed answer.
> > 
> > Austin S. Hemmelgarn - 17.08.18, 13:58:
> >> On 2018-08-17 05:08, Martin Steigerwald wrote:
[…]
> >>> Anyway, creating a new filesystem may have been better here
> >>> anyway,
> >>> cause it replaced an BTRFS that aged over several years with a new
> >>> one. Due to the increased capacity and due to me thinking that
> >>> Samsung 860 Pro compresses itself, I removed LZO compression. This
> >>> would also give larger extents on files that are not fragmented or
> >>> only slightly fragmented. I think that Intel SSD 320 did not
> >>> compress, but Crucial m500 mSATA SSD does. That has been the
> >>> secondary SSD that still had all the data after the outage of the
> >>> Intel SSD 320.
> >> 
> >> First off, keep in mind that the SSD firmware doing compression
> >> only
> >> really helps with wear-leveling.  Doing it in the filesystem will
> >> help not only with that, but will also give you more space to work
> >> with.> 
> > While also reducing the ability of the SSD to wear-level. The more
> > data I fit on the SSD, the less it can wear-level. And the better I
> > compress that data, the less it can wear-level.
> 
> No, the better you compress the data, the _less_ data you are
> physically putting on the SSD, just like compressing a file makes it
> take up less space.  This actually makes it easier for the firmware
> to do wear-leveling.  Wear-leveling is entirely about picking where
> to put data, and by reducing the total amount of data you are writing
> to the SSD, you're making that decision easier for the firmware, and
> also reducing the number of blocks of flash memory needed (which also
> helps with SSD life expectancy because it translates to fewer erase
> cycles).

On one hand I can go with this, but:

If I fill the SSD 99% with already compressed data, in case it 
compresses itself for wear leveling, it has less chance to wear level 
than with 99% of not yet compressed data that it could compress itself.

That was the point I was trying to make.

Sure, with a fill rate of about 46% for home, compression would help the 
wear leveling. And if the controller does not compress at all, it would 
also.

Hmmm, maybe I enable "zstd", but on the other hand I save CPU cycles 
with not enabling it. 

> > However… I am not all that convinced that it would benefit me as
> > long as I have enough space. That SSD replacement more than doubled
> > capacity from about 680 TB to 1480 TB. I have ton of free space in
> > the filesystems – usage of /home is only 46% for example – and
> > there are 96 GiB completely unused in LVM on the Crucial SSD and
> > even more than 183 GiB completely unused on Samsung SSD. The system
> > is doing weekly "fstrim" on all filesystems. I think that this is
> > more than is needed for the longevity of the SSDs, but well
> > actually I just don´t need the space, so…
> > 
> > Of course, in case I manage to fill up all that space, I consider
> > using compression. Until then, I am not all that convinced that I´d
> > benefit from it.
> > 
> > Of course it may increase read speeds and in case of nicely
> > compressible data also write speeds, I am not sure whether it even
> > matters. Also it uses up some CPU cycles on a dual core (+
> > hyperthreading) Sandybridge mobile i5. While I am not sure about
> > it, I bet also having larger possible extent sizes may help a bit.
> > As well as no compression may also help a bit with fragmentation.
> 
> It generally does actually. Less data physically on the device means
> lower chances of fragmentation.  In your case, it may not improve

I thought "no compression" may help with fragmentation, but I think you 
think that "compression" helps with fragmentation and misunderstood what 
I wrote.

> speed much though (your i5 _probably_ can't compress data much faster
> than it can access your SSD's, which means you likely won't see much
> performance benefit other than reducing fragmentation).
> 
> > Well putting this to a (non-scientific) test:
> > 
> > […]/.local/share/akonadi/db_data/akonadi> du -sh * | sort -rh | head
> > -5 3,1G    parttable.ibd
> > 
> > […]/.local/share/akonadi/db_data/akonadi> filefrag parttable.ibd
> > parttable.ibd: 11583 extents found
> > 
> > Hmmm, already quite many extents after just about one week with the
> > new filesystem. On the old filesystem I had somewhat around
> > 40000-50000 extents on that file.
> 
> Filefrag doesn't properly handle compressed files on BTRFS.  It treats
> each 128KiB compression block as a separate extent, even though they
> may be contiguous as part of one BTRFS extent.  That one file by
> itself should have reported as about 25396 extents on the old volume
> (assuming it was entirely compressed), so your numbers seem to match
> up realistically.>

Oh, thanks. I did not know that filefrag does not understand extents for 
compressed files in BTRFS.

> > Well actually what do I know: I don´t even have an idea whether not
> > using compression would be beneficial. Maybe it does not even matter
> > all that much.
> > 
> > I bet testing it to the point that I could be sure about it for my
> > workload would take considerable amount of time.
> 
> One last quick thing about compression in general on BTRFS.  Unless
> you have a lot of files that are likely to be completely
> incompressible, you're generally better off using `compress-force`
> instead of `compress`.  With regular `compress`, BTRFS will try to
> compress the first few blocks of a file, and if that fails will mark
> the file as incompressible and not try to compress any of it
> automatically ever again.  With `compress-force`, BTRFS will just
> unconditionally compress everything.

Well on one filesystem which is on a single SSD, I do have lots of image 
files, mostly jpg, and audio files in mp3 or ogg vorbis formats.

Thanks,
-- 
Martin
