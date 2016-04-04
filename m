Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52659 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbcDDEfE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 00:35:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amwE9-0008Bq-17
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 06:35:01 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 06:35:01 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 06:35:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Mon, 4 Apr 2016 04:34:54 +0000 (UTC)
Message-ID: <pan$39ed6$7954b891$6122ae15$76baf1b0@cox.net>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Mon, 04 Apr 2016 00:19:25 +0200 as excerpted:

> The corruptions seem to be different by the following observation:
> 
> While the VDI file was corrupted over and over again with a csum error,
> I could simply remove it and restore from backup. The last thing I did
> was ddescue it from the damaged version to my backup device, than rsync
> the file back to the originating device (which created a new file
> side-by-side, so in a new area of disk space, then replace-by-renamed
> the old one). I didn't run VirtualBox since back then but the file
> didn't become corrupted either since then.
> 
> But now, according to btrfsck, a csum error instead came up in another
> big file from Steam. This time, when I rm the file, the kernel
> backtraces and sends btrfs to RO mode. The file cannot be removed. I'm
> going to leave it that way currently, the file won't be used currently.
> And I can simply ignore it for backup and restore, it's not an important
> one. Better have an "incorrectable" csum error there than having one
> jumping unpredictably across my files.

While my dying ssd experience was with btrfs raid1 direct on a pair of 
ssds, extrapolating from what I learned about the ssd behavior to your 
case with bcache caching to the ssd, then writing back to the spinning 
rust backing store, presumably in btrfs single-device mode with single 
data and either single or dup metadata (there's enough other cases 
interwoven on this thread its no longer clear to me which posted btrfs fi 
show, etc, apply to this case, so I'm guessing, as I believe presenting 
it as more than a single device at the btrfs level would require multiple 
bcache devices, tho of course you could do that by partitioning the 
ssd)...

Would lead me to predict very much the behavior you're seeing, if the 
caching ssd was dying.

As bcache is running below btrfs, btrfs won't know anything about it, and 
therefore, will behave, effectively, as if it's not there -- an error on 
the ssd will look like an error on the btrfs, period.  (As I'm assuming a 
single btrfs device, which device of the btrfs doesn't come into 
question, tho which copy of dup metadata might... but that's an entirely 
different can of worms since I'm not sure whether the bcache would end up 
deduping the dup metadata or not, and the ssd might do the same, and...)

And with bcache doing write-behind from the ssd to the backing store, 
underneath the level at which btrfs could detect and track csum 
corruption, if it's corrupt on the ssd, that corruption then transfers to 
the backing store as btrfs won't know that transfer is happening at all 
and thus won't be in the loop to detect the csum error at that stage.


Meanwhile, what I saw on the pair of ssds, one going bad, in btrfs raid1 
mode, was that a btrfs scrub *WOULD* successfully detect the csum errors 
on the bad ssd, and rewrite it from the remaining good copy.

Keep in mind that this is without snapshots, so that rewrite, while COW, 
would then release the old copy back into the free space pool.  In so 
doing, it would trigger the ssd firmware to copy the rest of the erase-
block and erase it, and that in turn would trigger the firmware to detect 
the bad sector and replace it with one from its spare-sectors list.  As a 
result, it would tick up the raw value of attribute #5, 
Reallocated_Sector_Ct, as well as 182, Erase_Fail_Count_Total, in smartctl 
-A (tho the two attributes didn't increase in numeric lock-step, both 
were increasing over time, primarily when I ran scrubs).


But it was mostly (almost entirely) when I ran the scrubs and 
consequently rewrote the corrupted sectors from the copy on the good 
device, that it would trigger those erase-fails and sector reallocations.

Anyway, the failing ssd's issues gradually got worse, until I was having 
to scrub and trigger both filesystem recopy and bad ssd sector rewrites 
any time I wrote anything major to the filesystem as well as at cold-boot 
(leaving the system off for several hours apparently accelerated the 
sector rot within stable data, while the powered-on state kept the flash 
cells charged high enough they didn't rot so fast and it was mostly or 
entirely new/changed data I had to worry about).  Eventually I simply 
decided I was tired of the now more or less constant hassle and I wasn't 
learning much new any more from the decaying device's behavior, and I 
replaced it.


Translating that to your case, if your caching ssd is dying and some 
sectors are now corrupted, unless there's a second btrfs copy of that 
block to copy over the bad version with, it's unlikely to trigger those 
sector reallocations.

Tho actually rewriting them (or at the device firmware level, COWing them 
and erasing the old erase-blocks), as bcache will be doing if it dumps 
the current cache content and fills those blocks with something else, 
should trigger the same thing, tho unless bcache can force-dump and 
recache or something, I don't believe there's a systematic way to trigger 
it over all cached data as btrfs scrub does.

Anyway, if I'm correct and as your ordering the new ssd indicates you may 
suspect as well, the problem may indeed be that ssd, and a new ssd 
(assuming /it/ isn't defective) should fix it, tho the existing damage on 
the existing btrfs may or may not be fully recoverable once you get a new 
ssd and thus don't have to worry about further damage from the old one.

Meanwhile, putting bcache into write-around mode, so it makes no further 
changes to the ssd and only uses it for reads, is probably wise, and 
should help limit further damage.  Tho if in that mode bcache still does 
writeback of existing dirty and cached data to the backing store, some 
further damage could occur from that.  But I don't know enough about 
bcache to know what its behavior and level of available configuration in 
that regard actually are.  As long as it's not trying to write anything 
from the ssd to the backing store, I think further damage should be very 
limited.

But were you running btrfs raid1 without bcache, or with multiple devices 
at the btrfs level, each bcached but to separate ssds so any rot wouldn't 
be likely to transfer between them increasing the chances of both copies 
being bad at once, I expect you'd be seeing behavior on your ssd very 
close to what I saw on my failing one, and assuming your other device was 
fine, you could still be scrubbing and recovering fine, as I was, tho 
with the necessary frequency of scrubs increasing over time (and not 
helped by the recently reported too many csum errors on compressed 
content, even when they're on raid1 and should recover from the other 
copy, crashing btrfs and the system, thus requiring more frequent scrubs 
than would otherwise be required -- I ran into this too, but didn't 
realize it only triggered on compressed content and was thus a specific 
bug, and simply attributed it to btrfs not yet being fully stable and 
believed that's what it always did with too many crc errors, even when 
they should be recoverable from the good raid1 copy).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

