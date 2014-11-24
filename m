Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47295 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbaKXWVo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 17:21:44 -0500
Message-ID: <5473AF4F.2080408@fb.com>
Date: Mon, 24 Nov 2014 17:21:03 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <david@fromorbit.com>, <sandeen@redhat.com>,
        <clm@fb.com>, <dm-devel@redhat.com>, <hch@infradead.org>,
        <linux-fsdevel@vger.kernel.org>, <tytso@mit.edu>
Subject: Re: [RFC][PATCH] dm: add dm-power-fail target
References: <1416607231-8588-1-git-send-email-jbacik@fb.com> <20141124184534.GA24398@lenny.home.zabbo.net> <54738154.9010203@fb.com> <20141124195749.GA27597@lenny.home.zabbo.net> <547391DD.30406@fb.com> <20141124221015.GA32205@lenny.home.zabbo.net>
In-Reply-To: <20141124221015.GA32205@lenny.home.zabbo.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/24/2014 05:10 PM, Zach Brown wrote:
> On Mon, Nov 24, 2014 at 03:15:25PM -0500, Josef Bacik wrote:
>> On 11/24/2014 02:57 PM, Zach Brown wrote:
>>>>> This implements a writeback cache in kernel data structures so that you
>>>>> can race to throw away cached blocks that haven't been flushed.  How is
>>>>> that meaningfully different than using an actual writeback caching dm
>>>>> target and racing to invalidate it?
>>>>
>>>> I didn't think of the dm-cache target, but do we want to add data loss
>>>> testing code to something people actually use in production?  I feel like
>>>> that's a recipe for disaster.  I suppose it could work, but my target adds
>>>> some specific scenarios like blow up after FUA/FLUSH to test for specific
>>>> races.
>>>
>>> I don't know if we'd even need code changes.  Can't you forcibly fiddle
>>> with the target tables to remove the caching target at any point?  No
>>> hablo dm.
>>>
>>>>> Using real caching dm target configurations would let you reuse their
>>>>> testing and corner case handling that is, presumably, already slightly
>>>>> more advanced than printk() swearing.
>>>>>
>>>>
>>>> Well that's just an unfair jab, I missed _one_ debug printk.
>>>
>>> And it was a hilarious printk :).
>>>
>>>>> If we were to justify developing a specific power failure target, I'd
>>>>> like to see something that tracks write history and can replay the
>>>>> history to offer a resonably exhaustive set of possible write results.
>>>>> Verify *those* and you have much more confidence that the file system
>>>>> can handle reading the results of its interrupted writes.
>>>>
>>>> This sounds like a pretty cool idea, it would be weird trying to order
>>>> everything out though to catch problems where we don't properly wait on IO
>>>> to complete before we do flushing.  You'd probably have to keep track of
>>>> when things were submitted and when they completed in the log in order to
>>>> replay them in a way to expose problems with the flushing.  But you're right
>>>> it would allow us to more exhaustively test all different scenarios.
>>>
>>> Well, I think it'd be more about tracking write submission and flush
>>> completion to maintain sets of writes that could have become persistent
>>> in any order.  Then you provide an interface for iterating over devices
>>> that represent possible persistent outcomes.
>>>
>>> Say you have a tree of flush events and each flush has a tree of blocks
>>> that were dirty at the time of the flush.  After the flush you can walk
>>> the blocks and record their tree position (or maintain them with the
>>> _augmented callbacks.)
>>>
>>> Then each device full of possible outcomes can be described by the flush
>>> event and a giant bitmap with a few bits { .written, .corrupt } for each
>>> block version in the flush.  Satisfy reads of a block by walking back
>>> through the flushes.  Blocks in the current flush look up their tree
>>> position in the device state bitmap to find their fate.   The most
>>> recent dirty block in completed flushes is used, otherwise the backing
>>> device is used if you're building from an existing known state.
>>>
>>> Iterate over possible device states of write outcomes by adding bits
>>> with carry in the giant bitmap.  (complexity++ for using the bitmaps to
>>> represent which of multiple versions of one block should be used..)
>>>
>>> Something like that, anyway.  Email is easy :).
>>>
>>> It'd be interesting to see how far a simple prototype could go that
>>> keeps everything in memory and has sane static limits on how much
>>> history it tracks.
>>>
>>
>> That is way complicated, I was just going to take two devices, one that's a
>> linear mapping and the other that's the log, and then write to the log the
>> sector+data that was written in order that it completes, and then have
>> userspace do the replay.  So basically do the flush tracking like I am, then
>> write out chunks to the log device to keep a semblance of how the flushing
>> would have affected stuff, something like this
>>
>> write a, write b, a complete, flush, b complete, flush complete
>>
>> would log out
>>
>> wrote a, flush, write b, <other writes>, <next flush>
>>
>> and then we have a userspace thing that could do something like replay all
>> writes to a flush, do fs consistency and data consistency checks, walk to
>> the next flush, rinse repeat, and that way we could be sure that we always
>> have a consistent fs.
>
> I guess that'd be an ok start, but I don't think you need any clever
> kernel code to do that.  I've hacked up something like this in bash with
> blktrace, loopback files, and dd :/.

I don't think blktrace gives us the data being written though does it? 
If it does then hooray I'm done playing a device mapper developer.

>
> What I'm trying to say with this thread is that I think that only
> testing persistence in the order of submission or completion, and
> especially only around flushes, makes life too easy for the fs.  It
> doesn't reflect the real device state that users can be stuck with.  For
> example, I think we should test only b being written in that first
> sequence you describe.
>
> Maybe I'll throw something together to try and demonstrate what I'm on
> about.
>

Sure it's a really simple test, but what I currently have rigged up just 
does random writes+fsync and then uses the -EIO part of dm-power-fail. 
Then when my test gets an EIO it stops, saves the good file, unmounts 
and remounts the fs, and checks the good file against what is on the 
disk.  Nobody passes this test.  Btrfs, xfs and ext4 all fail at some 
point, takes an hour or two but eventually each one of them fall over. 
Now this could just be a bug in the test somewhere, but I'm pretty sure 
I've shaken all the bugs out.

With the logging approach then it is completely up to us how we replay 
the log, so we can always go back and do more horrible things with the 
replay, like replay for a while, skip a flush and write some of the next 
random crap and see what happens.  Doing horrible things is awesome and 
that is what I want, but I also want to make sure we're not failing in 
the simple things too.  Thanks,

Josef
