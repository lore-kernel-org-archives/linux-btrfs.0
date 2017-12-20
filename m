Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33071 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754337AbdLTNK0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 08:10:26 -0500
Received: by mail-io0-f175.google.com with SMTP id t196so17261155iof.0
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 05:10:26 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl>
 <4b132c07-62c7-e313-d454-b7414c737602@gmail.com>
 <20171219215849.GD14726@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d4059fa4-6f85-7b66-e749-b7cad620145c@gmail.com>
Date: Wed, 20 Dec 2017 08:10:17 -0500
MIME-Version: 1.0
In-Reply-To: <20171219215849.GD14726@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-19 16:58, Tomasz Pala wrote:
> On Tue, Dec 19, 2017 at 15:11:22 -0500, Austin S. Hemmelgarn wrote:
> 
>> Except the systems running on those ancient kernel versions are not
>> necessarily using a recent version of btrfs-progs.
> 
> Still much easier to update a userspace tools than kernel (consider
> binary drivers for various hardware).
OK, let's look at this objectively:

Current version of btrfs-progs is 4.14, released last month, and current 
kernel is 4.14.8 (or a 4.15 RC release).

In various distributions:
* Arch Linux:
	btrfs-progs version is 4.14-2
	kernel version is 4.14.6-1
* Alpine Linux:
	btrfs-progs version is 4.10.2-r0
	kernel version is 4.9.32-0
* Debian Sid:
	btrfs-progs version is 4.13.3-1
	kernel version is 4.14.0-1
* Debian 9.3:
	btrfs-progs version is 4.7.3-1
	kernel version is 4.9.0-4
* Fedora 27:
	btrfs-progs version is 4.11.3-3
	kernel version is 4.14.6-300
* Gentoo ~amd64 (equivalent of Debian Sid or Fedora Rawhide):
	btrfs-progs version is 4.14
	kernel version is 4.14.7
* Gentoo stable:
	btrfs-progs version is 4.10.2
	kernel version is 4.14.7
* Manjaro (a somewhat popular Arch Linux derivative):
	btrfs-progs version is 4.14-1
	kernel version is 4.11.12-1-rt16
* OpenSUSE Leap 42.3:
	btrfs-progs version is 4.5.3+20160729
	kernel version is 4.4.103-36
* OpenSUSE Tumbleweed:
	btrfs-progs version is 4.13.3
	kernel version is 4.14.6-1
* Ubuntu 17.10:
	btrfs-progs version is 4.12-1
	kernel version is 4.13.0-19
* Ubuntu 16.04.3:
	btrfs-progs version is 4.4-1ubuntu1
	kernel version is 4.4.0-104

Based on this, it looks like Alpine, Manjaro, and OpenSUSE Leap are the 
only distros for which it was easier to upgrade the userspace than the 
kernel, and Alpine and Manjaro are the only two that it even makes sense 
for that to be the case given that they use GRSecurity and RT patches 
respectively.

The fact is that most people use whatever version their distro packages, 
and don't install software themselves through other means, so for most 
people, it is easier to upgrade the kernel.

Even as a 'power user' using Gentoo (where it's really easy to install 
stuff from external sources because you have all the development tools 
pre-installed), I almost never pull anything that's beyond the main 
repositories or the small handful of user repositories that I've got 
enabled, and that's only for stuff I can't get in a repository.
> 
>> So in other words, spend the time to write up code for btrfs-progs that
>> will then be run by a significant minority of users because people using
>> old kernels usually use old userspace, and people using new kernels
>> won't have to care, instead of working on other bugs that are still
>> affecting people?
> 
> I am aware of the dillema and the answer is: that depends.
> Depends on expected usefulness of such infrastructure regarding _future_
> changes and possible bugs.
> In case of stable/mature/frozen projects this doesn't make much sense,
> as the possible incompatibilities would be very rare.
> Wheter this makes sense for btrfs? I don't know - it's not mature, but if the quirk rate
> would be too high to track appropriate kernel versions it might be
> really better to officially state "DO USE 4.14+ kernel, REALLY".
> 
> This might be accomplished very easy - when releasing new btrfs-progs
> check currently available LTS kernel and use it as a base reference for
> warning.
> 
> After all, "giving users a hurt me button is not ethical programming."
Scaring users needlessly is also not ethical programming.  As an example:

