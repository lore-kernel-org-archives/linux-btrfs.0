Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33736 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeHQPBR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 11:01:17 -0400
Received: by mail-io0-f174.google.com with SMTP id z20-v6so6705271iol.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Aug 2018 04:58:06 -0700 (PDT)
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
To: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
References: <2331408.nK7QgfhVWv@merkaba>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5591e89c-eb89-dc48-1dc6-dc46775c7817@gmail.com>
Date: Fri, 17 Aug 2018 07:58:00 -0400
MIME-Version: 1.0
In-Reply-To: <2331408.nK7QgfhVWv@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-17 05:08, Martin Steigerwald wrote:
> Hi!
> 
> This happened about two weeks ago. I already dealt with it and all is
> well.
> 
> Linux hung on suspend so I switched off this ThinkPad T520 forcefully.
> After that it did not boot the operating system anymore. Intel SSD 320,
> latest firmware, which should patch this bug, but apparently does not,
> is only 8 MiB big. Those 8 MiB just contain zeros.
> 
> Access via GRML and "mount -fo degraded" worked. I initially was even
> able to write onto this degraded filesystem. First I copied all data to
> a backup drive.
> 
> I even started a balance to "single" so that it would work with one SSD.
> 
> But later I learned that secure erase may recover the Intel SSD 320 and
> since I had no other SSD at hand, did that. And yes, it did. So I
> canceled the balance.
> 
> I partitioned the Intel SSD 320 and put LVM on it, just as I had it. But
> at that time I was not able to mount the degraded BTRFS on the other SSD
> as writable anymore, not even with "-f" "I know what I am doing". Thus I
> was not able to add a device to it and btrfs balance it to RAID 1. Even
> "btrfs replace" was not working.
> 
> I thus formatted a new BTRFS RAID 1 and restored.
> 
> A week later I migrated the Intel SSD 320 to a Samsung 860 Pro. Again
> via one full backup and restore cycle. However, this time I was able to
> copy most of the data of the Intel SSD 320 with "mount -fo degraded" via
> eSATA and thus the copy operation was way faster.
> 
> So conclusion:
> 
> 1. Pro: BTRFS RAID 1 really protected my data against a complete SSD
> outage.
Glad to hear I'm not the only one!
> 
> 2. Con:  It does not allow me to add a device and balance to RAID 1 or
> replace one device that is already missing at this time.
See below where you comment about this more, I've replied regarding it 
there.
> 
> 3. I keep using BTRFS RAID 1 on two SSDs for often changed, critical
> data.
> 
> 4. And yes, I know it does not replace a backup. As it was holidays and
> I was lazy backup was two weeks old already, so I was happy to have all
> my data still on the other SSD.
> 
> 5. The error messages in kernel when mounting without "-o degraded" are
> less than helpful. They indicate a corrupted filesystem instead of just
> telling that one device is missing and "-o degraded" would help here.
Agreed, the kernel error messages need significant improvement, not just 
for this case, but in general (I would _love_ to make sure that there 
are exactly zero exit paths for open_ctree that don't involve a proper 
error message being printed beyond the ubiquitous `open_ctree failed` 
message you get when it fails).
> 
> 
> I have seen a discussion about the limitation in point 2. That allowing
> to add a device and make it into RAID 1 again might be dangerous, cause
> of system chunk and probably other reasons. I did not completely read
> and understand it tough.
> 
> So I still don´t get it, cause:
> 
> Either it is a RAID 1, then, one disk may fail and I still have *all*
> data. Also for the system chunk, which according to btrfs fi df / btrfs
> fi sh was indeed RAID 1. If so, then period. Then I don´t see why it
> would need to disallow me to make it into an RAID 1 again after one
> device has been lost.
> 
> Or it is no RAID 1 and then what is the point to begin with? As I was
> able to copy of all date of the degraded mount, I´d say it was a RAID 1.
> 
> (I know that BTRFS RAID 1 is not a regular RAID 1 anyway, but just does
> two copies regardless of how many drives you use.)
So, what's happening here is a bit complicated.  The issue is entirely 
with older kernels that are missing a couple of specific patches, but it 
appears that not all distributions have their kernels updated to include 
those patches yet.

In short, when you have a volume consisting of _exactly_ two devices 
using raid1 profiles that is missing one device, and you mount it 
writable and degraded on such a kernel, newly created chunks will be 
single-profile chunks instead of raid1 chunks with one half missing. 
Any write has the potential to trigger allocation of a new chunk, and 
more importantly any _read_ has the potential to trigger allocation of a 
new chunk if you don't use the `noatime` mount option (because a read 
will trigger an atime update, which results in a write).

When older kernels then go and try to mount that volume a second time, 
they see that there are single-profile chunks (which can't tolerate 
_any_ device failures), and refuse to mount at all (because they can't 
guarantee that metadata is intact).  Newer kernels fix this part by 
checking per-chunk if a chunk is degraded/complete/missing, which avoids 
this because all the single chunks are on the remaining device.

As far as avoiding this in the future:

* If you're just pulling data off the device, mark the device read-only 
in the _block layer_, not the filesystem, before you mount it.  If 
you're using LVM, just mark the LV read-only using LVM commands  This 
will make 100% certain that nothing gets written to the device, and thus 
makes sure that you won't accidentally cause issues like this.
* If you're going to convert to a single device, just do it and don't 
stop it part way through.  In particular, make sure that your system 
will not lose power.
* Otherwise, don't mount the volume unless you know you're going to 
repair it.
> 
> 
> For this laptop it was not all that important but I wonder about BTRFS
> RAID 1 in enterprise environment, cause restoring from backup adds a
> significantly higher downtime.
> 
> Anyway, creating a new filesystem may have been better here anyway,
> cause it replaced an BTRFS that aged over several years with a new one.
> Due to the increased capacity and due to me thinking that Samsung 860
> Pro compresses itself, I removed LZO compression. This would also give
> larger extents on files that are not fragmented or only slightly
> fragmented. I think that Intel SSD 320 did not compress, but Crucial
> m500 mSATA SSD does. That has been the secondary SSD that still had all
> the data after the outage of the Intel SSD 320.
First off, keep in mind that the SSD firmware doing compression only 
really helps with wear-leveling.  Doing it in the filesystem will help 
not only with that, but will also give you more space to work with.

Secondarily, keep in mind that most SSD's use compression algorithms 
that are fast, but don't generally get particularly amazing compression 
ratios (think LZ4 or Snappy for examples of this).  In comparison, BTRFS 
provides a couple of options that are slower, but get far better ratios 
most of the time (zlib, and more recently zstd, which is actually pretty 
fast).
> 
> 
> Overall I am happy, cause BTRFS RAID 1 gave me access to the data after
> the SSD outage. That is the most important thing about it for me.
