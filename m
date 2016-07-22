Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35879 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbcGVRVK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jul 2016 13:21:10 -0400
Received: by mail-io0-f195.google.com with SMTP id y34so7794217ioi.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jul 2016 10:21:10 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: Make RAID stripesize configurable
To: Sanidhya Solanki <lkml.page@gmail.com>
References: <1469194929-27647-1-git-send-email-lkml.page@gmail.com>
 <f7de852d-86de-b438-e79f-c57666c7d0e4@gmail.com> <20160722120616.35f5ad2d@ad>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <770d8b86-1fea-ad9e-944b-1de140423ff7@gmail.com>
Date: Fri, 22 Jul 2016 13:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <20160722120616.35f5ad2d@ad>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-22 12:06, Sanidhya Solanki wrote:
> On Fri, 22 Jul 2016 10:58:59 -0400
> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>
>> On 2016-07-22 09:42, Sanidhya Solanki wrote:
>>> +*stripesize=<number>*;;
>>> +Specifies the new stripe size for a filesystem instance. Multiple BTrFS
>>> +filesystems mounted in parallel with varying stripe size are supported, the only
>>> +limitation being that the stripe size provided to balance in this option must
>>> +be a multiple of 512 bytes, and greater than 512 bytes, but not larger than
>>> +16 KiBytes. These limitations exist in the user's best interest. due to sizes too
>>> +large or too small leading to performance degradations on modern devices.
>>> +
>>> +It is recommended that the user try various sizes to find one that best suit the
>>> +performance requirements of the system. This option renders the RAID instance as
>>> +in-compatible with previous kernel versions, due to the basis for this operation
>>> +being implemented through FS metadata.
>>> +
>> I'm actually somewhat curious to see numbers for sizes larger than 16k.
>> In most cases, that probably will be either higher or lower than the
>> point at which performance starts suffering.  On an set of fast SSD's,
>> that's almost certainly lower than the turnover point (I can't give an
>> opinion on BTRFS, but for DM-RAID, the point at which performance starts
>> degrading significantly is actually 64k on the SSD's I use), while on a
>> set of traditional hard drives, it may be as low as 4k (yes, I have
>> actually seen systems where this is the case).  I think that we should
>> warn about sizes larger than 16k, not refuse to use them, especially
>> because the point of optimal performance will shift when we get proper
>> I/O parallelization.  Or, better yet, warn about changing this at all,
>> and assume that if the user continues they know what they're doing.
>
> I agree with you from a limited point of view. Your considerations are
> relevant for a more broad, but general, set of circumstances.
>
> My consideration is worst case scenario, particularly on SSDs, where,
> say, you pick 8KiB or 16 KiB, write out all your data, then delete a
> block, which will have to be read-erase-written on a multi-page level,
> usually 4KiB in size.
I don't know what SSD's you've been looking at, but the erase block size 
on all of the modern NAND MLC based SSD's I've seen is between 1 and 8 
megabytes, so it would lead to at most a single erase block being 
rewritten.  Even most of the NAND SLC based SSD's I've seen have at 
least a 64k erase block.  Overall, the only case this is reasonably 
going to lead to a multi-page rewrite is if the filesystem isn't 
properly aligned, which is not a likely situation for most people.
>
> On HDDs, this will make the problem of fragmenting even worse. On HDDs,
> I would only recommend setting stripe block size to the block level
> (usually 4KiB native, 512B emulated), but this just me focusing on the
> worst case scenario.
And yet, software RAID implementations do fine with larger stripe sizes. 
  On my home server, I'm using BTRFS in RAID1 mode on top of LVM managed 
DM-RAID0 volumes, and I actually have gone through testing every power 
of 2 stripe size in this configuration for the DM-RAID volumes from 1k 
up to 64k.  I get peak performance using a 16k stripe size, and the 
performance actually falls off faster at lower sizes than it does at 
higher ones (at least, within the range I checked).  I've seen similar 
results on all the server systems I manage for work as well, so it's not 
just consumer hard drives that behave like this.
>
> Maybe I will add these warnings in a follow-on patch, if others agree
> with these statements and concerns.
The other part of my issue with this which forgot to state is that two 
types of people are likely to use this feature:
1. Those who actually care about performance and are willing to test 
multiple configurations to find an optimal one.
2. Those who claim to care about performance, but either just twiddle 
things randomly or blindly follow advice from others without really 
knowing for certain what they're doing.
The only people settings like this actually help to a reasonable degree 
are in the first group.  Putting a upper limit on the stripe size caters 
to protecting the second group (who shouldn't be using this to begin 
with) at the expense of the first group.  This doesn't affect data 
safety (or at least, it shouldn't), it only impacts performance, the 
system is still usable even if this is set poorly, so the value of 
trying to make it resistant to stupid users is not all that great.

Additionally, unless you have numbers to back up 16k being the practical 
maximum on most devices, then it's really just an arbitrary number, 
which is something that should be avoided in management tools.
