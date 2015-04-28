Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59072 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbbD1Et7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 00:49:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YmxSy-0001RB-HR
	for linux-btrfs@vger.kernel.org; Tue, 28 Apr 2015 06:49:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2015 06:49:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2015 06:49:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-progs BTRFS mounted with -o recovery showing no errors on
 scrub - minor
Date: Tue, 28 Apr 2015 04:49:46 +0000 (UTC)
Message-ID: <pan$74b1$6f200c1f$ea194380$e1e64066@cox.net>
References: <D06066B0-F26E-4F1D-BFF5-E6BC8CDB68B1@plack.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anthony Plack posted on Mon, 27 Apr 2015 07:51:14 -0500 as excerpted:

> This may be by design since the driver is handling the errors. When the
> drive is mounted with -o recovery, and then a scrub is performed, scrub
> will show no errors. 
> 
> fatdrive ~ # dmesg | tail
> [35348.694291] repair_io_failure: 4 callbacks suppressed
> [35348.694297] BTRFS: read error corrected: ino 1 off 93863407616 (dev /dev/sds sector 183326968)
> [35351.029568] BTRFS (device sdt): parent transid verify failed on 8392192475136 wanted 148989 found 147789
> [35351.048101] BTRFS: read error corrected: ino 1 off 8392192475136 (dev /dev/sds sector 2314785632)
> [35470.018881] BTRFS (device sdt): parent transid verify failed on 94051291136 wanted 150686 found 150687
> [35470.150372] BTRFS (device sdt): parent transid verify failed on 94051291136 wanted 150686 found 150687
> [35948.602971] BTRFS (device sdt): parent transid verify failed on 94238015488 wanted 150690 found 150691
> [35948.608723] BTRFS (device sdt): parent transid verify failed on 94238015488 wanted 150690 found 150691
> [36114.453009] BTRFS (device sdt): parent transid verify failed on 94238015488 wanted 150690 found 150691
> [36114.472586] BTRFS (device sdt): parent transid verify failed on 94238015488 wanted 150690 found 150691
> fatdrive ~ # btrfs scrub status /mnt/data
> scrub status for f591ac13-1a69-476d-bd30-346f87a491da
> 	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 2651 seconds
> 	total bytes scrubbed: 2.39TiB with 0 errors
> 
> I have reported this as issue 97351.
> https://bugzilla.kernel.org/show_bug.cgi?id=97351

You misunderstand the type of errors scrub fixes, compared to what the
above dmesg reflects.

Scrub searches for and (if possible and not read-only) fixes only one
type of errors, where the data stored in a block does not match the
checksum recorded for that block, thus indicating either in-transit
or in-storage errors on the storage device itself, after btrfs
calculated and stored the checksum for that data.  It's entirely
possible for the data to match the checksum -- it's still the same
data that btrfs sent to storage and the checksum matches (or it's
something for which checksumming is specifically turned off, the 
space-cache isn't checksummed IIRC, and setting NOCOW on a file
will turn off checksumming as well) -- and thus come up clean on a
scrub, but for that data to be invalid for some other reason.

In this case the other reason is that the (commit) generation number
(aka transaction id, transid) is off.  The wanted transid on the
last one, for instance, is 150690, but it found a transid one
higher than that.

Which AFAIK[1] is actually expected when one has to mount with recovery,
since while the generation number is normally monotonically
increasing and thus under /normal/ operation you should never see a
found value /higher/ than wanted, mounting with recovery gives btrfs
explicit permission to use and older generation (with btrfs being
copy-on-write, there will be many older generations still available
on-device) if it has to.

So what seems to have occurred here is that you used recovery to
allow btrfs to use an older generation where it needed to, and it
needed to do just that for some of the subtrees, falling one
commit generation back.  But some others were actually current,
which is why you're getting a wanted (which matches the generation
chosen for recovery, one back) that's one lower than found, for
these subtrees.

Bottom line, the checksums are apparently fine, so scrub won't
see anything wrong, no matter how invalid the data that was
actually sent to the device to store.

Which will make that bug invalid...  unless it gets turned
into a documentation bug suggesting the btrfs-scrub documentation
be made more explicit on this point.  Which might actually be
considered a valid bug, depending on how data error detection
and correction technology knowledgeable we expect our users to
be.  Professional sysadmins should know this stuff from raid
and the like and it shouldn't need explained to them, but
ordinary personal machine users and sysadmins likely won't.

---
[1] AFAIK:  I'm a btrfs user and list regular, not a dev.
This is my understanding based on the presented evidence
and what I do know about recovery, that being that it
allows falling back a few generations if necessary, and
about generation aka transid numbers and btrfs commit
behavior.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

