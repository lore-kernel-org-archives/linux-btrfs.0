Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:45200 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab2J1TGZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 15:06:25 -0400
Date: Sun, 28 Oct 2012 19:06:01 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Message-ID: <20121028190601.GJ2381@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <201210281133.10571.Martin@lichtvoll.de>
 <508D0FC5.1020404@inwind.it>
 <201210281216.43983.Martin@lichtvoll.de>
 <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <017607D1-1C4E-47A9-9308-FFEB5737B440@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 Oct 2012 12:27 -0600, from lists@colorremedies.com (Chris Murphy):
> I think we're all trained to see file size as absolute, even when
> the file is in effect duplicated. I think it's possible we need to
> be retrained to look at this from a storage point of view. The
> storage "pool" is 200GB in size, and data allocation is 2x in raid1.
> I find new users intuit this, rather than thinking the file size is
> no different, there in a sense no second copy, but the file system
> is half the size. With conventional raid, this logic sorta works
> because the raid isn't a file system, so the filesystem really
> wasn't twice the size. But in btrfs it is. Same for ZFS for that
> matter.

This makes a valid point. And there's another issue potentially at
play: file system level compression, _which btrfs already supports_.
Say you store a highly compressible file (a web server access log,
perhaps) on a compressed volume that is set up with RAID 1 across a
set of physical drives. You know the pool size, and you know the data
allocation ratio. What you _don't_ know and can't predict is the
_compression_ ratio for any new data, which means that you still can't
calculate how much more payload data can be added to the file before
you run out of storage space. You _can_ calculate a worst case
scenario figure (no compression possible on the new payload data), but
that's about it.

_However_, while thinking in terms of storage pool sizes, allocation
ratios and so forth might work for technically inclined people, I'm
not so sure it'll work for ordinary users. But then again:

* How many ordinary users are going to use multi-device file systems
  in the first place? Most ordinary users I know have only a single
  internal disk for primary storage. Even the tiny subset of those who
  use Linux aren't magically going to add several disks to their PCs
  to create a storage pool encompassing multiple physical devices just
  because the file system supports it.

* "btrfs" _is_ the file system administration tool. In a way, it makes
  sense that the data provided by it will be geared more toward
  technically minded people.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
