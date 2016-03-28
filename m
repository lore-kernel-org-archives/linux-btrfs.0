Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24397 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbcC1Ofi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 10:35:38 -0400
From: "James Johnston" <johnstonj.public@codenest.com>
To: "'Duncan'" <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <001b01d188ac$16740630$435c1290$@codenest.com> <pan$284e3$6ee9615a$919b0339$15e3af27@cox.net>
In-Reply-To: <pan$284e3$6ee9615a$919b0339$15e3af27@cox.net>
Subject: RE: Compression causes kernel crashes if there are I/O or checksum errors (was: RE: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing device in RAID-1)
Date: Mon, 28 Mar 2016 14:34:14 -0000
Message-ID: <003801d188fe$e8c9b920$ba5d2b60$@codenest.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for the corroborating report - it does sound to me like you ran into the
same problem I've found.  (I don't suppose you ever captured any of the
crashes?  If they assert on the same thing as me then it's even stronger
evidence.)

> The failure mode of this particular ssd was premature failure of more and
> more sectors, about 3 MiB worth over several months based on the raw
> count of reallocated sectors in smartctl -A, but using scrub to rewrite
> them from the good device would normally work, forcing the firmware to
> remap that sector to one of the spares as scrub corrected the problem.

I wonder what the risk of a CRC collision was in your situation?

Certainly my test of "dd if=/dev/zero of=/dev/sdb" was very abusive, and I
wonder if the result after scrubbing is trustworthy, or if there was some
collisions.  But I wasn't checking to see if data coming out the other end was
OK - I was just trying to see if the kernel crashes or not (e.g. a USB stick
holding a bad btrfs file system should not crash a system).

> But /home (on an entirely separate filesystem, but a filesystem still on
> a pair of partitions, one on each of the same two ssds) would often have
> more, and because I have a particular program that I start with my X and
> KDE session that reads a bunch of files into cache as it starts up, I had
> a systemd service configured to start at boot and cat all the files in
> that particular directory to /dev/null, thus caching them so when I later
> started X and KDE (I don't run a *DM and thus login at the text CLI and
> startx, with a kde session, from the CLI) and thus this program, all the
> files it reads would already be in cache.
>
> <snip> If that service was allowed to run, it would read in all
> those files and the resulting errors would often crash the kernel.

This sounds oddly familiar to how I made it crash. :)

> So I quickly learned that if I powered up and the kernel crashed at that
> point, I could reboot with the emergency kernel parameter, which would
> tell systemd to give me a maintenance-mode root login prompt after doing
> its normal mounts but before starting the normal post-mount services, and
> I could run scrub from there.  That would normally repair things without
> triggering the crash, and when I had run scrub repeatedly if necessary to
> correct any unverified errors in the first runs, I could then exit
> emergency mode and let systemd start the normal services, including the
> service that read all these files off the now freshly scrubbed
> filesystem, without further issues.

That is one thing I did not test.  I only ever scrubbed after first doing the
"cat all files to null" test.  So in the case of compression, I never got that
far.  Probably someone should test the scrubbing more thoroughly (i.e. with
that abusive "dd" test I did) just to be sure that it is stable to confirm your
observations, and that the problem is only limited to ordinary file I/O on the
file system.

> And apparently the devs don't test the
> someone less common combination of both compression and high numbers of
> raid1 correctable checksum errors, or they would have probably detected
> and fixed the problem from that.

Well, I've only tested with RAID-1.  I don't know if:

1.  The problem occurs with other RAID levels like RAID-10, RAID5/6.

2.  The kernel crashes in non-duplicated levels.  In these cases, data loss is
    inevitable since the data is missing, but these losses should be handled
    cleanly, and not by crashing the kernel.  For example:

    a.  Checksum errors in RAID-0.
    b.  Checksum errors on a single hard drive (not multiple device array).

I guess more testing is needed, but I don't have time to do this more
exhaustive testing right now, especially for these other RAID levels I'm not
planning to use (as I'm doing this in my limited free time).  (For now, I can
just turn off compression & move on.)

Do any devs do regular regression testing for these sorts of edge cases once
they come up? (i.e. this problem won't come back, will it?)

> So thanks for the additional tests and narrowing it down to the
> compression on raid1 with many checksum errors case.  Now that you've
> found out how the problem can be replicated, I'd guess we'll have a fix
> patch in relatively short order. =:^)

Hopefully!  Like I said, it might not be limited to RAID-1 though.  I only
tested RAID-1.

> That said, based on my own experience, I don't consider the problem dire
> enough to switch off compression on my btrfs raid1s here.  After all, I
> both figured out how to live with the problem on my failing ssd before I
> knew all this detail, and have eliminated the symptoms for the time being
> at least, as the devices I'm using now are currently reliable enough that
> I don't have to deal with this issue.
> 
> And in the even that I do encounter the problem again, in severe enough
> form that I can't even get a successful scrub in to fix it, possibly due
> to catastrophic failure of a device, I should still be able to simply
> remove that device and use degraded,ro mounts of the remaining device to
> get access to the data in ordered to copy it to a replacement filesystem.

That sounds like it would work.  Assuming this bug doesn't eat data in the
process.  I have not tried scrubbing after encountering this bug.  The remaining
"good" device in the array ought to still be ok.  But I have not tested.  You
might want to test that.

The most severe form might be if the drive drops off the SATA bus, which from
what I read is not an uncommon failure mode.  In that case, you're probably
guaranteed to encounter this in short order and the system is going to go down.

I did at one point awhile back test that I could boot the system degraded after
it went down from hot-removing a drive.  This was ultimately successful (after
manually tweaking the boot process in grub/initramfs: unrelated issues), but I
don't recall scrubbing it afterwards.

Best regards,

James Johnston


