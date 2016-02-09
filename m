Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50491 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764AbcBIVys (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 16:54:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aTGFA-0001s9-CO
	for linux-btrfs@vger.kernel.org; Tue, 09 Feb 2016 22:54:44 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 22:54:44 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 22:54:44 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: USB memory sticks wear & speed: btrfs vs f2fs?
Date: Tue, 9 Feb 2016 22:52:04 +0100
Message-ID: <20160209225204.13f9ffbc@jupiter.sol.kaishome.de>
References: <n9chle$q0h$1@ger.gmane.org>
	<56B9F2E2.8010808@swiftspirit.co.za>
	<56B9FEC0.8020603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 9 Feb 2016 09:59:12 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> > I haven't found much reference or comparison information online wrt
> > wear leveling - mostly performance benchmarks that don't really
> > address your request. Personally I will likely never bother with
> > f2fs unless I somehow end up working on a project requiring
> > relatively small storage in Flash (as that is what f2fs was
> > designed for).  
> I would tend to agree, but that's largely because BTRFS is more of a 
> known entity for me, and certain features (send/receive in
> particular) are important enough for my usage that I'm willing to
> take the performance hit.  IIRC, F2FS was developed for usage in
> stuff like Android devices and other compact embedded devices, where
> the FTL may not do a good job of wear leveling, so it should work
> equally well on USB flash drives (many of the cheap ones have no
> wear-leveling at all, and even some of the expensive ones have
> sub-par wear-leveling compared to good SSD's).

Actually, I think most of them only do wear-levelling in the storage
area where the FAT is expected - making them pretty useless for
anything else than FAT formatting...

I think the expected use-case for USB flash drives is only adding
files, and occasionally delete them - or just delete all / reformat.
It's not expected to actually "work" with files on such drives. Most of
them are pretty bad at performance anyways for such usage patterns.
It's actually pretty easy to wear out such a drive within a few days.
I've tried myself with a drive called "ReadyBoost-capable" - yeah, it
took me 2 weeks to wear it out after activating "ReadyBoost" on it, and
it took only a few days to make its performance crawl. It's just slow
now and full of unusable blocks.

-- 
Regards,
Kai

Replies to list-only preferred.

