Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37802 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3HYMNK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 08:13:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VDZBr-0005j4-WA
	for linux-btrfs@vger.kernel.org; Sun, 25 Aug 2013 14:13:07 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Aug 2013 14:13:07 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Aug 2013 14:13:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help interpreting RAID1 space allocation
Date: Sun, 25 Aug 2013 12:12:49 +0000 (UTC)
Message-ID: <pan$cd80e$ef762822$17e636cb$3a2b1f54@cox.net>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net> <
	093e4c7d21b5e734c86fc4bb1703a69e@lixil.net> <
	D8D710C1-2FEC-41E1-A139-522F351E0464@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 24 Aug 2013 23:18:26 -0600 as excerpted:

> On Aug 24, 2013, at 11:24 AM, Joel Johnson <mrjoel@lixil.net> wrote:
>> 
>> Similar to what Duncan described in his response, on a hot-remove
>> (without doing the proper btrfs device delete), there is no opportunity
>> for a rebalance or metadata change on the pulled drives, so I would
>> expect there to be a signature of some sort for consistency checking
>> before readding it. At least, btrfs shouldn't add the readded device
>> back as an active device when it's really still inconsistent and not
>> being used, even if it indicates the same UUID.
> 
> Question: On hot-remove, does 'mount' show the volume as degraded?
> 
> I find the degraded mount option confusing. What does it mean to use -o
> degraded when mounting a volume for which all devices are present and
> functioning?

The degraded mount option does indeed simply ALLOW mounting without all 
devices.  If all devices can be found, btrfs will still integrate them 
all, regardless of the mount option.

Looked at in that way, therefore, having the degraded option remain when 
all devices were found and integrated makes sense.  It's simply denoting 
the historical fact at that point, that the degraded option was included 
when mounting, and thus that it WOULD have mounted without all devices, 
if it couldn't find them all, regardless of whether it found and 
integrated all devices or not.

And hot-remove won't change the options used to mount, either, so 
degraded won't (or shouldn't, I don't think it does but didn't actually 
check that case personally) magically appear in the options due to the 
hot-remove.

However, I /believe/ btrfs filesystem show should display MISSING when a 
device has been hot-removed, until it's added again.  That's what I 
understand Joel to be saying, at least, and it's consistent with my 
understanding of the situation.

(I would have tested that when I did my original testing, except I didn't 
know my way around multi-device btrfs well enough to properly grok either 
the commands I really should be running or their output.  I did run the 
commands, but I had the other device still attached even tho I'd 
originally mounted degraded, so it didn't show up as missing, and I 
didn't understand the significance of what I was seeing, except to the 
extent that I knew the results I got from the separate degraded writes 
followed by a non-degraded mount were NOT what I expected, and I simply 
resolved to steer well clear of degraded mounting in the first place, if 
I could help it, and to take steps to wipe and clean-add in the event 
something happened and I really NEEDED that degraded.)

>> Based on my experience with this and Duncan's feedback, I'd like to see
>> the wiki have some warnings about dealing with multidevice filesystems,
>> especially surrounding the degraded mount option.

Well, as I got told at one point, it's a wiki, knock yourself out. =:^/

Tho... in fairness, while I intend to register and do some of these 
changes at some point, in practice, I'm far more comfortable on 
newsgroups and mailing lists than in web forums or editing wikis, so 
unfortunately I've not gotten "the properly rounded tuit" yet. =:^(

But seriously, Joel, I agree it needs done, and if you get to it before I 
do... there'll be less I need to do.  So if you have the time and 
motivation to do it, please do so! =:^)  Plus you appear to be doing a 
bit more thorough testing with it than I did, so you're arguably better 
placed to do it anyway.

> To me, degraded is an array or volume state, not up to the user to set
> as an option. So I'd like to know if the option is temporary, to more
> easily handle a particular problem for now, but the intention is to
> handle it better (differently) in the future.

Hopefully the above helped with that.  AFAIK the degraded mount-option 
will remain more or less as it is -- simply allowing the filesystem to 
start instead of error-out if it can't find all devices, but effectively 
doing nothing if it does find all devices.

Meanwhile, I'm used to running beta and at times alpha software, and what 
we have now is clearly classic alpha, not all primary features 
implemented yet, let alone all the sharp edges removed and the chrome 
polished up.  Classic beta has all the baseline features, and we are 
getting close, but still has sharp edges/bugs that can hurt if one isn't 
careful around them.  I honestly expect btrfs should be hitting that by 
end of year or certainly early next, as it really is getting close now.

