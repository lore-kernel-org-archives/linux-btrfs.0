Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57858 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaCIQk5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Mar 2014 12:40:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WMgmV-000724-EX
	for linux-btrfs@vger.kernel.org; Sun, 09 Mar 2014 17:40:55 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 17:40:55 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 17:40:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding btrfs and backups
Date: Sun, 9 Mar 2014 16:40:30 +0000 (UTC)
Message-ID: <pan$72cea$1961f20d$d4386bc$889c1510@cox.net>
References: <loom.20140306T191655-366@post.gmane.org>
	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
	<loom.20140307T144540-512@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric Mesa posted on Fri, 07 Mar 2014 14:03:44 +0000 as excerpted:

> Duncan - thanks for this comprehensive explanation. For a huge portion
> of your reply...I was all wondering why you and others were saying
> snapshots aren't backups. They certainly SEEMED like backups. But now I
> see that the problem is one of precise terminology vs colloquialisms. In
> other words, snapsshots are not backups in and of themselves. They are
> like Mac's Time Machine. BUT if you take these snapshots and then put
> them on another media - whether that's local or not - THEN you have
> backups. Am I right, or am I still missing something subtle?

You got it. =:^)

Tho as I just mentioned in a reply on a different subthread, it's worth 
noting that btrfs send/receive is still a bit buggy at present and is 
giving people with corner-cases some errors.  To my knowledge, if both 
the send and receive sides complete without error, it's a perfectly 
reliable backup.  The problem is, they aren't always completing without 
errors at present, and I'd hate to have to actually need a current backup 
shortly after those send/receives started triggering errors, before I had 
a chance to put a different solution in place.  So at this point I'd 
recommend having that other solution in place from the beginning, just in 
case.

IOW, it's fine to play with send/receive right now, but don't depend on 
it with your life, or the life of your data!  In a year or even six 
months, hopefully those bugs should be worked out and it'll be reliable 
as the sun rise, but I wouldn't count on that for my own data ATM, and 
I'd recommend you don't either.

Tho as I said, to the best of my knowledge, if both sides complete 
without error, it's as reliable as btrfs itself is ATM.  (Tho while 
kernel 3.13 did tone down the "might-eat-your-babies" warning on the 
kernel's btrfs config option, it's still what I'd classify as "semi-
stable", so keep those backups updated and tested, and run current 
kernels since older kernels do still mean known bugs that are fixed in 
current!)

> I think the most important thing you said was at the end and I'd like a
> little clarification on that if it's OK with you.
> 
> "As with local snapshots, old ones can
>> be deleted on both the send and receive ends, as long as at least one
>> common reference snapshot is maintained on both ends, so diffs taken
>> against the send side reference can be applied to an appropriately
>> identical receive side reference, thereby updating the receive side to
>> match the new read-only snapshot on the send side."
> 
> So, let's say I have everything set up. This means I created the
> read-only shot on my home btrfs volume and sent it to the backup drive.
> I'm making hourly snapshots and after each snapshot is made, it's sent
> to the backup drive. So, obviously the backup drive needs to be at least
> as big as the home drive so it can store what's on home plus the
> snapshot-diffs. Now let's be extreme and say that in the course of a
> year I touch and somehow change every single file on the home drive.
> That means if I only had one snapshot I'd need home drive x 2 space.
> (for used space, not unused space, naturally)

Well, not strictly as you said.  If you changed every BLOCK of every file 
over that year, THEN you'd need 2X the space.  But if a lot of those 
files are say half-gig-plus ISOs and you only changed say one word of one 
file on each ISO, then no, it wouldn't be the whole files changed, only a 
single individual (btrfs size, 4 KiB AFAIK) block within the file, and 4 
KiB out of half a gig is under 1/10 of 1 percent, so you wouldn't need 2X 
the space in a scenario like that.

> So I might want my backups to have last's year's data, but wouldn't want
> to need to upgrade the size of my actual home drive. So I would want to
> maintain less snapshots on my home drive than my backup drive. (It's
> possible I'm missing something here...something subtle that makes this
> not necessary) So do I only need to make sure I have the latest snapshot
> or maybe latest plus n-1 on the home drive while the backup drive can
> have all snapshots since the beginning? I THINK that can be the case
> based on reading your sentence, but I just want to make sure.

In general, yes.  Tho if you're doing hourly snapshots I'd probably keep 
say a day's worth locally, plus one a day for a week, and 1 weekly 
snapshot before that, just to cover the case of the my needing to recover 
a backup and finding that the remote backup just keeled over 12 hours 
ago.  Unless you're writing/erasing heavily, snapshots take up very 
nearly zero space, so keeping a few extra around isn't going to hurt a 
whole lot.

Meanwhile, however, I'd suggest a reasonable thinning down script on the 
remote backup as well, because at least at present, there are overhead 
issues once you get over several hundred snapshots.  But realistically, 
if you decide you need a file 11 months old, are you really going to care 
or even know exactly what hour it was, eleven months ago?  Not very 
likely.  It's far more likely that all those hundreds of snapshots will 
just be getting in your way, and it's unlikely to matter eleven months 
out whether you even get the precise /week/, vs. the one before or after 
that.

So I'd recommend something like thinning down the hourly snapshots to say 
one every six hours after a couple days, perhaps one a day after a week, 
one a week after a quarter (13 weeks), and one a quarter after a year.  
That keeps things manageable should you actually need to go back a year, 
so you're not sorting thru thousands (24*365=8760) of hourly snapshots 
just to pick one at random from sometime in the correct week after all.  
With a bit of reasonable thinning, you can keep that to well under 500 
(I've counted them up in examples a few times and come up with 200-300) 
without much trouble, making it a LOT easier to actually FIND a useful 
snapshot without all the extra noise, if you actually NEED to.

> If I may venture to see if I've learned
> something from your response, is it because when I change a file Back in
> Time stores the entire changed file while btrfs only stores the bits
> that have changed? Also, does it matter if the file is binary or text?
> If I'm editing metadata on an mp3 file is the resulting snapshot the
> entire mp3 or just what's changed? (vs how it would work with a text
> file)

I think I covered that above. =:^)  If you're not using btrfs 
compression, text or uncompressable binary shouldn't matter, and as I 
said, I believe the block size is 4 KiB (on x86 and amd64, it's actually 
the kernel memory page size, which differs on some archs).

Come to think of it, tho, in a heavy-snapshot scenario, compression may 
actually use more space, since I believe compression blocks are 128 KiB.  
But I'm far from sure on how compression and snapshots interact and what 
that would do in practice, size-wise.  Hopefully a dev or someone else 
with more information on that particular aspect will step in with 
accurate information there, either confirming or dispelling my thought.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

