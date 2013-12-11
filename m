Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46301 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3LKK4j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 05:56:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VqhT2-0000RL-UD
	for linux-btrfs@vger.kernel.org; Wed, 11 Dec 2013 11:56:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 11:56:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 11:56:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
Date: Wed, 11 Dec 2013 10:56:12 +0000 (UTC)
Message-ID: <pan$cd4bd$8058fd9d$d320fdd8$6cb46f0f@cox.net>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
	<01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com>
	<CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
	<F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
	<CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com>
	<B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 10 Dec 2013 17:33:59 -0700 as excerpted:

> On Dec 10, 2013, at 5:14 PM, Imran Geriskovan
> <imran.geriskovan@gmail.com> wrote:
> 
>>> Current btrfs-progs is v3.12. 0.19 is a bit old. But yes, looks like
>>> the wiki also needs updating.
>> 
>>> Anyway I just tried it on an 8GB stick and it works, but -M (mixed
>>> data+metadata) is required, which documentation also says incurs a
>>> performance hit, although I'm uncertain of the significance.
>> 
>> btrfs-tools 0.19+20130705 is the most recent one on Debian's leading
>> edge Sid/Unstable.

[I was debating where to reply, and chose here.]

To be fair, that's a snapshot date tag, 0.19 plus 2013-07-05 (which would 
be the date the git snapshot was taken), which isn't /that/ old, 
particularly for something like Debian.  There was a 0.20-rc1 about this 
time last year (Nov/Dec-ish 2012), but I guess Debian's date tags don't 
take rcs into account.

That said, as the wiki states, btrfs is still under /heavy/ development, 
anyone using it at this point is by definition a development filesystem 
tester, and said testers are strongly recommended to keep current with 
both kernel and btrfs-progs userspace both because not doing so 
unnecessarily risks whatever they're testing to already known and fixed 
bugs, and because if things /do/ go wrong, in addition to being little 
more than distracting noise if the bug is already fixed, reports from 
outdated versions simply aren't as useful if the bug remains unfixed.

Since the btrfs-progs git repo policy is master branch is always kept 
release-ready, development must be done on other branches and merged to 
master only when considered release-ready, ideally, all testers would run 
a current git build, either built themselves or for distros who choose to 
package a development/testing product like btrfs, built and updated by 
the distro on a weekly or monthly basis.  Of course that flies in the 
face of normal distro stabilization policies, but the point is, btrfs is 
NOT a normal distro stable package, and distros that choose to package it 
are by definition choosing to package a development package for their 
users to test /as/ a development package, and should update it 
accordingly.

And Debian or not Debian, a development status package last updated in 
July, when it's now December and there have been significant changes 
since July... might not be /that/ old in Debian terms, but it certainly 
isn't current, either!

>> Given the state of the docs probably very few or no people ever used
>> '-d dup'. As being the lead developer, is it possible for you to
>> provide some insights for the reliability of this option?
> 
> I'm not a developer, I'm just an ape who wears pants. Chris Mason is the
> lead developer. All I can say about it is that it's been working for me
> OK so far.

Least anyone finding this thread in google or the like think otherwise, 
it's probably worthwhile to emphasize that with a separate post... which 
I just did.

>> Can '-M' requirement be an indication of code which has not been ironed
>> out, or is it simply a constraint of the internal machinery?
> 
> I think it's just how chunks are allocated it becomes space inefficient
> to have two separate metadata and data chunks, hence the requirement to
> mix them if -d dup is used. But I'm not really sure.

AFAIK, duplicated data without RAID simply wasn't considered a reasonable 
use-case.  I'd certainly consider it so here, in particular because I 
*DO* use the data integrity and scrub features, but I'm actually using 
dual physical devices (SSDs in my case) in raid1 mode, instead.

The fact that mixed-data/metadata mode allows it is thus somewhat of an 
accident, more than a planned feature.  FWIW I had tried btrfs some time 
ago, then left as I decided it wasn't mature enough for my use-case at 
the time, and just came back in time to see mixed-mode going in.  Until 
mixed-mode, btrfs had quite some issues on 1-gig or smaller partitions as 
the pre-allocated separate data and metadata blocks simply didn't tend to 
balance out that well and one or the other would tend to be used up very 
fast, leaving the filesystem more or less useless in terms of further 
writes.  Mixed-data/metadata mode was added as an effective way of 
countering that problem, and in fact I've been quite pleased with how it 
has worked here on my smaller partitions.

