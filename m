Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43472 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbcCRXGX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 19:06:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ah3TJ-0001Pk-6N
	for linux-btrfs@vger.kernel.org; Sat, 19 Mar 2016 00:06:21 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 00:06:21 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 00:06:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [4.4.1] btrfs-transacti frequent high CPU usage despite little
 fragmentation
Date: Fri, 18 Mar 2016 23:06:04 +0000 (UTC)
Message-ID: <pan$c1998$42b65a7e$8b396259$757615d8@cox.net>
References: <56E92B38.10605@inoio.de>
	<pan$4920$33ddf09b$49bd87c9$2053e366@cox.net> <56EBCB7A.1010508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ole Langbehn posted on Fri, 18 Mar 2016 10:33:46 +0100 as excerpted:

> Duncan,
> 
> thanks for your extensive answer.
> 
> On 17.03.2016 11:51, Duncan wrote:
>> Ole Langbehn posted on Wed, 16 Mar 2016 10:45:28 +0100 as excerpted:
>> 
>> Have you tried the autodefrag mount option, then defragging?  That
>> should help keep rewritten files from fragmenting so heavily, at least.
>>  On spinning rust it doesn't play so well with large (half-gig plus)
>> databases or VM images, but on ssds it should scale rather larger; on
>> fast SSDs I'd not expect problems until 1-2 GiB, possibly higher.
> 
> Since I do have some big VM images, I never tried autodefrag.

OK.  Tho as you're on ssd you might consider /trying/ it.  The big 
problem with autodefrag and big VMs and DBs is that as the filesize gets 
larger, it becomes more difficult for autodefrag to keep up with the 
incoming stream of modifications, but ssds tend to be fast enough that 
they can keep up for far longer, and it may be that you won't see a 
noticeable issue.  If you do, you can always turn the mount option back 
off.

Also, nocow should mean autodefrag doesn't affect the file anyway, as it 
won't be fragmenting due to the nocow.  So if you have your really large 
VMs and DBs set nocow, it's quite likely, particularly on ssd, that you 
can set autodefrag and not see the performance problems with those large 
files that's the reason it's normally not recommended for the large db/vm 
use-case.

And like I said you can always turn it back off if necessary.

>> For large dbs or VM images, too large for autodefrag to handle well,
>> the nocow attribute is the usual suggestion, but I'll skip the details
>> on that for now, as you may not need it with autodefrag on an ssd,
>> unless your database and VM files are several gig apiece.
> 
> Since posting the original post, I experimented with setting the firefox
> places.sqlite to nodatacow (on a new file). 1 extent since, seems to
> work.

Seems you are reasonably familiar with the nocow attribute drill, so I'll 
just cover one remaining base, in case you missed it.

Nocow interacts with snapshots.  Basically, snapshots turn nocow into 
cow1, because they lock the existing version in place due to the 
snapshot.  First changes to a block after a snapshot, then, must be cow, 
tho further changes to it after that remain nocow to the new in-place 
location.

So nocow isn't fully nocow with snapshots, and fragmentation will slow 
down, but not be eliminated.  People doing regularly scheduled 
snapshotting therefore often need to do less frequent but also regularly 
scheduled (perhaps weekly or monthly, for multiple snapshots per day) 
defrag of their nowcow files.

Tho be aware that for performance reasons, defrag isn't snapshot aware 
and will break reflinks to existing snapshots, thereby increasing 
filesystem usage.  The total effect on usage of course depends on how 
much updating the nocow files get as well as snapshotting and defrag 
frequency.

>>> BTW: I did a VACUUM on the sqlite db and afterwards it had 1 extent.
>>> Expected, just saying that vacuuming seems to be a good measure for
>>> defragmenting sqlite databases.
>> 
>> I know the concept, but out of curiousity, what tool do you use for
>> that?  I imagine my firefox sqlite dbs could use some vacuuming as
>> well, but don't have the foggiest idea how to go about it.
> 
> simple call of the command line interface, like with any other SQL DB:
> 
> # sqlite3 /path/to/db.sqlite "VACUUM;"

Cool.  As far as I knew, sqlite was library only, no executable to invoke 
in that manner.  Shows how little I knew about sqlite. =:^)  Thanks.

>> Of *most* importance, you really *really* need to do something about
>> that data chunk imbalance, and to a lessor extent that metadata chunk
>> imbalance, because your unallocated space is well under a gig (306
>> MiB), with all that extra space, hundreds of gigs of it, locked up in
>> unused or only partially used chunks.
> 
> I'm curious - why is that a bad thing?

