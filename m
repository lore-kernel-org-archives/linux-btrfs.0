Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40116 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdLJAjn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Dec 2017 19:39:43 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eNpeX-000383-7s
        for linux-btrfs@vger.kernel.org; Sun, 10 Dec 2017 01:39:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Odd behaviour of replace -- unknown resulting state
Date: Sun, 10 Dec 2017 00:39:27 +0000 (UTC)
Message-ID: <pan$d1034$1977a365$dc878ff2$2adcb978@cox.net>
References: <20171209174348.GA26606@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sat, 09 Dec 2017 17:43:48 +0000 as excerpted:

> This is on 4.10, so there may have been fixes made to this since
> then. If so, apologies for the noise.
> 
>    I had a filesystem on 6 devices with a badly failing drive in it
> (/dev/sdi). I replaced the drive with a new one:
> 
> # btrfs replace start /dev/sdi /dev/sdj /media/video
> 
>    Once it had finished(*), I resized the device from 6 TB to 8 TB:
> 
> # btrfs fi resize 2:max /media/video
> 
>    I also removed another, smaller, device:
> 
> # btrfs dev del 7 /media/video
> 
>    Following this, btrfs fi show was reporting the correct device
> size, but still the same device node in the filesystem:
> 
> Label: 'amelia'  uuid: f7409f7d-bea2-4818-b937-9e45d754b5f1
>        Total devices 5 FS bytes used 9.15TiB
>        devid    2 size 7.28TiB used 6.44TiB path /dev/sdi2
>        devid    3 size 3.63TiB used 3.46TiB path /dev/sde2
>        devid    4 size 3.63TiB used 3.45TiB path /dev/sdd2
>        devid    5 size 1.81TiB used 1.65TiB path /dev/sdh2
>        devid    6 size 3.63TiB used 3.43TiB path /dev/sdc2
> 
>    Note that device 2 definitely isn't /dev/sdi2, because /dev/sdi2
> was on a 6 TB device, not an 8 TB device.
> 
>    Finally, I physically removed the two deleted devices from the
> machine. The second device came out fine, but the first (/dev/sdi) has
> now resulted in this from btrfs fi show:
> 
> Label: 'amelia'  uuid: f7409f7d-bea2-4818-b937-9e45d754b5f1
>        Total devices 5 FS bytes used 9.15TiB
>        devid    3 size 3.63TiB used 3.46TiB path /dev/sde2
>        devid    4 size 3.63TiB used 3.45TiB path /dev/sdd2
>        devid    5 size 1.81TiB used 1.65TiB path /dev/sdh2
>        devid    6 size 3.63TiB used 3.43TiB path /dev/sdc2
>        *** Some devices missing
> 
>    So, what's the *actual* current state of this filesystem? It's not
> throwing write errors in the kernel logs from having a missing device,
> so it seems like it's probably OK. However, the FS's idea of which
> devices it's got seems to be confused.
> 
>    I suspect that if I reboot, it'll all be fine, but I'd be happier
> if it hadn't got into this state in the first place.

As I believe you know, I'm not a coder, and there's a limit to the
technical detail level I'm comfortable with.  As such, I do sometimes
come to the wrong conclusions...

That said, as I understand things, this sort of device confusion is
normal for btrfs at this time, because the kernel btrfs code simply
doesn't have a proper concept of real-time (physical or blockdev layer
below btrfs) device disappearance/removal.

Adding the ability for btrfs to properly deal with device removal is
part of the patch set that one of the devs (Anand Jain, IIRC) is
working on as a prerequisite to hot-spare.  I've seen quite some
discussion on the device-tracking subset recently and it's my
impression that it's headed for mainline right now, tho I haven't
tracked it closely enough to be sure if it's in for 4.15 or being
staged for 4.16.

Until then, the btrfs fi show and similar output can be /expected/
to still show old devices at times until a reboot, even if what's
actually on-dev has been correctly updated.

Thus, I too expect that after a reboot it should actually show up
correctly, tho of course I'd expect people to have backups updated
before they go doing anything like btrfs device remove, etc, so
if it does /not/ come back after a reboot, no problem, just go to
the backup.

>    Is this bug fixed in later versions of the kernel? Can anyone think
> of any issues I might have if I leave it in this state for a while?
> Likewise, any issues I might have from a reboot? (Probably into 4.14)
> 
>    Hugo.
> 
> (*) as an aside, it was reporting over 300% complete when it finally
>     completed. Not sure if that's been fixed since 4.10, either.

IIRC, this one *has* been fixed recently.  At least, I definitely
remember multi-hundred-percent complete reports a few kernel-cycles
ago, and believed it to be a known bug with a known-to-fix patch just
waiting for the normal development cycle timing to get it out there.
And since that /was/ several kernel cycles ago, probably about the
4.10 you mention, actually, I'd be rather surprised to see it still
being an issue with current.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

