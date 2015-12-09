Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33986 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbbLINgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 08:36:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6eug-0000Hb-4z
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 14:36:10 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 14:36:10 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 14:36:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Wed, 9 Dec 2015 13:36:01 +0000 (UTC)
Message-ID: <pan$ab79a$6d00d5c9$95504338$ca8d2761@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	<20151126003342.GA24333@carfax.org.uk>
	<1449639781.7835.3.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 09 Dec 2015 06:43:01 +0100 as
excerpted:

> Hey Hugo,
> 
> 
> On Thu, 2015-11-26 at 00:33 +0000, Hugo Mills wrote:
> 
>> The issue is that nodatacow bypasses the transactional nature of
>> the FS, making changes to live data immediately. This then means that
>> if you modify a modatacow file, the csum for that modified section is
>> out of date, and won't be back in sync again until the latest
>> transaction is committed. So you can end up with an inconsistent
>> filesystem if there's a crash between the two events.

> Sure,... (and btw: is there some kind of journal planned for
> nodatacow'ed files?),... but why not simply trying to write an updated
> checksum after the modified section has been flushed to disk... of
> course there's no guarantee that both are consistent in case of crash (
> but that's also the case without any checksum)... but at least one would
> have the csum protection against everything else (blockerrors and that
> like) in case no crash occurs?

Answering the BTW first, not to my knowledge, and I'd be skeptical.  In 
general, btrfs is cowed, and that's the focus.  To the extent that nocow 
is necessary for fragmentation/performance reasons, etc, the idea is to 
try to make cow work better in those cases, for example by working on 
autodefrag to make it better at handling large files without the scaling 
issues it currently has above half a gig or so, and thus to confine nocow 
to a smaller and smaller niche use-case, rather than focusing on making 
nocow better.

Of course it remains to be seen how much better they can do with 
autodefrag, etc, but at this point, there's way more project 
possibilities than people to develop them, so even if they do find they 
can't make cow work much better for these cases, actually working on nocow 
would still be rather far down the list, because there's so many other 
improvement and feature opportunities that will get the focus first.  
Which in practice probably puts it in "it'd be nice, but it's low enough 
priority that we're talking five years out or more, unless of course 
someone else qualified steps up and that's their personal itch they want 
to scratch", territory.

As for the updated checksum after modification, the problem with that is 
that in the mean time, the checksum wouldn't verify, and while btrfs 
could of course keep status in memory during normal operations, that's 
not the problem, the problem is what happens if there's a crash and in-
memory state vaporizes.  In that case, when btrfs remounted, it'd have no 
way of knowing why the checksum didn't match, just that it didn't, and 
would then refuse access to that block in the file, because for all it 
knows, it /is/ a block error.

And there's already a mechanism for telling btrfs to ignore checksums, 
and nocow already activates it, so... there's really nothing more to be 
done.

>> > For me the checksumming is actually the most important part of btrfs
>> > (not that I wouldn't like its other features as well)... so turning
>> > it off is something I really would want to avoid.

Same here.  In fact, my most anticipated feature is N-way-mirroring, 
since that will allow three copies (or more, but three is my sweet spot 
balance between the space and reliability factors) instead of the current 
limit of two.  It just disturbs me than in the event of one copy being 
bad, the other copy /better/ be good, because there's no further 
fallback!  With a third copy, there'd be that one further fallback, and 
the chances of all three copies failing checksum verification are remote 
enough I'm willing to risk it, given the incremental cost of additional 
copies.

>> > Plus it opens questions like: When there are no checksums, how can it
>> > (in the RAID cases) decide which block is the good one in case of
>> > corruptions?

>>    It doesn't decide -- both copies look equally good, because
>> there's no checksum, so if you read the data, the FS will return
>> whatever data was on the copy it happened to pick.

> Hmm I see... so one gets basically the behaviour of RAID.
> Isn't that kind of a big loss? I always considered the guarantee against
> block errors and that like one of the big and basic features of btrfs.

It is a big and basic feature, but turning it off isn't the end of the 
world, because then it's still the same level of reliability other 
solutions such as raid generally provide.

And the choice to turn it off is just that, a choice, tho it's currently 
the recommended one in some cases, such as with large VM images, etc.

But as it happens, both VM image management and databases tend to come 
with their own integrity management, in part precisely because the 
filesystem could never provide that sort of service.  So to the extent 
that btrfs must turn off its integrity management features when dealing 
with that sort of file, it's no bigger deal than it would be on any other 
filesystem, it's simply returning what's normally a huge bonus compared 
to other filesystems, to the status quo for specific situations that it 
otherwise doesn't deal so well with.  And if the status quo was good 
enough before, and in the absence of btrfs would of necessity be good 
enough still, then where it's necessary with btrfs, it's good enough 
there as well.

IOW, there's only upside, no downside.  If the upside doesn't apply, it's 
still no worse than it was before, no downside.

> It seems that for certain (not too unimportant cases: DBs, VMs) one has
> to decide between either evil, loosing the guaranteed consistency via
> checksums... or basically running into severe troubles (like Mitch's
> reported fragmentation issues).
> 
> 
>> > 3) When I would actually disable datacow for e.g. a subvolume that
>> > holds VMs or DBs... what are all the implications?
>> > Obviously no checksumming, but what happens if I snapshot such a
>> > subvolume or if I send/receive it?
>> 
>>    After snapshotting, modifications are CoWed precisely once, and
>> then it reverts to nodatacow again. This means that making a snapshot
>> of a nodatacow object will cause it to fragment as writes are made to
>> it.
> I see... something that should possibly go to some advanced admin
> documentation (if not already in).
> It means basically, that one must assure that any such files (VM images,
> DB data dirs) are already created with nodatacow (perhaps on a subvolume
> which is mounted as such.
> 
> 
>> > 4) Duncan mentioned that defrag (and I guess that's also for auto-
>> > defrag) isn't ref-link aware...
>> > Isn't that somehow a complete showstopper?

>> It is, but the one attempt at dealing with it caused massive data
>> corruption, and it was turned off again.

IIRC, it wasn't data corruption so much, as massive scaling issues, to 
the point where defrag was entirely useless, as it could take a week or 
more for just one file.

So the decision was made that a non-reflink-aware defrag that actually 
worked in something like reasonable time even if it did break reflinks 
and thus increase space usage, was of more use than a defrag that 
basically didn't work at all, because it effectively took an eternity.  
After all, you can always decide not to run it if you're worried about 
the space effects it's going to have, but if it's going to take a week or 
more for just one file, you effectively don't have the choice to run it 
at all.

> So... does this mean that it's still planned to be implemented some day
> or has it been given up forever?

AFAIK it's still on the list.  And the scaling issues are better, but one 
big thing holding it up now is quota management.  Quotas never have 
worked correctly, but they were a big part (close to half, IIRC) of the 
original snapshot-aware-defrag scaling issues, and thus must be reliably 
working and in a generally stable state before a snapshot-aware-defrag 
can be coded to work with them.  And without that, it's only half a 
solution that would have to be redone when quotes stabilized anyway, so 
really, quota code /must/ be stabilized to the point that it's not a 
moving target, before reimplementing snapshot-aware-defrag makes any 
sense at all.

But even at that point, while snapshot-aware-defrag is still on the list, 
I'm not sure if it's ever going to be actually viable.  It may be that 
the scaling issues are just too big, and it simply can't be made to work 
both correctly and in anything approaching practical time.  Time will 
tell, of course, but until then...

> Given that you (or Duncan?,... sorry I sometimes mix up which of said
> exactly what, since both of you are notoriously helpful :-) ) mentioned
> that autodefrag basically fails with larger files,... and given that it
> seems to be quite important for btrfs to not be fragmented too heavily,
> it sounds a bit as if anything that uses (multiple) reflinks (e.g.
> snapshots) cannot be really used very well.