Btrfs allocates space in two stages, first to chunks of data or metadata 
type (there's also system type but that's pretty much fixed size so once 
the filesystem is created, no further system chunks are normally needed, 
unless it's created as a single device filesystem and then a whole slew 
of additional devices are added, or if the filesystem is massively resized 
on the same device, of course), then from within those chunks to files 
from data, and to metadata nodes from metadata, as necessary.

What can happen then, and used to happen frequently before 3.17, tho much 
less frequently but it can still happen now, is that over time and with 
use, the filesystem will allocate all available space as one type, 
typically data chunks, and then run out of space in the other type of 
chunk, typically metadata, and have no unallocated space from which to 
allocate more.   So you'll have lots of space left, but it'll be all tied 
up in only partially used chunks of the one type and you'll be out of 
space in the other type.

And by the time you actually start getting ENOSPC errors as a result of 
the situation, there's often too little space left to create even the one 
additional chunk necessary for a balance to write the data from other 
chunks into, in ordered to combine some of the less used chunks into 
fewer chunks at 100% usage (but for the last one, of course).

And you were already in a tight spot in that regard and may well have had 
errors if you had simply tried an unfiltered balance, because data chunks 
are typically 1 GiB in size (and can be upto 10 GiB in some circumstances 
on large enough filesystems, tho I think the really large sizes require 
multi-device), and you were down to 300-ish MiB of unallocated space, not 
enough to create a new 1 GiB data chunk.

And considering the filesystem's near terabyte scale, to be down to under 
a GiB of unallocated space is even more startling, particularly on newer 
kernels where empty chunks are normally reclaimed automatically (tho as 
the usage=0 balances reclaimed some space for you, obviously not all of 
them had been reclaimed in your case).

That was what was alarming to me, and it /may/ have had something to do 
with the high cpu and low speeds, tho indications were that you still had 
enough space in both data and metadata that it shouldn't have been too 
bad just yet.  But it was potentially heading that way, if you didn't do 
something, which is why I stressed it as I did.  Getting out of such 
situations once you're tightly jammed can be quite difficult and 
inconvenient, tho you were lucky enough not to be that tightly jammed 
just yet, only headed that way.

>> The subject says 4.4.1, but it's unclear whether that's your kernel
>> version or your btrfs-progs userspace version.

> # uname -r 4.4.1-gentoo
> 
> # btrfs --version btrfs-progs v4.4.1
> 
> So, both 4.4.1 ;)

=:^)

>> Try this:
>> 
>> btrfs balance start -dusage=0 -musage=0.
> 
> Did this although I'm reasonably up to date kernel-wise. I am very sure
> that the filesystem has never seen <3.18. Took some minutes, ended up
> with
> 
> # btrfs filesystem usage /
> Overall:
>     Device size:                 915.32GiB
>     Device allocated:            681.32GiB
>     Device unallocated:          234.00GiB
>     Device missing:                  0.00B
>     Used:                        153.80GiB
>     Free (estimated):            751.08GiB      (min: 751.08GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:667.31GiB, Used:150.22GiB
>    /dev/sda2     667.31GiB
> 
> Metadata,single: Size:14.01GiB, Used:3.58GiB
>    /dev/sda2      14.01GiB
> 
> System,single: Size:4.00MiB, Used:112.00KiB
>    /dev/sda2       4.00MiB
> 
> Unallocated:
>    /dev/sda2     234.00GiB
> 
> 
> -> Helped with data, not with metadata.

Yes, and most importantly, you're already out of the tight jam you were 
headed into, now with a comfortable several hundred gigs of unallocated 
space. =:^)

With that, the specific hoops weren't all necessary for further steps.  
In particular, I was afraid that wouldn't clear any chunks at all and 
you'd still have under a GiB free, still too small to properly balance 
data chunks, thus the suggestion to start with metadata and hoping it 
worked.

>> Then start with metadata, and up the usage numbers which are
>> percentages,
>> like this:
>> 
>> btrfs balance start -musage=5.
>> 
>> Then if it works up the number to 10, 20, etc.
> 
> upped it up to 70, relocated a total of 13 out of 685 chunks:
> 
> Metadata,single: Size:5.00GiB, Used:3.58GiB
>    /dev/sda2       5.00GiB

So you cleared a few more gigs to unallocated, as metadata total was 14 
GiB, now it's 5 GiB, much more in line with used (especially given the 
fact that your half a GiB of global reserve comes from metadata but 
doesn't count as used in the above figure, so you're effectively a bit 
over 4 GiB used, meaning you may not be able to free more even if 
balancing all metadata chunks with just -m, no usage filter).


