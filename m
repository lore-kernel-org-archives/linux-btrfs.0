Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47667 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdDAXbe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 19:31:34 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cuSUJ-00018B-KY
        for linux-btrfs@vger.kernel.org; Sun, 02 Apr 2017 01:31:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: force btrfs to release underlying block device(s)
Date: Sat, 1 Apr 2017 23:31:08 +0000 (UTC)
Message-ID: <pan$1f835$afcb2bc1$54acc19$51819f9d@cox.net>
References: <20170401005819.46dd9442@crass-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Glenn Washburn posted on Sat, 01 Apr 2017 00:58:19 -0500 as excerpted:

> I've run into a frustrating problem with a btrfs volume just now.  I
> have a USB drive which has many partitions, two of which are luks
> encrypted, which can be unlocked as a single, multi-device btrfs volume.
>  For some reason the drive logically disconnected at the USB protocol
> level, but not physically.  Then it reconnected.  This caused the mount
> point to be removed at the vfs layer, however I could not close the luks
> devices.
> 
> When looking in /sys/fs/btrfs, I see a directory with the UUID of the
> offending volume, which shows the luks devices under the devices
> directory.  So I presume the btrfs module is still holding references to
> the block devices, not allowing them to be closed.  I know I can do a
> "dmsetup remove --force" to force closing the luks devices, but I doubt
> that will cause the btrfs module to release the offending block devices.
>  So if I do that and then open the luks devices again and try to remount
> the btrfs volume, I'm guessing insanity will ensue.
> 
> I can't unload/reload the btrfs module because the root fs among others
> are using it.  Obviously, I can reboot, but that's a windows solution.
> Anyone have a solution to this issue?  Is anyone looking into ways to
> prevent this from happening?  I think this situation should be trivial
> to reproduce.

Short answer: This is yet another known point supporting "btrfs is still 
stabilizing and under heavy development, not fully stable and mature."

Longer...

This is a known issue on current btrfs.  ATM, btrfs has no notion of 
device disappearance -- it keeps trying to write updates to physically or 
lower-level-logically missing devices "forever", or at least until btrfs 
triggers an emergency read-only remount on the filesystem, but that 
doesn't free the device or dirty memory.

There are patches available as part of the global hot-spare patchset that 
give btrfs the notion of a dead device, so the hot-spare stuff can 
trigger auto-replacement with a hot-spare, but that's a long-term-merge-
target patchset that is currently back-burnered, with (AFAIK) no mainline 
merge target kernel in sight.  Meanwhile, from list posts it seems that 
patchset has bit-rotted and no longer applies as-is to current kernels.

So obviously the problem is known and will eventually be addressed, but 
just when is anyone's guess.  It's quite unlikely to be in the next 2-3 
kernel series, however, and could be several years out, altho the fact 
that someone had enough interest in it to create the patchset in the 
first place means it's reasonably likely to be seen within the 1-5 year 
timeframe, unlike wishlist items that don't even have RFC-level patches 
yet.

Tho another part of that patchset, the per-chunk availability check for 
degraded filesystems that allows writable mount of multi-device 
filesystems with single chunks, etc, as long as all chunks are available, 
has seen renewed activity recently as the problem it addresses, formerly 
two-device raid1 filesystems going read-only after one degraded-writable 
mount, has become an increasingly frequently list-reported problem.  That 
smaller patchset has I believe now been review and is I believe now in 
btrfs-next, scheduled for merge in 4.12.

That will definitely make the global-hot-spare patchset smaller and 
easier to (eventually) merge, as this part will have already been merged 
and thus no longer needs to be part of the global-hot-spare patchset.  
Conceivably, the device-tracking patches could similarly be broken out 
into a smaller patchset of their own, but without anything actually 
actively using them for anything, testing would be more difficult, and 
it's unclear they'd be separately merged.

But provided the per-chunk-availability check is merged in 3.12, it would 
move up my gut-feeling prediction on the global-hot-spare patchset it was 
part of a bit, to say 9 months to 3.5 years, from the otherwise 1-5 years 
prediction.

Of course as we've seen with the raid56 functionality, mainline merge 
doesn't necessarily mean it'll actually be usably stable any time soon.  
Most new features take at least a couple kernel cycles to stabilize after 
mainline merge, and a few, like raid56, take far longer and may never 
stabilize at least in anything close to original merge form.

IOW, patience is a virtue, particularly if you're not a kernel-level dev 
and thus can't really do much to help it along yourself, other than 
working with the devs to test once it's on the active merge schedule and 
after merge, to hopefully bring faster usable stability.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

