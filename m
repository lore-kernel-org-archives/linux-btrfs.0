Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60441 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaBGHHJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 02:07:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WBfWl-0003ug-Pk
	for linux-btrfs@vger.kernel.org; Fri, 07 Feb 2014 08:07:07 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 08:07:07 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 08:07:07 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Are nocow files snapshot-aware
Date: Fri, 7 Feb 2014 07:06:40 +0000 (UTC)
Message-ID: <pan$851d5$f707f4ca$8ec9d1c3$9613615f@cox.net>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com>
	<20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de>
	<pan$9252f$8363907a$3eaa17a6$f558018@cox.net>
	<r5mdsa-hng.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Fri, 07 Feb 2014 01:32:27 +0100 as excerpted:

> Duncan <1i5t5.duncan@cox.net> schrieb:
> 
>> That also explains the report of a NOCOW VM-image still triggering the
>> snapshot-aware-defrag-related pathology.  It was a _heavily_ auto-
>> snapshotted btrfs (thousands of snapshots, something like every 30
>> seconds or more frequent, without thinning them down right away), and
>> the continuing VM writes would nearly guarantee that many of those
>> snapshots had unique blocks, so the effect was nearly as bad as if it
>> wasn't NOCOW at all!
> 
> The question here is: Does it really make sense to create such snapshots
> of disk images currently online and running a system. They will probably
> be broken anyway after rollback - or at least I'd not fully trust the
> contents.
> 
> VM images should not be part of a subvolume of which snapshots are taken
> at a regular and short interval. The problem will go away if you follow
> this rule.
> 
> The same applies to probably any kind of file which you make nocow -
> e.g. database files. The only use case is taking _controlled_ snapshots
> - and doing it all 30 seconds is by all means NOT controlled, it's
> completely undeterministic.

I'd absolutely agree -- and that wasn't my report, I'm just recalling it, 
as at the time I didn't understand the interaction between NOCOW and 
snapshots and couldn't quite understand how a NOCOW file was still 
triggering the snapshot-aware-defrag pathology, which in fact we were 
just beginning to realize based on such reports.

In fact at the time I assumed it was because the NOCOW had been added 
after the file was originally written, such that btrfs couldn't NOCOW it 
properly.  That still might have been the case, but now that I understand 
the interaction between snapshots and NOCOW, I see that such heavy 
snapshotting on an actively written VM could trigger the same issue, even 
if the NOCOW file was created properly and was indeed NOCOW when content 
was actually first written into it.

But definitely agreed.  30 second snapshotting, with a 30 second commit 
deadline, is pretty much off the deep end regardless of the content.  I'd 
even argue that 1 minute snapshotting without snapshots thinned down to 
say 5 or 10 minute snapshots after say an hour, is too extreme to be 
practical.  Even a couple days of that, and how are you going to even 
manage the thousands of snapshots or know which precise snapshot to roll 
back to if you had to?  That's why in the what-I-considered toward the 
extreme end of practical example I posted here some days ago, IIRC I had 
it do 1 minute snapshots but thin them down to 5 or 10 minutes after a 
couple hours and to half hour after a couple days, with something like 90 
day snapshots out to a decade.  Even that I considered extreme altho at 
least reasonably so, but the point was, even with something as extreme as 
1 minute snapshots at first frequency and decade of snapshots, with 
reasonable thinning it was still very manageable, something like 250 
snapshots total, well below the thousands or tens of thousands we're 
sometimes seeing in reports.  That's hardly practical no matter how you 
slice it, as how likely are you to know the exact minute to roll back to, 
even a month out, and even if you do, if you can survive a month before 
detecting it, how important is rolling back to precisely the last minute 
before the problem actually going to be?  At a month out perhaps the 
hour, but the minute?

But some of the snapshotting scripts out there, and the admins running 
them, seem to have the idea that just because it's possible it must be 
done, and they have snapshots taken every minute or more frequently, with 
no automated snapshot thinning at all.  IMO that's pathology run amok 
even if btrfs /was/ stable and mature and /could/ handle it properly.

That's regardless of the content so it's from a different angle than you 
were attacking the problem from...  But if admins aren't able to 
recognize the problem with per-minute snapshots without any thinning at 
all for days, weeks, months on end, I doubt they'll be any better at 
recognizing that VMs, databases, etc, should have a dedicated subvolume.  
Taking the long view, with a bit of luck we'll get to the point were 
database and VM setup scripts and/or documentation recommend setting NOCOW 
on the directory the VMs/DBs/etc will be in, but in practice, even that's 
pushing it, and will take some time (2-5 years) as btrfs stabilizes and 
mainstreams, taking over from ext4 as the assumed Linux default.  Other 
than that, I guess it'll be a case-by-case basis as people report 
problems here.  But with a snapshot-aware-defrag that actually scales, 
hopefully there won't be so many people reporting problems.  True, they 
might not have the best optimized system and may have some minor 
pathologies in their admin practices, but as long as they remain /minor/ 
pathologies because btrfs can deal with them better than it does now thus 
keeping them from becoming /major/ pathologies...


But be that as it may, since such extreme snapshotting /is/ possible, and 
with automation and downloadable snapper scripts somebody WILL be doing 
it, btrfs should scale to it if it is to be considered mature and 
stable.  People don't want a filesystem that's going to fall over on them 
and lose data or simply become unworkably live-locked just because they 
didn't know what they were doing when they setup the snapper script and 
set it to 1 minute snaps without any corresponding thinning after an hour 
or a day or whatever.


Anyway, the temporary snapshot-aware-defrag disable commit is now in 
mainline, committed shortly after 3.14-rc1 so it'll be in rc2, giving the 
devs some breathing room to work out a solution that scales rather better 
than what we had.  So defragging is (hopefully temporarily) not snapshot 
aware again ATM, but the pathologic snapshot-aware-defrag scaling issues 
are at least in a bounded set of kernel releases now, so the immediately 
critical problem should die down to some extent now, as the related 
commits (the patches did need some backporting rework, apparently) hit 
stable, anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

