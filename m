Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51735 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbcBHWMv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 17:12:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aSu38-0002J1-5b
	for linux-btrfs@vger.kernel.org; Mon, 08 Feb 2016 23:12:50 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Feb 2016 23:12:50 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Feb 2016 23:12:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Use fast device only for metadata?
Date: Mon, 8 Feb 2016 22:12:42 +0000 (UTC)
Message-ID: <pan$dd516$c0f5f933$630bef62$f9ac950d@cox.net>
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba> <87twliri6m.fsf@thinkpad.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolaus Rath posted on Mon, 08 Feb 2016 13:44:17 -0800 as excerpted:

> Otherwise I'll give bcache a shot. I've avoided it so far because of the
> need to reformat and because of rumours that it doesn't work well with
> LVM or BTRFS. But it sounds as if that's not the case..

Bcache used to have problems with btrfs, but as I and others have 
mentioned, we have people known to be using btrfs with bcache on the 
list, and it has been working fine for quite some time, now.

Bcache vs. LVM, OTOH, I know nothing about.  Tho to be fair I guess I'm a 
bit anti-LVM biased myself, as it seems a bit too much complexity for the 
offered advantages, and when I tried it some time ago along with mdraid, 
I decided to keep the mdraid, but kill the lvm as too complex to be 
confident I could manage it correctly under the pressures of a disaster 
recovery situation, possibly with limited access to documentation, 
manpages, other recovery tools, etc.  MDRaid, OTOH, was easier to 
administer, in part because it's possible to assemble mdraid direct from 
the kernel without userspace (initr* or the like if / is on it), and I 
successfully managed it thru various issues over some time.

Of course these days I use multi-device btrfs directly, no mdraid, and a 
multi-device btrfs root unfortunately does seem to require an initr*, but 
its other advantages outweigh the additional complexity of having to use 
an initr*, so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

