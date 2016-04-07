Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41832 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbcDGCh6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Apr 2016 22:37:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anznr-0004Oi-OX
	for linux-btrfs@vger.kernel.org; Thu, 07 Apr 2016 04:36:15 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Apr 2016 04:36:15 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Apr 2016 04:36:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
Date: Thu, 7 Apr 2016 02:36:08 +0000 (UTC)
Message-ID: <pan$53d94$1e22c384$1d167735$75324bc2@cox.net>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
	<pan$20f45$63875276$ec725eab$c0dca8d1@cox.net>
	<CAFKQ2BucABTGrm9eybdC6j8fJOsfzLing7GfGaU=Jd9zUZV2wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ank Ular posted on Wed, 06 Apr 2016 18:08:53 -0400 as excerpted:

> I did read this page: https://btrfs.wiki.kernel.org/index.php/Restore
> 
> But, not understanding the meaning of much of the terminology, I didn't
> "get it".
> 
> Your explanation makes the page much clearer.

Yeah.  It took me awhile, some help from the list, and actually going 
thru the process for real, once, to understand that page as well.  As I 
said, once you get to the point of the automatic btrfs restore not 
working and needing the advanced stuff, the process gets /far/ more 
technical, and even for admin types used to dealing with technical stuff 
(I've been a gentooer for over a decade, as I actually enjoy its mix of 
customizability, including the ability to override distro defaults where 
found necessary, and automation where I don't particularly care), it's 
not exactly easy reading.

But it sure beats not having that page as a resource! =:^)

> I do need one
> clarification. I'm assuming that when I issue the command:
> 
>    btrfs-find-root /dev/sdb
> 
> it doesn't actually matter which device I use and that, in theory, any
> of the 20 devices should yield the same listing.
> 
> By the same token, when I issue the command:
> 
>    btrfs restore -t n /dev/sdb /mnt/restore
> 
> any of the 20 devices would work equally well.
> 
> I want to be clear on this because this will be the first time I attempt
> using 'btrfs restore'. While I think I understand what is supposed to
> happen now, there is nothing like experience to make that
> 'understanding' more solid. I just want to be sure I haven't confused
> myself before I do something more or less irrevocable.

Keep in mind that one of the advantages of btrfs restore is that it does 
NOT write to the filesystem it's trying to recover files from.  As such, 
it can't damage it further.  So the only way you could be doing something 
irrevocable would be trying to write restore's output back to the device 
in question, instead of to a different filesystem intended to restore the 
files to, or something equally crazy.

As to the question at hand, whether pointing it at one component device 
or another makes a difference, to the best of my knowledge, no.  However, 
it should be stated that my own experience with restore was with a two-
device btrfs raid1, so even if it actually only used the one device it 
was pointed at, it could be expected to work, since the two devices were 
actually raid1 mirrors of the same content.

Between that and the fact that the wiki page in reference, again,
https://btrfs.wiki.kernel.org/index.php/Restore , was clearly written 
from the single-device viewpoint, and the manpage doesn't say either, I 
can't actually say for sure how it deals with multiple-device filesystems 
when a single device doesn't contain effectively a copy of the entire 
filesystem, as was the case with my personal experience, on a two-device 
btrfs raid1 for both data and metadata.

But as I said, restore doesn't write to the devices or filesystem it's 
trying to restore files from, so feel free to experiment with it.  The 
only thing you might lose is a bit of time... unless you start trying to 
redirect its output to the devices it's trying to restore from, or 
something equally strange, and that's pretty difficult to do by accident!

But to my knowledge, pointing restore at any of the device components of 
the filesystem should be fine.  The one thing I'd be sure I had done 
previously would be btrfs device scan.  That's normally used (and 
normally triggered automatically by udev) to update the kernel on what 
component devices are available to form the filesystem before mounting, 
etc, while btrfs restore is otherwise mostly userspace code, so again I'm 
not /sure/ it applies in this case or not, but while btrfs check and 
btrfs restore are normally mostly userspace, I assume they /do/ make use 
of kernel services to at least figure out what device components belong 
to the filesystem in question, so a btrfs device scan would update that 
information for them.  Even if they don't use that mechanism, figuring 
that out entirely in userspace, it won't hurt.

Which BTW, any devs reading this care to clarify for me?  How /do/ 
otherwise userspace only commands such as btrfs check and btrfs restore, 
discover which device components make up a multi-device filesystem?  Do 
they still call kernel services for that, such that btrfs device scan 
matters as it triggers an update of the kernel's btrfs component devices 
list, or do they do it all in userspace?

> Fortunately, I neither use sub-volumes nor snapshots since nearly all of
> the files are static in nature.

FWIW, my use-case doesn't use either subvolumes or snapshots, either.  I 
prefer independent filesystems as they protect against filesystem 
meltdown while snapshots/subvolumes don't, and with an already functional 
configuration of partitions and filesystems from well before btrfs, 
throwing in the additional complexity of snapshots and subvolumes would 
simply complexify administration for me, and keeping my setup simple 
enough that I can actually understand it and manage it in a disaster 
recovery situation is for me an important component of my disaster 
management strategy.  In my time I've rejected more than one 
technological "solution" as too complex to master it sufficiently that I 
can be confident of my ability to recover to a working state under the 
pressures of disaster recovery, and the additional complexity of 
snapshots and subvolumes, when they clearly weren't needed in my 
situation, were simply one more thing to add to that pile of unnecessary 
complexity, rejected as an impediment to confident and reliable disaster 
recovery. =:^)