>> Once you have several gigs in unallocated, then try the same thing with
>> data:
>> 
>> btrfs balance start -musage=5
>> 
>> And again, increase it in increments of 5 or 10% at a time, to 50 or
>> 70%.
> 
> did
> 
> # btrfs balance start -dusage=70
> 
> straight away, took ages, regularly froze processes for minutes, after
> about 8h status is:
> 
> # btrfs balance status /
> Balance on '/' is paused
> 192 out of about 595 chunks balanced (194 considered),  68% left
> # btrfs filesystem usage /
> Overall:
>     Device size:                 915.32GiB
>     Device allocated:            482.04GiB
>     Device unallocated:          433.28GiB
>     Device missing:                  0.00B
>     Used:                        154.36GiB
>     Free (estimated):            759.48GiB      (min: 759.48GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   1.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:477.01GiB, Used:150.80GiB
>    /dev/sda2     477.01GiB
> 
> Metadata,single: Size:5.00GiB, Used:3.56GiB
>    /dev/sda2       5.00GiB
> 
> System,single: Size:32.00MiB, Used:96.00KiB
>    /dev/sda2      32.00MiB
> 
> Unallocated:
>    /dev/sda2     433.28GiB
> 
> -> Looking good. Will proceed when I don't need the box to actually be
> responsive.

The thing with the usage= filter is this.  Balancing empty (usage=0) 
chunks simply deletes them so is nearly instantaneous, and obviously 
reclaims 100% of the space because they were empty, so huge bang for the 
buck.  Balancing nearly empty chunks is still quite fast since there's 
very little data to rewrite and compact into the new chunks, and 
obviously, at usage=10, lets you compact 10 or more only 10% used or less 
chunks into one new chunk, so as long as you have a lot of them, you 
still gets really good bang for the buck.

But as usage increases, you're writing more and more data, for less and 
less bang for the buck.  At half full, 50% usage, balance is only 
combining two chunks into one, while writing the same amount of data to 
recover only one chunk of the two, as it was writing to recover 9 chunks 
out of 10, at 10% usage.

So when the filesystem still has a lot of room, a lot of people stop at 
say usage=25, where they're still recovering 3/4 of the chunks, or 
usage=33, where they're recovering 2/3.  As the filesystem fills up, they 
may need to do usage=50, recovering only 1/2 of the chunks rewritten, and 
eventually, usage=67 or 70, writing three chunks into two, and thus 
recovering only one chunk's worth of space for every three written, 1/3.

It's rarely useful to go above that, unless you're /really/ pressed for 
space, and then it's simpler to just do a balance without that filter and 
balance all chunks, tho you can still use -d or -m to only do data or 
metadata chunks, if desired.

That's why I suggested you bump the usage up in increments, with my 
intention, tho I guess I didn't clearly state it, being that you'd stop 
once total dropped reasonably close to used, for data, say 300 GiB total, 
150 used, or if you were lucky, 200 GiB total, 150 used.

With luck that would have happened at say -dusage=40 or -dusage=50, while 
your bang for the buck was still reclaiming at least half of the chunks 
in the rewrite, and -dusage=70 would have never been needed.

That's why you found it taking so long.

Meanwhile, discussion in another thread reminded me of another factor, 
quotas.

For a long time quotes were simply broken in btrfs as the code was buggy 
and various corner-cases resulted in negative (!!) reported usage and the 
like.  With kernel 4.4, known corner-case bugs are in general fixed and 
the numbers should finally be correct, but there's still a LOT of quota 
overhead for balance, etc.  They're discussing right now whether part or 
all of that can be eliminated, but for the time being, anyway, active 
btrfs quotas incur a /massive/ balance overhead, so if you use quotas and 
are going to be doing more than trivial balances, it's worth turning them 
off temporarily for the balance if you can, then rescanning after the 
balance when you turn them back on, if you do need them and didn't simply 
have quotas on because you could.  Of course depending on how you are 
using quotas, turning them off for the balance might not be an option, 
but if you can, it will avoid effectively repeated rescans during the 
balance, and while the rescan while turning them back on will take some 
time, it should take far less than the time lost to the repeated rescans 
if they're enabled during the balance.

I believe btrfs check is similarly afflicted with massive quota overhead, 
tho I'm not sure if it's /as/ bad for check.

I've never had quotas enabled here at all, however, as I don't really 
need them and the negatives are still too high, even if they're actually 
working now, and I entirely forgot about them when I was recommending the 
above to help get your chunk usage vs. total back under control.

So if you're using quotas, consider turning them off at least temporarily 
when you do reschedule those balances.  In fact, you may wish to leave 
them off if you don't really need them, at least until they figure out 
how to reduce the overhead they currently trigger in balance and check.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

