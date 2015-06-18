Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56501 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbbFRIAi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 04:00:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z5UkN-0003NC-4E
	for linux-btrfs@vger.kernel.org; Thu, 18 Jun 2015 10:00:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 10:00:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 10:00:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID10 Balancing Request for Comments and Advices
Date: Thu, 18 Jun 2015 08:00:20 +0000 (UTC)
Message-ID: <pan$1dafb$f1bd5eb3$9b82558d$abbe0967@cox.net>
References: <1434456557.89597618@apps.rackspace.com>
	<20150616122545.GI9850@carfax.org.uk>
	<61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com>
	<pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net>
	<74449C35-BA4E-4476-9EA1-EFE66312AFFA@up4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vincent Olivier posted on Wed, 17 Jun 2015 09:46:50 -0400 as excerpted:

>> On Jun 16, 2015, at 7:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> 
>> Yes.  GlobalReserve is for short-term btrfs-internal use, reserved for
>> times when btrfs needs to (temporarily) allocate some space in ordered
>> to free space, etc.  It's always single, and you'll rarely see anything
>> but 0 used except perhaps in the middle of a balance or something.
> 
> 
> Get it. Thanks.
> 
> Is there anyway to put that on another device, say, a SSD?

Not (AFAIK) presently.  There are various btrfs feature suggestions 
involving selective steering various btrfs component bits to faster or 
slower devices, etc, as can be seen on the wiki, but the btrfs chunk 
allocator isn't really customizable beyond basic raid-level, yet.  It 
does what it does and that's it.  For fancy features such as this, unless 
you're a company or individual with resources to invest in a specific 
feature of interest, I'd say give btrfs development another five years or 
so, and it may be tackling this sort of thing.

The two actually working alternatives I know of are bcached btrfs 
(there's someone on-list that actually does that and reports it working), 
and a more mature "btrfs-similar" solution such as zfs, tho of course zfs 
on Linux has its own issues, primarily licensing/legal.

> I am thinking
> of backing up this RAID10 on a 2x8TB device-managed SMR RAID1 and I want
> to minimize random write operations (noatime & al.). I will start a new
> thread for that maybe but first, is there something substantial I can
> read about btrfs+SMR? Or should I avoid SMR+btfs ?

I haven't the foggiest, but in case it spares someone looking up SMR like 
I just had to do, SMR = Shingled Magnetic Recording -- the new "shingled" 
drives that have been in the tech news since shortly before they started 
shipping in late 2013.

https://en.wikipedia.org/wiki/Shingled_magnetic_recording

> ok then, rule of the thumb re-run the scrub on “unverified checksum
> error(s)”. I have yet to see checksum errors yet but will keep it in
> mind..

FWIW, see my few minutes ago reply to Marc MERLIN in the "BTRFS: read 
error corrected: ino 1 off ...." thread, if you're interested in further 
discussion on this.  

But regardless, based on my own experience, that's a good rule of thumb, 
yes. =:^)

>> Meanwhile, I'm having a bit of morbid fun watching as [a dying ssd]
>> slowly decays, getting experience of the process in a reasonably
>> controlled setting without serious danger to my data, since it is
>> backed up.

> You sure have morbid inclinations ! ;-)

=:^)

> Out of curiosity what is the frequency and sequence of smartctl
> long/short tests + btrfs scrubs ? Is it all automated ?

I haven't automated any of that, except that since this dying ssd thing 
started I created a small scriptlet (could be an alias, but I prefer 
scriptlets), "bscrub", that runs btrfs scrub start -Bd $*, to avoid 
typing in the full command.  All I have to add is the mountpoint to 
scrub, possibly preceded by -r to read-only scrub /, which I keep read-
only mounted by default.

Perhaps to my harm I don't actually do the smart-tests regularly.  I'm 
not actually sure they're particularly useful on SSDs, particularly when 
using checksum-verified and raid-redundant filesystems such as btrfs in 
raid1/10 mode (and raid5/6 as it matures).  In practice btrfs scrub 
regularly reporting error corrected and/or nasty bus reset errors showing 
up in the logs are a pretty good advance indicators, better than smart 
status, from what I've seen.

I do check smartctrl -AH regularly, particularly now, but (in the past at 
least, I think my habit may be changing for the better, now, one of the 
positive results of letting the dying ssd run for the moment) less 
frequently when no problems are evident.

I actually have a pretty firm policy of splitting up my data onto 
separate filesystems (btrfs subvolumes don't cut it for me as all the 
data eggs are still in the same filesystem basket and if its bottom falls 
out, !!!!), keeping them of easily managed and easily backed up size.  My 
largest btrfs is actually under 50 gig.  Between that and the fact that 
I'm using ssds, whole-filesystem maintenance (btrfs scrub, balance, and 
check commands) time is on the order of seconds to a few minutes (single 
digits) per filesystem.  As a result, running them is relatively trivial 
-- it doesn't take the hours to days people report for their multi-
terabyte btrfs on spinning rust, and I can and do sometimes run them on a 
whim.  Scrubs are generally under a minute per filesystem, with only a 
handful of filesystems routinely used, so under 10 minutes, total, 
including repeat-runs, on all routinely mounted btrfs.

Given the trivial time factor I basically simply integrated the scrub 
into my update procedure (weekly on average, tho it can be daily if I'm 
waiting on a fix or 10-14 days if I'm lazy), since that's my biggest 
filesystem changes and thus most likely to trigger new bad blocks.  / is 
read-only mounted by default except for updates, and the packages 
partition is only mounted for updates, so that takes care of them.  I've 
lately taken to scrubbing home every couple of days, before a reboot or 
sometimes when I'm reading this list and thus thinking about it.  boot 
and log are both trivial, under a gig each so scrubbed about as fast as I 
lift my finger off enter.  And boot isn't mounted by default and can be 
scrubbed when I mount it to update kernels, while log isn't something I'm 
hugely worried about losing.  My big partition is the media partition, 
but that's still reiserfs on spinning rust, so is neither scrubbable nor 
endangered by the failing ssd.  Other than that there's the backup 
versions of all these filesystem partitions, but they too can be scrubbed 
on update (primary backup, btrfs, on the ssds) or are still on reiserfs 
on spinning rust (secondary backup).

>> As for raid0 (and single), there's only one copy.  Btrfs detects
>> checksum failure as it does above, but since there's only the one copy,
>> if it's bad, well, for data you simply can't access that file any
>> longer.  For metadata, you can't access whatever directories and files
>> it referenced,
>> any longer.  (FWIW for the truly desperate who hope that at least some
>> of it can be recovered even if it's not a bit-perfect match, there's a
>> btrfs command that wipes the checksum tree, which will let you access
>> the previously bad-checksum files again, but it works on the entire
>> filesystem so it's all or nothing, and of course with known corruption,
>> there's no guarantees.)
> 
> But is it possible to manually correct the corruption by overwriting the
> corrupted files with a copy from a backup ? I mean is there enough
> information reported in order to do that ?

In general, yes.  For data corruption, btrfs scrub prints the affected 
file, so deleting it and pulling a new copy over from backup shouldn't be 
an issue.

Metadata is by nature a bit more difficult to trace down and correct, but 
(except for ssd) it's dup by default on single-device and raid1 by 
default on multi-device anyway, and I'd consider anyone playing games 
with single metadata without backups to be getting exactly the deal they 
negotiated for if they lose it all.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

