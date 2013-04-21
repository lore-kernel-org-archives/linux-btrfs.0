Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab3DUUC1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Apr 2013 16:02:27 -0400
Date: Sun, 21 Apr 2013 13:02:25 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] [RFC] btrfs: offline dedupe
Message-ID: <20130421200225.GO24720@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de> <5172B905.2050807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5172B905.2050807@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 20, 2013 at 05:49:25PM +0200, Gabriel de Perthuis wrote:
>> Hi,
>>
>> The following series of patches implements in btrfs an ioctl to do
>> offline deduplication of file extents.
>
> I am a fan of this patch, the API is just right.  I just have a few tweaks 
> to suggest to the argument checking.

Awesome, thanks for looking this over!


> At first the 1M limitation on the length was a bit inconvenient, but making 
> repeated calls in userspace is okay and allows for better error recovery 
> (for example, repeating the calls when only a portion of the ranges is 
> identical).  The destination file appears to be fragmented into 1M extents, 
> but these are contiguous so it's not really a problem.

Yeah I agree it's a bit inconvenient. To that end, I fixed things up so that
instead of erroring, we just limit the dedupe to 1M. If you want to see what
I'm talking about, the patch is at the top of my tree now:

https://github.com/markfasheh/btrfs-extent-same/commit/b39f93c2e78385ceea850b59edbd759120543a8b

This way userspace doesn't have to guess at what size is the max, and we can
change it in the future, etc.

Furthermore, I'm thinking it might even be better for us to just internally
loop on the entire range asked for. That won't necessarily fix the issue
where we fragment into 1M extents, but it would ease the interface even
more.

My only concern with looping over a large range would be the (almost)
unbounded nature of the operation... For example, if someone passes in a 4
Gig range and 100 files to do that on, we could be in the ioctl for some
time.

The middle ground would be to loop like I was talking about but limit the
maximum length (by just truncating the value, as above). The limit in this
case would obviously be much larger than 1 megabyte but not so large that we
can go off for an extreme amount of time. I'm thinking maybe 16 megabytes or
so to start?


> Requiring the offset or the length to align is spurious however; it doesn't 
> translate to any alignment in the extent tree (especially with 
> compression).  Requiring a minimum length of a few blocks or dropping the 
> alignment condition entirely would make more sense.

I'll take a look at this. Some of those checks are there for my own sanity
at the moment.

I really like that the start offset should align but there's no reason that
length can't be aligned to blocksize internally.

Are you sure that extents don't have to start at block boundaries? If that's
the case and we never have to change the start offset (to align it) then we
could drop the check entirely.


> I notice there is a restriction on cross-subvolume deduplication. Hopefully 
> it can be lifted like it was done in 3.6 for the clone ioctl.

Ok if it was removed from clone then this might be a spurious check on my
part. Most of the real extent work in btrfs-same is done by the code from
the clone ioctl.


> Deduplicating frozen subvolumes works fine, which is great for backups.
>
> Basic integration with bedup, my offline deduplication tool, is in an 
> experimental branch:
>
>   https://github.com/g2p/bedup/tree/wip/dedup-syscall
>
> Thanks to this, I look forward to shedding most of the caveats given in the 
> bedup readme and some unnecessary subtleties in the code.

Again, I'm really glad this is working out for you :)

I'll check out your bedup patch early this week. It will be instructive to
see how another engineer uses the ioctl.


>> I've made significant updates and changes from the original. In
>> particular the structure passed is more fleshed out, this series has a
>> high degree of code sharing between itself and the clone code, and the
>> locking has been updated.
>>
>> The ioctl accepts a struct:
>>
>> struct btrfs_ioctl_same_args {
>> 	__u64 logical_offset;	/* in - start of extent in source */
>> 	__u64 length;		/* in - length of extent */
>> 	__u16 total_files;	/* in - total elements in info array */
>
> Nit: total_files sounds like it would count the source file.
> dest_count would be better.
>
> By the way, extent-same might be better named range-same, since there is no 
> need for the input to fall on extent boundaries.

I actually don't like a lot of the naming. Much of it is historic from
Josef's early patch and the rest of the names I came up with earlier in
development while I was still feeling out the problem. I'm defnitely gonna
fix up total_files though - you're absolutely right that it's needlessly
confusing.


Thanks again for looking at this Gabriel. If you don't have any objections
I'll add you as CC to this series when I send new versions to the list from
now on.
	--Mark

--
Mark Fasheh
