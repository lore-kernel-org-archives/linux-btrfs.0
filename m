Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59657 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbcE0B2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 21:28:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b66a0-0005fP-7d
	for linux-btrfs@vger.kernel.org; Fri, 27 May 2016 03:28:48 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:28:48 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:28:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs [raid56] stability
Date: Fri, 27 May 2016 01:28:42 +0000 (UTC)
Message-ID: <pan$dff8$271eaaf1$15ab6462$128a4291@cox.net>
References: <CAKg6aQzTx7NLjC6gZxKUKkuACo313N3ZqxQ0SXO4WXEwGPFNkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Diego Torres posted on Fri, 27 May 2016 00:42:07 +0200 as excerpted:

> I've been using btrfs with a raid5 configuration with 3 disks for 6
> months, and then with 4 disks for a couple of months more. I run a
> weekly scrub, and a monthly balance. Btrfs is the only fs that can add
> drives one by one to an existing raid setup, and use the new space
> inmediately, without replacing all the drives. For me, this is one of
> the strongest points.
> 
> And, as far as I understand, If I keep and eye on the free space
> available, and no drives fail, the filesystem would last indefinitely.
> However, the code to replace a failed/missing drive is not yet final,
> as I have discovered reading some wikis and this mailing list. Maybe I'm
> wrong.
> 
> I haven't been able to find a timeline/roadmap about when the replace
> command will be stable/ready for use.
> 
> Is this someone's priority? Is it planned for the next one,two or three
> years coming?

[I took the liberty of updating the title, since you're not really asking 
about btrfs stability in general, but about btrfs raid56 mode 
stability...]

You ask a very good question... with a rather complicated answer, at 
least if I try to answer what I consider the real, unstated question.

The shortest accurate answer is that due to AFAIK currently not yet fully 
traced bugs, raid56 (that is, parity-raid) mode is (still) not 
recommended -- because while it nominally works, replacement turns out 
not to be practical (takes waaayyy long, think weeks, easily enough time 
for another device to die before replacement of the first is complete, 
thereby possibly killing the array) in some but not all reported cases 
currently, due to those bugs.  Provided they can be properly traced, a 
fix should be available relatively soon, and raid56 mode would then be 
rather cautiously considered usable, tho still newer and less mature than 
redundancy-raid mode (raid1, raid10).  I'd say 1-3 kernel cycles... 
unless something else comes up or the bugs (two of them) prove extremely 
difficult to trace and fix.

A longer, more complicated answer, will note that the raid56 code 
(including replace, I believe) was considered nominally complete with 
3.19, altho there were a couple critical bugs found and fixed in the 
early going, so the LTS stable 4.1 series is considered the absolute 
minimum for raid56 mode, and 4.4 LTS or current is strongly recommended.

This is very likely what most of the resources you read were referring 
to, the period between the original introduction of the runtime code in 
(AFAIK) 3.9, and nominal completion in 3.19 or fix of the initial 
critical bugs in 4.1.  Those resources likely simply haven't been updated 
since, altho with the current state, perhaps it's better that they 
aren't, as if the were more people would be trying it and running into 
these other bugs.

By late 4.3 and early 4.4, I was actually beginning to (extremely 
cautiously still) consider raid56 mode usable... but then the reports of 
these two further bugs, likely related, started coming in.

As mentioned above, the problem from the user perspective is that device 
replacement or restriping to a different width (as you'd do using a 
balance-convert if you started with N devices and then decided to expand 
the array) /can/ /sometimes/ take effectively /forever/, *far* longer 
than would be expected, and definitely long enough that there's a 
reasonable risk of further device death, killing the entire raid.  So the 
raid56 parity guarantees cannot be relied on in terms of device 
replacement, which pretty well breaks the whole reason people would 
choose raid56 mode, as opposed to something else, in the first place.  
That's why it's not currently recommended.

The problem from the developer perspective is different.  It's that 
replace and/or restripe works perfectly fine for some people, while 
others are affected by this pair of bugs, and AFAIK, it hasn't yet been 
possible to find the exact circumstances which trigger the bug(s), making 
it about impossible to reliably reproduce in any predictable manner, thus 
making it extremely difficult to reliably trace and fix.

Still, given that it's a known bug (or two) affecting enough people that 
it can't be a one-off, chances are pretty good that they'll have it 
traced and fixed within three kernel cycles.  I'd say one kernel cycle, 
as the couple of similarly widely seen bugs in other areas have been, but 
for the fact that pretty much /everything/ related to raid56 mode has 
seemed to take at least twice as long as people expected, so I'm allowing 
3 kernel cycles from now, 4.6, 4 from 4.5, the cycle we were in when we 
had enough reports of the problem to realize it was /not/ a one-off.

So I expect a fix by 4.9, but would recommend giving it another couple 
cycles after that fix, until 4.8 if the fix actually gets into the 4.6 
release, or 4.11 if it's actually 4.9 before the fix is integrated, just 
to see if any other raid56 related bugs turn up, before actually 
considering it reasonably usable.  And definitely ask again then (if you 
haven't been following the list and further raid56 development in the 
mean time) before you start relying on it, just in case it either hasn't 
been fixed, or some other serious bug has been found.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

