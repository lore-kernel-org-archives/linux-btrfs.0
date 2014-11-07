Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35577 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaKGDih (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Nov 2014 22:38:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XmaNg-00049q-Fn
	for linux-btrfs@vger.kernel.org; Fri, 07 Nov 2014 04:38:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 04:38:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 04:38:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Compatibility matrix kernel/tools
Date: Fri, 7 Nov 2014 03:38:23 +0000 (UTC)
Message-ID: <pan$d2077$fec7cdea$56b28895$45042d2e@cox.net>
References: <4CB60C7D-97C0-4DA5-830B-CAD0E3D0C22E@free.fr>
	<20141105214515.GD21247@carfax.org.uk> <545AD423.2010600@cn.fujitsu.com>
	<50788B41-C5FA-40B7-BFE8-008A85AB5669@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cyril Scetbon posted on Thu, 06 Nov 2014 10:21:47 +0100 as excerpted:

>>> On Wed, Nov 05, 2014 at 09:57:31PM +0100, Cyril Scetbon wrote:
>>>> 
>>>> Where can I find the compatibility matrix to know which btrfs-tools
>>>> version should work with a chosen linux kernel ?

> Thank you guys for this status ! I think you should add it somewhere in
> the documentation cause I'm pretty sure this is a repeated question from
> users.

Looking backward it hasn't been that much of a FAQ, because (despite what 
various commercial distros were willing to support for money) as far as 
the list was concerned btrfs was experimental (and is currently still not 
fully stable), so the very strong recommendation has always been, and 
remains now altho the strength of the recommendation is gradually fading 
as btrfs stabilizes, that users should always run the latest kernel as 
otherwise they are missing fixes for known problems that may well bite 
them if they don't.

Similarly but not as critically and with some differences for userspace.  
One difference was that until fairly recently userspace didn't have 
regular releases, so users of an after all experimental filesystem were 
expected to run git snapshots either built themselves and updated 
regularly, or from the distro, provided the distro updated their 
snapshots at least a couple times a year.  Older versions were mainly 
missing features for the online stuff (as Chris mentioned), and users 
were told they'd obtain best results for the offline stuff with current 
live-git (where the master branch was and is release-maturity-only code) 
or with specific testing patches.

Looking forward, however, as btrfs matures and stabilizes and as part of 
that process the btrfs community and documentation begins to accommodate 
users who routinely run years outdated code for the stability, and who 
expect to do the same thing with btrfs, this question is as you 
suggested, certain to BECOME a FAQ.

So adding it "somewhere", with the most appropriate initial "somewhere" 
likely being the user documentation section FAQ on the wiki, is indeed a 
good idea.

But it's a wiki and as such the expectation is that users themselves do 
the editing.  Go right ahead.  Chris Mason's authoritative explanation's 
a great start. =:^)

OTOH if you're like me you're more comfortable on the list, and editing 
the wiki is a big hassle.  The information will probably get there 
eventually either way, but if you do it you make sure it's done /now/, 
not whenever someone else gets to it.  So if you are comfortable updating 
the wiki, by all means do so, but if not, well, I've never done so 
either, so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

