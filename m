Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56559 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbcC2CX1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 22:23:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1akjJQ-0000A6-Ul
	for linux-btrfs@vger.kernel.org; Tue, 29 Mar 2016 04:23:21 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 04:23:20 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 04:23:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Compression causes kernel crashes if there are I/O or checksum
 errors (was: RE: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing
 device in RAID-1)
Date: Tue, 29 Mar 2016 02:23:10 +0000 (UTC)
Message-ID: <pan$8d4aa$86f9e595$a75cf83d$dda8e362@cox.net>
References: <001b01d188ac$16740630$435c1290$@codenest.com>
	<pan$284e3$6ee9615a$919b0339$15e3af27@cox.net>
	<003801d188fe$e8c9b920$ba5d2b60$@codenest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James Johnston posted on Mon, 28 Mar 2016 14:34:14 +0000 as excerpted:

> Thanks for the corroborating report - it does sound to me like you ran
> into the same problem I've found.  (I don't suppose you ever captured
> any of the crashes?  If they assert on the same thing as me then it's
> even stronger evidence.)

No...  In fact, as I have compress=lzo on all my btrfs, until you found 
out that it didn't happen in the uncompressed case, I simply considered 
that part and parcel of btrfs not being fully stabilized and mature yet.  
I didn't even consider it a specific bug on its own, and thus didn't 
report it or trace it in any way, and simply worked around it, even tho I 
certainly found it frustrating.

>> The failure mode of this particular ssd was premature failure of more
>> and more sectors, about 3 MiB worth over several months based on the
>> raw count of reallocated sectors in smartctl -A, but using scrub to
>> rewrite them from the good device would normally work, forcing the
>> firmware to remap that sector to one of the spares as scrub corrected
>> the problem.
> 
> I wonder what the risk of a CRC collision was in your situation?
> 
> Certainly my test of "dd if=/dev/zero of=/dev/sdb" was very abusive, and
> I wonder if the result after scrubbing is trustworthy, or if there was
> some collisions.  But I wasn't checking to see if data coming out the
> other end was OK - I was just trying to see if the kernel crashes or not
> (e.g. a USB stick holding a bad btrfs file system should not crash a
> system).

I had absolutely no trouble with the scrubbed data, or at least none I 
attributed to that, tho I didn't have the data cross-hashed and cross-
check the post-scrub result against earlier hashes or anything, so a few 
CRC collisions could have certainly snuck thru.

But even were some to have done so, or even if they didn't in practice, 
if they could have in theory, just the standard crc checks are so far 
beyond what's built into a normal filesystem like the reiserfs that's 
still my second (and non-btrfs) level backup.  So it's not like I'm 
majorly concerned.  If I was paranoid, as I mentioned I could certainly 
be doing cross-checks against multiple hashes, but I survived without any 
sort of routine data integrity checking for years, and even a practical 
worst-case-scenario crc-collision is already an infinite percentage 
better than that (just as 1 is an infinite percentage of 0), so it's 
nothing I'm going to worry about unless I actually start seeing real 
cases of it.

>> So I quickly learned that if I powered up and the kernel crashed at
>> that point, I could reboot with the emergency kernel parameter, which
>> would tell systemd to give me a maintenance-mode root login prompt
>> after doing its normal mounts but before starting the normal post-mount
>> services, and I could run scrub from there.  That would normally repair
>> things without triggering the crash, and when I had run scrub
>> repeatedly if necessary to correct any unverified errors in the first
>> runs, I could then exit emergency mode and let systemd start the normal
>> services, including the service that read all these files off the now
>> freshly scrubbed filesystem, without further issues.
> 
> That is one thing I did not test.  I only ever scrubbed after first
> doing the "cat all files to null" test.  So in the case of compression,
> I never got that far.  Probably someone should test the scrubbing more
> thoroughly (i.e. with that abusive "dd" test I did) just to be sure that
> it is stable to confirm your observations, and that the problem is only
> limited to ordinary file I/O on the file system.

I suspect that when the devs duplicate the bug and ultimately trace it 
down, we'll know from the code-path whether scrub could have hit it or 
not, without actually testing the scrub case on its own.

And along with the fix it's a fair bet will be an fstests patch that will 
verify no regressions there once fixed, as well.

Once the fstests patch is in, it should be just a small tweak to test 
whether scrub's subject to the problem if it uses a different code-path, 
or not, and in fact once they find and verify with a fix the problem 
here, even if scrub doesn't use that code-path, I expect they'll be 
verifying scrub's own code-paths as well.

>> And apparently the devs don't test the someone less common combination
>> of both compression and high numbers of raid1 correctable checksum
>> errors, or they would have probably detected and fixed the problem from
>> that.
> 
> Well, I've only tested with RAID-1.  I don't know if:
> 
> 1.  The problem occurs with other RAID levels like RAID-10, RAID5/6.
> 
> 2.  The kernel crashes in non-duplicated levels.  In these cases, data
> loss is inevitable since the data is missing, but these losses should be
> handled cleanly, and not by crashing the kernel.

Good points.  Again, I expect the extent of the bug based on its code-
path and what actually uses it, should be readily apparent once the bug 
is traced, and that tests will be developed to cover the other code 
paths, once the scope of this specific affected code path is known, if 
necessary.

Tho it's quite possible that testing these sorts of things will help 
further narrow the problem space, and thus could help in actually tracing 
down the bug, in the first place.

> Do any devs do regular regression testing for these sorts of edge cases
> once they come up? (i.e. this problem won't come back, will it?)

As should (now) be obvious from the above, yes, definitely.  Most patches 
to specific bugs also include fstests (originally xfstests, I don't 
actually know if the name has actually changed or if the fstests 
references I see are simply using an informal generic name, now that 
xfstest covers all sorts of other filesystems including btrfs, as well) 
patches to ensure the same bugs or anything close enough to them to 
trigger the same test-fails, don't get reintroduced.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

