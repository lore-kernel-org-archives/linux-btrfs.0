Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52371 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaJWUi3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 16:38:29 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so5180044wib.5
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 13:38:28 -0700 (PDT)
Received: from [192.168.0.12] (195-132-168-97.rev.numericable.fr. [195.132.168.97])
        by mx.google.com with ESMTPSA id bj7sm3365157wjc.33.2014.10.23.13.38.27
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Oct 2014 13:38:27 -0700 (PDT)
Message-ID: <54496742.4000206@gmail.com>
Date: Thu, 23 Oct 2014 22:38:26 +0200
From: Arnaud Kapp <kapp.arno@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 5 _thousand_ snapshots? even 160?
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>	<5446BEC0.8070009@siedziba.pl> <5446C597.9080904@gmail.com>	<54470403.8020904@pobox.com> <pan$42d5e$16ecc804$d0548cbe$495d3427@cox.net>
In-Reply-To: <pan$42d5e$16ecc804$d0548cbe$495d3427@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

First, I'd like to thank you for this is interesting discussion
and for pointing efficient snapshotting strategies.

My 5k snapshots actually come from 4 subvolumes. I create 8 snapshots
per hour because I actually create both a read-only and writable
snapshots for each of my volume. Yeah this may sound dump, but this
setup was my first use of btrfs --> oh some cool feature, lets abuse
them !

The reason I did that is simple: w/o reading this mailing list, I would
have continued to think that snapshots were really that cheap (a la 
git-branch). Turns out it's not the case (yet?).

I will now rethink my snapshotting plan thanks to you.