That might have been either of us, as I think we've both said effectively 
that, over time.

As for reflink/snapshot usefulness, it really depends on your use-case.  
If both modifications and snapshots are seldom, it shouldn't be a big 
deal.  For use-cases where snapshots are temporary, as can be the case 
for most snapshots anyway in most send/receive usage scenarios, again, 
the problem is quite limited.

The biggest problem is with large random-rewrite-pattern files, where 
both rewrites and snapshots occur frequently.  That's really a worst-case 
for copy-on-write in general, and btrfs is no exception.  But there's 
still workarounds that can help keep the situation under control, and if 
it comes to it, one can always use other filesystems and accept their 
limitations, where btrfs isn't a particularly useful choice due to these 
sorts of limitations.

Which again emphasizes my point, while there's cases where btrfs' 
features run into limits, it's all upside, no downside.  Worst-case, you 
set nocow and turn off snapshotting, but that's exactly the situation 
you're in anyway with other filesystems, so you're no worse off than if 
you were using them.

Meanwhile, where those btrfs features *can* be used, which is on /most/ 
files, with only limited exceptions, it's all upside! =:^)

>>  autodefrag, however, has
>> always been snapshot aware and snapshot safe, and would be the
>> recommended approach here.

> Ahhh... so autodefag *is* snapshot aware, and that's basically why the
> suggestion is (AFAIU) that it's turned on, right?

