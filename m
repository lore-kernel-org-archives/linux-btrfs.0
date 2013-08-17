Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55323 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3HQFDG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 01:03:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VAYfH-0004Tc-5N
	for linux-btrfs@vger.kernel.org; Sat, 17 Aug 2013 07:03:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 07:03:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 07:03:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Question: btrfs-progs releases?
Date: Sat, 17 Aug 2013 05:02:45 +0000 (UTC)
Message-ID: <pan$926b0$b4061d31$38c7ab48$19af94f0@cox.net>
References: <CAG-2HqVFdRjnK1LHnLDPm8frw1MtG2k44N=n4hhdv9kpdf4VoQ@mail.gmail.
	com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tom Gundersen posted on Sat, 17 Aug 2013 11:19:19 +0800 as excerpted:

> I package btrfs-progs for Arch Linux, and I'm wondering about its
> current status.
> 
> I have seen repeated talk of making regular releases, but so far we
> haven't had a proper release since v19 four years ago.
> 
> Are we to take from this that btrfs-progs is not suitable for
> distribution yet, and if so, would we be better off not shipping it at
> all? Or are there other reasons releases are not made?
> 
> I get frequent requests for shipping new git snapshots, but I'd rather
> not ship something that upstream does not deem ready for release.

Most of the following can be found on the btrfs wiki, at:

https://btrfs.wiki.kernel.org/

Well, both btrfs kernel code and btrfs-progs remain officially under 
heavy development, and bugs continue to be fixed with every release, so 
people who do choose to run it are *STRONGLY* encouraged both to keep 
their backups current (even more so than one would do with a stable 
filesystem), and to run at LEAST latest stable kernel if not the rcs, as 
well as to read the wiki and keep up with this list so they know what's 
going on with the filesystem they've chosen to test.

(FWIW, here, I run linus kernel git, but normally try to switch over 
about rc2 or 3, sticking to the previous version until then.)

Most distros who make btrfs available are packaging btrfs-progs git 
snapshots, because the same general theme applies to btrfs-progs -- bugs 
are REGULARLY being fixed, and if you're running old code, you really ARE 
taking unnecessary risks (in addition to any bug reports not being as 
helpful because you're running stale code).

That said, btrfs used as a traditional filesystem is the most mature and 
has been more or less stable (for an experimental filesystem) for some 
time now, with btrfs raid0/1/10 modes newer but now reasonably stable as 
well. (I'm running btrfs raid1 mode here, but with backups both to a 
second btrfs instance and to reiserfs, my former filesystem of choice, 
which has proven VERY stable and reliable for me, but isn't a good match 
for SSDs.)

But the new (kernel 3.10) btrfs raid5/6 code isn't usable except for pure 
testing ATM, as the code writes the raid checksums but does not yet know 
how to use them in case of device failure (someone in another thread just 
reported it segfaulting on device removal), so it works in all-OK mode 
only.  Personally, I wouldn't put my data on that (even with backups) at 
least for another couple kernels, and probably until about this time next 
year.

Meanwhile, btrfs-progs 0.20-rc1 has been out for awhile, and 0.19 is 
QUITE old now, so anything that's not at LEAST 0.20-rc1 is VERY dated 
these days... to the point I'd be seriously worried about it making 
problems worse instead of better!


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

