Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51882 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbcCWVyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 17:54:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aiqjU-0004rs-CL
	for linux-btrfs@vger.kernel.org; Wed, 23 Mar 2016 22:54:28 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 22:54:28 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 22:54:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID-1 refuses to balance large drive
Date: Wed, 23 Mar 2016 21:54:13 +0000 (UTC)
Message-ID: <pan$82c11$ef27b5bb$f1401a80$38608652@cox.net>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
	<56F2EA25.4070004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brad Templeton posted on Wed, 23 Mar 2016 12:10:29 -0700 as excerpted:

> It is Ubuntu wily, which is 4.2 and btrfs-progs 0.4.

Presumably that's a type for btrfs-progs.  Either that or Ubuntu's using 
a versioning that's totally different than upstream btrfs.  For some time 
now (since the 3.12 release, ancient history in btrfs terms), btrfs-progs 
has been release version synced with the kernel.  So the latest release 
is 4.5.0, to match the kernel 4.5.0 that came out shortly before that 
userspace release and that was developed at the same time.  Before that 
was 4.4.1, a primarily bugfix release to the previous 4.4.0.

Before 3.12, the previous actual userspace release, extremely stale by 
that point, was 0.19, tho there was a 0.20-rc1 release, that wasn't 
followed up with a 0.20 full release.  The recommendation back then was 
to run and for distros to ship git snapshots.

So where 0.4 came from I've not the foggiest, unless as I said it's a 
typo, perhaps for 4.0.

> I will upgrade to
> Xenial in April but probably not before, I don't have days to spend on
> this.   Is there a fairly safe ppa to pull 4.4 or 4.5?  In olden days, I
> would patch and build my kernels from source but I just don't have time
> for all the long-term sysadmin burden that creates any more.

Heh, this posting is from a gentooer, who builds /everything/ from 
sources. =:^)  Tho that's not really a problem as it can go on in the 
background and thus takes little actual attention time.

The real time is in figuring out what I need to know about what has 
changed between versions and if/how that needs to affect my existing 
config, but that's time that needs spent regardless of the distro, the 
major question being one of rolling distro and thus spending that time a 
bit here and a bit there as the various components upgrade, with a better 
chance of actually nailing down the problem to a specific package upgrade 
when there's issues, or doing it all in one huge version upgrade, which 
pretty much leaves you high and dry in terms of fixing problems since the 
entire world changes at once and it's thus nearly impossible to pin a bug 
to a particular package upgrade.


But meanwhile, as CMurphy says at the expense of a frowny face...

Given that btrfs is still maturing, and /not/ yet entirely stable and 
mature, and the fact that the list emphasis is on mainline, the list 
kernel recommendation is to follow one of two tracks, either mainline 
current, or mainline LTS.

If you choose the mainline current track, the recommendation is to stay 
within the latest two current kernel series.  With 4.5 out, that means 
you should be on 4.4 at least,  Previous non-LTS kernel series no longer 
get patch backports at least from mainline, and as we focus on mainline 
here, we're not tracking what distros may or may not backport on their 
own, so we simply can't provide the same level of support.

For LTS kernel track, the recommendation has recently relaxed slightly.  
Previously, it was again to stick with the latest two kernel LTS series, 
which would be 4.4 and 4.1.  However, the one previous to that was 3.18, 
and it has been reasonably stable, certainly more so that those previous 
to that, so while 4.1 or 4.4 is still what we really like to see, we 
recognize that some will be sticking to 3.18 and are continuing to try to 
support them as well, now that the LTS 4.4 has pushed it out of the 
primary recommended range.  But previous to that really isn't supported.

Not that we won't do best-effort, regardless, but in many instances, the 
best recommendation we can make with out-of-support kernels really is to 
upgrade to something more current, and try again.

Meanwhile, yes, we do recognize that distros have chosen to support btrfs 
on kernels outside that list.  But as I said, we don't track what patches 
the distros may or may not have backported, and thus aren't in a 
particularly good position to provide support for them.  The distros 
themselves, having chosen to provide that support, are in a far better 
position to do just that, since they know what they've backported and 
what they haven't.  So in that case, the best we can do is refer you to 
the distros whose support you are nominally relying on, to actually 
provide that support.

And obviously, kernel 4.2 isn't one of the ones named above.  It's 
neither a mainstream LTS, nor any longer within the last two current 
kernel releases.

So kernel upgrade, however you choose to do it, is strongly recommended, 
with two other alternatives if you prefer:

1) Ask your distro for support of versions off the mainline support 
list.  After all, they're the ones claiming to support the known to be 
not entirely stabilized and ready for production use btrfs on non-
mainline-LTS kernels long after mainline support for those non-LTS 
kernels has been dropped.

2) Choose a filesystem that better matches your needs, presumably because 
it /is/ fully mature and stable, and thus is properly supported on older 
kernels outside the relatively narrow range of btrfs-list recommended 
kernels.


As for userspace, as explained above, in most cases for online and 
generally operational btrfs, it's the kernel code that counts.  Userspace 
is important in three cases, however, (1) when you're first creating the 
filesystem (mkfs.btrfs), (2) if you need relatively new features that 
older userspace doesn't have the kernelcode calls to support, and (3) 
when the filesystem has problems and you're trying to fix them with btrfs 
check and the other offline tools, or you're simply trying to get what 
you can off the (presumably unmountable) filesystem using btrfs restore, 
before giving up on it entirely.

So for normal use, btrfs userspace version isn't as critical, until it 
gets so old translating from newer call syntax to older syntax, or 
between output formats, becomes a problem.  But once your btrfs won't 
mount properly and you're either trying to fix them or recover files off 
them, /then/ userspace becomes critical, as the newer versions can deal 
with more problems than older versions can.

Meanwhile, newer btrfs-progs userspace is always designed to be able to 
handle older kernels as well.

So a good rule of thumb for userspace is to run at least the latest 
userspace release from the series matching your kernel version (with the 
short period after kernel release before the corresponding userspace 
release excepted, of course, if you're running /that/ close to current).  
As long as you stay within kernel recommendations, that will keep your 
userspace within reason as well.


So a 4.2 kernel isn't supported (on list, but you can of course refer to 
your distro instead, if they support it) as it's out of the current 
kernel support range and isn't an LTS, and upgrading to 4.4 LTS is 
recommended.  Alternatively, you may wish to downgrade to kernel 4.1, 
which is actually an LTS kernel and remains well supported as such.

And once you're running a supported kernel, ensure that your btrfs-progs 
is the latest of that userspace series, or newer, and you should be good 
to go. =:^)

Again, with the alternatives being either getting support from your 
distro if they're supporting btrfs on versions outside of those supported 
on-list, or switching to a filesystem that better matches your use-case 
in terms of stability and longer term support.

> Also, I presume if this is a bug, it's in btrfsprogs, though the new one
> presumably needs a newer kernel too.

Balance, like most "online" btrfs code, is primarily kernel.  All 
userspace does is call the appropriate kernel code to do the actual work.

So the problem here is almost certainly kernel.


Meanwhile, I have an idea of what /might/ be your balance problem, but I 
want to cover it in a separate reply.  Suffice it to say here that the 
news isn't great, if this is your issue, as it's a known but somewhat 
rare problem that has yet to be properly traced down and fixed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

