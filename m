Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:40035 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBMUWG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 15:22:06 -0500
Message-ID: <52FD296F.8050308@libero.it>
Date: Thu, 13 Feb 2014 21:22:07 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jim Salter <jim@jrs-s.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-RAID(3 or 5/6/etc) like btrfs-RAID1?
References: <52FCEF46.3070306@jrs-s.net>
In-Reply-To: <52FCEF46.3070306@jrs-s.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jim,
On 02/13/2014 05:13 PM, Jim Salter wrote:
> This might be a stupid question but...

There is no stupid questions, only stupid answers...

> 
> Are there any plans to make parity RAID levels in btrfs similar to
> the current implementation of btrfs-raid1?
> 
> It took me a while to realize how different and powerful btrfs-raid1
> is from traditional raid1.  The ability to string together virtually
> any combination of "mutt" hard drives together in arbitrary ways and
> yet maintain redundancy is POWERFUL, and is seriously going to be a
> killer feature advancing btrfs adoption in small environments.
> 
> The one real drawback to btrfs-raid1 is that you're committed to n/2
> storage efficiency, since you're using pure redundancy rather than
> parity on the array.  I was thinking about that this morning, and
> suddenly it occurred to me that you ought to be able to create a
> striped parity array in much the same way as a btrfs-raid1 array.
> 
> Let's say you have five disks, and you arbitrarily want to define a
> stripe length of four data blocks plus one parity block per "stripe".

I what it is different from a raid5 setup (which is supported by btrfs)?

> Right now, what you're looking at effectively amounts to a RAID3
> array, like FreeBSD used to use.  But, what if we add two more disks?
> Or three more disks? Or ten more?  Is there any reason we can't keep
> our stripe length of four blocks + one parity block, and just
> distribute them relatively ad-hoc in the same way btrfs-raid1
> distributes redundant data blocks across an ad-hoc array of disks?
> 
> This could be a pretty powerful setup IMO - if you implemented
> something like this, you'd be able to arbitrarily define your storage
> efficiency (percentage of parity blocks / data blocks) and your
> fault-tolerance level (how many drives you can afford to lose before
> failure) WITHOUT tying it directly to your underlying disks

May be that it is a good idea, but which would be the advantage to 
use less drives that the available ones for a RAID ?

Regarding the fault tolerance level, few weeks ago there was a 
posting about a kernel library which would provide a generic
RAID framework capable of several degree of fault tolerance 
(raid 5,6,7...) [give a look to 
"[RFC v4 2/3] fs: btrfs: Extends btrfs/raid56 to 
support up to six parities" 2014/1/25]. This definitely would be a
big leap forward.

BTW, the raid5/raid6 support in BTRFS is only for testing purpose. 
However Chris Mason, told few week ago that he will work on these
issues.

[...]
> necessarily needing to rebalance as you add more disks to the array.
> This would be a heck of a lot more flexible than ZFS' approach of
> adding more immutable vdevs.

There is no needing to re-balance if you add more drives. The next 
chunk allocation will span all the available drives anyway. It is only 
required when you want to spans all data already written on all the drives.

Regards
Goffredo


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
