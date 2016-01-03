Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50111 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbcACNsa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Jan 2016 08:48:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aFj1G-0005tI-Al
	for linux-btrfs@vger.kernel.org; Sun, 03 Jan 2016 14:48:26 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 14:48:26 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 14:48:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: evidence of persistent state, despite device disconnects
Date: Sun, 3 Jan 2016 13:48:20 +0000 (UTC)
Message-ID: <pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
References: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 02 Jan 2016 12:22:07 -0700 as excerpted:

> OK, I basically do not trust the f'n kernel anymore. I'm having to
> reboot in order to get to a (reasonably) deterministic state. Merely
> disconnecting devices doesn't  make all aspects of that device and its
> filesystem, vanish.

We already knew that btrfs itself doesn't track device state very well, 
and that a reboot or for those with btrfs as a module, module unload/
reload, was needed to fully clear state.  Are you suggesting it's more 
than that?

> I think this persistence might be causing some Btrfs corruptions that
> don't seem to make any sense. Here is one example that I've kept track
> of every step of the way:
> 
> I have a Btrfs raid1 that fails to mount rw,degraded:

[Shortening the UUIDs for easier 80-column posting.  I deleted them in 
the first attempt, but decided they were useful here, as UUIDs are about 
the only way to track what's what as you will see, in the absence of 
btrfs fi show, with mountpoints jumping between brick and brick1, with 
references to devids that we don't know anything about due to that lack 
of fi show output, etc.]

> [  174.520303] BTRFS info (device sdc): allowing degraded mounts
> [  174.520421] BTRFS info (device sdc): disk space caching is enabled
> [  174.520527] BTRFS: has skinny extents
> [  174.528060] BTRFS warning (device sdc):
> devid 1 uuid [...]-828d1766719c is missing
> [  177.924127] BTRFS: missing devices(1) exceeds the limit(0),
> writeable mount is not allowed
> [  177.950761] BTRFS: open_ctree failed

That's the -828 UUID...

OK, looks like your "raid1" must have some single or raid0 chunks, which 
have a missing device limit of 0.

BTW, what kernel?  You don't say.

Meanwhile, I lost track of whether the patch set to do per-chunk 
evaluation of whether it's all there, thereby allowing degraded,rw 
mounting of multi-device filesystems with single chunks only on available 
devices, ever made it in, and if so, in which kernel.

I /think/ they were too late to make it into 4.3, but should have made it 
into 4.4.  But unfortunately, neither the 4.3 or 4.4 kernel btrfs changes 
are up on the wiki yet, and to confirm it in git I'd have to go back and 
figure out what those patches were named, which I'm too lazy to do ATM.

But of course without a reported kernel here, knowing whether they made 
it in and for what kernel wouldn't help, despite that information 
apparently being apropos to the situation.

> When mounted -o ro,degraded
> 
> [root@f23s ~]# btrfs fi df /mnt/brick2
> Data, RAID1: total=502.00GiB, used=499.69GiB
> Data, single: total=1.00GiB, used=2.00MiB
> System, RAID1: total=32.00MiB, used=80.00KiB
> System, single: total=32.00MiB, used=32.00KiB
> Metadata, RAID1: total=2.00GiB, used=1008.22MiB
> Metadata, single: total=1.00GiB, used=0.00B
> GlobalReserve, single: total=352.00MiB, used=0.00B
> 
> What the F?

OK, there we have the btrfs fi df.  But there's no btrfs fi show.  And 
you posted the dmesg from the mount, but didn't give the commandline, so 
we have nothing connecting the btrfs fi df /mnt/brick2 (note the brick2), 
to the above dmesg output.  No mount commandline, no btrfs fi show, 
nothing else, at this point.

> Because the last time it was normal/non-degraded and mounted, the only
> chunks were raid1 chunks. Somehow, single chunks have been added and
> used without any kernel messages to warn the user they no longer have a
> raid1, in effect.
> 
> What *exactly* happened since this was an intact raid1 only, 2 device
> volume?
> 
> 1. umount /mnt/brick           ##cleanly umounted

