Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37660 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaAZVo1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jan 2014 16:44:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W7XV9-0000jr-4U
	for linux-btrfs@vger.kernel.org; Sun, 26 Jan 2014 22:44:23 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2014 22:44:23 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jan 2014 22:44:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Options for SSD - autodefrag etc?
Date: Sun, 26 Jan 2014 21:44:00 +0000 (UTC)
Message-ID: <pan$7fa2c$63fcd33a$64312f4a$d9ed1b9@cox.net>
References: <52E19667.6090005@gmail.com>
	<pan$3043$d8104a03$9e09c506$6ce38ae5@cox.net> <2056077.lUO7kt9W8r@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sat, 25 Jan 2014 13:54:40 +0100 as excerpted:

> Hi Duncan,
> 
> Am Freitag, 24. Januar 2014, 06:54:31 schrieb Duncan:
>> Anyway, yes, I turned autodefrag on for my SSDs, here, but there are
>> arguments to be made in either direction, so I can understand people
>> choosing not to do that.
> 
> Do you have numbers to back up that this gives any advantage?

Your post (like some of mine) reads like a stream of consciousness more 
than a well organized post, making it somewhat difficult to reply to (I 
guess I'm now experiencing the pain others sometimes mention when trying 
to reply to some of mine).  However, I'll try...

I haven't done benchmarks, etc, nor do I have them at hand to quote, if 
that's what you're asking for.  But of course I did say I understand the 
arguments made by both sides, and just gave the reasons why I made the 
choice I did, here.

What I /do/ have is the multiple post here on this list from people 
complaining about pathologic[1] performance issues due to large-internal-
written-file fragmentation even on SSDs, particularly so when interacting 
with non-trivial numbers of snapshots as well.  That's a case that at 
present simply Does. Not. Scale. Period!

Of course the multi-gig internal-rewritten-file case is better suited to 
the NOCOW extended attribute than to autodefrag, but anyway...

> I have it disabled and yet I have things like:
> 
> Oh, this is insane. This filefrags runs for over [five minutes]
> already. And hogging on one core eating almost 100% of its processing
> power.

> /usr/bin/time -v filefrag soprano-virtuoso.db

> Well, now that command completed:
> 
> soprano-virtuoso.db: 93807 extents found
>         Command being timed: "filefrag soprano-virtuoso.db"
>         User time (seconds): 0.00
>         System time (seconds): 338.77
>         Percent of CPU this job got: 98%
>         Elapsed (wall clock) time (h:mm:ss or m:ss): 5:42.81

I don't see any mention of the file size.  I'm (informally) collecting 
data on that sort of thing ATM, since it's exactly the sort of thing I 
was referring to, and I've seen enough posts on the list about it to have 
caught my interest.

FWIW I'll guess something over a gig, perhaps 2-3 gigs...

Also FWIW, while my desktop of choice is indeed KDE, I'm running gentoo, 
and turned off USE=semantic-desktop and related flags some time ago 
(early kde 4.7, so over 2.5 years ago now), entirely purging nepomuk, 
virtuoso, etc, from my system.  That was well before I switched to btrfs, 
but the performance improvement from not just turning it off at runtime 
(I already had it off at runtime) but entirely purging it from my system 
was HUGE, I mean like clean all the malware off an MS Windows machine and 
see how much faster it runs HUGE, *WELL* more than I expected!  (I had 
/expected/ just to get rid of a few packages that I'd no longer have to 
update, little or no performance improvement at all, since I already the 
data indexing, etc, turned off to the extent that I could, at runtime.  
Boy was I surprised, but in a GOOD way! =:^)

Anyway, because I have that stuff not only disabled at runtime but 
entirely turned off at build time and purged from the system as well, I 
don't have such a database file available here to compare with yours.  
But I'd certainly be interested in knowing how big yours actually was, 
since I already have both the filefrag report on it, and your complaint 
about how long it took filefrag to compile that information and report 
back.

> Well I have some files with several ten thousands extent. But first,
> this is mounted with compress=lzo, so 128k is the largest extent size as
> far as I know