My /boot is 256 MiB, I have one of those in dup-mode, meaning both data/
metadata dup since it's mixed-mode, on each of my otherwise btrfs raid1 
mode SSDs, thus allowing for an effective backup of what would otherwise 
be not easily and effectively backup-able, since bootloaders tend to 
allow pointing at only one such location (tho with grub2 on GPT 
partitioned devices with a BIOS reserved partition for grub2, that's not 
the issue it tended to be on MBR, since grub2 should still come up with 
its rescue mode shell even if it can't find the /boot it'd normally load 
the normal shell from, and the rescue-mode shell can be used to point at 
a different /boot, but then the same question applies to the grub 
installed on that BIOS partition, for which a second device with its own 
grub2 installed to its own BIOS partition is still the best backup), and 
allowing me to select and boot either one from BIOS.  My /var/log is 640 
MiB mixed-mode too, but in btrfs raid1, with the size, 640 MiB, chosen as 
about half a GiB, rounded up a bit and positioned such that all later 
partitions on the device start at an even GiB boundary.

In fact, I only recently realized the DUP-mode implications of mixed-mode 
on the /boot partitions myself, when I went to scrub them and then 
thought "Oh, but they're not raid1, so scrub won't work on the data."  
Except that it did, because the mixed-mode made the data as well as the 
metadata DUP-mode.

>> How well does the main idea of "Guaranteed Data Integrity for extra
>> reliability" and the option "-d dup" in its current state match?
> 
> Well given that Btrfs is still flagged as experimental, most notably
> when creating any Btrfs file system, I'd say that doesn't apply here.

Good point! =:^)

Tho the "experimental" level was recently officially toned down a notch, 
with a change to the kernel's btrfs option description that now says the 
btrfs on-device format is considered reasonably stable and will change 
only if absolutely necessary, and then only in such a way that new 
versions will remain able to mount old-device-format filesystems.  But 
it's still a not fully complete and well tested filesystem, and it 
remains under very heavy development, with fixes in every kernel series.

Meanwhile, it can be pointed out that there's currently no built-in way 
to access data that fails its checksum -- currently, if there's no valid 
second copy around due to raid1 or dup mode (and it can be noted, there's 
ONLY one additional copy ATM, no way to add further redundancy, tho N-way 
mirroring is planned after raid5/6, the currently focused in-development 
feature, is completed), or if that second copy fails its checksum as 
well, you're SOL.

