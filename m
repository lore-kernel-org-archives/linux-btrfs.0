Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48216 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbICCWe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Sep 2015 22:22:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZXKAZ-0006ga-7e
	for linux-btrfs@vger.kernel.org; Thu, 03 Sep 2015 04:22:31 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2015 04:22:31 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2015 04:22:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to properly and efficiently balance RAID6 after more drives
 are added?
Date: Thu, 3 Sep 2015 02:22:23 +0000 (UTC)
Message-ID: <pan$45a25$fd021e31$91d1cbe2$220454a1@cox.net>
References: <55E6CF72.5070005@netcologne.de>
	<20150902113021.GD11358@carfax.org.uk> <55E6F51B.3000007@netcologne.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Rohmann posted on Wed, 02 Sep 2015 15:09:47 +0200 as excerpted:

> Hey Hugo,
> 
> thanks for the quick response.
> 
> On 09/02/2015 01:30 PM, Hugo Mills wrote:
>> You had some data on the first 8 drives with 6 data+2 parity, then
>> added four more. From that point on, you were adding block groups with
>> 10 data+2 parity. At some point, the first 8 drives became full, and
>> then new block groups have been added only to the new drives, using 2
>> data+2 parity.
> 
> Even though the old 8 drive RAID6 was not full yet? Read: There was
> still some terabytes of free space.

At this point we're primarily guessing (unless you want to dive deep into 
btrfs-debug or the like), because the results you posted are from after 
you added the set of four new devices to the existing eight.  We don't 
have the btrfs fi show and df from before you added the new devices.

But what we /do/ know from what you posted (from after the add), the 
previously existing devices are "100% chunk-allocated", size 3.64 TiB, 
used 3.64 TiB, on each of the first eight devices.

I don't know how much of (the user docs on) the wiki you've read, and/or 
understood, but for many people, it takes awhile to really understand a 
few major differences between btrfs and most other filesystems.

1) Btrfs separates data and metadata into separate allocations, 
allocating, tracking and reporting them separately.  While some 
filesystems do allocate separately, few expose the separate data and 
metadata allocation detail to the user.

2) Btrfs allocates and uses space in two steps, first allocating/
reserving relatively large "chunks" from free-space into separate data 
and metadata chunks, then using space from these chunk allocations as 
needed, until they're full and more must be allocated.  Nominal[1] chunk 
size is 1 GiB for data, 256 MiB for metadata.

It's worth noting that for striped raid (with or without parity, so 
raid0,5,6, with parity strips taken from what would be the raid0 strips 
as appropriate), btrfs allocates a full chunk strip on each available 
device, so nominal raid6 strip allocation on eight devices would be a 6 
GiB data plus 2 GiB parity stripe (8x1GiB strips per stripe), while 
metadata would be 1.5 GiB metadata (6x256MiB) plus half a GiB parity 
(2x256MiB) (total of 8x256MiB strips per stripe).

Again, most filesystems don't allocate in chunks like this, at least for 
data (they often will allocate metadata in chunks of some size, in 
ordered to keep it grouped relatively close together, but that level of 
detail isn't show to the user, and because metadata is typically a small 
fraction of data, it can simply be included in the used figure as soon as 
allocated and still disappear in the rounding error).  What they report 
as free space is thus available unallocated space that should, within 
rounding error, be available for data.

3) Up until a few kernel cycles ago, btrfs could and would automatically 
allocate chunks as needed, but wouldn't deallocate them when they 
emptied.  Once they were allocated for data or metadata, that's how they 
stayed allocated, unless/until the user did a balance manually, at which 
point the chunk rewrite would consolidate the used space and free any 
unused chunk-space back to the unallocated space pool.

The result was that given normal usage writing and deleting data, over 
time, all unallocated space would typically end up allocated as data 
chunks, such that at some point the filesystem would run out of metadata 
space and need to allocate more metadata chunks, but couldn't, because of 
all those extra partially to entirely empty data chunks that were 
allocated and never freed.

Since IIRC 3.17 or so (kernel cycle from unverified memory, but that 
should be close), btrfs will automatically deallocate chunks if they're 
left entirely empty, so the problem has disappeared to a large extent, 
tho it's still possible to eventually end up with a bunch of not-quite-
empty data chunks, that require a manual balance to consolidate and clean 
up.

4) Normal df (as opposed to btrfs fi df) will list free space in existing 
data chunks as free, even after all unallocated space is gone and it's 
all allocated to either data or metadata chunks.  At that point, which 
ever one you run out of first, typically metadata, will trigger ENOSPC 
errors, despite df often showing quite some free space left -- because 
all the reported free-space is tied up in data chunks, and there's no 
unallocated space left to allocate to new metadata chunks when the 
existing ones get full.

5) What btrfs fi show reports for "used" in the individual device stats 
is chunk-allocated space.

What your btrfs fi show is saying, is that 100% of the capacity of those 
first eight devices is chunk-allocated, to data or metadata chunks it 
doesn't say, but whichever it is, it's already allocated to one or the 
other, and cannot be reallocated to something else, either a different 
sized stripe after adding the new devices, or to the opposite of data or 
metadata, whichever it is allocated as, until it is rewritten in ordered 
to consolidate all the actually used space into as few chunks as 
possible, thereby freeing the unused but currently chunk-allocated space 
back to the unallocated pool.  This chunk rewrite and consolidation is 
exactly what balance is designed to do.

Again, at this point we're guessing to some extent, based on what's 
reported now, after the addition and evident partial use of the four new 
devices to the existing eight.  Thus we don't know for sure when the 
existing eight devices got fully allocated, whether it was before the 
addition of the new devices or after, but full allocation is definitely 
the state they're in now, according to your posted btrfs fi show.

One plausible guess is as Hugo suggested, that they were mostly but not 
fully allocated before the addition of the new devices, with that data 
written as an 8-strip-stripe (6+2), that after the addition of the four 
new devices, the remaining unallocated space on the original eight was 
then filled along with usage from the new four, in a 12-strip-stripe (10
+2), after which further writes, if any, were now down to a 4-strip-
stripe (2+2), since the original eight were now fully chunk-allocated and 
the new four were the only devices with remaining unallocated space.

Another plausible guess is that the original eight devices were fully 
chunk-allocated before the addition of the four new devices, and that the 
free space that df was reporting was entirely in already allocated but 
not fully used data chunks.  In this case, you would have been perilously 
close to ENOSPC errors, when the existing metadata chunks got full, since 
all space was already allocated so no more metadata chunks could have 
been allocated, and if you didn't actually hit those errors, it was 
simply down to the lucky timing of adding the four new devices.

In either case, that df was and is reporting TiB of free space doesn't 
necessarily mean that there was unallocated space left, because df 
reports on potential space to write data, including both data-chunk-
allocated-but-not-yet-data-used-space, and unallocated-space.  Btrfs fi 
show is reporting for each device it's total space and allocated space, 
something totally different than df reports, so trying to directly 
compare the output from the two commands without knowing exactly what 
those numbers mean, is meaningless as they're reporting two entirely 
different things.

---
[1] Nominal chunk size:  Note the "nominal" qualifier.  While this is the 
normal chunk allocation size, on multi-TiB devices, the first few data 
chunk allocations in particular can be much larger, multiples of a GiB, 
while as unallocated space dwindles, both data and metadata chunks can be 
smaller in ordered to use up the last available unallocated space.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