Well, you're mounting with compress=lzo (which I'm using too, FWIW), not 
compress-force=lzo, so btrfs won't try to compress it if it thinks it's 
already compressed.

Unfortunately, I believe there's no tool to report on whether btrfs has 
actually compressed the file or not, and as you imply filefrag doesn't 
know about btrfs compression yet, so just running the filefrag on a file 
on a compress=lzo btrfs doesn't really tell you a whole lot. =:^(

What you /could/ do (well, after you've freed some space given your 
filesystem usage information below, or perhaps to a different filesystem) 
would be copy the file elsewhere, using reflink=no just to be sure it's 
actually copied, and see what filefrag reports on the new copy.  Assuming 
enough free space btrfs should write the new file as a single extent, so 
if filefrag reports a similar number of extents on the new copy, you'll 
know it's compression related, while if it reports only one or a small 
handful of extents, you'll know the original wasn't compressed and it's 
real fragmentation.

It would also be interesting to know how long a filefrag on the new file 
takes, as compared to the original, but in ordered to get an apples to 
apples comparison, you'd have to either drop-caches before doing the 
filefrag on the new one, or reboot, since after the copy it'd be cached, 
while the 5+ minute time on the original above was presumably with very 
little of the file actually cached.

And of course you could temporarily mount without the compress=lzo option 
and do the copy, if you find it is the compression triggering the extents 
report from filefrag, just to see the difference compression makes.  Or 
similarly, you could mount with compress-force=lzo and try it, if you 
find btrfs isn't compressing the file with ordinary compress=lzo, again 
to see the difference that makes.

> and second: I did manual btrfs filesystem defragment on
> files like those and and never ever perceived any noticable difference
> in performance.
> 
> Thus I just gave up on trying to defragment stuff on the SSD.

I still say it'd be interesting to see the (from cold-cache) filefrag 
report and timing on a fresh copy, compared to the 5 minute plus timing 
above.

> And this is really quite high.

> But… I think I have a more pressing issue with that BTRFS /home
> on an Intel SSD 320 and that is that it is almost full:
> 
> merkaba:~> LANG=C df -hT /home
> Filesystem               Type   Size Used Avail Use% Mounted on
> /dev/mapper/merkaba-home btrfs  254G 241G  8.5G  97% /home

Yeah, that's uncomfortably close to full...


(FWIW, it's also interesting comparing that to a df on my /home...

$>> df .
Filesystem     2M-blocks  Used Available Use% Mounted on
/dev/sda6          20480 12104      7988  61% /h

As you can see I'm using 2M blocks (alias df=df -B2M), but the filesystem 
is raid1 both data and metadata, so the numbers would be double and the 
2M blocks are thus 1M block equivalent.  (You can also see that I've 
actually mounted it on /h, not /home.  /home is actually a symlink to /h 
just in case, but I export HOME=/h/whatever, and most programs honor 
that.)

So the partition size is 20480 MiB or 20.0 GiB, with ~12+ GiB used, just 
under 8 GiB available.

It can be and is so small because I have a dedicated media partition with 
all the big stuff located elsewhere (still on reiserfs on spinning rust, 
as a matter of fact).

Just interesting to see how people setup their systems differently, is 
all, thus the "FWIW". But the small independent partitions do make for 
much shorter balance times, etc! =:^)

> merkaba:~> btrfs filesystem show […]
> Label: home  uuid: […]
>         Total devices 1 FS bytes used 238.99GiB
>         devid  1 size 253.52GiB used 253.52GiB path [...]
> 
> Btrfs v3.12
> 
> merkaba:~> btrfs filesystem df /home
> Data, single: total=245.49GiB, used=237.07GiB
> System, DUP: total=8.00MiB, used=48.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=4.00GiB, used=1.92GiB
> Metadata, single: total=8.00MiB, used=0.00

It has come up before on this list and doesn't hurt anything, but those 
extra system-single and metadata-single chunks can be removed.  A balance 
with a zero usage filter should do it.  Something like this:

btrfs balance start -musage=0

That will act on metadata chunks with usage=0 only.  It may or may not 
act on the system chunk.  Here it does, and metadata implies system also, 
but someone reported it didn't, for them.  If it doesn't...