OK, the above fi df was for /mnt/brick2.  Here you're umounting
/mnt/brick.  **NOT** the same mountpoint.  So **NOT** cleanly umounted, 
as that's an entirely different filesystem.  Unless you did a copy/pasto 
and you actually umounted brick2.

But that's not what it says...

> 2. ## USB cables from the drives disconnected
> 3. lsblk and blkid see neither of them
> 4. devid1 is reconnected

Wait... devid1?  For brick or brick2?  Either way, we have no idea what 
devid1 is, because we don't have a btrfs fi show.


Honestly, CMurphy, your posts are /normally/ much more coherent than 
this.  Joking, but serious, are you still recovering from your new year's 
partying?  There's too many missing pieces and inconsistencies here.  
It's not like your normal posts.

> 5. devid1 is issued ATA security-erase-enhanced command via hdparm
> 6. devid1 is physically disconnected
> 7. oldidevid1 is luksformatted and opened

Oldidevid1?  Is that old devid1?  You said it was physically 
disconnected.  Nothing about reconnection.  So was it reconnected and 
lukesformated, or is this a different device, presumably from some much 
older btrfs devid1?

> 8. devid2 is connected
> 9. [root@f23s ~]# lsblk -f
> NAME   FSTYPE      LABEL   UUID               MOUNTPOINT
> sdb    crypto_LUKS         [...]-a0ffe83ced7e
> └─sdb
> sdc    btrfs       second  [...]-7fc93285c29c /mnt/brick2
> 
> [root@f23s ~]# btrfs fi show /mnt/brick2
> Label: 'second'  uuid: [...]-7fc93285c29c
>     Total devices 2 FS bytes used 500.68GiB
>     devid    1 size 697.64GiB used 504.03GiB path /dev/sdb
>     devid    2 size 697.64GiB used 504.03GiB path /dev/sdc

UUIDs:  No -828 UUID to match the dmesg output above.  The -a0ff UUID is 
new, apparently from the luksformatting in #7, and the -7fc UUID matches 
between the lsblk and (NOW we get it!!) btrfs fi show, but isn't the -828 
UUID in the dmesg above, so that dmesg segment is presumably for some 
other btrfs.  Note that with all the device disconnection and reconnection 
going on, the /dev/sdc here wouldn't be expected to be the same device as 
the /dev/sdc in the dmesg above, so mismatching UUIDs despite matching 
/dev/sdc device-paths isn't at all unexpected.

Which would seem to imply that while we have a btrfs fi show now, it's 
not the btrfs in the dmesg above, because the UUIDs don't match.  Either 
that or the UUID in the dmesg isn't the filesystem UUID but rather the 
device UUID.  But I can't verify that right now as the dmesg output for a 
whole device doesn't list UUIDs, only the nominal device node (nominal 
being the one used to mount, on multi-device btrfs).  Either way, the UUID 
in the dmesg from the btrfs mount error doesn't match any other UUID 
we've seen, yet.

Meanwhile, both these show a mounted btrfs on /mnt/brick2, but there's no 
mount in the sequence above.  Based on the sequence above, nothing should 
be mounted at /mnt/brick2.

But at this point there's enough odd and nonsensical about what we know 
and don't know from the post so far that this really isn't surprising...

> WTF?! This shouldn't be possible. devid1 is *completely* obliterated.
> It was securely erased. It has been luks formatted. It has been
> disconnected multiple times (as has devid2). And yet Btrfs sees this as
> an intact pair? That's just complete crap. *AND*

Why would you expect it to make any sense?  The rest of the post doesn't.

> It let's me mount it! Not degraded! No error messages!

Oh, here we're talking about a mount!  But as I said, no mount in the 
sequence!  At this point it's just entertainment.  I'm not even trying to 
make sense of it any longer!

Meanwhile, we have #9 above, and #11, below, but no #10.  I guess the 
btrfs fi show is supposed to be #10.  Or maybe #9 was supposed to be #10 
and include both the lsblk and the btrfs fi show, and #9 was supposed to 
be the mount we're missing.  Either way, more to not make any sense in a 
post that already made no sense. <shrug>

