Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52321 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdBDVLD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Feb 2017 16:11:03 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ca7bi-0003nN-0A
        for linux-btrfs@vger.kernel.org; Sat, 04 Feb 2017 22:10:54 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Very slow balance / btrfs-transaction
Date: Sat, 4 Feb 2017 22:10:51 +0100
Message-ID: <20170204221051.664ada65@jupiter.sol.kaishome.de>
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
        <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
        <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
        <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
        <1f5f66cfa8eca19b7e612e3b4745d788@85337f6d4fa4>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 04 Feb 2017 20:50:03 +0000
schrieb "Jorg Bornschein" <jb@capsec.org>:

> February 4, 2017 1:07 AM, "Goldwyn Rodrigues" <rgoldwyn@suse.de>
> wrote:
> 
> > Yes, please check if disabling quotas makes a difference in
> > execution time of btrfs balance.  
> 
> Just FYI: With quotas disabled it took ~20h to finish the balance
> instead of the projected >30 days. Therefore, in my case, there was a
> speedup of factor ~35.
> 
> 
> and thanks for the quick reply! (and for btrfs general!)
> 
> 
> BTW: I'm wondering how much sense it makes to activate the underlying
> bcache for my raid1 fs again. I guess btrfs chooses randomly (or
> based predicted of disk latency?) which copy of a given extend to
> load?

As far as I know, it uses PID modulo only currently, no round-robin,
no random value. There are no performance optimizations going into btrfs
yet because there're still a lot of ongoing feature implementations.

I think there were patches to include a rotator value in the stripe
selection. They don't apply to the current kernel. I tried it once and
didn't see any subjective difference for normal desktop workloads. But
that's probably because I use RAID1 for metadata only.

MDRAID uses stripe selection based on latency and other measurements
(like head position). It would be nice if btrfs implemented similar
functionality. This would also be helpful for selecting a disk if
there're more disks than stripesets (for example, I have 3 disks in my
btrfs array). This could write new blocks to the most idle disk always.
I think this wasn't covered by the above mentioned patch. Currently,
selection is based only on the disk with most free space.

> I guess that would mean the effective cache size would only be
> half of the actual cache-set size (+-additional overhead)? Or does
> btrfs try a deterministically determined copy of each extend first? 

I'm currently using 500GB bcache, it helps a lot during system start -
and probably also while using using the system. I think that bcache
mostly caches metadata access which should improve a lot of btrfs
performance issues. The downside of RAID1 profile is, that probably
every second access is a cache-miss unless it has already been cached.
Thus, it's only half-effective as it could be.

I'm using write-back bcache caching, and RAID0 for data (I do daily
backups with borgbackup, I can easily recover broken files). So
writing with bcache is not such an issue for me. The cache is big
enough that double metadata writes are no problem.


-- 
Regards,
Kai

Replies to list-only preferred.

