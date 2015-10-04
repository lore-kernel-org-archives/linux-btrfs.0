Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41969 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbbJDUgF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Oct 2015 16:36:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Ziq0o-0005cF-IL
	for linux-btrfs@vger.kernel.org; Sun, 04 Oct 2015 22:36:02 +0200
Received: from 145.132.48.198 ([145.132.48.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 22:36:02 +0200
Received: from ftoth by 145.132.48.198 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 22:36:02 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@exalondelft.nl>
Subject: Re: Excessive slab use deteriorates performance
Date: Sun, 04 Oct 2015 22:35:52 +0200
Message-ID: <mus2j9$qcj$1@ger.gmane.org>
References: <mu61ah$iaa$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:

> On Sat, Sep 26, 2015 at 01:59:13PM +0200, Ferry Toth wrote:
>> Could there be any relation to btrfs causing the mentioned slabs to not
>> be automatically freeed?
>> 
>> In the mean time we put:
>> vfs_cache_pressure = 10000
>> 
>> And this seems to be keeping slabs total at 2.5GB (with btrfs_inode at
>> 1.7GB).
>> 
>> Still, manually doing drop_caches, will reduce slabs total to 0.4GB, with
>> btrfs_inode at 0.01GB.
>> 
>> I'm not sure, but just having a RO operation scanning all files on the
>> disk causing kernel memory to be used to cache things that are almost not
>> used 12 hours later, while keeping more useful file caches from growing,
>> seems not really optimal.
>> 
>> Has anybody else seen this behavior?
> 
> Yes, a friend showed me almost identical situtation some time ago. Slab
> caches full, not reclaimed and dropping caches "fixed" that, likely
> caused by overnight cron jobs. At that time I was interested whether it
> was a leak but if the slab usage dropped and did not debug it further.

In our nightly cron jobs I found locate and mlocate. Now we are suspecting 
locate and removed that - as we understand mlocate should be a more 
efficient replacement for mlocate, so that might have been redundant.

> The sysctl vfs_cache_pressure should help to tune the system. The btrfs
> allocates slabs with the "reclaimable" flag on so there should not be
> any direct obstacle for that so there must be something else going on.

Exactly, as it reclaims without trouble when manually dropping the slabs 
AND 
reclaims better when putting vfs pressure excessively high, there might be 
something wrong either in btrfs or the reclaiming mechanism elsewhere in 
the 
kernel.

But if it is the latter, you would expect ext users to have similar 
troubles, at least with excessive slabs for dentry.

I would like to report this as a bug, but am not sure where to put it.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---
Ferry 

