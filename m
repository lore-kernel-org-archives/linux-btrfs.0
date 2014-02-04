Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34786 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaBDGJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 01:09:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WAZCC-0005fP-Cc
	for linux-btrfs@vger.kernel.org; Tue, 04 Feb 2014 07:09:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 07:09:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 07:09:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid5 unmountable
Date: Tue, 4 Feb 2014 06:08:58 +0000 (UTC)
Message-ID: <pan$67e3$41756215$a105cb5f$65318804@cox.net>
References: <20140203171224.3835fea1@trediske.ws.office.manitu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tetja Rediske posted on Mon, 03 Feb 2014 17:12:24 +0100 as excerpted:

[...]

> What happened before:
> 
> One disk was faulty, I added a new one and removed the old one, followed
> by a balance.
> 
> So far so good.
> 
> Some days after this I accidently removed a SATA Power Connector from
> another drive, without noticing it at first. Worked about an hour on the
> system, building new Kernel on another Filesystem. Rebooted with my new
> Kernel and the FS was not mountable. I noticed the "missing" disk and
> reattached the power.
> 
> So far i tried:
> 
> mount -o recovery
> btrfs check
> (after google) btrfs-zero-log
> 
> Sadly no luck. Whoever I can get my Files with btrfs restore. The
> Filesystem contains mainly Mediafiles, so it is not so bad, if they were
> lost, but restoring them from backups and sources will need atleast
> about a week. (Most of the Files are mirrored on a private Server, but
> even with 100MBit this takes a lot of time ; )
> 
> Some Idea who to recover this FS?

[As a btrfs users and list regular, /not/ a dev...]

That filesystem is very likely toast. =:(  Tho there's one thing you 
didn't mention trying yet that's worth the try.  See below...

You can read the list archives for the details if you like, but 
basically, the raid5/6 recovery code simply isn't complete yet and is not 
recommended for actual deployment in any way, shape or form.  In practice 
at present it's a fancy raid0 that calculates and writes a bunch of extra 
parity, and can be run-time tested and even in some cases recover from 
online-device-loss (as you noted), but throw a shutdown in there along 
with the bad device, and like a raid0, you might as well consider the 
filesystem lost... at least until the recovery code is complete, at which 
point if the filesystem is still around you may well be able to recover 
it, since the parity is all there, the code to actually recover from it 
just isn't all there yet.

FWIW, single-device btrfs is what I'd call almost-stable now altho you're 
still strongly encouraged to keep current and tested backups as there are 
still occasional corner-cases, and stay on current kernels and btrfs-
tools as potentially data-risking bugs still are getting fixed.  Multi-
device btrfs in single/raid0/1/10 modes are also closing in on stable 
now, tho not /quite/ as stable as single device, but quite usable as long 
as you do have tested backups -- unless you're unlucky you won't actually 
have to use them (I haven't had to use mine), but definitely keep 'em 
just in case.  But raid5/6, no-go, with the exception of pure testing 
data that you really are prepared to throw away, because recovery for it 
it really is still incomplete and thus known-broken.

The one thing I didn't see you mention that's worth a try if you haven't 
already, is the degraded mount option.  See
$KERNELSRC/Documentation/filesystems/btrfs.txt.  Tho really that should 
have been the first thing you tried for mounting once you realized you 
were down a device.

But with a bit of luck...

Also, if you've run btrf check with the --repair option (you didn't say, 
if you didn't, you should be fine as without --repair it's only a read-
only diagnostic), you may have made things worse, as that's really 
intended to be a last resort.

Of course if you'd been following the list as btrfs testers really should 
still be doing at this point, you'd have seen all this covered before.  
And of course, if you had done pre-deployment testing before you stuck 
valuable data on that btrfs raid5, you'd have noted the problems, even 
without reading about it on-list or on the wiki.  But of course hindsight 
is 20/20, as they say, and at least you DO have backups, even if they'll 
take awhile to restore.  =:^) That's already vastly better than a lot of 
the reports we unfortunately get here. =:^\

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

