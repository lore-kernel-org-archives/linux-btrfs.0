Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50982 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbcBIHDJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 02:03:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aT2KJ-00066C-AT
	for linux-btrfs@vger.kernel.org; Tue, 09 Feb 2016 08:03:07 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 08:03:07 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 08:03:07 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: "layout" of a six drive raid10
Date: Tue, 9 Feb 2016 08:02:58 +0100
Message-ID: <20160209080258.45339bf0@jupiter.sol.kaishome.de>
References: <1E2010FD-CBFD-44BD-B5DB-9ECD5C009391@bueechi.net>
	<pan$b862$fa78f2fd$bea6373b$99d690b8@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 9 Feb 2016 01:42:40 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Tho I'd consider benchmarking or testing, as I'm not sure btrfs raid1
> on spinning rust will in practice fully saturate the gigabit
> Ethernet, particularly as it gets fragmented (which COW filesystems
> such as btrfs tend to do much more so than non-COW, unless you're
> using something like the autodefrag mount option from the get-go, as
> I do here, tho in that case, striping won't necessarily help a lot
> either).
> 
> If you're concerned about getting the last bit of performance
> possible, I'd say raid10, tho over the gigabit ethernet, the
> difference isn't likely to be much.

If performance is an issue, I suggest putting an SSD and bcache into
the equation. I have very nice performance improvements with that,
especially with writeback caching (random write go to bcache first,
then to harddisk in background idle time).

Apparently, afaik it's currently not possible to have native bcache
redundandancy yet - so bcache can only be one SSD. It may be possible
to use two bcaches and assign the btrfs members alternating to it - tho
btrfs may decide to put two mirrors on the same bcache then. On the
other side, you could put bcache on lvm oder mdraid - but I would not
do it. On the bcache list, multiple people had problems with that
including btrfs corruption beyond repair.

On the other hand, you could simply go with bcache writearound caching
(only reads become cached) or writethrough caching (writes go in
parallel to bcache and btrfs). If the SSD dies, btrfs will still be
perfectly safe in this case.

If you are going with one of the latter options, the tuning knobs of
bcache may help you actually cache not only random accesses to bcache
but also linear accesses. It should help to saturate a gigabit link.

Currently, SANdisk offers a pretty cheap (not top performance) drive
with 500GB which should perfectly cover this usecase. Tho, I'm not sure
how stable this drive works with bcache. I only checked Crucial MX100
and Samsung Evo 840 yet - both working very stable with latest kernel
and discard enabled, no mdraid or lvm involved.

-- 
Regards,
Kai

Replies to list-only preferred.

