Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:41815 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3DVI4x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 04:56:53 -0400
Received: by mail-we0-f176.google.com with SMTP id s10so1033947wey.7
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 01:56:51 -0700 (PDT)
Message-ID: <5174FB48.60904@gmail.com>
Date: Mon, 22 Apr 2013 10:56:40 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] [RFC] btrfs: offline dedupe
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de> <5172B905.2050807@gmail.com> <20130421200225.GO24720@wotan.suse.de>
In-Reply-To: <20130421200225.GO24720@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Sat, Apr 20, 2013 at 05:49:25PM +0200, Gabriel de Perthuis wrote:
>>> Hi,
>>>
>>> The following series of patches implements in btrfs an ioctl to do
>>> offline deduplication of file extents.
>>
>> I am a fan of this patch, the API is just right.  I just have a few tweaks
>> to suggest to the argument checking.
>
> Awesome, thanks for looking this over!
>
>> At first the 1M limitation on the length was a bit inconvenient, but making
>> repeated calls in userspace is okay and allows for better error recovery
>> (for example, repeating the calls when only a portion of the ranges is
>> identical).  The destination file appears to be fragmented into 1M extents,
>> but these are contiguous so it's not really a problem.
>
> Yeah I agree it's a bit inconvenient. To that end, I fixed things up so that
> instead of erroring, we just limit the dedupe to 1M. If you want to see what
> I'm talking about, the patch is at the top of my tree now:
>
> https://github.com/markfasheh/btrfs-extent-same/commit/b39f93c2e78385ceea850b59edbd759120543a8b
>
> This way userspace doesn't have to guess at what size is the max, and we can
> change it in the future, etc.
>
> Furthermore, I'm thinking it might even be better for us to just internally
> loop on the entire range asked for. That won't necessarily fix the issue
> where we fragment into 1M extents, but it would ease the interface even
> more.
>
> My only concern with looping over a large range would be the (almost)
> unbounded nature of the operation... For example, if someone passes in a 4
> Gig range and 100 files to do that on, we could be in the ioctl for some
> time.
>
> The middle ground would be to loop like I was talking about but limit the
> maximum length (by just truncating the value, as above). The limit in this
> case would obviously be much larger than 1 megabyte but not so large that we
> can go off for an extreme amount of time. I'm thinking maybe 16 megabytes or
> so to start?

A cursor-style API could work here: make the offset and length 
parameters in/out, exit early in case of error or after the read quota 
has been used up.

The caller can retry as long as the length is nonzero (and at least one 
block), and the syscall will return frequently enough that it won't 
block an unmount operation or concurrent access to the ranges.

>> Requiring the offset or the length to align is spurious however; it doesn't
>> translate to any alignment in the extent tree (especially with
>> compression).  Requiring a minimum length of a few blocks or dropping the
>> alignment condition entirely would make more sense.
>
> I'll take a look at this. Some of those checks are there for my own sanity
> at the moment.
>
> I really like that the start offset should align but there's no reason that
> length can't be aligned to blocksize internally.
>
> Are you sure that extents don't have to start at block boundaries? If that's
> the case and we never have to change the start offset (to align it) then we
> could drop the check entirely.

I've had a look, and btrfs fiemap only sets FIEMAP_EXTENT_NOT_ALIGNED 
for inline extents, so the alignment requirement makes sense.  The 
caller should do the alignment and decide if it wants to extend a bit 
and accept a not-same status or shrink a bit, so just keep it as is and 
maybe add explanatory comments.

>> I notice there is a restriction on cross-subvolume deduplication. Hopefully
>> it can be lifted like it was done in 3.6 for the clone ioctl.
>
> Ok if it was removed from clone then this might be a spurious check on my
> part. Most of the real extent work in btrfs-same is done by the code from
> the clone ioctl.

Good to have this code shared (compression support is another win). 
bedup will need feature parity to switch from one ioctl to the other.

>> Deduplicating frozen subvolumes works fine, which is great for backups.
>>
>> Basic integration with bedup, my offline deduplication tool, is in an
>> experimental branch:
>>
>>    https://github.com/g2p/bedup/tree/wip/dedup-syscall
>>
>> Thanks to this, I look forward to shedding most of the caveats given in the
>> bedup readme and some unnecessary subtleties in the code.
>
> Again, I'm really glad this is working out for you :)
>
> I'll check out your bedup patch early this week. It will be instructive to
> see how another engineer uses the ioctl.

See ranges_same and dedup_fileset.  The ImmutableFDs stuff can be 
removed and the fact that dedup can be partially successful over a range 
will ripple through.

>>> I've made significant updates and changes from the original. In
>>> particular the structure passed is more fleshed out, this series has a
>>> high degree of code sharing between itself and the clone code, and the
>>> locking has been updated.
>>>
>>> The ioctl accepts a struct:
>>>
>>> struct btrfs_ioctl_same_args {
>>> 	__u64 logical_offset;	/* in - start of extent in source */
>>> 	__u64 length;		/* in - length of extent */
>>> 	__u16 total_files;	/* in - total elements in info array */
>>
>> Nit: total_files sounds like it would count the source file.
>> dest_count would be better.
>>
>> By the way, extent-same might be better named range-same, since there is no
>> need for the input to fall on extent boundaries.
>
> I actually don't like a lot of the naming. Much of it is historic from
> Josef's early patch and the rest of the names I came up with earlier in
> development while I was still feeling out the problem. I'm defnitely gonna
> fix up total_files though - you're absolutely right that it's needlessly
> confusing.

> Thanks again for looking at this Gabriel. If you don't have any objections
> I'll add you as CC to this series when I send new versions to the list from
> now on.
> 	--Mark

Of course, thanks!
