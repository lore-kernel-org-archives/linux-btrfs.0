Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37757 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1729714AbeGQVto (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 17:49:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1ffXHJ-0003pJ-R1
        for linux-btrfs@vger.kernel.org; Tue, 17 Jul 2018 23:13:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
Date: Tue, 17 Jul 2018 21:12:55 +0000 (UTC)
Message-ID: <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
References: <cover.1531503452.git.dsterba@suse.com>
        <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
        <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Mon, 16 Jul 2018 20:29:46 +0200 as
excerpted:

> On 07/15/2018 04:37 PM, waxhead wrote:

> Striping and mirroring/pairing are orthogonal properties; mirror and
> parity are mutually exclusive.

I can't agree.  I don't know whether you meant that in the global sense, 
or purely in the btrfs context (which I suspect), but either way I can't 
agree.

In the pure btrfs context, while striping and mirroring/pairing are 
orthogonal today, Hugo's whole point was that btrfs is theoretically 
flexible enough to allow both together and the feature may at some point 
be added, so it makes sense to have a layout notation format flexible 
enough to allow it as well.

In the global context, just to complete things and mostly for others 
reading as I feel a bit like a simpleton explaining to the expert here, 
just as raid10 is shorthand for raid1+0, aka raid0 layered on top of 
raid1 (normally preferred to raid01 due to rebuild characteristics, and 
as opposed to raid01, aka raid0+1, aka raid1 on top of raid0, sometimes 
recommended as btrfs raid1 on top of whatever raid0 here due to btrfs' 
data integrity characteristics and less optimized performance), so 
there's also raid51 and raid15, raid61 and raid16, etc, with or without 
the + symbols, involving mirroring and parity conceptually at two 
different levels altho they can be combined in a single implementation 
just as raid10 and raid01 commonly are.  These additional layered-raid 
levels can be used for higher reliability, with differing rebuild and 
performance characteristics between the two forms depending on which is 
the top layer.

> Question #1: for "parity" profiles, does make sense to limit the maximum
> disks number where the data may be spread ? If the answer is not, we
> could omit the last S. IMHO it should.

As someone else already replied, btrfs doesn't currently have the ability 
to specify spread limit, but the idea if we're going to change the 
notation is to allow for the flexibility in the new notation so the 
feature can be added later without further notation changes.

Why might it make sense to specify spread?  At least two possible reasons:

a) (stealing an already posted example) Consider a multi-device layout 
with two or more device sizes.  Someone may want to limit the spread in 
ordered to keep performance and risk consistent as the smaller devices 
fill up, limiting further usage to a lower number of devices.  If that 
lower number is specified as the spread originally it'll make things more 
consistent between the room on all devices case and the room on only some 
devices case.

b) Limiting spread can change the risk and rebuild performance profiles.  
Stripes of full width mean all stripes have a strip on each device, so 
knock a device out and (assuming parity or mirroring) replace it, and all 
stripes are degraded and must be rebuilt.  With less than maximum spread, 
some stripes won't be stripped to the replaced device, and won't be 
degraded or need rebuilt, tho assuming the same overall fill, a larger 
percentage of stripes that /do/ need rebuilt will be on the replaced 
device.  So the risk profile is more "objects" (stripes/chunks/files) 
affected but less of each object, or less of the total affected, but more 
of each affected object.

> Question #2: historically RAID10 is requires 4 disks. However I am
> guessing if the stripe could be done on a different number of disks:
> What about RAID1+Striping on 3 (or 5 disks) ? The key of striping is
> that every 64k, the data are stored on a different disk....

As someone else pointed out, md/lvm-raid10 already work like this.  What 
btrfs calls raid10 is somewhat different, but btrfs raid1 pretty much 
works this way except with huge (gig size) chunks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

