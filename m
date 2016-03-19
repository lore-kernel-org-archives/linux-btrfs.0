Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47047 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbcCSAjm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 20:39:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ah4vc-0002g9-9M
	for linux-btrfs@vger.kernel.org; Sat, 19 Mar 2016 01:39:40 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 01:39:40 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 01:39:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: recovery problem raid5
Date: Sat, 19 Mar 2016 00:39:29 +0000 (UTC)
Message-ID: <pan$11177$dc23156e$9ffc90e2$20c175e7@cox.net>
References: <56EC3DCC.6060101@alfazone.pl>
	<20160318180207.GA1802@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Fri, 18 Mar 2016 18:02:07 +0000 as excerpted:

> Also, that kernel's not really all that good for a parity RAID
> array -- it's the very first one that had the scrub and replace
> implementation, so it's rather less stable with parity RAID than the
> later 4.x kernels. That's probably not the issue here, though.
> 
> On Fri, Mar 18, 2016 at 06:41:32PM +0100, Marcin Solecki wrote:
>> 
>> # uname -a Linux jarvis.home 4.5.0-1.el7.elrepo.x86_64
>> 
>> # btrfs --version btrfs-progs v3.19.1

Umm... Hugo, look again.  He's running current 4.5 kernel.  It's the 
btrfs-progs version that's v3.19.1 and thus old.

Marcin.  You're kernel is current and should be fine.  It's the older 
kernels that have the most problems and 3.19 that was the first one with 
parity-raid scrub and replace, so Hugo obviously just read your post 
wrong.

Other than that, I'd normally trust Hugo's recommendations over any I 
might offer, and mount -o degraded is indeed precisely what's supposed to 
be used in a missing device situation, so I agree with him there.

You might consider upgrading userspace (btrfs-progs), as Hugo does have a 
point, if he did make it about the wrong thing, and while a 3.19 era 
userspace should work, given that full parity-raid support was very new 
at that point, a current 4.4.1 userspace may well have a few more 
bugfixes, tho I've not tracked the parity-raid support specifically 
enough to know for sure if it has any that apply to that.  But once he 
figures out you were talking about 3.19.1 userspace, not 3.19.1 kernel, 
Hugo will probably know more which if any parity-raid specific changes 
have been made to btrfs-progs since 3.19, as well.

(Of course, the wiki has a short user-targeted description of what 
changed in each btrfs-progs release as well, and I could look it up there 
if wanted to, but so can you, and I'm using the older raid1, not parity-
raid, so I don't have the direct personal interest in that info that you 
might, so...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

