Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54073 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3I3Hvx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 03:51:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQYGm-0004sq-L7
	for linux-btrfs@vger.kernel.org; Mon, 30 Sep 2013 09:51:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 09:51:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 09:51:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Mon, 30 Sep 2013 07:51:28 +0000 (UTC)
Message-ID: <pan$ea530$62f373f9$7645e5f4$cf21d374@cox.net>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org>
	<l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net>
	<l2a635$37m$1@ger.gmane.org> <l2a7km$gi8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Sun, 29 Sep 2013 22:55:43 +0100 as excerpted:

> On 29/09/13 22:29, Martin wrote:
> 
>> Looking up what's available for Gentoo, the maintainers there look to
>> be nicely sharp with multiple versions available all the way up to
>> kernel 3.11.2...

Cool, another gentooer! =:^)

> That is being pulled in now as expected:
> 
> sys-kernel/gentoo-sources-3.11.2

FWIW, I've been doing my own kernels (mainline) since back on mandrake a 
decade ago, and I just changed up my scripts a bit when I switched to 
gentoo.  Then later on I changed them up a bit more to be able to run git 
kernels.  These days I normally first try (and switch to if no serious 
bugs) to the dev kernel around -rc2 or so, by which point I figure 
anything likely to eat my system for breakfast should be either worked 
thru, or at least news of it available.  As a non-dev, it's very cool 
being able to spot and report bugs, possibly bisecting to a specific 
commit, and watch them get fixed before general kernel release. Just one 
way I as a non-dev can contribute back.  =:^)

To take care of packages that depend on a kernel package, I used to have 
a kernel (gentoo-sources-2.6.9999 or some such, back then, now of course 
it'd be 3.9999) in package.provided, but these days I don't even need 
that. =:^)

>> There's also the latest available from btrfs tools with
>> sys-fs/btrfs-progs "9999"...
> 
> Oddly, that caused emerge to report:
> 
> [ebuild     UD ] sys-fs/btrfs-progs-0.19.11 [0.20_rc1_p358] 0 kB
> 
> which is a *downgrade*. Hence, I'm keeping with the 0.20_rc1_p358.

btrfs-progs-9999 is available, but as a live package, it's masked in 
keeping with gentoo policy.  So to get it you'd need to unmask it.

But 0.20_rc1_p358 shouldn't be /too/ far back.  In fact, I'm guessing the 
p-number is the (serialized) patch sequence number indicating the number 
of commits forward from the rc1 tag.  And on the (locally unmasked) -9999 
version here, a git describe --tags gives me

v0.20-rc1-358-g194aa4a

... so 0.20_rc1_p358 is very likely identical to the live version at this 
point, and it makes no difference, except that the non-live version is a 
stable snapshot instead of a version that might change every time you 
merge it, if upstream has done any further commits.

So btrfs-progs-0.20_rc1_p358 should be fine.  And you were updating 
kernel to 3.11.2, so that should be fine by the time you read this, as 
well. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

