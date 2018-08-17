Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:47004 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbeHQP6n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 11:58:43 -0400
Received: by mail-io0-f177.google.com with SMTP id x5-v6so6787023iop.13
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Aug 2018 05:55:22 -0700 (PDT)
Subject: Re: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
References: <2331408.nK7QgfhVWv@merkaba>
 <5591e89c-eb89-dc48-1dc6-dc46775c7817@gmail.com> <1598008.Z1BGxZKWFL@merkaba>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <06e2c72d-8c46-e8a1-b371-6477e2d01d71@gmail.com>
Date: Fri, 17 Aug 2018 08:55:17 -0400
MIME-Version: 1.0
In-Reply-To: <1598008.Z1BGxZKWFL@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-17 08:28, Martin Steigerwald wrote:
> Thanks for your detailed answer.
> 
> Austin S. Hemmelgarn - 17.08.18, 13:58:
>> On 2018-08-17 05:08, Martin Steigerwald wrote:
> […]
>>> I have seen a discussion about the limitation in point 2. That
>>> allowing to add a device and make it into RAID 1 again might be
>>> dangerous, cause of system chunk and probably other reasons. I did
>>> not completely read and understand it tough.
>>>
>>> So I still don´t get it, cause:
>>>
>>> Either it is a RAID 1, then, one disk may fail and I still have
>>> *all*
>>> data. Also for the system chunk, which according to btrfs fi df /
>>> btrfs fi sh was indeed RAID 1. If so, then period. Then I don´t see
>>> why it would need to disallow me to make it into an RAID 1 again
>>> after one device has been lost.
>>>
>>> Or it is no RAID 1 and then what is the point to begin with? As I
>>> was
>>> able to copy of all date of the degraded mount, I´d say it was a
>>> RAID 1.
>>>
>>> (I know that BTRFS RAID 1 is not a regular RAID 1 anyway, but just
>>> does two copies regardless of how many drives you use.)
>>
>> So, what's happening here is a bit complicated.  The issue is entirely
>> with older kernels that are missing a couple of specific patches, but
>> it appears that not all distributions have their kernels updated to
>> include those patches yet.
>>
>> In short, when you have a volume consisting of _exactly_ two devices
>> using raid1 profiles that is missing one device, and you mount it
>> writable and degraded on such a kernel, newly created chunks will be
>> single-profile chunks instead of raid1 chunks with one half missing.
>> Any write has the potential to trigger allocation of a new chunk, and
>> more importantly any _read_ has the potential to trigger allocation of
>> a new chunk if you don't use the `noatime` mount option (because a
>> read will trigger an atime update, which results in a write).
>>
>> When older kernels then go and try to mount that volume a second time,
>> they see that there are single-profile chunks (which can't tolerate
>> _any_ device failures), and refuse to mount at all (because they
>> can't guarantee that metadata is intact).  Newer kernels fix this
>> part by checking per-chunk if a chunk is degraded/complete/missing,
>> which avoids this because all the single chunks are on the remaining
>> device.
> 
> How new the kernel needs to be for that to happen?
> 
> Do I get this right that it would be the kernel used for recovery, i.e.
> the one on the live distro that needs to be new enough? To one on this
> laptop meanwhile is already 4.18.1.
Yes, the kernel used for recovery is the important one here.  I don't 
remember for certain when the patches went in, but I'm pretty sure it's 
been no eariler than 4.14.  FWIW, I'm pretty sure SystemRescueCD has a 
new enough kernel, but they still (sadly) lack zstd support.
> 
> I used latest GRML stable release 2017.05 which has an 4.9 kernel.
While I don't know exactly when the patches went in, I'm fairly certain 
that 4.9 never got them.
> 
>> As far as avoiding this in the future:
> 
> I hope that with the new Samsung Pro 860 together with the existing
> Crucial m500 I am spared from this for years to come. That Crucial SSD
> according to SMART status about lifetime used has still quite some time
> to go.
Yes, hopefully.  And the SMART status on that Crucial is probably right, 
they tend to do a very good job in my experience with accurately 
measuring life expectancy (that or they're just _really_ good at 
predicting failures, I've never had a Crucial SSD that did not indicate 
correctly in the SMART status that it would fail in the near future).
> 
>> * If you're just pulling data off the device, mark the device
>> read-only in the _block layer_, not the filesystem, before you mount
>> it.  If you're using LVM, just mark the LV read-only using LVM
>> commands  This will make 100% certain that nothing gets written to
>> the device, and thus makes sure that you won't accidentally cause
>> issues like this.
> 
>> * If you're going to convert to a single device,
>> just do it and don't stop it part way through.  In particular, make
>> sure that your system will not lose power.
> 
>> * Otherwise, don't mount the volume unless you know you're going to
>> repair it.
> 
> Thanks for those. Good to keep in mind.
The last one is actually good advice in general, not just for BTRFS.  I 
can't count how many stories I've heard of people who tried to run half 
an array simply to avoid downtime, and ended up making things far worse 
than they were as a result.
> 
>>> For this laptop it was not all that important but I wonder about
>>> BTRFS RAID 1 in enterprise environment, cause restoring from backup
>>> adds a significantly higher downtime.
>>>
>>> Anyway, creating a new filesystem may have been better here anyway,
>>> cause it replaced an BTRFS that aged over several years with a new
>>> one. Due to the increased capacity and due to me thinking that
>>> Samsung 860 Pro compresses itself, I removed LZO compression. This
>>> would also give larger extents on files that are not fragmented or
>>> only slightly fragmented. I think that Intel SSD 320 did not
>>> compress, but Crucial m500 mSATA SSD does. That has been the
>>> secondary SSD that still had all the data after the outage of the
>>> Intel SSD 320.
>>
>> First off, keep in mind that the SSD firmware doing compression only
>> really helps with wear-leveling.  Doing it in the filesystem will help
>> not only with that, but will also give you more space to work with.
> 
> While also reducing the ability of the SSD to wear-level. The more data
> I fit on the SSD, the less it can wear-level. And the better I compress
> that data, the less it can wear-level.
No, the better you compress the data, the _less_ data you are physically 
putting on the SSD, just like compressing a file makes it take up less 
space.  This actually makes it easier for the firmware to do 
wear-leveling.  Wear-leveling is entirely about picking where to put 
data, and by reducing the total amount of data you are writing to the 
SSD, you're making that decision easier for the firmware, and also 
reducing the number of blocks of flash memory needed (which also helps 
with SSD life expectancy because it translates to fewer erase cycles).

The compression they do internally operates on the same principal, the 
only difference is that you have no control over how it's doing it and 
no way to see exactly how efficient it is (but it's pretty well known it 
needs to be fast, and fast compression usually does not get good 
compression ratios).
> 
>> Secondarily, keep in mind that most SSD's use compression algorithms
>> that are fast, but don't generally get particularly amazing
>> compression ratios (think LZ4 or Snappy for examples of this).  In
>> comparison, BTRFS provides a couple of options that are slower, but
>> get far better ratios most of the time (zlib, and more recently zstd,
>> which is actually pretty fast).
> 
> I considered switching to zstd. But it may not be compatible with grml
> 2017.05 4.9 kernel, of course I could test a grml snapshot with a newer
> kernel. I always like to be able to recover with some live distro :).
> And GRML is the one of my choice.
> 
> However… I am not all that convinced that it would benefit me as long as
> I have enough space. That SSD replacement more than doubled capacity
> from about 680 TB to 1480 TB. I have ton of free space in the
> filesystems – usage of /home is only 46% for example – and there are 96
> GiB completely unused in LVM on the Crucial SSD and even more than 183
> GiB completely unused on Samsung SSD. The system is doing weekly
> "fstrim" on all filesystems. I think that this is more than is needed
> for the longevity of the SSDs, but well actually I just don´t need the
> space, so…
> 
> Of course, in case I manage to fill up all that space, I consider using
> compression. Until then, I am not all that convinced that I´d benefit
> from it.
> 
> Of course it may increase read speeds and in case of nicely compressible
> data also write speeds, I am not sure whether it even matters. Also it
> uses up some CPU cycles on a dual core (+ hyperthreading) Sandybridge
> mobile i5. While I am not sure about it, I bet also having larger
> possible extent sizes may help a bit. As well as no compression may also
> help a bit with fragmentation.
It generally does actually. Less data physically on the device means 
lower chances of fragmentation.  In your case, it may not improve speed 
much though (your i5 _probably_ can't compress data much faster than it 
can access your SSD's, which means you likely won't see much performance 
benefit other than reducing fragmentation).
> 
> Well putting this to a (non-scientific) test:
> 
> […]/.local/share/akonadi/db_data/akonadi> du -sh * | sort -rh | head -5
> 3,1G    parttable.ibd
> 
> […]/.local/share/akonadi/db_data/akonadi> filefrag parttable.ibd
> parttable.ibd: 11583 extents found
> 
> Hmmm, already quite many extents after just about one week with the new
> filesystem. On the old filesystem I had somewhat around 40000-50000
> extents on that file.
Filefrag doesn't properly handle compressed files on BTRFS.  It treats 
each 128KiB compression block as a separate extent, even though they may 
be contiguous as part of one BTRFS extent.  That one file by itself 
should have reported as about 25396 extents on the old volume (assuming 
it was entirely compressed), so your numbers seem to match up 
realistically.>
> 
> Well actually what do I know: I don´t even have an idea whether not
> using compression would be beneficial. Maybe it does not even matter all
> that much.
> 
> I bet testing it to the point that I could be sure about it for my
> workload would take considerable amount of time.
> 
One last quick thing about compression in general on BTRFS.  Unless you 
have a lot of files that are likely to be completely incompressible, 
you're generally better off using `compress-force` instead of 
`compress`.  With regular `compress`, BTRFS will try to compress the 
first few blocks of a file, and if that fails will mark the file as 
incompressible and not try to compress any of it automatically ever 
again.  With `compress-force`, BTRFS will just unconditionally compress 
everything.