What that means in context is that I expect and hope that once the last 
few primary features get added, finish up raid5/6 mode and get full N-way 
mirroring (not just the 2-way referred to as raid1 currently), possibly 
dedup, finish up send/receive (it's there but rather too buggy to be 
entirely practical at present)... AFAIK, that's about it on the primary 
features list.

Then it's beta, with the full focus turning to debugging and getting rid 
of those sharp corners, and I expect THAT is when we'll see some of these 
really bare and sharp-cornered features such as multi-device raidN get 
rounded out in userspace, with the tools actually turning into something 
reasonably usable, not the bare-bones alpha proof-of-concept userspace 
tools we have for the multi-device features at present.

> For raid1 and raid10 this seems a problem for a file system that can
> become very large. The devices have enough information to determine
> exactly how far behind temporarily kicked devices are; it seems they
> effectively have an mdraid write-intent bitmap.

With atomic tree updates not taking effect until the root node is finally 
written, and with btrfs keeping a list of the last several root nodes as 
it has actually been doing for several versions now (since 3.0 at least, 
I believe), I /believe/ it's even better than a 1-deep write-intent 
bitmap, as it's effectively an N-deep stack of such bitmaps. =:^)

The problem is, as I explained above, btrfs is still effectively alpha, 
and the tools we are using to work with it are effectively bare-bones 
proof-of-concept alpha level tools, since not all features have yet been 
fully implemented, let alone having time to flesh anything out properly.

It'll take time...

> I think it's a problem if there isn't an write-intent bitmap equivalent
> for btrfs raid1/raid10, and right now there doesn't seem to be one.

As I explained I believe btrfs has even better.  It's simply that there's 
no proper tools available to use it yet...

> A compulsory rebalance means hours or days of rebalance just because one
> drive was dropped for a short while.

I think I consider myself lucky.  One thing I learned with my years of 
playing with mdraid is how to make proper use of partitions, with only 
the ones I actually needed active and the filesystems mounted, and 
activating/mounting read-only where possible, so if a device did drop out 
for whatever reason, between the split-up mounts meaning relatively 
little actual data was affected, and the write-intent bitmaps, I was back 
online right away.

While btrfs doesn't YET expose its root-node-stack as a stack of write-
intent-bitmaps as it COULD, and I believe eventually WILL, unlike back 
when I was running mdraid and dealing with the write-intent bitmaps 
there, I'm on SSD for my btrfs filesystems today, and they're MUCH faster.

*So* much so that between the multiple relatively small partitions (fully 
independent, I don't want all my eggs in one filesystem tree basket, so 
no subvolumes, they're fully independent filesystems/partitions) and the 
fact that they're on ssd...

Here, a full filesystem balance typically takes on the order of seconds 
to a minute, depending on the filesystem/partition.  That's rewriting ALL 
data and metadata on the filesystem!

So while I understand the concept of a full multi-terabyte filesystem 
rebalance taking on the order of days, the contrast between that concept, 
and the reality of a few gigabytes of data in its own dedicated 
filesystem on ssd rebalancing in a few tens of seconds here...

Makes a world of difference!

Let's just say I'm glad it isn't the other way around! =:^)

>> This then drives the question, how does one check the degraded state of
>> a filesystem if not the mount flag. I (quite likely with an md-raid
>> bias) expected to use the 'filesystem show' output, listed the devices
>> as well as a status flag of fully-consistent or rebalance in progress.
>> If that's not the correct or intended location, then provide
>> documentation on how to properly check the consistency state and
>> degraded state of a filesystem.
> 
> Yeah I think something functionally equivalent to a combination of mdadm
> -D and -E. mdadm distinguishes between array status/metadata vs member
> device status/metadata with those two commands.

While the bare-bones-alpha tools-state explains the current situation, 
never-the-less I believe these sorts of conversations are important, as 
they will very possibly help drive the shaping of the tools as they flesh 
out.

And yes, I do hope that the btrfs tools eventually get something 
comparable to mdadm -D and -E.  But I think it's equally important to 
realize that mdadm is actually a second-generation solution, that what 
we're looking at in mdadm is the end product of several years of it 
maturing plus the raid-tools solution before that, and that even then, 
those were already patterned after commercial and other raid product 
administration tools from before that.

Meanwhile, while there's some analogies between btrfs and md, and others 
between btrfs and zfs, really, this whole field of having filesystems do 
all that btrfs is attempting to do is relatively new ground, and we 
cannot and should not expect to directly compare the state of btrfs tools 
even after it's first declared stable, with the state of either mdadm or 
zfs tools, today.  It'll take some time to get there.

But get there I believe it will eventually do. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

