Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55999 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbcG0BKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 21:10:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bSDMv-0001no-D1
	for linux-btrfs@vger.kernel.org; Wed, 27 Jul 2016 03:10:41 +0200
Received: from ip-64-134-228-15.public.wayport.net ([64.134.228.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 03:10:41 +0200
Received: from 1i5t5.duncan by ip-64-134-228-15.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 03:10:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi defrag -r -t 32M? What is actually happening?
Date: Wed, 27 Jul 2016 01:10:35 +0000 (UTC)
Message-ID: <pan$acc$75dc71b8$532c7a5c$47aab598@cox.net>
References: <CAD=QJKhXC4OR1BanS2p1Kb0cHunduY9ETPwwhphkeCfHxOXA0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Tue, 26 Jul 2016 19:03:53 -0400 as excerpted:

> Hi,
> 
> I've been using btrfs fi defrag with out the "-r -t 32M" option for
> regular maintenance.  I just learned, in
> Documentation/btrfs-convert.asciidoc, that there is a recommendation
> to run with "-t 32M" after a conversion from ext2/3/4.  I then
> cross-referenced this with btrfs-filesystem(8), and found that:
> 
>     Extents bigger than value given by -t will be skipped, otherwise
>     this value is used as a target extent size, but is only advisory
>     and may not be reached if the free space is too fragmented. Use 0
>     to take the kernel default, which is 256kB but may change in the
>     future.
> 
> I understand the default behaviour of target extent size of 256kB to
> mean only defragment small files and metadata.  Or does this mean that
> the default behaviour is to defragment extent tree metadata >256kB,
> and then defragment the (larger than 256kB) data from many extents
> into a single extent?  I was surprised to read this!
> 
> What's really happening with this default behaviour?  Should everyone
> be using -t with a much larger value to actually defragment their
> databases?

Something about defrag's -t option should really be in the FAQ, as it is 
known to be somewhat confusing and to come up from time to time, tho this 
is the first time I've seen it in the context of convert.

In general, you are correct in that the larger the value given to -t, the 
more defragging you should ultimately get.  There's a practical upper 
limit, however, the data chunk size, which is nominally 1 GiB (tho on 
tiny btrfs it's smaller and on TB-scale it can be larger, to 8 or 10 GiB 
IIRC).  32-bit btrfs-progs defrag also had a bug at one point that would 
(IIRC) kill the parameter if it was set to 2+ GiB -- that has been fixed 
by hard-coding the 32-bit max to 1 GiB, I believe.  The bug didn't affect 
64-bit.  In any case, 1 GiB is fine, and often the largest btrfs can do 
anyway, due as I said to that being the normal data chunk size.

And btrfs defrag only deals with data.  There's no metadata defrag, tho 
balance -m (or whole filesystem) will normally consolidate the metadata 
into the fewest (nominally 256 MiB) metadata chunks possible as it 
rewrites them.

In that regard a defrag -t 32M recommendation is reasonable for a 
converted filesystem, tho you can certainly go larger... to 1 GiB as I 
said.

On a converted filesystem, however, there's possibly the opposite issue 
as well -- on btrfs, as stated, extents are normally limited to chunk 
size, nominally 1 GiB (the reason being for chunk management, with the 
indirection chunks provide allowing balance to do all the stuff it can 
do, like converting between different raid levels), while ext* apparently 
has no such limitation.  If the initial post-saved-subvol-delete defrag 
and balance don't work correctly -- they've been buggy at times in the 
past and haven't, then it can be the problem blocking a successful full 
balance is huge files with single extents larger than a GiB, that didn't 
get broken up into btrfs-native chunk-sized extents.  At times people 
have had to temporarily move these off the filesystem, thus clearing the 
> 1 GiB extents they took, and back on, thus recreating them with btrfs-
native chunk-size extents, maximum.


Of course all this is in the context of btrfs-convert.  But it's not 
really a recommended conversion path anyway, tho it's recognized as 
ultimately a pragmatic necessity.  The reasoning goes like this.  Before 
you do anything as major as filesystem conversion in the first place, 
full backups of anything you wish to keep are strongly recommended, 
because it's always possible something will go wrong during the convert.  
No sane sysadmin would attempt the conversion without a backup, unless 
the data really was defined as worth less than the cost of the space 
required to store that backup, because sane sysadmins recognize that 
attempting that sort of risky operation without a backup is by definition 
of the risk associated with the operation, defining that data as simply 
not worth the trouble -- they'd literally prefer to lose the data rather 
than pay the time/hassle/resource cost of having a backup.

And once the requirement of a full backup (or alternatively, that the 
data is really not worth the hassle) is recognized, it's far easier and 
faster to simply mkfs.btrfs a brand new btrfs and copy everything over 
from the old ext*, in the process leaving /it/ as the backup, than it is 
to go thru the hassle of doing the backup (and thus the same copy step 
you'd do copying the old data to the new filesystem) anyway, then the 
convert-in-place, then testing that it worked, then deleting the saved 
subvolume with the ext* metadata, then doing the defrag and balance, 
before you can be sure your btrfs is properly cleaned up and ready for 
normal use, and thus the btrfs convert fully successful.

Meanwhile, even when functioning perfectly, convert, because it /is/ 
dealing with the data and metadata in-place, isn't going to give you the 
flexibility or choices, nor the performance, of a freshly created btrfs, 
created with the options you want, and freshly populated with cleanly 
copied and thus fully native and defragged data and metadata from the 
old, now backup, copy.

So to a sysadmin considering the risks involved, convert gains you 
nothing and loses you lots, compared to starting with a brand new 
filesystem and copying everything over, thus letting the old filesystem 
remain in place as the initial backup until you're confident the data on 
the new filesystem is complete and the filesystem functioning properly as 
a full replacement for the old, now backup, copy.

Never-the-less, having a convert utility is "nice", and pragmatically 
recognized as a practical necessity, if btrfs is to eventually supplant 
ext* as the assumed Linux default filesystem, because despite all the 
wisdom saying otherwise and risk and disadvantages of convert-in-place, 
some people will never have those backups and will just take that risk, 
and without a convert utility, will simply remain with ext*.

(It's worth noting that arguably, those sorts of people shouldn't be 
switching to the still maturing filesystem in the first place, as backups 
or only testing with "losable" data is still strongly recommended for 
those wishing to try btrfs.  People who aren't willing to deal with 
backups really should be sticking to a rather more mature and stable 
filesystem than btrfs in its current state, and once they /are/ willing 
to deal with backups, the choice of a brand new btrfs and copy everything 
over from the old filesystem, which then becomes the backup, becomes so 
much better than convert, that there's simply no sane reason to use 
convert in the first place.  Thus, arguably, the only people using 
convert at this point should be those with the specific purpose of 
testing it, in ordered to be sure it's ready for that day when btrfs 
really is finally stable enough that it can in clear conscience be 
recommended to people without backups, as at least as stable and problem
free as whatever they were using previously.  Tho that day's likely some 
years in the future.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

