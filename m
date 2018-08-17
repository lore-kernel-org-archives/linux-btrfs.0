Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48685 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbeHQPbo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 11:31:44 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
Date: Fri, 17 Aug 2018 14:28:25 +0200
Message-ID: <1598008.Z1BGxZKWFL@merkaba>
In-Reply-To: <5591e89c-eb89-dc48-1dc6-dc46775c7817@gmail.com>
References: <2331408.nK7QgfhVWv@merkaba> <5591e89c-eb89-dc48-1dc6-dc46775c7817@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your detailed answer.  

Austin S. Hemmelgarn - 17.08.18, 13:58:
> On 2018-08-17 05:08, Martin Steigerwald wrote:
[…]
> > I have seen a discussion about the limitation in point 2. That
> > allowing to add a device and make it into RAID 1 again might be
> > dangerous, cause of system chunk and probably other reasons. I did
> > not completely read and understand it tough.
> > 
> > So I still don´t get it, cause:
> > 
> > Either it is a RAID 1, then, one disk may fail and I still have
> > *all*
> > data. Also for the system chunk, which according to btrfs fi df /
> > btrfs fi sh was indeed RAID 1. If so, then period. Then I don´t see
> > why it would need to disallow me to make it into an RAID 1 again
> > after one device has been lost.
> > 
> > Or it is no RAID 1 and then what is the point to begin with? As I
> > was
> > able to copy of all date of the degraded mount, I´d say it was a
> > RAID 1.
> > 
> > (I know that BTRFS RAID 1 is not a regular RAID 1 anyway, but just
> > does two copies regardless of how many drives you use.)
> 
> So, what's happening here is a bit complicated.  The issue is entirely
> with older kernels that are missing a couple of specific patches, but
> it appears that not all distributions have their kernels updated to
> include those patches yet.
> 
> In short, when you have a volume consisting of _exactly_ two devices
> using raid1 profiles that is missing one device, and you mount it
> writable and degraded on such a kernel, newly created chunks will be
> single-profile chunks instead of raid1 chunks with one half missing.
> Any write has the potential to trigger allocation of a new chunk, and
> more importantly any _read_ has the potential to trigger allocation of
> a new chunk if you don't use the `noatime` mount option (because a
> read will trigger an atime update, which results in a write).
> 
> When older kernels then go and try to mount that volume a second time,
> they see that there are single-profile chunks (which can't tolerate
> _any_ device failures), and refuse to mount at all (because they
> can't guarantee that metadata is intact).  Newer kernels fix this
> part by checking per-chunk if a chunk is degraded/complete/missing,
> which avoids this because all the single chunks are on the remaining
> device.

How new the kernel needs to be for that to happen?

Do I get this right that it would be the kernel used for recovery, i.e. 
the one on the live distro that needs to be new enough? To one on this 
laptop meanwhile is already 4.18.1.

I used latest GRML stable release 2017.05 which has an 4.9 kernel.

> As far as avoiding this in the future:

I hope that with the new Samsung Pro 860 together with the existing 
Crucial m500 I am spared from this for years to come. That Crucial SSD 
according to SMART status about lifetime used has still quite some time 
to go.

> * If you're just pulling data off the device, mark the device
> read-only in the _block layer_, not the filesystem, before you mount
> it.  If you're using LVM, just mark the LV read-only using LVM
> commands  This will make 100% certain that nothing gets written to
> the device, and thus makes sure that you won't accidentally cause
> issues like this.

> * If you're going to convert to a single device,
> just do it and don't stop it part way through.  In particular, make
> sure that your system will not lose power.

> * Otherwise, don't mount the volume unless you know you're going to
> repair it.

Thanks for those. Good to keep in mind.

> > For this laptop it was not all that important but I wonder about
> > BTRFS RAID 1 in enterprise environment, cause restoring from backup
> > adds a significantly higher downtime.
> > 
> > Anyway, creating a new filesystem may have been better here anyway,
> > cause it replaced an BTRFS that aged over several years with a new
> > one. Due to the increased capacity and due to me thinking that
> > Samsung 860 Pro compresses itself, I removed LZO compression. This
> > would also give larger extents on files that are not fragmented or
> > only slightly fragmented. I think that Intel SSD 320 did not
> > compress, but Crucial m500 mSATA SSD does. That has been the
> > secondary SSD that still had all the data after the outage of the
> > Intel SSD 320.
> 
> First off, keep in mind that the SSD firmware doing compression only
> really helps with wear-leveling.  Doing it in the filesystem will help
> not only with that, but will also give you more space to work with.

While also reducing the ability of the SSD to wear-level. The more data 
I fit on the SSD, the less it can wear-level. And the better I compress 
that data, the less it can wear-level.

> Secondarily, keep in mind that most SSD's use compression algorithms
> that are fast, but don't generally get particularly amazing
> compression ratios (think LZ4 or Snappy for examples of this).  In
> comparison, BTRFS provides a couple of options that are slower, but
> get far better ratios most of the time (zlib, and more recently zstd,
> which is actually pretty fast).

I considered switching to zstd. But it may not be compatible with grml 
2017.05 4.9 kernel, of course I could test a grml snapshot with a newer 
kernel. I always like to be able to recover with some live distro :). 
And GRML is the one of my choice.

However… I am not all that convinced that it would benefit me as long as 
I have enough space. That SSD replacement more than doubled capacity 
from about 680 TB to 1480 TB. I have ton of free space in the 
filesystems – usage of /home is only 46% for example – and there are 96 
GiB completely unused in LVM on the Crucial SSD and even more than 183 
GiB completely unused on Samsung SSD. The system is doing weekly 
"fstrim" on all filesystems. I think that this is more than is needed 
for the longevity of the SSDs, but well actually I just don´t need the 
space, so… 

Of course, in case I manage to fill up all that space, I consider using 
compression. Until then, I am not all that convinced that I´d benefit 
from it.

Of course it may increase read speeds and in case of nicely compressible 
data also write speeds, I am not sure whether it even matters. Also it 
uses up some CPU cycles on a dual core (+ hyperthreading) Sandybridge 
mobile i5. While I am not sure about it, I bet also having larger 
possible extent sizes may help a bit. As well as no compression may also 
help a bit with fragmentation.

Well putting this to a (non-scientific) test:

[…]/.local/share/akonadi/db_data/akonadi> du -sh * | sort -rh | head -5
3,1G    parttable.ibd

[…]/.local/share/akonadi/db_data/akonadi> filefrag parttable.ibd 
parttable.ibd: 11583 extents found

Hmmm, already quite many extents after just about one week with the new 
filesystem. On the old filesystem I had somewhat around 40000-50000 
extents on that file.


Well actually what do I know: I don´t even have an idea whether not 
using compression would be beneficial. Maybe it does not even matter all 
that much.

I bet testing it to the point that I could be sure about it for my 
workload would take considerable amount of time.

Ciao,
-- 
Martin