> 11. umount /mnt/brick2
> 12. Reboot
> 13. btrfs fi show
> warning, device 1 is missing
> warning devid 1 not found already
> Label: 'second'  uuid: [...]-7fc93285c29c
>     Total devices 2 FS bytes used 500.68GiB
>     devid    2 size 697.64GiB used 506.06GiB path /dev/sdc
>     *** Some devices missing

OK, the -7fc UUID that was previously mounted on /mnt/brick2...

And this is a btrfs fi show, without path, so it should list all btrfs in 
the system, mounted or not.  No others shown.  Whatever happened to the 
/mnt/brick filesystem umounted in #1, or the -828 UUID the dmesg at the 
top complaining about a missing device was complaining about?  No clue.

But there was no btrfs device scan done before that btrfs fi show.  Maybe 
that's why.  Or maybe it's because the other btrfs entries were manually 
edited out here.

> 14. # mount -o degraded, /dev/sdc /mnt/brick2
> mount: wrong fs type, bad option, bad superblock on /dev/sdc
> 
> and the trace at the very top with bogus missing devices(1) exceeds the
> limit(0), writeable mount is not allowed.
> 
> So during that not degraded mount of the file system where it saw a
> ghost of devid1, it wrote single chunks to devid2. And now devid2 can
> only ever be mounted read only. It's impossible to fix it, because I
> can't add devices when ro mounted.

The sequence still doesn't show where you actually did that mount that 
actually worked, only the one in #14 that didn't work, or what command 
you might have used.

And the umount in #1 was apparently for an entirely different /mnt/brick, 
while the lsblk and btrfs fi show in #9 clearly shows /mnt/brick2, which 
if the sequence above is to be believed, remained mounted the entire 
time, including while you unplugged its devices, plugged them back in and 
ATA secure-erased one, then luksformatted it (tho you don't record the 
actual commands used so we don't know for sure you got the devices 
correct, particularly in light of your already mixing up brick and 
brick2), all while the btrfs on brick2 is still supposedly mounted, with 
a btrfs that we already know doesn't track device disappearance 
particularly well.

In which case, I can see the still mounted btrfs trying to write raid1, 
and failing that, creating single chunks on the devices it could still 
see, to try to write to.

But that's very much not the only thing mixed up here!

Meanwhile, if your kernel is one without the per-chunk patches mentioned 
above, it could well be that the single chunks listed in that btrfs fi df 
are indeed there, intact, and that it didn't try to write to the other 
device at all.  In fact, the presence of those single-mode chunks, 
indicate that it indeed *did* sense the missing other device at some 
point, and wrote single chunks instead of raid1 chunks as a result.  With 
a kernel with those per-chunk tracking patches, it might well mount 
degraded,rw, and you may well have everything there, despite the entirely 
mixed up series of events above that make absolutely no sense as reported.

> Does anyone have any idea what tool to use to explain how the devid1
> /dev/sdb, which has been securely erased, luks formatted,
> disconnected, reconnected, *STILL* results in Btrfs thinking it's a
> valid drive and allowing a non-degraded mount until there's a reboot?
> That's really scary.
> 
> It's like the btrfs kernel code isn't refreshing its own fs or dev
> states when other parts of the kernel know it's gone. Maybe a 'btrfs dev
> scan' would have cleared this up, but I shouldn't have to do that to
> refresh Btrfs's state anytime I disconnect and connect devices just to
> make sure it doesn't sabotage the devices by surreptitiously adding
> single chunks to one of the drives!

Based on the evidence, I'd guess that you actually mounted it degraded,rw, 
somewhere along the line, and it wrote those single-mode chunks at that 
point.  Further, whatever kernel you're running, I'd guess it doesn't 
have the fairly recent patches checking data/metadata availability per-
chunk, and thus is exhibiting the known pre-patch behavior of refusing a 
second degraded,rw mount when the first put some single chunks on the 
existing drive, despite the contents of those chunks and thus the entire 
filesystem, still being available.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

