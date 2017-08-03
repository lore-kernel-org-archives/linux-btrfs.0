Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39993 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdHCDso (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 23:48:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dd77k-0004Vb-OZ
        for linux-btrfs@vger.kernel.org; Thu, 03 Aug 2017 05:48:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Massive loss of disk space
Date: Thu, 3 Aug 2017 03:48:29 +0000 (UTC)
Message-ID: <pan$5725a$55de2372$c6dc24b7$520ac328@cox.net>
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
        <20170801122039.GX7140@carfax.org.uk>
        <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
        <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
        <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
        <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Wed, 02 Aug 2017 19:52:30 +0200 as
excerpted:

> it seems that BTRFS always allocate the maximum space required, without
> consider the one already allocated. Is it too conservative ? I think no:
> consider the following scenario:
> 
> a) create a 2GB file
> b) fallocate -o 1GB -l 2GB
> c) write from 1GB to 3GB
> 
> after b), the expectation is that c) always succeed [1]: i.e. there is
> enough space on the filesystem. Due to the COW nature of BTRFS, you
> cannot rely on the already allocated space because there could be a
> small time window where both the old and the new data exists on the
> disk.

Not only a small time, perhaps (effectively) permanently, due to either 
of two factors:

1) If the existing extents are reflinked by snapshots or other files they 
obviously won't be released at all when the overwrite is completed.  
fallocate must account for this possibility, and behaving differently in 
the context of other reflinks would be confusing, so the best policy is 
consistently behave as if the existing data will not be freed.

2) As the devs have commented a number of times, an extent isn't freed if 
there's still a reflink to part of it.  If the original extent was a full 
1 GiB data chunk (the chunk being the max size of a native btrfs extent, 
one of the reasons a balance and defrag after conversion from ext4 and 
deletion of the ext4-saved subvolume is recommended, to break up the 
longer ext4 extents so they won't cause btrfs problems later) and all but 
a single 4 KiB block has been rewritten, the full 1 GiB extent will 
remain referenced and continue to take that original full 1 GiB space, 
*plus* the space of all the new-version extents of the overwritten data, 
of course.

So in our fallocate and overwrite scenario, we again must reserve space 
for two copies of the data, the original which may well not be freed even 
without other reflinks, if a single 4 KiB block of an extent remains 
unoverwritten, and the new version of the data.

At least that /was/ the behavior explained on-list previous to the hole-
punching changes.  I'm not a dev and haven't seen a dev comment on 
whether that remains the behavior after hole-punching, which may at least 
naively be expected to automatically handle and free overwritten data 
using hole-punching, or not.  I'd be interested in seeing someone who can 
read the code confirm one way or the other whether hole-punching changed 
that previous behavior, or not.
 
> My opinion is that in general this behavior is correct due to the COW
> nature of BTRFS.
> The only exception that I can find, is about the "nocow" file. For these
> cases taking in accout the already allocated space would be better.

I'd say it's dangerously optimistic even then, considering that "nocow" 
is actually "cow1" in the presence of snapshots.


Meanwhile, it's worth keeping in mind that it's exactly these sorts of 
corner-cases that are why btrfs is taking so long to stabilize.  
Supposedly "simple" expectations aren't always so simple, and if a 
filesystem gets it wrong, it's somebody's data hanging in the balance!  
(Tho if they've any wisdom at all, they'll ensure they're aware of the 
stability status of a filesystem before they put data on it, and will 
adjust their backup policies accordingly if they're using a still not 
fully stabilized filesystem such as btrfs, so the data won't actually be 
in any danger anyway unless it was literally throw-away value, only 
whatever specific instance of it was involved in that corner-case.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

