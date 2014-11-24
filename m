Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2915 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbaKXUQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 15:16:15 -0500
Message-ID: <547391DD.30406@fb.com>
Date: Mon, 24 Nov 2014 15:15:25 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <david@fromorbit.com>, <sandeen@redhat.com>,
        <clm@fb.com>, <dm-devel@redhat.com>, <hch@infradead.org>,
        <linux-fsdevel@vger.kernel.org>, <tytso@mit.edu>
Subject: Re: [RFC][PATCH] dm: add dm-power-fail target
References: <1416607231-8588-1-git-send-email-jbacik@fb.com> <20141124184534.GA24398@lenny.home.zabbo.net> <54738154.9010203@fb.com> <20141124195749.GA27597@lenny.home.zabbo.net>
In-Reply-To: <20141124195749.GA27597@lenny.home.zabbo.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/24/2014 02:57 PM, Zach Brown wrote:
>>> This implements a writeback cache in kernel data structures so that you
>>> can race to throw away cached blocks that haven't been flushed.  How is
>>> that meaningfully different than using an actual writeback caching dm
>>> target and racing to invalidate it?
>>
>> I didn't think of the dm-cache target, but do we want to add data loss
>> testing code to something people actually use in production?  I feel like
>> that's a recipe for disaster.  I suppose it could work, but my target adds
>> some specific scenarios like blow up after FUA/FLUSH to test for specific
>> races.
>
> I don't know if we'd even need code changes.  Can't you forcibly fiddle
> with the target tables to remove the caching target at any point?  No
> hablo dm.
>
>>> Using real caching dm target configurations would let you reuse their
>>> testing and corner case handling that is, presumably, already slightly
>>> more advanced than printk() swearing.
>>>
>>
>> Well that's just an unfair jab, I missed _one_ debug printk.
>
> And it was a hilarious printk :).
>
>>> If we were to justify developing a specific power failure target, I'd
>>> like to see something that tracks write history and can replay the
>>> history to offer a resonably exhaustive set of possible write results.
>>> Verify *those* and you have much more confidence that the file system
>>> can handle reading the results of its interrupted writes.
>>
>> This sounds like a pretty cool idea, it would be weird trying to order
>> everything out though to catch problems where we don't properly wait on IO
>> to complete before we do flushing.  You'd probably have to keep track of
>> when things were submitted and when they completed in the log in order to
>> replay them in a way to expose problems with the flushing.  But you're right
>> it would allow us to more exhaustively test all different scenarios.
>
> Well, I think it'd be more about tracking write submission and flush
> completion to maintain sets of writes that could have become persistent
> in any order.  Then you provide an interface for iterating over devices
> that represent possible persistent outcomes.
>
> Say you have a tree of flush events and each flush has a tree of blocks
> that were dirty at the time of the flush.  After the flush you can walk
> the blocks and record their tree position (or maintain them with the
> _augmented callbacks.)
>
> Then each device full of possible outcomes can be described by the flush
> event and a giant bitmap with a few bits { .written, .corrupt } for each
> block version in the flush.  Satisfy reads of a block by walking back
> through the flushes.  Blocks in the current flush look up their tree
> position in the device state bitmap to find their fate.   The most
> recent dirty block in completed flushes is used, otherwise the backing
> device is used if you're building from an existing known state.
>
> Iterate over possible device states of write outcomes by adding bits
> with carry in the giant bitmap.  (complexity++ for using the bitmaps to
> represent which of multiple versions of one block should be used..)
>
> Something like that, anyway.  Email is easy :).
>
> It'd be interesting to see how far a simple prototype could go that
> keeps everything in memory and has sane static limits on how much
> history it tracks.
>

That is way complicated, I was just going to take two devices, one 
that's a linear mapping and the other that's the log, and then write to 
the log the sector+data that was written in order that it completes, and 
then have userspace do the replay.  So basically do the flush tracking 
like I am, then write out chunks to the log device to keep a semblance 
of how the flushing would have affected stuff, something like this

write a, write b, a complete, flush, b complete, flush complete

would log out

wrote a, flush, write b, <other writes>, <next flush>

and then we have a userspace thing that could do something like replay 
all writes to a flush, do fs consistency and data consistency checks, 
walk to the next flush, rinse repeat, and that way we could be sure that 
we always have a consistent fs.  This would make it easier to check 
complex fs operations (like btrfs's balance) without having to come up 
with special hacks in those operations to check them.  I like this 
better because it's less DM code which means less swearing printks, but 
whichever we think will be the best thing for this sort of testing.  Thanks,

Josef
