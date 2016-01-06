Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52612 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbcAFHgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jan 2016 02:36:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aGidd-0008RG-Hs
	for linux-btrfs@vger.kernel.org; Wed, 06 Jan 2016 08:36:09 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 08:36:09 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jan 2016 08:36:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unrecoverable fs corruption?
Date: Wed, 6 Jan 2016 07:35:53 +0000 (UTC)
Message-ID: <pan$239bc$38bcd0c3$4c5a6275$65deddb4@cox.net>
References: <4bfedb90694d34a9a311d532715560d1@mail.mended-drum.net>
	<CAJCQCtSDpGnXpFpHxO9eyb7pLWKQis6+yOBznFkJO85e0NLyyw@mail.gmail.com>
	<pan$775e4$fad1d9d7$a69e525a$ff4dac1a@cox.net>
	<1451709141.8761.16.camel@scientia.net>
	<pan$e83b6$5156a07d$651aae24$9dda2c0a@cox.net>
	<1451865902.6411.6.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 04 Jan 2016 01:05:02 +0100 as
excerpted:

> On Sun, 2016-01-03 at 15:00 +0000, Duncan wrote:
>> But now that I think about it, balance does read the chunk in ordered
>> to rewrite its contents, and that read, like all reads, should normally
>> be checksum verified
> That was my idea.... :)
> 
>>  (except of course in the case of nodatasum, which nocow
>> of course implies).
> Though I haven't had the time so far to reply on the most recent posts
> in that thread,... I still haven't given up on the quest for
> checksumming of nodatacow'ed data ;-)

Following the lines of the btrfs-convert discussion elsewhere, I don't 
believe the current devs to be too interested in this at the current 
time, tho maybe in the "bluesky" timeframe, beyond five years out, likely 
more like ten.  Because most of them believe it to be cost/benefit 
impractical to work on.  However, much like btrfs-convert, if a (probably 
new) developer finds this his particular itch he wants to scratch, and 
puts in the seriously high level of effort to get it to work, and it's 
all up to code standard, perhaps.  But it's going to have to pass a 
pretty high level of skepticism and in general it's simply not considered 
worth the incredible level of effort that would be necessary, so it's 
going to take a developer with a pretty intense itch to scratch over a 
period, very likely, of some years, by the time the code can be both 
demonstrated theoretically correct and pass regression tests and 
skepticism, to get it to the level were it could be properly included.

IOW, not impossible, but as close as it gets.  I'd say the chances of 
seeing this in mainline (not just a series of patches carried by someone 
else) in anything under say 7 years is well under 5%, probably under 2%.  
The chances at say 15 years... maybe 15%.  (That said, if you look at ext4 
as an example, it has grown a bunch of exotic options over time, that 
most people will never use but that scratched someone's itch.  Btrfs 
could be getting similar, at 7+ years out, so it's possible, and at that 
viewpoint, some may even consider the chances near 50% at the 10 year out 
mark.  I'm skeptical, but I wouldn't have considered all those weird 
things now possible in ext4 likely to ever reach mainline ext4, either, 
so...)

But I honestly don't expect current devs to spend much time on the 
proposal, at least not in the 7- year timeframe.

> Especially on large filesystems all these operations tend to take large
> amounts of time and may even impact the lifetime of the storage
> device(s)... so it would be clever if certain such operations could be
> kinda "merged", at least for the purposes of getting the results.
> As in the above example, if one would anyway run a full balance, the
> next scrub may be skipped because one is just doing one.
> Similar for defrag.

Well, balance definitely doesn't do defrag.  By analogy, balance is at 
the UN, nation to nation, level, while defrag is at the city precinct 
level.  They're simply out of each other's scope.

Which isn't to say that at some point in the future, there won't be some 
btrfs doitall command, that does scrub and balance and defrag and 
recompression and ... all in a single pass, taking parameters from all 
the individual functions.  But as you say, that's likely to be at least 
intermediate future, 3-5 years out, maybe 5-7 years out or more.

And like btrfs-convert, I'd consider it in the "not a core tool, but nice 
to have" category.

>> And even if balance works to verify no checksum errors, I don't believe
>> it would correct them or give you the detail on them that a scrub
>> would.
> I'd have expected that that read errors are (if possible because of
> block copies) are repaired as soon as they're encountered... isn't that
> the case?

(My understanding is that...) At the balance level, checksum corruption 
errors aren't going to be fixed from the other copy or from parity, 
because unlike normal file usage, the other copy isn't read -- balance 
isn't worried about file or extent level corruption, and any it would 
find would be simply a byproduct of the normal read-time checksum 
verification process, it's simply moving chunks around.  Such errors 
would thus simply cause the balance to abort, with whatever balance-time 
error that wouldn't even necessarily reflect that it's a checksum error.

Assuming that's correct, a completed balance could be assumed to have in 
addition the meaning of a scrub completed without any errors, but a 
failed balance could have failed for one of any number of reasons and 
with one of various balance-level errors, with such a failure yielding 
little or no clue as to scrub status.

>> And if there is an error, it'd be a balance error, which might or might
>> not actually be a scrub error.
> Sure, but it shouldn't be difficult to collect e.g. scrub stats during
> balance as well.

Given that as of now they're still struggling to manage balance's memory 
requirements in ordered to let it scale more efficiently, and that 
scaling, particularly in the presence of large numbers of subvolumes and 
with quotas remains the single biggest issue, the devs are extremely 
unlikely to want to be adding additional memory requirements in ordered 
to additionally track scrub stats.

Even once the current scaling issues are resolved, I don't see it being a 
useful option for balance itself, precisely because of the scaling 
issues, then on potentially embedded systems running TB-scale storage.  
But there might indeed be some place for it in the still very theoretical 
btrfs doitall command you proposed and I named doitall, above.  Embedded-
scale applications would simply not run that command, instead running the 
lower resource individual commands, while doitall could say check that it 
had a minimum of 16 GiB of memory or whatever to use, and exit with an 
error if not, so it could optionally be run on systems with the required 
resources.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