4.9 is the current LTS release (4.9.71 as of right now).  Dozens of bugs 
have been fixed since then.  If we were to start doing as you propose, 
then we'd be spitting out potentially bogus warnings for everything up 
through current kernels.
> 
>>> Now, if the current kernels won't toggle degraded RAID1 as ro, can I
>>> safely add "degraded" to the mount options? My primary concern is the
>>> machine UPTIME. I care less about the data, as they are backed up to
>>> some remote location and loosing day or week of changes is acceptable,
>>> brain-split as well, while every hour of downtime costs me a real money.
>> In which case you shouldn't be relying on _ANY_ kind of RAID by itself,
>> let alone BTRFS.  If you care that much about uptime, you should be
>> investing in a HA setup and going from there.  If downtime costs you
> 
> I got this handled and don't use btrfs there - the question remains:
> in a situation as described above, is it safe now to add "degraded"?
> 
> To rephrase the question: can degraded RAID1 run permanently as rw
> without some *internal* damage?
Not on kernels that don't have the patch that's been mentioned a couple 
of times in this thread, with the caveat that 'internal damage' means 
that it won't mount on such kernels after the first time (but will mount 
on newer kernels that have been patched).
> 
>>> Anyway, users shouldn't look through syslog, device status should be
>>> reported by some monitoring tool.
>> This is a common complaint, and based on developer response, I think the
>> consensus is that it's out of scope for the time being.  There have been
>> some people starting work on such things, but nobody really got anywhere
>> because most of the users who care enough about monitoring to be
>> interested are already using some external monitoring tool that it's
>> easy to hook into.
> 
> I agree, the btrfs code should only emit events, so
> SomeUserspaceGUIWhatever could display blinking exclamation mark.
No, it shouldn't _only_ emit events.  It damn well should be logging to 
the kernel log even if it's emitting events, LVM does so, MD does so, 
ZFS does so, why the hell should BTRFS _NOT_ do so?
> 
>>> Well, the question is: either it is not raid YET, or maybe it's time to consider renaming?
>> Again, the naming is too ingrained.  At a minimum, you will have to keep
>> the old naming, and at that point you're just wasting time and making
>> things _more_ confusing because some documentation will use the old
> 
> True, but realizing that documentation is already flawed it gets easier.
> But I still don't know if it is going to be RAID some day? Or won't be
> "by design"?
> 
>>> Ha! I got this disabled on every bus (although for different reasons)
>>> after boot completes. Lucky me:)
>> Security I'm guessing (my laptop behaves like that for USB devices for
>> that exact reason)?  It's a viable option on systems that are tightly
> 
> Yes, machines are locked and only authorized devices are allowed during
> boot.
> 
>> IOW, if I lose a disk in a two device BTRFS volume set up for
>> replication, I'll mount it degraded, and convert it from the raid1
>> profile to the single profile and then remove the missing disk from the
>> volume.
> 
> I was about to do the same with my r/o-stuck btrfs system, unfortunatelly
> unplugged the wrong cable...
> 
>>> Writing accurate documentation requires deep undestanding of internals.
> [...]
>> Writing up something like that is near useless, it would only be valid
>> for upstream kernels (And if you're using upstream kernels and following
>> the advice of keeping up to date, what does it matter anyway?  The
> [...]
>> kernel that fixes the issues it reports.), because distros do whatever
>> the hell they want with version numbers (RHEL for example is notorious
>> for using _ancient_ version numbers bug having bunches of stuff
>> back-ported, and most other big distros that aren't Arch, Gentoo, or
>> Slackware derived do so too to a lesser degree), and it would require
>> constant curation to keep up to date.  Only for long-term known issues
> 
> OK, you've convinced me that kernel-vs-feature list is overhead.
> 
> So maybe other approach: just like systemd sets the system time (when no
> time source available) to it's own release date, maybe btrfs-progs
> should take the version of the kernel on which it was build?
The systemd thing works because it knows the current time can't be older 
than when it was built (short of time-travel, but that's probably 
irrelevant right now).  Grabbing the kernel version of the build system 
and then using that as our own version absolutely does not because:
1. The kernel on the build system has (or should have) zero impact on 
how btrfs-progs work on the target system.  The only bit that matters is 
the UAPI headers that are installed, and if those mismatch then 
btrfs-progs won't run at all.
2. While the code in btrfs-progs is developed in-concert with kernel 
code, it is not directly dependent on it for most of it's operation.  As 
a couple of people are apt to point out, kernel version matters mostly 
for regular operation, btrfs-progs version matters mostly for recovery 
and repair.  However, _both_ do matter, so just displaying one is a bad 
idea.

As of right now, the versioning of btrfs-progs is largely linked to 
whatever the current stable kernel version is at the time of release. 
That provides a good enough indication of the vintage that most people 
have no issues just running:

	btrfs --version
	uname -r

to figure out what they have, though of course `uname -r` is essentially 
useless for outsiders on RHEL or OEL systems (and there is nothing the 
btrfs community can do about that).
