Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46350 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaESU7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 16:59:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WmUIG-000543-M2
	for linux-btrfs@vger.kernel.org; Mon, 19 May 2014 22:36:20 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 22:36:20 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 22:36:20 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: ditto blocks on ZFS
Date: Mon, 19 May 2014 21:36:06 +0100
Message-ID: <lldpvm$s7c$1@ger.gmane.org>
References: <2308735.51F3c4eZQ7@xev> <ll7lvd$ulk$1@ger.gmane.org> <10946613.XrCytCZfuu@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <10946613.XrCytCZfuu@xev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/05/14 17:09, Russell Coker wrote:
> On Sat, 17 May 2014 13:50:52 Martin wrote:
[...]
>> Do you see or measure any real advantage?
> 
> Imagine that you have a RAID-1 array where both disks get ~14,000 read errors.  
> This could happen due to a design defect common to drives of a particular 
> model or some shared environmental problem.  Most errors would be corrected by 
> RAID-1 but there would be a risk of some data being lost due to both copies 
> being corrupt.  Another possibility is that one disk could entirely die 
> (although total disk death seems rare nowadays) and the other could have 
> corruption.  If metadata was duplicated in addition to being on both disks 
> then the probability of data loss would be reduced.
> 
> Another issue is the case where all drive slots are filled with active drives 
> (a very common configuration).  To replace a disk you have to physically 
> remove the old disk before adding the new one.  If the array is a RAID-1 or 
> RAID-5 then ANY error during reconstruction loses data.  Using dup for 
> metadata on top of the RAID protections (IE the ZFS ditto idea) means that 
> case doesn't lose you data.

Your example there is for the case where in effect there is no RAID. How
is that case any better than what is already done for btrfs duplicating
metadata?



So...


What real-world failure modes do the ditto blocks usefully protect against?

And how does that compare for failure rates and against what is already
done?


For example, we have RAID1 and RAID5 to protect against any one RAID
chunk being corrupted or for the total loss of any one device.

There is a second part to that in that another failure cannot be
tolerated until the RAID is remade.


Hence, we have RAID6 that protects against any two failures for a chunk
or device. Hence with just one failure, you can tolerate a second
failure whilst rebuilding the RAID.


And then we supposedly have safety-by-design where the filesystem itself
is using a journal and barriers/sync to ensure that the filesystem is
always kept in a consistent state, even after an interruption to any writes.


*What other failure modes* should we guard against?


There has been mention of fixing metadata keys from single bit flips...

Should hamming codes be used instead of a crc so that we can have
multiple bit error detect, single bit error correct functionality for
all data both in RAM and on disk for those systems that do not use ECC RAM?

Would that be useful?...


Regards,
Martin

