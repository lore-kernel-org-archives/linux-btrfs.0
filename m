Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50398 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbeILHCZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 03:02:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fzuPt-0007iY-6Y
        for linux-btrfs@vger.kernel.org; Wed, 12 Sep 2018 03:58:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: List of known BTRFS Raid 5/6 Bugs?
Date: Wed, 12 Sep 2018 01:57:58 +0000 (UTC)
Message-ID: <pan$18836$37b6f591$6932ddf6$a289595@cox.net>
References: <2685207.fCDoYgCM7x@t460-skr>
        <pan$3058a$74a39424$67b0d289$23de5876@cox.net> <2964682.kQZMURGi49@t460-skr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan K posted on Tue, 11 Sep 2018 13:29:38 +0200 as excerpted:

> wow, holy shit, thanks for this extended answer!
> 
>> The first thing to point out here again is that it's not
>> btrfs-specific.
> so that mean that every RAID implemantation (with parity) has such Bug?
> I'm looking a bit, it looks like that ZFS doesn't have a write hole.

Every parity-raid implementation that doesn't contain specific write-hole 
workarounds, yes, but some already have workarounds built-in, as btrfs 
will after the planned code is written/tested/merged/tested-more-broadly.

https://www.google.com/search?q=parity-raid+write-hole [1]

As an example, back some years ago when I was doing raid6 on mdraid, it 
had the write-hole problem and I remember reading about it at the time.  
However, right on the first page of hits for the above search...

LWN: A journal for MD/RAID5 : https://lwn.net/Articles/665299/

Seems md/raid5's write hole was (optionally) closed in kernel 4.4 with an 
optional journal device... preferably a fast ssd or nvram, to avoid 
performance issues, and mirrored, to avoid the journal itself being a 
single point of failure.

For me zfs is strictly an arm's-length thing, because if Oracle wanted to 
they could easily resolve the licensing thing as they own the code, but 
they haven't, which at this point can only be deliberate, and as I result 
I simply don't touch it.  That isn't to say I don't recommend it for 
those comfortable with or simply willing to overlook the licensing 
issues, however, because zfs remains the most mature Linux option for 
many of the same feature points that btrfs has, only at a lower maturity 
level.

But while I keep zfs at personal arm's length, from what I've picked up, 
I /believe/ zfs gets around the write-hole by doing strict copy-on-write 
combined with variable-length stripes -- unlike current btrfs, a stripe 
isn't always written as widely as possible, so for instance in a 20-
device raid5-alike they're able to do a 3-device and possibly even 2-
device "stripe", which then being entirely copy-on-write, avoids the read-
modify-write cycle of modified existing data that unless mitigated 
creates the parity-raid write-hole.

Variable-length stripes is actually one of the possible longer-term 
solutions already discussed for btrfs as well, but the logging/journalling 
solution seems to be what they've decided to implement first, and there's 
other tradeoffs to it (as discussed elsewhere).  Of course because as 
I've already explained I'm interested in the 3/4-way-mirroring option 
that would be used for the journal but also available to expand the 
current 2-way-raid1 mode to additional mirroring, this is absolutely fine 
with me! =:^)

> And
> it _only_ happens when the server has a ungraceful shutdown, caused by
> poweroutage? So that mean if I running btrfs raid5/6 and I've no
> poweroutages I've no problems?

Sort-of yes?

Keep in mind that power-outage isn't the /only/ way to have an ungraceful 
shutdown, just one of the most common.  Should the kernel crash or lock 
up for some reason, common examples include video and occasionally 
network driver bugs due to the direct access to hardware and memory they 
get, that can trigger an "ungraceful shutdown" as well, altho with care 
(basically always trying ssh-ing in for a remote shutdown if possible and/
or using alt-sysrq-reisub sequences on apparent lockups) it's often 
possible to prevent those being /entirely/ ungraceful at the hardware 
level, so it's not /quite/ as bad as an abrupt power outage or perhaps 
even worse a brownout that doesn't kill writes entirely but can at least 
theoretically trigger garbage scribbling in random device blocks.

So yes, sort-of, but it'd not just power-outages.

>>  it's possible to specify data as raid5/6 and metadata as raid1

> does some have this in production?

I'm sure people do.  (As I said I'm a raid1 guy here, even 3-way-
mirroring for some things were it possible, so no parity-raid at all for 
me personally.)

On btrfs, it is in fact the multi-device default and thus quite common to 
have data and metadata as different profiles.  The multi-device default 
for metadata if not specified is raid1, with single profile data.  So if 
you just specify raid5/6 data and don't specify metadata at all, you'll 
get exactly what was mentioned, raid5/6 data as specified, raid1 metadata 
as the unspecified multi-device default.

So were I to guess I'd guess that a lot of people who weren't paying 
attention when setting up but saying they have raid5/6, actually only 
have it for data, having not specified anything for metadata, so they got 
raid1 for it.


