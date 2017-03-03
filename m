Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60796 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbdCCFdl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 00:33:41 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cje3Z-0004B5-Kp
        for linux-btrfs@vger.kernel.org; Fri, 03 Mar 2017 04:39:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
Date: Fri, 3 Mar 2017 03:38:56 +0000 (UTC)
Message-ID: <pan$684e5$d327dc6a$2427124b$84079405@cox.net>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
        <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
        <22712.48434.400550.346157@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter Grandi posted on Fri, 03 Mar 2017 00:47:46 +0000 as excerpted:

>> [ ... ] Meanwhile, the problem as I understand it is that at the first
>> raid1 degraded writable mount, no single-mode chunks exist, but without
>> the second device, they are created.  [ ... ]
> 
> That does not make any sense, unless there is a fundamental mistake in
> the design of the 'raid1' profile, which this and other situations make
> me think is a possibility: that the category of "mirrored" 'raid1' chunk
> does not exist in the Btrfs chunk manager. That is, a chunk is either
> 'raid1' if it has a mirror, or if has no mirror it must be 'single'.
> 
> If a member device of a 'raid1' profile multidevice volume disappears
> there will be "unmirrored" 'raid1' profile chunks and some code path
> must recognize them as such, but the logic of the code does not allow
> their creation. Question: how does the code know that a specific 'raid1'
> chunk is mirrored or not? The chunk must have a link (member, offset) to
> its mirror, do they?

The problem at the surface level is, raid1 chunks MUST be created with 
two copies, one each on two different devices.  It is (currently) not 
allowed to create only a single copy of a raid1 chunk, and the two copies 
must be on different devices, so once you have only a single device, 
raid1 chunks cannot be created.

Which presents a problem when you're trying to recover, needing writable 
in ordered to be able to do a device replace or add/remove (with the 
remove triggering a balance), because btrfs is COW, so any changes get 
written to new locations, which requires chunked space that might not be 
available in the currently allocated chunks.

To work around that, they allowed the chunk allocator to fallback to 
single mode when it couldn't create raid1.

Which is fine as long as the recovery is completed in the same mount.  
But if you unmount or crash and try to remount to complete the job after 
those single-mode chunks have been created, oops!  Single mode chunks on 
a multi-device filesystem with a device missing, and the logic currently 
isn't sophisticated enough to realize that all the chunks are actually 
accounted for, so it forces read-only mounting to prevent further damage.

Which means you can copy off the files to a different filesystem as 
they're still all available, including any written in single-mode, but 
you can't fix the degraded filesystem any longer, as that requires a 
writable mount you're not going to be able to get, at least not with 
mainline.


At a lower level, the problem is that for raid1 (and I think raid10 as 
well tho I'm not sure on it), they made a mistake in the implementation.

For raid56, the minimum allowed writable devices is lower than the 
minimum number of devices for undegraded write, by the number of parity 
devices (so raid5 will allow two devices for undegraded write, 1 parity, 
one data, but one device for degraded write, raid6 will allow three 
devices for undegraded write, one data, two parity, or again, one device 
for degraded write).

But for raid1, both the degraded write minimum and the undegraded write 
minimum are set to *two* devices, an implementation error since the 
degraded write minimum should arguably be one device, without a mirror.

So the degrade to single-mode is a workaround for the real problem, not 
allowing degraded raid1 write (that is, chunk creation).

And all this is known and has been discussed right here on this list by 
the devs, but nobody has actually bothered to properly fix it, either by 
correctly setting the degraded raid1 write minimum to a single device, or 
even by working around the single-mode workaround, by correctly checking 
each chunk and allowing writable mount if all are accounted for, even if 
there's a missing device.

Or rather, the workaround for the incomplete workaround has had a patch 
submitted, but it got stuck in that long-running project and has been in 
limbo every since, and now I guess the patch has gone stale and doesn't 
even properly apply any longer.


All of which is yet more demonstration of the fact that is stated time 
and again on this list, that btrfs should be considered stabilizing, but 
still under heavy development and not yet fully stable, and backups 
should be kept updated and at-hand for any data you value higher than the 
bother and resources necessary to make those backups.

Because if there's backups updated and at hand, then what happens to the 
working copy doesn't matter, and in this particular case, even if the 
backups aren't fully current, the fact that they're available means 
there's space available to update them from the working copy should it go 
into readonly mode as well, which means recovery from the read-only 
formerly working copy is no big deal.

Either that, or by definition, the data wasn't of enough value to have 
backups when storing it on a widely known to be still stabilizing and 
under heavy development filesystem, where those backups are strongly 
recommended for any data of value, so /losing/ that data, by definition 
of failure to have that backup, can't be that big a deal either.  If 
actions, or failure to complete actions, speak louder than words, well, 
that's the way it is.

> What makes me think that "unmirrored" 'raid1' profile chunks are "not a
> thing" is that it is impossible to remove explicitly a member device
> from a 'raid1' profile volume: first one has to 'convert' to 'single',
> and then  the 'remove' copies back to the remaining devices the 'single'
> chunks that are on the explicitly 'remove'd device. Which to me seems
> absurd.

A device can indeed be removed from a raid1 without converting to single 
first... as long as that raid1 had more than two devices before, and 
there's enough space on the remaining two-plus devices to put at least 
one copy each on two separate devices.

Of course if there's only two devices in the raid1 to begin with, then 
yes, you can't remove one of the two devices while it's still raid1.  And 
of course if there's not enough room on the remaining two-plus devices 
for what was on the device being removed, likewise.  But you didn't 
mention either one of those conditions.

> Going further in my speculation, I suspect that at the core of the Btrfs
> multidevice design there is a persistent "confusion" (to use en
> euphemism) between volumes having a profile, and merely chunks have a
> profile.

Well, in btrfs, it's always chunks having the profile.  But there is 
indeed a confusion, as explained above, it's just not quite the one you 
described.

> My additional guess that the original design concept had multidevice
> volumes to be merely containers for chunks of whichever mixed profiles,
> so a subvolume could have 'raid1' profile metadata and 'raid0' profile
> data, and another could have 'raid10' profile metadata and data, but
> since handling this turned out to be too hard, this was compromised into
> volumes having all metadata chunks to have the same profile and all data
> of the same profile, which requires special-case handling of corner
> cases, like volumes being converted or missing member devices.
> 
> So in the case of 'raid1', a volume with say a 'raid1' data profile
> should have all-'raid1' and fully mirrored profile chunks, and the lack
> of a member devices fails that aim in two ways.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

