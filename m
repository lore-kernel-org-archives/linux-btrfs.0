Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47861 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbaDKSgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 14:36:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WYgJc-0005gK-0o
	for linux-btrfs@vger.kernel.org; Fri, 11 Apr 2014 20:36:40 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 20:36:40 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 20:36:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What does scrub do?
Date: Fri, 11 Apr 2014 18:36:28 +0000 (UTC)
Message-ID: <pan$23529$14f39da4$86626e41$bd158c9e@cox.net>
References: <loom.20140411T105444-935@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alex posted on Fri, 11 Apr 2014 11:23:31 +0000 as excerpted:

> I've never had scrub report anything other than 0 (zero) errors. Ever.
> Yet I've had more than one ( ;-) ) problem which required btrfs-zero-log
> and/or btrfs --repair. This are usually my fault - fixed it 'til it
> broke.
> 
> root@XX ~ # btrfs scrub status /
> scrub status for f8152a67-3c2e-4da1-812e-9a6ab2ad1102
> scrub started at Fri Apr 11 09:55:36 2014 and finished after 44 seconds
> total bytes scrubbed: 1.40GiB with 0 errors

[snip]

> [    7.720288] btrfs: bdev /dev/vda1 errs: wr 0, rd 0, flush 0,
> corrupt 66, gen 2

[snip]

> This scrub and dmesg were taken within minutes of each other. So what it
> the utility of running scrub? Or have I got the the wrong idea of what
> scrub should report.

Probably the latter (wrong idea...), altho you might have the wrong idea 
of what the mount is reporting, rather than the wrong idea about scrub, 
or more likely, a bit of wrong on both.

Scrub is designed to fix one specific kind of error, and then in only one 
specific (but somewhat common) case.  Btrfs data and metadata are both 
checksummed.  Scrub goes over each individual checksummed object and 
calculates its checksum, verifying it against the checksum stored for 
it.  If the checksums don't match, it records an error.

Additionally, for errors, *IF* there's a second copy of the object and 
that copy DOES pass checksum validation, scrub will rewrite the bad copy 
using the good copy, "scrubbing" the data and fixing the errors it found.

Here's the critical bit.  By default, btrfs keeps two copies of metadata, 
but *NOT* data.  On a single device filesystem, this is dup mode metadata 
(except on ssd, where it's single mode), single mode data.  On a multi-
device filesystem, metadata will default to raid1 mode instead of dup 
mode (a copy on each device instead of two copies on one device), while 
data still defaults to single mode -- just one copy.  There is one 
further exception, for filesystems under 1 GiB in size, btrfs defaults to 
mixed-mode, data/metadata in the same mixed chunks.

Of course if you created the filesystem with specific modes (say -draid1, 
for raid1 mode data, or -msingle, for single mode metadata) or if you did 
a balance-convert to change the mode or switched between multi-device and 
single-device filesystem, the defaults won't apply -- you'll have what 
you set (or the default for the originally created filesystem).

While scrub can detect checksum errors in single (and raid0) mode, there 
won't be a second hopefully valid copy to replace bad copies with, so it 
will detect checksum errors but won't be able to fix them.  Only if 
there's a second, valid copy, can it fix the errors it detects.

Which is one reason I run most of my btrfs filesystems with two devices 
configured as raid1 for both data and metadata.  (I do have a couple very 
small filesystems, /boot and its backup on the other device, that are 
mixed-mode dup-mode, on a single device, but of course dup-mode has a 
second copy too.)

Anyway, if you have never seen scrub errors, that's because scrub has 
never come across such checksum validation errors on your system.

Meanwhile, the corrupt errors you see in the above mount are likely 
historical.  The errors reported by mount above, and by btrfs device stat 
are the number of errors since the filesystem was created or since the 
last reset (btrfs device stat -z prints AND RESETS the stats).  As you've 
never had scrub report an error, the corruptions likely got fixed some 
other way, possibly by deleting the affected files.  But the count has 
never been reset, so you're still seeing those historical errors.

> PS: please get the 3.14 tools release out - perhaps the fixes have
> already gone through the tree and I am just shouting at the wind.

FWIW, btrfs-progs v3.14 is tagged in git, and I'm running it here.  I 
don't know tarball release status since I build from git, but it's 
definitely tagged and available in git, which is what I'm building from, 
so it's definitely out.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