> As far as backups go, we're talking about a home server/workstation.
> While I used to go through an excruciating budget battle every year on a
> professional level in my usually futile fight for disaster recovery
> planning funding, my personal budget is much, nuch more limited.

FWIW, here as well on the budget crunch angle, but with the difference 
being that unless it really was throw-away data, there's no way I'd trust 
btrfs raid56 mode without a backup, kept much more current than I tend to 
keep mine, BTW, as it's simply too immature still for that use case, at 
least from my point of view.

And for much the same reason I'd hesitate to recommend btrfs for use in a 
no-at-hand-backups situation as well.  Tho you've made it plain that in 
general, you do have backups... in the form of original source DVDs, etc, 
for most of your content.  It's simply not conveniently at hand and will 
take you quite some work to re-dump/re-convert, etc.  While I'm obviously 
bleeding edge enough to try btrfs here, it /is/ with backups, and I'm 
just conservative enough that I'd really not use btrfs personally for 
your use-case, nor recommend it, because in my judgement your backups, 
original sources in some cases, are simply not conveniently enough at 
hand to be something I'd consider worth the risk.

> Of the 53T currently in limbo, about ~6-8T are on several hundreds of
> DVDs. About 10T are on the hard drives of the my prior system which
> needs a replacement motherboard. {I had rsynced the data to a new build
> system just before imminent
>  failure}. Most of the rest can be re-collected from a variety of
> still existing sources as I still have the file names and link locations
> on a separate file system. My 'disaster recovery plans' assume patience,
> a limited budget and knowing where everything came from originally.
> Backups are a completely different issue. My backup planning won't be
> complete for another 12 or so since it essentially means building a
> duplicate system. Since my budget funding is limited, my duplicate
> system is happening piecemeal every other month or so.

I do hope you understand the implications of btrfs restore, in that 
case.  You aren't restoring to the damaged filesystem, you're grabbing 
files off that filesystem and copying them elsewhere, which means you 
must have free space elsewhere to copy them to.

Which means if it's 53T in limbo, you better either prioritize that 
restore and limit it to only what you actually have space elsewhere to 
restore to (using the regex pattern option), or have 53T of space 
available to restore to.

Or did you mean "in limbo" in more global terms, encompassing multiple 
btrfs and perhaps other non-btrfs filesystems as well, with this one 
being a much smaller fraction of that 53T, say 5-10T.  Even that's 
sizable, but it's a lot easier to come up with space to recover 5-10T to, 
than to recover 53T to, for sure.

> I do understand both backups {having implemented real time transaction
> journal-ling to tape combined with weekly 'dd'
> copies to tape, monthly full backups with 6 month retention
> yada-yada-yada} and disaster recovery planning. Been there.
> Done that. Save my ___ multiple times.
> 
> The crux is always funding.
> 
> Naturally, using 'btrfs restore' successfully will go a long ways
> towards shortening the recovery process.
> 
> It will be about a week before I can begin since I need to acquire the
> restore destination storage first.

OK, it looks like you /do/ understand that you'll need additional space 
to write that data to, and are already working on getting it.

Not to be a killjoy, but perhaps this can be a lesson.  Had you had that 
53T or whatever already backed up, you wouldn't need to be looking for 
that space now, as you'd already have it covered.  And you'd need the 
same space either way.  Tho to be fair, that's 53T of space you did get 
to put off purchase of... tho at the cost of risking losing it and having 
to resort to restoring from original sources.

Personally, flying without a backup net like that, I'd choose for myself 
some other more mature filesystem.  I use reiserfs for my own media 
partitions (on spinning rust, btrfs is all on ssd, here).  I do have it 
backed up, tho not to what I'd like, but given the hardware faults I've 
had with reiserfs and recovered, including head-crashes when the AC went 
out and the drive massively overheated (in Phoenix, it was 50C+ inside 
when I got to it, likely 60C in the computer, and very easily 70C head 
and platter temp, but the unmounted backup partitions on the drive worked 
just fine when everything cooled down), despite the head-crash and 
subsequent damage on some of the mounted partitions), bad memory, caps 
going bad on an old mobo... and the fact that I do have old and very 
stale copies of the data on now out of regular service devices... I 
expect I could recover most of it, and what I couldn't I'd simply do 
without.

> Thank you for explaining the process.

=:^)

FWIW... My dad was a teacher before he retired.  As he always said, the 
best way to learn something, even better than simply doing it yourself, 
is to try to teach it to others.  Others will come from different 
viewpoints and will ask questions and require explanations for areas you 
otherwise allow yourself to gloss over and to never really understand, so 
in explaining it to others, you learn it far better yourself.

For sure my dad knew whereof he spoke, on that one! It's not only the one 
asking that benefits from the answer!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

