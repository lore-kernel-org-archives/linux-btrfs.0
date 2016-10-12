Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6707 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752026AbcJLFug (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 01:50:36 -0400
Subject: Re: RAID system with adaption to changed number of disks
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
 <20161012043718.GW21290@hungrycats.org>
CC: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
Date: Wed, 12 Oct 2016 13:48:58 +0800
MIME-Version: 1.0
In-Reply-To: <20161012043718.GW21290@hungrycats.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/12/2016 12:37 PM, Zygo Blaxell wrote:
> On Wed, Oct 12, 2016 at 09:32:17AM +0800, Qu Wenruo wrote:
>>> But consider the identical scenario with md or LVM raid5, or any
>>> conventional hardware raid5. A scrub check simply reports a mismatch.
>>> It's unknown whether data or parity is bad, so the bad data strip is
>>> propagated upward to user space without error. On a scrub repair, the
>>> data strip is assumed to be good, and good parity is overwritten with
>>> bad.
>>
>> Totally true.
>>
>> Original RAID5/6 design is only to handle missing device, not rotted bits.
>
> Missing device is the _only_ thing the current design handles.  i.e. you
> umount the filesystem cleanly, remove a disk, and mount it again degraded,
> and then the only thing you can safely do with the filesystem is delete
> or replace a device.  There is also a probability of being able to repair
> bitrot under some circumstances.
>
> If your disk failure looks any different from this, btrfs can't handle it.
> If a disk fails while the array is running and the filesystem is writing,
> the filesystem is likely to be severely damaged, possibly unrecoverably.
>
> A btrfs -dsingle -mdup array on a mdadm raid[56] device might have a
> snowball's chance in hell of surviving a disk failure on a live array
> with only data losses.  This would work if mdadm and btrfs successfully
> arrange to have each dup copy of metadata updated separately, and one
> of the copies survives the raid5 write hole.  I've never tested this
> configuration, and I'd test the heck out of it before considering
> using it.
>
>>> So while I agree in total that Btrfs raid56 isn't mature or tested
>>> enough to consider it production ready, I think that's because of the
>>> UNKNOWN causes for problems we've seen with raid56. Not the parity
>>> scrub bug which - yeah NOT good, not least of which is the data
>>> integrity guarantees Btrfs is purported to make are substantially
>>> negated by this bug. I think the bark is worse than the bite. It is
>>> not the bark we'd like Btrfs to have though, for sure.
>>>
>>
>> Current btrfs RAID5/6 scrub problem is, we don't take full usage of tree and
>> data checksum.
> [snip]
>
> This leads directly to a variety of problems with the diagnostic tools,
> e.g.  scrub reports errors randomly across devices, and cannot report the
> path of files containing corrupted blocks if it's the parity block that
> gets corrupted.

At least better than screwing up good stripes.

The tool is just used to let user know if there is any corrupted stripes 
like kernel scrub, but with better behavior, like won't reconstruct 
stripes ignoring checksum.


For human readable report, it's not that hard (compared the the complex 
csum and parity check) to implement and can be added later.
For parity report, there is no way to output any human readable result 
anyway.

>
> btrfs also doesn't avoid the raid5 write hole properly.  After a crash,
> a btrfs filesystem (like mdadm raid[56]) _must_ be scrubbed (resynced)
> to reconstruct any parity that was damaged by an incomplete data stripe
> update.
>  As long as all disks are working, the parity can be reconstructed
> from the data disks.  If a disk fails prior to the completion of the
> scrub, any data stripes that were written during previous crashes may
> be destroyed.  And all that assumes the scrub bugs are fixed first.

This is true.
I didn't take this into account.

But this is not a *single* problem, but 2 problems.
1) Power loss
2) Device crash

Before making things complex, why not focusing on single problem.

Not to mention the possibility is much smaller than single problem.

>
> If writes occur after a disk fails, they all temporarily corrupt small
> amounts of data in the filesystem.  btrfs cannot tolerate any metadata
> corruption (it relies on redundant metadata to self-repair), so when a
> write to metadata is interrupted, the filesystem is instantly doomed
> (damaged beyond the current tools' ability to repair and mount
> read-write).

That's why we used higher duplication level for metadata by default.
And considering metadata size, it's much acceptable to use RAID1 for 
metadata other than RADI5/6.

>
> Currently the upper layers of the filesystem assume that once data
> blocks are written to disk, they are stable.  This is not true in raid5/6
> because the parity and data blocks within each stripe cannot be updated
> atomically.

True, but if we ignore parity, we'd find that, RAID5 is just RAID0.

COW ensures (cowed) data and metadata are all safe and checksum will 
ensure they are OK, so even for RAID0, it's not a problem for case like 
power loss.

So we should follow csum first and then parity.

If we following this principle, RAID5 should be a raid0 with a little 
higher possibility to recover some cases, like missing one device.

So, I'd like to fix RAID5 scrub to make it at least better than RAID0, 
not worse than RAID0.


>  btrfs doesn't avoid writing new data in the same RAID stripe
> as old data (it provides a rmw function for raid56, which is simply a bug
> in a CoW filesystem), so previously committed data can be lost.  If the
> previously committed data is part of the metadata tree, the filesystem
> is doomed; for ordinary data blocks there are just a few dozen to a few
> thousand corrupted files for the admin to clean up after each crash.

In fact, the _concept_ to solve such RMW behavior is quite simple:

Make sector size equal to stripe length. (Or vice versa if you like)

Although the implementation will be more complex, people like Chandan 
are already working on sub page size sector size support.

I think the sector size larger than page size is already on the TODO 
list and when it's done, we can do real COW RAID5/6 then.

Thanks,
Qu

>
> It might be possible to hack up the allocator to pack writes into empty
> stripes to avoid the write hole, but every time I think about this it
> looks insanely hard to do (or insanely wasteful of space) for data
> stripes.
>