That's guaranteed data integrity.  If the data can be accessed, its 
integrity is guaranteed due to the checksums.  If they fail, the data 
simply can no longer be accessed.  (Of course there's the nodatasum and 
nodatacow mount options which turn that off, and the NOCOW file 
attribute, which I believe turns off checksumming as well, and those are 
recommended for large-and-frequently-internally-written-file use-cases 
such as VM images, but those aren't the defaults.)

But while that might be guaranteed integrity, it's definitely NOT "extra 
reliability", at least in the actual accessible data sense, if you can't 
access the data AT ALL without a second copy around, which isn't 
available on a single device without data-dup-mode.

That was one reason I went multi-device and btrfs raid1 mode.  And I'd be 
much more comfortable if that N-way-mirroring feature was currently 
available and working as well.  I'd probably limit it to three-way, but I 
would definitely rest more comfortably with that three-way!

But, given btrfs' development status and thus the limits to trusting any 
such feature ATM, I think we're thinking future-stable-btrfs as much as 
current-development btrfs.  Three-way is definitely planned, and I agree 
with the premise of the original post as well, that there's a definite 
use-case for DUP-mode (and even TRIPL-mode, etc) on a single partition, 
too.

> If the case you're trying to mitigate is some kind of corruption that
> can only be repaired if you have at least one other copy of data, then
> -d dup is useful. But obviously this ignores the statistically greater
> chance of a more significant hardware failure, as this is still single
> device.

I'd take issue with the "statistically greater" assumption you make.  
Perhaps in theory, and arguably possibly in UPS-backed always-on 
scenarios as well, but I've had personal experience with failed checksums 
and subsequent scrubs here on my raid1 mode btrfs, that were NOT hardware 
faults, on quite new SSDs that I'd be VERY unhappy with if they /did/ 
actually start generating hardware faults.

In my case it's a variant of the unsafe shutdown scenario.  In 
particular, my SSDs takes a bit to stabilize after first turn-on, and one 
typically appears and is ready to take commands some seconds before the 
other one.  Now the kernel does have the rootwait commandline option to 
wait for devices to appear, and between that and the initramfs I have to 
use in ordered for a btrfs raid1-mode rootfs to mount properly 
(apparently rootflags=device=/dev/whatever,device=/dev/whatever2 doesn't 
parse properly, I'd guess due to splitting at the wrong equals, and 
without an initramfs I have to mount degraded, or at least I did a few 
kernels ago when I set things up), actual bootup works fine.

But suspend2ram apparently doesn't use the same rootwait mechanism, and 
if I leave my system in suspend2ram for more than a few hours (I'd guess 
whatever it takes for the SSDs caps to drain sufficiently so it takes too 
long to stabilize again), when I try to resume, one of the devices will 
appear first and the system will try to resume with only it, without the 
other device having shown up yet.

Unfortunately, btrfs raid1 mode doesn't yet cope particularly well with 
runtime (well here, resume-time) device-loss, and open-for-write files 
such as ~/.xsession-errors and /var/log/* start triggering errors almost 
immediately after resume, forcing the filesystems read-only and forcing 
an only semi-graceful reboot without properly closing those still-open-
for-writing-but-can't-be-written files.

Fortunately, those files are on independent btrfs non-root filesystems, 
and my also btrfs rootfs remains mounted read-only in normal operation, 
so there's very little chance of damage to the core system on the 
rootfs.  Only /home and /var/log are normally mounted writable (and the 
tmpfs-based /tmp, /run... of course, /var/lib and a few other things that 
need to be writable and retained over a reboot are symlinked to subdirs 
in /home).  And the writable filesystems have always remained bootable; 
they just have errors due to the abrupt device-drop and subsequent forced-
read-only of the remaining device with open-for-write files.

A scrub normally fixes them, altho in one case recently, it "fixed" both 
my user's .xsession-errors and .bash_history files to entire 
unreadability -- any attempt to read either one, even with cat, would 
lockup userspace (magic-srq would work, so the kernel wasn't entirely 
dead, but no userspace output). So scrub didn't save the files that time, 
even if it did apparently fix the metadata.  I couldn't log in, even in a 
non-X VT, as that user, until I deleted .bash_history.  And once I 
deleted the user's .bash_history, I could login non-X, but attempting to 
startx would again give me an unresponsive userspace, until I 
deleted .xsession-errors as well.

Needless-to-say, I've quit using suspend2ram for anything that might be 
longer than say four hours.  Unfortunately, suspend2disk aka hibernate 
didn't work on this machine last I tried it (it hibernated but resume 
would fail, tho that was when I first setup the machine over a year ago 
now, I really should try it again with a current kernel...), so all I 
have is reboot.  Tho with SSDs for the main system that's not so bad.  
And with it being winter here, the heat from a running system isn't 
entirely wasted, so for now I can leave the system on when I'd normally 
suspend2ram it during the 8-9 months out of the year I'm paying for any 
computer energy used twice, once to use it, again to pump it outside with 
the AC, here in Phoenix.

So the point of all that... data corruption isn't necessarily rarer than 
single-device hardware failure at all.  (Obviously in my case the fact 
that it's dual-devices in btrfs raid1 mode was a big part of the trigger; 
that wouldn't apply in single-device cases.  But there's other real-world 
corruption cases too, including simple ungraceful shutdowns that could 
well trigger the same sort of issues on a single device, that for a LOT 
of people are far more likely than hardware storage device failure.

So there's a definite use-case for single-device DUP/TRIPL/... mode, 
particularly so since that's what's required to actually make practical 
use of scrub and thus the actual available reliability side of the btrfs 
data integrity feature.

> Not only could the entire single device fail, but it's possible
> that erase blocks individually fail. And since the FTL decides where
> pages are stored, the duplicate data/metadata copies could be stored in
> the same erase block. So there is a failure vector other than full
> failure where some data can still be lost on a single device even with
> duplicate, or triplicate copies.

That's actually the reason btrfs defaults to SINGLE metadata mode on 
single-device SSD-backed filesystems, as well.

But as Imran points out, SSDs aren't all there is.  There's still 
spinning rust around.

And defaults aside, even on SSDs it should be /possible/ to specify data-
dup mode, because there's enough different SSD variants and enough 
different use-cases, that it's surely going to be useful some-of-the-time 
to someone. =:^)

And btrfs still being in development means it's a good time to make the 
request, before it's stabilized without data-dup mode, and possibly 
without the ability to easily add it because nobody thought the case was 
viable and it thus wasn't planned for before btrfs went stable. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

