Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43447 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933571AbaICXHL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 19:07:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XPJdu-0004iz-7v
	for linux-btrfs@vger.kernel.org; Thu, 04 Sep 2014 01:07:10 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Sep 2014 01:07:10 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Sep 2014 01:07:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: INFO: task btrfs-transacti:2408 blocked for more than 120
 seconds.
Date: Wed, 3 Sep 2014 23:06:58 +0000 (UTC)
Message-ID: <pan$5c2a6$641b4be8$956583a6$a6dae12e@cox.net>
References: <54074D1D.1070509@gmx.de> <1484398.jrmhBVWBue@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Thu, 04 Sep 2014 00:02:03 +0200 as excerpted:

> Am Mittwoch, 3. September 2014, 19:17:17 schrieben Sie:
>> At a 32 bit stable Gentoo Linux I do have 2 BTRFS file systems :
>> 
>> $ mount | grep btrfs /var/lib/portage.fs on /usr/portage type btrfs
>> (rw,noatime,compress=lzo) /var/lib/pkg.fs on /var/db/pkg type btrfs
>> (rw,noatime,compress=lzo)
>> 
>> holding a lot of small Gentoo-package-Manager-related files. The first
>> is exported via NMFS so that my KVM can access that tree too.
>> 
>> Today I got a hang while upgrading a package at the host and one within
>> the KVM at the same time, syslog tells me:
> 
> Which kernel is this?

>From the posted log:

>> Sep  3 19:10:57 n22 kernel: Not tainted 3.16.1 #5

=:^)

(FWIW even tho I don't claim to be a dev or to otherwise make much sense 
of traces like the one posted, I /have/ learned to look for the kernel 
version in a line near the top of the trace.  I can make sense of that, 
at least, and it can sometimes save a bit of confusion when the poster 
claims to be using one version but is obviously a bit confused themselves 
as the trace says it's something else.  =:^)

> If this is anything less than 3.17-rc3, I suggest you try with that one,
> or wait till the hang fix patches got into stable trees. Chris´s recent
> pull request may have been about these.

Agreed.  Very likely the following known issue:

Kernel 3.15 switched various critical btrfs tasks from private btrfs 
threads to the generic kworker kernel threads infrastructure, but in the 
process triggered a previously latent kworker lockdep bug where the 
kworker threads weren't behaving according to their documentation.

Developing and testing a proper fix to the root kworker threads behavior 
issue will probably take another kernel cycle or two, but in the mean 
time a btrfs patch working around the problem has been developed and 
tested.  It's in 3.17-rc3 and marked for stable but not yet in a stable 
release.

So 3.14 stable series wasn't affected by the problem as btrfs was still 
using private kernel threads, previous versions aren't recommended as 
they had other now known and fixed bugs, 3.15 is AFAIK not a long-term-
stable series and is unlikely to get the patch unless you apply it 
yourself, 3.16 isn't a long-term-stable either but is still supported and 
the patch is queued for the next stable release, and 3.17 thru rc2 
doesn't have the fix but it's in rc3.

So 3.17-rc3+ is the only non-git mainline kernel with the patch applied 
at this time.  For this bug you therefore have the following choices:

1) Switch to the latest 3.17 series development kernel. (Preferred)
2) Live with it until the next 3.16 stable series release.
3) Grab and apply the patch to a previous 3.15 or 3.16 stable series 
kernel yourself.
4) Revert to 3.14 stable series, which wasn't affected.
5) Turn off the compression mount option and do a rebalance to eliminate 
existing compression, as the bug only triggers when dealing with btrfs 
compression.
6) Live on the /real/ edge and switch to btrfs integration series 
kernels, with patches undergoing testing for the /next/ mainline kernel 
series (3.18 at this point).

FWIW, there's another much harder to trigger (thus only recently found, 
traced and patched) bug that goes back much farther (3.4 at least), with 
a patch in 3.17-rc3 and headed for stable series as well.  However, given 
the rarity of triggering it and the fact that people have lived with it 
until now, while that patch is good to apply to prevent future rare-case 
issues, it's not as urgent as the one above.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

