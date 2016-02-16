Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46875 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbcBPJLQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 04:11:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aVbf8-0003Fp-GX
	for linux-btrfs@vger.kernel.org; Tue, 16 Feb 2016 10:11:14 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 10:11:14 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 10:11:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Major HDD performance degradation on btrfs receive
Date: Tue, 16 Feb 2016 09:10:57 +0000 (UTC)
Message-ID: <pan$e915c$8746b287$af5e3af4$2174b65@cox.net>
References: <b9e02f6f-dc3e-94c1-1a60-30192206c95e@mokrynskyi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nazar Mokrynskyi posted on Tue, 16 Feb 2016 05:44:30 +0100 as excerpted:

> I have 2 SSD with BTRFS filesystem (RAID) on them and several
> subvolumes. Each 15 minutes I'm creating read-only snapshot of
> subvolumes /root, /home and /web inside /backup.
> After this I'm searching for last common subvolume on /backup_hdd,
> sending difference between latest common snapshot and simply latest
> snapshot to /backup_hdd.
> On top of all above there is snapshots rotation, so that /backup
> contains much less snapshots than /backup_hdd.

One thing thing that you imply, but don't actually make explicit except 
in the btrfs command output and mount options listing, is that /backup_hdd 
is a mountpoint for a second entirely independent btrfs (LABEL=Backup), 
while /backup is a subvolume on the primary / btrfs.  Knowing that is 
quite helpful in figuring out exactly what you're doing. =:^)

Further, implied, but not explicit since some folks use hdd when 
referring to ssds as well, is that the /backup_hdd hdd is spinning rust, 
tho you do make it explicit that the primary btrfs is on ssds.

> I'm using this setup for last 7 months or so and this is luckily the
> longest period when I had no problems with BTRFS at all.
> However, last 2+ months btrfs receive command loads HDD so much that I
> can't even get list of directories in it.
> This happens even if diff between snapshots is really small.
> HDD contains 2 filesystems - mentioned BTRFS and ext4 for other files,
> so I can't even play mp3 file from ext4 filesystem while btrfs receive
> is running.
> Since I'm running everything each 15 minutes this is a real headache.

The *big* question is how many snapshots you have on LABEL=Backup, since 
you mention rotating backups in /backup, but don't mention rotating/
thinning backups on LABEL=Backup, and do explicitly state that it has far 
more snapshots, and with four snapshots an hour, they'll build up rather 
fast if you aren't thinning them.

The rest of this post assumes that's the issue, since you didn't mention 
thinning out the snapshots on LABEL=Backup.  If you're already familiar 
with the snapshot scaling issue and snapshot caps and thinning 
recommendations regularly posted here, feel free to skip the below as 
it'll simply be review. =:^)

Btrfs has scaling issues when there's too many snapshots.  The 
recommendation I've been using is a target of no more than 250 snapshots 
per subvolume, with a target of no more than eight subvolumes and ideally 
no more than four subvolumes being snapshotted per filesystem, which 
doing the math leads to an overall filesystem target snapshot cap of 
1000-2000, and definitely no more than 3000, tho by that point the 
scaling issues are beginning to kick in and you'll feel it in lost 
performance, particularly on spinning rust, when doing btrfs maintenance 
such as snapshotting, send/receive, balance, check, etc.

