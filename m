Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45870 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbbGaIoU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 04:44:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZL5vM-0000Q7-Le
	for linux-btrfs@vger.kernel.org; Fri, 31 Jul 2015 10:44:16 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2015 10:44:16 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2015 10:44:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: systemd : Timed out waiting for defice
 =?CP1251?Q?dev-disk-by=85?=
Date: Fri, 31 Jul 2015 08:44:10 +0000 (UTC)
Message-ID: <pan$92f7f$b783d193$6a4f2413$86168ab3@cox.net>
References: <1437763277.673610371@apps.rackspace.com>
	<55B54568.5060902@googlemail.com>
	<pan$a902b$10dd7fbd$f0ca0693$dc0cc8e3@cox.net>
	<CAGfcS_=Z=bRzMvFBDeYQDU8Vxa2UVha44nWogjQ_-_irrZD1xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Thu, 30 Jul 2015 07:22:12 -0400 as excerpted:

> On Mon, Jul 27, 2015 at 1:20 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Philip Seeger posted on Sun, 26 Jul 2015 22:39:04 +0200 as excerpted:
>>
>>>> 50% of the time when booting, the system go in safe mode because my
>>>> 12x 4TB RAID10 btrfs is taking too long to mount from fstab.
>>>
>>> I've seen this exact behavior too (some time ago).
>>> Except that it wasn't 50% that it didn't work, more like almost
>>> everytime. Commenting out the fstab entry "fixed" it, mounting
>>> using a cronjob (@reboot) worked without a problem.
>>>
>>> (As far as I remember, options like x-systemd.device-timeout didn't
>>> change anything.)

With a bit deeper look into systemd's dynamically generated mount units 
(see below), I suspect that x-systemd.device-timeout wasn't what you 
needed -- it's the wrong timeout, on the time it takes the "primary" 
device (on a multi-device btrfs, the one you point mount at) to appear, 
not on the time it takes to mount or the entire mount process to occur, 
which is what needs to change here.

More below.

>>> If someone has the answer, I'd be interested too.
>>
>> You mean something like a custom systemd *.service unit file?  That's
>> what I'd do here. =:^)
> 
> I'd have to play with it to work out the kinks, but I'm pretty sure
> you'd be better off with a mount unit instead of basically reinventing a
> mount unit using a service unit.

Using a mount unit is indeed possible, and I contemplated including it, 
but (a) I haven't really worked with them so am less directly familiar 
with them, and (b) my posts tend to be on the longer side already, and 
given (a) I decided to draw the line somewhat arbitrarily in exclusion of 
mount unit discussion.

But I'm glad you mentioned them, completing the picture, and indeed, 
they'd be the most directly apropos solution. =:^)

And actually, while I still haven't actually used mount units, I did take 
a closer look at them recently in connection with a thread you're likely 
also reading, on a different mailing list.[1]

> I'd also think that you could also use drop-ins to enhance the
> auto-generated units created by the fstab generator, if you just wanted
> to add a dependency or such to a mount unit.  However, I've never tried
> to create a drop-in for a generated unit.

Hmm... Using drop-ins on generated units hadn't really occurred to me.  
Very good point! =:^)

It addresses one of the concerns I had about using a mount unit (and why 
I chose to suggest a normal service unit) as well, since at the time of 
my original reply, I couldn't see how to use a mount unit without 
overriding the entire generated mount unit, and with it, I thought, the 
ability to use the fstab entry for that mount.  I'd used dropins before, 
but only with static service units.

> Mount units should take any setting in systemd.unit which includes all
> the ordering/dependency/etc controls.

Yes.

BTW, in case it's not clear, systemd.unit refers to the general systemd 
unit manpage.  And of course the specific mount unit manpage is 
systemd.mount, which also refers to systemd.exec, for more esoteric 
settings that would affect the environment that mount executes in, for 
instance.  And systemd.kill covers kill mode, for the timeout option 
discussed below.

For the specific case of systemd giving up on many-device btrfs mounts, 
now that I've read a bit more and am thinking in terms of dropins, I'd 
guess the following option, covered in systemd.mount and to be placed in 
the mount section with an appropriate value, should do it:

TimeoutSec=

The default timeoutsec setting is set in /etc/systemd/systemd.conf 
(systemd-system.conf manpage) as DefaultTimeoutStartSec=, with 90 seconds 
the shipped default if it's not set there.  Without a specific setting in 
the unit file, that system default would be used.

So assuming no different setting in systemd.conf and no additions to the 
dynamically generated mount unit (with the name of the mountpoint and 
located in /run/systemd/generator/*.mount), probably that 90 second 
default timeout applied, and that simply isn't enough for a many-device 
btrfs to get fully assembled and mounted.

A timeoutsec setting of 0 should disable the timeout, or set it to 
something appropriately higher than the default timeout, say 
TimeoutSec=5m, assuming that's enough for your system.

The nofail option can be added to the mount options in fstab, thus not 
stopping the boot, and/or noauto can be added, so it doesn't mount with 
the normal boot at all.  Or...

So a dropin mount-unit in /etc/systemd/system/, named the same
(encoded-mountpoint.mount) as the dynamically generated mount unit 
located in /run/systemd/generator/ , with the following content, /should/ 
do it:

-----

[Mount]
TimeoutSec=0

-----

In theory at least (neither I nor Rich has tested dropins with 
dynamically generated units), that should add the timeout setting to the 
settings already there in the generated unit file, and the timeout should 
be entirely disabled (or set to an appropriate value if not 0) for that 
unit.


Tho that would still leave the mount happening at boot time "Before=local-
fs.target", which is what the generator puts in any mount units 
dynamically generated from fstab, unless noauto was set in the mount 
options.  To have the mount unit execute later, add the following as well:

-----

[Unit]
Before=
After=multi-user.target graphical.target

-----

The blank before= resets the generator-default before=local-fs.target.  
The After=multi-user.target graphical.target starts it after the normal 
boot sequence is finished, since that's the CLI-login and GUI login 
targets, respectively.

I'm not sure, a Requires=multi-user.target (in the unit section), or 
possibly Wants=multi-user.target, may be required as well.  Normally a 
line in fstab create a unit that will be required by local-fs.target 
(see /run/systemd/generator/local-fs.target.requires/), and I'm not sure 
if the above is enough to reset that or not.  I'd have to play with it a 
bit.

Which was the other reason I suggested a service unit instead of a mount 
unit.  I'm not sure how to reset the required-by local-fs.target bit, 
given that it's not in the generated unit file nor covered in the 
systemd.mount manpage that I could see, so if the goal includes not only 
increasing the the timeout, but placing it later in the boot sequence so 
it doesn't interfere with everything else including logging in, I wasn't 
sure how to override that on mount units and am still not sure, while I 
know exactly how to do it with service units as I'm actually doing that 
with one of mine (which cats all files of an entire rather large 
directory, redirecting output to /dev/null, thereby ensuring all files in 
that dir are cached).

---
[1] Both Rich and I are gentooers, he a dev I a user, and there's a 
current thread on the gentoo-dev list discussing mount-unit type 
functionality for openrc, the sysv-init-based init system that gentoo 
still uses by default, tho systemd is an option as well.  I looked into 
systemd mount-units for a reply there.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

