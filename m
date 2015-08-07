Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44653 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbbHGGZ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Aug 2015 02:25:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZNb5m-00046f-B8
	for linux-btrfs@vger.kernel.org; Fri, 07 Aug 2015 08:25:22 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 08:25:22 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 08:25:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Data single *and* raid?
Date: Fri, 7 Aug 2015 06:25:12 +0000 (UTC)
Message-ID: <pan$3604e$7f253329$74ce0fc2$93d6f380@cox.net>
References: <55BD277F.2040201@friedels.name>
	<20150801203258.GA14352@carfax.org.uk>
	<CAJCQCtTY0bWrFmm_6An9QcPm7ek53vCrFHjZjehHf-UotXJ7+A@mail.gmail.com>
	<55C3AE34.8050804@friedels.name> <55C40957.9040209@cn.fujitsu.com>
	<55C43F14.7080402@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hendrik Friedel posted on Fri, 07 Aug 2015 07:16:04 +0200 as excerpted:

>>> But then:
>>> # btrfs fi df /mnt/__Complete_Disk/
>>> Data, RAID5: total=3.83TiB, used=3.78TiB
>>> System, RAID5: total=32.00MiB, used=576.00KiB
>>> Metadata, RAID5: total=6.46GiB, used=4.84GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> [T]his seems to be a RAID5 now, right?
> Well, that's what I want, but the command was:
> btrfs balance start -dprofiles=single -mprofiles=raid1
> /mnt/__Complete_Disk/
> 
> So, we would expect raid1 here, no?

No.  The behavior might be a bit counterintuitive on first glance, but 
once the logic is understood, it makes sense.

1) You had tried the initial raid5 convert using an earlier kernel that 
had incomplete raid5 support, as evidenced by the lack of the global-
reserve line in btrfs fi df, on a new enough userspace that it should 
have had it.

2) That initial attempt ran out of space, possibly because it was keeping 
the single and raid1 chunks around due to fragmentation (Hugo's guess), 
or due to a now fixed raid5 conversion bugs in the old kernel[1] (my 
guess), or possibly due to some other bug that's apparently fixed in 
newer kernels, thus the successful completion of the conversion below.

3) But that initial attempt still did one critical thing -- set the 
default new-chunk type to raid5, for both data and metadata.

4) So when the second btrfs balance attempt came along, this one 
primarily intended to clean up that fragmentation that Hugo expected, and 
thus targeted at those old single data and raid1 metadata chunks, when it 
rewrote those chunks it used the new chunk default, rewriting them into 
raid5.

That was a result that Hugo obviously didn't predict as his instructions 
suggested following up with another balance command to complete the 
conversion.  And neither Chris (apparently) nor I (definitely!) foresaw 
it either.  But the behavior does make sense, once you take into account 
the default chunk type, and that a balance-convert does normally change 
it.

And FWIW, the precise behavior of this default chunk type selector and 
when it falls back to single data and raid1 or dup metadata (as it will 
in some instances with a degraded filesystem), has both been problematic 
before, and is being debated in a current thread, due to the implications 
for writable mounts of degraded single-device raid1s, for instance.  It's 
behavior in corner-cases like these that is much of the reason most 
regulars on this list don't consider btrfs fully stable and mature, just 
yet, because sometimes that corner-case behavior can mean the filesystem 
doing the wrong thing, going read-only, without any way to correct the 
problem even tho things are generally still fine, because correcting the 
problem would require a writable filesystem, thus creating a chicken and 
egg situation where correcting the problem requires a writable 
filesystem, but a writable filesystem isn't allowed until the problem is 
corrected, for instance.  (As of now, in that situation a user has little 
choice but to copy the data on that read-only filesystem elsewhere, do a 
mkfs to wipe away the problem, and restore to the fresh filesystem.  
Technically, that shouldn't be required.)

---
[1] FWIW, for "online" tasks like btrfs balance, the btrfs-progs 
userspace simply issues the commands to the kernel, which does the real 
work.  For "offline" tasks such as btrfs check or btrfs restore, 
userspace is the real brains and the kernel simply relays the commands at 
the device level, without much involvement by the kernel's btrfs code at 
all.  So while you had a current userspace, the old kernel was the 
critical part since btrfs balance is an online command in which it's the 
kernel's btrfs code that does the real work.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

