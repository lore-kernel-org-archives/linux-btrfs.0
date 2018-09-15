Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46811 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725744AbeIOHsH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Sep 2018 03:48:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g10K9-0008JY-JP
        for linux-btrfs@vger.kernel.org; Sat, 15 Sep 2018 04:28:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: state of btrfs snapshot limitations?
Date: Sat, 15 Sep 2018 02:28:33 +0000 (UTC)
Message-ID: <pan$425cf$32d9f075$987b0e87$b2aa40b1@cox.net>
References: <CAPd04b4nXw_qe7+8msY26UDr-m+MBpzYn_UdqGQX8Z-KxNN_0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James A. Robinson posted on Fri, 14 Sep 2018 14:05:29 -0700 as excerpted:

> The mail archive seems to indicate this list is appropriate for not only
> the technical coding issues, but also for user questions, so I wanted to
> pose a question here.  If I'm wrong about that, I apologize in advance.

User questions are fine here.  In fact, there are a number of non-dev 
regulars here who normally take the non-dev level questions.  I'm one of 
them. =:^)

> The page
> 
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
> 
> talks about the basic snapshot capabilities of btrfs and led me to look
> up what, if any, limits might apply.  I find some threads from a few
> years ago that talk about limiting the number of snapshots for a volume
> to 100.

Btrfs is optimized to make snapshotting very fast -- on an atomic copy-on-
write tree-based filesystem like btrfs it's pretty much just taking a new 
reference pointing at the current tree head so nothing in it disappears, 
and that's very fast -- but maintenance that works with existing 
snapshots (and other references) is often slower and doesn't always scale 
so nicely.  While from btrfs' perspective there's nothing "magical" about 
the number 100, in human terms it is of course easy to remember, and it's 
very roughly where the number of snapshots starts to take its toll on the 
time required for various filesystem maintenance tasks, including 
deleting snapshots, balance, fsck, quota maintenance, etc.

So the number of snapshots you can get away with depends primarily on 
three things:

1) Easiest and biggest factor:  If you don't need quotas, simply keeping 
that functionality turned off makes a big difference, and if you /do/ 
need them, turning them off temporarily for maintenance such as a 
rebalance, then doing a quota rescan when the balance is completed, can 
be the difference between a balance taking days or weeks with quotas on 
and constantly updating during the balance, vs. hours to a couple days 
turning quotas off during the balance.  There have been quite a number of 
people who have posted questions about balance not being practical (or 
even thinking it was hung) as it was taking "forever", that found simply 
turning quotas off (sometimes they didn't even know they were on, it was 
a distro setting) fixed the problem and that balance completed in a 
reasonable time after that.

(There have recently been patches to avoid some of the worst constant 
rescanning during balance, but as my own use-case doesn't require either 
quotas or snapshotting, I'm not following their status, and if quotas 
aren't required keeping them off will remain simplest and most efficient 
in any case.)

2) Use-case need for maintenance:  While (almost) any periodic-
snapshotting use-case is going to need snapshot thinning and thus 
snapshot removal as routine maintenance, some use-cases, particularly at 
the large scale, aren't going to find less routine maintenance tasks like 
full balance (converting between raid levels or adding/deleting devices 
to/from an existing filesystem) or check --repair, etc, useful; they'll 
simply swap in a hot-spare backup and mkfs the former working copy they 
would have otherwise needed maintenance on, because it's easier/simpler/
faster for them than trying to repair or change the device config of the 
existing filesystem, and their operating parameters already require the 
hot-spare resources for other reasons.

This is likely why a working fsck repair mechanism wasn't a high priority 
early on, and why it still has "holes" in the types of damage it can 
repair.  The big users such as facebook and oracle funding development 
simply don't find that sort of functionality useful as they hot-swap 
instead.  

But even for more "normal/personal" use-cases, if adding a device and 
rebalancing to make efficient use of it, or if repairing a broken 
filesystem when you already have the valuable stuff on it backed up 
anyway, is going to take days, with no guarantee all the problems will be 
fixed in any case for the repair case, even if it's going to take 
dropping by the local computer/electronics (super-)store for a new disk 
or three (remember the multi-device case), it may well make more sense to 
do that then to take days doing the repair/device-add with the existing 
filesystem.

Obviously if you aren't going to be repairing the filesystem or adding/
removing devices, the time that takes isn't a factor you need to worry 
about, and snapshot-deletion times are likely to be the only thing you 
need to worry about in terms of snapshot numbers scaling.

3) Backing-device speed, ssd vs. spinning-rust, etc, matters, but not as 
much as you might think, because for some filesystem maintenance 
operations, particularly with large numbers of snapshots/reflinks, parts 
of them are cpu- or memory-bound, not IO-bound.


So while 100 snapshots is a convenient number as a recommendation, it 
really depends.  On slow systems with quotas on and full-balances/fscks a 
necessary part of the use-case, 50 may even be high, while on fast 
systems with quotas off and mkfs and restore from backup preferable to 
full balances and check --repairs, the pain threshold for snapshot 
numbers may be 1000 or more, and indeed, the recommendation used to be 
under 300, which allows for a thinning scheme with a much nicer comfort 
margin than the newer under 100 recommendation.


> The reason I'm curious is I wanted to try and use the snapshot
> capability as a way of keeping a 'history' of a backup volume I
> maintain.  The backup doesn't change a lot overtime, but small changes
> are made to files within it daily.

Just keep in mind that "snapshots do not and cannot replace backups".  
You appear to be actually doing this /with/ a backup, not /as/ your 
backup, so you are likely fine, but if for no other reason than because 
I'll sleep better knowing I mentioned it explicitly... Don't make the 
mistake of thinking you're covered because you have it snapshotted, and 
then end up posting here when something happens to the filesystem or 
device(s) it's on, and all those snapshots are gone with the same 
filesystem damage that took out the working copy!

