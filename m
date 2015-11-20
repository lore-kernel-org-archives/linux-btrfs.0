Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59328 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbbKTDOw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:14:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zzc9w-0007Wl-Dd
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 04:14:48 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 04:14:48 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 04:14:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Date: Fri, 20 Nov 2015 03:14:38 +0000 (UTC)
Message-ID: <pan$7f2a7$22f8253d$ae640ac3$36e4e58d@cox.net>
References: <564CC90F.3060703@gmail.com>
	<20151118190857.GY24333@carfax.org.uk> <564E085C.3060208@gmail.com>
	<20151119182850.GE24333@carfax.org.uk> <564E18B9.2020509@gmail.com>
	<20151119185645.GF24333@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

linux-btrfs.tebulin posted on Thu, 19 Nov 2015 18:56:45 +0000 as
excerpted:

Meta-comment:

Apparently that attribution should actually be to Hugo Mills.  I've no 
idea what went wrong, but at least here as received from gmane.org, the 
from header really does say linux-btrfs.tebulin, so something obviously 
bugged out somewhere!


Meanwhile discussing btrfs data/metadata allocation, vs. usage of that 
allocation, Hugo also known here as tebulin, explained...

> If you've ever played SimCity, the allocation process is like zoning --
> you say what kind of thing can go on the space, but it's not actually
> used until something gets built on it.

Very nice analogy.  Thanks. =:^)

Tho I'd actually put it in terms of the real thing that sim city 
simulates, thus eliminating the proprietary comparison.  A city zones an 
area one way or another, restricting what can be built there -- you can't 
put heavy industry in a residential zone.  But the lot is still empty 
until something's actually built there.

And if the city has all its area zoned residential, and some company 
wants to build a plant there (generally considered a good thing as it'll 
provide employment), there's a process that allows rezoning.

In btrfs, there's four types of allocations aka "zones":

1) Unallocated (unzoned)

Can be used for anything but must be allocated/zoned first

2) System

Critical but limited in size and generally only allocated at mkfs or when 
adding a new device.

3) Data

The actual file storage, generally the largest allocation.

4) Metadata

Information /about/ the files, where they are located (the location and 
size of individual extents), ownership and permissions, date stamps, 
checksums, and for very small files (a few KiB), sometimes the file 
content itself.

4a) Global reserve

A small part of metadata reserved for emergency use only.  Btrfs is 
pretty strict about its use, and will generally error out with ENOSPC if 
metadata space other than the global reserve is used up, before actually 
using this global reserve.  As a result, any of the global reserve used 
at all indicates a filesystem in very severe straits, crisis mode.


As it happens, btrfs in practice tends to be a bit liberal about 
allocating/zoning data chunks, since it's easier to find bigger blocks of 
space in unallocated space than it is in busy partly used data space.  
(Think of a big shopping center.  It's easier to build it in outlying 
areas that haven't been built up yet, where many whole blocks worth of 
space can be allocated/zoned at once, than it is in the city center, 
where even finding a single whole block vacant, is near impossible.)

Over time, therefore, more and more space tends to be allocated to data, 
while existing data space, like those blocks near city center, may have 
most of its files/buildings deleted, but still have a couple still 
occupied.

Btrfs balancing, then, is comparable to the city functions of 
condemnation and rezoning to vacant/unallocated, forcing remaining 
occupants, most commonly data zoned, to move out of the way so the area 
can be reclaimed for other usage.  Then it can be rezoned to data again, 
or to metadata, whatever needs it.


(FWIW, I played the original sim city, but IIRC it wasn't sophisticated 
enough to have zoning yet.  Of course I've not played anything recent as 
to my knowledge it's not freedomware, and since I no longer agree to 
waive rights via EULA, etc, I can no longer legally install and run such 
things.  But the real life sim city simulates, is the antitype behind 
both that simulation, and the analogy I drew here, based on the one you 
drew to the simulation.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

