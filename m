Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48593 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbbE2EIO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 May 2015 00:08:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YyBae-0003Er-0h
	for linux-btrfs@vger.kernel.org; Fri, 29 May 2015 06:08:12 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2015 06:08:11 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2015 06:08:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Uncorrectable errors on RAID6
Date: Fri, 29 May 2015 04:08:02 +0000 (UTC)
Message-ID: <pan$9f47d$1eb16721$9531b0c4$5adc6e9e@cox.net>
References: <CAGwxe4h5ubG1SptGLH9STNvDaghQJwbUXEDTa_UHREXye9nPsA@mail.gmail.com>
	<55668222.8060707@cn.fujitsu.com>
	<CAGwxe4iTtf87K=WYMYWaUBQ7SEVSp3LEu4sT8eYzW2fiPn6ybw@mail.gmail.com>
	<CAGwxe4hcJAZw6=G9p3UqNzb3J6KM+pb6-ZXKU8bWMcaRCEa1+A@mail.gmail.com>
	<5567B48E.30003@cn.fujitsu.com>
	<CAGwxe4huzc-+stYGrma=FcO0_tdeKnyPwGRE5EtH3azfBcjzqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tobias Holst posted on Fri, 29 May 2015 04:00:15 +0200 as excerpted:

> Back to my actual data: Are there any tips on how to recover? Mount
> with "recover", copy over and see the log, which files seem to be
> broken? Or some (dangerous) tricks on how to repair this broken file
> system?
> I do have a full backup, but it's very slow and may take weeks
> (months?), if I have to recover everything.

Unfortunately I can't be of any direct help.  For that, Qu is a dev and 
already providing quite a bit.  But perhaps this will help a bit with 
background and in further decisions once the big current issue is dealt 
with...

With that out of the way...

As a (non-dev) btrfs user, sysadmin, and list regular, I can point out 
that full btrfs raid56 mode support is quite new, 3.19 was the first that 
had complete support in theory, and any code that new is very likely 
buggy enough you won't want to rely on it for anything but testing.  Real-
world deployment... can come later, after a few kernel cycles worth of 
maturing.  I've been recommending waiting at least two kernel cycles to 
work out the worst bugs, and that would still be very leading, perhaps 
bleeding, edge.  Better to wait about five cycles, a year or so, after 
which point btrfs raid56 mode should have stabilized to about that of the 
rest of btrfs, which is to say, not entirely stable yet, but reasonably 
usable for most people, provided they're following the sysadmin's backups 
rule, if they don't have backups by definition they don't care about the 
data regardless of claims to the contrary, and untested would-be backups 
cannot for purposes of this rule be considered backups.

The recommendation for now thus remains to stick with btrfs raid1 or 
raid10 modes, which are already effectively as mature as btrfs itself 
is.  Of course, given the six devices in your raid6, raid10 would be the 
more common choice, but since btrfs raid1 is only two-way-mirrored in any 
case, you'd get the same effective three-device capacity (assuming 
devices of roughly the same size) either way

And in fact the list unfortunately has several threads of folks with 
similar raid56 mode issues.  On the bright side, I guess their disasters 
are where the improvements and stabilization come from that the folks 
waiting the recommended two kernel cycles minimum, better a year (five 
kernel cycles), get, and were they not there, the recommended wait time 
would have to be longer.  Unfortunately that's little help for the folks 
with the problem...

So you have a backup, but it's slow enough you're looking at weeks or 
months to recover from it.  So it's a last-resort backup, but not a 
/practical/ backup.

How on earth did you come to use btrfs raid56 mode for this more or less 
not practically backed up data, despite the recommendations and long 
history of partial raid56 support indicating its complexity and thus the 
likelihood of severe bugs still being present, in the first place?  In 
fact, given a restore time of weeks to months and the fact that btrfs 
itself isn't yet completely stable, I'd wonder about choosing it in any 
mode (I can't imagine doing so myself with that sort of restore time, and 
I'd give up fancy features in ordered to get something as stable as 
possible, to cut down as far as possible the chance of having to use 
it... or perhaps more practically, I'd have an on-site primary backup 
with restore time on the order of hours to days, in addition to the 
presumably remote, slow backup and restore, which never-the-less remains 
an excellent insurance policy for the worst-case), but certainly, the 
still so new it's extremely likely to be buggy enough to eat data raid56 
mode isn't appropriate.

Hopefully you can restore, either via direct copy-off, or using btrfs 
restore (as Qu mentions), which has in fact been something I've used a 
couple times myself (on btrfs raid1, there's a reason I say btrfs itself 
isn't fully stable yet) as I've had backups but they weren't current 
(obviously a tradeoff I was willing to make, given my knowledge of the 
sysadmin's backup rule above), and btrfs restore worked better for me 
than the backups would have.

But given that you'll have to be restoring to something else, I'd 
strongly recommend at /least/ switching to btrfs raid1/10 mode, for the 
time being, if not to something other than btrfs if you still aren't 
going to have backups that restore in hours to days rather than weeks to 
months, because btrfs really /isn't/ stable enough for the latter case 
yet.

Then, since you'll have the extra storage you'll have freed after 
switching to the restored copy, I'd use that to create that local backup, 
restorable in days at maximum, rather than weeks at minimum, that you're 
currently missing.  With that backup in-place and tested, going ahead and 
playing with btrfs in its still not entirely stable, but for daily use 
with backups ready if needed, stable /enough/, is reasonable.  Just stay 
away from the raid56 stuff until it has a bit more time to mature, unless 
you really /do/ want to be a test guinea pig and actually having to use 
that backup won't bother you. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

