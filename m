Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52670 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbbKXFZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 00:25:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a1664-0000EW-Nu
	for linux-btrfs@vger.kernel.org; Tue, 24 Nov 2015 06:24:56 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 06:24:56 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 06:24:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Weird space issues (with more than plenty left; over 100GiB
 free on 465.63GiB RAID partition)
Date: Tue, 24 Nov 2015 05:24:50 +0000 (UTC)
Message-ID: <pan$3d5fc$3fe10e9a$7603afcc$b1c1012@cox.net>
References: <5653CC0F.7000001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steven Hoff posted on Mon, 23 Nov 2015 19:31:43 -0700 as excerpted:

> BTRFS Community,
> 
> I seem to be having a bit of an issue. A comment on
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22
No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space
> suggested reporting this to the mailing list.
> 
> Issue: BTRFS claims to be running out of space
> 
> Setup:
> /home: 2 500GB hard drives in MDADM RAID1 with BTRFS being the primary
> filesystem
> 
> Output of various commands:
> 
> $ sudo btrfs fi df
> /home Data, single: total=334.00GiB, used=333.84GiB
> System, DUP: total=32.00MiB, used=80.00KiB
> Metadata, DUP: total=1.50GiB, used=987.17MiB
> unknown, single: total=336.00MiB, used=0.00
> 
> $ sudo btrfs fi show /home
> Label: none  uuid: (private information removed)
>      Total devices 1 FS bytes used 334.80GiB
>      devid    1 size 465.63GiB used 337.06GiB path /dev/md0p1
> Btrfs v3.12
> 
> $ df /home
> Filesystem     1K-blocks      Used Available Use% Mounted on
> /dev/md0p1     488252416 352418008 134988424  73% /home
> 
> 
> I would like to note that "total" in the following line:
> Data, single: total=334.00GiB, used=333.84GiB gets smaller whenever data
> is deleted or moved from /home. I'm not sure if that is by design, or if
> it is a bug. Either way, every once in a while applications will start
> closing unexpectedly complaining that there is no space left.


Critical information not provided: kernel version.  However, if it's 
anything as old as the 3.12 btrfs-progs userspace that's being reported, 
you're running seriously ancient versions, and an upgrade to something 
semi-recent is *strongly* recommended.

Normally, the kernel version is most critical, and running either a 
current release series (4.3), or an LTS (long term support) version no 
further back than the penultimate (next to latest, 3.18 as 4.1 is the 
latest LTS, but the currently in development 4.4 has already been 
announced as another LTS so people on 3.18 should be strongly considering 
an upgrade to 4.1 by now).

As for btrfs userspace, while it's generally not so critical, 3.12 is 
getting a bit ridiculously old now, and a good rule of thumb is to run at 
least the version matching that of your kernel series, since a userspace 
release of a particular version comes shortly after the kernel release, 
and is being coded at the same time, so they're designed with each other 
in mind.  Tho running a newer userspace shouldn't be a problem, either.  
Following that rule of thumb, if you're following the kernel rule as 
well, you'll be running at least a 3.18 series kernel, so should be 
running at least a 3.18 series userspace.  That will ensure at least that 
it doesn't get a ridiculously old as your current 3.12 userspace.

But you do seem to be running at least a newer kernel than your 
userspace, as otherwise you'd not be getting that unknown line in btrfs 
fi df.  FWIW, newer userspace correctly reports that as global reserve.

And while it doesn't yet report it as such, the global reserve (again, 
reported as unknown on your ancient userspace) actually comes from the 
metadata number, so can be added to it.  There's actually some very 
recent on-list discussion on this topic, suggesting either making the 
global reserve a sub-entry under metadata, or eliminating it entirely, 
simply adding the global reserve size to metadata's used figure.

If you do that, the metadata line becomes 1.5 gig size, 1.3 gig used.  As 
metadata chunks are nominally a quarter gig but your metadata is dup 
mode, so writing will be to two of them at once, you're into your last 
already allocated set of metadata chunks, and similarly, data usage is 
into its last data chunk (nominally 1 GiB in size).

So that means before you do much of anything, either data or metadata 
will run out on its existing allocation, and new chunks should be 
allocated.

Now according to btrfs fi show, you have plenty of unallocated space 
(device line, 337 gig allocated, of 465 gig size, so over a hundred gig 
of unallocated free space), so allocating fresh chunks shouldn't be a 
problem at all.

But evidently in your case, at least some of the time, those allocations 
are failing.  Certainly, in the past, that was known to happen with some 
versions.

But that would be kernel code, and you didn't post what kernel version 
you're running.

Assuming based on your positively ancient btrfs userspace and the above 
hints that your kernel version, while newer, isn't exactly current... the 
first thing to do would be to get a current 4.3 series kernel, at least 
for testing, and see if the problem goes away.  If so and you you want to 
return to an older version and you weren't already on one of them, try 
the latest release of either the 3.18 or 4.1 kernel series, and see if 
the bug is still gone or is there again.

Based on the results of the above, we'll know whether it's a current 
kernel bug, or corrected in current but still in the LTS kernels, or only 
in whatever non-current non-LTS version you are currently running.

If the bug isn't in current or either of the last two LTS kernel series, 
then the solution is simple, run a still supported kernel.  If it's in 
the LTS series but not in current, then we know there's a bugfix in 
current that needs to be backported to LTS-stable.  If it's in current, 
then it's an active bug, and assuming the devs aren't already working on 
it, they're likely to ask you to run with the enospc_debug mount option 
and to post the resulting kernel logs from when the problem triggers.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

