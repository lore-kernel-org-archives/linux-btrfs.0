From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 11:48:11 -0500
Message-ID: <yq1fx466bzo.fsf@sermon.lab.mkp.net>
References: <4B97F7CE.4030405@bobich.net> <4B9829B1.1020706@bobich.net>
	<20100311073853.GA26129@attic.humilis.net>
	<201003111159.58081.hka@qbs.com.pl>
	<20100311123103.34246e95.skraw@ithnet.com>
	<ce25fe08b6b07e1993f62f6e34670e52@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <linux-btrfs@vger.kernel.org>
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ce25fe08b6b07e1993f62f6e34670e52@localhost> (Gordan Bobic's
	message of "Thu, 11 Mar 2010 12:17:30 +0000")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Gordan" == Gordan Bobic <gordan@bobich.net> writes:

Gordan> SD == SSD with an SD interface.

No, not really.

It is true that conceivably you could fit a sophisticated controller in
an SD card form factor.  But fact is that takes up space which could
otherwise be used for flash.  There may also be power consumption/heat
dissipation concerns.

Most SD card controllers have very, very simple wear leveling that in
most cases rely on the filesystem being FAT.  These cards are aimed at
cameras, MP3 players, etc. after all. And consequently it's trivial to
wear out an SD card by writing a block over and over.

The same is kind of true for Compact Flash.  There are two types of
cards, I prefer to think of them as camera grade and industrial.  Camera
grade CF is really no different from SD cards or any other consumer
flash form factor.

Industrial CF cards have controllers with sophisticated wear leveling.
Usually this is not quite as clever as a "big" SSD, but it is close
enough that you can treat the device as a real disk drive.  I.e. it has
multiple channels working in parallel unlike the consumer devices.

As a result of the smarter controller logic and the bigger bank of spare
flash, industrial cards are much smaller in capacity.  Typically in the
1-4 GB range.  But they are in many cases indistinguishable from a real
SSD in terms of performance and reliability.


Gordan> You can make an educated guess. For starters given that visible
Gordan> sector sizes are not equal to FS block sizes, it means that FS
Gordan> block sizes can straddle erase block boundaries without the
Gordan> flash controller, no matter how fancy, being able to determine
Gordan> this. Thus, at the very least, aligning FS structures so that
Gordan> they do not straddle erase block boundaries is useful in ALL
Gordan> cases. Thinking otherwise is just sticking your head in the sand
Gordan> because you cannot be bothered to think.

There are no means of telling what the erase block size is.  None.  We
have no idea.  The vendors won't talk.  It's part of their IP.

Also, there is no point in being hung up on the whole erase block thing.
Only crappy SSDs use block mapping where that matters.  These devices
will die a horrible death soon enough.  Good SSDs use a technique akin
to logging filesystems in which the erase block size and all other other
physical characteristics don't matter (from a host perspective).

-- 
Martin K. Petersen	Oracle Linux Engineering
