Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:36306 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaEUKfH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 06:35:07 -0400
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20140521103506.DDYL30009.eastrmfepo101.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Wed, 21 May 2014 06:35:06 -0400
Date: Wed, 21 May 2014 03:35:05 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: problem with degraded boot and systemd
Message-ID: <20140521033505.7d9e7aab@ws>
In-Reply-To: <4QrS1o00b1EMSLa01QrT4N>
References: <45D5C607-ED9D-49BB-BA60-CA2B0E94223D@colorremedies.com>
	<537BD078.7070504@libero.it>
	<20140520222609.GD1756@carfax.org.uk>
	<pan$6f6ec$5ba926ea$9860d25c$5d86cd20@cox.net>
	<4QrS1o00b1EMSLa01QrT4N>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 20 May 2014 18:51:26 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> 
> On May 20, 2014, at 6:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> > 
> > 
> > I'd actually argue that's functioning as it should, since I see
> > forced manual intervention in ordered to mount degraded as a
> > FEATURE, NOT A BUG.
> 
> Manual intervention is OK for now, when it takes the form of dropping
> to a dracut shell, and only requires the user to pass mount -o
> degraded. To mount degraded automatically is worse because within a
> notification API for user space, it will lead users to make bad
> choices resulting in data loss.
> 
> But the needed sequence is fairly burdensome: force shutdown, boot
> again, use rd.break=premount, then use mount -o degraded, and then
> exit a couple of times.

I haven't had the rootfs fail to mount due to that, but every time it
has failed for other reasons[2], I've been dropped to an emergency shell
prompt, from which I could run the mount manually, or do whatever else
I needed to do.  No force shutdown, boot again...  Just do the manual
mount or whatever, exit, and let the boot process continue from where
it errored out and dropped to the emergency shell.

But now that I think about it, I believe that automatic dropping to an
emergency shell when something goes wrong is a dracut option, that I
must have enabled by default.  I can't imagine why anyone would want it
off, thus forcing the reboot and manually adding the rd.break=whatever,
but apparently some folks do, so it's an option.  And I guess if you're
having to do the reboot and add the rd.break manually, you must not
have that option on when you do your dracut initr* builds.

> > [1] dracut: I use it here on gentoo as well, because my rootfs is a
> > multi-device btrfs and a kernel rootflags=device= line won't parse
> > correctly, apparently due to splitting at the wrong =, so I must
> > use an initr* despite my preference for a direct initr*-less boot,
> > and I use dracut to generate it.
> 
> rootflags doesn't take a device argument, it only applies to the
> volume to be mounted at /sysroot, so only one = is needed.

You misunderstand.  To mount a multi-device btrfs, one of two things
must happen to let the kernel know about all the devices.

A) btrfs device scan.

That's userspace, so for a multi-device btrfs
rootfs, it requires an initr* with the btrfs command and something to
trigger it (with dracut it's a udev rule that triggers the btrfs device
scan), before the mount is attempted.

B) btrfs has the device= mount option.

This can be given several times, once for each device in the
multi-device filesystem.

Under normal conditions, the rootflags= kernel commandline option could
thus be used to pass appropriate device= options to be used to mount
the rootfs, thus avoiding the need for an initr* with btrfs device scan
or the device= options passed to a userspace mount.

But trying rootflags=device=/dev/sda5,device=/dev/sdb5,... doesn't
work and the kernel will not mount the filesystem.

But rootflags=degraded works, but then activates the filesystem with
only the single device listed, say root=/dev/sda5, without the other
device.

So obviously rootflags= works since rootflags=degraded works.  But
rootflags=device= does NOT work.  The obvious difference and likely bug
is as I said, the multiple equals, with the kernel commandline parser
apparently trying to parse a parameter called rootflags=device, instead
of a parameter called rootflags, with device= as part of its value.
And of course rootflags=device isn't rootflags, so it doesn't do what
it's supposed to do.

Make more sense now? =:^)

Since I realized the double-equal parsing must be the problem, I've
been going to file a kernel bug on it and hopefully get the kernel
commandline parser fixed.  But apparently I have yet to find an
appropriately rounded tuit, since I've not done so yet. =:^(

FWIW, the btrfs kernel devs are aware that using device= with
rootflags= is broken, as it was one of them that originally mentioned
it to me when I was still asking about things before I had setup my
multi-device btrfs rootfs.  So it's a known issue.  But I'm not sure
they had looked into why, they just knew it didn't work.  And since it
only affects (1) btrfs users who (2) use a multi-device rootfs, *BUT*
(3) do NOT wish to use an initr*, I guess the priority simply hasn't
been high enough for them to investigate further.

So I really should file that bug[3] and get it it to the right people.

---
[2] Back a few dracut versions ago, building the initr* with host-only
would tie the initr* to the UUID of the default rootfs.  As long as
that UUID could be found, the usual root= could be used on the kernel
commandline to boot any other rootfs if desired, and naturally, that's
how I tested my backup, with the main rootfs still there and thus its
UUID available.  But then I renewed my backup, tested again that I
could boot to it using root=, and did a fresh mkfs on the main rootfs,
thus of course killing the UUID dracut was tied to.  When I tried to
reboot back to the fresh rootfs, I found I could no longer boot to
EITHER it or the backup, because of course the new UUID didn't match
what dracut was looking for.

That was of course stupid but I figured that must be what host-only was
setup to do, so I didn't report it.  Later, I happened to mention that
experience in a general gentoo discussion and the gentoo dracut
maintainer said that was definitely a bug.  It is now said to be fixed,
but I no longer trust host-only in any case, instead using module
blacklists and whitelists to build in the specific modules I need.

Anyway, that was one such drop-to-initr* emergency-shell-prompt that I
got.

[3] File that bug:  I normally use the kernel bugzilla to report my
bugs.  Seems to work as I've filed several bugs based on my pre-release
testing over the years, and but for one which took a couple kernel
cycles to resolve, they've all been resolved before full .0 kernel
release.

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