Unfortunately, many people post here complaining about performance issues 
when they're running 10K+ or even 100K+ snapshots per filesystem and the 
various btrfs maintenance commands have almost ground to a halt. =:^(

You say you're snapshotting three subvolumes, / /home and /web, at 15 
minute intervals.  That's 3*4=12 snapshots per hour, 12*24=288 snapshots 
per day.  If all those are on LABEL=Backup, you're hitting the 250 
snapshots per subvolume target in 250/4/24 = ... just over 2 and a half 
days.  And you're hitting the total per-filesystem snapshots target cap 
in 2000/288= ... just under seven days.

If you've been doing that for 7 months with no thinning, that's 
7*30*288= ... over 60K snapshots!  No *WONDER* you're seeing performance 
issues!

Meanwhile, say you need a file from a snapshot from six months ago.  Are 
you *REALLY* going to care, or even _know_, exactly what 15 minute 
snapshot it was?  And even if you do, just digging thru 60K+ snapshots... 
OK, so we'll assume you sort them by snapshotted subvolume so only have 
to dig thru 20K+ snapshots... just digging thru 20K snapshots to find the 
exact 15-minute snapshot you need... is quite a bit of work!

Instead, suppose you have a "reasonable" thinning program.  First, do you 
really need _FOUR_ snapshots an hour to LABEL=Backup?  Say you make it 
every 20 minutes, three an hour instead of four.  That already kills a 
third of them.  Then, say you take them every 15 or 20 minutes, but only 
send one per hour to LABEL=Backup.  (Or if you want, do them every 15 
minutes and send only ever other one, half-hourly to LABEL=Backup.  The 
point is to keep it both something you're comfortable with but also more 
reasonable.)

For illustration, I'll say you send once an hour.  That's 3*24=72 
snapshots per day, 24/day per subvolume, already a great improvement over 
the 96/day/subvolume and 288/day total you're doing now.

If then once a day, you thin down the third day back to every other hour, 
you'll have 2-3 days worth of hourly snapshots on LABEL=backup, so upto 
72 hourly snapshots per subvolume.  If on the 8th day you thin down to 
six-hourly, 4/day, cutting out 2/3, you'll have five days of 12/day/
subvolume, 60 snapshots per subvolume, plus the 72, 132 snapshots per 
subvolume total, to 8 days out so you can recover over a week's worth at 
at least 2-hourly, if needed.

If then on the 32 day (giving you a month's worth of at least 4X/day), 
you cut every other one, giving you twice a day snapshots, that's 24 days 
of 2X/day or 48 snapshots per subvolume, plus the 132 from before, 180 
snapshots per subvolume total, now.

If then on the 92 day (giving you two more months of 2X/day, a quarter's 
worth of at least 2X/day) you again thin every other one, to one per day, 
you have 60 days @ 2X/day or 120 snapshots per subvolume, plus the 180 we 
had already, 300 snapshots per subvolume, now.

OK, so we're already over our target 250/subvolume, so we could thin a 
bit more drastically.  However, we're only snapshotting three subvolumes, 
so we can afford a bit of lenience on the per-subvolume cap as that's 
assuming 4-8 snapshotted subvolumes, and we're still well under our total 
filesystem snapshot cap.

If then you keep another quarter's worth of daily snapshots, out to 183 
days, that's 91 days of daily snapshots, 91 per subvolume, on top of the 
300 we had, so now 391 snapshots per subvolume.

If you then thin to weekly snapshots, cutting 6/7, and keep them around 
another 27 weeks (just over half a year, thus over a year total), that's 
27 more snapshots per subvolume, plus the 391 we had, 418 snapshots per 
subvolume total.

418 snapshots per subvolume total, starting at 3-4X per hour to /backup 
and hourly to LABEL=Backup, thinning down gradually to weekly after six 
months and keeping that for the rest of the year.  Given that you're 
snapshotting three subvolumes, that's 1254 snapshots total, still well 
within the 1000-2000 total snapshots per filesystem target cap.

During that year, if the data is worth it, you should have done an offsite 
or at least offline backup, we'll say quarterly.  After that, keeping the 
local online backup around is merely for convenience, and with quarterly 
backups, after a year you have multiple copies and can simply delete the 
year-old snapshots, one a week, probably at the same time you thin down 
the six-month-old daily snapshots to weekly.

Compare that just over 1200 snapshots to the 60K+ snapshots you may have 
now, knowing that scaling over 10K snapshots is an issue particularly on 
spinning rust, and you should be able to appreciate the difference it's 
likely to make. =:^)

But at the same time, in practice it'll probably be much easier to 
actually retrieve something from a snapshot a few months old, because you 
won't have tens of thousands of effectively useless snapshots to sort 
thru as you will be regularly thinning them down! =:^)

> ~> uname [-r]
> 4.5.0-rc4-haswell
> 
> ~> btrfs --version
> btrfs-progs v4.4

You're staying current with your btrfs versions.  Kudos on that! =:^)

And on including btrfs fi show and btrfs fi df, as they were useful, tho 
I'm snipping them here.

One more tip.  Btrfs quotas are known to have scaling issues as well.  If 
you're using them, they'll exacerbate the problem.  And while I'm not 
sure about current 4.4 status, thru 4.3 at least, they were buggy and not 
reliable anyway.  So the recommendation is to leave quotas off on btrfs, 
and use some other more mature filesystem where they're known to work 
reliably if you really need them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

