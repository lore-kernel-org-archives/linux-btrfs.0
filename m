Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35231 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbaKXTFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 14:05:25 -0500
Message-ID: <54738154.9010203@fb.com>
Date: Mon, 24 Nov 2014 14:04:52 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <david@fromorbit.com>, <sandeen@redhat.com>,
        <clm@facebook.com>, <dm-devel@redhat.com>, <hch@infradead.org>,
        <linux-fsdevel@vger.kernel.org>, <tytso@mit.edu>
Subject: Re: [RFC][PATCH] dm: add dm-power-fail target
References: <1416607231-8588-1-git-send-email-jbacik@fb.com> <20141124184534.GA24398@lenny.home.zabbo.net>
In-Reply-To: <20141124184534.GA24398@lenny.home.zabbo.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/24/2014 01:45 PM, Zach Brown wrote:
> On Fri, Nov 21, 2014 at 05:00:31PM -0500, Josef Bacik wrote:
>> Hello,
>>
>> I'm hoping some FS guys can weigh in and verify my approach for testing power
>> fail conditions, and the DM guys to of course verify I didn't completely fail at
>> making a DM target.  All suggestions welcome, I want to have a nice robust tool
>> for testing power fail so we can be sure our fsync/commit code is all working
>> properly.  Thanks,
>
> *All* suggestions welcome?  OK, I'll put on my skeptic hat.
>
> This implements a writeback cache in kernel data structures so that you
> can race to throw away cached blocks that haven't been flushed.  How is
> that meaningfully different than using an actual writeback caching dm
> target and racing to invalidate it?

I didn't think of the dm-cache target, but do we want to add data loss 
testing code to something people actually use in production?  I feel 
like that's a recipe for disaster.  I suppose it could work, but my 
target adds some specific scenarios like blow up after FUA/FLUSH to test 
for specific races.

>
> Using real caching dm target configurations would let you reuse their
> testing and corner case handling that is, presumably, already slightly
> more advanced than printk() swearing.
>

Well that's just an unfair jab, I missed _one_ debug printk.

> Implementation of this specific mechanism aside, the architectural
> observation is that device ram disappearing during a power interruption
> is just one, and possibly the most forgiving, outcome.  Pulling the
> power out from under concurrnet cached writes can result in any
> combination of them being written, or not, or scrambled to the point of
> returning read errors.
>

So that's what this target tries to get around, we don't care about what 
happens to the data that is outstanding, we act like it never happened, 
because if we are going to rely on reading that data at all then we've 
already lost.  So simply acting like it disappeared is just as bad as it 
being garbage or returning an EIO (though returning an EIO would be 
pretty cool too and easily be added to the target).

> If we were to justify developing a specific power failure target, I'd
> like to see something that tracks write history and can replay the
> history to offer a resonably exhaustive set of possible write results.
> Verify *those* and you have much more confidence that the file system
> can handle reading the results of its interrupted writes.

This sounds like a pretty cool idea, it would be weird trying to order 
everything out though to catch problems where we don't properly wait on 
IO to complete before we do flushing.  You'd probably have to keep track 
of when things were submitted and when they completed in the log in 
order to replay them in a way to expose problems with the flushing.  But 
you're right it would allow us to more exhaustively test all different 
scenarios.  Thanks,

Josef

