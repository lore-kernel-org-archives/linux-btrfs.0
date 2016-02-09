Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36432 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964864AbcBISXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 13:23:52 -0500
Received: by mail-lb0-f176.google.com with SMTP id dx2so105209868lbd.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 10:23:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160209082933.52273993@jupiter.sol.kaishome.de>
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba>
	<87twliri6m.fsf@thinkpad.rath.org>
	<20160209082933.52273993@jupiter.sol.kaishome.de>
Date: Tue, 9 Feb 2016 19:23:50 +0100
Message-ID: <CAPmG0jYnogfJjutzQaL0FJAUbnLJke8i1-s_sNWVdF7JauSQ4w@mail.gmail.com>
Subject: Re: Use fast device only for metadata?
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 9, 2016 at 8:29 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Mon, 08 Feb 2016 13:44:17 -0800
> schrieb Nikolaus Rath <Nikolaus@rath.org>:
>
>> On Feb 07 2016, Martin Steigerwald <martin@lichtvoll.de> wrote:
>> > Am Sonntag, 7. Februar 2016, 21:07:13 CET schrieb Kai Krakow:
>> >> Am Sun, 07 Feb 2016 11:06:58 -0800
>> >>
>> >> schrieb Nikolaus Rath <Nikolaus@rath.org>:
>> >> > Hello,
>> >> >
>> >> > I have a large home directory on a spinning disk that I regularly
>> >> > synchronize between different computers using unison. That takes
>> >> > ages, even though the amount of changed files is typically
>> >> > small. I suspect most if the time is spend walking through the
>> >> > file system and checking mtimes.
>> >> >
>> >> > So I was wondering if I could possibly speed-up this operation by
>> >> > storing all btrfs metadata on a fast, SSD drive. It seems that
>> >> > mkfs.btrfs allows me to put the metadata in raid1 or dup mode,
>> >> > and the file contents in single mode. However, I could not find
>> >> > a way to tell btrfs to use a device *only* for metadata. Is
>> >> > there a way to do that?
>> >> >
>> >> > Also, what is the difference between using "dup" and "raid1" for
>> >> > the metadata?
>> >>
>> >> You may want to try bcache. It will speedup random access which is
>> >> probably the main cause for your slow sync. Unfortunately it
>> >> requires you to reformat your btrfs partitions to add a bcache
>> >> superblock. But it's worth the efforts.
>> >>
>> >> I use a nightly rsync to USB3 disk, and bcache reduced it from 5+
>> >> hours to typically 1.5-3 depending on how much data changed.
>> >
>> > An alternative is using dm-cache, I think it doesn´t need to
>> > recreate the filesystem.
>>
>> Yes, I tried that already but it didn't improve things at all. I
>> wrote a message to the lvm list though, so maybe someone will be able
>> to help.
>>
>> Otherwise I'll give bcache a shot. I've avoided it so far because of
>> the need to reformat and because of rumours that it doesn't work well
>> with LVM or BTRFS. But it sounds as if that's not the case..
>
> I'm myself using bcache+btrfs and it ran bullet proof so far, even
> after unintentional resets or power outage. It's important tho to NOT
> put any storage layer between bcache and your devices or between btrfs
> and your device as there are reports it becomes unstable with md or lvm
> involved. In my setup I can even use discard/trim without problems. I'd
> recommend a current kernel, tho.
>
> Since it requires reformatting, it's a big pita but it's worth the
> efforts. It appeared, from its design, much more effective and stable
> than dmcache. You could even format a bcache superblock "just in case",
> and add an SSD later. Without SSD, bcache will just work in passthru
> mode. Actually, I started to format all my storage with bcache
> superblock "just in case". It is similar to having another partition
> table folded inside - so it doesn't hurt (except you need bcache-probe
> in initrd to detect the contained filesystems).

Same positive bcache+BTRFS experience for me, I am using it since
kernel 4.1.6 and now just latest 4.4. Especially now it is possible to
use VM images in normal CoW mode with speed/performance comparable to
the image on SSD. This is with 50G images consisting of about 50k
extents, raid10 btrfs with mount options noatime,nossd,autodefrag and
writeback on. Initial amount of extents was in order of 100 or so, but
later small writes inside the VM just almost all end up in the bcache.
Nightly incremental send|receive is just a few minutes. Kernel compile
from local git repo clone almost works like from SSD.

When both RAM cache is invalidated and bcache detached / stopped / not
there, filesystem finds or operations that have to deal with
fragmentation or a lot of seeks clearly take way more time. From
there, after starting and using an OS in a VM for lets say 10 minutes
for common tasks, speed is 'SSD like' and not 'HDD like' anymore and
stays that way (until eviction of blocks of course).

The 'reformatting' might be avoided by using this:
https://github.com/g2p/blocks

I haven't used it myself as one fs was just full harddisk and my
python installations had some issues. I wanted to keep same UUID ( due
to longterm incremental send|receive cloning setup) so I did shrink
the filesystem to its almost smallest possible and then used an extra
device (4TB) to dd_rescue the fs image onto and then 2nd step
dd_rescue it back to the original disk (to a partition that is
bcache'd). A btrfs replace would have also been an option. Or some
2-step add-remove action or tricks with raid1.

For another disk I did not have a spare disk, so I made a script to do
an 'in-place' filesystem image replace. I have browsed the superblocks
(don't remember size, but its a few kB AFAIK), so 1G copyblocksize is
huge enough and keeping at least 2 copyblocks readahead stored on
intermediate storage worked fine. Same can be used for LUKS header
addition.
