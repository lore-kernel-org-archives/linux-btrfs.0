Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48954 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbcBIVaL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 16:30:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aTFrK-0002nP-Ug
	for linux-btrfs@vger.kernel.org; Tue, 09 Feb 2016 22:30:07 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 22:30:06 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 22:30:06 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Use fast device only for metadata?
Date: Tue, 9 Feb 2016 22:29:59 +0100
Message-ID: <20160209222959.26ccded4@jupiter.sol.kaishome.de>
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba>
	<87twliri6m.fsf@thinkpad.rath.org>
	<20160209082933.52273993@jupiter.sol.kaishome.de>
	<87k2mdeufs.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 09 Feb 2016 08:10:15 -0800
schrieb Nikolaus Rath <Nikolaus@rath.org>:

> On Feb 09 2016, Kai Krakow <hurikhan77@gmail.com> wrote:
> > You could even format a bcache superblock "just in case",
> > and add an SSD later. Without SSD, bcache will just work in passthru
> > mode.
> 
> Do the LVM concerns still apply in passthrough mode, or only when
> there's an actual cache?

I don't think anyone ever tried... But I think there's actually not
much logic involved in passthru mode, still it would pass through the
bcache layer - where the bugs may be. It may be worth stress testing
such a setup first, then do your backups (which you should do anyways
when using btrfs, so this is more or less a no-op).

There may even be differences if backing is on lvm, or if caching is on
lvm, and the order of layering (bcache+lvm+btrfs, or lvm+bcache+btrfs).
I think you may find some more details with the search machine of your
preference. I remember there were actually some posts detailing exactly
about this - including some mid-term experience with such a setup.

What ever you find, passthru-mode is probably the easiest path
regarding to code complexity, so it may not reproduce bugs others
found. You may want to try to reproduce exactly their situations but
just using passthru mode and see if it works.

I suspect the hardware storage stack may also play its role (SSD
firmware, SATA/RAID chipset, trim support on/off, NCQ support, ...)


-- 
Regards,
Kai

Replies to list-only preferred.