btrfs balance start -f -susage=0

... should do it.  (-f=force, needed if acting on system chunk only.)

https://btrfs.wiki.kernel.org/index.php/Balance_Filters

(That's for the filter info, not well documented in the manpage yet.  The 
manpage documents btrfs balance fairly well tho, other than that.)


Anyway... 252 gigs used of 252 total in filesystem show.  That's full 
enough you may not even be able to balance as there's no unallocated 
blocks left to allocate for the balance.  But the usage=0 thing may get 
you a bit of room, after which you can try usage=1, etc, to hopefully 
recover a bit more, until you get at least /some/ unallocated space as a 
buffer to work with.  Right now, you're risking being unable to allocate 
anything more when data or metadata runs out, and I'd be worried about 
that.


> Okay, I could probably get back 1,5 GiB on metadata, but whenever I
> tried a btrfs filesystem balance on any of the BTRFS filesystems on my
> SSD I usually got the following unpleasant result:
> 
> Halve of the performance. Like double boot times on / and such.

That's weird.  I wonder why/how, unless it's simply so full an SSD that 
the firmware's having serious trouble doing its thing.  I know I've seen 
nothing like that on my SSDs.  But then again, my usage is WILDLY 
different, with my largest partition 24 gigs, and only about 60% of the 
SSD even partitioned at all because I keep the big stuff like media files 
on spinning rust (and reiserfs, not btrfs), so the firmware has *LOTS* of 
room to shuffle blocks around for write-cycle balancing, etc.

And of course I'm using a different brand SSD.  (FWIW, Corsair Neutron 
256 GB, 238 GiB, *NOT* the Neutron GTX.)  But if anything, Intel SSDs 
have a better rep than my Corsair Neutrons do, so I doubt that has 
anything to do with it.

> So I have the following thoughts:
> 
> 1) I am not yet clear whether defragmenting files on SSD will really
> bring a benefit.

Of course that's the question of the entire thread.  As I said, I have it 
turned on here, but I understand the arguments for both sides, and from 
here that question does appear to remain open for debate.

One other related critical point while we're on the subject.

A number of people have reported that at least for some distros installed 
to btrfs, brand new installs are coming up significantly fragmented.  
Apparently some distros do their install to btrfs mounted without 
autodefrag turned on.

And once there's existing fragmentation, turning on autodefrag /then/ 
results in a slowdown for several boot cycles, as normal usage detects 
and queues for defrag, then defrags, all those already fragmented files.  
There's an eventual speedup (at least on spinning rust, SSDs of course 
are open to question, thus this thread), but the system has to work thru 
the existing backlog of fragmentation before you'll see it.

Of course one way out of that (temporary but sometimes several days) pain 
is to deliberately run a btrfs defrag recursive (new enough btrfs has a 
recursive flag, previous to that, one had to play some tricks with find, 
as documented on the wiki) on the entire filesystem.  That will be more 
intense pain, but it'll be over faster! =:^)

The point being, if a reader is considering autodefrag, be SURE and turn 
it on BEFORE there's a whole bunch of already fragmented data on the 
filesystem.

Ideally, turn it on for the first mount after the mkfs.btrfs, and never 
mount without it.  That ensures there's never a chance for fragmentation 
to get out of hand in the first place. =:^)

(Well, with the additional caveat that the NOCOW extended attribute is 
used appropriately on internal-rewrite files such as VM images, 
databases, bittorrent preallocations, etc, when said file approaches a 
gig or larger.  But that is discussed elsewhere.)

> 2) On my /home problem is more that it is almost full and free space
> appears to be highly fragmented. Long fstrim times speak tend to agree
> with it:
> 
> merkaba:~> /usr/bin/time fstrim -v /home
> /home: 13494484992 bytes were trimmed
> 0.00user 12.64system 1:02.93elapsed 20%CPU

Some people wouldn't call a minute "long", but yeah, on an SSD, even at 
several hundred gig, that's definitely not "short".

