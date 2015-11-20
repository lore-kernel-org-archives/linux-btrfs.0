Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback6.mail.ru ([94.100.181.147]:36909 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbKTOp2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 09:45:28 -0500
Received: from smtp3.mail.ru (smtp3.mail.ru [94.100.179.58])
	by fallback6.mail.ru (mPOP.Fallback_MX) with ESMTP id 6EF71181601C
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 17:24:49 +0300 (MSK)
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:55190 helo=centurion)
	by smtp3.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1ZzmcI-0002Ro-6I
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 17:24:46 +0300
Received: from [127.0.0.1] (localhost [IPv6:::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id 627EF48827E
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 15:24:44 +0100 (CET)
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: linux-btrfs@vger.kernel.org
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk> <564E085C.3060208@gmail.com>
 <20151119182850.GE24333@carfax.org.uk> <564E18B9.2020509@gmail.com>
 <20151119185645.GF24333@carfax.org.uk>
 <pan$7f2a7$22f8253d$ae640ac3$36e4e58d@cox.net>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <564F2D65.7050307@mail.ru>
Date: Fri, 20 Nov 2015 15:25:41 +0100
MIME-Version: 1.0
In-Reply-To: <pan$7f2a7$22f8253d$ae640ac3$36e4e58d@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Many thanks to Duncan for such a verbose clarification. I am thinking
about another parallel similar to SimSity, and that is memory management
in virtual machines like Java. If heap is full, it does not really mean
that there is no free memory. In this case JVM forces garbage collector
and if after that procedure no memory was released, then it signals this
to application by raising OutOfMemoryError.

I think the similar should happen in btrfs: ENOSPC is returned to
application only when there is really no space left. If no chunk can be
further allocated, btrfs should check all "deleted" data chunks and and
return them to unallocated pool. I would expect this automatic "cleanup"
from modern filesystem.

This behaviour not necessarily should be a default one, as one can argue
that:
* Such cleanup procedure may freeze the calling process for a
considerable time, as btrfs would need to walk all allocated chunks to
find candidates for release.
* Filesystem will perhaps anyway run of free space soon, so why not to
fallback with error earlier? (for example, one process is intensively
writing the log)

It would be nice to have the automatic "cleanup" function controlled by
some /sys/fs/btrfs/features variable, which if set to 1, forces btrfs to
do its best to allocate the chunk before giving up and returning ENOSPC,
sacrificing response time of the process/application.

On 2015-11-20 04:14, Duncan wrote:
> linux-btrfs.tebulin posted on Thu, 19 Nov 2015 18:56:45 +0000 as
> excerpted:
> 
> Meta-comment:
> 
> Apparently that attribution should actually be to Hugo Mills.  I've no 
> idea what went wrong, but at least here as received from gmane.org, the 
> from header really does say linux-btrfs.tebulin, so something obviously 
> bugged out somewhere!
> 
> 
> Meanwhile discussing btrfs data/metadata allocation, vs. usage of that 
> allocation, Hugo also known here as tebulin, explained...
> 
>> If you've ever played SimCity, the allocation process is like zoning --
>> you say what kind of thing can go on the space, but it's not actually
>> used until something gets built on it.
> 
> Very nice analogy.  Thanks. =:^)
> 
> Tho I'd actually put it in terms of the real thing that sim city 
> simulates, thus eliminating the proprietary comparison.  A city zones an 
> area one way or another, restricting what can be built there -- you can't 
> put heavy industry in a residential zone.  But the lot is still empty 
> until something's actually built there.
> 
> And if the city has all its area zoned residential, and some company 
> wants to build a plant there (generally considered a good thing as it'll 
> provide employment), there's a process that allows rezoning.
> 
> In btrfs, there's four types of allocations aka "zones":
> 
> 1) Unallocated (unzoned)
> 
> Can be used for anything but must be allocated/zoned first
> 
> 2) System
> 
> Critical but limited in size and generally only allocated at mkfs or when 
> adding a new device.
> 
> 3) Data
> 
> The actual file storage, generally the largest allocation.
> 
> 4) Metadata
> 
> Information /about/ the files, where they are located (the location and 
> size of individual extents), ownership and permissions, date stamps, 
> checksums, and for very small files (a few KiB), sometimes the file 
> content itself.
> 
> 4a) Global reserve
> 
> A small part of metadata reserved for emergency use only.  Btrfs is 
> pretty strict about its use, and will generally error out with ENOSPC if 
> metadata space other than the global reserve is used up, before actually 
> using this global reserve.  As a result, any of the global reserve used 
> at all indicates a filesystem in very severe straits, crisis mode.
> 
> 
> As it happens, btrfs in practice tends to be a bit liberal about 
> allocating/zoning data chunks, since it's easier to find bigger blocks of 
> space in unallocated space than it is in busy partly used data space.  
> (Think of a big shopping center.  It's easier to build it in outlying 
> areas that haven't been built up yet, where many whole blocks worth of 
> space can be allocated/zoned at once, than it is in the city center, 
> where even finding a single whole block vacant, is near impossible.)
> 
> Over time, therefore, more and more space tends to be allocated to data, 
> while existing data space, like those blocks near city center, may have 
> most of its files/buildings deleted, but still have a couple still 
> occupied.
> 
> Btrfs balancing, then, is comparable to the city functions of 
> condemnation and rezoning to vacant/unallocated, forcing remaining 
> occupants, most commonly data zoned, to move out of the way so the area 
> can be reclaimed for other usage.  Then it can be rezoned to data again, 
> or to metadata, whatever needs it.
> 
> 
> (FWIW, I played the original sim city, but IIRC it wasn't sophisticated 
> enough to have zoning yet.  Of course I've not played anything recent as 
> to my knowledge it's not freedomware, and since I no longer agree to 
> waive rights via EULA, etc, I can no longer legally install and run such 
> things.  But the real life sim city simulates, is the antitype behind 
> both that simulation, and the analogy I drew here, based on the one you 
> drew to the simulation.)
> 


-- 
With best regards,
Dmitry