> ZFS btw have 2 copies of metadata by
> default, maybe it would also be an option or btrfs?

It actually sounds like they do hybrid raid, then, not just pure parity-
raid, but mirroring the metadata as well.  That would be in accord with a 
couple things I'd read about zfs but hadn't quite pursued to the logical 
conclusion, and would be what btrfs as already available does with raid5/6 
data and raid1 metadata.

> in this case you think 'btrfs fi balance start -mconvert=raid1
> -dconvert=raid5 /path ' is safe at the moment?

Provided you have backups in accordance with the "if it's more valuable 
than the time/trouble/resources for the backup, it's backed up" rule, and 
on current kernels, yes.

>> That means small files and modifications to existing files, the ends of
>> large files, and much of the metadata, will be written twice, first to
>> the log, then to the final location.

> that sounds that the performance will go down? So far as I can see btrfs
> can't beat ext4 or btrfs nor zfs and then they will made it even slower?

That's the effect journaling[2] partial-stripe-writes will have, yes.

However, parity-raid /always/ has a write-performance tradeoff, well 
either that or a space/organization-tradeoff if it does less than full-
width stripes, because traditional parity-raid /already/ has the read-
modify-write problem for partial-stripe-width writes (and partial-width-
stripe-writes for non-traditional solutions such as zfs a space layout 
efficiency problem), so lower small-write performance is already a 
tradeoff you're making choosing parity-raid in the first place, and 
journaling only accentuates it a bit, as the price paid for closing the 
write hole.

The performance issue was a big part of the reason I ended up switching 
from parity-raid to raid1, back in the day on mdraid.  And it turned out 
I was /much/ happier with raid1. which had much better performance than I 
had thought it would (the mdraid raid1 scheduler is recognized for its 
high efficiency read-scheduling and for parallel-write scheduling, so 
write latency is only about the same as writes to a single device, while 
many or large reads are smart-scheduled to parallelize across all 
mirrors).

(The other part of the reason I switched back to raid1 on mdraid was 
because I had rather naively thought on parity-raid the parity would be 
cross-checked in the standard read path, giving me integrity checking as 
well.  Turns out that's not the case; parity is only used for rebuilds in 
case of device-loss and isn't checked for normal reads, a great 
disappointment.  That's actually why I'm so looking forward to btrfs 3-
and-4-way mirroring, because btrfs already has full checksumming and 
routine checking on read, for data and metadata integrity, but currently 
only has two-way-mirroring, so if you're down a device and the copy on 
the remaining device is bad, you're just out of luck, whereas 3-way-
mirroring would let a device be bad and still give me a backup if one of 
the two remaining copies ended up failing checksum verification.  4-way-
mirroring would obviously add yet another copy, but 3-way is the sweet-
spot for me.)

The performance is why mdraid recommends putting the journal on a faster 
device (or better yet mirrors, avoiding the single point of failure of a 
single journal device), ssd or nvram, for performance reasons, turning a 
slow-down into a speedup due to the write-cache.  But btrfs doesn't have 
device-purpose-specification like that built-in yet, so it's either all 
devices, or use something like bcache with an ssd as the front device.  
(The ssd used as the bcache front device can be partitioned to allow a 
single ssd to cache multiple slower backing devices.)

OTOH, as stated it's only smaller less-than-stripe-width writes that will 
be affected.  As soon as you're writing more than stripe width, as with 
large files for data or for metadata when copying whole subdir trees, 
most of it will be full-stripe-writes and thus shouldn't have to (I'm not 
sure how it's actually going to be implemented) be logged/journalled.


Meanwhile, at least one of the other alternatives, less-than-full-width-
stripes, or writing partly empty full-width-stripes, as necessary, of 
course with COW so read-modify-write is entirely avoided, will likely 
eventually be available on btrfs as well.  But they have their own 
tradeoffs, faster initially than the logged/journalled solution, but less 
efficient initial space utilization, with a clean-up balance likely 
periodically required to rewrite all the short-stripes (either less than 
full width or partially empty) to full width.  So all possibilities have 
their tradeoffs, none are a "magic" solution that entirely does away with 
problems inherent to parity-raid, without tradeoffs of /some/ sort.

But zfs is already (optionally? I don't know) using these tradeoffs, and 
on mdraid there's options, and people often aren't even aware of the 
tradeoffs they're taking on those solutions, so... I suppose when it's 
all said and done the only people aware of the issues on btrfs are likely 
going to be the highly technical and case-optimizer crowds, too.  
Everyone else will probably just use the defaults and not even be aware 
of the tradeoffs they're making by doing so, as is already the case on 
mdraid and zfs.

---
[1] As I'm no longer running either mdraid or parity-raid, I've not 
followed this extremely closely, but writing this actually spurred me to 
google the problem and see when and how mdraid fixed it.  So the links 
are from that. =:^)

[2] Journalling/journaling, one or two Ls?  The spellcheck flags both and 
last I tried googling it the answer was inconclusive.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