It's not well comparable because as I explained, my partition sizes are 
so much smaller, but for reference, a trim on my 20-gig /home took a bit 
over a second.  Doing the math, that'd be 10-20 seconds for 200+ gigs.  
That you're seeing a minute, does indeed seem to indicate high free-space 
fragmentation.

But again, I'm at under 60% SSD space even partitioned, so there's LOTS 
of space for the firmware to do its management thing.  If your SSD is 256 
gig as mine, with 253+ gigs used (well, I see below it's 300 gig, but 
still...) ... especially if you're not running with the discard mount 
option (which could be an entire thread of its own, but at least there's 
some official guidance on it), that firmware could be working pretty hard 
indeed with the resources it has at its disposal!

I expect you'd see quite a difference if you could reduce that to say 80% 
partitioned and trim the other 20%, giving the firmware a solid 20% extra 
space to work with.

If you could then give btrfs some headroom on the reduced size partition 
as well, well...

> 3) Turning autodefrag on might fragment free space even more.

Now, yes.  As I stressed above, turn it on when the filesystem's new, 
before you start loading it with content, and the story should be quite 
different.  Don't give it a chance to fragment in the first place. =:^)

> 4) I have no clear conclusion on what maintenance other than scrubbing
> might make sense for BTRFS filesystems on SSDs at all. Everything I
> tried either did not have any perceivable effect or made things worse.

Well, of course there's backups.  Given that btrfs isn't fully stabilized 
yet and there are still bugs being worked out, those are *VITAL* 
maintenance! =:^)

Also, for the same reason (btrfs isn't yet fully stable), I recently 
refreshed and double-checked my backups, then blew away the existing 
btrfs with a fresh mkfs.btrfs and restored from backup.

The brand new filesystems now make use of several features that the older 
ones didn't have, including the new 16k nodesize default. =:^)  For 
anyone who has been running btrfs for awhile, that's potentially a nice 
improvement.

I expect to do the same thing at least once more, later on after btrfs 
has settled down to more or less routine stability, just to clear out any 
remaining not-fully-stable-yet corner-cases that may eventually come back 
to haunt me if I don't, as well as to update the filesystem to take 
advantage of any further format updates between now and then.

That's useful btrfs maintenance, SSD or no SSD. =:^)

> Thus for SSD except for the scrubbing and the occasional fstrim I be
> done with it.
> 
> For harddisks I enable autodefrag.
> 
> But still for now this is only guess work. I don´t have much clue on
> BTRFS filesystems maintenance yet and I just remember the slogan on
> xfs.org wiki:
> 
> "Use the defaults."

=:^)

> I would love to hear some more or less official words from BTRFS
> filesystem developers on that. But for know I think one of the best
> optimizations would be to complement that 300 GB Intel SSD 320 with a
> 512 GB Crucial m5 mSATA SSD or some Intel mSATA SSDs (but these cost
> twice as much), and make more free space on /home again. For criticial
> data regarding data safety and amount of accesses I could even use BTRFS
> RAID 1 then.

Indeed.  I'm running btrfs raid1 mode with my ssds (except for /boot, 
where I have a separate one configured on each drive, so I can grub 
install update one and test it before doing the other, without 
endangering my ability to boot off the other should something go wrong).

> All those MPEG3 and photos I could place on the bigger
> mSATA SSD. Granted a SSD is definately not needed for those, but it is
> just more silent. I never got how loud even a tiny 2,5 inch laptop drive
> is, unless I switched one external on while using this ThinkPad T520
> with SSD. For the first time I heard the harddisk clearly. Thus I´d
> prefer a SSD anyway.

Well, yes.  But SSDs cost money.  And at least here, while I could 
justify two SSDs in raid1 mode for my critical data, and even 
overprovision such that I have nearly 50% available space entirely 
unpartitioned, I really couldn't justify spending SSD money on gigs of 
media files.

But as they say, YMMV...

---
[1] Pathologic: THAT is the word I was looking for in several recent 
posts, but couldn't remember, not "pathetic", "pathologic"!  But all I 
could think of was pathetic, and I knew /that/ wasn't what I wanted, so 
explained using other words instead.  So if you see any of my other 
recent posts on the issue and think I'm describing a pathologic case 
using other words, it's because I AM!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

