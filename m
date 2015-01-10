Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49518 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbbAJJsm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 04:48:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y9ses-0005Yj-NU
	for linux-btrfs@vger.kernel.org; Sat, 10 Jan 2015 10:48:38 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 10:48:38 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 10:48:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Segfault in "btrfs balance start" due to kernel page allocation
 failure
Date: Sat, 10 Jan 2015 09:48:28 +0000 (UTC)
Message-ID: <pan$2d568$1ac426bb$63b3d5b5$e3656e0f@cox.net>
References: <m8odfs$rv2$1@ger.gmane.org>
	<pan$91b96$595041e4$b1777a9d$1c82bf25@cox.net>
	<m8psfs$h0t$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remy Blank posted on Sat, 10 Jan 2015 01:41:31 +0100 as excerpted:

> I'll check back in a year or two, hopefully btrfs will have gained more
> stability by then. The feature set is certainly awesome, so I'm looking
> forward to being able to use it.

Yes.  Despite the removal of the experimental warnings, btrfs isn't yet 
(entirely) stable, and the general sysadmin adage that if if you don't 
have backups, you don't /actually/ care about losing the data no matter 
what you /claim/, and that backups that aren't tested as actually usable 
aren't backups at all, applies in an even stronger way to btrfs than it 
will to more mature and stable filesystems.  And people not prepared to 
deal with that really should choose something more mature and stable at 
this point.

But at the same time, btrfs is maturing quite fast now, and is vastly 
more stable and mature now that it was a year ago, so it's coming along.  
I'd guess the code should be getting close to what I'd call "stable" in a 
year or so and may in fact be very close to it with 3.19, but I'd not be 
comfortable actually calling it stable until nearly a year (which happens 
to be roughly five kernel series...) later, with no serious issues in the 
intervening time.  Thus, if I think the code will be basically stable 
within a year as I think is reasonable, it'd be a year after that before 
I'd be really comfortable /calling/ it stable, which puts it about two 
years out, just as you said.

Tho of course major distros are beginning to make it the default even now 
(OpenSuSE being the first, I believe) so it's already stable /enough/ for 
them, and as you mention, more conservative users are only now beginning 
to consider ext4 stable, and for them, btrfs stability may yet be five 
years out...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