FWIW, I've seen it asserted that autodefrag is snapshot aware a few times 
now, but I'm not personally sure that is the case and I don't see any 
immediately obvious reason it would be, when (manual) defrag isn't, so 
I've refrained from making that claim, myself.  If I were to see multiple 
devs make that assertion, I'd be more confident, but I believe I've only 
seen it from Hugo, and while I trust him in general because in general 
what he says makes sense, here, as I said, it just doesn't make immediate 
sense to me that the two would be so different, and without that 
explained and lacking further/other confirmation...  I just remain 
personally unsure and thus refrain from making that assertion, myself.

Which is why you've not seen me mention it...

Tho I can and _do_ say I've been happy with autodefrag here, and ensure 
it's enabled on everything, generally on first mount.  But again, my 
particular use-case doesn't deal with snapshots or reflinking in general, 
neither does it have these large random-rewrite-pattern files, so I'd be 
unlikely to see the effects of reflink-awareness, or lack thereof, in my 
own autodefrag usage, however much I might otherwise endorse it in 
general.

> So, I'm afraid O:-), that triggers a follow-up question:
> Why isn't it the default? Or in other words what are its drawbacks (e.g.
> other cases where ref-links would be broken up,... or issues with
> compression)?

The biggest downside of autodefrag is its performance on large (generally 
noticeable at between half a gig and a gig) random-rewrite-pattern files 
in actively-being-rewritten use.  For all other cases it's generally 
recommended, but that's why it's not the default.

And the problem there is simply that at some point the files get large 
enough that the defragging rewrites take longer than the time between 
those random updates, so the defragging rewrites become the bottleneck.  
As long as that's not occurring, either because the file is small enough, 
or because the backing device is SSD and/or simply fast enough, or 
because the updates are coming in slow enough to allow the file to be 
rewritten between them (the VM or DB using the file isn't in heavy enough 
use to trigger the problem), autodefrag works fine.

Meanwhile, there remain some tweaks they think they can do to autodefrag, 
that in theory should help eliminate this issue or at least move the 
bottlenecking to say 10 gig instead of 1 gig, but again, there's way more 
improvements to be made at this point than devs working on making them, 
so this improvement, as many others, simply has to wait its turn.  
However, this one's at least intermediate priority, so I'd put it at 
anywhere from two months to perhaps three years out.  It's unlikely to be 
beyond the 5 year mark, as some features on the wishlist almost certainly 
are.

> And also, when I now activate it on an already populated fs, will it
> defrag also any old files (even if they're not rewritten or so)?
> I tried to have a look for some general (rather "for dummies" than for
> core developers) description of how defrag and autodefrag work... but
> couldn't find anything in the usual places... :-(

AFAIK autodefrag only queues up the defrag when it detects fragmentation 
beyond some threshold, and it only checks and thus only detects at file 
(re)write.

Additionally, on a filesystem that hasn't had autodefrag on from the 
beginning, fragmentation is likely to be high enough that defrag, either 
auto or manual, won't be able to defrag to ideal levels, and 
fragmentation is thus likely to remain high for some time.

Further, when a filesystem is highly fragmented and autodefrag is first 
turned on, often it actually rather negatively affects performance for a 
few days, because so many files are so fragmented that it's queuing up 
defrags for nearly everything written.

So really, the ideal is having autodefrag on from the beginning, which is 
why I generally ensure it's on from the very first mount, or at least 
before I actually start putting files in the filesystem, here.  (Normally 
I'll create the filesystem including the label, and create the fstab 
entry for it referencing that label that includes autodefrag, at very 
nearly the same time, sometimes creating the fstab entry first since I do 
use the label, not the UUID.  Then I mount it using that fstab entry, so 
yes, it /does/ have autodefrag enabled from the very first mount. =:^)

Of course this might be reason enough to verify your backups one more 
time, blow away the filesystem with a brand new mkfs.btrfs, create that 
fstab entry with autodefrag included, mount, and restore from backups.  
This even gives you a chance to activate newer btrfs features like 16 KiB 
node size by default, if your filesystem is old enough to have been 
created before they were available, or before they were the default. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

