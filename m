Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43227 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbaLMAul (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 19:50:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xzaut-00083Z-GZ
	for linux-btrfs@vger.kernel.org; Sat, 13 Dec 2014 01:50:39 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 01:50:39 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 01:50:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2 1/3] Btrfs: get more accurate output in df command.
Date: Sat, 13 Dec 2014 00:50:27 +0000 (UTC)
Message-ID: <pan$15017$735d4dc1$40043b93$f0365d23@cox.net>
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>
	<548B2D34.9060509@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Fri, 12 Dec 2014 19:00:20 +0100 as
excerpted:

> $ sudo ./btrfs fi df /mnt/btrfs1/
> Data, RAID1: total=1.00GiB, used=512.00KiB
> Data, single: total=8.00MiB, used=0.00B
> System, RAID1: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=1.00GiB, used=112.00KiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=16.00MiB, used=0.00B
> 
> In this case the filesystem is empty (it was a new filesystem !).
> However a 1G metadata chunk was already allocated. This is the reasons
> why the free space is only 4Gb.

Trivial(?) correction.

Metadata chunks are quarter-gig, not 1 gig.  So that's 4 quarter-gig 
metadata chunks allocated, not a (one/single) 1-gig metadata chunk.

> On my system the ratio metadata/data is 234MB/8.82GB = ~3%, so ignoring
> the metadata chunk from the free space may not be a big problem. 

Presumably your use-case is primarily reasonably large files; too large 
for their data to be tucked directly into metadata instead of allocating 
an extent from a data chunk.

That's not always going to be the case.  And given the multi-device 
default allocation of raid1 metadata, single data, files small enough to 
fit into metadata have a default size effect double their actual size!  
(Tho it can be noted that given btrfs' 4 KiB standard block size, without 
metadata packing there'd still be an outsized effect for files smaller 
than half that, 2 KiB or under, but there it'd be in data chunks, not 
metadata.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