On 10/22/2014 06:05 AM, Duncan wrote:
> Robert White posted on Tue, 21 Oct 2014 18:10:27 -0700 as excerpted:
>
>> Each snapshot is effectively stapling down one version of your entire
>> metadata tree, right? So imagine leaving tape spikes (little marks on
>> the floor to keep track of where something is so you can put it back)
>> for the last 150 or 5000 positions of the chair you are sitting in. At
>> some point the clarity and purpose of those marks becomes the opposite
>> of useful.
>>
>> Hourly for a day, daily for a week, weekly for a month, monthly for a
>> year. And it's not a "backup" if you haven't moved it to another device.
>> If you have 5k snapshots of a file that didn't change, you are still
>> just one bad disk sector away from never having that data again because
>> there's only one copy of the actual data stapled down in all of those
>> snapshots.
>
> Exactly.
>
> I explain the same thing in different words:
>
> (Note: "You" in this post is variously used to indicate the parent
> poster, and a "general you", including but not limited to the grandparent
> poster inquiring about his 5000 hourly snapshots.  As I'm not trying to
> write a book or a term paper I actively suppose it should be clear to
> which "you" I'm referring in each case based on context...)
>
> Say you are taking hourly snapshots of a file, and you mistakenly delete
> it or need a copy from some time earlier.
>
> If you figure that out a day later, yes, the hour the snapshot was taken
> can make a big difference.
>
> If you don't figure it out until a month later, then is it going to be
> REALLY critical which HOUR you pick, or is simply picking one hour in the
> correct day (or possibly half-day) going to be as good, knowing that if
> you guess wrong you can always go back or forward another whole day?
>
> And if it's a year later, is even the particular day going to matter, or
> will going forward or backward a week or a month going to be good enough?
>
> And say it *IS* a year later, and the actual hour *DOES* matter.  A year
> later, exactly how are you planning to remember the EXACT hour you need,
> such that simply randomly picking just one out of the day or week is
> going to make THAT big a difference?
>
> As you said but adjusted slightly to even out the weeks vs months, hourly
> for a day (or two), daily to complete the week (or two), weekly to
> complete the quarter (13 weeks), and if desired, quarterly for a year or
> two.
>
> But as you also rightly pointed out, just as if it's not tested it's not
> a backup, if it's not on an entirely separate device and filesystem, it's
> not a backup.
>
> And if you don't have real backups at least every quarter, why on earth
> are you worrying about a year's worth of hourly snapshots?  If disaster
> strikes and the filesystem blows up, without a separate backup, they're
> all gone, so why the trouble to keep them around in the first place?
>
> And once you have that quarterly or whatever backup, then the advantage
> of continuing to lock down those 90-day-stale copies of all those files
> and metadata goes down dramatically, since if worse comes to worse, you
> simply retrieve it from backup, but meanwhile, all that stale locked down
> data and metadata is eating up room and dramatically complicating the job
> btrfs must do to manage it all!
>
> Yes, there are use-cases and there are use-cases.  But if you aren't
> keeping at least quarterly backups, perhaps you better examine your
> backup plan and see if it really DOES match your use-case, ESPECIALLY if
> you're keeping thousands of snapshots around.  And once you DO have those
> quarterly or whatever backups, then do you REALLY need to keep around
> even quarterly snapshots covering the SAME period?
>
> But let's say you do:
>
> 48 hourly snapshots, thinned after that to...
>
> 12 daily snapshots (2 weeks = 14, minus the two days of hourly), thinned
> after that to...
>
> 11 weekly snapshots (1 quarter = 13 weeks, minus the two weeks of daily),
> thinned after that to...
>
> 7 quarterly snapshots (2 years = 8 quarters, minus the quarter of weekly).
>
> 48 + 12 + 11 + 7 = ...
>
> 78 snapshots, appropriately spaced by age, covering two full years.
>
> I've even done the math for the extreme case of per-minute snapshots.
> With reasonable thinning along the lines of the above, even per-minute
> snapshots ends up well under 300 snapshots being reasonably managed at
> any single time.
>
> And keeping it under 300 snapshots really DOES help btrfs in terms of
> management task time-scaling.
>
> If you're doing hourly, as I said, 78, tho killing the quarterly
> snapshots entirely because they're backed up reduces that to 71, but
> let's just say, EASILY under 100.
>
> Tho that is of course per subvolume.  If you have multiple subvolumes on
> the same filesystem, that can still end up being a thousand or two
> snapshots per filesystem.  But those are all groups of something under
> 300 (under 100 with hourly) highly connected to each other, with the
> interweaving inside each of those groups being the real complexity in
> terms of btrfs management.
>
> But 5000 snapshots?
>
> Why?  Are you *TRYING* to test btrfs until it breaks, or TRYING to
> demonstrate a balance taking an entire year?
>
> Do a real backup (or more than one, using those snapshots) if you need
> to, then thin the snapshots to something reasonable.  As the above
> example shows, if it's a single subvolume being snapshotted, with hourly
> snapshots, 100 is /more/ than reasonable.
>
> With some hard questions, keeping in mind the cost in extra maintenance
> time for each additional snapshot, you might even find that minimum 6-
> hour snapshots (four per day) instead of 1-hour snapshots (24 per day)
> are fine.  Or you might find that you only need to keep hourly snapshots
> for 12 hours instead of the 48 I assumed above, and daily snapshots for a
> week instead of the two I assumed above.  Throwing in the nothing over a
> quarter because it's backed up assumption as well, that's...
>
> 8 4x-daily snapshots (2 days)
>
> 5 daily snapshots (a week, minus the two days above)
>
> 12 weekly snapshots (a quarter, minus the week above, then it's backed up
> to other storage)
>
> 8 + 5 + 12 = ...
>
> 25 snapshots total, 6-hours apart (four per day) at maximum frequency aka
> minimum spacing, reasonably spaced by age to no more than a week apart,
> with real backups taking over after a quarter.
>
> Btrfs should be able to work thru that in something actually approaching
> reasonable time, even if you /are/ dealing with 4 TB of data. =:^)
>
> Bonus hints:
>
> Btrfs quotas significantly complicate management as well.  If you really
> need them, fine, but don't unnecessarily use them just because they are
> there.
>
> Look into defrag.
>
> If you don't have any half-gig plus VMs or databases or similar "internal
> rewrite pattern" files, consider the autodefrag mount option.  Note that
> if you haven't been using it and your files are highly fragmented, it can
> slow things down at first, but a manual defrag, possibly a directory tree
> at a time to split things up into reasonable size and timeframes, can
> help.
>
> If you are running large VMs or databases or other half-gig-plus sized
> internal-rewrite-pattern files, the autodefrag mount option may not
> perform well for you.  There's other options for that, including separate
> subvolumes, setting nocow on those files, and setting up a scheduled
> defrag.  That's out of scope for this post, so do your research.  It has
> certainly been discussed enough on-list.
>
> Meanwhile, do note that defrag is currently snapshot-aware-disabled, due
> to scaling issues.  IOW, if your files are highly fragmented as they may
> well be if you haven't been regularly defragging them, expect the defrag
> to eat a lot of space since it'll break the sharing with older snapshots
> as anything that defrag moves will be unshared.  However, if you've
> reduced snapshots to the quarter-max before off-filesystem backup as
> recommended above, a quarter from now all the undefragged snapshots will
> be expired and off the system and you'll have reclaimed that extra space.
> Meanwhile, your system should be /much/ easier to manage and will likely
> be snappier in its response as well.  =:^)
>
> With all these points applied, balance performance should improve
> dramatically.  However, with 4 TB of data the shear data size will remain
> a factor.  Even in the best case typical thruput on spinning rust won't
> reach the ideal.  10 MiB/sec is a reasonable guide.  4 TiB/10 MiB/sec...
>
> 4*1024*1024 (MiB) /  10 MiB / sec = ...
>
> nearly 420 thousand seconds ... / 60 sec/min = ...
>
> 7000 minutes ... / 60 min/hour = ...
>
> nearly 120 hours or ...
>
> a bit under 5 days.
>
>
> So 4 TiB on spinning rust could reasonably take about 5 days to balance
> even under quite good conditions.  That's due to the simple mechanics of
> head seek to read, head seek again to write, on spinning rust, and the
> shear size of 4 TB of data and metadata (tho with a bit of luck some of
> that will disappear as you thin out those thousands of snapshots, and
> it'll be more like 3 TB than 4, or possibly even down to 2 TiB, by the
> time you actually do it).
>
> IOW, it's not going to be instant, by any means.
>
> But the good part of it is that you don't have to do it all at once.  You
> can use balance filters and balance start/pause/resume/cancel as
> necessary, to do only a portion of it at a time, and restart the balance
> using the convert,soft options so it doesn't redo already converted
> chunks when you have time to let it run.  As long as it completes at
> least one chunk each run it'll make progress.
>