> With btrfs I was thinking perhaps I could more efficiently maintain the
> archive of changes over time using a snapshot. If this is an awful
> thought and I should just go away, please let me know.

This is actually a valid and quite common use-case...

> If the limit is 100 or less I'd need use a more complicated rotation
> scheme.  For example with a layout like the following:
> 
> min/<mm>
> hour/<hh>
> day/<dd>
> month/<mm>
> year/<yyy>
> 
> The idea being each bucket, min, hour, day, month, would be capped and
> older snapshots would be removed and replaced with newer ones over time.
> 
> so with a 15-minute snapshot cycle I'd end up with
> 
> min/[00,15,30,45]
> hour/[00-23]
> day/[01-31]
> month/[01-12]
> year/[2018,2019,...]
> 
> (72+ snapshots with room for a few years worth of yearly's).
> 
> But if things have changed with btrfs over the past few years and number
> of snapshots scales much higher, I would use the easier scheme:
> 
> /min/[00,15,30,45]
> /hourly/[00-23]
> /daily/<yyyy>/<mmdd>
> 
> with 365 snapshots added per additional year.

There's potentially at least two other snapshotting reasons to keep in 
mind as well, as they could add to the total...

* If you're planning to use btrfs send/receive, presumably for backups, 
that requires read-only snapshots, probably with at least some kept 
around as reference points for later incremental send/receives, as well.

* Some distros take pre-upgrade snapshots in ordered to allow rollbacks 
if necessary.

You can probably integrate your planned snapshotting scheme with both of 
the above, certainly with the first, but they are something you need to 
be aware of and keep in consideration if they apply.


Another possible caveat: With the current use-case being primarily 
backup, this likely doesn't apply, but snapshots limit the effectiveness 
of nocow, which effectively becomes cow1.  Look into that if it does 
apply.


As to your scheme...

Traditionally, our examples use a snapshot timestamp scheme, with 
snapshots taken at the minimum period (every 15 minutes in the above) and 
then thinned down, say deleting every other one to 30 minutes after an 
hour or two, again deleting every other one to an hour after say six, 
deleting 5 of six to every six hours after a day (or 30 hours, to give an 
overlap of six hours), deleting 6 of 7 days after a week or two... 
deleting every other week after say 6 weeks, deleting half to every 4th 
week after six months, deleting 2/3 to every 12th week (~quarterly) after 
a year...

And then to help stress the difference between snapshots and backups, and 
to help free space and with fragmentation caused by keeping references to 
otherwise long gone files locked up in ancient snapshots, after a year or 
two, rather than thinning to annual snapshots and keeping those, I at 
least, recommended taking backups to other media (tape, physically 
swapped out hard drives, etc) if it was considered necessary to keep 
history that far back at all, and deleting all snapshots beyond a year or 
two out.

However, as I was composing the above discussion of snapshot creation 
being nearly cost-free, with snapshot deletion and other filesystem 
maintenance being the real cost of snapshots, in the context of your 
separated time-based scheme above, it occurred to me that taking multiple 
separate snapshots at different period intervals, so for instance worst-
case 00/minute, hourly, daily, monthly, yearly, all at (nearly) the same 
time, and then simply deleting all in the appropriate directory beyond 
some cap time, instead of the thinning logic of the above traditional 
model, wouldn't actually be much less efficient in terms of snapshot 
taking, because snapshotting is /designed/ to be fast, while at the same 
time it would significantly simplify the logic of the deletion scripts 
since they could simply delete everything older than X, instead of having 
to do conditional thinning logic.

So your scheme with period slotting and capping as opposed to simply 
timestamping and thinning, is a new thought to me, but I like the idea 
for its simplicity, and as I said, it shouldn't really "cost" more, 
because taking snapshots is fast and relatively cost-free. =:^)

I'd still recommend taking it easy on the yearly, tho, perhaps beyond a 
year or two, preferring physically media swapping and archiving at the 
yearly level if yearly archiving is found necessary at all.  And 
depending on your particular needs, physical-swap archiving at six months 
or even quarterly might actually be appropriate, especially given that 
(with spinning rust at least, I guess ssds retain best with periodic 
power-up) on-the-shelf archiving should be more dependable as a last-
resort backup.

Or do similar online with for example Amazon Glacier (never used 
personally, tho I actually have the site open for reference as I write 
this and at US $0.004 per gig per month... so say $100 for a TB for 2 
years or a couple hundred gig for a decade, $10/yr with a much better 
chance at actually being able to use it after a fire/flood/etc that'd 
take out anything local, tho actually retrieving it would cost a bit 
too... I'm actually thinking perhaps I should consider it... obviously 
I'd well encrypt first... until now I'd always done onsite backup only, 
figuring if I had a fire or something that'd be the last thing I'd be 
worried about, but now I'm actually considering...)

OK, so I guess the bottom-line answer is "it depends."  But the above 
should give you more data to plugin for your specific use-case.

But if it's pure backup, you don't expect to expand to more devices in-
place and you can blow it away and don't have to consider check --repair, 
AND you can do a couple filesystems so as to keep your daily snapshots 
separate from the more frequent backups and thus avoid snapshot deletion, 
you may actually be able to do the 365 dailies for 2-3 years then swap-
out filesystems and devices without deleting snapshots, thus avoiding any 
of the maintenance-scaling issues that are the big limitation, and have 
it work just fine.

OTOH, if you're use-case is a bit more conventional, with more 
maintenance to have to worry about scaling, capping to 100 snapshots 
remains a reasonable recommendation, and if you need quotas as well and 
can't afford to disable them even temporarily for a balance, you may find 
under 50 snapshots to be your maintenance pain tolerance threshold.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
