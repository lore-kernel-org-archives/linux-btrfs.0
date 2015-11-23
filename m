Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40011 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbbKWFtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 00:49:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a0k01-0006Em-Ac
	for linux-btrfs@vger.kernel.org; Mon, 23 Nov 2015 06:49:13 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 06:49:13 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 06:49:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
Date: Mon, 23 Nov 2015 05:49:05 +0000 (UTC)
Message-ID: <pan$564a3$4b5e10ad$ddc42749$7ee47482@cox.net>
References: <56523AC8.7050205@voidptr.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nils Steinger posted on Sun, 22 Nov 2015 22:59:36 +0100 as excerpted:

> I recently ran into a problem while trying to back up some of my btrfs
> subvolumes over the network:
> `btrfs send` works flawlessly on snapshots of most subvolumes, but keeps
> failing on snapshots of a certain subvolume — always after sending 15
> GiB:
> 
> btrfs send /btrfs/snapshots/home/2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT |
> pv | ssh kappa "btrfs receive /mnt/300gb/backups/snapshots/zeta/home/"
> At subvol /btrfs/snapshots/home/2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT At
> subvol 2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT ERROR: send ioctl failed
> with -2: No such file or directory
>   15GB 0:34:34 [7,41MB/s]
> 
> I've tried piping the output to /dev/null instead of ssh and got the
> same error (again after sending 15 GiB), so this seems to be on the
> sending side.
> 
> However, btrfs scrub reports no errors and I don't get any messages in
> dmesg when the btrfs send fails.
> 
> What could cause this kind of error?
> And is there a way to fix it, preferably without recreating the FS?

Btrfs scrub?  Why do you believe it will detect/fix the problem?  Do you 
have reason to believe the hardware is not reliable and is returning data 
that's different than what was saved in the first place, or that your RAM 
is bad and thus that the checksums recorded for the data and metadata as 
it was saved were unreliable as saved?

Because what btrfs scrub does is very simple.  It checks that the data 
and metadata on the filesystem still produce checksums that match the 
checksums recorded when that data/metadata and the checksums covering it 
were originally saved.  If the checksums match, scrub reports no problems.

But what scrub does NOT detect are problems in the data and metadata that 
occurred before it was saved.  If you downloaded a jpeg image, for 
instance, and it was corrupted in the download, but the data you got was 
saved to btrfs just the way you got it, it won't report as invalid, 
because the checksum was taken on data that was already invalid.  But if 
it was correct as downloaded and saved, but the physical device hosting 
the btrfs is going bad, so it returns different data for that file than 
what was originally saved, then the checksum taken on the data before it 
was saved isn't going to match what you're getting back, and /that/ error 
would be detected.

So btrfs scrub detects (and under all but single and raid0 modes, 
potentially corrects using either the redundant copy of dup or raid1/10 
modes or the parity cross-checks of raid5/6 modes) is a very limited 
subset of potential errors, generally only that the data that was written 
still matches the checksum written for it, when it is read back.  But it 
won't detect others, if there's a bug in btrfs itself such that it 
checksums and writes the wrong data, or if the data was otherwise invalid 
before it was checksummed and written in the first place (as with the jpeg 
corrupted during download, example).

What you're almost certainly wanting to run instead, is btrfs check (the 
recommendation is not to run it with the --repair option, until you know 
what errors it returns in default check-but-don't-fix mode, and know that 
repair will actually fix the problem, generally after posting the results 
of the check-only here and getting confirmation that --repair will 
actually fix the problems properly), since btrfs check actually checks 
for various other filesystem related bugs.


However, note that just because send is failing, doesn't mean check will 
actually find something wrong.  It might, but it might not, too.  The 
general send/receive situation is as follows:

If both send and receive complete successfully, you can be quite 
confident that you have a faithfully reproduced copy.  However, there are 
various corner-cases that send/receive may still have problems with, altho 
over time the ones found have been fixed to work correctly.

Here's a very simple example that was one of the first such corner-cases 
fixed.  Suppose you have a subvolume that originally has two directories, 
A and B, with B nested inside A such that B is a subdir of A.  That's 
what you do your original send/receive based on.  Then, sometime later, 
you decide B should be the outer directory, with A nested inside it.  
Then, you do another send/receive, this one incremental, using the first 
one as the parent. That reversed nesting order corner-case used to trip 
up send/receive, which didn't originally know how to deal with that 
case.  But as I said, that was one of the first corner-case breakages 
found, and a patch soon taught send/receive how to deal with it properly.

But there have been a number of other similar corner-case failures, 
generally more complex than that one.  As they've been found they've been 
fixed.

The problem, however, is that as a dev you never really know that you've 
found and fixed *ALL* of them, because as you find and fix the most 
common, the remaining corner-case failures become less and less common, 
and you never really know if there's yet more of them that are simply too 
rare for people to have found and reported yet, or if you've really 
gotten them all, now.


But, again, it's worth noting that the failure mode is "fail dirty".  
That is, if both ends report success, you can be quite confident it is 
indeed a reliable copy.  The chance of silent failure is extremely small, 
and if there is a failure, you know about it as one end or the other 
fails with an error you can see, even if you don't know exactly what's 
causing it.


So definitely, do that check and see if it reports problems.  But don't 
be too surprised if it doesn't, because it very well could be another 
corner-case that is entirely valid at the filesystem level (just like 
that nesting reversal above, that's entirely legit), and send/receive 
simply doesn't know how to deal with it yet.

If the check does come up clean, then the next thing, since you didn't 
mention your kernel or btrfs-progs versions, is to upgrade to current 
versions if necessary, since send/receive (and check) will have been 
taught about more problems and how to deal with them, in newer versions.  
Try again (both the send/receive and the check) with those current 
versions.

If with current you're still getting failure, but check coming up clean, 
then you've very possibly hit another corner-case, and the devs are 
likely to be interested in trying to debug and trace it down, to 
eliminate it as they've done the others.


Meanwhile, if you don't have time to debug with them, you can of course 
try resolving the situation yourself.  Since it's reproducibly happening 
at 15 GiB, it's always happening at the same place.  You can try deleting 
stuff or moving it temporarily to a different filesystem or subvolume, 
and see if you can avoid the problem or move it elsewhere.  By bisecting 
the problem (repeatedly cutting in half the problem space each time, 
testing half of what was the bad half in the last step), you have a very 
good chance of figuring out what subdir, and possibly eventually what 
file, is causing the problem.  Once you know that, you can delete just 
that subdir or file and restore from backup, hopefully deleting the 
problem along with the file, and not bringing it back with the restore 
from backup.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

